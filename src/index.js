const express = require('express');
const { createServer } = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());

const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: "*", // In production, replace with your app's domain
    methods: ["GET", "POST"]
  }
});

// Store user socket mappings
const userSockets = new Map();

io.use((socket, next) => {
  const userId = socket.handshake.auth.userId;
  if (!userId) {
    return next(new Error("User ID not provided"));
  }
  socket.userId = userId;
  next();
});

io.on('connection', (socket) => {
  const userId = socket.userId;
  console.log(`User connected: ${userId}`);
  
  // Store user's socket
  userSockets.set(userId, socket);

  // Handle sending messages
  socket.on('send_message', (message) => {
    console.log('New message:', message);
    io.emit(`chat:${message.chatId}`, message);
  });

  // Handle typing indicators
  socket.on('typing', ({ chatId, userId, isTyping }) => {
    socket.to(`chat:${chatId}`).emit('typing', { userId, isTyping });
  });

  // Handle joining chat rooms
  socket.on('join_chat', (chatId) => {
    socket.join(`chat:${chatId}`);
    console.log(`User ${userId} joined chat ${chatId}`);
  });

  // Handle leaving chat rooms
  socket.on('leave_chat', (chatId) => {
    socket.leave(`chat:${chatId}`);
    console.log(`User ${userId} left chat ${chatId}`);
  });

  // Handle disconnection
  socket.on('disconnect', () => {
    console.log(`User disconnected: ${userId}`);
    userSockets.delete(userId);
  });
});

const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`🚀 Socket.IO server running on port ${PORT}`);
});
