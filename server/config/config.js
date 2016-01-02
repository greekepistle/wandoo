// PRODUCTION CONFIGURATION

module.exports = {
  port: process.env.PORT,
  dbUser : process.env.DBUSER,
  dbPassword : process.env.DBPASS,
  dbHost : process.env.DBHOST,
  db : process.env.DB,
  serverURL : process.env.SERVERURL,
}

