if [ "X${GOOGLE_APPLICATION_CREDENTIALS}" != "X" ]; then
    gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}
fi

# Supported environments
setenv() {
    export ENV=$1
    ENV_UPPER=${ENV^^}
    export KUBECONFIG=$(printenv ${ENV_UPPER}_KUBECONFIG)
    export ANSIBLE_INVENTORY=$(printenv ${ENV_UPPER}_ANSIBLE_INVENTORY)
    export ETCDCTL_ENDPOINTS=$(printenv ${ENV_UPPER}_ETCDCTL_ENDPOINTS)
}

dev () {
  setenv "dev"
}

prod () {
  setenv "prod"
}

# Initialize
if [ "X${PROD_KUBECONFIG}" != "X" ]; then
  prod
fi
