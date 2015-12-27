var express = require('express');
var config = require('./config')
var router = require('./router');
var logger = require('./logger');
var bodyParser = require('body-parser');
var cronjob = require('./worker')

// var crondbclean = require('./cron-dbclean');

var app = express();
var expressRouter = express.Router(); 

app.use(bodyParser.json({limit: '5mb'}));
// app.use(bodyParser.urlencoded({limit: '5mb'}));

app.use(logger);
app.use('/images',express.static(__dirname + '/public/images'));
app.use('/', expressRouter);

router(expressRouter);
app.listen(config.port);

module.exports = app;



/*Cron Jobs*/
//cronjob.schedulejob();
