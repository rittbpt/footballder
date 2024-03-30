const friendService = require('../service/friend')

exports.getfriends = async (req, res) => {
    try {
        const { userId } = req.params
        const data = await friendService.getfriends(userId)
        res.send({status: 200 , data : data})
    } catch (e) {
        console.log(e.message)
        return res.send({ status: 400 });
    }
}

exports.insert = async (req, res) => {
    try {
        const { userId , friendId } = req.body
        const data = await friendService.insert(userId , friendId)  
        res.send({status: 200 , data : data.length === 0 ? "Already friend" : "Add friend success"})
    } catch (e) {
        console.log(e.message)
        return res.send({ status: 400 });
    }
}

exports.remove = async (req, res) => {
    try {
        const { userId , friendId } = req.body
        await friendService.remove(userId , friendId)  
        res.send({status: 200 })
    } catch (e) {
        console.log(e.message)
        return res.send({ status: 400 });
    }
}


