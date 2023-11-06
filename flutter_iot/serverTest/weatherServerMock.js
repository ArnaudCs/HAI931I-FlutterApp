const http = require('http');

const server = http.createServer((req, res) => {
  // Si la requête est de type GET et vers la route '/data'
  if (req.method === 'GET' && req.url === '/data') {
    // Créez un objet JSON avec les données souhaitées
    const responseData = {
      coord: {
        lon: 10.99,
        lat: 44.34
      },
      weather: [
        {
          id: 501,
          main: "Rain",
          description: "moderate rain",
          icon: "10d"
        }
      ],
      base: "stations",
      main: {
        temp: 12,
        feels_like: 298.74,
        temp_min: 297.56,
        temp_max: 300.05,
        pressure: 1015,
        humidity: 64,
        sea_level: 1015,
        grnd_level: 933
      },
      visibility: 10000,
      wind: {
        speed: 0.62,
        deg: 349,
        gust: 1.18
      },
      rain: {
        "1h": 3.16
      },
      clouds: {
        all: 100
      },
      dt: 1661870592,
      sys: {
        type: 2,
        id: 2075663,
        country: "IT",
        sunrise: 1661834187,
        sunset: 1661882248
      },
      timezone: 7200,
      id: 3163858,
      name: "Montpellier",
      cod: 200
    };

    // Envoie la réponse sous forme de JSON
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(responseData));
  } else {
    // Si la route n'est pas '/data', renvoyer une réponse 404
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found');
  }
});

const port = 3000; // Port sur lequel le serveur écoutera
server.listen(port, () => {
  console.log(`Serveur en cours d'exécution sur le port ${port}`);
});