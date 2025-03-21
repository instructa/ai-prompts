---
description: "Guidelines for integrating Firebase backend services with Angular applications"
globs: "*.component.ts,*.service.ts,*.module.ts,environment.ts,*.angular.json,angular.json"
---

# Firebase + Angular Integration Setup Guide

This guide provides step-by-step instructions for integrating Firebase with an Angular application.

## Prerequisites
- Node.js and npm installed
- Angular CLI installed globally (`npm install -g @angular/cli`)
- A Firebase account (create one at [Firebase Console](https://console.firebase.google.com))

## Installation Steps

1. Create a new Angular project (skip if you have an existing project):
```bash
ng new my-firebase-project
cd my-firebase-project
```

2. Install Firebase and AngularFire dependencies:
```bash
npm install firebase @angular/fire
```

## Configuration

1. Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com)

2. Register your application in the Firebase Console and get your configuration

3. Create or update `src/environments/environment.ts`:
```typescript
export const environment = {
  production: false,
  firebase: {
    apiKey: 'your-api-key',
    authDomain: 'your-project.firebaseapp.com',
    projectId: 'your-project-id',
    storageBucket: 'your-project.appspot.com',
    messagingSenderId: 'your-messaging-sender-id',
    appId: 'your-app-id'
  }
};
```

4. Update `src/app/app.module.ts`:
```typescript
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppComponent } from './app.component';

// Firebase imports
import { AngularFireModule } from '@angular/fire/compat';
import { AngularFirestoreModule } from '@angular/fire/compat/firestore';
import { AngularFireAuthModule } from '@angular/fire/compat/auth';
import { AngularFireStorageModule } from '@angular/fire/compat/storage';
import { environment } from '../environments/environment';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    AngularFireModule.initializeApp(environment.firebase),
    AngularFirestoreModule,
    AngularFireAuthModule,
    AngularFireStorageModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

## Usage Examples

### Authentication
```typescript
import { Component } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import firebase from 'firebase/compat/app';

@Component({
  selector: 'app-auth',
  template: `
    <div *ngIf="auth.user | async as user; else showLogin">
      <h1>Hello {{ user.displayName }}!</h1>
      <button (click)="logout()">Logout</button>
    </div>
    <ng-template #showLogin>
      <button (click)="login()">Login with Google</button>
    </ng-template>
  `
})
export class AuthComponent {
  constructor(public auth: AngularFireAuth) {}

  login() {
    this.auth.signInWithPopup(new firebase.auth.GoogleAuthProvider());
  }

  logout() {
    this.auth.signOut();
  }
}
```

### Firestore Data Management
```typescript
import { Component } from '@angular/core';
import { AngularFirestore } from '@angular/fire/compat/firestore';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-data',
  template: `
    <ul>
      <li *ngFor="let item of items$ | async">
        {{ item.name }}
      </li>
    </ul>
  `
})
export class DataComponent {
  items$: Observable<any[]>;

  constructor(private firestore: AngularFirestore) {
    this.items$ = this.firestore.collection('items').valueChanges();
  }

  addItem(item: any) {
    this.firestore.collection('items').add(item);
  }

  updateItem(id: string, item: any) {
    this.firestore.doc(`items/${id}`).update(item);
  }

  deleteItem(id: string) {
    this.firestore.doc(`items/${id}`).delete();
  }
}
```

### File Storage
```typescript
import { Component } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/compat/storage';
import { finalize } from 'rxjs/operators';

@Component({
  selector: 'app-storage',
  template: `
    <input type="file" (change)="uploadFile($event)">
    <div *ngIf="downloadURL | async as url">
      <img [src]="url">
    </div>
  `
})
export class StorageComponent {
  downloadURL: Observable<string>;

  constructor(private storage: AngularFireStorage) {}

  uploadFile(event: any) {
    const file = event.target.files[0];
    const filePath = `uploads/${new Date().getTime()}_${file.name}`;
    const fileRef = this.storage.ref(filePath);
    const task = this.storage.upload(filePath, file);

    // Get notified when the download URL is available
    task.snapshotChanges().pipe(
      finalize(() => {
        this.downloadURL = fileRef.getDownloadURL();
      })
    ).subscribe();
  }
}
```

## Security Considerations

1. **Authentication Rules**: Always implement proper authentication and authorization rules in Firebase:
```typescript
// Example Firestore security rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

2. **Environment Variables**: Never commit Firebase configuration with real credentials to version control.

3. **Data Validation**: Implement proper data validation both on the client and server side.

## Best Practices

1. Use TypeScript interfaces for your data models
2. Implement proper error handling for Firebase operations
3. Use AngularFire's built-in observables for real-time updates
4. Follow Angular's dependency injection patterns
5. Implement proper loading states for async operations

## Troubleshooting

Common issues and solutions:

1. **Firebase initialization error**: Ensure your configuration in `environment.ts` is correct
2. **Authentication errors**: Check if the authentication method is enabled in Firebase Console
3. **Firestore permission denied**: Verify your security rules
4. **Storage upload issues**: Check storage rules and file size limits

## Additional Resources

- [Official AngularFire Documentation](https://github.com/angular/angularfire)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Angular Documentation](https://angular.io/docs) 