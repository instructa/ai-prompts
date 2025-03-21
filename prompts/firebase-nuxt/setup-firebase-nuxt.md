---
description: "Guidelines for integrating Firebase backend services with Nuxt applications"
globs: "*.vue,*.ts,nuxt.config.*,server/**/*,composables/**/*"
---

# Firebase + Nuxt Integration Setup Guide

This guide provides step-by-step instructions for integrating Firebase with Nuxt 3 using VueFire.

## Prerequisites
- Node.js and npm installed
- Nuxt 3 project set up
- Firebase account and project created
- Basic understanding of Nuxt and Firebase

## Installation

1. Install required dependencies:
```bash
npm install firebase nuxt-vuefire
```

2. Configure Nuxt and Firebase in `nuxt.config.ts`:
```typescript
export default defineNuxtConfig({
  modules: ['nuxt-vuefire'],
  vuefire: {
    config: {
      apiKey: process.env.FIREBASE_API_KEY,
      authDomain: process.env.FIREBASE_AUTH_DOMAIN,
      projectId: process.env.FIREBASE_PROJECT_ID,
      storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
      messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
      appId: process.env.FIREBASE_APP_ID
    },
    auth: {
      enabled: true,
      sessionCookie: true // Enable server-side auth
    },
    admin: {
      // Optional: Enable Firebase Admin for server-side operations
      serviceAccount: {
        projectId: process.env.FIREBASE_ADMIN_PROJECT_ID,
        clientEmail: process.env.FIREBASE_ADMIN_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_ADMIN_PRIVATE_KEY
      }
    }
  },
  runtimeConfig: {
    public: {
      firebaseApiKey: process.env.FIREBASE_API_KEY,
      firebaseAuthDomain: process.env.FIREBASE_AUTH_DOMAIN,
      firebaseProjectId: process.env.FIREBASE_PROJECT_ID,
      firebaseStorageBucket: process.env.FIREBASE_STORAGE_BUCKET,
      firebaseMessagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
      firebaseAppId: process.env.FIREBASE_APP_ID
    }
  }
})
```

3. Create `.env` file:
```env
FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your-messaging-sender-id
FIREBASE_APP_ID=your-app-id

# Optional: Firebase Admin SDK credentials
FIREBASE_ADMIN_PROJECT_ID=your-project-id
FIREBASE_ADMIN_CLIENT_EMAIL=your-client-email
FIREBASE_ADMIN_PRIVATE_KEY=your-private-key
```

## Usage Examples

### Authentication Composable

1. Create `composables/useFirebaseAuth.ts`:
```typescript
import { useFirebaseAuth, useCurrentUser } from 'vuefire'
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signInWithPopup,
  GoogleAuthProvider,
  signOut as firebaseSignOut,
  onAuthStateChanged,
  type User
} from 'firebase/auth'

export function useAuth() {
  const auth = useFirebaseAuth()!
  const user = useCurrentUser()
  const router = useRouter()
  const loading = ref(false)
  const error = ref<string | null>(null)

  // Email/Password Sign In
  const signInWithEmail = async (email: string, password: string) => {
    loading.value = true
    error.value = null
    try {
      await signInWithEmailAndPassword(auth, email, password)
      router.push('/dashboard')
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  // Email/Password Sign Up
  const signUpWithEmail = async (email: string, password: string) => {
    loading.value = true
    error.value = null
    try {
      await createUserWithEmailAndPassword(auth, email, password)
      router.push('/dashboard')
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  // Google Sign In
  const signInWithGoogle = async () => {
    loading.value = true
    error.value = null
    try {
      const provider = new GoogleAuthProvider()
      await signInWithPopup(auth, provider)
      router.push('/dashboard')
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  // Sign Out
  const signOut = async () => {
    loading.value = true
    error.value = null
    try {
      await firebaseSignOut(auth)
      router.push('/')
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  return {
    user,
    loading,
    error,
    signInWithEmail,
    signUpWithEmail,
    signInWithGoogle,
    signOut
  }
}
```

### Firestore Composables

1. Create `composables/useFirestore.ts`:
```typescript
import { useFirestore, useCollection, useDocument } from 'vuefire'
import {
  collection,
  doc,
  query,
  where,
  orderBy,
  limit,
  addDoc,
  updateDoc,
  deleteDoc,
  type DocumentData,
  type QueryConstraint
} from 'firebase/firestore'

export function useFirestoreCollection<T = DocumentData>(
  path: string,
  constraints?: {
    where?: [string, firebase.firestore.WhereFilterOp, any][];
    orderBy?: [string, 'asc' | 'desc'][];
    limit?: number;
  }
) {
  const db = useFirestore()
  const loading = ref(false)
  const error = ref<string | null>(null)

  const buildQuery = () => {
    let collectionRef = collection(db, path)
    const queryConstraints: QueryConstraint[] = []

    if (constraints) {
      if (constraints.where) {
        constraints.where.forEach(([field, op, value]) => {
          queryConstraints.push(where(field, op, value))
        })
      }

      if (constraints.orderBy) {
        constraints.orderBy.forEach(([field, direction]) => {
          queryConstraints.push(orderBy(field, direction))
        })
      }

      if (constraints.limit) {
        queryConstraints.push(limit(constraints.limit))
      }
    }

    return queryConstraints.length > 0
      ? query(collectionRef, ...queryConstraints)
      : collectionRef
  }

  const data = useCollection<T>(buildQuery())

  const add = async (document: Omit<T, 'id'>) => {
    loading.value = true
    error.value = null
    try {
      const docRef = await addDoc(collection(db, path), document)
      return docRef.id
    } catch (e: any) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  return {
    data,
    loading,
    error,
    add
  }
}

export function useFirestoreDocument<T = DocumentData>(path: string, id: string) {
  const db = useFirestore()
  const loading = ref(false)
  const error = ref<string | null>(null)

  const docRef = doc(db, path, id)
  const data = useDocument<T>(docRef)

  const update = async (updates: Partial<T>) => {
    loading.value = true
    error.value = null
    try {
      await updateDoc(docRef, updates as DocumentData)
    } catch (e: any) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  const remove = async () => {
    loading.value = true
    error.value = null
    try {
      await deleteDoc(docRef)
    } catch (e: any) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  return {
    data,
    loading,
    error,
    update,
    remove
  }
}
```

### Storage Composable

1. Create `composables/useStorage.ts`:
```typescript
import { useFirebaseStorage } from 'vuefire'
import {
  ref as storageRef,
  uploadBytes,
  getDownloadURL,
  deleteObject
} from 'firebase/storage'

export function useStorage(path: string) {
  const storage = useFirebaseStorage()!
  const loading = ref(false)
  const error = ref<string | null>(null)
  const downloadURL = ref<string | null>(null)

  const upload = async (file: File) => {
    loading.value = true
    error.value = null
    try {
      const fileRef = storageRef(storage, `${path}/${file.name}`)
      await uploadBytes(fileRef, file)
      downloadURL.value = await getDownloadURL(fileRef)
      return downloadURL.value
    } catch (e: any) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  const remove = async (filename: string) => {
    loading.value = true
    error.value = null
    try {
      const fileRef = storageRef(storage, `${path}/${filename}`)
      await deleteObject(fileRef)
      downloadURL.value = null
    } catch (e: any) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    error,
    downloadURL,
    upload,
    remove
  }
}
```

### Example Components

1. Authentication Component:
```vue
<!-- components/Auth.vue -->
<template>
  <div>
    <div v-if="error" class="error">{{ error }}</div>
    
    <form @submit.prevent="handleSubmit" v-if="!user">
      <input
        v-model="email"
        type="email"
        placeholder="Email"
        required
      />
      <input
        v-model="password"
        type="password"
        placeholder="Password"
        required
      />
      <button type="submit" :disabled="loading">
        {{ isSignUp ? 'Sign Up' : 'Sign In' }}
      </button>
      <button
        type="button"
        @click="signInWithGoogle"
        :disabled="loading"
      >
        Sign in with Google
      </button>
      <a href="#" @click.prevent="isSignUp = !isSignUp">
        {{ isSignUp ? 'Already have an account?' : 'Need an account?' }}
      </a>
    </form>

    <div v-else>
      <p>Welcome, {{ user.email }}</p>
      <button @click="signOut" :disabled="loading">Sign Out</button>
    </div>
  </div>
</template>

<script setup lang="ts">
const {
  user,
  loading,
  error,
  signInWithEmail,
  signUpWithEmail,
  signInWithGoogle,
  signOut
} = useAuth()

const email = ref('')
const password = ref('')
const isSignUp = ref(false)

const handleSubmit = async () => {
  if (isSignUp.value) {
    await signUpWithEmail(email.value, password.value)
  } else {
    await signInWithEmail(email.value, password.value)
  }
}
</script>
```

2. Firestore CRUD Component:
```vue
<!-- components/TodoList.vue -->
<template>
  <div>
    <div v-if="error" class="error">{{ error }}</div>

    <form @submit.prevent="handleSubmit">
      <input
        v-model="newTodo"
        type="text"
        placeholder="New todo"
        required
      />
      <button type="submit" :disabled="loading">Add Todo</button>
    </form>

    <ul v-if="todos.data">
      <li v-for="todo in todos.data" :key="todo.id">
        <span>{{ todo.text }}</span>
        <button
          @click="deleteTodo(todo.id)"
          :disabled="loading"
        >
          Delete
        </button>
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
interface Todo {
  id: string
  text: string
  completed: boolean
  createdAt: Date
}

const newTodo = ref('')
const todos = useFirestoreCollection<Todo>('todos', {
  orderBy: [['createdAt', 'desc']]
})

const handleSubmit = async () => {
  if (!newTodo.value.trim()) return

  await todos.add({
    text: newTodo.value,
    completed: false,
    createdAt: new Date()
  })

  newTodo.value = ''
}

const deleteTodo = async (id: string) => {
  const todo = useFirestoreDocument<Todo>('todos', id)
  await todo.remove()
}
</script>
```

## Server-Side Usage

1. Create server middleware for authentication:
```typescript
// server/middleware/auth.ts
export default defineEventHandler(async (event) => {
  const session = await getUserSession(event)
  if (!session && !event.path.startsWith('/api/public')) {
    throw createError({
      statusCode: 401,
      message: 'Unauthorized'
    })
  }
})
```

2. Create API routes with Firebase Admin:
```typescript
// server/api/users/[id].ts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const id = event.context.params.id
  const db = getFirestore()
  
  try {
    const doc = await db.collection('users').doc(id).get()
    if (!doc.exists) {
      throw createError({
        statusCode: 404,
        message: 'User not found'
      })
    }
    return { id: doc.id, ...doc.data() }
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      message: error.message
    })
  }
})
```

## Security Considerations
1. Use environment variables for Firebase configuration
2. Implement proper Firebase security rules
3. Enable App Check for additional security
4. Use server-side session cookies for authentication
5. Validate data on both client and server
6. Implement rate limiting
7. Use Firebase Admin SDK for server-side operations

## Best Practices
1. Use composables for Firebase services
2. Implement proper error handling
3. Use TypeScript for better type safety
4. Follow Nuxt 3 conventions
5. Implement proper loading states
6. Use Firebase emulators for development
7. Keep Firebase configuration secure
8. Use proper data validation

## Troubleshooting
1. Check Nuxt server logs
2. Monitor Firebase console
3. Verify security rules
4. Check network requests
5. Validate environment variables
6. Check Firebase emulator
7. Verify authentication state

## Additional Resources
- [Nuxt 3 Documentation](https://nuxt.com/docs)
- [VueFire Documentation](https://vuefire.vuejs.org/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Firebase Console](https://console.firebase.google.com/) 