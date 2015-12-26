var request = require('supertest'),
    fs = require('fs'),
    db = require('../server/db'),
    userData = require('./userData'),
    wandooTextData = require('./wandooTextData');
    locDataGenerator = require('./locDataGenerator'),
    wandooTimeDataGenerator = require('./wandooTimeDataGenerator');

var server = request.agent('http://localhost:8000');

var numUsers = 6, //can optionally set this to userData.length
    numLocations = 33,
    numWandoos = 33, //max 33, need to add more to wandooTextData if you want more
    numTimes = 33,
    locSeed = [37.7833669, -122.4088739]; // location where you want to centre all locations

var locData = locDataGenerator(locSeed, numLocations);
var wandooTimeData = wandooTimeDataGenerator(numTimes);
var userIDs = [];


var generateUsers = function (callback) {
  var generateUser = function (i) {
    fs.readFile('./profilePics/' + i + '.png', 'base64', function (err, data) {
      if (err) {
        throw err;
      }
      userData[i].profilePic = data;
      userData[i].latitude = locData[i][0];
      userData[i].longitude = locData[i][1];

      server
        .post('/api/users')
        .send(userData[i])
        .end(function (err,res) {
          if (err) {
            throw err;
          }
          if (i < numUsers - 1) {
            generateUser(i + 1);
          } else {
            callback();
            return;
          }
        });
    });
  }
  generateUser(0);
}

var getUserIDs = function (callback) {
  var qs = 'select userID from user';
  db.query(qs, function (err, result) {
    if (err) {
      throw err;
    } 
    // console.log(result);
    userIDs = result.map(function (val) {
      return val.userID;
    });
    callback();
  });
}

var generateWandoos = function (callback) {
  var generateWandoo = function (i) {
    var wandoo = {
      userID : userIDs[Math.round(Math.random() * userIDs.length)],
      text : wandooTextData[i],
      startTime : wandooTimeData[i][0],
      postTime : wandooTimeData[i][1],
      latitude : locData[i][0],
      longitude : locData[i][1],
      numPeople : Math.ceil(Math.random() * 4) 
    };
    console.log(wandoo.startTime);
    // console.log(wandoo.userID);
    server
      .post('/api/wandoos')
      .send(wandoo)
      .end(function (err) {
        if (err) {
          throw err;
        }
        if (i < numWandoos - 1) {
          generateWandoo(i + 1);
        } else {
          callback();
          return;
        }
      });
  }
  generateWandoo(0);
}

generateUsers(function () {
  getUserIDs(function () {
    generateWandoos(function () {
      console.log('Complete');
    });
  });
});
  






