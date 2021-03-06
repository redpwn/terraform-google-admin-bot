# redpwn/admin-bot

Deploy [redpwn/admin-bot](https://github.com/redpwn/admin-bot) to Google Cloud Run.

Example configuration: [`example/main.tf`](https://github.com/redpwn/admin-bot/blob/master/example/main.tf).

## Variables

Name|Default|Description
--|--|--
`image`|*(none)*|Docker image URI on [`gcr.io`](https://cloud.google.com/container-registry) or [`docker.pkg.dev`](https://cloud.google.com/artifact-registry) with [`redpwn/admin-bot` base](https://github.com/redpwn/admin-bot)
`prefix`|`admin-bot`|Prefix for all GCP resources created by the module
`recaptcha.site`|*(none)*|Google reCAPTCHA site key
`recaptcha.secret`|*(none)*|Google reCAPTCHA secret key
