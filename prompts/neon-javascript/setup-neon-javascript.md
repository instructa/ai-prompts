---
description: "Guidelines for integrating Neon serverless Postgres with JavaScript applications"
globs: "*.js,*.mjs,*.cjs"
---

# Neon + JavaScript Integration Setup Guide

This guide provides step-by-step instructions for integrating Neon serverless Postgres with a JavaScript application.

## Prerequisites
- Node.js and npm installed
- JavaScript project initialized
- Neon account and project created

## Installation

1. Install required dependencies:
```bash
npm install @neondatabase/serverless
```

## Configuration

1. Create a `.env` file in your project root:
```env
DATABASE_URL=postgresql://<user>:<password>@<endpoint>.neon.tech/<dbname>?sslmode=require
```

2. Create a database configuration file `src/db.js`:
```javascript
import { neon } from '@neondatabase/serverless';
import dotenv from 'dotenv';

dotenv.config();

const sql = neon(process.env.DATABASE_URL);

export { sql };
```

## Usage Examples

### Basic Database Operations
```javascript
// src/users.js
import { sql } from './db.js';

export async function getUsers() {
  try {
    const users = await sql`
      SELECT id, name, email
      FROM users
      ORDER BY name ASC
    `;
    return users;
  } catch (error) {
    console.error('Failed to fetch users:', error);
    throw error;
  }
}

export async function getUserById(id) {
  try {
    const [user] = await sql`
      SELECT id, name, email
      FROM users
      WHERE id = ${id}
    `;
    return user;
  } catch (error) {
    console.error(`Failed to fetch user ${id}:`, error);
    throw error;
  }
}

export async function createUser({ name, email }) {
  try {
    const [user] = await sql`
      INSERT INTO users (name, email)
      VALUES (${name}, ${email})
      RETURNING id, name, email
    `;
    return user;
  } catch (error) {
    console.error('Failed to create user:', error);
    throw error;
  }
}

export async function updateUser(id, { name, email }) {
  try {
    const [user] = await sql`
      UPDATE users
      SET name = ${name}, email = ${email}
      WHERE id = ${id}
      RETURNING id, name, email
    `;
    return user;
  } catch (error) {
    console.error(`Failed to update user ${id}:`, error);
    throw error;
  }
}

export async function deleteUser(id) {
  try {
    await sql`
      DELETE FROM users
      WHERE id = ${id}
    `;
  } catch (error) {
    console.error(`Failed to delete user ${id}:`, error);
    throw error;
  }
}
```

### Express.js API Example
```javascript
// src/server.js
import express from 'express';
import {
  getUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser
} from './users.js';

const app = express();
app.use(express.json());

// Get all users
app.get('/users', async (req, res) => {
  try {
    const users = await getUsers();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get user by ID
app.get('/users/:id', async (req, res) => {
  try {
    const user = await getUserById(parseInt(req.params.id));
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
    const user = await createUser(req.body);
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update user
app.put('/users/:id', async (req, res) => {
  try {
    const user = await updateUser(parseInt(req.params.id), req.body);
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
    await deleteUser(parseInt(req.params.id));
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
// src/db.utils.js
import { sql } from './db.js';

export async function withTransaction(callback) {
  try {
    await sql`BEGIN`;
    const result = await callback(sql);
    await sql`COMMIT`;
    return result;
  } catch (error) {
    await sql`ROLLBACK`;
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
  
  const [{ total }] = await sql.raw(countQuery, params);
  const data = await sql.raw(
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

## Best Practices

1. **Environment Configuration**
   - Use environment variables for database credentials
   - Never commit sensitive credentials to version control
   - Use different database branches for development/production

2. **Database Access**
   - Create modular database functions
   - Implement proper error handling
   - Use connection pooling when possible

3. **Query Safety**
   - Use parameterized queries to prevent SQL injection
   - Validate input data before queries
   - Implement proper error handling

4. **Performance**
   - Use connection pooling when possible
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
   - Always use parameterized queries
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

2. **Query Errors**
   - Check SQL syntax
   - Verify table and column names
   - Validate data types

3. **Performance Problems**
   - Monitor query execution time
   - Check for missing indexes
   - Optimize large queries

## Additional Resources

- [Neon Documentation](https://neon.tech/docs)
- [Node.js Documentation](https://nodejs.org/docs)
- [Express.js Documentation](https://expressjs.com/) 