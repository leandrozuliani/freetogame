const express = require('express');
const request = require('request');
const app = express();

const args = process.argv.slice(2);

const key = getValueByName('--key=');
const host = getValueByName('--host=');

function getValueByName(name) {
  let key = null;
  for (let arg of args) {
    if (arg.startsWith(name)) {
      key = arg.split('=')[1];
      return key;
    }
  }
}

// Middleware para permitir CORS nas chamadas da aplicação Flutter
app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", req.headers.origin);
  res.header("Access-Control-Allow-Headers", "*");
  res.header("access-control-allow-methods", "GET, POST");
  res.header("access-control-expose-headers", "*");
  res.header("Referrer-Policy", "no-referrer");
  next();
});

// Endpoint do resource /resource?url=$url
app.get('/resource', function (req, res) {
  const url = req.query.url;
  if (!url) {
    return res.status(400).send('URL resource é obrigatório');
  }
  req.query.headers = {
    'x-rapidapi-key': key,
    'x-rapidapi-host': host
  };

  request.get({ uri: url, headers: req.query.headers }).on('response', function (response) {

    console.log(`[Endpoint] Response: ${response.statusCode} ${JSON.stringify(req.originalUrl)}`);

    res.set('Content-Type', response.headers['content-type']);

    const data = [];
    response.on('data', (chunk) => {
      data.push(chunk);
    }).on('end', () => {
      res.send(Buffer.concat(data));
    });
  }).on('error', function (err) {
    console.error(err);
    res.status(500).send('Erro ao acessar /resource');
  });
});


const port = process.env.PORT || 3000;
app.listen(port, function (error) {
  if (error) {
    console.error(`Erro ao iniciar servidor na porta ${port}: ${error}`);
  } else {
    console.log(`Servidor iniciado na porta ${port}`);
  }
});
