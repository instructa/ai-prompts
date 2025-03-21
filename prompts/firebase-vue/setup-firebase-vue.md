---
description: "Guidelines for integrating Firebase backend services with Vue applications"
globs: "*.vue,*.ts,vite.config.*,src/**/*,composables/**/*"
---

# Firebase + Vue Integration Setup Guide

This guide provides instructions for setting up and integrating Firebase with a Vue 3 application.

## Prerequisites
- Node.js and npm installed
- Vue 3 project initialized
- Firebase project created

## Installation

1. Install required dependencies:
```bash
npm install firebase vuefire
```

## Configuration

2. Create a new file `src/firebase.ts` for Firebase configuration:
```typescript
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';
import { getStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID
};

// Initialize Firebase
export const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export const storage = getStorage(app);
```

3. Set up VueFire plugin in `src/main.ts`:
```typescript
import { createApp } from 'vue';
import { VueFire, VueFireAuth } from 'vuefire';
import App from './App.vue';
import { app as firebaseApp } from './firebase';

const app = createApp(App);

app.use(VueFire, {
  firebaseApp,
  modules: [VueFireAuth()]
});

app.mount('#app');
```

## Usage Examples

### Authentication Component
```vue
<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useCurrentUser, useFirebaseAuth } from 'vuefire';
import { signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut } from 'firebase/auth';

const router = useRouter();
const auth = useFirebaseAuth()!;
const user = useCurrentUser();

const form = ref({
  email: '',
  password: ''
});
const error = ref<string | null>(null);
const loading = ref(false);
const isLogin = ref(true);

const handleSubmit = async () => {
  loading.value = true;
  error.value = null;

  try {
    if (isLogin.value) {
      await signInWithEmailAndPassword(auth, form.value.email, form.value.password);
    } else {
      await createUserWithEmailAndPassword(auth, form.value.email, form.value.password);
    }
    router.push('/dashboard');
  } catch (err: any) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

const handleLogout = async () => {
  try {
    await signOut(auth);
    router.push('/login');
  } catch (err: any) {
    console.error('Logout failed:', err);
  }
};
</script>

<template>
  <div v-if="user">
    <h2>Welcome, {{ user.email }}</h2>
    <button @click="handleLogout" :disabled="loading">
      {{ loading ? 'Logging out...' : 'Logout' }}
    </button>
  </div>
  <div v-else>
    <h2>{{ isLogin ? 'Login' : 'Register' }}</h2>
    <form @submit.prevent="handleSubmit">
      <div>
        <label for="email">Email:</label>
        <input
          id="email"
          v-model="form.email"
          type="email"
          required
        />
      </div>
      <div>
        <label for="password">Password:</label>
        <input
          id="password"
          v-model="form.password"
          type="password"
          required
        />
      </div>
      <button type="submit" :disabled="loading">
        {{ loading ? 'Processing...' : (isLogin ? 'Login' : 'Register') }}
      </button>
      <p v-if="error" class="error">{{ error }}</p>
    </form>
    <p>
      {{ isLogin ? "Don't have an account?" : "Already have an account?" }}
      <button @click="isLogin = !isLogin">
        {{ isLogin ? 'Register' : 'Login' }}
      </button>
    </p>
  </div>
</template>
```

### Firestore Data Management Component
```vue
<script setup lang="ts">
import { ref } from 'vue';
import { useCollection, useDocument } from 'vuefire';
import { collection, doc, addDoc, updateDoc, deleteDoc, query, orderBy, limit } from 'firebase/firestore';
import { db } from '../firebase';

// Collection reference
const todosCollection = collection(db, 'todos');

// Query with ordering and limit
const todosQuery = query(
  todosCollection,
  orderBy('createdAt', 'desc'),
  limit(10)
);

// Use the collection
const todos = useCollection(todosQuery);

// New todo form
const newTodo = ref('');
const loading = ref(false);
const error = ref<string | null>(null);

// Add new todo
const addTodo = async () => {
  if (!newTodo.value.trim()) return;
  
  loading.value = true;
  error.value = null;
  
  try {
    await addDoc(todosCollection, {
      text: newTodo.value,
      completed: false,
      createdAt: new Date()
    });
    newTodo.value = '';
  } catch (err: any) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

// Toggle todo completion
const toggleTodo = async (todoId: string, completed: boolean) => {
  const todoRef = doc(db, 'todos', todoId);
  try {
    await updateDoc(todoRef, {
      completed: !completed
    });
  } catch (err: any) {
    console.error('Failed to toggle todo:', err);
  }
};

// Delete todo
const deleteTodo = async (todoId: string) => {
  const todoRef = doc(db, 'todos', todoId);
  try {
    await deleteDoc(todoRef);
  } catch (err: any) {
    console.error('Failed to delete todo:', err);
  }
};
</script>

<template>
  <div>
    <form @submit.prevent="addTodo">
      <input
        v-model="newTodo"
        placeholder="Add new todo"
        :disabled="loading"
      />
      <button type="submit" :disabled="loading">
        {{ loading ? 'Adding...' : 'Add Todo' }}
      </button>
    </form>
    
    <p v-if="error" class="error">{{ error }}</p>
    
    <ul>
      <li v-for="todo in todos" :key="todo.id">
        <input
          type="checkbox"
          :checked="todo.completed"
          @change="toggleTodo(todo.id, todo.completed)"
        />
        <span :class="{ completed: todo.completed }">
          {{ todo.text }}
        </span>
        <button @click="deleteTodo(todo.id)">Delete</button>
      </li>
    </ul>
  </div>
</template>

<style scoped>
.completed {
  text-decoration: line-through;
  color: #888;
}
</style>
```

### File Storage Component
```vue
<script setup lang="ts">
import { ref } from 'vue';
import { storage } from '../firebase';
import { ref as storageRef, uploadBytes, getDownloadURL, deleteObject } from 'firebase/storage';
import { useCurrentUser } from 'vuefire';

const user = useCurrentUser();
const files = ref<{ name: string; url: string }[]>([]);
const uploading = ref(false);
const error = ref<string | null>(null);

// Upload file
const handleFileUpload = async (event: Event) => {
  const fileInput = event.target as HTMLInputElement;
  if (!fileInput.files?.length) return;
  
  const file = fileInput.files[0];
  const fileRef = storageRef(storage, `uploads/${user.value?.uid}/${file.name}`);
  
  uploading.value = true;
  error.value = null;
  
  try {
    await uploadBytes(fileRef, file);
    const url = await getDownloadURL(fileRef);
    files.value.push({ name: file.name, url });
  } catch (err: any) {
    error.value = err.message;
  } finally {
    uploading.value = false;
    fileInput.value = ''; // Reset input
  }
};

// Delete file
const deleteFile = async (fileName: string) => {
  const fileRef = storageRef(storage, `uploads/${user.value?.uid}/${fileName}`);
  
  try {
    await deleteObject(fileRef);
    files.value = files.value.filter(f => f.name !== fileName);
  } catch (err: any) {
    console.error('Failed to delete file:', err);
  }
};
</script>

<template>
  <div>
    <input
      type="file"
      @change="handleFileUpload"
      :disabled="uploading"
    />
    
    <p v-if="error" class="error">{{ error }}</p>
    
    <div v-if="uploading" class="loading">
      Uploading...
    </div>
    
    <ul>
      <li v-for="file in files" :key="file.name">
        <a :href="file.url" target="_blank">{{ file.name }}</a>
        <button @click="deleteFile(file.name)">Delete</button>
      </li>
    </ul>
  </div>
</template>
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
2. Structure your Firebase services in modules
3. Implement proper error handling
4. Use VueFire's composables for reactive data
5. Implement proper loading states
6. Use Firebase emulators for local development
7. Follow Vue's composition API best practices
8. Implement proper data validation
9. Use Firebase indexes for complex queries

## Troubleshooting
1. Check Firebase console for errors
2. Verify security rules configuration
3. Check network requests in browser developer tools
4. Use Firebase debugging tools
5. Monitor Firebase usage and quotas
6. Check Vue DevTools for component state
7. Verify environment variables

## Additional Resources
- [Firebase Documentation](https://firebase.google.com/docs)
- [VueFire Documentation](https://vuefire.vuejs.org/)
- [Vue 3 Documentation](https://vuejs.org/)
- [Firebase Console](https://console.firebase.google.com/) 