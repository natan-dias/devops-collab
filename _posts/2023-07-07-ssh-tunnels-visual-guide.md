---
layout: post
title: SSH Tunnels - Local and Remote Port Forwarding (PT-BR)
subtitle: Um guia visual sobre Túneis SSH
#cover-img: /assets/img/post-img/k8s.png
thumbnail-img: /assets/img/post-img/ssh-tunnels-post/diagrama02.jpg
#share-img: /assets/img/path.jpg
tags: [devops, sysadmin, PT-BR posts]
gh-repo: natan-dias/devops-collab
gh-badge: [star, follow, watch]
---

SSH, um grande exemplo de uma tecnologia que já existe há bastante tempo, mas ainda é vastamente utilizada nos dias de hoje. Pode ser que ainda valha a pena aprender alguns truques de SSH do que se empenhar em aprender algumas dezenas de ferramentas Cloud Native que certamente vão ficar obsoletas no semestre seguinte.

Tecnologias como o SSH Tunnels é um bom exemplo. Com nada mais nada menos que algumas ferramentas básicas e eventualmente utilizando comandos simples, você pode executar e atinigir os seguintes objetivos:

- Acessar uma VPC interna através de uma instância EC2 pública;
- Abrir uma porta a partir do localhost de uma VM de desenvolvimento no navegador do host;
- Expor qualquer servidor local de uma rede privada para a internet.

Mas mesmo que você utilize SSH Tunnels diariamente, podem surgir algumas questões simples ao tentar entender qual é o comando correto. O comando deve executar um tunel remoto ou local? Quais são as Flags? Seria *local_port:remote_port* sempre ou tem outra forma de fazer? 

Para tentar entender melhor, o resultado do post é uma série de labs e guias visuais.

## Local Port Forwarding

Começando pelo que eu mais uso. Muitas vezes, pode haver um serviço escutando no host local ou em uma interface privada de uma máquina para a qual só posso fazer SSH por meio de seu IP público. E digamoes que eu preciso acessar esta porta de fora. Alguns exemplos típicos:

- Acessando um banco de dados (MySQL, Postgres, Redis, etc) usando uma UI do seu laptop.
- Usando seu navegador para acessar um aplicativo da Web exposto apenas a uma rede privada.
- Acessar a porta de um contêiner de seu laptop sem publicá-lo na interface pública do servidor.

Todos os casos de uso acima podem ser resolvidos com um único comando ssh:

```
ssh -L [local_addr:]local_port:remote_addr:remote_port [user@]sshd_addr
```

A flag -L indica que estamos iniciando um encaminhamento de porta local. O que realmente significa é:

- Na sua máquina o cliente SSH vai escutar na porta definida em *local_port*.
- Qualquer tráfego para esta porta vai ser encaminhado para a definição *remote_addr:remote_port* para a máquina que você estiver fazendo o SSH.

Veja no diagrama abaixo:

![diagrama01]( {{ "/assets/img/post-img/ssh-tunnels-post/diagrama01.jpg" | relative_url }} )

## Local Port Forwarding com um Bastion Host

Pode não ser óbvio a princípio, mas o comando ssh -L permite encaminhar uma porta local para uma porta remota em qualquer máquina, não apenas no próprio servidor SSH. Observe como *remote_addr* e *sshd_addr* podem ou não ter o mesmo valor:

```
ssh -L [local_addr:]local_port:remote_addr:remote_port [user@]sshd_addr
```

![diagrama02]( {{ "/assets/img/post-img/ssh-tunnels-post/diagrama02.jpg" | relative_url }} )

Costumo usar o truque acima para chamar endpoints acessíveis a partir do bastion host, mas não do meu laptop (por exemplo, usando uma instância do EC2 com interfaces públicas e privadas para conectar-se a um cluster OpenSearch implantado totalmente em uma VPC).

## Remote Port Forwarding

Outro cenário popular (mas bastante inverso) é quando você deseja expor momentaneamente um serviço local para o mundo exterior. Obviamente, para isso, você precisará de um ingress gateway público. Mas não tema! Qualquer servidor público com um daemon SSH pode ser usado como um gateway:

```
ssh -R [remote_addr:]remote_port:local_addr:local_port [user@]gateway_addr
```

O comando acima não parece mais complicado do que sua contraparte ssh -L. Mas há uma armadilha...

Por padrão, o túnel SSH acima permitirá usar apenas o host local do gateway como endereço remoto. Em outras palavras, sua porta local ficará acessível apenas de dentro do próprio servidor de gateway e muito provavelmente não é algo que você realmente precisa. Por exemplo, normalmente desejo usar o endereço público do gateway como endereço remoto para expor meus serviços locais à Internet pública. Para isso, o servidor SSH precisa ser configurado com a configuração *GatewayPorts yes*.

Exemplo:

- Expondo um serviço de desenvolvimento do seu laptop para a Internet pública para uma demonstração.

Assim fica o Remote Port Forwarding em um diagrama:

![diagrama03]( {{ "/assets/img/post-img/ssh-tunnels-post/diagrama03.jpg" | relative_url }} )

## Remote Port Forwarding de uma Network Privada

Assim como o encaminhamento de porta local, o encaminhamento de porta remota tem seu próprio modo bastion host. Mas, desta vez, a máquina com o cliente SSH (por exemplo, seu laptop de desenvolvimento) desempenha o papel de Bastion. Em particular, ele permite expor portas de uma rede doméstica (ou privada) à qual seu laptop tem acesso ao mundo externo por meio do gateway de entrada:

```
ssh -R [remote_addr:]remote_port:local_addr:local_port [user@]gateway_addr
```

Parece quase idêntico ao túnel SSH remoto simples, mas o par *local_addr:local_port* torna-se o endereço de um dispositivo na rede privada. Aqui está como isso pode ser representado em um diagrama:

![diagrama04]( {{ "/assets/img/post-img/ssh-tunnels-post/diagrama04.jpg" | relative_url }} )

Como normalmente uso meu laptop como um thin client e o desenvolvimento real ocorre em um servidor doméstico, confio em um encaminhamento de porta remoto quando preciso expor um serviço de desenvolvimento de um servidor doméstico à Internet pública e a única máquina com o acesso ao gateway é meu laptop.

## Resumindo

Depois de fazer todos esses diagramas, notei que:

- A palavra "local" pode significar a máquina cliente SSH ou um host upstream acessível a partir desta máquina.
- A palavra "remoto" pode significar a máquina do servidor SSH (sshd) de um host upstream acessível a partir dele.
- O encaminhamento de porta local (ssh -L) implica que é o cliente ssh que começa a ouvir em uma nova porta.
- O encaminhamento de porta remota (ssh -R) implica que é o servidor sshd que começa a escutar em uma porta extra.
- As flags são "ssh -L local:remote" e "ssh -R remote:local" e é sempre o lado esquerdo que abre uma nova porta.

Deixo abaixo o link original do autor e prometo trazer os labs no futuro. O link original possui alguns labs, mas eu quis fazer os meus próprios, então vou fazer isso num post separado.

[Ivan Velichko - A Visual Guide to SSH Tunnels: Local and Remote Port Forwarding](https://iximiuz.com/en/posts/ssh-tunnels/)


GITHUB: [devops-collab-projects](https://github.com/natan-dias/devops-collab-projects)
