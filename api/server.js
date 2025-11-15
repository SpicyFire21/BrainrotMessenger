import express from 'express'
const app = express();
import axios from "axios";
import http from "http";
import { Server } from "socket.io";
import pool from './database/db.js'
import cors from 'cors'
import bodyParser from "body-parser";

const PORT = 3000
const apiURL = `http://localhost:${PORT}`

app.use(express.json()); // obligatoire
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors({origin: 'http://localhost:5173'}));

const server = http.createServer(app);

const io = new Server(server, {
    cors: {
        origin: '*',
        methods: ['GET', 'POST']
    }
});

import messageRoute from './routes/message.router.js';
import userRoute from './routes/user.router.js';
import MessageService from "./services/message.service.js";



app.use('/messages',messageRoute);
app.use('/users',userRoute);

io.on("connection", (socket) => {

    socket.on("typing",(data)=>{
        socket.broadcast.emit('typing',data);
    });

    socket.on("disconnect", () => {
    });

    socket.on("chat-message", async (data) => {

        try {
            //save du message en bdd
            // await MessageService.addMessage(data);
            await axios.post(`${apiURL}/messages/send`,data)
            io.emit("chat-message", data);
        }catch (e){
            console.error(e)
        }

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

