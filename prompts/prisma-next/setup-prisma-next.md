---
description: "Guidelines for integrating Prisma ORM with Next.js applications"
globs: "*.tsx,*.ts,next.config.*,app/**/*,src/app/**/*"
---

# Prisma with Next.js Integration Setup Guide

This guide provides step-by-step instructions for integrating Prisma ORM with a Next.js application.

## Prerequisites
- Node.js and npm installed
- Next.js project initialized
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

1. Create a Prisma client instance `lib/prisma.ts`:
```typescript
import { PrismaClient } from '@prisma/client'

const prismaClientSingleton = () => {
  return new PrismaClient()
}

declare global {
  var prisma: undefined | ReturnType<typeof prismaClientSingleton>
}

const prisma = globalThis.prisma ?? prismaClientSingleton()

export default prisma

if (process.env.NODE_ENV !== 'production') globalThis.prisma = prisma
```

## API Routes Implementation

1. Create users API routes `app/api/users/route.ts`:
```typescript
import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET() {
  try {
    const users = await prisma.user.findMany({
      include: {
        posts: true
      }
    })
    return NextResponse.json(users)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch users' },
      { status: 500 }
    )
  }
}

export async function POST(request: Request) {
  try {
    const body = await request.json()
    const user = await prisma.user.create({
      data: body,
      include: {
        posts: true
      }
    })
    return NextResponse.json(user, { status: 201 })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to create user' },
      { status: 500 }
    )
  }
}
```

2. Create user detail API routes `app/api/users/[id]/route.ts`:
```typescript
import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const user = await prisma.user.findUnique({
      where: { id: parseInt(params.id) },
      include: {
        posts: true
      }
    })
    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      )
    }
    return NextResponse.json(user)
  } catch (error) {
    return NextResponse.json(
      { error: `Failed to fetch user ${params.id}` },
      { status: 500 }
    )
  }
}

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const body = await request.json()
    const user = await prisma.user.update({
      where: { id: parseInt(params.id) },
      data: body,
      include: {
        posts: true
      }
    })
    return NextResponse.json(user)
  } catch (error) {
    return NextResponse.json(
      { error: `Failed to update user ${params.id}` },
      { status: 500 }
    )
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    await prisma.user.delete({
      where: { id: parseInt(params.id) }
    })
    return new NextResponse(null, { status: 204 })
  } catch (error) {
    return NextResponse.json(
      { error: `Failed to delete user ${params.id}` },
      { status: 500 }
    )
  }
}
```

3. Create posts API routes `app/api/posts/route.ts`:
```typescript
import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET() {
  try {
    const posts = await prisma.post.findMany({
      include: {
        author: true
      }
    })
    return NextResponse.json(posts)
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch posts' },
      { status: 500 }
    )
  }
}

export async function POST(request: Request) {
  try {
    const body = await request.json()
    const post = await prisma.post.create({
      data: {
        ...body,
        authorId: parseInt(body.authorId)
      },
      include: {
        author: true
      }
    })
    return NextResponse.json(post, { status: 201 })
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to create post' },
      { status: 500 }
    )
  }
}
```

4. Create post detail API routes `app/api/posts/[id]/route.ts`:
```typescript
import { NextResponse } from 'next/server'
import prisma from '@/lib/prisma'

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const post = await prisma.post.findUnique({
      where: { id: parseInt(params.id) },
      include: {
        author: true
      }
    })
    if (!post) {
      return NextResponse.json(
        { error: 'Post not found' },
        { status: 404 }
      )
    }
    return NextResponse.json(post)
  } catch (error) {
    return NextResponse.json(
      { error: `Failed to fetch post ${params.id}` },
      { status: 500 }
    )
  }
}

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const body = await request.json()
    const post = await prisma.post.update({
      where: { id: parseInt(params.id) },
      data: body,
      include: {
        author: true
      }
    })
    return NextResponse.json(post)
  } catch (error) {
    return NextResponse.json(
      { error: `Failed to update post ${params.id}` },
      { status: 500 }
    )
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    await prisma.post.delete({
      where: { id: parseInt(params.id) }
    })
    return new NextResponse(null, { status: 204 })
  } catch (error) {
    return NextResponse.json(
      { error: `Failed to delete post ${params.id}` },
      { status: 500 }
    )
  }
}
```

## Server Actions Implementation

1. Create users actions `app/actions/users.ts`:
```typescript
'use server'

import prisma from '@/lib/prisma'

export async function getUsers() {
  try {
    return await prisma.user.findMany({
      include: {
        posts: true
      }
    })
  } catch (error) {
    throw new Error('Failed to fetch users')
  }
}

export async function createUser(data: { email: string; name?: string }) {
  try {
    return await prisma.user.create({
      data,
      include: {
        posts: true
      }
    })
  } catch (error) {
    throw new Error('Failed to create user')
  }
}

export async function updateUser(id: number, data: { email?: string; name?: string }) {
  try {
    return await prisma.user.update({
      where: { id },
      data,
      include: {
        posts: true
      }
    })
  } catch (error) {
    throw new Error(`Failed to update user ${id}`)
  }
}

export async function deleteUser(id: number) {
  try {
    await prisma.user.delete({
      where: { id }
    })
  } catch (error) {
    throw new Error(`Failed to delete user ${id}`)
  }
}
```

2. Create posts actions `app/actions/posts.ts`:
```typescript
'use server'

import prisma from '@/lib/prisma'

export async function getPosts() {
  try {
    return await prisma.post.findMany({
      include: {
        author: true
      }
    })
  } catch (error) {
    throw new Error('Failed to fetch posts')
  }
}

export async function createPost(data: {
  title: string
  content?: string
  authorId: number
}) {
  try {
    return await prisma.post.create({
      data,
      include: {
        author: true
      }
    })
  } catch (error) {
    throw new Error('Failed to create post')
  }
}

export async function updatePost(
  id: number,
  data: { title?: string; content?: string; published?: boolean }
) {
  try {
    return await prisma.post.update({
      where: { id },
      data,
      include: {
        author: true
      }
    })
  } catch (error) {
    throw new Error(`Failed to update post ${id}`)
  }
}

export async function deletePost(id: number) {
  try {
    await prisma.post.delete({
      where: { id }
    })
  } catch (error) {
    throw new Error(`Failed to delete post ${id}`)
  }
}
```

## Component Implementation

1. Create users page `app/users/page.tsx`:
```typescript
'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { getUsers, createUser, deleteUser } from '@/app/actions/users'
import { useEffect } from 'react'
import type { User } from '@prisma/client'

export default function UsersPage() {
  const router = useRouter()
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [newUser, setNewUser] = useState({ email: '', name: '' })

  useEffect(() => {
    loadUsers()
  }, [])

  async function loadUsers() {
    try {
      const data = await getUsers()
      setUsers(data)
    } catch (e) {
      setError('Failed to load users')
    } finally {
      setLoading(false)
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)
    try {
      await createUser(newUser)
      setNewUser({ email: '', name: '' })
      await loadUsers()
      router.refresh()
    } catch (e) {
      setError('Failed to create user')
    } finally {
      setLoading(false)
    }
  }

  async function handleDelete(id: number) {
    setLoading(true)
    setError(null)
    try {
      await deleteUser(id)
      await loadUsers()
      router.refresh()
    } catch (e) {
      setError(`Failed to delete user ${id}`)
    } finally {
      setLoading(false)
    }
  }

  if (loading) return <div>Loading...</div>
  if (error) return <div className="error">{error}</div>

  return (
    <div>
      <h1>Users</h1>

      <form onSubmit={handleSubmit} className="form">
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
        <button type="submit" disabled={loading}>Add User</button>
      </form>

      <ul className="list">
        {users.map((user) => (
          <li key={user.id} className="list-item">
            <span>{user.name} ({user.email})</span>
            <button
              onClick={() => handleDelete(user.id)}
              disabled={loading}
            >
              Delete
            </button>
          </li>
        ))}
      </ul>

      <style jsx>{`
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
      `}</style>
    </div>
  )
}
```

2. Create posts page `app/posts/page.tsx`:
```typescript
'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { getPosts, createPost, updatePost, deletePost } from '@/app/actions/posts'
import type { Post } from '@prisma/client'

export default function PostsPage() {
  const router = useRouter()
  const [posts, setPosts] = useState<Post[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [newPost, setNewPost] = useState({
    title: '',
    content: '',
    authorId: ''
  })

  useEffect(() => {
    loadPosts()
  }, [])

  async function loadPosts() {
    try {
      const data = await getPosts()
      setPosts(data)
    } catch (e) {
      setError('Failed to load posts')
    } finally {
      setLoading(false)
    }
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)
    try {
      await createPost({
        ...newPost,
        authorId: parseInt(newPost.authorId)
      })
      setNewPost({ title: '', content: '', authorId: '' })
      await loadPosts()
      router.refresh()
    } catch (e) {
      setError('Failed to create post')
    } finally {
      setLoading(false)
    }
  }

  async function handleTogglePublish(id: number, published: boolean) {
    setLoading(true)
    setError(null)
    try {
      await updatePost(id, { published: !published })
      await loadPosts()
      router.refresh()
    } catch (e) {
      setError(`Failed to update post ${id}`)
    } finally {
      setLoading(false)
    }
  }

  async function handleDelete(id: number) {
    setLoading(true)
    setError(null)
    try {
      await deletePost(id)
      await loadPosts()
      router.refresh()
    } catch (e) {
      setError(`Failed to delete post ${id}`)
    } finally {
      setLoading(false)
    }
  }

  if (loading) return <div>Loading...</div>
  if (error) return <div className="error">{error}</div>

  return (
    <div>
      <h1>Posts</h1>

      <form onSubmit={handleSubmit} className="form">
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
        <button type="submit" disabled={loading}>Add Post</button>
      </form>

      <ul className="list">
        {posts.map((post) => (
          <li key={post.id} className="list-item">
            <div className="post-header">
              <h2>{post.title}</h2>
              <div className="post-actions">
                <button
                  onClick={() => handleTogglePublish(post.id, post.published)}
                  disabled={loading}
                >
                  {post.published ? 'Unpublish' : 'Publish'}
                </button>
                <button
                  onClick={() => handleDelete(post.id)}
                  disabled={loading}
                >
                  Delete
                </button>
              </div>
            </div>
            <p>{post.content}</p>
            <p className="post-meta">By: {post.author.name}</p>
          </li>
        ))}
      </ul>

      <style jsx>{`
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
      `}</style>
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
   - Implement proper connection handling

2. Error Handling
   - Implement proper error handling in API routes
   - Show user-friendly error messages
   - Log errors for debugging
   - Use appropriate HTTP status codes

3. Type Safety
   - Use TypeScript for better type safety
   - Leverage Prisma's generated types
   - Define proper interfaces for data structures
   - Use strict type checking

4. Performance
   - Use proper indexes in schema
   - Implement pagination for large datasets
   - Cache frequently accessed data
   - Use server components when appropriate
   - Implement optimistic updates

5. Next.js Best Practices
   - Use server components for data fetching
   - Implement proper loading states
   - Follow Next.js conventions
   - Use server actions for mutations
   - Implement proper error boundaries

6. Security
   - Validate input data
   - Implement proper authentication
   - Use prepared statements (handled by Prisma)
   - Sanitize user input
   - Implement proper CORS policies

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