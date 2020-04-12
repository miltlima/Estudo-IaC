variable "amis" {
    type = "map"

    default = {
        "us-east-1" = "ami-04b9e92b5572fa0d1"
        "us-east-2" = "ami-0dacb0c129b49f529"
    }
}

variable "cidrs_vip" {
    type = "list"
    default = ["177.191.201.98/32"]
}

variable "key_name" {
    default = "labs-milton"
}
