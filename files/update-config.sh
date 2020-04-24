#!/bin/bash
set -e

if [ -z "${3}" ]
then
	echo "Usage: update-config.sh <file> <key> <environment>" >&2
	exit 1
fi

file="${1}"
key="${2}"
environment="${3}"

function get_old_value()
{
	file="${1}"
	key="${2}"
	
	if [ -f "${file}" ]
	then
		grep -Ee "^[[:space:]]*${key}[[:space:]]*=" "${file}" |\
			cut -d'=' -f'2' |\
			sed -e "s/^[\"\']*//" -e "s/[\"\']*$//"
	else
		echo ""
	fi
}

old_key="$(get_old_value "${file}" 'activationKey')"
old_env="$(get_old_value "${file}" 'environment')"

if [ "${key}" != "${old_key}" -o "${environment}" != "${old_env}" ]
then
	stackify-agent-config --key "${key}" --environment "${environment}" >>'/dev/null'
	echo 'CHANGED'
fi
