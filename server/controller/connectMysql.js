const mysql = require('mysql2')
const DATABASE_URL = 'mysql://44b3qc6n7v2rj2lgv5x7:pscale_pw_7A8w1aQ2QNPde6g3AjaoLQCAONZrarVxXVlJpfxdhGR@aws.connect.psdb.cloud/footballder?ssl={"rejectUnauthorized":true}'
const connection = mysql.createConnection(DATABASE_URL)

const api = (query, rowsAffected, type, table) => {
    return new Promise((resolve, reject) => {
        connection.query(query, (err, result, field) => {
            if (err) {
                reject(err);
            } else {
                resolve(result[0]);
            }
            connection.end(); 
        });
    });
};



module.exports = api;