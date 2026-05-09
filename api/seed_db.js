const mongoose = require('mongoose');

// --- CONFIGURATION (Original Working URI) ---
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyXy5AY2x1c3RlcjAudnl3dTV4dC5tb25nb2RiLm5ldC9GcmVlWmVlSG9zdD9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkmYXBwTmFtZT1DbHVzdGVyMA==';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();

const whitelistSchema = new mongoose.Schema({
    ip: String,
    password: { type: String },
    custom_apikey: { type: String },
    owner: { type: String, default: 'FreeZeeHost Official' },
    status: { type: String, default: 'active' }
}, { collection: 'whitelist' });

const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function seed() {
    console.log('🚀 Connecting to MongoDB Atlas...');
    try {
        await mongoose.connect(MONGO_URI);
        console.log('✅ Connected successfully!');
        
        const vpsIp = '157.245.157.188';
        const update = { 
            password: 'FreeZeeHost12', 
            custom_apikey: 'FreeZeeHost12',
            status: 'active'
        };

        await Whitelist.findOneAndUpdate({ ip: vpsIp }, update, { upsert: true });

        console.log('\n🌟 WHITELIST SUCCESSFUL 🌟');
        console.log(`🔹 IP TARGET    : ${vpsIp}`);
        console.log(`🔹 OWNER PASS   : FreeZeeHost12`);
        console.log(`🔹 API KEY      : FreeZeeHost12`);
        await mongoose.disconnect();
    } catch (error) {
        console.error('\n❌ GAGAL KONEKSI:', error.message);
    }
}
seed();
