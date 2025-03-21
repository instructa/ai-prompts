---
description: "Guidelines for integrating Neon serverless Postgres with TanStack Query applications"
globs: "*.tsx,*.ts,**/hooks/**/*,**/queries/**/*"
---

# Neon + TanStack Integration Setup Guide

This guide provides step-by-step instructions for integrating Neon serverless Postgres with TanStack Query (formerly React Query).

## Prerequisites
- Node.js and npm installed
- React project initialized
- TanStack Query installed
- Neon account and project created

## Installation

1. Install required dependencies:
```bash
npm install @neondatabase/serverless @tanstack/react-query
```

## Configuration

1. Create a `.env` file in your project root:
```env
DATABASE_URL=postgresql://<user>:<password>@<endpoint>.neon.tech/<dbname>?sslmode=require
```

2. Create a database configuration file `src/lib/db.ts`:
```typescript
import { neon } from '@neondatabase/serverless';

const sql = neon(process.env.DATABASE_URL!);

export { sql };
```

3. Set up TanStack Query client:
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
import { sql } from '../lib/db';

interface User {
  id: number;
  name: string;
  email: string;
}

// Fetch all users
export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const users = await sql<User[]>`
        SELECT id, name, email
        FROM users
        ORDER BY name ASC
      `;
      return users;
    },
  });
}

// Fetch user by ID
export function useUser(id: number) {
  return useQuery({
    queryKey: ['users', id],
    queryFn: async () => {
      const [user] = await sql<User[]>`
        SELECT id, name, email
        FROM users
        WHERE id = ${id}
      `;
      return user;
    },
    enabled: !!id,
  });
}

// Create user mutation
export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ name, email }: Omit<User, 'id'>) => {
      const [user] = await sql<User[]>`
        INSERT INTO users (name, email)
        VALUES (${name}, ${email})
        RETURNING id, name, email
      `;
      return user;
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
      const [user] = await sql<User[]>`
        UPDATE users
        SET name = ${data.name}, email = ${data.email}
        WHERE id = ${id}
        RETURNING id, name, email
      `;
      return user;
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
      await sql`DELETE FROM users WHERE id = ${id}`;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

### React Component Example
```typescript
// src/components/UserList.tsx
import { useState } from 'react';
import { useUsers, useCreateUser, useUpdateUser, useDeleteUser } from '../hooks/useUsers';

export function UserList() {
  const [newUser, setNewUser] = useState({ name: '', email: '' });
  
  const { data: users, isLoading, error } = useUsers();
  const createUser = useCreateUser();
  const updateUser = useUpdateUser();
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
          placeholder="Email"
          type="email"
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
```

### Infinite Query Example
```typescript
// src/hooks/useInfiniteUsers.ts
import { useInfiniteQuery } from '@tanstack/react-query';
import { sql } from '../lib/db';

const PAGE_SIZE = 10;

interface User {
  id: number;
  name: string;
  email: string;
}

export function useInfiniteUsers() {
  return useInfiniteQuery({
    queryKey: ['users', 'infinite'],
    queryFn: async ({ pageParam = 0 }) => {
      const offset = pageParam * PAGE_SIZE;
      const users = await sql<User[]>`
        SELECT id, name, email
        FROM users
        ORDER BY name ASC
        LIMIT ${PAGE_SIZE}
        OFFSET ${offset}
      `;
      return users;
    },
    getNextPageParam: (lastPage, allPages) => {
      return lastPage.length === PAGE_SIZE ? allPages.length : undefined;
    },
  });
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
   - Define TypeScript interfaces for models
   - Use type-safe query and mutation hooks
   - Implement proper validation

## Security Considerations

1. **Database Access**
   - Use least privilege database users
   - Enable SSL for database connections
   - Regularly rotate database credentials

2. **Query Safety**
   - Use parameterized queries
   - Validate user inputs
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
- [TanStack Query Documentation](https://tanstack.com/query/latest)
- [TypeScript Documentation](https://www.typescriptlang.org/) 