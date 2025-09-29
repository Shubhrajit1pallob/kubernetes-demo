import express from 'express';

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello, from a container!',
    service: 'hello-node',
    pod: process.env.PODNAME || 'unknown',
    time: new Date().toISOString(),

  });

});

app.get('/readyz', (req, res) => {
    res.send('Ready');
});

app.get('/healthz', (req, res) => {
  res.send('Healthy');
});

app.listen(PORT, () => {
  console.log(`Server is listening on Port: ${PORT}`);
});