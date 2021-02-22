variable "config_file" {
  type = string
  default = ""
}
locals { 
	timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
	config = merge(jsondecode(file("config.json")), 
			can(fileexists("${var.config_file}")) ? try(jsondecode(file("${var.config_file}")), {}) : {}
		)
}



source "qemu" "builder" {
  cpus                   = try(parseint("${local.config.cpus}", 10), "${local.config.cpus}")
  accelerator            = "${local.config.accelerator}"
  boot_command           = "${local.config.boot_command}"
  boot_wait              = "2s"
  disk_interface         = "${local.config.disk_interface}"
  disk_size              = "${local.config.disk_size}"
  floppy_files           = ["./user-data", "./meta-data"]
  floppy_label           = "cidata"
  format                 = "${local.config.format}"
  headless               = false
  iso_checksum           = "${local.config.iso_checksum}"
  iso_url                = "${local.config.iso_url}"
  memory                 = try(parseint("${local.config.memory}", 10), "${local.config.memory}")
  net_device             = "${local.config.net_device}"
  ssh_handshake_attempts = "200"
  ssh_password           = "ubuntu"
  ssh_timeout            = "20m"
  ssh_username           = "ubuntu"
  vm_name                = "${local.config.vm_name}"
}

build {
  sources = ["source.qemu.builder"]

  provisioner "ansible" {
    command         = "${local.config.scripts.run-ansible}"
    extra_arguments = ["-b"]
    playbook_file   = "${local.config.scripts.ansible-playbook}"
    user            = "ubuntu"
  }
  provisioner "shell" {
    script = "${local.config.scripts.cleanup}"
    execute_command = "sudo {{ .Path }}"
  }
}
