---
description: "Guidelines for integrating Neon serverless Postgres with Vue applications"
globs: "*.vue,*.ts,vite.config.*,src/**/*,composables/**/*"
---

# Neon + Vue Integration Setup Guide

This guide provides step-by-step instructions for integrating Neon serverless Postgres with a Vue 3 application.

## Prerequisites
- Node.js and npm installed
- Vue 3 project initialized
- Neon account and project created

## Installation

1. Install required dependencies:
```bash
npm install @neondatabase/serverless
```

## Configuration

1. Create a `.env` file in your project root:
```env
VITE_DATABASE_URL=postgresql://<user>:<password>@<endpoint>.neon.tech/<dbname>?sslmode=require
```

2. Create a database configuration file `src/lib/db.ts`:
```typescript
import { neon } from '@neondatabase/serverless';

const sql = neon(import.meta.env.VITE_DATABASE_URL);

export { sql };
```

## Usage Examples

### Basic Database Operations Component
```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { sql } from '@/lib/db';

interface User {
  id: number;
  name: string;
  email: string;
}

const users = ref<User[]>([]);
const loading = ref(false);
const error = ref<string | null>(null);

const fetchUsers = async () => {
  loading.value = true;
  error.value = null;
  try {
    users.value = await sql<User[]>`
      SELECT id, name, email
      FROM users
      ORDER BY name ASC
    `;
  } catch (e: any) {
    error.value = e.message;
  } finally {
    loading.value = false;
  }
};

const addUser = async (name: string, email: string) => {
  loading.value = true;
  error.value = null;
  try {
    const [newUser] = await sql<User[]>`
      INSERT INTO users (name, email)
      VALUES (${name}, ${email})
      RETURNING id, name, email
    `;
    users.value.push(newUser);
  } catch (e: any) {
    error.value = e.message;
  } finally {
    loading.value = false;
  }
};

const updateUser = async (id: number, name: string, email: string) => {
  loading.value = true;
  error.value = null;
  try {
    const [updatedUser] = await sql<User[]>`
      UPDATE users
      SET name = ${name}, email = ${email}
      WHERE id = ${id}
      RETURNING id, name, email
    `;
    const index = users.value.findIndex(u => u.id === id);
    if (index !== -1) {
      users.value[index] = updatedUser;
    }
  } catch (e: any) {
    error.value = e.message;
  } finally {
    loading.value = false;
  }
};

const deleteUser = async (id: number) => {
  loading.value = true;
  error.value = null;
  try {
    await sql`
      DELETE FROM users
      WHERE id = ${id}
    `;
    users.value = users.value.filter(u => u.id !== id);
  } catch (e: any) {
    error.value = e.message;
  } finally {
    loading.value = false;
  }
};

onMounted(fetchUsers);
</script>

<template>
  <div>
    <h2>Users</h2>
    
    <div v-if="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    
    <ul v-else>
      <li v-for="user in users" :key="user.id">
        {{ user.name }} ({{ user.email }})
        <button @click="deleteUser(user.id)">Delete</button>
      </li>
    </ul>
  </div>
</template>
```

### Composable for Database Operations
```typescript
// composables/useDatabase.ts
import { ref } from 'vue';
import { sql } from '@/lib/db';

export function useDatabase<T>() {
  const data = ref<T[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);

  const execute = async (query: string, params: any[] = []) => {
    loading.value = true;
    error.value = null;
    try {
      const result = await sql.raw(query, params);
      return result;
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const fetchAll = async (table: string, orderBy?: string) => {
    loading.value = true;
    error.value = null;
    try {
      data.value = await sql<T[]>`
        SELECT *
        FROM ${sql(table)}
        ${orderBy ? sql`ORDER BY ${sql(orderBy)}` : sql``}
      `;
    } catch (e: any) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  };

  const fetchById = async (table: string, id: number) => {
    loading.value = true;
    error.value = null;
    try {
      const [result] = await sql<T[]>`
        SELECT *
        FROM ${sql(table)}
        WHERE id = ${id}
      `;
      return result;
    } catch (e: any) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  };

  const insert = async (table: string, data: Partial<T>) => {
    loading.value = true;
    error.value = null;
    try {
      const columns = Object.keys(data);
      const values = Object.values(data);
      const [result] = await sql<T[]>`
        INSERT INTO ${sql(table)} (${sql(columns.join(', '))})
        VALUES (${sql(...values)})
        RETURNING *
      `;
      return result;
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const update = async (table: string, id: number, data: Partial<T>) => {
    loading.value = true;
    error.value = null;
    try {
      const setClause = Object.entries(data)
        .map(([key, value]) => `${key} = ${sql`${value}`}`)
        .join(', ');
      
      const [result] = await sql<T[]>`
        UPDATE ${sql(table)}
        SET ${sql(setClause)}
        WHERE id = ${id}
        RETURNING *
      `;
      return result;
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const remove = async (table: string, id: number) => {
    loading.value = true;
    error.value = null;
    try {
      await sql`
        DELETE FROM ${sql(table)}
        WHERE id = ${id}
      `;
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  return {
    data,
    loading,
    error,
    execute,
    fetchAll,
    fetchById,
    insert,
    update,
    remove
  };
}
```

## Best Practices

1. **Environment Variables**
   - Always use environment variables for database credentials
   - Never commit `.env` file to version control
   - Provide a `.env.example` file with placeholder values

2. **SQL Injection Prevention**
   - Always use parameterized queries with the `sql` template tag
   - Never concatenate user input directly into SQL strings
   - Use the `sql` helper for dynamic table/column names

3. **Error Handling**
   - Implement proper error handling for all database operations
   - Display user-friendly error messages
   - Log detailed errors for debugging

4. **Performance**
   - Use connection pooling for better performance
   - Implement pagination for large datasets
   - Use appropriate indexes on your tables

5. **Type Safety**
   - Define TypeScript interfaces for your database models
   - Use type parameters with the database composable
   - Validate data before sending to the database

## Security Considerations

1. **Database Access**
   - Use least privilege database users
   - Enable SSL for database connections
   - Regularly rotate database credentials

2. **Query Safety**
   - Validate and sanitize all user inputs
   - Use prepared statements for dynamic queries
   - Implement rate limiting for database operations

3. **Data Protection**
   - Encrypt sensitive data before storing
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
- [Vue 3 Documentation](https://vuejs.org/)
- [TypeScript Documentation](https://www.typescriptlang.org/) 