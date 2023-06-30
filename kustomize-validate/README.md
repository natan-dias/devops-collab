# Kustomize validation script

[README PORTUGUESE VERSION](./README_PT.md)

This script is just an easy way to check folders and to validate your kustomization setup.

## Requirements

+ Python
+ [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/)
+ [kubernetes-validate](https://github.com/willthames/kubernetes-validate)

## How to use

The script can be placed anywhere, but preferably in the folder at the same level as your service or stack. In this example, the service is named "webserver-example" and the overlay would be "test-web". If you want, just change the script's LOCAL variable.

Just run via CLI:

> ./k8s-validate.sh test-web


The API VERSION variable can be changed or can be obtained from the CURL command, using the api_version variable. For this, you will have to put the url of your kubernetes cluster to obtain this information directly from your cluster.

The script will generate the YAML files from your kustomize build, as the following pattern:

> service.env.yaml

This build file will be tested against the API_VERSION variable by the kustomize-validate module.

## Contribute

To add new features, report a bug or improvements, please create an Issue and a Pull Request. I just kindly ask you to follow this standards:

+ BUGS

Create a branch with the tag BUG:

> bug-YOUR-BRANCH

+ FEATURE AND IMPROVEMENTS

Create a branch with the tag FEATURE:

> feature-YOUR-BRANCH