---
description: "Guidelines for integrating Firebase backend services with Astro applications"
globs: "*.astro,*.ts,astro.config.*,env.d.ts"
---

# Firebase + Astro Integration Setup Guide

This guide provides step-by-step instructions for integrating Firebase with an Astro application.

## Prerequisites
- Node.js and npm installed
- Astro project initialized
- Firebase account and project created

## Installation

1. Install required dependencies:
```bash
npm install firebase firebase-admin @astrojs/node
```

2. Install Firebase CLI globally:
```bash
npm install -g firebase-tools
```

## Configuration

1. Initialize Firebase in your project:
```bash
firebase init hosting
firebase experiments:enable webframeworks
```

2. Create a new file `src/lib/firebase.client.ts` for client-side Firebase configuration:
```typescript
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: import.meta.env.PUBLIC_FIREBASE_API_KEY,
  authDomain: import.meta.env.PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.PUBLIC_FIREBASE_APP_ID
};

// Initialize Firebase for client-side
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
```

3. Create a new file `src/lib/firebase.server.ts` for server-side Firebase Admin configuration:
```typescript
import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

if (!getApps().length) {
  initializeApp({
    credential: cert({
      projectId: import.meta.env.FIREBASE_PROJECT_ID,
      clientEmail: import.meta.env.FIREBASE_CLIENT_EMAIL,
      privateKey: import.meta.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n')
    })
  });
}

export const adminAuth = getAuth();
export const adminDb = getFirestore();
```

4. Update `astro.config.mjs` to enable SSR:
```typescript
import { defineConfig } from 'astro/config';
import node from '@astrojs/node';

export default defineConfig({
  output: 'server',
  adapter: node({
    mode: 'middleware'
  }),
  vite: {
    ssr: {
      noExternal: ['firebase', 'firebase-admin']
    }
  }
});
```

## Usage Examples

### Authentication Component
```astro
---
// src/components/Auth.astro
import { auth } from '../lib/firebase.client';
import { signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut } from 'firebase/auth';

let error = null;

if (Astro.request.method === 'POST') {
  const formData = await Astro.request.formData();
  const action = formData.get('action');
  const email = formData.get('email') as string;
  const password = formData.get('password') as string;

  try {
    if (action === 'login') {
      await signInWithEmailAndPassword(auth, email, password);
      return Astro.redirect('/dashboard');
    } else if (action === 'register') {
      await createUserWithEmailAndPassword(auth, email, password);
      return Astro.redirect('/dashboard');
    } else if (action === 'logout') {
      await signOut(auth);
      return Astro.redirect('/');
    }
  } catch (e: any) {
    error = e.message;
  }
}
---

<div>
  <form method="post">
    <div>
      <label for="email">Email:</label>
      <input
        id="email"
        name="email"
        type="email"
        required
      />
    </div>
    <div>
      <label for="password">Password:</label>
      <input
        id="password"
        name="password"
        type="password"
        required
      />
    </div>
    <div>
      <button type="submit" name="action" value="login">
        Login
      </button>
      <button type="submit" name="action" value="register">
        Register
      </button>
    </div>
    {error && <p class="error">{error}</p>}
  </form>
</div>

<script>
  import { auth } from '../lib/firebase.client';
  import { onAuthStateChanged } from 'firebase/auth';

  onAuthStateChanged(auth, (user) => {
    if (user) {
      console.log('User is signed in:', user);
    } else {
      console.log('User is signed out');
    }
  });
</script>
```

### Protected Page
```astro
---
// src/pages/dashboard.astro
import { adminAuth } from '../lib/firebase.server';

// Check authentication
const sessionCookie = Astro.cookies.get('session')?.value;

if (!sessionCookie) {
  return Astro.redirect('/login');
}

try {
  const decodedClaim = await adminAuth.verifySessionCookie(sessionCookie);
  const user = await adminAuth.getUser(decodedClaim.uid);
} catch (error) {
  Astro.cookies.delete('session');
  return Astro.redirect('/login');
}
---

<div>
  <h1>Welcome to Dashboard</h1>
  <form method="post" action="/auth">
    <input type="hidden" name="action" value="logout" />
    <button type="submit">Logout</button>
  </form>
</div>
```

### Firestore Data Management
```astro
---
// src/pages/todos.astro
import { adminDb } from '../lib/firebase.server';

let todos = [];
let error = null;

// Handle form submission
if (Astro.request.method === 'POST') {
  const formData = await Astro.request.formData();
  const action = formData.get('action');
  const title = formData.get('title');
  const id = formData.get('id');

  try {
    switch (action) {
      case 'create':
        await adminDb.collection('todos').add({
          title,
          completed: false,
          createdAt: new Date()
        });
        break;
      case 'toggle':
        const doc = await adminDb.collection('todos').doc(id).get();
        await doc.ref.update({
          completed: !doc.data().completed
        });
        break;
      case 'delete':
        await adminDb.collection('todos').doc(id).delete();
        break;
    }
  } catch (e) {
    error = e.message;
  }
}

// Fetch todos
try {
  const snapshot = await adminDb.collection('todos')
    .orderBy('createdAt', 'desc')
    .limit(10)
    .get();
  
  todos = snapshot.docs.map(doc => ({
    id: doc.id,
    ...doc.data()
  }));
} catch (e) {
  error = e.message;
}
---

<div>
  <form method="post">
    <input
      type="text"
      name="title"
      placeholder="New todo"
      required
    />
    <input type="hidden" name="action" value="create" />
    <button type="submit">Add</button>
  </form>

  {error && <p class="error">{error}</p>}

  <ul>
    {todos.map((todo) => (
      <li>
        <form method="post" style="display: inline">
          <input type="hidden" name="id" value={todo.id} />
          <input type="hidden" name="action" value="toggle" />
          <button type="submit">
            {todo.completed ? '✓' : '○'}
          </button>
        </form>
        <span style={`text-decoration: ${todo.completed ? 'line-through' : 'none'}`}>
          {todo.title}
        </span>
        <form method="post" style="display: inline">
          <input type="hidden" name="id" value={todo.id} />
          <input type="hidden" name="action" value="delete" />
          <button type="submit">Delete</button>
        </form>
      </li>
    ))}
  </ul>
</div>
```

### File Storage
```astro
---
// src/pages/files.astro
import { adminStorage } from '../lib/firebase.server';

let files = [];
let error = null;

// Handle file upload
if (Astro.request.method === 'POST') {
  const formData = await Astro.request.formData();
  const file = formData.get('file');
  const action = formData.get('action');

  try {
    if (action === 'upload' && file instanceof Blob) {
      const buffer = Buffer.from(await file.arrayBuffer());
      const filename = `${Date.now()}-${file.name}`;
      await adminStorage.bucket().file(filename).save(buffer);
    } else if (action === 'delete') {
      const filename = formData.get('filename');
      await adminStorage.bucket().file(filename).delete();
    }
  } catch (e) {
    error = e.message;
  }
}

// Fetch files
try {
  const [filesList] = await adminStorage.bucket().getFiles();
  files = await Promise.all(
    filesList.map(async (file) => {
      const [url] = await file.getSignedUrl({
        action: 'read',
        expires: Date.now() + 60 * 60 * 1000 // 1 hour
      });
      return {
        name: file.name,
        url
      };
    })
  );
} catch (e) {
  error = e.message;
}
---

<div>
  <form method="post" enctype="multipart/form-data">
    <input
      type="file"
      name="file"
      accept="image/*"
      required
    />
    <input type="hidden" name="action" value="upload" />
    <button type="submit">Upload</button>
  </form>

  {error && <p class="error">{error}</p>}

  <ul>
    {files.map((file) => (
      <li>
        <a href={file.url} target="_blank" rel="noopener noreferrer">
          {file.name}
        </a>
        <form method="post" style="display: inline">
          <input type="hidden" name="filename" value={file.name} />
          <input type="hidden" name="action" value="delete" />
          <button type="submit">Delete</button>
        </form>
      </li>
    ))}
  </ul>
</div>
```

## Security Considerations
1. Never expose Firebase configuration in client-side code without proper security measures
2. Use environment variables for sensitive configuration
3. Implement proper session management
4. Set up appropriate Firebase security rules
5. Use Firebase Admin SDK for server-side operations
6. Implement proper CSRF protection
7. Validate all user input server-side
8. Use secure session cookies

## Best Practices
1. Use TypeScript for better type safety
2. Separate client and server-side Firebase configurations
3. Implement proper error handling
4. Use Astro's built-in form handling
5. Implement proper loading states
6. Use Firebase emulators for local development
7. Follow Astro's patterns for data mutations
8. Implement proper data validation
9. Use Firebase indexes for complex queries

## Troubleshooting
1. Check Firebase console for errors
2. Verify security rules configuration
3. Check network requests in browser developer tools
4. Use Firebase debugging tools
5. Monitor Firebase usage and quotas
6. Check Astro server logs
7. Verify environment variables

## Additional Resources
- [Firebase Documentation](https://firebase.google.com/docs)
- [Astro Documentation](https://docs.astro.build)
- [Firebase Console](https://console.firebase.google.com/) 