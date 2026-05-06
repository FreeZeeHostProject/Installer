const mongoose = require('mongoose');

// --- CONFIGURATION (Updated with your credentials) ---
// MongoDB URI with updated password 'FreeZeeHost12'
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyQGNsdXN0ZXIwLnZ5d3U1eHQubW9uZ29kYi5uZXQvRnJlZVplZUhvc3Q/cmV0cnlXcml0ZXM9dHJ1ZSZ3PW1ham9yaXR5JmFwcE5hbWU9Q2x1c3RlcjA=';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();

const whitelistSchema = new mongoose.Schema({
    ip: String,
    password: { type: String },
    custom_apikey: { type: String },
    owner: String,
    status: { type: String, default: 'active' }
}, { collection: 'whitelist' });

const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function seed() {
    console.log('🚀 Connecting to MongoDB Atlas...');
    try {
        await mongoose.connect(MONGO_URI);
        console.log('✅ Connected successfully!');
        
        const vpsIp = '157.245.157.188'; // IP VPS kamu
        
        const update = { 
            password: 'FreeZeeHost12', 
            custom_apikey: 'FreeZeeHost12', 
            owner: 'FreeZeeHost Official',
            status: 'active'
        };

        const doc = await Whitelist.findOneAndUpdate({ ip: vpsIp }, update, { 
            upsert: true, 
            new: true 
        });

        console.log('\n🌟 WHITELIST SUCCESSFUL 🌟');
        console.log(`🔹 IP TARGET    : ${vpsIp}`);
        console.log(`🔹 OWNER PASS   : ${doc.password}`);
        console.log(`🔹 API KEY      : ${doc.custom_apikey}`);
        console.log('\nSekarang kamu bisa menjalankan install.sh dengan lancar!');

        await mongoose.disconnect();
    } catch (error) {
        console.error('\n❌ GAGAL KONEKSI:', error.message);
        console.log('\nTips: Pastikan kamu sudah "Allow Access from Anywhere" (0.0.0.0/0)');
        console.log('di Dashboard MongoDB Atlas -> Network Access.');
    }
}

seed();
