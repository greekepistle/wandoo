var request = require('supertest'),
    fs = require('fs'),
    _ = require('underscore'),
    db = require('../server/db/db'),
    userDataGenerator = require('./userDataGenerator');
    wandooTextData = require('./wandooGenerator'),
    locDataGenerator = require('./locDataGenerator'),
    wandooTimeDataGenerator = require('./wandooTimeDataGenerator'),
    config = require('../server/config/config');

var server = request.agent(config.serverURL);

var numUsers = 500, // max is userData.length
    numWandoos = 2500,
    // location where you want to centre all locations
    locSeed = [37.7833669, -122.4088739], // SF
    // locSeed = [32.8724048054, -117.2019943782], // San Diego
    numInterests = numWandoos * 3,
    // below are currently not used
    selectedInterestedRatio = 0.6, // ratio of total selected users in system to total interested users in system
    rejectedInterestedRatio = 0.2; // ratio of total rejected users in system to total interested users in system
    noneInterestedRatio = 0.2;

var locData = locDataGenerator(locSeed, numWandoos);
var wandooTimeData = wandooTimeDataGenerator(numWandoos);
var userIDs = [];
var wandooIDs = [];

var getRandIndex = function (maxIndex) {
  return Math.round(Math.random() * maxIndex);
}

var randomElement = function(array){
  var randomIndex = Math.floor(Math.random() * array.length);
  return array[randomIndex];
};
var generateUsers = function (callback) {
  var userData = [];
  var generateUser = function (i) {
    if (i < numUsers) {
      fs.readFile(__dirname + '/profilePics/' + getRandIndex(9) + '.png', 'base64', function (err, data) {
        if (err) {
          throw err;
        }
        userData[i] = userDataGenerator();
        userData[i].profilePic = data;
        userData[i].latitude = locDataGenerator(locSeed, 1)[0][0];
        userData[i].longitude = locDataGenerator(locSeed, 1)[0][1];
        server
          .post('/api/users')
          .send(userData[i])
          .end(function (err,res) {
            if (err) {
              throw err;
            }
            generateUser(i + 1);
          });
      });
    } else {
      callback();
    }
  }
  generateUser(0);
}

var getUserIDs = function (userIDs, callback) {
  var qs = 'select userID from user';
  db.getConnection(function (err, con) {
    if (err) {
      console.error(err);
    } else {
      db.query(qs, function (err, result) {
        con.release();
        if (err) {
          throw err;
        } 
        userIDs = result.map(function (val) {
          return val.userID;
        });
        callback(userIDs);
      });
    }
  });
}

var getWandooIDs = function (wandooIDs, callback) {
  var qs = 'select wandooID, userID from wandoo';
  db.getConnection(function (err, con) {
    if (err) {
      console.error(err);
    } else {
      db.query(qs, function (err, result) {
        con.release();
        if (err) {
          throw err;
        } 
        wandooIDs = result.map(function (val) {
          return [val.wandooID, val.userID];
        });
        callback(wandooIDs);
      });
    }
  });
}

var generateWandoos = function (userIDs, callback) {
  var generateWandoo = function (i) {
    if (i < numWandoos) {
      var wandoo = {
        userID : userIDs[Math.round(Math.random() * (userIDs.length - 1))],
        text : wandooTextData(),
        startTime : wandooTimeData[i][1],
        postTime : wandooTimeData[i][0],
        latitude : locData[i][0],
        longitude : locData[i][1],
        numPeople : Math.ceil(Math.random() * 3) 
      };
      server
        .post('/api/wandoos')
        .send(wandoo)
        .end(function (err) {
          if (err) {
            throw err;
          }
          generateWandoo(i + 1);
        });
    } else {
      callback();
    }
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

var generateInterests = function (userIDs, wandooIDs, callback) {
  var interests = [];
  var generateInterest = function (i) {
    if (i < numInterests) {
      var wandooID = wandooIDs[getRandIndex(wandooIDs.length - 1)];
      console.log(wandooIDs);
      var filteredUserIDs = _.chain(interests)
        .filter(function (interest) {
          return interest.wandooID === wandooID;
        })
        .pluck('userID');
      var userID;
      while (!userID) {
        var userIndex = getRandIndex(userIDs.length - 1);
        //check if user is not liking their own wandoo and has not expressed interest in wandoo already
        if (userIDs[userIndex] !== wandooID[1] && !contains(filteredUserIDs, userIndex)) { 
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

          var rand = Math.random();
          if (rand <= selectedInterestedRatio) {
            interest.selected = true;
          } else if (rand <= selectedInterestedRatio + rejectedInterestedRatio) {
            interest.rejected = true;
          }
          interests.push(interest);

          generateInterest(i + 1);
        });
    } else {
      callback();
    }
  }
  generateInterest(0);
}

module.exports = {
  generateUsers : generateUsers,
  getUserIDs : getUserIDs,
  generateWandoos : generateWandoos,
  getWandooIDs : getWandooIDs, 
  generateInterests : generateInterests
};

generateUsers(function () {
  getUserIDs(userIDs, function (userIDs) {
    generateWandoos(userIDs, function () {
      getWandooIDs(wandooIDs, function (wandooIDs) {
        // generateInterests(userIDs, wandooIDs, function () {
          console.log('Complete');
        // });
      })
    });
  });
});

// NEED TO TEST GENERATE INTEREST BEFORE ADDING IT

// PSEUDO CODE
// 1. Insert users
// 2. Get userIDs
// 3. Insert wandoos
// 4. Insert wandoo_interests
// 5. Insert room
// 6. Insert room_user
// 7. Run workers
