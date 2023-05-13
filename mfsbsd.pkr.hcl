variable "github_user" {
  type        = string
  description = "Github user name to obtain SSH keys from"
}

variable "permit_root_login" {
  type        = string
  description = "OpenSSH PermitRootLogin option value"
  default     = "without-password"
}

source "qemu" "mfsbsd" {
  iso_url          = "https://mfsbsd.vx.sk/files/iso/13/amd64/mfsbsd-13.1-RELEASE-amd64.iso"
  iso_checksum     = "sha256:3f4fc2147ba02b40812f57cbd1c0903243524d4b9bf828761784e309f9a3c63c"
  output_directory = "out"
  shutdown_command = "poweroff"
  disk_size        = "150M"
  memory           = 4096
  format           = "qcow2"
  ssh_username     = "root"
  ssh_password     = "mfsroot"
  ssh_timeout      = "20m"
  vm_name          = "mfsbsd"
  net_device       = "virtio-net"
  disk_interface   = "virtio"
  boot_wait        = "10s"
  headless         = true
  http_directory   = "sources"
}


build {
  sources = ["source.qemu.mfsbsd"]

  provisioner "shell-local" {
    script = "./get_sources.sh"
  }

  provisioner "file" {
    source      = "./sources"
    destination = "/sources"
  }

  provisioner "shell" {
    script         = "./mkimg.sh"
    env_var_format = "setenv %s '%s'; "
    environment_vars = [
      "GITHUB_USER=${var.github_user}",
    ]
  }
}
