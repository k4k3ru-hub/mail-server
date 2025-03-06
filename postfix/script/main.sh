#!/bin/bash
set -e

#
# Constants
#
readonly SCRIPT_CONFIG_MAIN_CF_FILE_PATH=/app/script/config/main.cf.sh
readonly SCRIPT_CONFIG_MASTER_CF_FILE_PATH=/app/script/config/master.cf.sh

readonly POSTFIX_FILE_PATH=/etc/postfix
readonly POSTFIX_MAIN_CF_FILE_PATH=${POSTFIX_FILE_PATH}/main.cf
readonly WORK_FILE_PATH=/app
readonly CONFIG_FILE_PATH=${WORK_FILE_PATH}/config
readonly MAIN_CF_TMPL_FILE_PATH=${CONFIG_FILE_PATH}/main.cf.tmpl


log() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $@"
}


#
# Export environment variables.
#
export_env() {
	export ALIAS_MAPS="${ALIAS_MAPS:-lmdb:/etc/postfix/aliases}"
	export INET_INTERFACES="${INET_INTERFACES:-all}"
	export INET_PROTOCOLS="${INET_PROTOCOLS:-all}"
	if [[ -z ${LOCAL_RECIPIENT_MAPS+x} ]]; then
		export LOCAL_RECIPIENT_MAPS="${LOCAL_RECIPIENT_MAPS:-proxy:unix:passwd.byname \$alias_maps}"
	fi
	export LOCAL_TRANSPORT="${LOCAL_TRANSPORT:-local}"
	export MAILLOG_FILE="${MAILLOG_FILE:-}"
    export MAIL_OWNER="${MAIL_OWNER:-postfix}"
    export MYDESTINATION="${MYDESTINATION:-\$myhostname, \$mydomain}"
    export MYDOMAIN="${MYDOMAIN:-localhost}"
    export MYHOSTNAME="${MYHOSTNAME:-mail.localhost}"
    export MYNETWORKS_STYLE="${MYNETWORKS_STYLE:-host}"
    export MYNETWORKS="${MYNETWORKS:-127.0.0.0/8 [::1]/128}"
    export MYORIGIN="${MYORIGIN:-\$myhostname}"
    export NOTIFY_CLASSES="${NOTIFY_CLASSES:-resource, software}"
    export PROXY_INTERFACES="${PROXY_INTERFACES:-}"
    export RELAY_DOMAINS="${RELAY_DOMAINS:-}"
    export RELAY_RECIPIENT_MAPS="${RELAY_RECIPIENT_MAPS:-}"
    export RELAYHOST="${RELAYHOST:-}"
	export SMTP_TLS_SECURITY_LEVEL="${SMTP_TLS_SECURITY_LEVEL:-}"
	export SMTP_TLS_CERT_FILE="${SMTP_TLS_CERT_FILE:-}"
	export SMTP_TLS_KEY_FILE="${SMTP_TLS_KEY_FILE:-}"
    export SMTPD_RECIPIENT_RESTRICTIONS="${SMTPD_RECIPIENT_RESTRICTIONS:-permit_mynetworks}"
	export SMTPD_RELAY_RESTRICTIONS="${SMTPD_RELAY_RESTRICTIONS:-permit_mynetworks, permit_sasl_authenticated, defer_unauth_destination}"
    export SMTPD_SASL_AUTH_ENABLE="${SMTPD_SASL_AUTH_ENABLE:-no}"
    export SMTPD_SASL_PATH="${SMTPD_SASL_PATH:-smtpd}"
    export SMTPD_SASL_SECURITY_OPTIONS="${SMTPD_SASL_SECURITY_OPTIONS:-noanonymous}"
    export SMTPD_SASL_TYPE="${SMTPD_SASL_TYPE:-cyrus}"
    export SMTPD_TLS_AUTH_ONLY="${SMTPD_TLS_AUTH_ONLY:-no}"
    export SMTPD_TLS_CERT_FILE="${SMTPD_TLS_CERT_FILE:-}"
    export SMTPD_TLS_CHAIN_FILES="${SMTPD_TLS_CHAIN_FILES:-}"
    export SMTPD_TLS_KEY_FILE="${SMTPD_TLS_KEY_FILE:-\$smtpd_tls_cert_file}"
    export SMTPD_TLS_SECURITY_LEVEL="${SMTPD_TLS_SECURITY_LEVEL:-}"
    export SOFT_BOUNCE="${SOFT_BOUNCE:-no}"
}


#
# Run main process.
#
log "Starting script..."

# Export environment variables.
export_env

# Set up main.cf
. ${SCRIPT_CONFIG_MAIN_CF_FILE_PATH}
setup_main_cf

# Set up master.cf
. ${SCRIPT_CONFIG_MASTER_CF_FILE_PATH}
setup_master_cf

newaliases
exec postfix start-fg

log "Script execution completed!"
