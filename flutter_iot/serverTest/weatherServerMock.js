const http = require('http');

const server = http.createServer((req, res) => {
  // Route pour la luminosité (/brightness)
  if (req.url === '/brightness') {
    console.log('Requête brightness !');
    const luminosity = 75.5; // Exemple de luminosité
    const data = {
      luminosity: luminosity
    };
    const jsonData = JSON.stringify(data);

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(jsonData);
  }
  // Route pour l'humidité (/humidity)
  else if (req.url === '/humidity') {
    const humidity = 60.2; // Exemple d'humidité
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