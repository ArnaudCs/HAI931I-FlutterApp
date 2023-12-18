const http = require('http');

function getRandomValue(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

const server = http.createServer((req, res) => {
  // Route pour les capteurs (/sensors)
  if (req.url === '/sensors') {
    console.log('Requête sensors !');
    const currentTemp = getRandomValue(10, 40); // Exemple de plage pour la température
    const currentLum = getRandomValue(1000, 10000);  // Exemple de plage pour la luminosité
    const timeBeforeWater = getRandomValue(0, 100); // Exemple de plage pour le temps avant l'arrosage

    const data = {
      currentTemp: currentTemp,
      currentLum: currentLum,
      timeBeforeWater: timeBeforeWater
    };

    const jsonData = JSON.stringify(data);

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(jsonData);
  }
  // Si la route n'est pas /sensors, renvoyer une réponse 404
  else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found');
  }
});

const port = 3000; // Port sur lequel le serveur écoutera
server.listen(port, () => {
  console.log(`Serveur en cours d'exécution sur le port ${port}`);
});
