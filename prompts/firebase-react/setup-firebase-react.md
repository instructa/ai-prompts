---
description: "Guidelines for integrating Firebase backend services with React applications"
globs: "*.jsx,*.tsx,*.js,*.ts,src/**/*"
---

# Firebase + React Integration Setup Guide

This guide provides step-by-step instructions for integrating Firebase with a React application.

## Prerequisites
- Node.js and npm installed
- React project initialized
- Firebase account and project created

## Installation

1. Install required dependencies:
```bash
npm install firebase
```

## Configuration

2. Create a new file `src/firebase.ts` for Firebase configuration:
```typescript
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';
import { getStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: process.env.REACT_APP_FIREBASE_API_KEY,
  authDomain: process.env.REACT_APP_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.REACT_APP_FIREBASE_PROJECT_ID,
  storageBucket: process.env.REACT_APP_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.REACT_APP_FIREBASE_APP_ID
};

// Initialize Firebase
export const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export const storage = getStorage(app);
```

## Usage Examples

### Authentication Hook
```typescript
import { useState, useEffect } from 'react';
import { User, onAuthStateChanged, signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut } from 'firebase/auth';
import { auth } from '../firebase';

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setUser(user);
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const login = async (email: string, password: string) => {
    try {
      setError(null);
      await signInWithEmailAndPassword(auth, email, password);
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  const register = async (email: string, password: string) => {
    try {
      setError(null);
      await createUserWithEmailAndPassword(auth, email, password);
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  const logout = async () => {
    try {
      setError(null);
      await signOut(auth);
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  return { user, loading, error, login, register, logout };
}
```

### Authentication Component
```typescript
import React, { useState } from 'react';
import { useAuth } from '../hooks/useAuth';
import { useNavigate } from 'react-router-dom';

export function AuthComponent() {
  const { user, loading, error, login, register, logout } = useAuth();
  const navigate = useNavigate();
  const [isLogin, setIsLogin] = useState(true);
  const [form, setForm] = useState({
    email: '',
    password: ''
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    try {
      if (isLogin) {
        await login(form.email, form.password);
      } else {
        await register(form.email, form.password);
      }
      navigate('/dashboard');
    } catch (err) {
      console.error('Authentication failed:', err);
    }
  };

  if (loading) return <div>Loading...</div>;

  return (
    <div>
      {user ? (
        <div>
          <p>Welcome, {user.email}</p>
          <button onClick={logout}>Logout</button>
        </div>
      ) : (
        <div>
          <h2>{isLogin ? 'Login' : 'Register'}</h2>
          <form onSubmit={handleSubmit}>
            <input
              type="email"
              placeholder="Email"
              value={form.email}
              onChange={(e) => setForm({ ...form, email: e.target.value })}
              required
            />
            <input
              type="password"
              placeholder="Password"
              value={form.password}
              onChange={(e) => setForm({ ...form, password: e.target.value })}
              required
            />
            <button type="submit">
              {isLogin ? 'Login' : 'Register'}
            </button>
            {error && <p className="error">{error}</p>}
          </form>
          <p>
            {isLogin ? "Don't have an account?" : "Already have an account?"}
            <button onClick={() => setIsLogin(!isLogin)}>
              {isLogin ? 'Register' : 'Login'}
            </button>
          </p>
        </div>
      )}
    </div>
  );
}
```

### Firestore Hook
```typescript
import { useState } from 'react';
import { collection, query, where, orderBy, limit, addDoc, updateDoc, deleteDoc, doc, onSnapshot, QueryConstraint } from 'firebase/firestore';
import { db } from '../firebase';

export function useFirestore<T>(collectionName: string) {
  const [documents, setDocuments] = useState<T[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const subscribeToCollection = (queryConstraints: QueryConstraint[] = []) => {
    setLoading(true);
    
    const q = query(collection(db, collectionName), ...queryConstraints);
    
    return onSnapshot(q, 
      (snapshot) => {
        const docs = snapshot.docs.map(doc => ({
          id: doc.id,
          ...doc.data()
        })) as T[];
        setDocuments(docs);
        setLoading(false);
      },
      (err) => {
        setError(err.message);
        setLoading(false);
      }
    );
  };

  const addDocument = async (data: Omit<T, 'id'>) => {
    try {
      setError(null);
      const docRef = await addDoc(collection(db, collectionName), data);
      return docRef.id;
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  const updateDocument = async (id: string, data: Partial<T>) => {
    try {
      setError(null);
      const docRef = doc(db, collectionName, id);
      await updateDoc(docRef, data);
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  const deleteDocument = async (id: string) => {
    try {
      setError(null);
      const docRef = doc(db, collectionName, id);
      await deleteDoc(docRef);
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  return {
    documents,
    loading,
    error,
    subscribeToCollection,
    addDocument,
    updateDocument,
    deleteDocument
  };
}
```

### Firestore Component Example
```typescript
import React, { useEffect, useState } from 'react';
import { useFirestore } from '../hooks/useFirestore';
import { orderBy, limit, where } from 'firebase/firestore';

interface Todo {
  id: string;
  title: string;
  completed: boolean;
  createdAt: Date;
}

export function TodoList() {
  const {
    documents: todos,
    loading,
    error,
    subscribeToCollection,
    addDocument,
    updateDocument,
    deleteDocument
  } = useFirestore<Todo>('todos');

  const [newTodo, setNewTodo] = useState('');

  useEffect(() => {
    const unsubscribe = subscribeToCollection([
      orderBy('createdAt', 'desc'),
      limit(10)
    ]);
    
    return () => unsubscribe();
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!newTodo.trim()) return;
    
    try {
      await addDocument({
        title: newTodo,
        completed: false,
        createdAt: new Date()
      });
      setNewTodo('');
    } catch (err) {
      console.error('Failed to add todo:', err);
    }
  };

  const toggleTodo = async (todo: Todo) => {
    try {
      await updateDocument(todo.id, {
        completed: !todo.completed
      });
    } catch (err) {
      console.error('Failed to toggle todo:', err);
    }
  };

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <input
          value={newTodo}
          onChange={(e) => setNewTodo(e.target.value)}
          placeholder="Add new todo"
        />
        <button type="submit">Add</button>
      </form>

      <ul>
        {todos.map((todo) => (
          <li key={todo.id}>
            <input
              type="checkbox"
              checked={todo.completed}
              onChange={() => toggleTodo(todo)}
            />
            <span style={{ textDecoration: todo.completed ? 'line-through' : 'none' }}>
              {todo.title}
            </span>
            <button onClick={() => deleteDocument(todo.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### Storage Hook
```typescript
import { useState } from 'react';
import { ref, uploadBytes, getDownloadURL, deleteObject } from 'firebase/storage';
import { storage } from '../firebase';

export function useStorage(path: string) {
  const [progress, setProgress] = useState(0);
  const [error, setError] = useState<string | null>(null);
  const [url, setUrl] = useState<string | null>(null);

  const uploadFile = async (file: File) => {
    try {
      setError(null);
      const storageRef = ref(storage, `${path}/${file.name}`);
      await uploadBytes(storageRef, file);
      const downloadUrl = await getDownloadURL(storageRef);
      setUrl(downloadUrl);
      return downloadUrl;
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  const deleteFile = async (filename: string) => {
    try {
      setError(null);
      const storageRef = ref(storage, `${path}/${filename}`);
      await deleteObject(storageRef);
      setUrl(null);
    } catch (err: any) {
      setError(err.message);
      throw err;
    }
  };

  return { progress, error, url, uploadFile, deleteFile };
}
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
1. Use TypeScript for better type safety
2. Structure your Firebase services in custom hooks
3. Implement proper error handling
4. Use real-time listeners where appropriate
5. Implement proper loading states
6. Use Firebase emulators for local development
7. Follow React's hooks patterns
8. Implement proper data validation
9. Use Firebase indexes for complex queries

## Troubleshooting
1. Check Firebase console for errors
2. Verify security rules configuration
3. Check network requests in browser developer tools
4. Use Firebase debugging tools
5. Monitor Firebase usage and quotas
6. Check React Developer Tools for component state
7. Verify environment variables

## Additional Resources
- [Firebase Documentation](https://firebase.google.com/docs)
- [React Documentation](https://react.dev)
- [Firebase Console](https://console.firebase.google.com/) 