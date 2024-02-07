const moment = require('moment');

async function DateNow() {
    return moment().format('YYYY-MM-DD HH:mm:ss');
}

async function convertdatestringtoDate(date) {
    return moment(date, 'DD/MM/YYYY').format('YYYY-MM-DD HH:mm:ss');
}

async function convertdateDatetostring(date) {
    return moment(date).format('DD/MM/YYYY');
}

async function convertdatetimestingDatetime(date) {
    return moment(date , 'YYYY-MM-DD HH:mm:ss').format('YYYY-MM-DD HH:mm:ss');
}

module.exports = {
    DateNow,
    convertdatestringtoDate,
    convertdateDatetostring , 
    convertdatetimestingDatetime
};