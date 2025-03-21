---
description: "Guidelines for integrating Firebase backend services with TanStack Query applications"
globs: "*.tsx,*.ts,**/hooks/**/*,**/queries/**/*"
---

# Firebase + TanStack Query Integration Setup Guide

This guide provides step-by-step instructions for integrating Firebase with TanStack Query (formerly React Query) in a React application.

## Prerequisites
- Node.js and npm installed
- React project set up
- Firebase account and project created
- Basic understanding of React and Firebase

## Installation

1. Install the required dependencies:
```bash
npm install @tanstack/react-query @tanstack/react-query-devtools firebase @tanstack-query-firebase/react
```

2. Set up Firebase configuration in `src/lib/firebase.ts`:
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

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
export const storage = getStorage(app);
```

3. Set up TanStack Query in `src/App.tsx`:
```typescript
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 30 * 60 * 1000, // 30 minutes
      retry: 3,
      refetchOnWindowFocus: false
    }
  }
});

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      {/* Your app components */}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}

export default App;
```

## Usage Examples

### Custom Hooks for Firestore Operations

1. Create a hooks directory `src/hooks/firebase.ts`:
```typescript
import { useDocumentQuery, useCollectionQuery } from '@tanstack-query-firebase/react/firestore';
import { useSubscription } from '@tanstack-query-firebase/react/firestore';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { doc, collection, query, where, orderBy, setDoc, deleteDoc, DocumentData } from 'firebase/firestore';
import { db } from '../lib/firebase';

// Document hooks
export function useDocument<T = DocumentData>(path: string, id: string) {
  const docRef = doc(db, path, id);
  return useDocumentQuery<T>(docRef, {
    queryKey: [path, id],
  });
}

export function useDocumentRealtime<T = DocumentData>(path: string, id: string) {
  const docRef = doc(db, path, id);
  return useSubscription<T>(docRef, {
    queryKey: [path, id],
  });
}

// Collection hooks
export function useCollection<T = DocumentData>(
  path: string,
  constraints?: {
    where?: [string, firebase.firestore.WhereFilterOp, any][];
    orderBy?: [string, 'asc' | 'desc'][];
    limit?: number;
  }
) {
  let collectionRef = collection(db, path);
  
  if (constraints) {
    let q = query(collectionRef);
    
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
    
    collectionRef = q;
  }

  return useCollectionQuery<T>(collectionRef, {
    queryKey: [path, constraints],
  });
}

export function useCollectionRealtime<T = DocumentData>(
  path: string,
  constraints?: {
    where?: [string, firebase.firestore.WhereFilterOp, any][];
    orderBy?: [string, 'asc' | 'desc'][];
    limit?: number;
  }
) {
  let collectionRef = collection(db, path);
  
  if (constraints) {
    let q = query(collectionRef);
    
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
    
    collectionRef = q;
  }

  return useSubscription<T>(collectionRef, {
    queryKey: [path, constraints],
  });
}

// Mutation hooks
export function useDocumentMutation<T = DocumentData>(path: string) {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ id, data }: { id: string; data: T }) => {
      const docRef = doc(db, path, id);
      await setDoc(docRef, data, { merge: true });
      return { id, data };
    },
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries([path, id]);
      queryClient.invalidateQueries([path]);
    }
  });
}

export function useDocumentDelete(path: string) {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (id: string) => {
      const docRef = doc(db, path, id);
      await deleteDoc(docRef);
      return id;
    },
    onSuccess: (id) => {
      queryClient.invalidateQueries([path, id]);
      queryClient.invalidateQueries([path]);
    }
  });
}
```

### Example Components

1. User Profile Component:
```typescript
import { useDocument, useDocumentMutation } from '../hooks/firebase';

interface User {
  id: string;
  name: string;
  email: string;
  bio: string;
}

function UserProfile({ userId }: { userId: string }) {
  const { data: user, isLoading, error } = useDocument<User>('users', userId);
  const mutation = useDocumentMutation<User>('users');

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  if (!user) return <div>User not found</div>;

  const handleUpdate = async (newData: Partial<User>) => {
    try {
      await mutation.mutateAsync({
        id: userId,
        data: { ...user, ...newData }
      });
    } catch (error) {
      console.error('Failed to update user:', error);
    }
  };

  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
      <p>{user.bio}</p>
      <button
        onClick={() => handleUpdate({ bio: 'Updated bio' })}
        disabled={mutation.isPending}
      >
        Update Bio
      </button>
    </div>
  );
}
```

2. Real-time Chat Component:
```typescript
import { useCollectionRealtime, useDocumentMutation } from '../hooks/firebase';

interface Message {
  id: string;
  text: string;
  userId: string;
  createdAt: number;
}

function ChatRoom({ roomId }: { roomId: string }) {
  const { data: messages, isLoading } = useCollectionRealtime<Message>('messages', {
    where: [['roomId', '==', roomId]],
    orderBy: [['createdAt', 'desc']],
    limit: 50
  });

  const mutation = useDocumentMutation<Message>('messages');

  const sendMessage = async (text: string) => {
    try {
      await mutation.mutateAsync({
        id: Date.now().toString(),
        data: {
          text,
          roomId,
          userId: 'current-user-id', // Replace with actual user ID
          createdAt: Date.now()
        }
      });
    } catch (error) {
      console.error('Failed to send message:', error);
    }
  };

  if (isLoading) return <div>Loading...</div>;

  return (
    <div>
      <div className="messages">
        {messages?.map(message => (
          <div key={message.id} className="message">
            <span>{message.text}</span>
            <small>{new Date(message.createdAt).toLocaleString()}</small>
          </div>
        ))}
      </div>
      <form onSubmit={(e) => {
        e.preventDefault();
        const input = e.currentTarget.elements.namedItem('message') as HTMLInputElement;
        if (input.value.trim()) {
          sendMessage(input.value);
          input.value = '';
        }
      }}>
        <input
          type="text"
          name="message"
          placeholder="Type a message..."
          disabled={mutation.isPending}
        />
        <button type="submit" disabled={mutation.isPending}>
          Send
        </button>
      </form>
    </div>
  );
}
```

## Best Practices

1. Query Key Management
- Use consistent query key patterns
- Include all relevant parameters in query keys
- Keep query keys as simple as possible
```typescript
// Good
const queryKey = ['users', userId];
const queryKey = ['posts', { category, page }];

// Bad
const queryKey = ['users', { id: userId, timestamp: Date.now() }];
```

2. Caching Strategy
- Set appropriate staleTime and cacheTime
- Use prefetching for predictable navigation
- Implement optimistic updates for mutations
```typescript
// Configure global defaults
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // Data is fresh for 5 minutes
      cacheTime: 30 * 60 * 1000, // Cache is kept for 30 minutes
    }
  }
});

// Prefetch data
queryClient.prefetchQuery({
  queryKey: ['users', userId],
  queryFn: () => fetchUser(userId)
});
```

3. Error Handling
- Implement proper error boundaries
- Use error states in components
- Retry failed queries appropriately
```typescript
function ErrorFallback({ error, resetErrorBoundary }) {
  return (
    <div role="alert">
      <p>Something went wrong:</p>
      <pre>{error.message}</pre>
      <button onClick={resetErrorBoundary}>Try again</button>
    </div>
  );
}
```

4. Performance Optimization
- Use select to transform data
- Implement infinite queries for large lists
- Enable suspense mode when appropriate
```typescript
const { data } = useDocument('users', userId, {
  select: (user) => ({
    displayName: `${user.firstName} ${user.lastName}`,
    avatar: user.profilePicture
  })
});
```

## Security Considerations
1. Implement proper Firebase security rules
2. Use environment variables for Firebase configuration
3. Validate data before mutations
4. Implement proper authentication checks
5. Use Firebase App Check
6. Handle sensitive data appropriately
7. Implement rate limiting

## Troubleshooting
1. Check React Query DevTools for query states
2. Monitor Firebase console for errors
3. Use proper error boundaries
4. Check network requests
5. Verify security rules
6. Monitor query invalidation
7. Check cache behavior

## Additional Resources
- [TanStack Query Documentation](https://tanstack.com/query/latest)
- [Firebase Documentation](https://firebase.google.com/docs)
- [TanStack Query Firebase Documentation](https://tanstack-query-firebase.web.app/)
- [React Documentation](https://reactjs.org/docs) 