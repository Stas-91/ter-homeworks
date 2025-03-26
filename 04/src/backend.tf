terraform {
  backend "s3" {
    bucket = "simple-bucket-iqz461d3"
    key    = "terraform.tfstate"
    region = "ru-central1"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    # access_key и secret_key будут взяты из AWS_ACCESS_KEY_ID и AWS_SECRET_ACCESS_KEY
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true # Отключаем запрос AWS account ID

    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g8ta6qu7na0ir2khnv/etnld6anrv93cf3cfqfe"
    dynamodb_table = "tfstate-lock-develop"
  }
}