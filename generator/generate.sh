#!/bin/bash

root_dir="$(dirname "$(realpath "${0}")")"

set -e

function _run(){
	docker run -e HOME=/srv -u $UID:$UID --rm -w /srv -v "${root_dir}":/srv python:3 "$@"
}

if [ ! -d "${root_dir}"/env ];
then
	_run python -m venv ./env --system-site-packages
	_run ./env/bin/pip install jinja2 glorpen-config pyyaml
fi
_run ./env/bin/python3 generate.py "$@"
