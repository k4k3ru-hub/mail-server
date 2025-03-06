#!/bin/bash

#
# Set up master.cf with master.cf.tmpl
#
setup_master_cf() {
	# 
	local masterCfTmplFilePath=${WORK_FILE_PATH}/config/master.cf.tmpl
	local postfixMasterCfFilePath=${POSTFIX_FILE_PATH}/master.cf

	if [[ ! -f "${masterCfTmplFilePath}" ]]; then
		log "Skip creating master.cf from ${masterCfTmplFilePath}"
		return
	fi

	# Remove space
	SMTPD_RELAY_RESTRICTIONS=$(echo "$SMTPD_RELAY_RESTRICTIONS" | sed 's/ //g')
	SMTPD_RECIPIENT_RESTRICTIONS=$(echo "$SMTPD_RECIPIENT_RESTRICTIONS" | sed 's/ //g')

	envsubst < ${masterCfTmplFilePath} > ${postfixMasterCfFilePath}

	sed -i '/^#/d; /^$/d' ${postfixMasterCfFilePath}

	log "Created ${postfixMasterCfFilePath} from ${masterCfTmplFilePath}."
}
