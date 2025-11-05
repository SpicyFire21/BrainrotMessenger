import express from 'express'
const app = express();
import axios from "axios";
import http from "http";
import { Server } from "socket.io";
import pool from './database/db.js'

const PORT = 3000
const apiURL = `http://localhost:${PORT}`

const server = http.createServer(app);

const io = new Server(server, {
    cors: {
        origin: '*',
        methods: ['GET', 'POST']
    }
});

import messageRoute from './routes/message.router.js';
import userRoute from './routes/user.router.js';


app.use('/messages',messageRoute);
app.use('/users',userRoute);

io.on("connection", (socket) => {
    console.log("✅ Un utilisateur est connecté 🧦 :", socket.id);

    socket.on("typing",(data)=>{
        socket.broadcast.emit('typing',data);
    });

    socket.on("disconnect", () => {
        console.log("❌ Utilisateur déconnecté :", socket.id);
    });

    socket.on("chat-message", (data) => {
        console.log("📨 Nouveau message :", data);

        try {
            axios.post(`${apiURL}/messages/send`,data)
                .then(() => console.log("💾 Message enregistré dans la BDD"))
        }catch (e){
            console.error(e)
        }

        io.emit("chat-message", data); // broadcast à tous
    });
});


server.listen( PORT,() => {
    console.log(`API lancé sur ${apiURL}`);
    pool.connect((err) => {
        if (err) {
            console.error('Erreur de connexion à la base de données :', err);
        } else {
            console.log('Connexion à la base de données réussie 😏😏 ');
        }
    });
});

