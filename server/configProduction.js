// copy this file to a new config.js

module.exports = {
  port: process.env.PORT,
  dbUser : process.env.DBUSER,
  dbPassword : process.env.DBPASS,
  dbHost : process.env.DBHOST,
  serverURL : process.env.SERVERURL,
}
console.log(process.env.TIMES);
