---
description: "Guidelines for integrating Neon serverless Postgres with Next.js applications"
globs: "*.tsx,*.ts,next.config.*,app/**/*,src/app/**/*"
---

# Neon + Next.js Integration Setup Guide

This guide provides step-by-step instructions for integrating Neon serverless Postgres with a Next.js 14 application.

## Prerequisites
- Node.js and npm installed
- Next.js 14 project initialized
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

2. Create a database configuration file `lib/db.ts`:
```typescript
import { neon } from '@neondatabase/serverless';

const sql = neon(process.env.NEON_DATABASE_URL!);

export { sql };
```

## Usage Examples

### Server Actions
```typescript
// app/actions/users.ts
'use server';

import { sql } from '@/lib/db';
import { revalidatePath } from 'next/cache';

interface User {
  id: number;
  name: string;
  email: string;
}

export async function getUsers() {
  try {
    const users = await sql<User[]>`
      SELECT id, name, email
      FROM users
      ORDER BY name ASC
    `;
    return { users };
  } catch (error: any) {
    return { error: `Failed to fetch users: ${error.message}` };
  }
}

export async function getUser(id: number) {
  try {
    const [user] = await sql<User[]>`
      SELECT id, name, email
      FROM users
      WHERE id = ${id}
    `;
    
    if (!user) {
      return { error: 'User not found' };
    }

    return { user };
  } catch (error: any) {
    return { error: `Failed to fetch user: ${error.message}` };
  }
}

export async function createUser(formData: FormData) {
  const name = formData.get('name') as string;
  const email = formData.get('email') as string;

  try {
    const [user] = await sql<User[]>`
      INSERT INTO users (name, email)
      VALUES (${name}, ${email})
      RETURNING id, name, email
    `;
    
    revalidatePath('/users');
    return { user };
  } catch (error: any) {
    return { error: `Failed to create user: ${error.message}` };
  }
}

export async function updateUser(id: number, formData: FormData) {
  const name = formData.get('name') as string;
  const email = formData.get('email') as string;

  try {
    const [user] = await sql<User[]>`
      UPDATE users
      SET name = ${name}, email = ${email}
      WHERE id = ${id}
      RETURNING id, name, email
    `;

    if (!user) {
      return { error: 'User not found' };
    }

    revalidatePath('/users');
    revalidatePath(`/users/${id}`);
    return { user };
  } catch (error: any) {
    return { error: `Failed to update user: ${error.message}` };
  }
}

export async function deleteUser(id: number) {
  try {
    await sql`DELETE FROM users WHERE id = ${id}`;
    revalidatePath('/users');
    return { success: true };
  } catch (error: any) {
    return { error: `Failed to delete user: ${error.message}` };
  }
}
```

### Page Components
```typescript
// app/users/page.tsx
import { getUsers, createUser, deleteUser } from '@/app/actions/users';

export default async function UsersPage() {
  const { users, error } = await getUsers();

  if (error) {
    return <div className="error">{error}</div>;
  }

  return (
    <div>
      <h1>Users</h1>

      <form action={createUser}>
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
      </form>

      {users?.length ? (
        <ul>
          {users.map((user) => (
            <li key={user.id}>
              {user.name} ({user.email})
              <form action={deleteUser.bind(null, user.id)}>
                <button type="submit">Delete</button>
              </form>
            </li>
          ))}
        </ul>
      ) : (
        <p>No users found.</p>
      )}
    </div>
  );
}

// app/users/[id]/page.tsx
import { getUser, updateUser } from '@/app/actions/users';
import { notFound } from 'next/navigation';

interface Props {
  params: { id: string };
}

export default async function UserPage({ params }: Props) {
  const id = parseInt(params.id);
  const { user, error } = await getUser(id);

  if (error) {
    if (error === 'User not found') {
      notFound();
    }
    return <div className="error">{error}</div>;
  }

  return (
    <div>
      <h1>Edit User</h1>

      <form action={updateUser.bind(null, id)}>
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
      </form>
    </div>
  );
}
```

### Client Components
```typescript
// app/components/UserForm.tsx
'use client';

import { useFormStatus } from 'react-dom';
import { createUser } from '@/app/actions/users';

export function UserForm() {
  const { pending } = useFormStatus();

  return (
    <form action={createUser}>
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
      <button type="submit" disabled={pending}>
        {pending ? 'Adding...' : 'Add User'}
      </button>
    </form>
  );
}

// app/components/DeleteButton.tsx
'use client';

import { useFormStatus } from 'react-dom';
import { deleteUser } from '@/app/actions/users';

interface Props {
  userId: number;
}

export function DeleteButton({ userId }: Props) {
  const { pending } = useFormStatus();

  return (
    <form action={deleteUser.bind(null, userId)}>
      <button type="submit" disabled={pending}>
        {pending ? 'Deleting...' : 'Delete'}
      </button>
    </form>
  );
}
```

### API Routes (Alternative Approach)
```typescript
// app/api/users/route.ts
import { sql } from '@/lib/db';
import { NextResponse } from 'next/server';

interface User {
  id: number;
  name: string;
  email: string;
}

export async function GET() {
  try {
    const users = await sql<User[]>`
      SELECT id, name, email
      FROM users
      ORDER BY name ASC
    `;
    return NextResponse.json(users);
  } catch (error: any) {
    return NextResponse.json(
      { error: `Failed to fetch users: ${error.message}` },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  try {
    const { name, email } = await request.json();
    
    const [user] = await sql<User[]>`
      INSERT INTO users (name, email)
      VALUES (${name}, ${email})
      RETURNING id, name, email
    `;
    
    return NextResponse.json(user, { status: 201 });
  } catch (error: any) {
    return NextResponse.json(
      { error: `Failed to create user: ${error.message}` },
      { status: 500 }
    );
  }
}

// app/api/users/[id]/route.ts
export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    const [user] = await sql<User[]>`
      SELECT id, name, email
      FROM users
      WHERE id = ${id}
    `;

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      );
    }

    return NextResponse.json(user);
  } catch (error: any) {
    return NextResponse.json(
      { error: `Failed to fetch user: ${error.message}` },
      { status: 500 }
    );
  }
}

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    const { name, email } = await request.json();

    const [user] = await sql<User[]>`
      UPDATE users
      SET name = ${name}, email = ${email}
      WHERE id = ${id}
      RETURNING id, name, email
    `;

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      );
    }

    return NextResponse.json(user);
  } catch (error: any) {
    return NextResponse.json(
      { error: `Failed to update user: ${error.message}` },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    await sql`DELETE FROM users WHERE id = ${id}`;
    return new NextResponse(null, { status: 204 });
  } catch (error: any) {
    return NextResponse.json(
      { error: `Failed to delete user: ${error.message}` },
      { status: 500 }
    );
  }
}
```

## Best Practices

1. **Environment Configuration**
   - Use environment variables for database credentials
   - Never commit sensitive credentials to version control
   - Use different database branches for development/production

2. **Database Access**
   - Keep database logic in server-side code
   - Use Server Actions for form submissions
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
   - Use type-safe Server Actions
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
- [Next.js Documentation](https://nextjs.org/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/) 