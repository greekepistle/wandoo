// INPUT

// get current date and time

// set desired amount of records

// Repeat for the desired amount of records

  // Generate a random post time with the following range
    // oldest time: midnight of ( current time - 2 days )
    // newest time: current time

  // Generate a random start time with the following range
    // oldest time: post time to the next 15 min interval
    // newest time: a minute before midnight of ( current time + 1 day )

// OUTPUT

// [<startTime>,<postTime>]

var roundUpToNearestInterval = function (minStart) {
  minute = minStart.getMinutes();
  if (minute % 15 === 0) {
      result = minute;
  } else {
      var multiple = Math.floor(minute / 15);
      result = (multiple === 3 ? 0 : multiple + 1) * 15;
  }
  minStart.setMinutes(result);
  minStart.setSeconds(0);
  minStart.setMilliseconds(0);
}

var setMaxStart = function (maxStart) {
  maxStart.setDate(maxStart.getDate() + 1);
  maxStart.setHours(23);
  maxStart.setMinutes(45);
  maxStart.setSeconds(0);
  maxStart.setMilliseconds(0);
}

var setMinPost = function (minPost) {
  minPost.setDate(minPost.getDate() - 2);
  minPost.setHours(0);
  minPost.setMinutes(0);
  minPost.setSeconds(0);
  minPost.setMilliseconds(0);
}

var results = [];

var numRecords = 10;

var current = new Date();
var minPost = new Date(current.getTime());
setMinPost(minPost);
var maxPost = new Date(current.getTime());
var maxStart = new Date();
setMaxStart(maxStart);

// var randomPost = new Date(+minPost + (Math.random() * (maxPost - minPost)));
// var minStart = new Date(randomPost.getTime());
// setMinStart(minStart);
// var randomStart = new Date(+minStart + (Math.random() * (maxStart - minStart))); 

// console.log(randomPost);
// console.log(randomStart);



for (var i = 0; i < numRecords; i ++) {
  var randomPost = new Date(+minPost + (Math.random() * (maxPost - minPost)));
  var minStart = new Date(randomPost.getTime());
  roundUpToNearestInterval(minStart);
  var randomStart = new Date(+minStart + (Math.random() * (maxStart - minStart))); 
  roundUpToNearestInterval(randomStart);
  results.push([randomPost.toJSON(), randomStart.toJSON()]);
}
console.log((new Date()).toJSON());
console.log(results);



