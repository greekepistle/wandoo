function distance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;    // Math.PI / 180
  var c = Math.cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;

  return 7917.5 * Math.asin(Math.sqrt(a)); // Diameter of the earth: 7917.5
}


console.log(distance(37.5990724000, -122.3828988000, 37.9459413000, -122.4450154000));
