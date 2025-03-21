---
description: "Guidelines for integrating Neon serverless Postgres with Remix applications"
globs: "*.tsx,*.ts,app/**/*,server/**/*,remix.config.*"
---

# Neon + Remix Integration Setup Guide

This guide provides step-by-step instructions for integrating Neon serverless Postgres with a Remix application.

## Prerequisites
- Node.js and npm installed
- Remix project initialized
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

2. Create a database configuration file `app/lib/db.server.ts`:
```typescript
import { neon } from '@neondatabase/serverless';

const sql = neon(process.env.DATABASE_URL!);

export { sql };
```

## Usage Examples

### Basic Database Operations
```typescript
// app/routes/users.tsx
import { json, type LoaderFunctionArgs } from '@remix-run/node';
import { useLoaderData } from '@remix-run/react';
import { sql } from '~/lib/db.server';

interface User {
  id: number;
  name: string;
  email: string;
}

export async function loader({ request }: LoaderFunctionArgs) {
  try {
    const users = await sql<User[]>`
      SELECT id, name, email
      FROM users
      ORDER BY name ASC
    `;
    return json({ users });
  } catch (error: any) {
    throw new Error(`Failed to fetch users: ${error.message}`);
  }
}

export async function action({ request }: LoaderFunctionArgs) {
  const formData = await request.formData();
  const action = formData.get('action');

  try {
    switch (action) {
      case 'create': {
        const name = formData.get('name') as string;
        const email = formData.get('email') as string;

        const [user] = await sql<User[]>`
          INSERT INTO users (name, email)
          VALUES (${name}, ${email})
          RETURNING id, name, email
        `;
        return json({ user });
      }

      case 'update': {
        const id = parseInt(formData.get('id') as string);
        const name = formData.get('name') as string;
        const email = formData.get('email') as string;

        const [user] = await sql<User[]>`
          UPDATE users
          SET name = ${name}, email = ${email}
          WHERE id = ${id}
          RETURNING id, name, email
        `;
        return json({ user });
      }

      case 'delete': {
        const id = parseInt(formData.get('id') as string);
        await sql`DELETE FROM users WHERE id = ${id}`;
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

      <form method="post">
        <input type="hidden" name="action" value="create" />
        <input type="text" name="name" placeholder="Name" required />
        <input type="email" name="email" placeholder="Email" required />
        <button type="submit">Add User</button>
      </form>

      <ul>
        {users.map((user) => (
          <li key={user.id}>
            <form method="post" style={{ display: 'inline' }}>
              <input type="hidden" name="action" value="delete" />
              <input type="hidden" name="id" value={user.id} />
              <span>{user.name} ({user.email})</span>
              <button type="submit">Delete</button>
            </form>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### Database Utility Functions
```typescript
// app/lib/db.utils.server.ts
import { sql } from './db.server';

export async function withTransaction<T>(
  callback: (transaction: typeof sql) => Promise<T>
): Promise<T> {
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

export async function createPaginatedQuery<T>(
  baseQuery: string,
  page: number,
  pageSize: number,
  params: any[] = []
): Promise<{ data: T[]; total: number; pages: number }> {
  const offset = (page - 1) * pageSize;
  const countQuery = `SELECT COUNT(*) as total FROM (${baseQuery}) as subquery`;
  
  const [{ total }] = await sql.raw(countQuery, params);
  const data = await sql.raw<T[]>(
    `${baseQuery} LIMIT ${pageSize} OFFSET ${offset}`,
    params
  );

  return {
    data,
    total: parseInt(total),
    pages: Math.ceil(total / pageSize)
  };
}

export async function executeInBatch<T>(
  items: T[],
  batchSize: number,
  callback: (batch: T[]) => Promise<void>
): Promise<void> {
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
   - Keep database logic in server-only files (*.server.ts)
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
   - Define interfaces for database models
   - Use TypeScript's strict mode
   - Implement proper data validation

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
- [Remix Documentation](https://remix.run/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/) 