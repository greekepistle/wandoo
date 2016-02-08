module.exports = function (seed, numRecords) {

  var latOffset = 0.2;
  var longOffset = 0.2;
  var lat, long;
  var result = [];

  for (var i = 0; i < numRecords; i ++) {
    lat = seed[0] - latOffset + Math.random() * latOffset * 2;
    long = seed[1] - longOffset + Math.random() * longOffset * 2;

    latString = lat.toString();
    concatLat = +latString.substring(0, latString.lastIndexOf('.') + 8);

    longString = long.toString();
    concatLong = +longString.substring(0, longString.lastIndexOf('.') + 8);

    result.push([concatLat,concatLong]);
  }
  return result;
  
}









