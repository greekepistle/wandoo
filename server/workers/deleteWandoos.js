var _ = require('underscore');
var wandoo = require('../models/wandoo');
var interested = require('../models/interested');

var expiredWandoos = function (data) {
  return Date.parse(data.start_time) < Date.parse(new Date());
}

var expiredRooms = function(data) {
  return Date.parse(data.expiry) >= Date.parse(new Date());
}

var processWandooData = function (data) {
  var expiredEntries = data.filter(expiredWandoos);
  
  console.log('Expired entries:', expiredEntries);
  console.log('Expired entries count:', expiredEntries.length);

  _.each(expiredEntries, function (entry) {
    if (entry.status === 'E') {
      entry.delete = true;
    } else if (entry.status === 'A' && entry.room) {
      // check if there exists a room with a corresponding wandooID
      entry.passive = true;
    } else if (entry.status === 'A' && !entry.room) {
      entry.delete = true;
    }
  });

  var toPassive = _.pluck(_.filter(expiredEntries, function (entry) {
    return ('passive' in entry);
  }),'wandooID');
  var toDelete = _.pluck(_.filter(expiredEntries, function (entry) {
    return ('delete' in entry);
  }), 'wandooID');

  // console.log('passive', toPassive);
  // console.log('delete', toDelete);

  wandoo.updateToPassive(toPassive, function (err, result1) {
    if (err) {
      console.log(err);
    } else {
      wandoo.delete(toDelete, function (err, result2) {
        if (err) {
          console.log(err);
        } else {
          console.log('Wandoos successfully deleted and updated.');
        }
      });
    }
  });
}

var processRoomData = function (data) {
  // filter for rooms which are expired
  var expiredEntries = data.filter(expiredRooms);
  // get the wandooID for each of the rooms that are expired
  var toExpire = _.pluck(data);
  // update the status for all wandooIDs to be 'E'
  wandoo.updateToExpired(toExpire, function (err, result) {
    if (err) {
      console.log(err);
    } else {
      console.log('Wandoos successfully expired.')
    }
  });
  
}

var job1 = function () {
  wandoo.getForDW(function (err, result) {
    if (err) {
      console.log('DB entries not retrieved');
      console.log(err);
    } else { 
      processWandooData(result);
    }
  });
}

var job2 = function () {
  // get all rooms
  
}

module.exports = job1;

job1(
