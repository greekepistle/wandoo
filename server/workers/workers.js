var crondbclean = require('./cron-dbclean');
var cleanUpWandoos = require('./cleanUpWandoos');
var CronJob = require('cron').CronJob;

module.exports = {
  schedulejob: function() {
    new CronJob('*/15 * * * *', cleanUpWandoos, null, true, 'America/Los_Angeles');
  }
};

