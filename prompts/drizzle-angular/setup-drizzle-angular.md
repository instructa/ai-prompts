---
description: "Guidelines for integrating Drizzle ORM with Angular applications"
globs: "*.component.ts,*.service.ts,*.module.ts,environment.ts,*.angular.json,angular.json"
---

# Drizzle + Angular Integration Setup Guide

This guide provides step-by-step instructions for integrating Drizzle ORM with an Angular application.

## Prerequisites
- Node.js and npm installed
- Angular project initialized
- PostgreSQL database (or any other supported database)

## Installation

1. Install required dependencies:
```bash
npm install drizzle-orm pg
npm install -D drizzle-kit @types/pg
```

## Configuration

1. Create environment files:
```typescript
// src/environments/environment.ts
export const environment = {
  production: false,
  databaseUrl: 'postgres://<user>:<password>@<host>:<port>/<dbname>',
};

// src/environments/environment.prod.ts
export const environment = {
  production: true,
  databaseUrl: 'postgres://<user>:<password>@<host>:<port>/<dbname>',
};
```

2. Create a database schema file `src/app/db/schema.ts`:
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

3. Create a database configuration file `src/app/db/index.ts`:
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';
import { environment } from '../../environments/environment';

const pool = new Pool({
  connectionString: environment.databaseUrl,
});

export const db = drizzle(pool, { schema });
```

4. Create a migration script `drizzle.config.ts`:
```typescript
import type { Config } from 'drizzle-kit';

export default {
  schema: './src/app/db/schema.ts',
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
// src/app/services/user.service.ts
import { Injectable } from '@angular/core';
import { db } from '../db';
import { users, type User, type NewUser } from '../db/schema';
import { eq } from 'drizzle-orm';
import { Observable, from } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  getUsers(): Observable<User[]> {
    return from(
      db.select().from(users).orderBy(users.name)
    );
  }

  getUserById(id: number): Observable<User | undefined> {
    return from(
      db.select()
        .from(users)
        .where(eq(users.id, id))
        .then(([user]) => user)
    );
  }

  createUser(user: NewUser): Observable<User> {
    return from(
      db.insert(users)
        .values(user)
        .returning()
        .then(([newUser]) => newUser)
    );
  }

  updateUser(id: number, user: Partial<NewUser>): Observable<User> {
    return from(
      db.update(users)
        .set(user)
        .where(eq(users.id, id))
        .returning()
        .then(([updatedUser]) => updatedUser)
    );
  }

  deleteUser(id: number): Observable<void> {
    return from(
      db.delete(users)
        .where(eq(users.id, id))
        .then(() => void 0)
    );
  }
}
```

### Component Examples
```typescript
// src/app/components/user-list/user-list.component.ts
import { Component, OnInit } from '@angular/core';
import { UserService } from '../../services/user.service';
import { type User, type NewUser } from '../../db/schema';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-user-list',
  template: `
    <div>
      <h2>Users</h2>

      <form [formGroup]="userForm" (ngSubmit)="onSubmit()">
        <input
          formControlName="name"
          placeholder="Name"
          required
        />
        <input
          formControlName="email"
          type="email"
          placeholder="Email"
          required
        />
        <button type="submit" [disabled]="userForm.invalid || loading">
          Add User
        </button>
      </form>

      <div *ngIf="loading">Loading...</div>
      <div *ngIf="error" class="error">{{ error }}</div>

      <ul *ngIf="users.length; else noUsers">
        <li *ngFor="let user of users">
          {{ user.name }} ({{ user.email }})
          <button (click)="deleteUser(user.id)" [disabled]="loading">
            Delete
          </button>
        </li>
      </ul>

      <ng-template #noUsers>
        <p>No users found.</p>
      </ng-template>
    </div>
  `,
})
export class UserListComponent implements OnInit {
  users: User[] = [];
  loading = false;
  error: string | null = null;
  userForm: FormGroup;

  constructor(
    private userService: UserService,
    private fb: FormBuilder
  ) {
    this.userForm = this.fb.group({
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
    });
  }

  ngOnInit(): void {
    this.loadUsers();
  }

  loadUsers(): void {
    this.loading = true;
    this.error = null;

    this.userService.getUsers().subscribe({
      next: (users) => {
        this.users = users;
        this.loading = false;
      },
      error: (err) => {
        this.error = err.message;
        this.loading = false;
      },
    });
  }

  onSubmit(): void {
    if (this.userForm.valid) {
      this.loading = true;
      this.error = null;

      this.userService.createUser(this.userForm.value).subscribe({
        next: (user) => {
          this.users.push(user);
          this.userForm.reset();
          this.loading = false;
        },
        error: (err) => {
          this.error = err.message;
          this.loading = false;
        },
      });
    }
  }

  deleteUser(id: number): void {
    this.loading = true;
    this.error = null;

    this.userService.deleteUser(id).subscribe({
      next: () => {
        this.users = this.users.filter(u => u.id !== id);
        this.loading = false;
      },
      error: (err) => {
        this.error = err.message;
        this.loading = false;
      },
    });
  }
}

// src/app/components/user-detail/user-detail.component.ts
@Component({
  selector: 'app-user-detail',
  template: `
    <div *ngIf="user">
      <h2>Edit User</h2>

      <form [formGroup]="userForm" (ngSubmit)="onSubmit()">
        <input
          formControlName="name"
          placeholder="Name"
          required
        />
        <input
          formControlName="email"
          type="email"
          placeholder="Email"
          required
        />
        <button type="submit" [disabled]="userForm.invalid || loading">
          Update User
        </button>
      </form>

      <div *ngIf="loading">Loading...</div>
      <div *ngIf="error" class="error">{{ error }}</div>
    </div>
  `,
})
export class UserDetailComponent implements OnInit {
  @Input() id!: number;
  user: User | null = null;
  loading = false;
  error: string | null = null;
  userForm: FormGroup;

  constructor(
    private userService: UserService,
    private fb: FormBuilder
  ) {
    this.userForm = this.fb.group({
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
    });
  }

  ngOnInit(): void {
    this.loadUser();
  }

  loadUser(): void {
    this.loading = true;
    this.error = null;

    this.userService.getUserById(this.id).subscribe({
      next: (user) => {
        if (user) {
          this.user = user;
          this.userForm.patchValue(user);
        }
        this.loading = false;
      },
      error: (err) => {
        this.error = err.message;
        this.loading = false;
      },
    });
  }

  onSubmit(): void {
    if (this.userForm.valid) {
      this.loading = true;
      this.error = null;

      this.userService.updateUser(this.id, this.userForm.value).subscribe({
        next: (user) => {
          this.user = user;
          this.loading = false;
        },
        error: (err) => {
          this.error = err.message;
          this.loading = false;
        },
      });
    }
  }
}
```

## Best Practices

1. **Schema Management**
   - Define schemas using Drizzle's type-safe builders
   - Use migrations for schema changes
   - Keep schema files organized and modular

2. **Database Access**
   - Create injectable services for database operations
   - Use RxJS observables for async operations
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
- [Angular Documentation](https://angular.io/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/) 