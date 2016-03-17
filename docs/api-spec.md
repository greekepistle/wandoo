# Wandoo API Specification

##Users

### GET /api/users

#### Parameters

Name|Notes|Example
----|-----|-------
facebookID| | 10153381139067955
#### Example

```json
curl -i http://localhost:8000/api/users?facebookID=10153381139067955
```

#### Usage
1. When user logs in, we need to get their userID and profile data
 
### GET /api/users/\<userID\>

#### Example

```json
curl -i http://localhost:8000/api/users/324624
```

#### Usage
1. When a user likes a wandoo, we need to display user info to host

### POST /api/users


#### Payload

Name | Notes | Example | 
-----|------------- | --------- |
name | Full name | John Smith |
facebookID | Uniquely identifies a user of Facebook | 10153381139067955 |
email | | john.smith@yahoo.com |
age | | 53 |
sex | | M |
profilePic | A base64 encoded image file | data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=|
employer | | Google |
jobTitle | | Software Engineer |
latitude | | 37.7836675 |
longitude | | -122.4091699 |
educationInstitution | | Stanford |
objectID| Provided by Parse |IPyQqWYM0x | 
friends | To be added post-MVP | |
interests | To be added post-MVP | |
likes | To be added post-MVP |  |

#### Examples

```json

curl -i -X POST -H 'Content-Type: application/json' -d '{"name":"Pete Zurish","facebookID":134515,"email":"pete.z@gmail.com","age":28,"sex":"M","profilePic":"data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=","employer":"Google","jobTitle":"Software Engineer","latitude":"37.7836675","longitude":"-122.4091699","educationInstitution":"University of Toronto", "objectID":"adfgafh"}' localhost:8000/api/users

```
#### Usage
1. Every new user that is created will have its user data sent to the server to store in the database.

### DELETE /api/users/\<userID\>

To be added post-MVP

#### Example

```json

```

#### Usage
1. When a user deletes his/her account from our system. a) delete user from user table b) delete host wandoos c) delete all wandoo interests by the user

### PUT /api/users/\<userID\>

#### Payload

Name | Notes | Example |
-----|------------- | --------- |
latitude | latitude of user's current position | 37.7836675 |
longitude | longitude of user's current position| -122.4091699 | 

#### Usage
1. For every user request from the client, we will send this PUT request to update the user location (ex. from web application, we can use navigator.geolocation.getCurrentPosition)

#### Example

```json
curl -i -X PUT -H "Content-Type: application/json" localhost:8000/api/users/21 -d '{"latitude":23.00,"longitude":45.234}'
```


## Wandoos

### GET /api/wandoos

#### Parameters

Name | Notes | Example
-----|-------|------------|
offset| The record number to start from. Must be used with limit. Starts from 0.| 0 |
limit | Limits the number of return values | 25 |
hostID | Returns all wandoos of the host identified by the host's userID. Cannot be used with offset and limit.| 222 |
userID | Returns all wandoos that are 20 miles away from user. | 3345 |
startTime | To be added post-MVP, ISO:8601 String (use Date.prototype.toJSON())| 2015-12-12T01:30:00.040Z |
endTime | To be added post-MVP, ISO:8601 String (use Date.prototype.toJSON())| 2015-12-12T02:30:00.040Z |
postTime | To be added post-MVP, ISO:8601 String (use Date.prototype.toJSON())| 2015-12-12T01:00:00.040Z |
tag | To be added post-MVP | dinner |

#### Examples

```json
curl -i http://localhost:8000/api/wandoos
curl -i localhost:8000/api/wandoos?offset=2\&limit=5
curl -i localhost:8000/api/wandoos?hostID=1
curl -i localhost:8000/api/wandoos?userID=5
```

#### Usage
1. Retrieve all wandoos of a host by specifying host's userID
2. Retrieve all wandoos near user's location
3. Retrieve all wandoos and limit the amount returned

### POST /api/wandoos

#### Payload

Name | Notes | Example | 
-----|------------- | --------- |
userID | | 222 | 
text | Full text of the wandoo (max of x characters)? | Going out to lunch |  
startTime | ISO:8601 String (use Date.prototype.toJSON()) | 2015-12-12T01:30:00.040Z | 
endTime | ISO:8601 String (use Date.prototype.toJSON()) | 2015-12-12T02:00:00.040Z | 
postTime | ISO:8601 String (use Date.prototype.toJSON()) | 2015-12-12T01:00:00.040Z | 
tag | To be added post-MVP | lunch | 
latitude | latitude of user's position | 37.7836675 |
longitude | longitude of user's position | -122.4091699 |
numPeople | | 4 |

#### Examples

```json
curl -i -X POST -H 'Content-Type: application/json' localhost:8000/api/wandoos -d '{"userID":63,"text":"I want to go out to lunch","startTime":"2015-12-12T01:30:00.040Z","endTime":"2015-12-12T02:30:00.040Z","postTime":"2015-12-12T01:00:00.040Z","latitude":37.7836675,"longitude":-122.4091699,"numPeople":4}'
```

### DELETE /api/wandoos

#### Payload
Name | Notes | Example
-----|-------|--------
wandooIDs|An array of wandooIDs that identify the wandoos to be deleted|[24,43,56]

#### Examples

#### Usage
1. When a user deletes a wandoo (delete room, tags, interests)
2. When a wandoo expires and the worker deletes it

### PUT /api/wandoos/\<wandooID\>

#### Payload
Name | Notes | Example
-----|-------|---------
status|Update the status of the wandoo to 'P' (passive). This can only change the status of the wandoo to 'P'. | P

#### Examples
```json
curl -i -X PUT -H 'Content-Type: application/json' http://localhost:8000/api/wandoos/168 -d '{"status":"P"}'
```


#### Usage
1. When a wandoo has been filled, the wandoo should no longer be visible within the main feed. This PUT request should be sent when this wandoo has been filled.


## Interested 

### GET /api/interested

#### Parameters

Name | Notes | Example
-----|-------|---------
wandooID| Cannot be specified if userID is specified| 22323|
userID| Cannot be specified if wandooID is specified| 235245|

#### Examples
```json
```

#### Usage
1. On the feed, all wandoos which a user has already expressed interest in will be disabled
2. A user will be able to view all of the wandoos that they've expressed interest in

### POST /api/interested

#### Payload

Name | Notes | Example
-----|-------|--------
wandooID| | 234325
userID| | 245425

#### Examples

```json
curl -i -X POST -H 'Content-Type: application/json' localhost:8000/api/interested -d '{"wandooID":9,"userID":63}'
```

### PUT /api/interested/\<wandooID\>/\<userID\>

#### Payload
Name | Notes | Example
----|------|------
selected| 1 indicates that a host has selected a user, 0 indicates that host has not. Cannot be specified if **rejected** is specified.  | 1
rejected| 1 indicates that a host has selected a user, 0 indicates that host has not. Cannot be specified if **selected** is specified. | 0
hostID|userID of the host| 245626|

#### Examples
```json
```

#### Usage
1. When a host selects/rejects a user, send a PUT to change respective flag

## Rooms

### GET /api/rooms

#### Parameters

Name | Notes | Example
-----|-------|---------
userID| Cannot be specified if wandooID is specified| 22323|

#### Examples
```js
curl -i localhost:8000/api/rooms?userID=3
```

### POST /api/rooms

#### Payload

Name| Notes | Example
----|-------|--------
wandooID| | 352436|
userIDs| An array of userIDs | [235435, 53466]| 

#### Examples

```json
curl -i -X POST -H 'Content-Type: application/json' localhost:8000/api/rooms -d '{"wandooID":1,"userIDs":[1,2]}'
```

#### Usage
1. When a host has selected a guest for the hosts's wandoo, the room will be created with the host userIDs and the selected guest userIDs.

### PUT /api/rooms/\<roomID\>

#### Payload

Name| Notes | Example
----|-------|--------
userIDs| An array of userIDs | 2354| 

#### Examples

```json
curl -i -X PUT -H 'Content-Type: application/json' http://localhost:8000/api/rooms/10 -d '{"userIDs":[3,4]}'
```

### DELETE /api/rooms

#### Payload 
Name | Notes | Example
-----|-------|--------
roomIDs| An array of roomIDs, which identify the rooms that will be deleted| [2,3,4]

#### Examples

```json
curl -i -X DELETE localhost:8000/api/rooms -d '{"roomIDs":[2,3,4]}'
```

#### Usage
1. Worker deletes rooms when they have been expired.

## Tags

To be added post-MVP

### GET /api/tags

#### Usage
1. Client must know the valid tags that a user can submit for a wandoo.










