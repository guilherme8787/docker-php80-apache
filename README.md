## Docker com PHP 8 e Apache 2

Docker com PHP 8 e Apache 2, acompanha mods

_Requisitos_

**Docker 2.3 ou superior**

- Documentação para instalação de outros _mods_ no PHP via Dockerfile [Documentação docker-php-extension](https://github.com/mlocati/docker-php-extension-installer)
- Para instalar mods no Apache procurar baixar a adicionar via `a2enmod`

Uso

```
    git clone https://github.com/guilherme8787/docker-php80-apache.git
```

```
    cd docker-php80-apache
```

```
    docker-compose up -d --build
```

- Acessar via navegador através da porta 8888 http://localhost:8888
- Caso você mude a porta do docker lembrar de alterar o ports.conf
- Configurar o mod_evasive de acordo com o desejo
- Já possui configurações pra SSL e mod instalado, as linhas estão no docker-compose.yml
