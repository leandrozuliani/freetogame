# freetogame

Free-to-game é um aplicativo que permite ao usuário visualizar os jogos gratuitos disponíveis para jogar online. 
Este aplicativo é uma implementação livre que exibe jogos de vários gêneros e plataformas, incluindo jogos para PC e navegador. O usuário pode pesquisar por  `título`, `descrição` e `fabricante` (publisher) além de filtrar por `gêneros` e ordenar por `título` ou `data de lançamento`.

## Componentes
1. O aplicativo foi desenvolvido em Flutter e utiliza a API pública da Free-to-play para exibir os jogos e que requer uma chave-privada para utilização. A key utilizada nesse projeto é apenas ilustrativa e encontra-se desativada.

2. Para gerenciar os filtros de pesquisa, foi utilizado o pacote Provider.


## Restrições
1. Para carregar as imagens dos jogos há restriçãode Cross-origin, portanto foi utilizado um serviço público de proxy CORS da https://proxy.cors.sh/ e precisa se registrar para obter a `x-cors-api-key`. Isso ocorre devido a restrições na API da freetogame. Esse token tem validade de 24 horas. Existem outras opções no mercado.

## Como rodar
Para executar o projeto, siga os seguintes passos:

1. Clone o repositório;
2. Abra o projeto no Visual Studio Code ou em outro editor de sua preferência;
3. Abra um terminal e execute o comando flutter pub get para instalar todas as dependências;
4. No arquivo game_service.dart, insira sua chave de API da `X-RapidAPI-Key` no método getHeaders();
Também no arquivo game_service.dart, insira a key `x-cors-api-key` fornecida por [https://proxy.cors.sh/]

5. Execute no terminal `flutter pub get` e `flutter run -d Chrome` para iniciar o aplicativo no navegador ou `flutter run` para rodar no emulator pré-instalado.

## Observações técnicas

O aplicativo utiliza GridView para exibir a lista de jogos e carregamento das imagens é gerenciado pelo Flutter a medida que o usuário faz scroll, sendo assim não seria necessário um `scroll infinito` a menos que a paginação fosse gerenciada no backend.

As imagens são baixadas gradualmente conforme o usuário faz scroll e automaticamente elas ficam em cache no dispositivo.

Foi utilizado o gerenciador de estados `Provider` para armazenar a lista e o resultado do filtro de pesquisa.
