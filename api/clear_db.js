const mongoose = require('mongoose');

// --- CONFIGURATION ---
const user = 'freezeehost';
const pass = encodeURIComponent('FreeZeeHost12_.');
const host = 'cluster0.vywu5xt.mongodb.net';
const dbName = 'FreeZeeHost';

const MONGO_URI = `mongodb+srv://${user}:${pass}@${host}/${dbName}?retryWrites=true&w=majority&appName=Cluster0`;

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
