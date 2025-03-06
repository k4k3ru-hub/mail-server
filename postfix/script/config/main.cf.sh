#!/bin/bash

#
# Set up main.cf with main.cf.tmpl
#
setup_main_cf() {
	# Set local variables.
	local mainCfTmplFilePath=${WORK_FILE_PATH}/config/main.cf.tmpl
	local postfixMainCfFilePath=${POSTFIX_FILE_PATH}/main.cf

	if [[ ! -f "${mainCfTmplFilePath}" ]]; then
		log "Skip creating main.cf from ${mainCfTmplFilePath}"
		return
	fi

	envsubst < ${mainCfTmplFilePath} > ${postfixMainCfFilePath}

	sed -i '/^#/d; /^$/d' ${postfixMainCfFilePath}

	log "Created ${postfixMainCfFilePath} from ${mainCfTmplFilePath}."
}
