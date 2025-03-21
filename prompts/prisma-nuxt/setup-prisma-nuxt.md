---
description: "Guidelines for integrating Prisma ORM with Nuxt applications"
globs: "*.vue,*.ts,nuxt.config.*,server/**/*,composables/**/*"
---

# Prisma with Nuxt.js Integration Setup Guide

This guide provides step-by-step instructions for integrating Prisma ORM with a Nuxt.js application.

## Prerequisites
- Node.js and npm installed
- Nuxt.js project initialized
- PostgreSQL database (or any other supported database)

## Installation

1. Install Prisma and its dependencies:
```bash
npm install @prisma/client
npm install -D prisma
```

2. Initialize Prisma in your project:
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

## Database Client Setup

1. Create a Prisma client plugin `server/plugins/prisma.ts`:
```typescript
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export default defineNitroPlugin(async (nitroApp) => {
  nitroApp.prisma = prisma
})
```

2. Create type definitions `types/nitro.d.ts`:
```typescript
import { PrismaClient } from '@prisma/client'

declare module 'nitropack' {
  interface NitroApp {
    prisma: PrismaClient
  }
}
```

## API Routes Implementation

1. Create users API routes `server/api/users/[...].ts`:
```typescript
export default defineEventHandler(async (event) => {
  const prisma = event.context.prisma
  const method = event.method
  const id = event.context.params?.id

  // GET /api/users
  if (method === 'GET' && !id) {
    try {
      const users = await prisma.user.findMany({
        include: {
          posts: true
        }
      })
      return users
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: 'Failed to fetch users'
      })
    }
  }

  // GET /api/users/:id
  if (method === 'GET' && id) {
    try {
      const user = await prisma.user.findUnique({
        where: { id: parseInt(id) },
        include: {
          posts: true
        }
      })
      if (!user) {
        throw createError({
          statusCode: 404,
          message: 'User not found'
        })
      }
      return user
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: `Failed to fetch user ${id}`
      })
    }
  }

  // POST /api/users
  if (method === 'POST') {
    try {
      const body = await readBody(event)
      const user = await prisma.user.create({
        data: body,
        include: {
          posts: true
        }
      })
      return user
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: 'Failed to create user'
      })
    }
  }

  // PUT /api/users/:id
  if (method === 'PUT' && id) {
    try {
      const body = await readBody(event)
      const user = await prisma.user.update({
        where: { id: parseInt(id) },
        data: body,
        include: {
          posts: true
        }
      })
      return user
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: `Failed to update user ${id}`
      })
    }
  }

  // DELETE /api/users/:id
  if (method === 'DELETE' && id) {
    try {
      await prisma.user.delete({
        where: { id: parseInt(id) }
      })
      return { message: 'User deleted successfully' }
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: `Failed to delete user ${id}`
      })
    }
  }
})
```

2. Create posts API routes `server/api/posts/[...].ts`:
```typescript
export default defineEventHandler(async (event) => {
  const prisma = event.context.prisma
  const method = event.method
  const id = event.context.params?.id

  // GET /api/posts
  if (method === 'GET' && !id) {
    try {
      const posts = await prisma.post.findMany({
        include: {
          author: true
        }
      })
      return posts
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: 'Failed to fetch posts'
      })
    }
  }

  // GET /api/posts/:id
  if (method === 'GET' && id) {
    try {
      const post = await prisma.post.findUnique({
        where: { id: parseInt(id) },
        include: {
          author: true
        }
      })
      if (!post) {
        throw createError({
          statusCode: 404,
          message: 'Post not found'
        })
      }
      return post
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: `Failed to fetch post ${id}`
      })
    }
  }

  // POST /api/posts
  if (method === 'POST') {
    try {
      const body = await readBody(event)
      const post = await prisma.post.create({
        data: {
          ...body,
          authorId: parseInt(body.authorId)
        },
        include: {
          author: true
        }
      })
      return post
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: 'Failed to create post'
      })
    }
  }

  // PUT /api/posts/:id
  if (method === 'PUT' && id) {
    try {
      const body = await readBody(event)
      const post = await prisma.post.update({
        where: { id: parseInt(id) },
        data: body,
        include: {
          author: true
        }
      })
      return post
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: `Failed to update post ${id}`
      })
    }
  }

  // DELETE /api/posts/:id
  if (method === 'DELETE' && id) {
    try {
      await prisma.post.delete({
        where: { id: parseInt(id) }
      })
      return { message: 'Post deleted successfully' }
    } catch (error) {
      throw createError({
        statusCode: 500,
        message: `Failed to delete post ${id}`
      })
    }
  }
})
```

## Composables Implementation

1. Create users composable `composables/useUsers.ts`:
```typescript
export const useUsers = () => {
  const { data: users, refresh: refreshUsers, error: usersError } = useFetch('/api/users')
  const loading = ref(false)
  const error = ref<string | null>(null)

  const createUser = async (userData: { email: string; name?: string }) => {
    loading.value = true
    error.value = null
    try {
      await $fetch('/api/users', {
        method: 'POST',
        body: userData
      })
      await refreshUsers()
    } catch (e) {
      error.value = 'Failed to create user'
      console.error('Failed to create user:', e)
    } finally {
      loading.value = false
    }
  }

  const updateUser = async (id: number, userData: { email?: string; name?: string }) => {
    loading.value = true
    error.value = null
    try {
      await $fetch(`/api/users/${id}`, {
        method: 'PUT',
        body: userData
      })
      await refreshUsers()
    } catch (e) {
      error.value = `Failed to update user ${id}`
      console.error(`Failed to update user ${id}:`, e)
    } finally {
      loading.value = false
    }
  }

  const deleteUser = async (id: number) => {
    loading.value = true
    error.value = null
    try {
      await $fetch(`/api/users/${id}`, {
        method: 'DELETE'
      })
      await refreshUsers()
    } catch (e) {
      error.value = `Failed to delete user ${id}`
      console.error(`Failed to delete user ${id}:`, e)
    } finally {
      loading.value = false
    }
  }

  return {
    users,
    loading,
    error: error.value || usersError.value,
    createUser,
    updateUser,
    deleteUser
  }
}
```

2. Create posts composable `composables/usePosts.ts`:
```typescript
export const usePosts = () => {
  const { data: posts, refresh: refreshPosts, error: postsError } = useFetch('/api/posts')
  const loading = ref(false)
  const error = ref<string | null>(null)

  const createPost = async (postData: {
    title: string
    content?: string
    authorId: number
  }) => {
    loading.value = true
    error.value = null
    try {
      await $fetch('/api/posts', {
        method: 'POST',
        body: postData
      })
      await refreshPosts()
    } catch (e) {
      error.value = 'Failed to create post'
      console.error('Failed to create post:', e)
    } finally {
      loading.value = false
    }
  }

  const updatePost = async (
    id: number,
    postData: { title?: string; content?: string; published?: boolean }
  ) => {
    loading.value = true
    error.value = null
    try {
      await $fetch(`/api/posts/${id}`, {
        method: 'PUT',
        body: postData
      })
      await refreshPosts()
    } catch (e) {
      error.value = `Failed to update post ${id}`
      console.error(`Failed to update post ${id}:`, e)
    } finally {
      loading.value = false
    }
  }

  const deletePost = async (id: number) => {
    loading.value = true
    error.value = null
    try {
      await $fetch(`/api/posts/${id}`, {
        method: 'DELETE'
      })
      await refreshPosts()
    } catch (e) {
      error.value = `Failed to delete post ${id}`
      console.error(`Failed to delete post ${id}:`, e)
    } finally {
      loading.value = false
    }
  }

  return {
    posts,
    loading,
    error: error.value || postsError.value,
    createPost,
    updatePost,
    deletePost
  }
}
```

## Pages Implementation

1. Create users page `pages/users.vue`:
```vue
<script setup lang="ts">
const { users, loading, error, createUser, deleteUser } = useUsers()
const newUser = ref({ email: '', name: '' })

const handleSubmit = async () => {
  await createUser(newUser.value)
  newUser.value = { email: '', name: '' }
}
</script>

<template>
  <div>
    <h1>Users</h1>

    <div v-if="error" class="error">
      {{ error }}
    </div>

    <form @submit.prevent="handleSubmit" class="form">
      <input
        v-model="newUser.email"
        type="email"
        placeholder="Email"
        required
      />
      <input
        v-model="newUser.name"
        type="text"
        placeholder="Name"
      />
      <button type="submit" :disabled="loading">Add User</button>
    </form>

    <div v-if="loading">Loading...</div>

    <ul v-else class="list">
      <li v-for="user in users" :key="user.id" class="list-item">
        <span>{{ user.name }} ({{ user.email }})</span>
        <button
          @click="deleteUser(user.id)"
          :disabled="loading"
        >
          Delete
        </button>
      </li>
    </ul>
  </div>
</template>

<style scoped>
.error {
  color: red;
  margin-bottom: 1rem;
}

.form {
  margin-bottom: 2rem;
}

.form input {
  margin-right: 0.5rem;
}

.list {
  list-style: none;
  padding: 0;
}

.list-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem;
  border-bottom: 1px solid #eee;
}

.list-item button {
  margin-left: 1rem;
}
</style>
```

2. Create posts page `pages/posts.vue`:
```vue
<script setup lang="ts">
const { posts, loading, error, createPost, updatePost, deletePost } = usePosts()
const newPost = ref({
  title: '',
  content: '',
  authorId: ''
})

const handleSubmit = async () => {
  await createPost({
    ...newPost.value,
    authorId: parseInt(newPost.value.authorId)
  })
  newPost.value = { title: '', content: '', authorId: '' }
}

const togglePublish = async (id: number, published: boolean) => {
  await updatePost(id, { published: !published })
}
</script>

<template>
  <div>
    <h1>Posts</h1>

    <div v-if="error" class="error">
      {{ error }}
    </div>

    <form @submit.prevent="handleSubmit" class="form">
      <input
        v-model="newPost.title"
        type="text"
        placeholder="Title"
        required
      />
      <input
        v-model="newPost.content"
        type="text"
        placeholder="Content"
      />
      <input
        v-model="newPost.authorId"
        type="number"
        placeholder="Author ID"
        required
      />
      <button type="submit" :disabled="loading">Add Post</button>
    </form>

    <div v-if="loading">Loading...</div>

    <ul v-else class="list">
      <li v-for="post in posts" :key="post.id" class="list-item">
        <div class="post-header">
          <h2>{{ post.title }}</h2>
          <div class="post-actions">
            <button
              @click="togglePublish(post.id, post.published)"
              :disabled="loading"
            >
              {{ post.published ? 'Unpublish' : 'Publish' }}
            </button>
            <button
              @click="deletePost(post.id)"
              :disabled="loading"
            >
              Delete
            </button>
          </div>
        </div>
        <p>{{ post.content }}</p>
        <p class="post-meta">By: {{ post.author.name }}</p>
      </li>
    </ul>
  </div>
</template>

<style scoped>
.error {
  color: red;
  margin-bottom: 1rem;
}

.form {
  margin-bottom: 2rem;
}

.form input {
  margin-right: 0.5rem;
}

.list {
  list-style: none;
  padding: 0;
}

.list-item {
  margin-bottom: 2rem;
  padding: 1rem;
  border: 1px solid #eee;
  border-radius: 4px;
}

.post-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.post-header h2 {
  margin: 0;
}

.post-actions button {
  margin-left: 0.5rem;
}

.post-meta {
  color: #666;
  font-size: 0.9rem;
  margin-top: 1rem;
}
</style>
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

2. Error Handling
   - Implement proper error handling in API routes
   - Show user-friendly error messages
   - Log errors for debugging

3. Type Safety
   - Use TypeScript for better type safety
   - Leverage Prisma's generated types
   - Define proper interfaces for data structures

4. Performance
   - Use proper indexes in schema
   - Implement pagination for large datasets
   - Cache frequently accessed data
   - Use SSR when appropriate

5. Nuxt.js Best Practices
   - Use composables for reusable logic
   - Implement proper loading states
   - Follow Nuxt.js conventions

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