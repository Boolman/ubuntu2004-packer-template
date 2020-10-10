# ubuntu2004-packer-template



Populate environment variables and go



```
    "cluster": "{{env `VSPHERE_CLUSTER`}}",
    "datacenter": "{{env `VSPHERE_DATACENTER`}}",
    "datastore": "{{env `VSPHERE_DATASTORE`}}",
    "folder": "{{env `VSPHERE_FOLDER`}}",
    "iso_path": "{{env `VSPHERE_ISO_PATH`}}",
    "packer_bastion_host": "{{env `PACKER_BASTION_HOST`}}",
    "packer_bastion_key": "{{env `PACKER_BASTION_KEY`}}",
    "password": "{{env `VSPHERE_PASSWORD`}}",
    "template_name": "{{env `VSPHERE_TEMPLATE_NAME`}}",
    "template_network": "{{env `VSPHERE_NETWORK`}}",
    "vcenter_server": "{{env `VSPHERE_SERVER`}}",
    "vcenter_username": "{{env `VSPHERE_USERNAME`}}"
```
