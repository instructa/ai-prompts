---
description: "Guidelines for integrating Firebase backend services with JavaScript applications"
globs: "*.js,*.mjs,*.cjs,*.html"
---

# Firebase + JavaScript Integration Setup Guide

This guide provides step-by-step instructions for integrating Firebase with a vanilla JavaScript application.

## Prerequisites
- Web server or development environment
- Firebase account and project created
- Basic understanding of JavaScript and web development

## Installation

1. Add the Firebase SDK to your HTML file:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Firebase + JavaScript App</title>
</head>
<body>
    <!-- Firebase App (the core Firebase SDK) -->
    <script type="module">
        import { initializeApp } from 'https://www.gstatic.com/firebasejs/11.3.0/firebase-app.js';
        import { getAuth } from 'https://www.gstatic.com/firebasejs/11.3.0/firebase-auth.js';
        import { getFirestore } from 'https://www.gstatic.com/firebasejs/11.3.0/firebase-firestore.js';
        import { getStorage } from 'https://www.gstatic.com/firebasejs/11.3.0/firebase-storage.js';

        // Your web app's Firebase configuration
        const firebaseConfig = {
            apiKey: "your-api-key",
            authDomain: "your-project.firebaseapp.com",
            projectId: "your-project-id",
            storageBucket: "your-project.appspot.com",
            messagingSenderId: "your-messaging-sender-id",
            appId: "your-app-id"
        };

        // Initialize Firebase
        const app = initializeApp(firebaseConfig);
        const auth = getAuth(app);
        const db = getFirestore(app);
        const storage = getStorage(app);

        // Make Firebase services available globally
        window.auth = auth;
        window.db = db;
        window.storage = storage;
    </script>

    <!-- Your application code -->
    <script src="js/app.js" defer></script>
</body>
</html>
```

## Usage Examples

### Authentication
```javascript
// js/auth.js
class Auth {
    constructor() {
        this.auth = window.auth;
        this.setupAuthUI();
        this.setupAuthStateListener();
    }

    setupAuthUI() {
        const loginForm = document.getElementById('loginForm');
        const signupForm = document.getElementById('signupForm');
        const logoutButton = document.getElementById('logout');

        loginForm?.addEventListener('submit', async (e) => {
            e.preventDefault();
            const email = e.target.email.value;
            const password = e.target.password.value;

            try {
                await this.login(email, password);
                loginForm.reset();
            } catch (error) {
                console.error('Login failed:', error);
                this.showError(error.message);
            }
        });

        signupForm?.addEventListener('submit', async (e) => {
            e.preventDefault();
            const email = e.target.email.value;
            const password = e.target.password.value;

            try {
                await this.signup(email, password);
                signupForm.reset();
            } catch (error) {
                console.error('Signup failed:', error);
                this.showError(error.message);
            }
        });

        logoutButton?.addEventListener('click', () => this.logout());
    }

    setupAuthStateListener() {
        this.auth.onAuthStateChanged((user) => {
            if (user) {
                console.log('User is signed in:', user);
                this.updateUI(true);
            } else {
                console.log('User is signed out');
                this.updateUI(false);
            }
        });
    }

    async login(email, password) {
        return await this.auth.signInWithEmailAndPassword(email, password);
    }

    async signup(email, password) {
        return await this.auth.createUserWithEmailAndPassword(email, password);
    }

    async logout() {
        try {
            await this.auth.signOut();
        } catch (error) {
            console.error('Logout failed:', error);
            this.showError(error.message);
        }
    }

    updateUI(isLoggedIn) {
        const authForms = document.getElementById('authForms');
        const userContent = document.getElementById('userContent');
        
        if (isLoggedIn) {
            authForms?.classList.add('hidden');
            userContent?.classList.remove('hidden');
        } else {
            authForms?.classList.remove('hidden');
            userContent?.classList.add('hidden');
        }
    }

    showError(message) {
        const errorDiv = document.getElementById('error');
        if (errorDiv) {
            errorDiv.textContent = message;
            errorDiv.classList.remove('hidden');
            setTimeout(() => {
                errorDiv.classList.add('hidden');
            }, 5000);
        }
    }
}

// Initialize authentication
const auth = new Auth();
```

### Firestore Data Management
```javascript
// js/database.js
class Database {
    constructor() {
        this.db = window.db;
        this.setupUI();
    }

    setupUI() {
        const addForm = document.getElementById('addForm');
        addForm?.addEventListener('submit', async (e) => {
            e.preventDefault();
            const data = {
                title: e.target.title.value,
                content: e.target.content.value,
                createdAt: new Date()
            };

            try {
                await this.addDocument('posts', data);
                addForm.reset();
                this.loadDocuments();
            } catch (error) {
                console.error('Failed to add document:', error);
                this.showError(error.message);
            }
        });

        // Initial load
        this.loadDocuments();
    }

    async addDocument(collection, data) {
        try {
            const docRef = await this.db.collection(collection).add(data);
            console.log('Document written with ID:', docRef.id);
            return docRef;
        } catch (error) {
            console.error('Error adding document:', error);
            throw error;
        }
    }

    async getDocuments(collection, queries = []) {
        try {
            let ref = this.db.collection(collection);
            
            // Apply queries if any
            queries.forEach(query => {
                ref = ref.where(query.field, query.operator, query.value);
            });

            const snapshot = await ref.get();
            return snapshot.docs.map(doc => ({
                id: doc.id,
                ...doc.data()
            }));
        } catch (error) {
            console.error('Error getting documents:', error);
            throw error;
        }
    }

    async updateDocument(collection, id, data) {
        try {
            await this.db.collection(collection).doc(id).update(data);
            console.log('Document updated:', id);
        } catch (error) {
            console.error('Error updating document:', error);
            throw error;
        }
    }

    async deleteDocument(collection, id) {
        try {
            await this.db.collection(collection).doc(id).delete();
            console.log('Document deleted:', id);
        } catch (error) {
            console.error('Error deleting document:', error);
            throw error;
        }
    }

    async loadDocuments() {
        try {
            const posts = await this.getDocuments('posts');
            this.renderDocuments(posts);
        } catch (error) {
            console.error('Error loading documents:', error);
            this.showError(error.message);
        }
    }

    renderDocuments(documents) {
        const container = document.getElementById('posts');
        if (!container) return;

        container.innerHTML = documents.map(doc => `
            <div class="post" data-id="${doc.id}">
                <h3>${doc.title}</h3>
                <p>${doc.content}</p>
                <button onclick="db.deleteDocument('posts', '${doc.id}')">Delete</button>
            </div>
        `).join('');
    }

    showError(message) {
        const errorDiv = document.getElementById('error');
        if (errorDiv) {
            errorDiv.textContent = message;
            errorDiv.classList.remove('hidden');
            setTimeout(() => {
                errorDiv.classList.add('hidden');
            }, 5000);
        }
    }
}

// Initialize database
const db = new Database();
```

### File Storage
```javascript
// js/storage.js
class Storage {
    constructor() {
        this.storage = window.storage;
        this.setupUI();
    }

    setupUI() {
        const uploadForm = document.getElementById('uploadForm');
        uploadForm?.addEventListener('submit', async (e) => {
            e.preventDefault();
            const file = e.target.file.files[0];
            if (!file) return;

            try {
                const url = await this.uploadFile(file);
                this.addFileToList(file.name, url);
                uploadForm.reset();
            } catch (error) {
                console.error('Upload failed:', error);
                this.showError(error.message);
            }
        });

        // Initial load
        this.loadFiles();
    }

    async uploadFile(file) {
        try {
            const path = `uploads/${Date.now()}_${file.name}`;
            const ref = this.storage.ref().child(path);
            await ref.put(file);
            return await ref.getDownloadURL();
        } catch (error) {
            console.error('Error uploading file:', error);
            throw error;
        }
    }

    async deleteFile(path) {
        try {
            const ref = this.storage.ref().child(path);
            await ref.delete();
            console.log('File deleted:', path);
        } catch (error) {
            console.error('Error deleting file:', error);
            throw error;
        }
    }

    async loadFiles() {
        try {
            const ref = this.storage.ref().child('uploads');
            const result = await ref.listAll();
            
            const files = await Promise.all(
                result.items.map(async (item) => ({
                    name: item.name,
                    url: await item.getDownloadURL()
                }))
            );

            this.renderFiles(files);
        } catch (error) {
            console.error('Error loading files:', error);
            this.showError(error.message);
        }
    }

    addFileToList(name, url) {
        const container = document.getElementById('files');
        if (!container) return;

        const div = document.createElement('div');
        div.className = 'file';
        div.innerHTML = `
            <a href="${url}" target="_blank">${name}</a>
            <button onclick="storage.deleteFile('uploads/${name}')">Delete</button>
        `;
        container.appendChild(div);
    }

    renderFiles(files) {
        const container = document.getElementById('files');
        if (!container) return;

        container.innerHTML = files.map(file => `
            <div class="file">
                <a href="${file.url}" target="_blank">${file.name}</a>
                <button onclick="storage.deleteFile('uploads/${file.name}')">Delete</button>
            </div>
        `).join('');
    }

    showError(message) {
        const errorDiv = document.getElementById('error');
        if (errorDiv) {
            errorDiv.textContent = message;
            errorDiv.classList.remove('hidden');
            setTimeout(() => {
                errorDiv.classList.add('hidden');
            }, 5000);
        }
    }
}

// Initialize storage
const storage = new Storage();
```

## Security Considerations
1. Never expose Firebase configuration in client-side code without proper security measures
2. Implement proper authentication state management
3. Use environment variables for sensitive configuration
4. Set up appropriate Firestore security rules
5. Implement proper file upload restrictions
6. Use Firebase App Check for additional security
7. Implement proper error handling for all operations

## Best Practices
1. Structure your Firebase services in modules
2. Implement proper error handling
3. Use async/await for better code readability
4. Implement proper loading states
5. Use Firebase emulators for local development
6. Follow JavaScript best practices and patterns
7. Implement proper data validation
8. Use Firebase indexes for complex queries

## Troubleshooting
1. Check Firebase console for errors
2. Verify security rules configuration
3. Check network requests in browser developer tools
4. Use Firebase debugging tools
5. Monitor Firebase usage and quotas
6. Check browser console for errors
7. Verify environment variables

## Additional Resources
- [Firebase Documentation](https://firebase.google.com/docs)
- [JavaScript MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
- [Firebase Console](https://console.firebase.google.com/) 