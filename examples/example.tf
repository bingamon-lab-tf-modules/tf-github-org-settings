terraform {
  required_version = ">= 1.9.0"
}

module "tf-github-org-settings" {
  source = "github.com/bingamon-lab-tf-modules/tf-github-org-settings?ref=v1.0.0"
  #version = "~> 1.0"

  # TFVars go here

}