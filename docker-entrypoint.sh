#!/bin/sh
set -e

if [ -n "${1}" ]; then
  exec "${*}"
fi

DEFAULT_ARGS="--http-port 8081 --dir=${TELEGRAM_WORK_DIR} --temp-dir=${TELEGRAM_TEMP_DIR}"
CUSTOM_ARGS=""

if [ -n "$TELEGRAM_LOG_FILE" ]; then
  CUSTOM_ARGS="--log=${TELEGRAM_LOG_FILE}"
fi
if [ -n "$TELEGRAM_STAT" ]; then
  CUSTOM_ARGS="${CUSTOM_ARGS} --http-stat-port=8082"
fi
if [ -n "$TELEGRAM_FILTER" ]; then
  CUSTOM_ARGS="${CUSTOM_ARGS} --filter=$TELEGRAM_FILTER"
fi
if [ -n "$TELEGRAM_MAX_WEBHOOK_CONNECTIONS" ]; then
  CUSTOM_ARGS="${CUSTOM_ARGS} --max-webhook-connections=$TELEGRAM_MAX_WEBHOOK_CONNECTIONS"
fi
if [ -n "$TELEGRAM_VERBOSITY" ]; then
  CUSTOM_ARGS="${CUSTOM_ARGS} --verbosity=$TELEGRAM_VERBOSITY"
fi
if [ -n "$TELEGRAM_MAX_CONNECTIONS" ]; then
  CUSTOM_ARGS="${CUSTOM_ARGS} --max-connections=$TELEGRAM_MAX_CONNECTIONS"
fi
if [ -n "$TELEGRAM_PROXY" ]; then
  CUSTOM_ARGS="${CUSTOM_ARGS} --proxy=$TELEGRAM_PROXY"
fi
if [ -n "$TELEGRAM_LOCAL" ]; then
  CUSTOM_ARGS="${CUSTOM_ARGS} --local"
fi

if [ -n "$TELEGRAM_USERNAME" ]; then
  CUSTOM_ARGS="${CUSTOM_ARGS} --username=${TELEGRAM_USERNAME} --groupname=${TELEGRAM_GROUPNAME}"
  getent group ${TELEGRAM_GROUPNAME} || addgroup -g ${TELEGRAM_GROUPNAME_ID} -S ${TELEGRAM_GROUPNAME}
  getent passwd ${TELEGRAM_USERNAME} || adduser -S -D -H -u ${TELEGRAM_USERNAME_ID} -h ${TELEGRAM_WORK_DIR} -s /sbin/nologin -G ${TELEGRAM_GROUPNAME} -g ${TELEGRAM_GROUPNAME} ${TELEGRAM_USERNAME}
  chown -R ${TELEGRAM_USERNAME}:${TELEGRAM_GROUPNAME} "${TELEGRAM_WORK_DIR}"
  chown -R ${TELEGRAM_USERNAME}:${TELEGRAM_GROUPNAME} "${TELEGRAM_TEMP_DIR}"
fi

COMMAND="telegram-bot-api ${DEFAULT_ARGS}${CUSTOM_ARGS}"

echo "$COMMAND"
# shellcheck disable=SC2086
exec $COMMAND
