const chatService = require("../service/chat")

exports.insertchat = async (req, res) => {
    try {
        const chatdt = req.body
        await chatService.insertchat(chatdt)
        res.send({ status: 200 })
    } catch (e) {
        return res.send({ status: 400 });
    }
},
    exports.getchat = async (req, res) => {
        try {
            const chatId = req.params
            const result = await chatService.getchat(chatId.chatId)
            res.send({ status: 200, data: result })
        } catch (e) {
            return res.send({ status: 400 });
        }
    },
    exports.readchat = async (req, res) => {
        try {
            const { chatId, userId } = req.query
            const result = await chatService.readchat(chatId, userId)
            res.send({ status: 200, data: result })
        } catch (e) {
            return res.send({ status: 400 });
        }
    }

