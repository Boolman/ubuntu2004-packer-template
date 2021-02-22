#!/usr/bin/env bash
find . -maxdepth 1 -name 'requirements.yaml' -exec ansible-galaxy role install -r  {} \;
find . -maxdepth 1 -name 'collections.yaml' -exec ansible-galaxy collection install -r  {} \;
ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 /home/eoh/.ansible/_build/pip_packages/bin/ansible-playbook "$@"
