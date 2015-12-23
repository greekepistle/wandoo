// east: example 1: 37.789048, -122.387229

// north: 2: 37.810917, -122.477343
// - golden gate bridge




// west: 37.751869, -122.510050


// south: 37.624711, -122.380869
// - near the airport


var numRecords = 10;

var seed = [37.7833669, -122.4088739];

var latOffset = 0.2;

var longOffset = 0.2;

var lat, long;

var result = [];

for (var i = 0; i < numRecords; i ++) {
  lat = seed[0] - latOffset + Math.random() * latOffset * 2;
  long = seed[1] - longOffset + Math.random() * longOffset * 2;
  result.push([lat,long]); // need to round this to a small decimal
}


console.log(result);




