import { io } from "socket.io-client";

const URL = "https://api-brainrot-messenger.onrender.com/"; //url de l'api

export const socket = io(URL, {
    autoConnect: false, // connexion manuelle
});

window.socket = socket; // <- rend disponible dans la console dev
