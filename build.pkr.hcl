variable "cluster" {
  type    = string
  default = "${var.VSPHERE_CLUSTER}"
}

variable "datacenter" {
  type    = string
  default = "${var.VSPHERE_DATACENTER}"
}

variable "datastore" {
  type    = string
  default = "${var.VSPHERE_DATASTORE}"
}

variable "folder" {
  type    = string
  default = "${var.VSPHERE_FOLDER}"
}

variable "iso_path" {
  type    = string
  default = "${var.VSPHERE_ISO_PATH}"
}

variable "packer_bastion_host" {
  type    = string
  default = "${var.PACKER_BASTION_HOST}"
}

variable "packer_bastion_key" {
  type    = string
  default = "${var.PACKER_BASTION_KEY}"
}

variable "password" {
  type    = string
  default = "${var.VSPHERE_PASSWORD}"
}

variable "template_name" {
  type    = string
  default = "${var.VSPHERE_TEMPLATE_NAME}"
}

variable "template_network" {
  type    = string
  default = "${var.VSPHERE_NETWORK}"
}

variable "vcenter_server" {
  type    = string
  default = "${var.VSPHERE_SERVER}"
}

variable "vcenter_username" {
  type    = string
  default = "${var.VSPHERE_USERNAME}"
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "vsphere-iso" "vmware-builder" {
  CPUs                 = 4
  RAM                  = 4096
  RAM_reserve_all      = true
  boot_command         = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud", "<enter><wait>"]
  boot_order           = "disk,cdrom"
  boot_wait            = "5s"
  cluster              = "${var.cluster}"
  convert_to_template  = true
  datacenter           = "${var.datacenter}"
  datastore            = "${var.datastore}"
  disk_controller_type = "pvscsi"
  floppy_files         = ["./user-data", "./meta-data"]
  floppy_label         = "cidata"
  folder               = "${var.folder}"
  guest_os_type        = "ubuntu64Guest"
  insecure_connection  = true
  ip_settle_timeout    = "5s"
  ip_wait_timeout      = "15m"
  iso_paths            = "[${var.datastore}] ${var.iso_path}"
  network_adapters {
    network      = "${var.template_network}"
    network_card = "vmxnet3"
  }
  password               = "${var.password}"
  ssh_handshake_attempts = 20
  ssh_password           = "ubuntu"
  ssh_timeout            = "20m"
  ssh_username           = "ubuntu"
  storage {
    disk_size             = 40000
    disk_thin_provisioned = true
  }
  username       = "${var.vcenter_username}"
  vcenter_server = "${var.vcenter_server}"
  vm_name        = "${var.template_name}"
}

build {
  sources = ["source.vsphere-iso.vmware-builder"]

  provisioner "ansible" {
    extra_arguments = ["-b"]
    playbook_file   = "./playbooks/standard.yml"
    user            = "ubuntu"
  }
  provisioner "shell" {
    script = "./scripts/cleanup.sh"
    override = {
      vmware-builder = {
        execute_command = "sudo bash {{.Path}}"
      }
    }
  }
}
