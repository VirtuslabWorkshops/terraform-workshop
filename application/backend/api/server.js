const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 80
const db = require('./dbqueries.js')

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)

app.get('/', (request, response) => {
    response.json({ info: 'VL Library, yay!' })
})

app.get('/articles', db.getArticles)

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})