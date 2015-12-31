var express = require('express');
var fs = require('fs');
var config = require('./config/config')
var router = require('./router');
var logger = require('./logger');
var bodyParser = require('body-parser');
var cronjob = require('./workers/workers');

var app = express();
var expressRouter = express.Router(); 

// check if ./server/public/images exists
fs.access(__dirname + '/public/images', fs.R_OK | fs.W_OK, function (err) {
  if (err) {
    throw './server/public/images directory cannot be found!'
  }
});

app.use(bodyParser.json({limit: '5mb'}));
app.use(logger);
app.use('/images',express.static(__dirname + '/public/images'));
app.use('/', expressRouter);
router(expressRouter);
app.listen(config.port);

module.exports = app;

/*Cron Jobs*/
cronjob.schedulejob();
