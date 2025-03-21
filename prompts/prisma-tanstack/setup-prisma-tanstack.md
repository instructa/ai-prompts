---
description: "Guidelines for integrating Prisma ORM with TanStack Query applications"
globs: "*.tsx,*.ts,**/hooks/**/*,**/queries/**/*"
---

# Prisma with TanStack Query Integration Setup Guide

This guide provides step-by-step instructions for integrating Prisma ORM with TanStack Query (formerly React Query) in a React application.

## Prerequisites
- Node.js and npm installed
- React project initialized
- PostgreSQL database (or any other supported database)

## Installation

1. Install Prisma and its dependencies:
```bash
npm install @prisma/client
npm install -D prisma
```

2. Install TanStack Query and related packages:
```bash
npm install @tanstack/react-query @tanstack/react-query-devtools
```

3. Initialize Prisma in your project:
```bash
npx prisma init
```

## Database Schema

1. Define your schema in `prisma/schema.prisma`:
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Post {
  id        Int      @id @default(autoincrement())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  Int
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

## API Service Implementation

1. Create a Prisma client instance `src/lib/prisma.ts`:
```typescript
import { PrismaClient } from '@prisma/client'

let prisma: PrismaClient

if (process.env.NODE_ENV === 'production') {
  prisma = new PrismaClient()
} else {
  if (!global.prisma) {
    global.prisma = new PrismaClient()
  }
  prisma = global.prisma
}

export { prisma }
```

2. Create API service functions `src/services/api.ts`:
```typescript
import { prisma } from '../lib/prisma'
import type { User, Post, Prisma } from '@prisma/client'

export const api = {
  // User operations
  async getUsers() {
    return prisma.user.findMany({
      include: {
        posts: true
      }
    })
  },

  async getUserById(id: number) {
    return prisma.user.findUnique({
      where: { id },
      include: {
        posts: true
      }
    })
  },

  async createUser(data: Prisma.UserCreateInput) {
    return prisma.user.create({
      data,
      include: {
        posts: true
      }
    })
  },

  async updateUser(id: number, data: Prisma.UserUpdateInput) {
    return prisma.user.update({
      where: { id },
      data,
      include: {
        posts: true
      }
    })
  },

  async deleteUser(id: number) {
    return prisma.user.delete({
      where: { id }
    })
  },

  // Post operations
  async getPosts() {
    return prisma.post.findMany({
      include: {
        author: true
      }
    })
  },

  async getPostById(id: number) {
    return prisma.post.findUnique({
      where: { id },
      include: {
        author: true
      }
    })
  },

  async createPost(data: Prisma.PostCreateInput) {
    return prisma.post.create({
      data,
      include: {
        author: true
      }
    })
  },

  async updatePost(id: number, data: Prisma.PostUpdateInput) {
    return prisma.post.update({
      where: { id },
      data,
      include: {
        author: true
      }
    })
  },

  async deletePost(id: number) {
    return prisma.post.delete({
      where: { id }
    })
  }
}
```

## TanStack Query Setup

1. Create a query client provider `src/providers/QueryProvider.tsx`:
```typescript
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 1000, // 5 seconds
      retry: 1
    }
  }
})

export function QueryProvider({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  )
}
```

2. Create custom hooks for users `src/hooks/useUsers.ts`:
```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '../services/api'
import type { User, Prisma } from '@prisma/client'

export function useUsers() {
  const queryClient = useQueryClient()

  const usersQuery = useQuery({
    queryKey: ['users'],
    queryFn: () => api.getUsers()
  })

  const createUserMutation = useMutation({
    mutationFn: (data: Prisma.UserCreateInput) => api.createUser(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
    }
  })

  const updateUserMutation = useMutation({
    mutationFn: ({ id, data }: { id: number; data: Prisma.UserUpdateInput }) =>
      api.updateUser(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
    }
  })

  const deleteUserMutation = useMutation({
    mutationFn: (id: number) => api.deleteUser(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
    }
  })

  return {
    users: usersQuery.data,
    isLoading: usersQuery.isLoading,
    error: usersQuery.error,
    createUser: createUserMutation.mutate,
    updateUser: updateUserMutation.mutate,
    deleteUser: deleteUserMutation.mutate
  }
}

export function useUser(id: number) {
  return useQuery({
    queryKey: ['users', id],
    queryFn: () => api.getUserById(id)
  })
}
```

3. Create custom hooks for posts `src/hooks/usePosts.ts`:
```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { api } from '../services/api'
import type { Post, Prisma } from '@prisma/client'

export function usePosts() {
  const queryClient = useQueryClient()

  const postsQuery = useQuery({
    queryKey: ['posts'],
    queryFn: () => api.getPosts()
  })

  const createPostMutation = useMutation({
    mutationFn: (data: Prisma.PostCreateInput) => api.createPost(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['posts'] })
    }
  })

  const updatePostMutation = useMutation({
    mutationFn: ({ id, data }: { id: number; data: Prisma.PostUpdateInput }) =>
      api.updatePost(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['posts'] })
    }
  })

  const deletePostMutation = useMutation({
    mutationFn: (id: number) => api.deletePost(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['posts'] })
    }
  })

  return {
    posts: postsQuery.data,
    isLoading: postsQuery.isLoading,
    error: postsQuery.error,
    createPost: createPostMutation.mutate,
    updatePost: updatePostMutation.mutate,
    deletePost: deletePostMutation.mutate
  }
}

export function usePost(id: number) {
  return useQuery({
    queryKey: ['posts', id],
    queryFn: () => api.getPostById(id)
  })
}
```

## Component Implementation

1. Create a users component `src/components/Users.tsx`:
```typescript
import { useState } from 'react'
import { useUsers } from '../hooks/useUsers'

export function Users() {
  const { users, isLoading, error, createUser, updateUser, deleteUser } = useUsers()
  const [newUser, setNewUser] = useState({ email: '', name: '' })

  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error: {error.message}</div>

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    createUser(newUser)
    setNewUser({ email: '', name: '' })
  }

  return (
    <div>
      <h2>Users</h2>

      <form onSubmit={handleSubmit}>
        <input
          type="email"
          placeholder="Email"
          value={newUser.email}
          onChange={(e) => setNewUser({ ...newUser, email: e.target.value })}
          required
        />
        <input
          type="text"
          placeholder="Name"
          value={newUser.name}
          onChange={(e) => setNewUser({ ...newUser, name: e.target.value })}
        />
        <button type="submit">Add User</button>
      </form>

      <ul>
        {users?.map((user) => (
          <li key={user.id}>
            {user.name} ({user.email})
            <button onClick={() => deleteUser(user.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}
```

2. Create a posts component `src/components/Posts.tsx`:
```typescript
import { useState } from 'react'
import { usePosts } from '../hooks/usePosts'

export function Posts() {
  const { posts, isLoading, error, createPost, updatePost, deletePost } = usePosts()
  const [newPost, setNewPost] = useState({
    title: '',
    content: '',
    authorId: ''
  })

  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error: {error.message}</div>

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    createPost({
      ...newPost,
      authorId: parseInt(newPost.authorId)
    })
    setNewPost({ title: '', content: '', authorId: '' })
  }

  const togglePublish = (id: number, published: boolean) => {
    updatePost({ id, data: { published: !published } })
  }

  return (
    <div>
      <h2>Posts</h2>

      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Title"
          value={newPost.title}
          onChange={(e) => setNewPost({ ...newPost, title: e.target.value })}
          required
        />
        <input
          type="text"
          placeholder="Content"
          value={newPost.content}
          onChange={(e) => setNewPost({ ...newPost, content: e.target.value })}
        />
        <input
          type="number"
          placeholder="Author ID"
          value={newPost.authorId}
          onChange={(e) => setNewPost({ ...newPost, authorId: e.target.value })}
          required
        />
        <button type="submit">Add Post</button>
      </form>

      <ul>
        {posts?.map((post) => (
          <li key={post.id}>
            <h3>{post.title}</h3>
            <p>{post.content}</p>
            <p>By: {post.author.name}</p>
            <button onClick={() => togglePublish(post.id, post.published)}>
              {post.published ? 'Unpublish' : 'Publish'}
            </button>
            <button onClick={() => deletePost(post.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  )
}
```

## App Setup

1. Update your main App component `src/App.tsx`:
```typescript
import { QueryProvider } from './providers/QueryProvider'
import { Users } from './components/Users'
import { Posts } from './components/Posts'

export function App() {
  return (
    <QueryProvider>
      <div>
        <h1>Blog App</h1>
        <Users />
        <Posts />
      </div>
    </QueryProvider>
  )
}
```

## Environment Setup

1. Create `.env` file:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/dbname?schema=public"
```

2. Add `.env` to `.gitignore`:
```
.env
```

## Database Migration

1. Generate Prisma Client:
```bash
npx prisma generate
```

2. Create and apply migrations:
```bash
npx prisma migrate dev --name init
```

## Best Practices

1. Database Connection
   - Use connection pooling in production
   - Keep environment variables secure
   - Use migrations for schema changes

2. TanStack Query Best Practices
   - Configure appropriate stale times
   - Implement proper error handling
   - Use optimistic updates when appropriate
   - Leverage query invalidation

3. Type Safety
   - Use TypeScript for better type safety
   - Leverage Prisma's generated types
   - Define proper interfaces for data structures

4. Performance
   - Use proper indexes in schema
   - Implement pagination for large datasets
   - Cache frequently accessed data
   - Configure proper query stale times

5. Error Handling
   - Implement proper error boundaries
   - Show user-friendly error messages
   - Log errors for debugging

6. Security
   - Validate input data
   - Implement proper authentication
   - Use prepared statements (handled by Prisma)

## Development Workflow

1. Make schema changes in `schema.prisma`
2. Generate migration:
```bash
npx prisma migrate dev --name <migration-name>
```

3. Update Prisma Client:
```bash
npx prisma generate
```

4. Use Prisma Studio for database management:
```bash
npx prisma studio
``` 