import pool from '../database/db.js'

import {encrypt,decrypt} from "./RSA.js";

// Chiffrement avant envoi (avec la clé publique du destinataire)
export async function rsaEncryptMiddleware(req, res, next) {
    console.log("encrypt")
    try {
        const {  receiverid, content } = req.body;
        if (! receiverid || !content) return next();

        const result = await pool.query(
            'SELECT public_key, rsa_modulo FROM users WHERE id = $1',
            [ receiverid]
        );
        if (result.rows.length === 0) return next();

        const { public_key, rsa_modulo } = result.rows[0];
        const e = Number(public_key);
        const n = Number(rsa_modulo);

        const cipher = encrypt(content, e, n);
        console.log("e",e);
        console.log("n",n);
        console.log("cipher",cipher);
        req.body.content = JSON.stringify(cipher);
        next();
    } catch (err) {
        console.error('Erreur chiffrement RSA :', err);
        next();
    }
}

// Déchiffrement à la réception (avec la clé privée du destinataire connecté)
export async function rsaDecryptMiddleware(req, res, next) {
    try {
        const { receiverid } = req.params;
        if (!receiverid) return next();

        const result = await pool.query(
            'SELECT private_key, rsa_modulo FROM users WHERE id = $1',
            [receiverid]
        );
        if (result.rows.length === 0) return next();

        const { private_key, rsa_modulo } = result.rows[0];
        const d = Number(private_key);
        const n = Number(rsa_modulo);

        if (Array.isArray(res.locals.data.data)) {
            res.locals.data.data = res.locals.data.data.map(msg => {
                if(msg.content) {
                    msg.content = decrypt(JSON.parse(msg.content), d, n);
                }
                return msg;
            });
        }
        console.log(res.locals.data.data)
        next();
    } catch (err) {
        console.error('Erreur déchiffrement RSA :', err);
        next(err);
    }
}


