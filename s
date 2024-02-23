<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Real-time Chat</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }
    .chat-container {
        width: 400px;
        margin: 20px auto;
        border: 1px solid #ccc;
        border-radius: 5px;
        overflow: hidden;
    }
    .chat-box {
        height: 300px;
        overflow-y: auto;
        padding: 10px;
    }
    .message {
        margin-bottom: 10px;
    }
    input[type="text"] {
        width: calc(100% - 20px);
        padding: 5px 10px;
        margin: 0;
    }
    button {
        width: calc(100% - 20px);
        padding: 8px 0;
        margin: 0;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
</style>
</head>
<body>
<div class="chat-container">
    <div class="chat-box" id="chat-box"></div>
    <input type="text" id="message-input" placeholder="Type your message here...">
    <button onclick="sendMessage()">Send</button>
</div>

<script src="https://www.gstatic.com/firebasejs/9.6.8/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.6.8/firebase-firestore.js"></script>
<script>
    // Replace this with your own Firebase project configuration
    const firebaseConfig = {
        apiKey: "YOUR_API_KEY",
        authDomain: "YOUR_AUTH_DOMAIN",
        projectId: "YOUR_PROJECT_ID",
        storageBucket: "YOUR_STORAGE_BUCKET",
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
        appId: "YOUR_APP_ID",
        measurementId: "YOUR_MEASUREMENT_ID"
    };
    
    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
    
    const db = firebase.firestore();
    
    const chatBox = document.getElementById('chat-box');
    const messageInput = document.getElementById('message-input');
    
    function sendMessage() {
        const messageText = messageInput.value.trim();
        if (messageText !== '') {
            db.collection('messages').add({
                text: messageText,
                timestamp: firebase.firestore.FieldValue.serverTimestamp()
            });
            messageInput.value = '';
        }
    }
    
    function displayMessage(message) {
        const msgElement = document.createElement('div');
        msgElement.classList.add('message');
        msgElement.textContent = message.text;
        chatBox.appendChild(msgElement);
        chatBox.scrollTop = chatBox.scrollHeight;
    }
    
    // Listen for new messages in real-time
    db.collection('messages').orderBy('timestamp').onSnapshot(snapshot => {
        snapshot.docChanges().forEach(change => {
            if (change.type === 'added') {
                displayMessage(change.doc.data());
            }
        });
    });
</script>
</body>
</html>
