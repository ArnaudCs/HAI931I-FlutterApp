const http = require('http');

function getRandomValue(min, max) {
  return Math.random() * (max - min) + min;
}

const server = http.createServer((req, res) => {
  // Route pour la luminosité (/brightness)
  if (req.url === '/brightness') {
    console.log('Requête brightness !');
    const luminosity = getRandomValue(30, 90);
    const data = {
      luminosity: luminosity
    };
    const jsonData = JSON.stringify(data);

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(jsonData);
  }
  // Route pour l'humidité (/humidity)
  else if (req.url === '/humidity') {
    const humidity = getRandomValue(40, 80);
    console.log('Requête humidity !');
    const data = {
      humidity: humidity
    };
    const jsonData = JSON.stringify(data);

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(jsonData);
  }
  // Si la route n'est ni /brightness ni /humidity, renvoyer une réponse 404
  else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found');
  }
});

const port = 3000; // Port sur lequel le serveur écoutera
server.listen(port, () => {
  console.log(`Serveur en cours d'exécution sur le port ${port}`);
});