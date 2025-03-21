---
description: "Guidelines for integrating Drizzle ORM with TanStack Query applications"
globs: "*.tsx,*.ts,**/hooks/**/*,**/queries/**/*"
---

# Drizzle + TanStack Integration Setup Guide

This guide provides step-by-step instructions for integrating Drizzle ORM with TanStack Query (formerly React Query).

## Prerequisites
- Node.js and npm installed
- React project initialized
- PostgreSQL database (or any other supported database)

## Installation

1. Install required dependencies:
```bash
npm install drizzle-orm pg @tanstack/react-query
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
  connectionString: process.env.DATABASE_URL,
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

6. Set up TanStack Query client:
```typescript
// src/lib/query-client.ts
import { QueryClient } from '@tanstack/react-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      retry: 1,
    },
  },
});
```

## Usage Examples

### Database Operations with TanStack Query
```typescript
// src/hooks/useUsers.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { db } from '../db';
import { users, type User, type NewUser } from '../db/schema';
import { eq } from 'drizzle-orm';

// Fetch all users
export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const users = await db.select().from(users).orderBy(users.name);
      return users;
    },
  });
}

// Fetch user by ID
export function useUser(id: number) {
  return useQuery({
    queryKey: ['users', id],
    queryFn: async () => {
      const [user] = await db
        .select()
        .from(users)
        .where(eq(users.id, id));
      return user;
    },
    enabled: !!id,
  });
}

// Create user mutation
export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (user: NewUser) => {
      const [newUser] = await db
        .insert(users)
        .values(user)
        .returning();
      return newUser;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}

// Update user mutation
export function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ id, ...data }: User) => {
      const [updatedUser] = await db
        .update(users)
        .set(data)
        .where(eq(users.id, id))
        .returning();
      return updatedUser;
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
      queryClient.invalidateQueries({ queryKey: ['users', data.id] });
    },
  });
}

// Delete user mutation
export function useDeleteUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (id: number) => {
      await db.delete(users).where(eq(users.id, id));
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

### React Component Examples
```typescript
// src/components/UserList.tsx
import { useState } from 'react';
import { useUsers, useCreateUser, useDeleteUser } from '../hooks/useUsers';
import type { NewUser } from '../db/schema';

export function UserList() {
  const [newUser, setNewUser] = useState<NewUser>({
    name: '',
    email: '',
  });

  const { data: users, isLoading, error } = useUsers();
  const createUser = useCreateUser();
  const deleteUser = useDeleteUser();

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    createUser.mutate(newUser, {
      onSuccess: () => setNewUser({ name: '', email: '' }),
    });
  };

  return (
    <div>
      <h2>Users</h2>

      <form onSubmit={handleSubmit}>
        <input
          value={newUser.name}
          onChange={(e) => setNewUser(prev => ({ ...prev, name: e.target.value }))}
          placeholder="Name"
          required
        />
        <input
          value={newUser.email}
          onChange={(e) => setNewUser(prev => ({ ...prev, email: e.target.value }))}
          type="email"
          placeholder="Email"
          required
        />
        <button type="submit" disabled={createUser.isPending}>
          Add User
        </button>
      </form>

      <ul>
        {users?.map((user) => (
          <li key={user.id}>
            {user.name} ({user.email})
            <button
              onClick={() => deleteUser.mutate(user.id)}
              disabled={deleteUser.isPending}
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

// src/components/UserDetail.tsx
import { useUser, useUpdateUser } from '../hooks/useUsers';
import type { User } from '../db/schema';

interface Props {
  id: number;
}

export function UserDetail({ id }: Props) {
  const { data: user, isLoading, error } = useUser(id);
  const updateUser = useUpdateUser();

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  if (!user) return <div>User not found</div>;

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    const updatedUser: User = {
      id: user.id,
      name: formData.get('name') as string,
      email: formData.get('email') as string,
    };
    updateUser.mutate(updatedUser);
  };

  return (
    <div>
      <h2>Edit User</h2>

      <form onSubmit={handleSubmit}>
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
        <button type="submit" disabled={updateUser.isPending}>
          Update User
        </button>
      </form>
    </div>
  );
}
```

### Infinite Query Example
```typescript
// src/hooks/useInfiniteUsers.ts
import { useInfiniteQuery } from '@tanstack/react-query';
import { db } from '../db';
import { users, type User } from '../db/schema';

const PAGE_SIZE = 10;

export function useInfiniteUsers() {
  return useInfiniteQuery({
    queryKey: ['users', 'infinite'],
    queryFn: async ({ pageParam = 0 }) => {
      const offset = pageParam * PAGE_SIZE;
      const users = await db
        .select()
        .from(users)
        .orderBy(users.name)
        .limit(PAGE_SIZE)
        .offset(offset);
      return users;
    },
    getNextPageParam: (lastPage, allPages) => {
      return lastPage.length === PAGE_SIZE ? allPages.length : undefined;
    },
  });
}

// src/components/InfiniteUserList.tsx
import { useInfiniteUsers } from '../hooks/useInfiniteUsers';

export function InfiniteUserList() {
  const {
    data,
    isLoading,
    error,
    hasNextPage,
    fetchNextPage,
    isFetchingNextPage,
  } = useInfiniteUsers();

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div>
      <h2>Users</h2>

      <ul>
        {data.pages.map((page, i) => (
          <React.Fragment key={i}>
            {page.map((user) => (
              <li key={user.id}>
                {user.name} ({user.email})
              </li>
            ))}
          </React.Fragment>
        ))}
      </ul>

      {hasNextPage && (
        <button
          onClick={() => fetchNextPage()}
          disabled={isFetchingNextPage}
        >
          {isFetchingNextPage ? 'Loading more...' : 'Load More'}
        </button>
      )}
    </div>
  );
}
```

## Best Practices

1. **Query Keys**
   - Use consistent query key structure
   - Include relevant parameters in query keys
   - Keep query keys as simple as possible

2. **Caching Strategy**
   - Set appropriate stale times
   - Configure retry behavior
   - Use optimistic updates when appropriate

3. **Error Handling**
   - Implement proper error boundaries
   - Display user-friendly error messages
   - Log errors for debugging

4. **Performance**
   - Use infinite queries for large datasets
   - Implement proper pagination
   - Configure proper cache invalidation

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

2. **Query Issues**
   - Check query key structure
   - Verify cache invalidation
   - Monitor query state

3. **Performance Problems**
   - Monitor query execution time
   - Check for missing indexes
   - Optimize large queries

## Additional Resources

- [Drizzle Documentation](https://orm.drizzle.team)
- [TanStack Query Documentation](https://tanstack.com/query/latest)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) 