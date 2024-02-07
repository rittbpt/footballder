const api = require("../connect/connectMysql")
const dateHelper = require("../helper/date")

const method = {
    getall: async function (selectedFields , userId) {
        try {
            const sql = `SELECT ${selectedFields || '*'} FROM MatchTable WHERE userCreate != ${userId}`;
            const data = await api(sql);
            return data;
        } catch (error) {
            throw error;
        }
    },

    insert: async function (matchName, locationId, selectDatetime, amount, Description, statusMatch, userCreate) {
        try {
            const time = await dateHelper.convertdatestringtoDate(selectDatetime)
            const sql = `INSERT INTO MatchTable
            (
                ${!matchName ? '' : 'matchName,'}
                ${!locationId ? '' : 'locationId,'}
                ${!selectDatetime ? '' : 'selectDatetime,'}
                ${!amount ? '' : 'amount,'}
                ${!Description ? '' : 'Description,'}
                ${!statusMatch ? '' : 'statusMatch,'}
                ${!userCreate ? '' : 'userCreate'}
            )
            VALUES
            (
                ${!matchName ? '' : `'${matchName}',`}
                ${!locationId ? '' : `'${locationId}',`}
                ${!selectDatetime ? '' : `'${time}',`}
                ${!amount ? '' : `'${amount}',`}
                ${!Description ? '' : `'${Description}',`}
                ${!statusMatch ? '' : `'${statusMatch}',`}
                ${!userCreate ? '' : `'${userCreate}'`}
            );
            
                        `
            const data = await api(sql);
            return data;
        } catch (error) {
            console.log(error)
            throw error;
        }
    },


    

}

module.exports = method;
