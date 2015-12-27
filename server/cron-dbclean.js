var _ = require('underscore');
var wandoo = require('./models/wandoo.js');
var interested = require('./models/interested.js');



var isExpired = function(data) {
	return Date.parse(data.start_time) < Date.parse(new Date());
}


// Pseudo code Iteration 1
// Worker 1 - Responsible for Wandoo table:
//  a) Filters all Wandoo's with startTime < curTime and creates expired list
//  		-> forEach Elem in Expired list
//  					if status flag is Expired 
//  							put status = delete
//  					if status flag is Active
//  							Check if there is room where corresponding wandoo_id
//  								if yes 
//  									set Wandoo_Elem status to Passive
//  								if no 
//  									put status = delete
//  					if status = delete
//  						Delete (room_user, wandoo_interest) where corresponding wandoo_id
//  						Delete room where corresponding wandoo_id
//  						Delete Wandoo where corresponding wandoo_id 

// Worker 2 - Responsible for room table

// 	a) Filter all room with expire_time < curTime and create room_expire_list
// 			-> forEach Elem in room_expire_list
// 						set wandoo_table status flag to expired where corresponding wandoo_id 




var processWandooData = function(dataset) {

		//Filter for all expired entries and collect those wandoo ids
		var expired_entries = dataset.filter(isExpired);
		
		console.log("Expired entries", expired_entries);
		console.log("Expired entries count", expired_entries.length);

		_.each(expired_entries, function(entry) {
			// Current wandoo id to delete
			// console.log(entry.wandooID);
			// Delete all rooms, room_user corresponding to Wandoo_id before deleting wandoos table
			// If you don't do this, the other operations (Wandoo_delete) will be unsucccessful
			


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