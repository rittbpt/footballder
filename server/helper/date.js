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
module.exports = {
    DateNow,
    convertdatestringtoDate,
    convertdateDatetostring
};