const chatroomRepo = require('../repository/Chatroom')
const matchRepo = require('../repository/Match')
const locationHelper = require('../helper/locaiton')
const datehelper = require('../helper/date')

const method = {
    getlistchat: async function (userId) {
        try {
            const data = await chatroomRepo.getlistchat(userId)
            return data;
        } catch (error) {
            throw error;
        }
    },
    insert: async function (obj) {
        try {
            const chatId = await chatroomRepo.insert(obj)
            return chatId
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    findcharoomidbymatchid: async function (MatchId) {
        try {
            const chatId = await chatroomRepo.findcharoomidbymatchid(MatchId)
            return chatId
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    chats: async function (userId) {
        try {
            const chats = await chatroomRepo.chats(userId)
            console.log(chats)
            const result = []
            for (const chat of chats) {
                const _ = {}
                if (chat.type) {
                    const userinfo = await chatroomRepo.privatechat(userId, chat.ChatID)
                    const count = await matchRepo.getmatchuserjoin(chat.MatchId)
                    console.log(userinfo)
                    _.name = userinfo[0].firstName
                    _.photo = userinfo[0].photo
                    _.message = chat.message
                    _.time = await datehelper.checkdate(chat.time)
                    _.ChatID = chat.ChatID
                    _.readed = chat.readed
                    _.count = count.length
                    result.push(_)
                } else {
                    const matchinfo = await matchRepo.getinfo(chat.MatchId)
                    const matchinfo_ = await locationHelper.getdetailone(matchinfo)
                    const count = await matchRepo.getmatchuserjoin(chat.MatchId)
                    _.name = matchinfo_[0].matchName
                    _.photo = matchinfo_[0].photo
                    _.message = chat.message
                    _.time = await datehelper.checkdate(chat.time)
                    _.ChatID = chat.ChatID
                    _.readed = chat.readed
                    _.count = count.length

                    result.push(_)
                }
            }
            return result
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },
    readchat: async function (userId, chatId) {
        try {
            await chatroomRepo.readchat(userId, chatId)
            return
        } catch (e) {
            console.log(e.message)
            throw e;
        }
    },

};

module.exports = method;