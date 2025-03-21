---
description: "Guidelines for integrating Drizzle ORM with Astro applications"
globs: "*.astro,*.ts,astro.config.*,env.d.ts"
---

# Drizzle + Astro Integration Setup Guide

This guide provides step-by-step instructions for integrating Drizzle ORM with an Astro application.

## Prerequisites
- Node.js and npm installed
- Astro project initialized with SSR enabled
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
  connectionString: import.meta.env.DATABASE_URL,
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

### Basic Database Operations
```astro
---
// src/pages/users.astro
import { db } from '../db';
import { users, type User } from '../db/schema';
import { eq } from 'drizzle-orm';

let userList: User[] = [];
let error: string | null = null;

try {
  userList = await db.select().from(users).orderBy(users.name);
} catch (e: any) {
  error = e.message;
}
---

<div>
  <h1>Users</h1>
  
  {error && <div class="error">{error}</div>}
  
  <ul>
    {userList.map((user) => (
      <li>
        {user.name} ({user.email})
        <form method="POST" action="/api/users/delete">
          <input type="hidden" name="id" value={user.id} />
          <button type="submit">Delete</button>
        </form>
      </li>
    ))}
  </ul>

  <form method="POST" action="/api/users/create">
    <input type="text" name="name" placeholder="Name" required />
    <input type="email" name="email" placeholder="Email" required />
    <button type="submit">Add User</button>
  </form>
</div>
```

### API Routes
```typescript
// src/pages/api/users/create.ts
import type { APIRoute } from 'astro';
import { db } from '../../../db';
import { users } from '../../../db/schema';

export const POST: APIRoute = async ({ request }) => {
  try {
    const formData = await request.formData();
    const name = formData.get('name') as string;
    const email = formData.get('email') as string;

    const [user] = await db
      .insert(users)
      .values({ name, email })
      .returning();

    return new Response(JSON.stringify(user), {
      status: 201,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
};

// src/pages/api/users/[id].ts
import type { APIRoute } from 'astro';
import { db } from '../../../db';
import { users } from '../../../db/schema';
import { eq } from 'drizzle-orm';

export const GET: APIRoute = async ({ params }) => {
  try {
    const id = parseInt(params.id!);
    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, id));

    if (!user) {
      return new Response(JSON.stringify({ error: 'User not found' }), {
        status: 404,
        headers: {
          'Content-Type': 'application/json'
        }
      });
    }

    return new Response(JSON.stringify(user), {
      status: 200,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
};

export const PUT: APIRoute = async ({ request, params }) => {
  try {
    const id = parseInt(params.id!);
    const formData = await request.formData();
    const name = formData.get('name') as string;
    const email = formData.get('email') as string;

    const [user] = await db
      .update(users)
      .set({ name, email })
      .where(eq(users.id, id))
      .returning();

    if (!user) {
      return new Response(JSON.stringify({ error: 'User not found' }), {
        status: 404,
        headers: {
          'Content-Type': 'application/json'
        }
      });
    }

    return new Response(JSON.stringify(user), {
      status: 200,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
};

export const DELETE: APIRoute = async ({ params }) => {
  try {
    const id = parseInt(params.id!);
    await db.delete(users).where(eq(users.id, id));
    return new Response(null, { status: 204 });
  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
};
```

### Database Utility Functions
```typescript
// src/lib/db.utils.ts
import { db } from '../db';

export async function withTransaction<T>(
  callback: (transaction: typeof db) => Promise<T>
): Promise<T> {
  try {
    await db.execute(sql`BEGIN`);
    const result = await callback(db);
    await db.execute(sql`COMMIT`);
    return result;
  } catch (error) {
    await db.execute(sql`ROLLBACK`);
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
  
  const [{ total }] = await db.execute(countQuery, params);
  const data = await db.execute<T[]>(
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
- [Astro Documentation](https://docs.astro.build)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) 