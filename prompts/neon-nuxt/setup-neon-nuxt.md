---
description: "Guidelines for integrating Neon serverless Postgres with Nuxt applications"
globs: "*.vue,*.ts,nuxt.config.*,server/**/*,composables/**/*"
---

# Neon + Nuxt Integration Setup Guide

This guide provides step-by-step instructions for integrating Neon serverless Postgres with a Nuxt 3 application.

## Prerequisites
- Node.js and npm installed
- Nuxt 3 project initialized
- Neon account and project created

## Installation

1. Install required dependencies:
```bash
npm install @neondatabase/serverless
```

## Configuration

1. Create a `.env` file in your project root:
```env
NEON_DATABASE_URL=postgresql://<user>:<password>@<endpoint>.neon.tech/<dbname>?sslmode=require
```

2. Create a database configuration file `server/lib/db.ts`:
```typescript
import { neon } from '@neondatabase/serverless';

const sql = neon(process.env.NEON_DATABASE_URL!);

export { sql };
```

## Usage Examples

### Server API Routes
```typescript
// server/api/users/index.ts
import { sql } from '../../lib/db';

interface User {
  id: number;
  name: string;
  email: string;
}

export default defineEventHandler(async (event) => {
  try {
    const users = await sql<User[]>`
      SELECT id, name, email
      FROM users
      ORDER BY name ASC
    `;
    return users;
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      message: `Failed to fetch users: ${error.message}`,
    });
  }
});

// server/api/users/[id].ts
export default defineEventHandler(async (event) => {
  const id = parseInt(event.context.params.id);

  try {
    const [user] = await sql<User[]>`
      SELECT id, name, email
      FROM users
      WHERE id = ${id}
    `;

    if (!user) {
      throw createError({
        statusCode: 404,
        message: 'User not found',
      });
    }

    return user;
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      message: `Failed to fetch user: ${error.message}`,
    });
  }
});

// server/api/users/create.post.ts
export default defineEventHandler(async (event) => {
  const { name, email } = await readBody(event);

  try {
    const [user] = await sql<User[]>`
      INSERT INTO users (name, email)
      VALUES (${name}, ${email})
      RETURNING id, name, email
    `;
    return user;
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      message: `Failed to create user: ${error.message}`,
    });
  }
});

// server/api/users/[id].put.ts
export default defineEventHandler(async (event) => {
  const id = parseInt(event.context.params.id);
  const { name, email } = await readBody(event);

  try {
    const [user] = await sql<User[]>`
      UPDATE users
      SET name = ${name}, email = ${email}
      WHERE id = ${id}
      RETURNING id, name, email
    `;

    if (!user) {
      throw createError({
        statusCode: 404,
        message: 'User not found',
      });
    }

    return user;
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      message: `Failed to update user: ${error.message}`,
    });
  }
});

// server/api/users/[id].delete.ts
export default defineEventHandler(async (event) => {
  const id = parseInt(event.context.params.id);

  try {
    await sql`DELETE FROM users WHERE id = ${id}`;
    return { success: true };
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      message: `Failed to delete user: ${error.message}`,
    });
  }
});
```

### Composables
```typescript
// composables/useUsers.ts
interface User {
  id: number;
  name: string;
  email: string;
}

export function useUsers() {
  const users = ref<User[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);

  const fetchUsers = async () => {
    loading.value = true;
    error.value = null;
    try {
      users.value = await $fetch('/api/users');
    } catch (e: any) {
      error.value = e.message;
    } finally {
      loading.value = false;
    }
  };

  const getUser = async (id: number) => {
    loading.value = true;
    error.value = null;
    try {
      return await $fetch(`/api/users/${id}`);
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const createUser = async (user: Omit<User, 'id'>) => {
    loading.value = true;
    error.value = null;
    try {
      const newUser = await $fetch('/api/users/create', {
        method: 'POST',
        body: user,
      });
      users.value.push(newUser);
      return newUser;
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const updateUser = async (id: number, user: Partial<User>) => {
    loading.value = true;
    error.value = null;
    try {
      const updatedUser = await $fetch(`/api/users/${id}`, {
        method: 'PUT',
        body: user,
      });
      const index = users.value.findIndex(u => u.id === id);
      if (index !== -1) {
        users.value[index] = updatedUser;
      }
      return updatedUser;
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const deleteUser = async (id: number) => {
    loading.value = true;
    error.value = null;
    try {
      await $fetch(`/api/users/${id}`, { method: 'DELETE' });
      users.value = users.value.filter(u => u.id !== id);
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  return {
    users,
    loading,
    error,
    fetchUsers,
    getUser,
    createUser,
    updateUser,
    deleteUser,
  };
}
```

### Page Component Example
```vue
<!-- pages/users.vue -->
<script setup lang="ts">
const {
  users,
  loading,
  error,
  fetchUsers,
  createUser,
  deleteUser
} = useUsers();

const newUser = ref({ name: '', email: '' });

onMounted(() => {
  fetchUsers();
});

const handleSubmit = async () => {
  try {
    await createUser(newUser.value);
    newUser.value = { name: '', email: '' };
  } catch (error) {
    console.error('Failed to create user:', error);
  }
};
</script>

<template>
  <div>
    <h1>Users</h1>

    <div v-if="loading">Loading...</div>
    <div v-else-if="error" class="error">{{ error }}</div>

    <form @submit.prevent="handleSubmit">
      <input
        v-model="newUser.name"
        placeholder="Name"
        required
      />
      <input
        v-model="newUser.email"
        type="email"
        placeholder="Email"
        required
      />
      <button type="submit">Add User</button>
    </form>

    <ul v-if="users.length">
      <li v-for="user in users" :key="user.id">
        {{ user.name }} ({{ user.email }})
        <button @click="deleteUser(user.id)">Delete</button>
      </li>
    </ul>
    <p v-else>No users found.</p>
  </div>
</template>
```

## Best Practices

1. **Environment Configuration**
   - Use environment variables for database credentials
   - Never commit sensitive credentials to version control
   - Use different database branches for development/production

2. **Database Access**
   - Keep database logic in server-side code
   - Use typed queries with interfaces
   - Implement proper error handling

3. **Query Safety**
   - Use parameterized queries to prevent SQL injection
   - Validate input data before queries
   - Implement proper error handling

4. **Performance**
   - Use connection pooling when possible
   - Implement pagination for large datasets
   - Cache frequently accessed data

5. **Type Safety**
   - Define TypeScript interfaces for models
   - Use type-safe composables
   - Implement proper validation

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
- [Nuxt 3 Documentation](https://nuxt.com/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/) 