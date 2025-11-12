const pool = require('../database/db');
const { encrypt, decrypt } = require('./RSA');

// Chiffrement avant envoi (avec la clé publique du destinataire)
async function rsaEncryptMiddleware(req, res, next) {
    try {
        const { receiverId, message } = req.body;
        if (!receiverId || !message) return next();

        const result = await pool.query(
            'SELECT public_key, rsa_modulo FROM users WHERE id = $1',
            [receiverId]
        );
        if (result.rows.length === 0) return next();

        const { public_key, rsa_modulo } = result.rows[0];
        const e = BigInt(public_key);
        const n = BigInt(rsa_modulo);

        const cipher = encrypt(message, e, n);
        req.body.message = JSON.stringify(cipher);
        next();
    } catch (err) {
        console.error('Erreur chiffrement RSA :', err);
        next();
    }
}

// Déchiffrement à la réception (avec la clé privée du destinataire connecté)
async function rsaDecryptMiddleware(req, res, next) {
    try {
        const { userId } = req; // supposé être défini par auth middleware
        if (!res.locals.data || !res.locals.data.message || !userId) return next();

        const result = await pool.query(
            'SELECT private_key, rsa_modulo FROM users WHERE id = $1',
            [userId]
        );
        if (result.rows.length === 0) return next();

        const { private_key, rsa_modulo } = result.rows[0];
        const d = BigInt(private_key);
        const n = BigInt(rsa_modulo);

        const cipher = JSON.parse(res.locals.data.message);
        res.locals.data.message = decrypt(cipher, d, n);
        next();
    } catch (err) {
        console.error('Erreur déchiffrement RSA :', err);
        next();
    }
}

module.exports = { rsaEncryptMiddleware, rsaDecryptMiddleware };
