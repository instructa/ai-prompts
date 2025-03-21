---
description: "Guidelines for integrating Firebase backend services with Remix applications"
globs: "*.tsx,*.ts,app/**/*,server/**/*,remix.config.*"
---

# Firebase + Remix Integration Setup Guide

This guide provides step-by-step instructions for integrating Firebase with a Remix application.

## Prerequisites
- Node.js and npm installed
- Remix project initialized
- Firebase account and project created

## Installation

1. Install required dependencies:
```bash
npm install firebase firebase-admin
```

## Configuration

2. Create a new file `app/services/firebase.client.ts` for client-side Firebase configuration:
```typescript
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore/lite';
import { getStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID
};

// Initialize Firebase for client-side
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
```

3. Create a new file `app/services/firebase.server.ts` for server-side Firebase Admin configuration:
```typescript
import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

if (!getApps().length) {
  initializeApp({
    credential: cert({
      projectId: process.env.FIREBASE_PROJECT_ID,
      clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
      privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n')
    })
  });
}

export const adminAuth = getAuth();
export const adminDb = getFirestore();
```

## Usage Examples

### Authentication Route (app/routes/auth.tsx)
```typescript
import { json, redirect } from '@remix-run/node';
import { Form, useActionData, useLoaderData } from '@remix-run/react';
import { auth } from '~/services/firebase.client';
import { adminAuth } from '~/services/firebase.server';
import { signInWithEmailAndPassword, createUserWithEmailAndPassword } from 'firebase/auth';
import { getSession, commitSession } from '~/services/session.server';

export async function loader({ request }) {
  const session = await getSession(request.headers.get('Cookie'));
  if (session.has('userId')) {
    return redirect('/dashboard');
  }
  return json({});
}

export async function action({ request }) {
  const formData = await request.formData();
  const action = formData.get('action');
  const email = formData.get('email');
  const password = formData.get('password');

  try {
    let userCredential;
    if (action === 'login') {
      userCredential = await signInWithEmailAndPassword(auth, email, password);
    } else {
      userCredential = await createUserWithEmailAndPassword(auth, email, password);
    }

    // Create session
    const session = await getSession();
    session.set('userId', userCredential.user.uid);

    return redirect('/dashboard', {
      headers: {
        'Set-Cookie': await commitSession(session)
      }
    });
  } catch (error) {
    return json({ error: error.message }, { status: 400 });
  }
}

export default function Auth() {
  const actionData = useActionData();
  const loaderData = useLoaderData();

  return (
    <div>
      <Form method="post">
        <div>
          <label htmlFor="email">Email:</label>
          <input
            id="email"
            name="email"
            type="email"
            required
          />
        </div>
        <div>
          <label htmlFor="password">Password:</label>
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
        {actionData?.error && (
          <p className="error">{actionData.error}</p>
        )}
      </Form>
    </div>
  );
}
```

### Protected Route (app/routes/dashboard.tsx)
```typescript
import { json, redirect } from '@remix-run/node';
import { useLoaderData } from '@remix-run/react';
import { adminAuth } from '~/services/firebase.server';
import { getSession } from '~/services/session.server';

export async function loader({ request }) {
  const session = await getSession(request.headers.get('Cookie'));
  const userId = session.get('userId');

  if (!userId) {
    return redirect('/auth');
  }

  try {
    const user = await adminAuth.getUser(userId);
    return json({ user });
  } catch (error) {
    return redirect('/auth');
  }
}

export default function Dashboard() {
  const { user } = useLoaderData();

  return (
    <div>
      <h1>Welcome, {user.email}</h1>
      <Form method="post" action="/logout">
        <button type="submit">Logout</button>
      </Form>
    </div>
  );
}
```

### Firestore Data Management (app/routes/todos.tsx)
```typescript
import { json } from '@remix-run/node';
import { useLoaderData, useFetcher } from '@remix-run/react';
import { adminDb } from '~/services/firebase.server';

export async function loader() {
  const todosSnapshot = await adminDb.collection('todos').orderBy('createdAt', 'desc').limit(10).get();
  const todos = todosSnapshot.docs.map(doc => ({
    id: doc.id,
    ...doc.data()
  }));
  return json({ todos });
}

export async function action({ request }) {
  const formData = await request.formData();
  const action = formData.get('action');
  const title = formData.get('title');
  const id = formData.get('id');

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

  return json({ success: true });
}

export default function Todos() {
  const { todos } = useLoaderData();
  const fetcher = useFetcher();

  return (
    <div>
      <fetcher.Form method="post">
        <input
          type="text"
          name="title"
          placeholder="New todo"
          required
        />
        <input type="hidden" name="action" value="create" />
        <button type="submit">Add</button>
      </fetcher.Form>

      <ul>
        {todos.map((todo) => (
          <li key={todo.id}>
            <fetcher.Form method="post">
              <input type="hidden" name="id" value={todo.id} />
              <input type="hidden" name="action" value="toggle" />
              <button type="submit">
                {todo.completed ? '✓' : '○'}
              </button>
            </fetcher.Form>
            <span style={{ textDecoration: todo.completed ? 'line-through' : 'none' }}>
              {todo.title}
            </span>
            <fetcher.Form method="post">
              <input type="hidden" name="id" value={todo.id} />
              <input type="hidden" name="action" value="delete" />
              <button type="submit">Delete</button>
            </fetcher.Form>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### File Storage (app/routes/files.tsx)
```typescript
import { json, unstable_parseMultipartFormData } from '@remix-run/node';
import { useLoaderData, useFetcher } from '@remix-run/react';
import { adminStorage } from '~/services/firebase.server';
import { storage } from '~/services/firebase.client';
import { ref, getDownloadURL } from 'firebase/storage';

export async function loader() {
  const [files] = await adminStorage.bucket().getFiles();
  const fileList = await Promise.all(
    files.map(async (file) => {
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
  return json({ files: fileList });
}

export async function action({ request }) {
  const formData = await unstable_parseMultipartFormData(request);
  const file = formData.get('file');
  const action = formData.get('action');

  if (action === 'upload' && file) {
    const buffer = await file.arrayBuffer();
    const filename = `${Date.now()}-${file.name}`;
    await adminStorage.bucket().file(filename).save(Buffer.from(buffer));
    return json({ success: true });
  }

  if (action === 'delete') {
    const filename = formData.get('filename');
    await adminStorage.bucket().file(filename).delete();
    return json({ success: true });
  }

  return json({ error: 'Invalid action' }, { status: 400 });
}

export default function Files() {
  const { files } = useLoaderData();
  const fetcher = useFetcher();

  return (
    <div>
      <fetcher.Form method="post" encType="multipart/form-data">
        <input
          type="file"
          name="file"
          accept="image/*"
          required
        />
        <input type="hidden" name="action" value="upload" />
        <button type="submit">Upload</button>
      </fetcher.Form>

      <ul>
        {files.map((file) => (
          <li key={file.name}>
            <a href={file.url} target="_blank" rel="noopener noreferrer">
              {file.name}
            </a>
            <fetcher.Form method="post">
              <input type="hidden" name="filename" value={file.name} />
              <input type="hidden" name="action" value="delete" />
              <button type="submit">Delete</button>
            </fetcher.Form>
          </li>
        ))}
      </ul>
    </div>
  );
}
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
4. Use Remix's form handling for better progressive enhancement
5. Implement proper loading states
6. Use Firebase emulators for local development
7. Follow Remix's patterns for data mutations
8. Implement proper data validation
9. Use Firebase indexes for complex queries

## Troubleshooting
1. Check Firebase console for errors
2. Verify security rules configuration
3. Check network requests in browser developer tools
4. Use Firebase debugging tools
5. Monitor Firebase usage and quotas
6. Check Remix server logs
7. Verify environment variables

## Additional Resources
- [Firebase Documentation](https://firebase.google.com/docs)
- [Remix Documentation](https://remix.run/docs/en/main)
- [Firebase Console](https://console.firebase.google.com/) 