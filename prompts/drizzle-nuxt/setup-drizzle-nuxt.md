---
description: "Guidelines for integrating Drizzle ORM with Nuxt applications"
globs: "*.vue,*.ts,nuxt.config.*,server/**/*,composables/**/*"
---

# Drizzle + Nuxt Integration Setup Guide

This guide provides step-by-step instructions for integrating Drizzle ORM with a Nuxt 3 application.

## Prerequisites
- Node.js and npm installed
- Nuxt 3 project initialized
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

2. Create a database schema file `server/db/schema.ts`:
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

3. Create a database configuration file `server/db/index.ts`:
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const db = drizzle(pool, { schema });
```

4. Create a migration script `drizzle.config.ts`:
```typescript
import type { Config } from 'drizzle-kit';

export default {
  schema: './server/db/schema.ts',
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

### Server Routes
```typescript
// server/api/users/index.ts
import { db } from '../../db';
import { users } from '../../db/schema';
import { eq } from 'drizzle-orm';

export default defineEventHandler(async (event) => {
  const method = getMethod(event);

  try {
    switch (method) {
      case 'GET':
        return await db.select().from(users).orderBy(users.name);

      case 'POST': {
        const body = await readBody(event);
        const [user] = await db
          .insert(users)
          .values(body)
          .returning();
        return user;
      }

      default:
        throw createError({
          statusCode: 405,
          message: 'Method not allowed',
        });
    }
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      message: error.message,
    });
  }
});

// server/api/users/[id].ts
export default defineEventHandler(async (event) => {
  const method = getMethod(event);
  const id = parseInt(event.context.params.id);

  try {
    switch (method) {
      case 'GET': {
        const [user] = await db
          .select()
          .from(users)
          .where(eq(users.id, id));

        if (!user) {
          throw createError({
            statusCode: 404,
            message: 'User not found',
          });
        }

        return user;
      }

      case 'PUT': {
        const body = await readBody(event);
        const [user] = await db
          .update(users)
          .set(body)
          .where(eq(users.id, id))
          .returning();

        if (!user) {
          throw createError({
            statusCode: 404,
            message: 'User not found',
          });
        }

        return user;
      }

      case 'DELETE': {
        await db.delete(users).where(eq(users.id, id));
        return { success: true };
      }

      default:
        throw createError({
          statusCode: 405,
          message: 'Method not allowed',
        });
    }
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      message: error.message,
    });
  }
});
```

### Composables
```typescript
// composables/useUsers.ts
import type { User, NewUser } from '~/server/db/schema';

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

  const createUser = async (user: NewUser) => {
    loading.value = true;
    error.value = null;
    try {
      const newUser = await $fetch('/api/users', {
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

  const updateUser = async (id: number, user: Partial<NewUser>) => {
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

### Page Components
```vue
<!-- pages/users/index.vue -->
<script setup lang="ts">
import type { NewUser } from '~/server/db/schema';

const {
  users,
  loading,
  error,
  fetchUsers,
  createUser,
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

<!-- pages/users/[id].vue -->
<script setup lang="ts">
const route = useRoute();
const router = useRouter();

const id = parseInt(route.params.id as string);
const { getUser, updateUser } = useUsers();

const user = ref(await getUser(id));

const handleSubmit = async (e: Event) => {
  const form = e.target as HTMLFormElement;
  const formData = new FormData(form);

  try {
    await updateUser(id, {
      name: formData.get('name') as string,
      email: formData.get('email') as string,
    });
    router.push('/users');
  } catch (error) {
    console.error('Failed to update user:', error);
  }
};
</script>

<template>
  <div>
    <h1>Edit User</h1>

    <form @submit.prevent="handleSubmit">
      <input
        name="name"
        :value="user.name"
        placeholder="Name"
        required
      />
      <input
        name="email"
        type="email"
        :value="user.email"
        placeholder="Email"
        required
      />
      <button type="submit">Update User</button>
    </form>
  </div>
</template>
```

## Best Practices

1. **Schema Management**
   - Define schemas using Drizzle's type-safe builders
   - Use migrations for schema changes
   - Keep schema files organized and modular

2. **Database Access**
   - Keep database logic in server-side code
   - Use typed queries with interfaces
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
- [Nuxt 3 Documentation](https://nuxt.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) 