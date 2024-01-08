const mysql = require('mysql2')
const DATABASE_URL = 'mysql://44b3qc6n7v2rj2lgv5x7:pscale_pw_7A8w1aQ2QNPde6g3AjaoLQCAONZrarVxXVlJpfxdhGR@aws.connect.psdb.cloud/footballder?ssl={"rejectUnauthorized":true}'


const api = async (query, rowsAffected, type, table) => {
    const connection = mysql.createConnection(DATABASE_URL)
    return new Promise((resolve, reject) => {
        connection.query(query, (err, result, field) => {
            if (err) {
                reject(err);
            } else {
                resolve(result);
            }
            connection.end();
        });
    });
};



module.exports = api;