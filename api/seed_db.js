const mongoose = require('mongoose');

// --- CONFIGURATION ---
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyXy5AY2x1c3RlcjAudnl3dTV4dC5tb25nb2RiLm5ldC9GcmVlWmVlSG9zdD9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkmYXBwTmFtZT1DbHVzdGVyMA==';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();

const whitelistSchema = new mongoose.Schema({
    ip: String,
    password: { type: String, required: true },
    custom_apikey: { type: String, required: true },
    owner: String,
    status: { type: String, default: 'active' },
    createdAt: { type: Date, default: Date.now }
}, { collection: 'whitelist' });

const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function seed() {
    console.log('Syncing Owner Credentials to MongoDB...');
    try {
        await mongoose.connect(MONGO_URI);
        
        // --- EDIT DATA DISINI UNTUK WHITELIST IP BARU ---
        const vpsIp = 'GANTI_DENGAN_IP_VPS'; 
        
        const update = { 
            password: 'GANTI_DENGAN_PASSWORD_ANDA', 
            custom_apikey: 'GANTI_DENGAN_API_KEY_ANDA', 
            owner: 'FreeZeeHost Official',
            status: 'active'
        };

        const doc = await Whitelist.findOneAndUpdate({ ip: vpsIp }, update, { 
            upsert: true, 
            new: true 
        });

        console.log(`✅ Success! Owner Credentials for IP ${vpsIp}:`);
        console.log(`   🔹 OWNER PASSWORD : ${doc.password}`);
        console.log(`   🔹 CUSTOM API KEY : ${doc.custom_apikey}`);

        await mongoose.disconnect();
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

seed();
