const moment = require('moment');

async function DateNow() {
    return moment().format('YYYY-MM-DD HH:mm:ss');
}

async function DateNow_() {
    return moment().format('YYYY-MM-DD');
}

async function convertdatestringtoDate(date) {
    return moment(date, 'DD/MM/YYYY').format('YYYY-MM-DD HH:mm:ss');
}

async function convertdateDatetostring(date) {
    return moment(date).format('DD/MM/YYYY');
}

async function convertdatetimestingDatetime(date) {
    return moment(date, 'YYYY-MM-DD HH:mm:ss').format('YYYY-MM-DD HH:mm:ss');
}

async function textday(date) {
    return moment(date, 'YYYY-MM-DD HH:mm:ss').format('DD MMMM YYYY');
}

async function changetotime(date) {
    return moment(date, 'YYYY-MM-DD HH:mm:ss').format('HH:mm');
}


async function checkdate(date) {
    const date_now = moment().format('DD/MM/YYYY')
    const isMonth = moment().format('MM/YYYY')
    if (date_now === await convertdateDatetostring(date)) {
        return date.split(' ')[1].slice(0,5)
    } else if ((isMonth === moment().format('MM/YYYY')) || (moment().format('YYYY') === moment().format('YYYY'))) {
        return moment(date).format('MM/YY')
    } else {
        return await convertdateDatetostring(date)
    }
}


async function calculateage(date) {
    const birthday = moment(date);
    const now = moment();
    const age = now.diff(birthday, 'years');
    return age
}

module.exports = {
    DateNow,
    convertdatestringtoDate,
    convertdateDatetostring,
    convertdatetimestingDatetime,
    textday,
    changetotime,
    calculateage,
    DateNow_ ,
    checkdate
};