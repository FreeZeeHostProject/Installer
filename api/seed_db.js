const mongoose = require('mongoose');

// --- CONFIGURATION ---
const user = 'freezeehost';
const pass = encodeURIComponent('FreeZeeHost12_.');
const host = 'cluster0.vywu5xt.mongodb.net';
const dbName = 'FreeZeeHost';

const MONGO_URI = `mongodb+srv://${user}:${pass}@${host}/${dbName}?retryWrites=true&w=majority&appName=Cluster0`;

const whitelistSchema = new mongoose.Schema({
    ip: String,
    password: { type: String, required: true }, // Ini adalah Password dari Owner/Developer
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
        
        const vpsIp = '157.245.157.188';
        
        // Data unik dari Owner/Developer
        const update = { 
            password: 'OWNER-PASS-PREMIUM', // Password dari Owner
            custom_apikey: 'FZ-DEV-888-KEYS', // API Key dari Owner
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
