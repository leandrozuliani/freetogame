[![Dart CI](https://github.com/leandrozuliani/freetogame/actions/workflows/dart.yml/badge.svg)](https://github.com/leandrozuliani/freetogame/actions/workflows/dart.yml)

# freetogame

Free-to-game é uma API que permite ao usuário visualizar os jogos gratuitos disponíveis para jogar online. 
Este aplicativo é uma implementação que exibe jogos de vários gêneros e plataformas, incluindo jogos para PC e navegador. O usuário pode pesquisar por  `título`, `descrição` e `fabricante` (publisher) além de filtrar por `gêneros` e ordenar por `título` ou `data de lançamento`.

## Componentes
1. O aplicativo foi desenvolvido em Flutter e utiliza a API pública da Free-to-play para exibir os jogos e que requer uma chave-privada para utilização, que deve ser informada como instruído abaixo.

## Restrições
Para subir esse projeto em ambiente local é necessário um servidor Node Express local para fazer um proxy com as imagens e JSON da API free-to-game que possui restrições de CORS.

Para isso é necessário rodar na raiz do projeto :
1. `npm install request express` - dependencias para o servidor node usando os pacotes express e request.
2. `node server/server.js --key=<API-KEY> --host=<API-HOST>` - aplicação vai ouvir as requisições do Flutter em http://localhost:3000/ 

Obs: Para obter a sua chave, faça o cadastro em https://www.freetogame.com/api-doc

## Como rodar
Para executar o projeto, siga os seguintes passos:

1. Abra o projeto no Visual Studio Code ou em outro editor de sua preferência;
2. Em um terminal separado execute `npm install express request`  
     E em seguida suba o servidor utilizando `node server/server.js --key=<API-KEY> --host=<API-HOST>`.
3. Em outro terminal, execute o comando `flutter pub get` para instalar todas as dependências do Flutter.
4. Finalmente, execute no terminal  `flutter run -d Chrome` ou apenas `flutter run` para iniciar o aplicativo emulator pré-instalado pelo Android Studio ou rodar diretamente no Chrome.

Obs: Neste projeto foram utilizadas as seguintes versões:
* Dart SDK version: 2.19.2
* Flutter 3.7.5
* Node v18+ - (opcional) para o servidor local

## Observações técnicas

O aplicativo utiliza GridView para exibir a lista de jogos e carregamento das imagens é gerenciado pelo Flutter a medida que o usuário faz scroll, sendo assim não seria necessário um `scroll infinito` a menos que a paginação fosse gerenciada no backend.

As imagens são baixadas gradualmente conforme o usuário faz scroll e automaticamente elas ficam em cache no dispositivo.

Foi utilizado o gerenciador de estados `Provider` para armazenar a lista e o resultado do filtro de pesquisa.
