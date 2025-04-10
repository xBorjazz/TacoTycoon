// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyAswlq_ipTWfOlrgYvGg8Ivfm3hnKGvSmI",
  authDomain: "cucei-taco-tycoon.firebaseapp.com",
  projectId: "cucei-taco-tycoon",
  storageBucket: "cucei-taco-tycoon.firebasestorage.app",
  messagingSenderId: "322335987888",
  appId: "1:322335987888:web:49a916448502a25f3d0375",
  measurementId: "G-EHDFHM59R8"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);