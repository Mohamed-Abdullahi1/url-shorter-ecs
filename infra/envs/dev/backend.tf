terraform {
  backend "s3" {
    bucket       = "url-tf-state-454374565233"
    key          = "infra/dev/terrafrom.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
