---
description: "Guidelines for integrating Prisma ORM with Astro applications"
globs: "*.astro,*.ts,astro.config.*,env.d.ts"
---

# Prisma with Astro Integration Setup Guide

This guide provides step-by-step instructions for integrating Prisma ORM with an Astro application.

## Prerequisites
- Node.js and npm installed
- Astro project initialized
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

1. Create a database client file `src/lib/prisma.ts`:
```typescript
import { PrismaClient } from '@prisma/client'

let prisma: PrismaClient

declare global {
  var prisma: PrismaClient
}

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

## API Endpoints Implementation

1. Create an API endpoint for users `src/pages/api/users/index.ts`:
```typescript
import type { APIRoute } from 'astro'
import { prisma } from '../../../lib/prisma'

export const get: APIRoute = async () => {
  try {
    const users = await prisma.user.findMany({
      include: {
        posts: true
      }
    })
    return new Response(JSON.stringify(users), {
      status: 200,
      headers: {
        'Content-Type': 'application/json'
      }
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to fetch users' }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    })
  }
}

export const post: APIRoute = async ({ request }) => {
  try {
    const body = await request.json()
    const { email, name } = body

    const user = await prisma.user.create({
      data: {
        email,
        name
      },
      include: {
        posts: true
      }
    })

    return new Response(JSON.stringify(user), {
      status: 201,
      headers: {
        'Content-Type': 'application/json'
      }
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to create user' }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    })
  }
}
```

2. Create an API endpoint for posts `src/pages/api/posts/index.ts`:
```typescript
import type { APIRoute } from 'astro'
import { prisma } from '../../../lib/prisma'

export const get: APIRoute = async () => {
  try {
    const posts = await prisma.post.findMany({
      include: {
        author: true
      }
    })
    return new Response(JSON.stringify(posts), {
      status: 200,
      headers: {
        'Content-Type': 'application/json'
      }
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to fetch posts' }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    })
  }
}

export const post: APIRoute = async ({ request }) => {
  try {
    const body = await request.json()
    const { title, content, authorId } = body

    const post = await prisma.post.create({
      data: {
        title,
        content,
        authorId: parseInt(authorId)
      },
      include: {
        author: true
      }
    })

    return new Response(JSON.stringify(post), {
      status: 201,
      headers: {
        'Content-Type': 'application/json'
      }
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: 'Failed to create post' }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    })
  }
}
```

## Frontend Implementation

1. Create a users page `src/pages/users.astro`:
```astro
---
import Layout from '../layouts/Layout.astro'
import { prisma } from '../lib/prisma'

const users = await prisma.user.findMany({
  include: {
    posts: true
  }
})
---

<Layout title="Users">
  <main>
    <h1>Users</h1>

    <form id="userForm" class="user-form">
      <input type="email" name="email" placeholder="Email" required />
      <input type="text" name="name" placeholder="Name" />
      <button type="submit">Add User</button>
    </form>

    <ul class="user-list">
      {users.map((user) => (
        <li>
          <span>{user.name} ({user.email})</span>
          <button class="delete-user" data-user-id={user.id}>Delete</button>
        </li>
      ))}
    </ul>
  </main>
</Layout>

<style>
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
</style>

<script>
  const userForm = document.getElementById('userForm')
  const userList = document.querySelector('.user-list')

  userForm?.addEventListener('submit', async (e) => {
    e.preventDefault()
    const formData = new FormData(e.target as HTMLFormElement)
    const data = {
      email: formData.get('email'),
      name: formData.get('name')
    }

    try {
      const response = await fetch('/api/users', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })

      if (!response.ok) throw new Error('Failed to create user')

      const user = await response.json()
      const li = document.createElement('li')
      li.innerHTML = `
        <span>${user.name} (${user.email})</span>
        <button class="delete-user" data-user-id="${user.id}">Delete</button>
      `
      userList?.appendChild(li)
      ;(e.target as HTMLFormElement).reset()
    } catch (error) {
      console.error('Failed to create user:', error)
    }
  })

  userList?.addEventListener('click', async (e) => {
    const target = e.target as HTMLElement
    if (target.classList.contains('delete-user')) {
      const userId = target.getAttribute('data-user-id')
      try {
        const response = await fetch(`/api/users/${userId}`, {
          method: 'DELETE'
        })

        if (!response.ok) throw new Error('Failed to delete user')

        target.closest('li')?.remove()
      } catch (error) {
        console.error('Failed to delete user:', error)
      }
    }
  })
</script>
```

2. Create a posts page `src/pages/posts.astro`:
```astro
---
import Layout from '../layouts/Layout.astro'
import { prisma } from '../lib/prisma'

const posts = await prisma.post.findMany({
  include: {
    author: true
  }
})
---

<Layout title="Posts">
  <main>
    <h1>Posts</h1>

    <form id="postForm" class="post-form">
      <input type="text" name="title" placeholder="Title" required />
      <input type="text" name="content" placeholder="Content" />
      <input type="number" name="authorId" placeholder="Author ID" required />
      <button type="submit">Add Post</button>
    </form>

    <ul class="post-list">
      {posts.map((post) => (
        <li>
          <div class="post-header">
            <h2>{post.title}</h2>
            <div class="post-actions">
              <button
                class="toggle-publish"
                data-post-id={post.id}
                data-published={post.published}
              >
                {post.published ? 'Unpublish' : 'Publish'}
              </button>
              <button class="delete-post" data-post-id={post.id}>
                Delete
              </button>
            </div>
          </div>
          <p>{post.content}</p>
          <p class="post-meta">By: {post.author.name}</p>
        </li>
      ))}
    </ul>
  </main>
</Layout>

<style>
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
</style>

<script>
  const postForm = document.getElementById('postForm')
  const postList = document.querySelector('.post-list')

  postForm?.addEventListener('submit', async (e) => {
    e.preventDefault()
    const formData = new FormData(e.target as HTMLFormElement)
    const data = {
      title: formData.get('title'),
      content: formData.get('content'),
      authorId: formData.get('authorId')
    }

    try {
      const response = await fetch('/api/posts', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })

      if (!response.ok) throw new Error('Failed to create post')

      const post = await response.json()
      const li = document.createElement('li')
      li.innerHTML = `
        <div class="post-header">
          <h2>${post.title}</h2>
          <div class="post-actions">
            <button
              class="toggle-publish"
              data-post-id="${post.id}"
              data-published="false"
            >
              Publish
            </button>
            <button class="delete-post" data-post-id="${post.id}">
              Delete
            </button>
          </div>
        </div>
        <p>${post.content}</p>
        <p class="post-meta">By: ${post.author.name}</p>
      `
      postList?.appendChild(li)
      ;(e.target as HTMLFormElement).reset()
    } catch (error) {
      console.error('Failed to create post:', error)
    }
  })

  postList?.addEventListener('click', async (e) => {
    const target = e.target as HTMLElement
    if (target.classList.contains('delete-post')) {
      const postId = target.getAttribute('data-post-id')
      try {
        const response = await fetch(`/api/posts/${postId}`, {
          method: 'DELETE'
        })

        if (!response.ok) throw new Error('Failed to delete post')

        target.closest('li')?.remove()
      } catch (error) {
        console.error('Failed to delete post:', error)
      }
    }

    if (target.classList.contains('toggle-publish')) {
      const postId = target.getAttribute('data-post-id')
      const published = target.getAttribute('data-published') === 'true'
      try {
        const response = await fetch(`/api/posts/${postId}`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ published: !published })
        })

        if (!response.ok) throw new Error('Failed to update post')

        const post = await response.json()
        target.textContent = post.published ? 'Unpublish' : 'Publish'
        target.setAttribute('data-published', post.published.toString())
      } catch (error) {
        console.error('Failed to update post:', error)
      }
    }
  })
</script>
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

5. Astro Best Practices
   - Use server-side rendering when possible
   - Implement proper client-side hydration
   - Follow Astro conventions

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