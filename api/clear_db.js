const mongoose = require('mongoose');

// --- CONFIGURATION ---
const _0x1f2e = 'bW9uZ29kYitzcnY6Ly9mcmVlemVlaG9zdDpGcmVlWmVlSG9zdDEyXy5AY2x1c3RlcjAudnl3dTV4dC5tb25nb2RiLm5ldC9GcmVlWmVlSG9zdD9yZXRyeVdyaXRlcz10cnVlJnc9bWFqb3JpdHkmYXBwTmFtZT1DbHVzdGVyMA==';
const MONGO_URI = Buffer.from(_0x1f2e, 'base64').toString();

const whitelistSchema = new mongoose.Schema({
    ip: String,
    license_key: String,
    custom_apikey: String,
    owner: String,
    status: { type: String, default: 'active' },
    createdAt: { type: Date, default: Date.now }
});

const Whitelist = mongoose.model('Whitelist', whitelistSchema);

async function clearData() {
    console.log('🗑️  Connecting to MongoDB to clear test data...');
    try {
        await mongoose.connect(MONGO_URI);
        const vpsIp = '157.245.157.188';

        const result = await Whitelist.deleteOne({ ip: vpsIp });
        if (result.deletedCount > 0) {
            console.log(`✅ Sukses! Data IP ${vpsIp} telah dihapus dari database.`);
        } else {
            console.log(`⚠️ Data IP ${vpsIp} tidak ditemukan (sudah kosong).`);
        }

        await mongoose.disconnect();
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

clearData();
