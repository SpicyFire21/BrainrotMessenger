import express from 'express';
import * as messageController from "../controller/message.controller.js";

var router = express.Router();

router.get("/",messageController.getMessages);
router.post('/send',messageController.addMessage);

router.get("/sender/:senderid",messageController.getMessageBySenderid);
router.get("/receiver/:receiverid",messageController.getMessageByReceiverid);
router.get("/conversation/:receiverid/:senderid",messageController.getConversation)


router.get("/:id",messageController.getMessageById);
router.put('/:id',messageController.updateMessageById);
router.delete('/:id',messageController.deleteMessageById);

export default router;
