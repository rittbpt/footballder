const chatRepo = require("../repository/chat")
const chatroomRepo = require("../repository/Chatroom")

const method = {
    insert: async function (data) {
        try {
            await chatRepo.insert(data)
            return
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    insertchat: async function (chatdt) {
        try {
            const data = await chatRepo.insertchat(chatdt)
            await chatRepo.newchatmessage(chatdt.userId, chatdt.chatId)
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    getchat: async function (chatId) {
        try {
            const data = await chatRepo.getchat(chatId)
            return data
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    readchat: async function (userId, chatId) {
        try {
            await chatRepo.readchat(userId, chatId)
        } catch (e) {
            throw e;
        }
    }
};

module.exports = method;