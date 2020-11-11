NAMESPACE_NAME ?= mig-rollback-samples # hardcoded in manifests files
MANIFEST_FILE_NAME ?= mig-rollback-samples.yaml

deploy: build-manifest oc-cleanup oc-apply

build-manifest:
	cat manifests/*.yaml > ${MANIFEST_FILE_NAME}

oc-apply:
	oc apply -f ${MANIFEST_FILE_NAME}

oc-cleanup:
	oc delete namespace --ignore-not-found=true ${NAMESPACE_NAME}
