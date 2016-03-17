module.exports = function (req, res, next) {
  if ( req.method === 'GET') {
    console.log('Received ' + req.method + ' from ' + req.url);
  } else {
    console.log('Received ' + req.method + ' from ' + req.url + 
      '\n>>> Payload:\n' + JSON.stringify(req.body));
  }
  next();
}
