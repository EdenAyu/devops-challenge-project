variable "aws_region" {
  description = "This variable represents the AWS region where all of the resources Terraform provisions will live, we normally default this to us-west-2 as it is cheaper than us-west-1"
  default     = "us-west-2"
}

variable "public_key" {
  description = "public key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHWzomiNVuLeSMVQ6b1R5mg5qLRNSMfxYUSUsic6eSCAPLnaiNWT1oVupRCy5uS5U9knlUrK0Ff7hS4IhmI3ZGJ1ZaYfCNDpe4QMRoqEqQV7uqyyXsBAxzVVlRe6pnQTBvvZG7+jq33SA3lFhfjfsQjoT2EeXgXX9YTsHHdgy6JyfZx+SR6qX+0IShkUTVvEADcqctYo0Y8QKh9ZrjZKgu8tlYCR+FbZqEDcA33Cd4XDNNiRHW3ZnjgelmnemzaflEORPG1pdiD6LMMYkMgwzTL8F4dc8iccStPFEPTKL9t2DUJDzaoswyur0CoXrc/MzDtCm8MbNraYwTKBCYFIlIQK1nF/56gS6rxmdL/Kqv5cbGBYoSNRJur5KzPd0SWbRFhBDGlyXNtJQnSKDZBinp6G4dOsPNZ+5cNHwihP0l15+ms4giVCTlZHNwusNKU8y+ZV8hBlZxk008FdpXSu2Dy0/SFy1obaFtsuOBU6Yg9vsIob+JxcDJ8fe8ByOTYu8= edeng@DESKTOP-ND9EHP0"
}
