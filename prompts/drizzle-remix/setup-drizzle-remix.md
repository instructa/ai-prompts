---
description: "Guidelines for integrating Drizzle ORM with Remix applications"
globs: "*.tsx,*.ts,app/**/*,server/**/*,remix.config.*"
---

# Drizzle + Remix Integration Setup Guide

This guide provides step-by-step instructions for integrating Drizzle ORM with a Remix application.

## Prerequisites
- Node.js and npm installed
- Remix project initialized
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

2. Create a database schema file `app/db/schema.ts`:
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

3. Create a database configuration file `app/db/index.server.ts`:
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
  schema: './app/db/schema.ts',
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

### Database Operations
```typescript
// app/models/user.server.ts
import { db } from '~/db/index.server';
import { users, type User, type NewUser } from '~/db/schema';
import { eq } from 'drizzle-orm';

export async function getUsers() {
  try {
    return await db.select().from(users).orderBy(users.name);
  } catch (error: any) {
    console.error('Failed to fetch users:', error);
    throw error;
  }
}

export async function getUserById(id: number) {
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
}

export async function createUser(user: NewUser) {
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
}

export async function updateUser(id: number, user: Partial<NewUser>) {
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
}

export async function deleteUser(id: number) {
  try {
    await db.delete(users).where(eq(users.id, id));
  } catch (error: any) {
    console.error(`Failed to delete user ${id}:`, error);
    throw error;
  }
}
```

### Route Examples
```typescript
// app/routes/users._index.tsx
import { json, type LoaderFunctionArgs, type ActionFunctionArgs } from '@remix-run/node';
import { useLoaderData, Form } from '@remix-run/react';
import { getUsers, createUser, deleteUser } from '~/models/user.server';
import type { User } from '~/db/schema';

export async function loader() {
  try {
    const users = await getUsers();
    return json({ users });
  } catch (error: any) {
    throw new Error(`Failed to fetch users: ${error.message}`);
  }
}

export async function action({ request }: ActionFunctionArgs) {
  const formData = await request.formData();
  const action = formData.get('action');

  try {
    switch (action) {
      case 'create': {
        const name = formData.get('name') as string;
        const email = formData.get('email') as string;
        const user = await createUser({ name, email });
        return json({ user });
      }

      case 'delete': {
        const id = parseInt(formData.get('id') as string);
        await deleteUser(id);
        return json({ success: true });
      }

      default:
        throw new Error('Invalid action');
    }
  } catch (error: any) {
    throw new Error(`Failed to perform action: ${error.message}`);
  }
}

export default function Users() {
  const { users } = useLoaderData<typeof loader>();

  return (
    <div>
      <h1>Users</h1>

      <Form method="post">
        <input type="hidden" name="action" value="create" />
        <input
          name="name"
          placeholder="Name"
          required
        />
        <input
          name="email"
          type="email"
          placeholder="Email"
          required
        />
        <button type="submit">Add User</button>
      </Form>

      {users.length ? (
        <ul>
          {users.map((user) => (
            <li key={user.id}>
              {user.name} ({user.email})
              <Form method="post" style={{ display: 'inline' }}>
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="id" value={user.id} />
                <button type="submit">Delete</button>
              </Form>
            </li>
          ))}
        </ul>
      ) : (
        <p>No users found.</p>
      )}
    </div>
  );
}

// app/routes/users.$id.tsx
import { json, type LoaderFunctionArgs, type ActionFunctionArgs } from '@remix-run/node';
import { useLoaderData, Form } from '@remix-run/react';
import { getUserById, updateUser } from '~/models/user.server';

export async function loader({ params }: LoaderFunctionArgs) {
  const id = parseInt(params.id!);

  try {
    const user = await getUserById(id);
    if (!user) {
      throw new Response('Not Found', { status: 404 });
    }
    return json({ user });
  } catch (error: any) {
    throw new Error(`Failed to fetch user: ${error.message}`);
  }
}

export async function action({ params, request }: ActionFunctionArgs) {
  const id = parseInt(params.id!);
  const formData = await request.formData();
  const name = formData.get('name') as string;
  const email = formData.get('email') as string;

  try {
    const user = await updateUser(id, { name, email });
    return json({ user });
  } catch (error: any) {
    throw new Error(`Failed to update user: ${error.message}`);
  }
}

export default function EditUser() {
  const { user } = useLoaderData<typeof loader>();

  return (
    <div>
      <h1>Edit User</h1>

      <Form method="post">
        <input
          name="name"
          defaultValue={user.name}
          placeholder="Name"
          required
        />
        <input
          name="email"
          type="email"
          defaultValue={user.email}
          placeholder="Email"
          required
        />
        <button type="submit">Update User</button>
      </Form>
    </div>
  );
}
```

## Best Practices

1. **Schema Management**
   - Define schemas using Drizzle's type-safe builders
   - Use migrations for schema changes
   - Keep schema files organized and modular

2. **Database Access**
   - Keep database logic in server-only files (*.server.ts)
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
- [Remix Documentation](https://remix.run/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) 