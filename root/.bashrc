if [ "X${SERVICE_ACCOUNT_FILE}" != "X" ]; then
    gcloud auth activate-service-account --key-file=${SERVICE_ACCOUNT_FILE}
fi