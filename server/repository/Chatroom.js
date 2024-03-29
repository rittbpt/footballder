const api = require("../connect/connectMysql")
const dateHelper = require("../helper/date")

const method = {
    insert: async function (data) {
        try {
            const sql = `INSERT INTO Chatroom (Chatname , type , MatchId ) VALUES ('${data.MatchName}' , '${data.type}'  , ${data.MatchId})`
            const chatId = await api(sql)
            return chatId
        } catch (e) {
            throw e;
        }

    },
    findcharoomidbymatchid: async function (MatchId) {
        try {
            const sql = `SELECT ChatID FROM Chatroom WHERE MatchId = ${MatchId}`
            const chatId = await api(sql)
            return chatId[0].ChatID
        } catch (e) {
            throw e;
        }

    },
    chats: async function (userId) {
        try {
            const sql = `SELECT c.readed ,cr.* FROM Chatroom AS cr JOIN Chat AS c ON c.chatId = cr.ChatID WHERE c.userId = ${userId}`
            const chats = await api(sql)
            return chats
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    newchatmessage: async function (chatId , data) {
        try {
            const time = await dateHelper.DateNow()
            const sql = `UPDATE Chatroom SET time = '${time}' , message = '${data}' WHERE ChatID = ${chatId}`
            const chats = await api(sql)
            return chats
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },

}

module.exports = method;
