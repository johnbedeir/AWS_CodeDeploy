const http = require('http');

// Create an HTTP server
const server = http.createServer((req, res) => {
  res.statusCode = 200;  // Set the status code to 200 (OK)
  res.setHeader('Content-Type', 'text/plain');  // Set the content type to plain text
  res.end('Hello World\n');  // Send "Hello World" as the response
});

// The server listens on port 80 (HTTP) or any other available port
const PORT = process.env.PORT || 80;
server.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});
