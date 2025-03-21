---
description: "Guidelines for integrating Prisma ORM with JavaScript applications"
globs: "*.js,*.mjs,*.cjs"
---

# Prisma with JavaScript Integration Setup Guide

This guide provides step-by-step instructions for integrating Prisma ORM with a JavaScript application.

## Prerequisites
- Node.js and npm installed
- JavaScript project initialized
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

1. Create a database client file `src/db.js`:
```javascript
const { PrismaClient } = require('@prisma/client')

let prisma

// This is needed because in development we don't want to restart
// the server with every change, but we want to make sure we don't
// create a new connection to the DB with every change either.
if (process.env.NODE_ENV === 'production') {
  prisma = new PrismaClient()
} else {
  if (!global.prisma) {
    global.prisma = new PrismaClient()
  }
  prisma = global.prisma
}

module.exports = prisma
```

## Models Implementation

1. Create a users model `src/models/user.js`:
```javascript
const prisma = require('../db')

const userModel = {
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

  async getUserById(id) {
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

  async createUser(data) {
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

  async updateUser(id, data) {
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

  async deleteUser(id) {
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

module.exports = userModel
```

2. Create a posts model `src/models/post.js`:
```javascript
const prisma = require('../db')

const postModel = {
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

  async getPostById(id) {
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

  async createPost(data) {
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

  async updatePost(id, data) {
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

  async deletePost(id) {
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

module.exports = postModel
```

## Express.js API Implementation

1. Install Express.js:
```bash
npm install express cors
```

2. Create an Express server `src/server.js`:
```javascript
const express = require('express')
const cors = require('cors')
const userModel = require('./models/user')
const postModel = require('./models/post')

const app = express()
app.use(cors())
app.use(express.json())

// User routes
app.get('/api/users', async (req, res) => {
  try {
    const users = await userModel.getUsers()
    res.json(users)
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch users' })
  }
})

app.get('/api/users/:id', async (req, res) => {
  try {
    const user = await userModel.getUserById(parseInt(req.params.id))
    if (!user) {
      return res.status(404).json({ error: 'User not found' })
    }
    res.json(user)
  } catch (error) {
    res.status(500).json({ error: `Failed to fetch user ${req.params.id}` })
  }
})

app.post('/api/users', async (req, res) => {
  try {
    const user = await userModel.createUser(req.body)
    res.status(201).json(user)
  } catch (error) {
    res.status(500).json({ error: 'Failed to create user' })
  }
})

app.put('/api/users/:id', async (req, res) => {
  try {
    const user = await userModel.updateUser(parseInt(req.params.id), req.body)
    res.json(user)
  } catch (error) {
    res.status(500).json({ error: `Failed to update user ${req.params.id}` })
  }
})

app.delete('/api/users/:id', async (req, res) => {
  try {
    await userModel.deleteUser(parseInt(req.params.id))
    res.status(204).end()
  } catch (error) {
    res.status(500).json({ error: `Failed to delete user ${req.params.id}` })
  }
})

// Post routes
app.get('/api/posts', async (req, res) => {
  try {
    const posts = await postModel.getPosts()
    res.json(posts)
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch posts' })
  }
})

app.get('/api/posts/:id', async (req, res) => {
  try {
    const post = await postModel.getPostById(parseInt(req.params.id))
    if (!post) {
      return res.status(404).json({ error: 'Post not found' })
    }
    res.json(post)
  } catch (error) {
    res.status(500).json({ error: `Failed to fetch post ${req.params.id}` })
  }
})

app.post('/api/posts', async (req, res) => {
  try {
    const post = await postModel.createPost(req.body)
    res.status(201).json(post)
  } catch (error) {
    res.status(500).json({ error: 'Failed to create post' })
  }
})

app.put('/api/posts/:id', async (req, res) => {
  try {
    const post = await postModel.updatePost(parseInt(req.params.id), req.body)
    res.json(post)
  } catch (error) {
    res.status(500).json({ error: `Failed to update post ${req.params.id}` })
  }
})

app.delete('/api/posts/:id', async (req, res) => {
  try {
    await postModel.deletePost(parseInt(req.params.id))
    res.status(204).end()
  } catch (error) {
    res.status(500).json({ error: `Failed to delete post ${req.params.id}` })
  }
})

const PORT = process.env.PORT || 3000
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
```

## Frontend Implementation

1. Create a simple HTML frontend `public/index.html`:
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Blog App</title>
  <style>
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
      margin-bottom: 1rem;
      padding: 1rem;
      border: 1px solid #eee;
      border-radius: 4px;
    }

    .list-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 1rem;
    }

    .list-actions button {
      margin-left: 0.5rem;
    }

    .meta {
      color: #666;
      font-size: 0.9rem;
      margin-top: 1rem;
    }
  </style>
</head>
<body>
  <div id="app">
    <h1>Blog App</h1>

    <section id="users">
      <h2>Users</h2>
      <div id="userError" class="error" style="display: none;"></div>

      <form id="userForm" class="form">
        <input type="email" name="email" placeholder="Email" required>
        <input type="text" name="name" placeholder="Name">
        <button type="submit">Add User</button>
      </form>

      <ul id="userList" class="list"></ul>
    </section>

    <section id="posts">
      <h2>Posts</h2>
      <div id="postError" class="error" style="display: none;"></div>

      <form id="postForm" class="form">
        <input type="text" name="title" placeholder="Title" required>
        <input type="text" name="content" placeholder="Content">
        <input type="number" name="authorId" placeholder="Author ID" required>
        <button type="submit">Add Post</button>
      </form>

      <ul id="postList" class="list"></ul>
    </section>
  </div>

  <script>
    const API_URL = 'http://localhost:3000/api'

    // Users
    async function loadUsers() {
      try {
        const response = await fetch(`${API_URL}/users`)
        const users = await response.json()
        const userList = document.getElementById('userList')
        userList.innerHTML = users.map(user => `
          <li class="list-item">
            <div class="list-header">
              <span>${user.name} (${user.email})</span>
              <div class="list-actions">
                <button onclick="deleteUser(${user.id})">Delete</button>
              </div>
            </div>
          </li>
        `).join('')
      } catch (error) {
        showError('userError', 'Failed to load users')
      }
    }

    async function createUser(event) {
      event.preventDefault()
      const form = event.target
      const data = {
        email: form.email.value,
        name: form.name.value
      }

      try {
        const response = await fetch(`${API_URL}/users`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(data)
        })

        if (!response.ok) throw new Error('Failed to create user')

        form.reset()
        loadUsers()
      } catch (error) {
        showError('userError', 'Failed to create user')
      }
    }

    async function deleteUser(id) {
      try {
        const response = await fetch(`${API_URL}/users/${id}`, {
          method: 'DELETE'
        })

        if (!response.ok) throw new Error('Failed to delete user')

        loadUsers()
      } catch (error) {
        showError('userError', `Failed to delete user ${id}`)
      }
    }

    // Posts
    async function loadPosts() {
      try {
        const response = await fetch(`${API_URL}/posts`)
        const posts = await response.json()
        const postList = document.getElementById('postList')
        postList.innerHTML = posts.map(post => `
          <li class="list-item">
            <div class="list-header">
              <h3>${post.title}</h3>
              <div class="list-actions">
                <button onclick="togglePublish(${post.id}, ${!post.published})">
                  ${post.published ? 'Unpublish' : 'Publish'}
                </button>
                <button onclick="deletePost(${post.id})">Delete</button>
              </div>
            </div>
            <p>${post.content}</p>
            <p class="meta">By: ${post.author.name}</p>
          </li>
        `).join('')
      } catch (error) {
        showError('postError', 'Failed to load posts')
      }
    }

    async function createPost(event) {
      event.preventDefault()
      const form = event.target
      const data = {
        title: form.title.value,
        content: form.content.value,
        authorId: parseInt(form.authorId.value)
      }

      try {
        const response = await fetch(`${API_URL}/posts`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(data)
        })

        if (!response.ok) throw new Error('Failed to create post')

        form.reset()
        loadPosts()
      } catch (error) {
        showError('postError', 'Failed to create post')
      }
    }

    async function togglePublish(id, published) {
      try {
        const response = await fetch(`${API_URL}/posts/${id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ published })
        })

        if (!response.ok) throw new Error('Failed to update post')

        loadPosts()
      } catch (error) {
        showError('postError', `Failed to update post ${id}`)
      }
    }

    async function deletePost(id) {
      try {
        const response = await fetch(`${API_URL}/posts/${id}`, {
          method: 'DELETE'
        })

        if (!response.ok) throw new Error('Failed to delete post')

        loadPosts()
      } catch (error) {
        showError('postError', `Failed to delete post ${id}`)
      }
    }

    function showError(elementId, message) {
      const element = document.getElementById(elementId)
      element.textContent = message
      element.style.display = 'block'
      setTimeout(() => {
        element.style.display = 'none'
      }, 3000)
    }

    // Event listeners
    document.getElementById('userForm').addEventListener('submit', createUser)
    document.getElementById('postForm').addEventListener('submit', createPost)

    // Initial load
    loadUsers()
    loadPosts()
  </script>
</body>
</html>
```

## Environment Setup

1. Create `.env` file:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/dbname?schema=public"
PORT=3000
```

2. Add `.env` to `.gitignore`:
```
.env
node_modules
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

3. Performance
   - Use proper indexes in schema
   - Implement pagination for large datasets
   - Cache frequently accessed data

4. API Design
   - Follow RESTful conventions
   - Implement proper validation
   - Use appropriate HTTP status codes

5. Security
   - Validate input data
   - Implement proper authentication
   - Use prepared statements (handled by Prisma)
   - Implement CORS properly

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

5. Start the development server:
```bash
node src/server.js
``` 