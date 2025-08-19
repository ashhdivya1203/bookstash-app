importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDV7N00WlO_CHvsyGm4pFEHJ6ewTu1wNLI",
  authDomain: "mybookstash-66ecb.firebaseapp.com",
  projectId: "mybookstash-66ecb",
  storageBucket: "mybookstash-66ecb.appspot.com",
  messagingSenderId: "647501110429",
  appId: "1:647501110429:web:b12b3a2483080bcef70874",
  measurementId: "G-VE548VHMRP"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
