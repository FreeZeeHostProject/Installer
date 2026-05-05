const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyXy5AY2x1c3RlcjAudnl3dTV4dC5tb25nb2RiLm5ldC9GcmVlWmVlSG9zdD9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkmYXBwTmFtZT1DbHVzdGVyMA==';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();
const PORT = 3000;

mongoose.connect(MONGO_URI)
    .then(() => console.log('✅ Connected to MongoDB Atlas'))
    .catch(err => console.error('❌ Could not connect to MongoDB', err));

const whitelistSchema = new mongoose.Schema({
    ip: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    custom_apikey: { type: String, required: true },
    owner: String,
    status: { type: String, default: 'active' },
    createdAt: { type: Date, default: Date.now }
}, { collection: 'whitelist' });

const Whitelist = mongoose.model('Whitelist', whitelistSchema);

app.post('/check-ip', async (req, res) => {
    const vpsIp = req.body.ip;
    try {
        const found = await Whitelist.findOne({ ip: vpsIp, status: 'active' });
        if (found) return res.status(200).send('OK');
        return res.status(403).send('Forbidden');
    } catch (error) {
        res.status(500).send('Error');
    }
});

app.post('/verify-auth', async (req, res) => {
    const { ip, password, apikey } = req.body;
    try {
        const found = await Whitelist.findOne({ 
            ip: ip, 
            password: password, 
            custom_apikey: apikey, 
            status: 'active' 
        });

        if (found) return res.status(200).send('OK');
        return res.status(403).send('Forbidden');
    } catch (error) {
        res.status(500).send('Error');
    }
});

app.listen(PORT, () => {
    console.log(`🚀 FreeZeeHost API Online`);
});
