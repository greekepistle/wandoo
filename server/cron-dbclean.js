var _ = require('underscore');
var wandoo = require('./models/wandoo.js');
var interested = require('./models/interested.js');



var isExpired = function(data) {
	return Date.parse(data.start_time) < Date.parse(new Date());
}



var processWandooData = function(dataset) {

		//Filter for all expired entries and collect those wandoo ids
		var expired_entries = dataset.filter(isExpired);
		
		console.log("Expired entries", expired_entries);
		console.log("Expired entries count", expired_entries.length);

		_.each(expired_entries, function(entry) {
			// Current wandoo id to delete
			// console.log(entry.wandooID);

		// Delete expired Wandoos
		// Delete /interested/ table entries with the wandoo_id, before wandoo table,
		 // If you dont't do this, first as it will error
		// Delete /wandoo/expired_wandoo_id
		wandoo.delete(entry.wandooID, function(err, res1, res2, res3) {
			if(err) {
				console.log("Worker Wandoo delete unsuccessful");
			} else {
				console.log("Worker Wandoo delete sucesses");
			}
		})

	});

	}

	var getQueryCBAndProcess = function (err, result, callback) {

		if(err) {
			console.log("DB entries not retrieved");
		} else {
			callback(result);
		}

	}

	module.exports = {

		job: function() {

			console.log("Test this every minute");
			wandoo.getAll(function (err, result) {
				getQueryCBAndProcess(err, result, processWandooData);
			});

		}

	};