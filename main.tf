data "google_project" "project" {}
data "google_client_config" "current" {}

resource google_pubsub_topic topic {
  name = var.prefix
}

resource google_cloud_run_service submit {
  name = "${var.prefix}-submit"
  location = data.google_client_config.current.region

  template {
    spec {
      containers {
        image = var.image
        resources {
          limits = {
            memory = "128Mi"
            cpu = "1"
          }
        }
        env {
          name = "APP_SERVICE"
          value = "submit"
        }
        env {
          name = "APP_PUBSUB_TOPIC"
          value = google_pubsub_topic.topic.name
        }
        env {
          name = "APP_RECAPTCHA_SITE"
          value = var.recaptcha.site
        }
        env {
          name = "APP_RECAPTCHA_SECRET"
          value = var.recaptcha.secret
        }
      }
      container_concurrency = 100
      timeout_seconds = 10
      service_account_name = google_service_account.submit.account_id
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }
}

resource google_cloud_run_service_iam_binding submit {
  service = google_cloud_run_service.submit.name
  location = google_cloud_run_service.submit.location
  role = "roles/run.invoker"
  members = [
    "allUsers",
  ]
}

resource google_service_account submit {
  account_id = "${var.prefix}-submit"
}

resource google_pubsub_topic_iam_binding submit {
  topic = google_pubsub_topic.topic.name
  role = "roles/pubsub.publisher"
  members = [
    "serviceAccount:${google_service_account.submit.email}",
  ]
}

resource google_cloud_run_service visit {
  name = "${var.prefix}-visit"
  location = data.google_client_config.current.region

  template {
    spec {
      containers {
        image = var.image
        resources {
          limits = {
            memory = "1Gi"
            cpu = "1"
          }
        }
        env {
          name = "APP_SERVICE"
          value = "visit"
        }
      }
      container_concurrency = 5
      timeout_seconds = 70
      service_account_name = google_service_account.visit.account_id
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }
}

resource google_service_account visit {
  account_id = "${var.prefix}-visit"
}

resource google_service_account invoke {
  account_id = "${var.prefix}-invoke"
}

resource google_service_account_iam_binding invoke {
  service_account_id = google_service_account.invoke.id
  role = "roles/iam.serviceAccountTokenCreator"
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com",
  ]
}

resource google_cloud_run_service_iam_binding invoke {
  service = google_cloud_run_service.visit.name
  location = google_cloud_run_service.visit.location
  role = "roles/run.invoker"
  members = [
    "serviceAccount:${google_service_account.invoke.email}"
  ]
}

resource google_pubsub_subscription visit {
  name = "${google_pubsub_topic.topic.name}-visit"
  topic = google_pubsub_topic.topic.name
  message_retention_duration = "3600s"
  ack_deadline_seconds = 80
  push_config {
    push_endpoint = google_cloud_run_service.visit.status[0].url
    oidc_token {
      service_account_email = google_service_account.invoke.email
    }
  }
  expiration_policy {
    ttl = ""
  }
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "300s"
  }
}
