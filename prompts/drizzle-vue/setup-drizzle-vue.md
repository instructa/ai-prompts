---
description: "Guidelines for integrating Drizzle ORM with Vue 3 applications"
globs: "*.vue,*.ts,vite.config.*,src/**/*,composables/**/*"
---

# Drizzle + Vue Integration Setup Guide

This guide provides step-by-step instructions for integrating Drizzle ORM with a Vue 3 application.

## Prerequisites
- Node.js and npm installed
- Vue 3 project initialized
- PostgreSQL database (or any other supported database)

## Installation

1. Install required dependencies:
```bash
npm install drizzle-orm pg
npm install -D drizzle-kit @types/pg
```

## Configuration

1. Create a `.env` file in your project root:
```env
DATABASE_URL=postgres://<user>:<password>@<host>:<port>/<dbname>
```

2. Create a database schema file `src/db/schema.ts`:
```typescript
import { pgTable, serial, text, varchar } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: varchar('name', { length: 255 }).notNull(),
  email: text('email').notNull().unique(),
});

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
```

3. Create a database configuration file `src/db/index.ts`:
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

const pool = new Pool({
  connectionString: import.meta.env.VITE_DATABASE_URL,
});

export const db = drizzle(pool, { schema });
```

4. Create a migration script `drizzle.config.ts`:
```typescript
import type { Config } from 'drizzle-kit';

export default {
  schema: './src/db/schema.ts',
  out: './drizzle',
  driver: 'pg',
  dbCredentials: {
    connectionString: process.env.DATABASE_URL!,
  },
} satisfies Config;
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

### Database Service
```typescript
// src/services/userService.ts
import { db } from '@/db';
import { users, type User, type NewUser } from '@/db/schema';
import { eq } from 'drizzle-orm';

export const userService = {
  async getUsers() {
    try {
      return await db.select().from(users).orderBy(users.name);
    } catch (error: any) {
      console.error('Failed to fetch users:', error);
      throw error;
    }
  },

  async getUserById(id: number) {
    try {
      const [user] = await db
        .select()
        .from(users)
        .where(eq(users.id, id));
      return user;
    } catch (error: any) {
      console.error(`Failed to fetch user ${id}:`, error);
      throw error;
    }
  },

  async createUser(user: NewUser) {
    try {
      const [newUser] = await db
        .insert(users)
        .values(user)
        .returning();
      return newUser;
    } catch (error: any) {
      console.error('Failed to create user:', error);
      throw error;
    }
  },

  async updateUser(id: number, user: Partial<NewUser>) {
    try {
      const [updatedUser] = await db
        .update(users)
        .set(user)
        .where(eq(users.id, id))
        .returning();
      return updatedUser;
    } catch (error: any) {
      console.error(`Failed to update user ${id}:`, error);
      throw error;
    }
  },

  async deleteUser(id: number) {
    try {
      await db.delete(users).where(eq(users.id, id));
    } catch (error: any) {
      console.error(`Failed to delete user ${id}:`, error);
      throw error;
    }
  },
};
```

### Composable
```typescript
// src/composables/useUsers.ts
import { ref } from 'vue';
import { userService } from '@/services/userService';
import type { User, NewUser } from '@/db/schema';

export function useUsers() {
  const users = ref<User[]>([]);
  const loading = ref(false);
  const error = ref<string | null>(null);

  const fetchUsers = async () => {
    loading.value = true;
    error.value = null;
    try {
      users.value = await userService.getUsers();
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
      return await userService.getUserById(id);
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const createUser = async (user: NewUser) => {
    loading.value = true;
    error.value = null;
    try {
      const newUser = await userService.createUser(user);
      users.value.push(newUser);
      return newUser;
    } catch (e: any) {
      error.value = e.message;
      throw e;
    } finally {
      loading.value = false;
    }
  };

  const updateUser = async (id: number, user: Partial<NewUser>) => {
    loading.value = true;
    error.value = null;
    try {
      const updatedUser = await userService.updateUser(id, user);
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
      await userService.deleteUser(id);
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

### Component Example
```vue
<!-- src/components/UserList.vue -->
<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useUsers } from '@/composables/useUsers';
import type { NewUser } from '@/db/schema';

const {
  users,
  loading,
  error,
  fetchUsers,
  createUser,
  updateUser,
  deleteUser
} = useUsers();

const newUser = ref<NewUser>({
  name: '',
  email: '',
});

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
    <h2>Users</h2>

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

1. **Schema Management**
   - Define schemas using Drizzle's type-safe builders
   - Use migrations for schema changes
   - Keep schema files organized and modular

2. **Database Access**
   - Create service layers for database operations
   - Use composables for state management
   - Implement proper error handling

3. **Query Safety**
   - Use Drizzle's query builders
   - Validate input data before queries
   - Implement proper error handling

4. **Performance**
   - Use connection pooling
   - Implement pagination for large datasets
   - Cache frequently accessed data

5. **Type Safety**
   - Use Drizzle's type inference
   - Define proper interfaces
   - Implement proper validation

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
- [Vue 3 Documentation](https://vuejs.org)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) 