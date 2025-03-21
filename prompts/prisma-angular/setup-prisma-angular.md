---
description: "Guidelines for integrating Prisma ORM with Angular applications"
globs: "*.component.ts,*.service.ts,*.module.ts,environment.ts,*.angular.json,angular.json"
---

# Prisma with Angular Integration Setup Guide

This guide provides step-by-step instructions for integrating Prisma ORM with an Angular application.

## Prerequisites
- Node.js and npm installed
- Angular project initialized
- PostgreSQL database (or any other supported database)

## Installation

1. Install Prisma and its dependencies:
```bash
npm install @prisma/client
npm install -D prisma
```

2. Initialize Prisma in your project:
```bash
npx prisma init
```

## Database Schema

1. Define your schema in `prisma/schema.prisma`:
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String?
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Post {
  id        Int      @id @default(autoincrement())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  Int
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

## Service Implementation

1. Create a Prisma service `src/app/services/prisma.service.ts`:
```typescript
import { Injectable, OnModuleDestroy, OnModuleInit } from '@angular/core';
import { PrismaClient } from '@prisma/client';

@Injectable({
  providedIn: 'root'
})
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor() {
    super();
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
```

2. Create a users service `src/app/services/users.service.ts`:
```typescript
import { Injectable } from '@angular/core';
import { PrismaService } from './prisma.service';
import { User, Prisma } from '@prisma/client';
import { Observable, from } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class UsersService {
  constructor(private prisma: PrismaService) {}

  getUsers(): Observable<User[]> {
    return from(
      this.prisma.user.findMany({
        include: {
          posts: true
        }
      })
    ).pipe(
      catchError((error) => {
        console.error('Failed to fetch users:', error);
        throw error;
      })
    );
  }

  getUserById(id: number): Observable<User | null> {
    return from(
      this.prisma.user.findUnique({
        where: { id },
        include: {
          posts: true
        }
      })
    ).pipe(
      catchError((error) => {
        console.error(`Failed to fetch user ${id}:`, error);
        throw error;
      })
    );
  }

  createUser(data: Prisma.UserCreateInput): Observable<User> {
    return from(
      this.prisma.user.create({
        data,
        include: {
          posts: true
        }
      })
    ).pipe(
      catchError((error) => {
        console.error('Failed to create user:', error);
        throw error;
      })
    );
  }

  updateUser(id: number, data: Prisma.UserUpdateInput): Observable<User> {
    return from(
      this.prisma.user.update({
        where: { id },
        data,
        include: {
          posts: true
        }
      })
    ).pipe(
      catchError((error) => {
        console.error(`Failed to update user ${id}:`, error);
        throw error;
      })
    );
  }

  deleteUser(id: number): Observable<User> {
    return from(
      this.prisma.user.delete({
        where: { id }
      })
    ).pipe(
      catchError((error) => {
        console.error(`Failed to delete user ${id}:`, error);
        throw error;
      })
    );
  }
}
```

3. Create a posts service `src/app/services/posts.service.ts`:
```typescript
import { Injectable } from '@angular/core';
import { PrismaService } from './prisma.service';
import { Post, Prisma } from '@prisma/client';
import { Observable, from } from 'rxjs';
import { catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class PostsService {
  constructor(private prisma: PrismaService) {}

  getPosts(): Observable<Post[]> {
    return from(
      this.prisma.post.findMany({
        include: {
          author: true
        }
      })
    ).pipe(
      catchError((error) => {
        console.error('Failed to fetch posts:', error);
        throw error;
      })
    );
  }

  getPostById(id: number): Observable<Post | null> {
    return from(
      this.prisma.post.findUnique({
        where: { id },
        include: {
          author: true
        }
      })
    ).pipe(
      catchError((error) => {
        console.error(`Failed to fetch post ${id}:`, error);
        throw error;
      })
    );
  }

  createPost(data: Prisma.PostCreateInput): Observable<Post> {
    return from(
      this.prisma.post.create({
        data,
        include: {
          author: true
        }
      })
    ).pipe(
      catchError((error) => {
        console.error('Failed to create post:', error);
        throw error;
      })
    );
  }

  updatePost(id: number, data: Prisma.PostUpdateInput): Observable<Post> {
    return from(
      this.prisma.post.update({
        where: { id },
        data,
        include: {
          author: true
        }
      })
    ).pipe(
      catchError((error) => {
        console.error(`Failed to update post ${id}:`, error);
        throw error;
      })
    );
  }

  deletePost(id: number): Observable<Post> {
    return from(
      this.prisma.post.delete({
        where: { id }
      })
    ).pipe(
      catchError((error) => {
        console.error(`Failed to delete post ${id}:`, error);
        throw error;
      })
    );
  }
}
```

## Component Implementation

1. Create a users component `src/app/components/users/users.component.ts`:
```typescript
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UsersService } from '../../services/users.service';
import { User } from '@prisma/client';

@Component({
  selector: 'app-users',
  template: `
    <div>
      <h2>Users</h2>
      
      <div *ngIf="error" class="error">
        {{ error }}
      </div>

      <form [formGroup]="userForm" (ngSubmit)="createUser()">
        <input formControlName="email" type="email" placeholder="Email" required>
        <input formControlName="name" placeholder="Name">
        <button type="submit" [disabled]="!userForm.valid">Add User</button>
      </form>

      <ul>
        <li *ngFor="let user of users">
          {{ user.name }} ({{ user.email }})
          <button (click)="deleteUser(user.id)">Delete</button>
        </li>
      </ul>
    </div>
  `,
  styles: [`
    .error {
      color: red;
      margin-bottom: 1rem;
    }

    form {
      margin-bottom: 1rem;
    }

    input {
      margin-right: 0.5rem;
    }

    ul {
      list-style: none;
      padding: 0;
    }

    li {
      margin-bottom: 0.5rem;
    }

    button {
      margin-left: 0.5rem;
    }
  `]
})
export class UsersComponent implements OnInit {
  users: User[] = [];
  error = '';
  userForm: FormGroup;

  constructor(
    private usersService: UsersService,
    private fb: FormBuilder
  ) {
    this.userForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      name: ['']
    });
  }

  ngOnInit() {
    this.loadUsers();
  }

  loadUsers() {
    this.usersService.getUsers().subscribe({
      next: (users) => this.users = users,
      error: (error) => this.error = 'Failed to load users'
    });
  }

  createUser() {
    if (this.userForm.valid) {
      this.usersService.createUser(this.userForm.value).subscribe({
        next: (user) => {
          this.users.push(user);
          this.userForm.reset();
        },
        error: (error) => this.error = 'Failed to create user'
      });
    }
  }

  deleteUser(id: number) {
    this.usersService.deleteUser(id).subscribe({
      next: () => {
        this.users = this.users.filter(user => user.id !== id);
      },
      error: (error) => this.error = `Failed to delete user ${id}`
    });
  }
}
```

2. Create a posts component `src/app/components/posts/posts.component.ts`:
```typescript
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PostsService } from '../../services/posts.service';
import { Post } from '@prisma/client';

@Component({
  selector: 'app-posts',
  template: `
    <div>
      <h2>Posts</h2>
      
      <div *ngIf="error" class="error">
        {{ error }}
      </div>

      <form [formGroup]="postForm" (ngSubmit)="createPost()">
        <input formControlName="title" placeholder="Title" required>
        <input formControlName="content" placeholder="Content">
        <input formControlName="authorId" type="number" placeholder="Author ID" required>
        <button type="submit" [disabled]="!postForm.valid">Add Post</button>
      </form>

      <ul>
        <li *ngFor="let post of posts">
          <h3>{{ post.title }}</h3>
          <p>{{ post.content }}</p>
          <p>By: {{ post.author?.name }}</p>
          <button (click)="togglePublish(post)">
            {{ post.published ? 'Unpublish' : 'Publish' }}
          </button>
          <button (click)="deletePost(post.id)">Delete</button>
        </li>
      </ul>
    </div>
  `,
  styles: [`
    .error {
      color: red;
      margin-bottom: 1rem;
    }

    form {
      margin-bottom: 1rem;
    }

    input {
      margin-right: 0.5rem;
    }

    ul {
      list-style: none;
      padding: 0;
    }

    li {
      margin-bottom: 1rem;
      padding: 1rem;
      border: 1px solid #ddd;
      border-radius: 4px;
    }

    h3 {
      margin: 0 0 0.5rem 0;
    }

    p {
      margin: 0.5rem 0;
    }

    button {
      margin-right: 0.5rem;
    }
  `]
})
export class PostsComponent implements OnInit {
  posts: Post[] = [];
  error = '';
  postForm: FormGroup;

  constructor(
    private postsService: PostsService,
    private fb: FormBuilder
  ) {
    this.postForm = this.fb.group({
      title: ['', Validators.required],
      content: [''],
      authorId: ['', Validators.required]
    });
  }

  ngOnInit() {
    this.loadPosts();
  }

  loadPosts() {
    this.postsService.getPosts().subscribe({
      next: (posts) => this.posts = posts,
      error: (error) => this.error = 'Failed to load posts'
    });
  }

  createPost() {
    if (this.postForm.valid) {
      this.postsService.createPost({
        ...this.postForm.value,
        authorId: parseInt(this.postForm.value.authorId)
      }).subscribe({
        next: (post) => {
          this.posts.push(post);
          this.postForm.reset();
        },
        error: (error) => this.error = 'Failed to create post'
      });
    }
  }

  togglePublish(post: Post) {
    this.postsService.updatePost(post.id, {
      published: !post.published
    }).subscribe({
      next: (updatedPost) => {
        const index = this.posts.findIndex(p => p.id === post.id);
        if (index !== -1) {
          this.posts[index] = updatedPost;
        }
      },
      error: (error) => this.error = `Failed to update post ${post.id}`
    });
  }

  deletePost(id: number) {
    this.postsService.deletePost(id).subscribe({
      next: () => {
        this.posts = this.posts.filter(post => post.id !== id);
      },
      error: (error) => this.error = `Failed to delete post ${id}`
    });
  }
}
```

## Module Setup

1. Update `src/app/app.module.ts`:
```typescript
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { ReactiveFormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { UsersComponent } from './components/users/users.component';
import { PostsComponent } from './components/posts/posts.component';
import { PrismaService } from './services/prisma.service';
import { UsersService } from './services/users.service';
import { PostsService } from './services/posts.service';

@NgModule({
  declarations: [
    AppComponent,
    UsersComponent,
    PostsComponent
  ],
  imports: [
    BrowserModule,
    ReactiveFormsModule
  ],
  providers: [
    PrismaService,
    UsersService,
    PostsService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

## Environment Setup

1. Create `.env` file:
```env
DATABASE_URL="postgresql://user:password@localhost:5432/dbname?schema=public"
```

2. Add `.env` to `.gitignore`:
```
.env
```

## Database Migration

1. Generate Prisma Client:
```bash
npx prisma generate
```

2. Create and apply migrations:
```bash
npx prisma migrate dev --name init
```

## Best Practices

1. Database Connection
   - Use connection pooling in production
   - Keep environment variables secure
   - Use migrations for schema changes

2. Error Handling
   - Implement proper error handling in services
   - Show user-friendly error messages
   - Log errors for debugging

3. Type Safety
   - Use TypeScript for better type safety
   - Leverage Prisma's generated types
   - Define proper interfaces for data structures

4. Performance
   - Use proper indexes in schema
   - Implement pagination for large datasets
   - Cache frequently accessed data

5. Angular Best Practices
   - Use reactive forms for form handling
   - Implement proper unsubscribe patterns
   - Follow Angular style guide

6. Security
   - Validate input data
   - Implement proper authentication
   - Use prepared statements (handled by Prisma)

## Development Workflow

1. Make schema changes in `schema.prisma`
2. Generate migration:
```bash
npx prisma migrate dev --name <migration-name>
```

3. Update Prisma Client:
```bash
npx prisma generate
```

4. Use Prisma Studio for database management:
```bash
npx prisma studio
``` 