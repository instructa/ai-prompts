---
description: "Guidelines for integrating Neon serverless Postgres with Angular applications"
globs: "*.component.ts,*.service.ts,*.module.ts,environment.ts,*.angular.json,angular.json"
---

# Neon + Angular Integration Setup Guide

This guide provides step-by-step instructions for integrating Neon serverless Postgres with an Angular application.

## Prerequisites
- Node.js and npm installed
- Angular project initialized
- Neon account and project created

## Installation

1. Install required dependencies:
```bash
npm install @neondatabase/serverless
```

## Configuration

1. Create environment files:

```typescript
// src/environments/environment.ts
export const environment = {
  production: false,
  databaseUrl: 'postgresql://<user>:<password>@<endpoint>.neon.tech/<dbname>?sslmode=require'
};

// src/environments/environment.prod.ts
export const environment = {
  production: true,
  databaseUrl: 'postgresql://<user>:<password>@<endpoint>.neon.tech/<dbname>?sslmode=require'
};
```

2. Create a database service `src/app/services/database.service.ts`:
```typescript
import { Injectable } from '@angular/core';
import { neon } from '@neondatabase/serverless';
import { environment } from '../../environments/environment';
import { Observable, from } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DatabaseService {
  private sql = neon(environment.databaseUrl);

  query<T>(queryString: string, params: any[] = []): Observable<T> {
    return from(this.sql.raw(queryString, params));
  }

  execute(queryString: string, params: any[] = []): Observable<any> {
    return from(this.sql.raw(queryString, params));
  }
}
```

## Usage Examples

### Basic Data Service
```typescript
// src/app/services/user.service.ts
import { Injectable } from '@angular/core';
import { DatabaseService } from './database.service';
import { Observable } from 'rxjs';

export interface User {
  id: number;
  name: string;
  email: string;
}

@Injectable({
  providedIn: 'root'
})
export class UserService {
  constructor(private db: DatabaseService) {}

  getUsers(): Observable<User[]> {
    return this.db.query<User[]>('SELECT * FROM users ORDER BY name ASC');
  }

  getUserById(id: number): Observable<User> {
    return this.db.query<User>(
      'SELECT * FROM users WHERE id = $1',
      [id]
    );
  }

  createUser(user: Omit<User, 'id'>): Observable<User> {
    return this.db.query<User>(
      'INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *',
      [user.name, user.email]
    );
  }

  updateUser(id: number, user: Partial<User>): Observable<User> {
    const updates = [];
    const values = [];
    let paramIndex = 1;

    if (user.name) {
      updates.push(`name = $${paramIndex}`);
      values.push(user.name);
      paramIndex++;
    }

    if (user.email) {
      updates.push(`email = $${paramIndex}`);
      values.push(user.email);
      paramIndex++;
    }

    values.push(id);
    return this.db.query<User>(
      `UPDATE users SET ${updates.join(', ')} WHERE id = $${paramIndex} RETURNING *`,
      values
    );
  }

  deleteUser(id: number): Observable<void> {
    return this.db.execute('DELETE FROM users WHERE id = $1', [id]);
  }
}
```

### Component Example
```typescript
// src/app/components/user-list/user-list.component.ts
import { Component, OnInit } from '@angular/core';
import { UserService, User } from '../../services/user.service';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-user-list',
  template: `
    <div class="user-list">
      <h2>Users</h2>
      
      <div *ngIf="loading">Loading...</div>
      <div *ngIf="error" class="error">{{ error }}</div>
      
      <ul *ngIf="users$ | async as users">
        <li *ngFor="let user of users">
          {{ user.name }} ({{ user.email }})
          <button (click)="deleteUser(user.id)">Delete</button>
        </li>
      </ul>

      <form (ngSubmit)="addUser()">
        <input [(ngModel)]="newUser.name" name="name" placeholder="Name" required>
        <input [(ngModel)]="newUser.email" name="email" placeholder="Email" required>
        <button type="submit">Add User</button>
      </form>
    </div>
  `
})
export class UserListComponent implements OnInit {
  users$: Observable<User[]>;
  loading = false;
  error: string | null = null;
  newUser = { name: '', email: '' };

  constructor(private userService: UserService) {
    this.users$ = this.userService.getUsers();
  }

  ngOnInit(): void {
    this.loadUsers();
  }

  loadUsers(): void {
    this.loading = true;
    this.error = null;
    this.users$ = this.userService.getUsers();
  }

  addUser(): void {
    this.loading = true;
    this.error = null;
    this.userService.createUser(this.newUser).subscribe({
      next: () => {
        this.newUser = { name: '', email: '' };
        this.loadUsers();
      },
      error: (err) => {
        this.error = err.message;
        this.loading = false;
      }
    });
  }

  deleteUser(id: number): void {
    this.loading = true;
    this.error = null;
    this.userService.deleteUser(id).subscribe({
      next: () => this.loadUsers(),
      error: (err) => {
        this.error = err.message;
        this.loading = false;
      }
    });
  }
}
```

## Best Practices

1. **Environment Configuration**
   - Use environment files for database configuration
   - Never commit sensitive credentials to version control
   - Use different database branches for development/production

2. **Database Access**
   - Create a centralized database service
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
- [Angular Documentation](https://angular.io/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/) 