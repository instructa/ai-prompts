---
description: "Guidelines for integrating Prisma ORM with Vue applications"
globs: "*.vue,*.ts,vite.config.*,src/**/*,composables/**/*"
---

# Prisma with Vue.js Integration Setup Guide

This guide provides step-by-step instructions for integrating Prisma ORM with a Vue.js application.

## Prerequisites
- Node.js and npm installed
- Vue.js project initialized
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

## API Service Setup

1. Create a Prisma service file `src/services/prisma.ts`:
```typescript
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export default prisma
```

2. Create a users service `src/services/users.ts`:
```typescript
import prisma from './prisma'
import type { User } from '@prisma/client'

export const userService = {
  async getUsers() {
    try {
      return await prisma.user.findMany({
        include: {
          posts: true
        }
      })
    } catch (error) {
      console.error('Failed to fetch users:', error)
      throw error
    }
  },

  async getUserById(id: number) {
    try {
      return await prisma.user.findUnique({
        where: { id },
        include: {
          posts: true
        }
      })
    } catch (error) {
      console.error(`Failed to fetch user ${id}:`, error)
      throw error
    }
  },

  async createUser(data: { email: string; name?: string }) {
    try {
      return await prisma.user.create({
        data,
        include: {
          posts: true
        }
      })
    } catch (error) {
      console.error('Failed to create user:', error)
      throw error
    }
  },

  async updateUser(id: number, data: { email?: string; name?: string }) {
    try {
      return await prisma.user.update({
        where: { id },
        data,
        include: {
          posts: true
        }
      })
    } catch (error) {
      console.error(`Failed to update user ${id}:`, error)
      throw error
    }
  },

  async deleteUser(id: number) {
    try {
      return await prisma.user.delete({
        where: { id }
      })
    } catch (error) {
      console.error(`Failed to delete user ${id}:`, error)
      throw error
    }
  }
}
```

3. Create a posts service `src/services/posts.ts`:
```typescript
import prisma from './prisma'
import type { Post } from '@prisma/client'

export const postService = {
  async getPosts() {
    try {
      return await prisma.post.findMany({
        include: {
          author: true
        }
      })
    } catch (error) {
      console.error('Failed to fetch posts:', error)
      throw error
    }
  },

  async getPostById(id: number) {
    try {
      return await prisma.post.findUnique({
        where: { id },
        include: {
          author: true
        }
      })
    } catch (error) {
      console.error(`Failed to fetch post ${id}:`, error)
      throw error
    }
  },

  async createPost(data: { title: string; content?: string; authorId: number }) {
    try {
      return await prisma.post.create({
        data,
        include: {
          author: true
        }
      })
    } catch (error) {
      console.error('Failed to create post:', error)
      throw error
    }
  },

  async updatePost(id: number, data: { title?: string; content?: string; published?: boolean }) {
    try {
      return await prisma.post.update({
        where: { id },
        data,
        include: {
          author: true
        }
      })
    } catch (error) {
      console.error(`Failed to update post ${id}:`, error)
      throw error
    }
  },

  async deletePost(id: number) {
    try {
      return await prisma.post.delete({
        where: { id }
      })
    } catch (error) {
      console.error(`Failed to delete post ${id}:`, error)
      throw error
    }
  }
}
```

## Vue Components Implementation

1. Create a Users component `src/components/Users.vue`:
```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { userService } from '@/services/users'
import type { User } from '@prisma/client'

const users = ref<User[]>([])
const newUser = ref({ email: '', name: '' })
const error = ref('')

onMounted(async () => {
  try {
    users.value = await userService.getUsers()
  } catch (e) {
    error.value = 'Failed to load users'
  }
})

async function createUser() {
  try {
    const user = await userService.createUser(newUser.value)
    users.value.push(user)
    newUser.value = { email: '', name: '' }
  } catch (e) {
    error.value = 'Failed to create user'
  }
}

async function deleteUser(id: number) {
  try {
    await userService.deleteUser(id)
    users.value = users.value.filter(user => user.id !== id)
  } catch (e) {
    error.value = `Failed to delete user ${id}`
  }
}
</script>

<template>
  <div>
    <h2>Users</h2>
    
    <div v-if="error" class="error">
      {{ error }}
    </div>

    <form @submit.prevent="createUser">
      <input v-model="newUser.email" type="email" placeholder="Email" required>
      <input v-model="newUser.name" placeholder="Name">
      <button type="submit">Add User</button>
    </form>

    <ul>
      <li v-for="user in users" :key="user.id">
        {{ user.name }} ({{ user.email }})
        <button @click="deleteUser(user.id)">Delete</button>
      </li>
    </ul>
  </div>
</template>

<style scoped>
.error {
  color: red;
  margin-bottom: 1rem;
}

form {
  margin-bottom: 1rem;
}

input {
  margin-right: 0.5rem;
}

ul {
  list-style: none;
  padding: 0;
}

li {
  margin-bottom: 0.5rem;
}

button {
  margin-left: 0.5rem;
}
</style>
```

2. Create a Posts component `src/components/Posts.vue`:
```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { postService } from '@/services/posts'
import type { Post, User } from '@prisma/client'

const posts = ref<Post[]>([])
const newPost = ref({ title: '', content: '', authorId: 0 })
const error = ref('')

onMounted(async () => {
  try {
    posts.value = await postService.getPosts()
  } catch (e) {
    error.value = 'Failed to load posts'
  }
})

async function createPost() {
  try {
    const post = await postService.createPost(newPost.value)
    posts.value.push(post)
    newPost.value = { title: '', content: '', authorId: 0 }
  } catch (e) {
    error.value = 'Failed to create post'
  }
}

async function deletePost(id: number) {
  try {
    await postService.deletePost(id)
    posts.value = posts.value.filter(post => post.id !== id)
  } catch (e) {
    error.value = `Failed to delete post ${id}`
  }
}

async function togglePublish(post: Post) {
  try {
    const updatedPost = await postService.updatePost(post.id, {
      published: !post.published
    })
    const index = posts.value.findIndex(p => p.id === post.id)
    if (index !== -1) {
      posts.value[index] = updatedPost
    }
  } catch (e) {
    error.value = `Failed to update post ${post.id}`
  }
}
</script>

<template>
  <div>
    <h2>Posts</h2>
    
    <div v-if="error" class="error">
      {{ error }}
    </div>

    <form @submit.prevent="createPost">
      <input v-model="newPost.title" placeholder="Title" required>
      <input v-model="newPost.content" placeholder="Content">
      <input v-model.number="newPost.authorId" type="number" placeholder="Author ID" required>
      <button type="submit">Add Post</button>
    </form>

    <ul>
      <li v-for="post in posts" :key="post.id">
        <h3>{{ post.title }}</h3>
        <p>{{ post.content }}</p>
        <p>By: {{ post.author.name }}</p>
        <button @click="togglePublish(post)">
          {{ post.published ? 'Unpublish' : 'Publish' }}
        </button>
        <button @click="deletePost(post.id)">Delete</button>
      </li>
    </ul>
  </div>
</template>

<style scoped>
.error {
  color: red;
  margin-bottom: 1rem;
}

form {
  margin-bottom: 1rem;
}

input {
  margin-right: 0.5rem;
}

ul {
  list-style: none;
  padding: 0;
}

li {
  margin-bottom: 1rem;
  padding: 1rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

h3 {
  margin: 0 0 0.5rem 0;
}

p {
  margin: 0.5rem 0;
}

button {
  margin-right: 0.5rem;
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
   - Implement proper error handling in services
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

5. Security
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