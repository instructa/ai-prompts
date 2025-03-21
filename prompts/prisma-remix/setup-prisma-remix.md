---
description: "Guidelines for integrating Prisma ORM with Remix applications"
globs: "*.tsx,*.ts,app/**/*,server/**/*,remix.config.*"
---

# Prisma with Remix Integration Setup Guide

This guide provides step-by-step instructions for integrating Prisma ORM with a Remix application.

## Prerequisites
- Node.js and npm installed
- Remix project initialized
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

1. Create a database client file `app/db.server.ts`:
```typescript
import { PrismaClient } from '@prisma/client'

let prisma: PrismaClient

declare global {
  var __db__: PrismaClient
}

// This is needed because in development we don't want to restart
// the server with every change, but we want to make sure we don't
// create a new connection to the DB with every change either.
if (process.env.NODE_ENV === 'production') {
  prisma = new PrismaClient()
} else {
  if (!global.__db__) {
    global.__db__ = new PrismaClient()
  }
  prisma = global.__db__
  prisma.$connect()
}

export { prisma }
```

## Models Implementation

1. Create a users model `app/models/user.server.ts`:
```typescript
import type { User } from '@prisma/client'
import { prisma } from '~/db.server'

export async function getUsers() {
  return prisma.user.findMany({
    include: {
      posts: true
    }
  })
}

export async function getUserById(id: number) {
  return prisma.user.findUnique({
    where: { id },
    include: {
      posts: true
    }
  })
}

export async function createUser(data: Pick<User, 'email' | 'name'>) {
  return prisma.user.create({
    data,
    include: {
      posts: true
    }
  })
}

export async function updateUser(id: number, data: Partial<Pick<User, 'email' | 'name'>>) {
  return prisma.user.update({
    where: { id },
    data,
    include: {
      posts: true
    }
  })
}

export async function deleteUser(id: number) {
  return prisma.user.delete({
    where: { id }
  })
}
```

2. Create a posts model `app/models/post.server.ts`:
```typescript
import type { Post } from '@prisma/client'
import { prisma } from '~/db.server'

export async function getPosts() {
  return prisma.post.findMany({
    include: {
      author: true
    }
  })
}

export async function getPostById(id: number) {
  return prisma.post.findUnique({
    where: { id },
    include: {
      author: true
    }
  })
}

export async function createPost(data: Pick<Post, 'title' | 'content' | 'authorId'>) {
  return prisma.post.create({
    data,
    include: {
      author: true
    }
  })
}

export async function updatePost(
  id: number,
  data: Partial<Pick<Post, 'title' | 'content' | 'published'>>
) {
  return prisma.post.update({
    where: { id },
    data,
    include: {
      author: true
    }
  })
}

export async function deletePost(id: number) {
  return prisma.post.delete({
    where: { id }
  })
}
```

## Route Implementation

1. Create a users route `app/routes/users.tsx`:
```typescript
import { json, type LoaderFunction, type ActionFunction } from '@remix-run/node'
import { useLoaderData, Form, useActionData } from '@remix-run/react'
import { getUsers, createUser, deleteUser } from '~/models/user.server'

export const loader: LoaderFunction = async () => {
  const users = await getUsers()
  return json({ users })
}

export const action: ActionFunction = async ({ request }) => {
  const formData = await request.formData()
  const intent = formData.get('intent')

  if (intent === 'create') {
    const email = formData.get('email')
    const name = formData.get('name')

    if (typeof email !== 'string' || typeof name !== 'string') {
      return json({ error: 'Invalid form data' }, { status: 400 })
    }

    try {
      const user = await createUser({ email, name })
      return json({ user })
    } catch (error) {
      return json({ error: 'Failed to create user' }, { status: 500 })
    }
  }

  if (intent === 'delete') {
    const userId = formData.get('userId')

    if (typeof userId !== 'string') {
      return json({ error: 'Invalid user ID' }, { status: 400 })
    }

    try {
      await deleteUser(parseInt(userId))
      return json({ success: true })
    } catch (error) {
      return json({ error: 'Failed to delete user' }, { status: 500 })
    }
  }

  return json({ error: 'Invalid intent' }, { status: 400 })
}

export default function Users() {
  const { users } = useLoaderData<typeof loader>()
  const actionData = useActionData<typeof action>()

  return (
    <div>
      <h1>Users</h1>

      {actionData?.error && (
        <div className="error">{actionData.error}</div>
      )}

      <Form method="post" className="user-form">
        <input type="hidden" name="intent" value="create" />
        <input
          type="email"
          name="email"
          placeholder="Email"
          required
        />
        <input
          type="text"
          name="name"
          placeholder="Name"
        />
        <button type="submit">Add User</button>
      </Form>

      <ul className="user-list">
        {users.map((user) => (
          <li key={user.id}>
            <span>{user.name} ({user.email})</span>
            <Form method="post" style={{ display: 'inline' }}>
              <input type="hidden" name="intent" value="delete" />
              <input type="hidden" name="userId" value={user.id} />
              <button type="submit">Delete</button>
            </Form>
          </li>
        ))}
      </ul>

      <style>
        {`
          .error {
            color: red;
            margin-bottom: 1rem;
          }

          .user-form {
            margin-bottom: 2rem;
          }

          .user-form input {
            margin-right: 0.5rem;
          }

          .user-list {
            list-style: none;
            padding: 0;
          }

          .user-list li {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem;
            border-bottom: 1px solid #eee;
          }

          .user-list button {
            margin-left: 1rem;
          }
        `}
      </style>
    </div>
  )
}
```

2. Create a posts route `app/routes/posts.tsx`:
```typescript
import { json, type LoaderFunction, type ActionFunction } from '@remix-run/node'
import { useLoaderData, Form, useActionData } from '@remix-run/react'
import { getPosts, createPost, updatePost, deletePost } from '~/models/post.server'

export const loader: LoaderFunction = async () => {
  const posts = await getPosts()
  return json({ posts })
}

export const action: ActionFunction = async ({ request }) => {
  const formData = await request.formData()
  const intent = formData.get('intent')

  if (intent === 'create') {
    const title = formData.get('title')
    const content = formData.get('content')
    const authorId = formData.get('authorId')

    if (
      typeof title !== 'string' ||
      typeof content !== 'string' ||
      typeof authorId !== 'string'
    ) {
      return json({ error: 'Invalid form data' }, { status: 400 })
    }

    try {
      const post = await createPost({
        title,
        content,
        authorId: parseInt(authorId)
      })
      return json({ post })
    } catch (error) {
      return json({ error: 'Failed to create post' }, { status: 500 })
    }
  }

  if (intent === 'update') {
    const postId = formData.get('postId')
    const published = formData.get('published')

    if (typeof postId !== 'string' || typeof published !== 'string') {
      return json({ error: 'Invalid form data' }, { status: 400 })
    }

    try {
      const post = await updatePost(parseInt(postId), {
        published: published === 'true'
      })
      return json({ post })
    } catch (error) {
      return json({ error: 'Failed to update post' }, { status: 500 })
    }
  }

  if (intent === 'delete') {
    const postId = formData.get('postId')

    if (typeof postId !== 'string') {
      return json({ error: 'Invalid post ID' }, { status: 400 })
    }

    try {
      await deletePost(parseInt(postId))
      return json({ success: true })
    } catch (error) {
      return json({ error: 'Failed to delete post' }, { status: 500 })
    }
  }

  return json({ error: 'Invalid intent' }, { status: 400 })
}

export default function Posts() {
  const { posts } = useLoaderData<typeof loader>()
  const actionData = useActionData<typeof action>()

  return (
    <div>
      <h1>Posts</h1>

      {actionData?.error && (
        <div className="error">{actionData.error}</div>
      )}

      <Form method="post" className="post-form">
        <input type="hidden" name="intent" value="create" />
        <input
          type="text"
          name="title"
          placeholder="Title"
          required
        />
        <input
          type="text"
          name="content"
          placeholder="Content"
        />
        <input
          type="number"
          name="authorId"
          placeholder="Author ID"
          required
        />
        <button type="submit">Add Post</button>
      </Form>

      <ul className="post-list">
        {posts.map((post) => (
          <li key={post.id}>
            <div className="post-header">
              <h2>{post.title}</h2>
              <div className="post-actions">
                <Form method="post" style={{ display: 'inline' }}>
                  <input type="hidden" name="intent" value="update" />
                  <input type="hidden" name="postId" value={post.id} />
                  <input
                    type="hidden"
                    name="published"
                    value={(!post.published).toString()}
                  />
                  <button type="submit">
                    {post.published ? 'Unpublish' : 'Publish'}
                  </button>
                </Form>
                <Form method="post" style={{ display: 'inline' }}>
                  <input type="hidden" name="intent" value="delete" />
                  <input type="hidden" name="postId" value={post.id} />
                  <button type="submit">Delete</button>
                </Form>
              </div>
            </div>
            <p>{post.content}</p>
            <p className="post-meta">By: {post.author.name}</p>
          </li>
        ))}
      </ul>

      <style>
        {`
          .error {
            color: red;
            margin-bottom: 1rem;
          }

          .post-form {
            margin-bottom: 2rem;
          }

          .post-form input {
            margin-right: 0.5rem;
          }

          .post-list {
            list-style: none;
            padding: 0;
          }

          .post-list li {
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
        `}
      </style>
    </div>
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

2. Error Handling
   - Implement proper error handling in models
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

5. Remix Best Practices
   - Use loader and action functions
   - Implement proper form handling
   - Follow Remix conventions

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