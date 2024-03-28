exports.upload = async (req, res) => {
    try {
        const { file } = req.file
        res.send({ status: 200 })
    } catch (e) {
        console.log(e.message)
        res.send({ status: 400 });
    }
};