var sql = require("mssql");
const { dbConfig } = require("./dbconnect");


const getArticles = (request, response) => {
  var conn = new sql.ConnectionPool(dbConfig);

  conn.connect()
    .then(function () {

      var req = new sql.Request(conn);

      req.query("SELECT * FROM ARTICLES")
        .then(function (recordset) {
          response.status(200).json(recordset);
          conn.close();
        })
        .catch(function (err) {
          console.log(err);
          conn.close();
        })
    })
    .catch(function (err) {
      console.log(err);
      conn.close();
    });
}

module.exports = {
  getArticles
}