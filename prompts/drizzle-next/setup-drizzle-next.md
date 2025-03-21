---
description: "Guidelines for integrating Drizzle ORM with Next.js applications"
globs: "*.tsx,*.ts,next.config.*,app/**/*,src/app/**/*"
---

# Drizzle ORM with Next.js Integration Setup Guide

This guide provides step-by-step instructions for integrating Drizzle ORM with a Next.js application.

## Prerequisites
- Node.js and npm installed
- Next.js project initialized
- PostgreSQL database (or any other supported database)

## Installation

1. Install Drizzle ORM and database driver:
```bash
npm install drizzle-orm pg
npm install -D drizzle-kit @types/pg
```

2. For TypeScript support, ensure tsconfig.json includes:
```json
{
  "compilerOptions": {
    "target": "es2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ]
  }
}
```

## Database Configuration

1. Create a database configuration file `src/db/config.ts`:
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
 
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});
 
export const db = drizzle(pool);
```

2. Create schema definition `src/db/schema.ts`:
```typescript
import { pgTable, serial, text, timestamp } from 'drizzle-orm/pg-core';
 
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  email: text('email').notNull().unique(),
  createdAt: timestamp('created_at').defaultNow(),
});
```

3. Create migration configuration `drizzle.config.ts`:
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

4. Add migration scripts to package.json:
```json
{
  "scripts": {
    "db:generate": "drizzle-kit generate:pg",
    "db:push": "drizzle-kit push:pg",
    "db:studio": "drizzle-kit studio"
  }
}
```

## Server Actions Implementation

1. Create a server action file `src/app/actions/users.ts`:
```typescript
'use server'
 
import { db } from '@/db/config';
import { users } from '@/db/schema';
import { eq } from 'drizzle-orm';
 
export async function getUsers() {
  try {
    return await db.select().from(users);
  } catch (error) {
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
  } catch (error) {
    console.error(`Failed to fetch user ${id}:`, error);
    throw error;
  }
}
 
export async function createUser(data: { name: string; email: string }) {
  try {
    const [user] = await db
      .insert(users)
      .values(data)
      .returning();
    return user;
  } catch (error) {
    console.error('Failed to create user:', error);
    throw error;
  }
}
 
export async function updateUser(id: number, data: { name?: string; email?: string }) {
  try {
    const [user] = await db
      .update(users)
      .set(data)
      .where(eq(users.id, id))
      .returning();
    return user;
  } catch (error) {
    console.error(`Failed to update user ${id}:`, error);
    throw error;
  }
}
 
export async function deleteUser(id: number) {
  try {
    await db
      .delete(users)
      .where(eq(users.id, id));
  } catch (error) {
    console.error(`Failed to delete user ${id}:`, error);
    throw error;
  }
}
```

## Client Component Implementation

Create a client component `src/app/components/UserList.tsx`:
```typescript
'use client'
 
import { useEffect, useState } from 'react';
import { getUsers, createUser, updateUser, deleteUser } from '@/app/actions/users';
 
export default function UserList() {
  const [users, setUsers] = useState([]);
 
  useEffect(() => {
    const loadUsers = async () => {
      const data = await getUsers();
      setUsers(data);
    };
    loadUsers();
  }, []);
 
  const handleCreateUser = async (e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    await createUser({
      name: formData.get('name') as string,
      email: formData.get('email') as string,
    });
    const data = await getUsers();
    setUsers(data);
    e.target.reset();
  };
 
  return (
    <div>
      <form onSubmit={handleCreateUser}>
        <input name="name" placeholder="Name" required />
        <input name="email" type="email" placeholder="Email" required />
        <button type="submit">Add User</button>
      </form>
 
      <ul>
        {users.map((user) => (
          <li key={user.id}>
            {user.name} ({user.email})
            <button onClick={() => deleteUser(user.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## Environment Setup

1. Create `.env.local` file:
```env
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
```

2. Add `.env.local` to `.gitignore`:
```
.env.local
```

## Best Practices

1. Database Connection
   - Use connection pooling for better performance
   - Keep environment variables secure
   - Use migrations for schema changes

2. Server Actions
   - Implement proper error handling
   - Use TypeScript for type safety
   - Keep actions atomic and focused

3. Client Components
   - Implement proper loading states
   - Handle errors gracefully
   - Use optimistic updates when appropriate

4. Security
   - Validate input data
   - Implement proper authentication
   - Use prepared statements (handled by Drizzle)

5. Performance
   - Use indexes for frequently queried fields
   - Implement pagination for large datasets
   - Cache frequently accessed data

## Migrations

1. Generate migrations:
```bash
npm run db:generate
```

2. Apply migrations:
```bash
npm run db:push
```

3. View and manage database with Drizzle Studio:
```bash
npm run db:studio
``` 