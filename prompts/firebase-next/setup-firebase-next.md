---
description: "Guidelines for integrating Firebase backend services with Next.js applications"
globs: "*.tsx,*.ts,next.config.*,app/**/*,src/app/**/*"
---

# Firebase + Next.js Integration Setup Guide

This guide provides step-by-step instructions for integrating Firebase with Next.js 14, focusing on App Router and Server Components.

## Prerequisites
- Node.js and npm installed
- Next.js 14 project set up
- Firebase account and project created
- Basic understanding of Next.js and Firebase

## Installation

1. Install required dependencies:
```bash
npm install firebase firebase-admin
```

2. Set up Firebase configuration in `lib/firebase/client.ts`:
```typescript
import { initializeApp, getApps } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';
import { getStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID
};

// Initialize Firebase for client-side
export const firebaseApp = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0];
export const db = getFirestore(firebaseApp);
export const auth = getAuth(firebaseApp);
export const storage = getStorage(firebaseApp);
```

3. Set up Firebase Admin in `lib/firebase/admin.ts`:
```typescript
import { initializeApp, getApps, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { getAuth } from 'firebase-admin/auth';
import { getStorage } from 'firebase-admin/storage';

const adminApp = getApps().length === 0
  ? initializeApp({
      credential: cert({
        projectId: process.env.FIREBASE_ADMIN_PROJECT_ID,
        clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_ADMIN_PRIVATE_KEY?.replace(/\\n/g, '\n')
      })
    })
  : getApps()[0];

export const adminDb = getFirestore();
export const adminAuth = getAuth();
export const adminStorage = getStorage();
```

4. Create `.env.local`:
```env
# Client-side Firebase config
NEXT_PUBLIC_FIREBASE_API_KEY=your-api-key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your-project-id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your-project.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your-messaging-sender-id
NEXT_PUBLIC_FIREBASE_APP_ID=your-app-id

# Server-side Firebase Admin config
FIREBASE_ADMIN_PROJECT_ID=your-project-id
FIREBASE_ADMIN_CLIENT_EMAIL=your-client-email
FIREBASE_ADMIN_PRIVATE_KEY=your-private-key
```

## Authentication Setup

1. Create authentication hooks in `lib/hooks/useAuth.ts`:
```typescript
'use client';

import { useEffect, useState } from 'react';
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signInWithPopup,
  GoogleAuthProvider,
  signOut,
  onAuthStateChanged,
  type User
} from 'firebase/auth';
import { auth } from '@/lib/firebase/client';
import { useRouter } from 'next/navigation';

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setUser(user);
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const signIn = async (email: string, password: string) => {
    try {
      await signInWithEmailAndPassword(auth, email, password);
      router.push('/dashboard');
    } catch (error: any) {
      throw new Error(error.message);
    }
  };

  const signUp = async (email: string, password: string) => {
    try {
      await createUserWithEmailAndPassword(auth, email, password);
      router.push('/dashboard');
    } catch (error: any) {
      throw new Error(error.message);
    }
  };

  const signInWithGoogle = async () => {
    try {
      const provider = new GoogleAuthProvider();
      await signInWithPopup(auth, provider);
      router.push('/dashboard');
    } catch (error: any) {
      throw new Error(error.message);
    }
  };

  const logout = async () => {
    try {
      await signOut(auth);
      router.push('/');
    } catch (error: any) {
      throw new Error(error.message);
    }
  };

  return {
    user,
    loading,
    signIn,
    signUp,
    signInWithGoogle,
    logout
  };
}
```

2. Create authentication middleware in `middleware.ts`:
```typescript
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { adminAuth } from '@/lib/firebase/admin';

export async function middleware(request: NextRequest) {
  const session = request.cookies.get('session')?.value;

  // Return to /login if no session exists
  if (!session) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  try {
    // Verify session
    const decodedClaim = await adminAuth.verifySessionCookie(session, true);

    // Add user to request
    const requestHeaders = new Headers(request.headers);
    requestHeaders.set('user', JSON.stringify(decodedClaim));

    // Return request with user
    return NextResponse.next({
      request: {
        headers: requestHeaders,
      },
    });
  } catch (error) {
    // Delete session cookie if invalid
    const response = NextResponse.redirect(new URL('/login', request.url));
    response.cookies.delete('session');
    return response;
  }
}

export const config = {
  matcher: ['/dashboard/:path*']
};
```

## Firestore Setup

1. Create Firestore hooks in `lib/hooks/useFirestore.ts`:
```typescript
'use client';

import { useState, useCallback } from 'react';
import {
  collection,
  doc,
  query,
  where,
  orderBy,
  limit,
  getDocs,
  getDoc,
  addDoc,
  updateDoc,
  deleteDoc,
  type Query,
  type DocumentData
} from 'firebase/firestore';
import { db } from '@/lib/firebase/client';

export function useFirestore<T = DocumentData>(collectionName: string) {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  const getDocuments = useCallback(async (
    constraints?: {
      where?: [string, firebase.firestore.WhereFilterOp, any][];
      orderBy?: [string, 'asc' | 'desc'][];
      limit?: number;
    }
  ) => {
    setLoading(true);
    setError(null);

    try {
      let q: Query = collection(db, collectionName);

      if (constraints) {
        if (constraints.where) {
          constraints.where.forEach(([field, op, value]) => {
            q = query(q, where(field, op, value));
          });
        }

        if (constraints.orderBy) {
          constraints.orderBy.forEach(([field, direction]) => {
            q = query(q, orderBy(field, direction));
          });
        }

        if (constraints.limit) {
          q = query(q, limit(constraints.limit));
        }
      }

      const snapshot = await getDocs(q);
      return snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      })) as T[];
    } catch (err: any) {
      setError(err);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [collectionName]);

  const getDocument = useCallback(async (id: string) => {
    setLoading(true);
    setError(null);

    try {
      const docRef = doc(db, collectionName, id);
      const docSnap = await getDoc(docRef);

      if (!docSnap.exists()) {
        throw new Error('Document not found');
      }

      return {
        id: docSnap.id,
        ...docSnap.data()
      } as T;
    } catch (err: any) {
      setError(err);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [collectionName]);

  const addDocument = useCallback(async (data: Omit<T, 'id'>) => {
    setLoading(true);
    setError(null);

    try {
      const docRef = await addDoc(collection(db, collectionName), data);
      return docRef.id;
    } catch (err: any) {
      setError(err);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [collectionName]);

  const updateDocument = useCallback(async (id: string, data: Partial<T>) => {
    setLoading(true);
    setError(null);

    try {
      const docRef = doc(db, collectionName, id);
      await updateDoc(docRef, data as DocumentData);
    } catch (err: any) {
      setError(err);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [collectionName]);

  const deleteDocument = useCallback(async (id: string) => {
    setLoading(true);
    setError(null);

    try {
      const docRef = doc(db, collectionName, id);
      await deleteDoc(docRef);
    } catch (err: any) {
      setError(err);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [collectionName]);

  return {
    loading,
    error,
    getDocuments,
    getDocument,
    addDocument,
    updateDocument,
    deleteDocument
  };
}
```

## Server Actions

1. Create server actions in `app/actions/firebase.ts`:
```typescript
'use server';

import { adminDb, adminAuth } from '@/lib/firebase/admin';
import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';

export async function createSessionCookie(idToken: string) {
  try {
    const expiresIn = 60 * 60 * 24 * 5 * 1000; // 5 days
    const sessionCookie = await adminAuth.createSessionCookie(idToken, { expiresIn });
    cookies().set('session', sessionCookie, {
      maxAge: expiresIn,
      httpOnly: true,
      secure: true
    });
  } catch (error) {
    throw new Error('Failed to create session');
  }
}

export async function getUserData(userId: string) {
  try {
    const userDoc = await adminDb.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw new Error('User not found');
    }
    return {
      id: userDoc.id,
      ...userDoc.data()
    };
  } catch (error) {
    throw new Error('Failed to get user data');
  }
}

export async function updateUserData(userId: string, data: any) {
  try {
    await adminDb.collection('users').doc(userId).update(data);
  } catch (error) {
    throw new Error('Failed to update user data');
  }
}
```

## Example Components

1. Authentication Component:
```typescript
// app/components/Auth.tsx
'use client';

import { useState } from 'react';
import { useAuth } from '@/lib/hooks/useAuth';

export default function Auth() {
  const { signIn, signUp, signInWithGoogle, loading } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isSignUp, setIsSignUp] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (isSignUp) {
        await signUp(email, password);
      } else {
        await signIn(email, password);
      }
    } catch (error: any) {
      console.error('Authentication error:', error.message);
    }
  };

  return (
    <div className="max-w-md mx-auto mt-8">
      <form onSubmit={handleSubmit} className="space-y-4">
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="Email"
          required
          className="w-full p-2 border rounded"
        />
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          placeholder="Password"
          required
          className="w-full p-2 border rounded"
        />
        <button
          type="submit"
          disabled={loading}
          className="w-full p-2 bg-blue-500 text-white rounded"
        >
          {isSignUp ? 'Sign Up' : 'Sign In'}
        </button>
        <button
          type="button"
          onClick={signInWithGoogle}
          disabled={loading}
          className="w-full p-2 bg-red-500 text-white rounded"
        >
          Sign in with Google
        </button>
        <button
          type="button"
          onClick={() => setIsSignUp(!isSignUp)}
          className="w-full p-2 text-blue-500"
        >
          {isSignUp ? 'Already have an account?' : 'Need an account?'}
        </button>
      </form>
    </div>
  );
}
```

2. Protected Dashboard Page:
```typescript
// app/dashboard/page.tsx
import { headers } from 'next/headers';
import { getUserData } from '@/app/actions/firebase';

export default async function DashboardPage() {
  const headersList = headers();
  const user = JSON.parse(headersList.get('user') || '{}');
  const userData = await getUserData(user.uid);

  return (
    <div className="max-w-4xl mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Dashboard</h1>
      <div className="bg-white shadow rounded-lg p-6">
        <h2 className="text-xl font-semibold mb-4">Welcome, {userData.name}</h2>
        <div className="space-y-4">
          <p>Email: {userData.email}</p>
          <p>Member since: {new Date(userData.createdAt).toLocaleDateString()}</p>
        </div>
      </div>
    </div>
  );
}
```

## Security Considerations
1. Use environment variables for Firebase configuration
2. Implement proper Firebase security rules
3. Use Firebase Admin SDK for server-side operations
4. Implement proper session management
5. Use secure cookies for authentication
6. Use proper data validation
7. Implement rate limiting
8. Use Firebase App Check

## Best Practices
1. Use server components when possible
2. Implement proper error handling
3. Use TypeScript for better type safety
4. Follow Next.js 14 conventions
5. Implement proper loading states
6. Use Firebase emulators for development
7. Keep Firebase configuration secure
8. Use proper data validation

## Troubleshooting
1. Check Next.js server logs
2. Monitor Firebase console
3. Verify security rules
4. Check network requests
5. Validate environment variables
6. Check Firebase emulator
7. Verify authentication state

## Additional Resources
- [Next.js Documentation](https://nextjs.org/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Firebase Console](https://console.firebase.google.com/)
- [Next.js with Firebase Examples](https://github.com/vercel/next.js/tree/canary/examples) 