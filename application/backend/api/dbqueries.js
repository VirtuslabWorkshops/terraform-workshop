var sql = require("mssql");
const { dbConfig } = require("./dbconnect");


const getArticles = (request, response) => {
  // Create connection instance
  var conn = new sql.ConnectionPool(dbConfig);

  conn.connect()
      // Successfull connection
      .then(function () {

          // Create request instance, passing in connection instance
          var req = new sql.Request(conn);

          // Call mssql's query method passing in params
          req.query("SELECT * FROM [SalesLT].[Customer]")
              .then(function (recordset) {
                response.status(200).json(recordset);
                  conn.close();
              })
              // Handle sql statement execution errors
              .catch(function (err) {
                  console.log(err);
                  conn.close();
              })

      })
      // Handle connection errors
      .catch(function (err) {
          console.log(err);
          conn.close();
      });
}

  module.exports = {
    getArticles
  }