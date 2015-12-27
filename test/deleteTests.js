var room = require('../server/models/room');
var wandoo = require('../server/models/wandoo');

// TEST for room.deleteByWandoo

room.deleteByWandoo(66, function (err, results) {
  if (err) {
    console.log(err);
  } else {
    console.log(results);
  }
});

// TEST for wandoo.delete

wandoo.delete(3, function (err, results) {
  if (err) {
    console.log(err);
  } else {
    console.log(results);
  }
});
