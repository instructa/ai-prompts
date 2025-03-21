---
description: "Guidelines for integrating Drizzle ORM with JavaScript applications"
globs: "*.js,*.mjs,*.cjs"
---

# Drizzle + JavaScript Integration Setup Guide

This guide provides step-by-step instructions for integrating Drizzle ORM with a vanilla JavaScript application.

## Prerequisites
- Node.js and npm installed
- JavaScript project initialized
- PostgreSQL database (or any other supported database)

## Installation

1. Install required dependencies:
```bash
npm install drizzle-orm pg
npm install -D drizzle-kit
```

## Configuration

1. Create a `.env` file in your project root:
```env
DATABASE_URL=postgres://<user>:<password>@<host>:<port>/<dbname>
```

2. Create a database schema file `src/db/schema.js`:
```javascript
import { pgTable, serial, text, varchar } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: varchar('name', { length: 255 }).notNull(),
  email: text('email').notNull().unique(),
});
```

3. Create a database configuration file `src/db/index.js`:
```javascript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema.js';
import dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const db = drizzle(pool, { schema });
```

4. Create a migration script `drizzle.config.js`:
```javascript
export default {
  schema: './src/db/schema.js',
  out: './drizzle',
  driver: 'pg',
  dbCredentials: {
    connectionString: process.env.DATABASE_URL,
  },
};
```

5. Add migration scripts to `package.json`:
```json
{
  "scripts": {
    "generate": "drizzle-kit generate:pg",
    "migrate": "drizzle-kit push:pg"
  }
}
```

## Usage Examples

### Database Operations
```javascript
// src/services/userService.js
import { db } from '../db/index.js';
import { users } from '../db/schema.js';
import { eq } from 'drizzle-orm';

export const userService = {
  async getUsers() {
    try {
      return await db.select().from(users).orderBy(users.name);
    } catch (error) {
      console.error('Failed to fetch users:', error);
      throw error;
    }
  },

  async getUserById(id) {
    try {
      const [user] = await db
        .select()
        .from(users)
        .where(eq(users.id, id));
      return user;
    } catch (error) {
      console.error(`Failed to fetch user ${id}:`, error);
      throw error;
    }
  },

  async createUser(user) {
    try {
      const [newUser] = await db
        .insert(users)
        .values(user)
        .returning();
      return newUser;
    } catch (error) {
      console.error('Failed to create user:', error);
      throw error;
    }
  },

  async updateUser(id, user) {
    try {
      const [updatedUser] = await db
        .update(users)
        .set(user)
        .where(eq(users.id, id))
        .returning();
      return updatedUser;
    } catch (error) {
      console.error(`Failed to update user ${id}:`, error);
      throw error;
    }
  },

  async deleteUser(id) {
    try {
      await db.delete(users).where(eq(users.id, id));
    } catch (error) {
      console.error(`Failed to delete user ${id}:`, error);
      throw error;
    }
  },
};
```

### Express.js API Example
```javascript
// src/server.js
import express from 'express';
import { userService } from './services/userService.js';

const app = express();
app.use(express.json());

// Get all users
app.get('/users', async (req, res) => {
  try {
    const users = await userService.getUsers();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get user by ID
app.get('/users/:id', async (req, res) => {
  try {
    const user = await userService.getUserById(parseInt(req.params.id));
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create user
app.post('/users', async (req, res) => {
  try {
    const user = await userService.createUser(req.body);
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update user
app.put('/users/:id', async (req, res) => {
  try {
    const user = await userService.updateUser(parseInt(req.params.id), req.body);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete user
app.delete('/users/:id', async (req, res) => {
  try {
    await userService.deleteUser(parseInt(req.params.id));
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### Database Utility Functions
```javascript
// src/utils/dbUtils.js
import { db } from '../db/index.js';
import { sql } from 'drizzle-orm';

export async function withTransaction(callback) {
  try {
    await db.execute(sql`BEGIN`);
    const result = await callback(db);
    await db.execute(sql`COMMIT`);
    return result;
  } catch (error) {
    await db.execute(sql`ROLLBACK`);
    throw error;
  }
}

export async function createPaginatedQuery(
  baseQuery,
  page,
  pageSize,
  params = []
) {
  const offset = (page - 1) * pageSize;
  const countQuery = `SELECT COUNT(*) as total FROM (${baseQuery}) as subquery`;
  
  const [{ total }] = await db.execute(countQuery, params);
  const data = await db.execute(
    `${baseQuery} LIMIT ${pageSize} OFFSET ${offset}`,
    params
  );

  return {
    data,
    total: parseInt(total),
    pages: Math.ceil(total / pageSize)
  };
}

export async function executeInBatch(items, batchSize, callback) {
  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    await callback(batch);
  }
}
```

### Frontend Example
```javascript
// src/public/js/users.js
async function fetchUsers() {
  try {
    const response = await fetch('/users');
    if (!response.ok) throw new Error('Failed to fetch users');
    return await response.json();
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

async function createUser(userData) {
  try {
    const response = await fetch('/users', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(userData),
    });
    if (!response.ok) throw new Error('Failed to create user');
    return await response.json();
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

async function updateUser(id, userData) {
  try {
    const response = await fetch(`/users/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(userData),
    });
    if (!response.ok) throw new Error('Failed to update user');
    return await response.json();
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

async function deleteUser(id) {
  try {
    const response = await fetch(`/users/${id}`, {
      method: 'DELETE',
    });
    if (!response.ok) throw new Error('Failed to delete user');
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

// Example usage with DOM
document.addEventListener('DOMContentLoaded', async () => {
  const userList = document.getElementById('userList');
  const userForm = document.getElementById('userForm');

  async function renderUsers() {
    const users = await fetchUsers();
    userList.innerHTML = users
      .map(
        user => `
          <li>
            ${user.name} (${user.email})
            <button onclick="deleteUser(${user.id})">Delete</button>
          </li>
        `
      )
      .join('');
  }

  userForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const formData = new FormData(userForm);
    const userData = {
      name: formData.get('name'),
      email: formData.get('email'),
    };
    await createUser(userData);
    userForm.reset();
    await renderUsers();
  });

  await renderUsers();
});
```

## Best Practices

1. **Schema Management**
   - Define schemas using Drizzle's query builders
   - Use migrations for schema changes
   - Keep schema files organized and modular

2. **Database Access**
   - Create service layers for database operations
   - Implement proper error handling
   - Use connection pooling when possible

3. **Query Safety**
   - Use Drizzle's query builders
   - Validate input data before queries
   - Implement proper error handling

4. **Performance**
   - Use connection pooling
   - Implement pagination for large datasets
   - Cache frequently accessed data

5. **Error Handling**
   - Implement proper error handling
   - Log errors appropriately
   - Return meaningful error messages

## Security Considerations

1. **Database Access**
   - Use least privilege database users
   - Enable SSL for database connections
   - Regularly rotate database credentials

2. **Query Safety**
   - Use Drizzle's query builders to prevent SQL injection
   - Validate and sanitize all user inputs
   - Implement rate limiting

3. **Data Protection**
   - Encrypt sensitive data
   - Implement proper access controls
   - Regular security audits

## Troubleshooting

Common issues and solutions:

1. **Connection Issues**
   - Verify database URL format
   - Check network connectivity
   - Ensure SSL is properly configured

2. **Migration Issues**
   - Check schema syntax
   - Verify migration files
   - Run migrations in order

3. **Performance Problems**
   - Monitor query execution time
   - Check for missing indexes
   - Optimize large queries

## Additional Resources

- [Drizzle Documentation](https://orm.drizzle.team)
- [Node.js Documentation](https://nodejs.org/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) 