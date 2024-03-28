const api = require("../connect/connectMysql")
const { findData , insert } = require("../connect/Connectmongodb")

const method = {

    insert: async function (data) {
        try {
            const sql = `INSERT INTO Chat (userId , chatId , readed ) VALUES (${data.userId} ,${data.chatroomId} , 0 )`
            const chatId = await api(sql)
            return chatId
        } catch (e) {
            throw e;
        }
    },
    insertchat: async function (data) {
        try {
            await insert(data)
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    getchat: async function (chatId) {
        try {
            const result = await findData(chatId)
            return result
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    readchat: async function (userId, chatId) {
        try {
            const sql = `UPDATE Chat SET readed = 1 WHERE userId = ${userId} AND chatId = ${chatId}`
            await api(sql)
            return
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    newchatmessage: async function (userId, chatId , data) {
        try {
            const sql = `UPDATE Chat SET readed = 0 , WHERE userId != ${userId} AND chatId = ${chatId}`
            await api(sql)
            return
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
}

module.exports = method;
