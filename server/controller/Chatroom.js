const chatroomService = require('../service/Chatroom')
const chatService = require("../service/chat")

exports.insertChatroom = async (req, res) => {
    try {
        const obj = req.body
        const chatroomId = await chatroomService.insert(obj)
        obj.chatroomId = chatroomId.insertId
        await chatService.insert(obj)

        return
    } catch (e) {
        console.log(e.message)
        return res.send({ status: 400 });
    }
},

    exports.joinchat = async (req, res) => {
        try {
            const obj = req.query
            const chatroomId = await chatroomService.findcharoomidbymatchid(obj.MatchId)
            obj.chatroomId = chatroomId
            await chatService.insert(obj)

            res.send({ status: 200 })
        } catch (e) {
            console.log(e.message)
            return res.send({ status: 400 });
        }
    },
    exports.chats = async (req, res) => {
        try {
            const { userId } = req.params
            const chats = await chatroomService.chats(userId)
            res.send({ status: 200, chats: chats })
        } catch (e) {
            console.log(e.message)
            return res.send({ status: 400 });
        }
    },
    exports.readchat = async (req, res) => {
        try {
            const { userId, chatId } = req.query
            await chatroomService.readchat(userId, chatId)
            res.send({ status: 200 })
        } catch (e) {
            console.log(e.message)
            return res.send({ status: 400 });
        }
    }





// exports.getlistchat = async (req, res) => {
//     try {
//         const { userId } = req.params
//         const data = Service.getlistchat(userId)
//         res.send("ok")
//     } catch (e) {
//         console.log(e.message)
//         return res.send({ status: 400 });
//     }
// }

