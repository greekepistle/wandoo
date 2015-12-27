var request = require('supertest'),
    fs = require('fs'),
    db = require('../server/db'),
    userData = require('./userData'),
    wandooTextData = require('./wandooTextData');
    locDataGenerator = require('./locDataGenerator'),
    wandooTimeDataGenerator = require('./wandooTimeDataGenerator');

var server = request.agent('http://localhost:8000');

var numUsers = 6, // max is userData.length
    numLocations = 33,
    numWandoos = 33, //max 33, need to add more to wandooTextData if you want more
    numTimes = 33,
    locSeed = [37.7833669, -122.4088739], // location where you want to centre all locations
    numInterests = 100

var locData = locDataGenerator(locSeed, numLocations);
var wandooTimeData = wandooTimeDataGenerator(numTimes);
var userIDs = [];
var wandooIDs = [];

var getRandIndex = function (maxIndex) {
  return Math.round(Math.random() * maxIndex);
}

var generateUsers = function (callback) {
  var generateUser = function (i) {
    fs.readFile(__dirname + '/profilePics/' + i + '.png', 'base64', function (err, data) {
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
    userIDs = result.map(function (val) {
      return val.userID;
    });
    callback();
  });
}

var getWandooIDs = function (callback) {
  var qs = 'select wandooID, userID from wandoo';
  db.query(qs, function (err, result) {
    if (err) {
      throw err;
    } 
    wandooIDs = result.map(function (val) {
      return [val.wandooID, val.userID];
    });
    callback();
  });

}

var generateWandoos = function (callback) {
  var generateWandoo = function (i) {
    var wandoo = {
      userID : userIDs[Math.round(Math.random() * (userIDs.length - 1))],
      text : wandooTextData[i],
      startTime : wandooTimeData[i][1],
      postTime : wandooTimeData[i][0],
      latitude : locData[i][0],
      longitude : locData[i][1],
      numPeople : Math.ceil(Math.random() * 4) 
    };
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

var selRejCombos = [ // not currently used
  {
    selected : 0,
    rejected : 0
  },
  {
    selected : 1,
    rejected : 0
  },
  {
    selected : 0,
    rejected : 1
  }
];

var generateInterests = function (callback) {

  var generateInterest = function (i) {
    var wandooID = wandooIDs[getRandIndex(wandooIDs.length - 1)];
    var userID;
    while (!userID) {
      var userIndex = getRandIndex(userIDs.length - 1);
      if (userIDs[userIndex] !== wandooID[1]) { //check if user is not liking their own wandoo
        userID = userIDs[userIndex];
      }
    }
    var interest = {
      wandooID : wandooID[0],
      userID : userID
    }
    server
      .post('/api/interested')
      .send(interest)
      .end(function (err) {
        if (err) {
          throw err;
        }
        if (i < numInterests) {
          generateInterest(i + 1);
        } else {
          callback();
          return;
        }
      });
  }
  generateInterest(0);
}

generateUsers(function () {
  getUserIDs(function () {
    generateWandoos(function () {
      getWandooIDs(function () {
        generateInterests(function () {
          console.log('Complete');
        });
      })
    });
  });
});
  
// 1. Insert users
// 2. Get userIDs
// 3. Insert wandoos
// 4. Insert wandoo_interests
// 5. Insert room
// 6. Insert room_user
// 7. Run workers
