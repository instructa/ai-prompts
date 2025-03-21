---
description: "Best practices for building APIs with FastAPI and SQLAlchemy ORM"
globs: "*.py,models.py,schemas.py,crud.py,database.py,main.py"
---

# FastAPI + SQLAlchemy Stack Best Practices

The FastAPI + SQLAlchemy stack combines FastAPI's modern, high-performance web framework capabilities with SQLAlchemy's powerful ORM system to build robust, type-safe APIs with efficient database access.

## Project Structure

### Directory Organization
- Organize project with a clear, modular structure
- Separate concerns with dedicated modules
- Maintain consistent naming conventions
- Use subdirectories for larger feature groups

```
project_name/
├── alembic/               # Database migrations
│   ├── versions/
│   └── env.py
├── app/
│   ├── __init__.py
│   ├── main.py            # FastAPI application definition
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py      # Application configuration
│   │   ├── security.py    # Security utilities
│   │   └── database.py    # Database connection handling
│   ├── api/
│   │   ├── __init__.py
│   │   ├── deps.py        # Dependency injection
│   │   └── routes/
│   │       ├── __init__.py
│   │       ├── users.py   # User routes
│   │       └── items.py   # Item routes
│   ├── models/
│   │   ├── __init__.py
│   │   ├── user.py        # User SQLAlchemy models
│   │   └── item.py        # Item SQLAlchemy models
│   ├── schemas/
│   │   ├── __init__.py
│   │   ├── user.py        # User Pydantic schemas
│   │   └── item.py        # Item Pydantic schemas
│   ├── crud/
│   │   ├── __init__.py
│   │   ├── base.py        # Base CRUD operations
│   │   ├── user.py        # User CRUD operations
│   │   └── item.py        # Item CRUD operations
│   └── services/
│       ├── __init__.py    # Business logic services
│       └── email.py       # Email service
├── tests/
│   ├── __init__.py
│   ├── conftest.py        # Test fixtures
│   └── api/
│       ├── test_users.py
│       └── test_items.py
├── .env                   # Environment variables (gitignored)
├── alembic.ini            # Alembic configuration
├── pyproject.toml         # Dependencies and metadata
└── README.md
```

### Component Separation
- Define clear boundaries between components
- Use layered architecture (models, schemas, routes, services)
- Implement dependency injection for loose coupling
- Maintain consistent import patterns

```python
# Layered architecture example

# models/user.py - Database model
from sqlalchemy import Column, Integer, String
from app.core.database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)

# schemas/user.py - API schemas (request/response models)
from pydantic import BaseModel, EmailStr

class UserBase(BaseModel):
    email: EmailStr

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    is_active: bool
    
    class Config:
        orm_mode = True

# crud/user.py - Database operations
from sqlalchemy.orm import Session
from app.models.user import User
from app.schemas.user import UserCreate
from app.core.security import get_password_hash

def get_user(db: Session, user_id: int):
    return db.query(User).filter(User.id == user_id).first()

def create_user(db: Session, user: UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = User(email=user.email, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# api/routes/users.py - API endpoints
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.crud.user import get_user, create_user
from app.schemas.user import User, UserCreate

router = APIRouter()

@router.post("/", response_model=User)
def create_user_route(user: UserCreate, db: Session = Depends(get_db)):
    db_user = create_user(db=db, user=user)
    return db_user

@router.get("/{user_id}", response_model=User)
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = get_user(db=db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user
```

## Database Configuration

### SQLAlchemy Setup
- Configure proper database connection pooling
- Use environment variables for connection strings
- Define consistent base model class
- Implement session management

```python
# core/database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from app.core.config import settings

SQLALCHEMY_DATABASE_URL = settings.DATABASE_URL

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    pool_pre_ping=True,  # Check connection before using from pool
    pool_size=5,         # Connection pool size
    max_overflow=10,     # Max additional connections
    pool_timeout=30,     # Timeout for getting connection from pool
    pool_recycle=1800,   # Recycle connections after 30 minutes
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Dependency for routes
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

### Migration Strategy
- Use Alembic for database migrations
- Create migration scripts for schema changes
- Set up automated migration generation
- Document migration process

```python
# Example alembic migration workflow

# 1. Initialize alembic (run once)
# $ alembic init alembic

# 2. Configure alembic to use your SQLAlchemy models
# alembic/env.py
from app.models import Base
target_metadata = Base.metadata

# 3. Generate a migration after model changes
# $ alembic revision --autogenerate -m "Add user table"

# 4. Run migrations
# $ alembic upgrade head

# 5. Downgrade if necessary
# $ alembic downgrade -1
```

### Query Optimization
- Optimize database queries for performance
- Use eager loading with `joinedload` for related objects
- Implement pagination for large result sets
- Create indexes for frequently queried fields

```python
# Optimized query example
from sqlalchemy.orm import joinedload

def get_user_with_items(db: Session, user_id: int):
    return (
        db.query(User)
        .options(joinedload(User.items))  # Eager load items
        .filter(User.id == user_id)
        .first()
    )

# Pagination example
def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(User).offset(skip).limit(limit).all()

# Model with indexes
class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, index=True)  # Index on email
    username = Column(String, unique=True, index=True)  # Index on username
```

## API Design

### Endpoint Structure
- Design RESTful endpoints with consistent naming
- Group related endpoints under router prefixes
- Use appropriate HTTP methods for operations
- Implement status codes consistently

```python
# Example router for users resource
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.crud.user import get_user, create_user, update_user, delete_user
from app.schemas.user import User, UserCreate, UserUpdate

router = APIRouter(prefix="/users", tags=["users"])

@router.post("/", response_model=User, status_code=status.HTTP_201_CREATED)
def create_user_route(user: UserCreate, db: Session = Depends(get_db)):
    return create_user(db=db, user=user)

@router.get("/{user_id}", response_model=User)
def read_user_route(user_id: int, db: Session = Depends(get_db)):
    db_user = get_user(db=db, user_id=user_id)
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="User not found"
        )
    return db_user

@router.put("/{user_id}", response_model=User)
def update_user_route(
    user_id: int, user: UserUpdate, db: Session = Depends(get_db)
):
    db_user = get_user(db=db, user_id=user_id)
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="User not found"
        )
    return update_user(db=db, db_user=db_user, user=user)

@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user_route(user_id: int, db: Session = Depends(get_db)):
    db_user = get_user(db=db, user_id=user_id)
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="User not found"
        )
    delete_user(db=db, user_id=user_id)
    return None
```

### Request/Response Models
- Create Pydantic models for all request/response data
- Separate input and output schemas
- Use strict type validation
- Implement proper model inheritance

```python
# Example Pydantic schemas with inheritance
from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime

class ItemBase(BaseModel):
    title: str
    description: Optional[str] = None

class ItemCreate(ItemBase):
    pass

class ItemUpdate(ItemBase):
    title: Optional[str] = None

class Item(ItemBase):
    id: int
    owner_id: int
    created_at: datetime
    
    class Config:
        orm_mode = True

class UserBase(BaseModel):
    email: EmailStr
    is_active: Optional[bool] = True

class UserCreate(UserBase):
    password: str = Field(..., min_length=8)

class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    password: Optional[str] = Field(None, min_length=8)
    is_active: Optional[bool] = None

class User(UserBase):
    id: int
    items: List[Item] = []
    
    class Config:
        orm_mode = True
```

### Dependency Injection
- Use FastAPI's dependency injection system
- Create reusable dependencies
- Implement authentication/authorization via dependencies
- Layer dependencies for complex requirements

```python
# Example dependencies
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from sqlalchemy.orm import Session
from app.core.config import settings
from app.core.database import get_db
from app.crud.user import get_user_by_email
from app.models.user import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def get_current_user(
    db: Session = Depends(get_db),
    token: str = Depends(oauth2_scheme)
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM]
        )
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    user = get_user_by_email(db, email=email)
    if user is None:
        raise credentials_exception
    return user

def get_current_active_user(
    current_user: User = Depends(get_current_user),
):
    if not current_user.is_active:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user

def get_current_admin_user(
    current_user: User = Depends(get_current_active_user),
):
    if not current_user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    return current_user
```

## Authentication and Security

### Authentication Implementation
- Implement JWT-based authentication
- Use secure password hashing (bcrypt)
- Create token generation and verification functions
- Set appropriate token expiration

```python
# Security utilities
from datetime import datetime, timedelta
from typing import Optional
from jose import jwt
from passlib.context import CryptContext
from app.core.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
        )
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(
        to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM
    )
    return encoded_jwt

# Authentication endpoint
@router.post("/token", response_model=Token)
def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(
        minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
    )
    access_token = create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}
```

### Rate Limiting
- Implement rate limiting for API endpoints
- Use Redis or similar for distributed rate limiting
- Configure different limits for different endpoints
- Document rate limiting for API consumers

```python
# Using slowapi for rate limiting
from fastapi import FastAPI, Depends
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

limiter = Limiter(key_func=get_remote_address)
app = FastAPI()
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

@app.get("/limited")
@limiter.limit("5/minute")
async def limited_endpoint(request: Request):
    return {"message": "Rate limited endpoint"}

# Custom rate limits per user role
def rate_limit_by_user(request: Request, user: User = Depends(get_current_user)):
    if user.is_premium:
        return "100/minute"
    return "10/minute"

@app.get("/user-limited")
@limiter.limit(rate_limit_by_user)
async def user_limited_endpoint(
    request: Request, 
    user: User = Depends(get_current_user)
):
    return {"message": f"Endpoint with user-specific rate limits for {user.email}"}
```

### CORS Configuration
- Configure CORS for frontend compatibility
- Restrict allowed origins in production
- Set appropriate headers and methods
- Document CORS settings

```python
# CORS configuration
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings

app.add_middleware(
    CORSMiddleware,
    allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type"],
)
```

## Error Handling

### Exception Management
- Create custom exception classes for various error types
- Implement consistent error response format
- Use appropriate HTTP status codes
- Include helpful error messages

```python
# Custom exceptions
from fastapi import HTTPException, status

class BaseAPIException(HTTPException):
    status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    detail = "Internal server error"
    
    def __init__(self, detail=None, headers=None):
        super().__init__(
            status_code=self.status_code,
            detail=detail or self.detail,
            headers=headers,
        )

class NotFoundException(BaseAPIException):
    status_code = status.HTTP_404_NOT_FOUND
    detail = "Resource not found"

class BadRequestException(BaseAPIException):
    status_code = status.HTTP_400_BAD_REQUEST
    detail = "Bad request"

class UnauthorizedException(BaseAPIException):
    status_code = status.HTTP_401_UNAUTHORIZED
    detail = "Unauthorized"
    
    def __init__(self, detail=None, headers=None):
        headers = headers or {"WWW-Authenticate": "Bearer"}
        super().__init__(detail=detail, headers=headers)

class ForbiddenException(BaseAPIException):
    status_code = status.HTTP_403_FORBIDDEN
    detail = "Forbidden"

# Usage
def get_user_by_id(user_id: int, db: Session):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise NotFoundException(f"User with id {user_id} not found")
    return user
```

### Validation Error Handling
- Use Pydantic models for input validation
- Customize validation error responses
- Provide helpful error messages for validation failures
- Document validation requirements

```python
# Custom validation error handler
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from fastapi import status, Request

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(
    request: Request, exc: RequestValidationError
):
    errors = []
    for error in exc.errors():
        location = error["loc"]
        field = location[-1] if len(location) > 1 else location[0]
        errors.append({
            "field": field,
            "message": error["msg"],
            "type": error["type"],
        })
    
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "detail": "Validation Error",
            "errors": errors,
        },
    )
```

### Global Exception Handling
- Implement global exception handlers
- Log exceptions for debugging
- Return user-friendly error messages
- Hide sensitive error details in production

```python
# Global exception handler
from fastapi import Request
import logging
import traceback

logger = logging.getLogger(__name__)

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    # Log the error with traceback
    logger.error(
        f"Unhandled exception: {str(exc)}\n"
        f"Request: {request.method} {request.url}\n"
        f"Traceback: {traceback.format_exc()}"
    )
    
    # In production, return a generic message
    if settings.ENVIRONMENT == "production":
        return JSONResponse(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            content={"detail": "Internal server error"},
        )
    
    # In development, return more details
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "detail": "Internal server error",
            "error": str(exc),
            "traceback": traceback.format_exc().split("\n"),
        },
    )
```

## Performance Optimization

### Database Performance
- Use connection pooling efficiently
- Implement query optimization techniques
- Add appropriate indexes to database tables
- Use select_for_update for concurrency control

```python
# Query optimization examples
from sqlalchemy import func, or_
from sqlalchemy.orm import joinedload, contains_eager

# Count with proper SQL COUNT
def count_active_users(db: Session):
    return db.query(func.count(User.id)).filter(User.is_active == True).scalar()

# Complex query optimization
def search_users(db: Session, query: str, skip: int = 0, limit: int = 100):
    search = f"%{query}%"
    return (
        db.query(User)
        .options(joinedload(User.profile))  # Eager load profile
        .filter(
            or_(
                User.email.ilike(search),
                User.username.ilike(search),
                User.first_name.ilike(search),
                User.last_name.ilike(search),
            )
        )
        .offset(skip)
        .limit(limit)
        .all()
    )

# Select for update (concurrency control)
def update_user_balance(db: Session, user_id: int, amount: float):
    # Lock the row for update
    user = (
        db.query(User)
        .filter(User.id == user_id)
        .with_for_update()  # Lock row
        .first()
    )
    if not user:
        raise NotFoundException(f"User with id {user_id} not found")
    
    user.balance += amount
    db.commit()
    return user
```

### Response Optimization
- Use async endpoints for IO-bound operations
- Implement pagination for large result sets
- Consider response compression
- Use caching for expensive operations

```python
# Async endpoint example
@router.get("/async-users", response_model=List[User])
async def get_users_async(db: Session = Depends(get_db)):
    # Use a threadpool to run the blocking DB operation
    def get_all_users():
        return db.query(User).all()
    
    # Run in threadpool
    users = await asyncio.to_thread(get_all_users)
    return users

# Pagination with links
@router.get("/users", response_model=PaginatedResponse[User])
def get_users_paginated(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    request: Request = None,
):
    users = db.query(User).offset(skip).limit(limit).all()
    total = db.query(func.count(User.id)).scalar()
    
    # Create pagination links
    base_url = str(request.url).split("?")[0]
    links = {}
    
    if skip > 0:
        links["prev"] = f"{base_url}?skip={max(0, skip-limit)}&limit={limit}"
    
    if skip + limit < total:
        links["next"] = f"{base_url}?skip={skip+limit}&limit={limit}"
    
    return {
        "items": users,
        "total": total,
        "skip": skip,
        "limit": limit,
        "links": links,
    }
```

### Caching Strategy
- Implement caching for frequently accessed data
- Use Redis or similar for distributed caching
- Set appropriate cache expiration times
- Implement cache invalidation strategies

```python
# Simple Redis cache example
from redis import Redis
import json
from functools import wraps

redis_client = Redis.from_url(settings.REDIS_URL)

def cache(expire_seconds=60):
    def decorator(func):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            # Create cache key from function name and arguments
            key_parts = [func.__name__]
            key_parts.extend([str(arg) for arg in args])
            key_parts.extend([f"{k}:{v}" for k, v in sorted(kwargs.items())])
            cache_key = ":".join(key_parts)
            
            # Try to get from cache
            cached = redis_client.get(cache_key)
            if cached:
                return json.loads(cached)
            
            # Execute function and cache result
            result = await func(*args, **kwargs)
            redis_client.setex(
                cache_key,
                expire_seconds,
                json.dumps(result, default=str),
            )
            return result
        return wrapper
    return decorator

# Usage
@router.get("/cached-stats")
@cache(expire_seconds=300)  # 5 minutes
async def get_system_stats():
    # Expensive operation
    stats = calculate_system_stats()
    return stats
```

## Testing

### Test Structure
- Organize tests by feature/module
- Create test fixtures with pytest
- Use test database for integration tests
- Implement comprehensive test coverage

```python
# tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.core.database import Base, get_db
from app.main import app

# Create test database
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(scope="function")
def db():
    # Create the database tables
    Base.metadata.create_all(bind=engine)
    
    # Create a session for testing
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        
    # Drop all tables after the test
    Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def client(db):
    # Override the get_db dependency
    def override_get_db():
        try:
            yield db
        finally:
            pass
    
    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()

# Fixture for test user
@pytest.fixture(scope="function")
def test_user(db):
    from app.crud.user import create_user
    from app.schemas.user import UserCreate
    
    user_in = UserCreate(
        email="test@example.com",
        password="password123",
    )
    user = create_user(db=db, user=user_in)
    return user
```

### Unit Tests
- Test individual components in isolation
- Mock external dependencies
- Focus on edge cases and error conditions
- Use parametrized tests for multiple scenarios

```python
# tests/crud/test_user.py
import pytest
from app.crud.user import create_user, get_user, get_user_by_email
from app.schemas.user import UserCreate

def test_create_user(db):
    user_in = UserCreate(
        email="test@example.com",
        password="password123",
    )
    user = create_user(db=db, user=user_in)
    assert user.email == "test@example.com"
    assert hasattr(user, "hashed_password")
    assert user.hashed_password != "password123"

def test_get_user(db, test_user):
    user = get_user(db=db, user_id=test_user.id)
    assert user
    assert user.id == test_user.id
    assert user.email == test_user.email

def test_get_user_by_email(db, test_user):
    user = get_user_by_email(db=db, email=test_user.email)
    assert user
    assert user.id == test_user.id
    assert user.email == test_user.email

def test_get_user_nonexistent(db):
    user = get_user(db=db, user_id=999)
    assert user is None

@pytest.mark.parametrize(
    "email,password,valid",
    [
        ("test@example.com", "password123", True),
        ("invalid@example.com", "password123", False),
        ("test@example.com", "wrongpassword", False),
    ],
)
def test_authenticate_user(db, test_user, email, password, valid):
    from app.crud.user import authenticate_user
    
    user = authenticate_user(db=db, email=email, password=password)
    if valid:
        assert user
        assert user.id == test_user.id
    else:
        assert user is None
```

### Integration Tests
- Test API endpoints with TestClient
- Verify correct response status codes
- Check response data structure
- Test error handling

```python
# tests/api/test_users.py
from fastapi import status

def test_create_user(client):
    response = client.post(
        "/users/",
        json={"email": "test@example.com", "password": "password123"},
    )
    assert response.status_code == status.HTTP_201_CREATED
    data = response.json()
    assert data["email"] == "test@example.com"
    assert "id" in data

def test_read_user(client, test_user):
    response = client.get(f"/users/{test_user.id}")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["email"] == test_user.email
    assert data["id"] == test_user.id

def test_read_user_not_found(client):
    response = client.get("/users/999")
    assert response.status_code == status.HTTP_404_NOT_FOUND

def test_authentication(client, test_user):
    # Test login
    response = client.post(
        "/token",
        data={"username": test_user.email, "password": "password123"},
    )
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"
    
    # Test protected endpoint
    token = data["access_token"]
    response = client.get(
        "/users/me",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["email"] == test_user.email
    assert data["id"] == test_user.id
```

## Deployment

### Environment Configuration
- Use environment variables for configuration
- Create separate settings for different environments
- Implement secrets management
- Document required environment variables

```python
# core/config.py
from pydantic import BaseSettings, AnyHttpUrl, validator
from typing import List, Optional, Union
import secrets
from functools import lru_cache

class Settings(BaseSettings):
    API_V1_STR: str = "/api/v1"
    SECRET_KEY: str = secrets.token_urlsafe(32)
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # Database settings
    DATABASE_URL: str
    
    # CORS settings
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = []
    
    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> List[str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        if isinstance(v, list):
            return v
        return []
    
    # Environment name
    ENVIRONMENT: str = "dev"
    
    # Redis
    REDIS_URL: Optional[str] = None
    
    class Config:
        env_file = ".env"
        case_sensitive = True

@lru_cache()
def get_settings():
    return Settings()

settings = get_settings()
```

### Docker Setup
- Create Docker configuration for the application
- Use multi-stage builds for efficiency
- Configure Docker Compose for local development
- Document Docker-related commands

```dockerfile
# Dockerfile
FROM python:3.9-slim as builder

WORKDIR /app/

# Install poetry
RUN pip install poetry==1.1.13

# Copy poetry configuration
COPY pyproject.toml poetry.lock* /app/

# Configure poetry
RUN poetry config virtualenvs.in-project true && \
    poetry install --no-dev --no-interaction --no-ansi

FROM python:3.9-slim

WORKDIR /app/

# Copy virtual environment
COPY --from=builder /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH"

# Copy application code
COPY . /app/

# Set environment variables
ENV PYTHONPATH=/app

# Run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/app
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/app
      - ENVIRONMENT=dev
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis
    command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

  db:
    image: postgres:13
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=app
    ports:
      - "5432:5432"

  redis:
    image: redis:6
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

### Performance Tuning
- Configure Uvicorn for production deployment
- Use Gunicorn as process manager
- Implement proper worker configuration
- Monitor application performance

```
# Example deployment command
gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app
```

```python
# gunicorn.conf.py for deployment
from multiprocessing import cpu_count

# Worker Options
workers = cpu_count() * 2 + 1
worker_class = 'uvicorn.workers.UvicornWorker'

# Server Socket
bind = "0.0.0.0:8000"

# Logging
loglevel = 'info'
accesslog = 'access.log'
errorlog = 'error.log'

# Process Naming
proc_name = 'fastapi-app'

# Server Mechanics
daemon = False
```

## Documentation and Tooling

### API Documentation
- Use automatic Swagger/OpenAPI documentation
- Add proper descriptions to endpoints
- Document request/response models
- Include authentication requirements

```python
# main.py
from fastapi import FastAPI
from app.api.routes import users, items
from app.core.config import settings

app = FastAPI(
    title="My FastAPI Application",
    description="FastAPI application with SQLAlchemy ORM",
    version="0.1.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
)

# Include routers
app.include_router(
    users.router,
    prefix=f"{settings.API_V1_STR}/users",
    tags=["users"],
)
app.include_router(
    items.router,
    prefix=f"{settings.API_V1_STR}/items",
    tags=["items"],
)

# Customize OpenAPI documentation
app.openapi = custom_openapi_function
```

### Code Quality Tools
- Use linters (flake8, pylint) for code quality
- Implement type checking with mypy
- Use automated formatting with black
- Configure pre-commit hooks

```toml
# pyproject.toml
[tool.black]
line-length = 88
target-version = ['py38']
include = '\.pyi?$'

[tool.isort]
profile = "black"
multi_line_output = 3

[tool.mypy]
python_version = 3.8
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[tool.pytest.ini_options]
testpaths = ["tests"]
```

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.0.1
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/pycqa/isort
    rev: 5.9.3
    hooks:
      - id: isort

  - repo: https://github.com/psf/black
    rev: 21.9b0
    hooks:
      - id: black

  - repo: https://github.com/pycqa/flake8
    rev: 4.0.1
    hooks:
      - id: flake8
        additional_dependencies: [flake8-docstrings]
```