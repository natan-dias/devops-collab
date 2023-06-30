# Kustomize validation script

[README ENGLISH VERSION](./README.md)

Este script é apenas uma forma mais fácil de verificar múltiplas pastas e validar se as configurações do seu kustomization estão corretas. 

## Requerimentos

+ Python
+ [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/)
+ [kubernetes-validate](https://github.com/willthames/kubernetes-validate)

## Como utilizar

O script pode ser colocado em qualquer lugar, mas preferencialmente na pasta no mesmo nível do seu serviço ou stack. Neste exemplo, o serviço tem o nome de "webserver-example" e o overlay seria o "test-web". Caso queira, basta alterar a variável LOCAL do script. 

Para rodar o script, basta utilizar via linha de comando:

> ./k8s-validate.sh test-web

A API VERSION pode ser alterada ou pode ser obtida a partir do comando CURL, utilizando a variável api_version. Para isto, você terá que colocar a url do seu cluster kubernetes para obter esta informação diretamente do seu cluster.

O script vai gerar arquivos YAML provenientes do seu kustomize build, seguindo o padrão:

> service.env.yaml

Este arquivo gerado pelo kustomize build vai ser testado pelo módulo kustomize-validate utilizando a variável API_VERSION que você selecionar (ou aquela obtida pelo seu cluster).

## Contribua

Caso queira adicionar uma nova feature, encontre algum bug ou tenha alguma sugestão de melhoria, favor abrir uma Issue e criar um Pull Request com as modificações. Peço a gentilza de seguir o seguinte padrão:

+ BUGS

Criar um branch com a tag bug:

> bug-SEU-BRANCH

+ FEATURE e Melhorias

Criar um branch com a tag feature:

> feature-SEU-BRANCH