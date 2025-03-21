---
description: "Best practices for building web applications with Flask and SQLAlchemy ORM"
globs: "*.py,models.py,views.py,routes.py,app.py,config.py"
---

# Flask + SQLAlchemy Stack Best Practices

The Flask + SQLAlchemy stack combines Flask's lightweight web framework with SQLAlchemy's powerful ORM capabilities, providing a flexible foundation for building web applications with robust database interactions.

## Project Structure

### Directory Organization
- Use application factory pattern for flexible configuration
- Organize project into modular components
- Separate concerns with dedicated modules
- Use blueprints for feature organization

```
myproject/
├── myproject/
│   ├── __init__.py           # App factory
│   ├── config.py             # Configuration settings
│   ├── extensions.py         # Flask extensions (SQLAlchemy, etc.)
│   ├── models/
│   │   ├── __init__.py       # Import models
│   │   ├── user.py           # User model
│   │   └── item.py           # Item model
│   ├── api/
│   │   ├── __init__.py       # Blueprint creation
│   │   ├── users.py          # User routes
│   │   └── items.py          # Item routes
│   ├── auth/
│   │   ├── __init__.py       # Auth blueprint
│   │   └── routes.py         # Auth routes
│   ├── templates/            # Jinja2 templates
│   │   └── ...
│   ├── static/               # Static files
│   │   └── ...
│   └── utils/                # Utility functions
│       └── ...
├── migrations/               # Alembic migrations
│   └── ...
├── tests/                    # Test files
│   ├── conftest.py           # Test fixtures
│   ├── test_models.py        # Model tests
│   └── test_api.py           # API tests
├── .env                      # Environment variables (gitignore)
├── .flaskenv                 # Flask variables
├── setup.py                  # Package setup
└── requirements.txt          # Dependencies
```

### Application Factory
- Implement app factory pattern for modular setup
- Register extensions and blueprints systematically
- Configure the application based on environment
- Create clear initialization routines

```python
# myproject/__init__.py
from flask import Flask
from flask_migrate import Migrate

from myproject.extensions import db
from myproject.config import config

# Import blueprints
from myproject.api import api_bp
from myproject.auth import auth_bp

def create_app(config_name='default'):
    """Create and configure the Flask application."""
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    db.init_app(app)
    migrate = Migrate(app, db)
    
    # Register blueprints
    app.register_blueprint(api_bp, url_prefix='/api')
    app.register_blueprint(auth_bp, url_prefix='/auth')
    
    # Register shell context
    @app.shell_context_processor
    def make_shell_context():
        return {'db': db, 'User': User, 'Item': Item}
    
    return app

# myproject/extensions.py
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

db = SQLAlchemy()
ma = Marshmallow()
```

### Blueprint Organization
- Create focused blueprints for feature areas
- Implement consistent route registration
- Use URL prefixes for logical grouping
- Include error handlers at appropriate levels

```python
# myproject/api/__init__.py
from flask import Blueprint

api_bp = Blueprint('api', __name__)

# Import routes after creating blueprint to avoid circular imports
from myproject.api import users, items

# myproject/api/users.py
from flask import jsonify, request
from myproject.api import api_bp
from myproject.models.user import User
from myproject.extensions import db

@api_bp.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return jsonify([user.to_dict() for user in users])

@api_bp.route('/users/<int:id>', methods=['GET'])
def get_user(id):
    user = User.query.get_or_404(id)
    return jsonify(user.to_dict())

@api_bp.errorhandler(404)
def resource_not_found(e):
    return jsonify(error=str(e)), 404
```

## Database Configuration

### SQLAlchemy Setup
- Configure SQLAlchemy with best practices
- Use environment variables for connection strings
- Set up appropriate connection pooling
- Create consistent model base classes

```python
# myproject/config.py
import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Base configuration."""
    SECRET_KEY = os.environ.get('SECRET_KEY', 'dev-key')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_size': 10,
        'pool_recycle': 60,
        'pool_pre_ping': True,
    }

class DevelopmentConfig(Config):
    """Development configuration."""
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DEV_DATABASE_URL', 'sqlite:///dev.sqlite'
    )

class TestingConfig(Config):
    """Testing configuration."""
    TESTING = True
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'TEST_DATABASE_URL', 'sqlite:///:memory:'
    )

class ProductionConfig(Config):
    """Production configuration."""
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL', 'postgresql://user:pass@localhost/dbname'
    )

config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}
```

### Model Design
- Create clear, well-structured SQLAlchemy models
- Use appropriate relationship patterns
- Implement model mixins for common functionality
- Include serialization methods or properties

```python
# myproject/models/base.py
from datetime import datetime
from myproject.extensions import db

class CRUDMixin:
    """Mixin that adds convenience methods for CRUD operations."""

    @classmethod
    def create(cls, **kwargs):
        """Create a new record and save it to the database."""
        instance = cls(**kwargs)
        return instance.save()

    def update(self, commit=True, **kwargs):
        """Update specific fields of a record."""
        for attr, value in kwargs.items():
            setattr(self, attr, value)
        return self.save() if commit else self

    def save(self, commit=True):
        """Save the record."""
        db.session.add(self)
        if commit:
            db.session.commit()
        return self

    def delete(self, commit=True):
        """Remove the record from the database."""
        db.session.delete(self)
        if commit:
            db.session.commit()

class TimestampMixin:
    """Mixin for tracking when records are created and updated."""
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(
        db.DateTime, 
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )

class Model(db.Model, CRUDMixin):
    """Base model class that includes CRUD convenience methods."""
    __abstract__ = True

class TimestampModel(Model, TimestampMixin):
    """Base model class that includes CRUD and timestamp convenience methods."""
    __abstract__ = True

# myproject/models/user.py
from werkzeug.security import generate_password_hash, check_password_hash
from myproject.models.base import TimestampModel
from myproject.extensions import db

class User(TimestampModel):
    """User model for storing user data."""
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(256))
    is_active = db.Column(db.Boolean, default=True)
    
    # Relationships
    items = db.relationship('Item', back_populates='user', lazy='dynamic')
    
    def __repr__(self):
        return f'<User {self.username}>'
    
    def set_password(self, password):
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'is_active': self.is_active,
            'created_at': self.created_at.isoformat(),
            'updated_at': self.updated_at.isoformat()
        }
```

### Migration Strategy
- Use Flask-Migrate (Alembic) for database migrations
- Create proper migration scripts for schema changes
- Set up automated migration discovery
- Document migration commands and workflow

```python
# Command examples for migrations

# Initialize migrations directory
# $ flask db init

# Create a migration
# $ flask db migrate -m "Create user and item tables"

# Apply migrations
# $ flask db upgrade

# Downgrade if necessary
# $ flask db downgrade
```

## Route Design

### RESTful Endpoints
- Design consistent RESTful API endpoints
- Use appropriate HTTP methods for operations
- Implement proper response status codes
- Structure URL patterns logically

```python
# myproject/api/items.py
from flask import jsonify, request, url_for
from myproject.api import api_bp
from myproject.models.item import Item
from myproject.extensions import db

# List items
@api_bp.route('/items', methods=['GET'])
def get_items():
    page = request.args.get('page', 1, type=int)
    per_page = min(request.args.get('per_page', 10, type=int), 100)
    
    pagination = Item.query.paginate(page=page, per_page=per_page)
    items = pagination.items
    
    prev_url = url_for('api.get_items', page=page-1) if pagination.has_prev else None
    next_url = url_for('api.get_items', page=page+1) if pagination.has_next else None
    
    return jsonify({
        'items': [item.to_dict() for item in items],
        'prev': prev_url,
        'next': next_url,
        'total': pagination.total
    })

# Get item
@api_bp.route('/items/<int:id>', methods=['GET'])
def get_item(id):
    item = Item.query.get_or_404(id)
    return jsonify(item.to_dict())

# Create item
@api_bp.route('/items', methods=['POST'])
def create_item():
    data = request.get_json() or {}
    
    if 'name' not in data:
        return jsonify({'error': 'Missing required field: name'}), 400
    
    item = Item(name=data['name'], description=data.get('description', ''))
    item.save()
    
    response = item.to_dict()
    response['_links'] = {'self': url_for('api.get_item', id=item.id)}
    return jsonify(response), 201

# Update item
@api_bp.route('/items/<int:id>', methods=['PUT'])
def update_item(id):
    item = Item.query.get_or_404(id)
    data = request.get_json() or {}
    
    item.update(**data)
    
    return jsonify(item.to_dict())

# Delete item
@api_bp.route('/items/<int:id>', methods=['DELETE'])
def delete_item(id):
    item = Item.query.get_or_404(id)
    item.delete()
    
    return '', 204
```

### Request Handling
- Validate request data thoroughly
- Implement proper error handling for malformed requests
- Use marshmallow or similar for schema validation
- Handle query parameters consistently

```python
# Using marshmallow for validation
from myproject.extensions import ma

class ItemSchema(ma.Schema):
    class Meta:
        fields = ('id', 'name', 'description', 'user_id', 'created_at', 'updated_at')

item_schema = ItemSchema()
items_schema = ItemSchema(many=True)

@api_bp.route('/items', methods=['POST'])
def create_item():
    data = request.get_json() or {}
    
    # Validate data
    errors = item_schema.validate(data)
    if errors:
        return jsonify(errors), 400
    
    item = Item(**data)
    item.save()
    
    return jsonify(item_schema.dump(item)), 201
```

### Response Formatting
- Create consistent response formats
- Include appropriate metadata in responses
- Implement HATEOAS links when appropriate
- Use proper content types and headers

```python
def create_response(data, status_code=200, headers=None):
    """Helper function to create a consistent API response."""
    response = {
        'data': data,
        'status': 'success' if status_code < 400 else 'error',
        'timestamp': datetime.utcnow().isoformat()
    }
    
    return jsonify(response), status_code, headers

def create_paginated_response(query, schema, page, per_page, endpoint, **kwargs):
    """Helper function to create paginated responses."""
    pagination = query.paginate(page=page, per_page=per_page)
    
    data = schema.dump(pagination.items)
    
    # Create pagination links
    params = {**request.args.to_dict(), **kwargs}
    
    links = {}
    if pagination.has_prev:
        links['prev'] = url_for(
            endpoint, page=page-1, per_page=per_page, **params
        )
    if pagination.has_next:
        links['next'] = url_for(
            endpoint, page=page+1, per_page=per_page, **params
        )
    
    response = {
        'data': data,
        'meta': {
            'page': page,
            'per_page': per_page,
            'total': pagination.total,
            'pages': pagination.pages
        },
        'links': links
    }
    
    return create_response(response)
```

## Authentication and Security

### Authentication Implementation
- Use Flask-Login or similar for session management
- Implement token-based authentication for APIs
- Create secure password handling routines
- Support multiple authentication methods when needed

```python
# myproject/extensions.py
from flask_login import LoginManager

login_manager = LoginManager()

# In application factory
def create_app(config_name='default'):
    # ...
    login_manager.init_app(app)
    # ...

# In User model
from flask_login import UserMixin

class User(UserMixin, TimestampModel):
    # ...

# In auth module
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@auth_bp.route('/login', methods=['POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('main.index'))
    
    data = request.get_json() or {}
    
    user = User.query.filter_by(username=data.get('username')).first()
    if user is None or not user.check_password(data.get('password')):
        return jsonify({'error': 'Invalid username or password'}), 401
    
    login_user(user, remember=data.get('remember', False))
    return jsonify({'message': 'Login successful'})

@auth_bp.route('/logout')
def logout():
    logout_user()
    return jsonify({'message': 'Logout successful'})
```

### Token Authentication
- Implement JWT tokens for API authentication
- Set appropriate token expiration
- Create secure token generation and validation
- Include token refresh mechanisms

```python
# myproject/extensions.py
from flask_jwt_extended import JWTManager

jwt = JWTManager()

# In application factory
def create_app(config_name='default'):
    # ...
    jwt.init_app(app)
    # ...

# In auth routes
from flask_jwt_extended import (
    create_access_token, create_refresh_token, 
    jwt_required, get_jwt_identity
)

@auth_bp.route('/token', methods=['POST'])
def get_token():
    data = request.get_json() or {}
    
    username = data.get('username')
    password = data.get('password')
    
    user = User.query.filter_by(username=username).first()
    if user is None or not user.check_password(password):
        return jsonify({'error': 'Invalid username or password'}), 401
    
    # Create tokens
    access_token = create_access_token(identity=user.id)
    refresh_token = create_refresh_token(identity=user.id)
    
    return jsonify({
        'access_token': access_token,
        'refresh_token': refresh_token
    })

@auth_bp.route('/token/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh_token():
    current_user_id = get_jwt_identity()
    access_token = create_access_token(identity=current_user_id)
    
    return jsonify({'access_token': access_token})

# In protected routes
@api_bp.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    return jsonify({'message': f'Hello, {user.username}!'})
```

### Security Considerations
- Implement proper CSRF protection
- Configure secure cookies and sessions
- Use HTTPS in production
- Set appropriate security headers

```python
# myproject/config.py
class Config:
    # ...
    SESSION_COOKIE_SECURE = True  # In production
    SESSION_COOKIE_HTTPONLY = True
    REMEMBER_COOKIE_SECURE = True
    REMEMBER_COOKIE_HTTPONLY = True
    JWT_COOKIE_SECURE = True
    
    # For Flask-Talisman (HTTPS and security headers)
    TALISMAN_FORCE_HTTPS = True
    TALISMAN_CONTENT_SECURITY_POLICY = {
        'default-src': "'self'",
        'img-src': '*',
        'script-src': ["'self'", 'code.jquery.com'],
        'style-src': ["'self'", 'fonts.googleapis.com'],
    }

# In application factory
from flask_talisman import Talisman

def create_app(config_name='default'):
    # ...
    if not app.debug and not app.testing:
        Talisman(app)
    # ...
```

## Error Handling

### Global Error Handlers
- Implement comprehensive error handlers
- Create consistent error response format
- Log errors appropriately
- Return user-friendly error messages

```python
# myproject/errors.py
from flask import Blueprint, jsonify
import logging

errors_bp = Blueprint('errors', __name__)
logger = logging.getLogger(__name__)

@errors_bp.app_errorhandler(400)
def bad_request(e):
    logger.warning(f'Bad request: {str(e)}')
    return jsonify(error='Bad request', message=str(e)), 400

@errors_bp.app_errorhandler(404)
def not_found(e):
    return jsonify(error='Not found', message=str(e)), 404

@errors_bp.app_errorhandler(500)
def internal_server_error(e):
    logger.error(f'Server error: {str(e)}')
    return jsonify(error='Internal server error'), 500

@errors_bp.app_errorhandler(Exception)
def unhandled_exception(e):
    logger.exception(f'Unhandled exception: {str(e)}')
    return jsonify(error='Internal server error'), 500

# In application factory
def create_app(config_name='default'):
    # ...
    from myproject.errors import errors_bp
    app.register_blueprint(errors_bp)
    # ...
```

### Custom Exceptions
- Create application-specific exception classes
- Map exceptions to appropriate HTTP status codes
- Include helpful context in exception messages
- Document exception handling patterns

```python
# myproject/exceptions.py
class APIException(Exception):
    """Base exception for API errors."""
    status_code = 500
    message = 'An unexpected error occurred'
    
    def __init__(self, message=None, status_code=None, payload=None):
        super().__init__()
        if message is not None:
            self.message = message
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload
    
    def to_dict(self):
        rv = dict(self.payload or ())
        rv['error'] = self.message
        return rv

class ResourceNotFound(APIException):
    """Exception raised when a requested resource is not found."""
    status_code = 404
    message = 'Resource not found'

class ValidationError(APIException):
    """Exception raised for validation errors."""
    status_code = 400
    message = 'Validation error'

# In myproject/errors.py
@errors_bp.app_errorhandler(APIException)
def handle_api_exception(e):
    response = jsonify(e.to_dict())
    response.status_code = e.status_code
    return response

# Usage in views
@api_bp.route('/items/<int:id>', methods=['GET'])
def get_item(id):
    item = Item.query.get(id)
    if item is None:
        raise ResourceNotFound(f'Item with id {id} not found')
    return jsonify(item.to_dict())
```

## Performance Optimization

### Query Optimization
- Use efficient SQLAlchemy query patterns
- Implement proper join strategies
- Optimize N+1 query problems
- Use database indexes effectively

```python
# Optimizing queries

# Bad: N+1 query problem
@api_bp.route('/users_with_items', methods=['GET'])
def users_with_items_bad():
    users = User.query.all()
    result = []
    
    for user in users:
        # This causes N additional queries, one per user
        items = [item.to_dict() for item in user.items]
        user_dict = user.to_dict()
        user_dict['items'] = items
        result.append(user_dict)
    
    return jsonify(result)

# Good: Eager loading to solve N+1
@api_bp.route('/users_with_items', methods=['GET'])
def users_with_items_good():
    users = User.query.options(
        db.joinedload(User.items)  # Eager load in a single query
    ).all()
    
    result = []
    for user in users:
        user_dict = user.to_dict()
        user_dict['items'] = [item.to_dict() for item in user.items]
        result.append(user_dict)
    
    return jsonify(result)

# Using indexes in models
class Item(TimestampModel):
    __tablename__ = 'items'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), index=True)
    category = db.Column(db.String(50), index=True)  # Add index for frequently queried field
    
    # For composite index on multiple columns
    __table_args__ = (
        db.Index('idx_item_name_category', 'name', 'category'),
    )
```

### Caching
- Implement proper caching strategies
- Use Flask-Caching for view caching
- Consider Redis for distributed caching
- Cache expensive operations and frequent queries

```python
# myproject/extensions.py
from flask_caching import Cache

cache = Cache()

# In application factory
def create_app(config_name='default'):
    # ...
    cache_config = {
        'CACHE_TYPE': 'redis',
        'CACHE_REDIS_URL': os.environ.get('REDIS_URL', 'redis://localhost:6379/0'),
        'CACHE_DEFAULT_TIMEOUT': 300
    }
    cache.init_app(app, config=cache_config)
    # ...

# In views
@api_bp.route('/expensive-operation', methods=['GET'])
@cache.cached(timeout=60)  # Cache for 60 seconds
def expensive_operation():
    # Perform expensive database query or calculation
    result = slow_function()
    return jsonify(result)

# Memoize function results
@cache.memoize(timeout=300)
def get_user_stats(user_id):
    """Compute statistics for a user (expensive operation)."""
    # Expensive computation here
    return stats

# Cache key for logged in user
def make_cache_key():
    """Create a cache key based on current user and request path."""
    return f"{request.path}:{current_user.id if current_user else 'anonymous'}"

@api_bp.route('/user-specific-data', methods=['GET'])
@cache.cached(timeout=60, key_prefix=make_cache_key)
def user_specific_data():
    # Data specific to current user
    return jsonify(data)

# Cache invalidation
@api_bp.route('/items/<int:id>', methods=['PUT'])
def update_item(id):
    item = Item.query.get_or_404(id)
    data = request.get_json() or {}
    
    item.update(**data)
    
    # Invalidate cache for this item
    cache.delete_memoized(get_item_by_id, id)
    
    return jsonify(item.to_dict())
```

### Database Connection Pooling
- Configure SQLAlchemy connection pooling appropriately
- Set pool size based on workload and server resources
- Implement connection recycling
- Monitor connection usage

```python
# myproject/config.py
class Config:
    # ...
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_size': 10,  # Default max connections
        'max_overflow': 20,  # Additional connections when pool_size is reached
        'pool_timeout': 30,  # Seconds to wait before giving up on getting a connection
        'pool_recycle': 1800,  # Seconds - recycle connections after 30 minutes
        'pool_pre_ping': True,  # Check connection validity before using from pool
    }
```

## Testing

### Test Configuration
- Create separate test configuration
- Use test database (SQLite in-memory or separate test DB)
- Implement test fixtures for common setup
- Use factories for test data generation

```python
# tests/conftest.py
import pytest
from myproject import create_app
from myproject.extensions import db as _db

@pytest.fixture(scope='session')
def app():
    """Create and configure a Flask app for testing."""
    app = create_app('testing')
    
    # Create a test context
    with app.app_context():
        yield app

@pytest.fixture(scope='session')
def db(app):
    """Create and configure a database for testing."""
    _db.create_all()
    yield _db
    _db.drop_all()

@pytest.fixture(scope='function')
def session(db):
    """Create a new database session for a test."""
    connection = db.engine.connect()
    transaction = connection.begin()
    
    session = db.create_scoped_session(
        options=dict(bind=connection, binds={})
    )
    db.session = session
    
    yield session
    
    transaction.rollback()
    connection.close()
    session.remove()

@pytest.fixture
def client(app):
    """Create a test client for the app."""
    with app.test_client() as client:
        yield client

@pytest.fixture
def user(session):
    """Create a test user."""
    user = User(
        username='testuser',
        email='test@example.com'
    )
    user.set_password('password')
    session.add(user)
    session.commit()
    return user
```

### Model Testing
- Test model properties and relationships
- Verify constraint enforcement
- Test custom model methods
- Check serialization functionality

```python
# tests/test_models.py
def test_user_creation(session):
    user = User(
        username='testuser',
        email='test@example.com'
    )
    user.set_password('password')
    session.add(user)
    session.commit()
    
    assert user.id is not None
    assert user.username == 'testuser'
    assert user.email == 'test@example.com'
    assert user.check_password('password')
    assert not user.check_password('wrongpassword')

def test_user_unique_constraint(session, user):
    # Try to create a user with the same username
    duplicate_user = User(
        username='testuser',  # Same as fixture
        email='another@example.com'
    )
    session.add(duplicate_user)
    
    # Should raise an IntegrityError
    with pytest.raises(Exception):
        session.commit()
    
    session.rollback()

def test_relationship(session, user):
    # Create item related to user
    item = Item(name='Test Item', user_id=user.id)
    session.add(item)
    session.commit()
    
    # Test relationship from user to item
    assert item in user.items
    
    # Test relationship from item to user
    assert item.user == user
```

### API Testing
- Test API endpoints for correct behavior
- Verify response status codes and formats
- Test authentication and permissions
- Include edge cases and error conditions

```python
# tests/test_api.py
import json

def test_get_users(client):
    response = client.get('/api/users')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert isinstance(data, list)

def test_create_user(client):
    data = {
        'username': 'newuser',
        'email': 'newuser@example.com',
        'password': 'password'
    }
    response = client.post(
        '/api/users',
        data=json.dumps(data),
        content_type='application/json'
    )
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['username'] == 'newuser'
    assert 'id' in data

def test_get_nonexistent_user(client):
    response = client.get('/api/users/999')
    assert response.status_code == 404

def test_authentication(client, user):
    # Test login with invalid credentials
    response = client.post(
        '/auth/token',
        data=json.dumps({
            'username': 'testuser',
            'password': 'wrongpassword'
        }),
        content_type='application/json'
    )
    assert response.status_code == 401
    
    # Test login with valid credentials
    response = client.post(
        '/auth/token',
        data=json.dumps({
            'username': 'testuser',
            'password': 'password'
        }),
        content_type='application/json'
    )
    assert response.status_code == 200
    data = json.loads(response.data)
    assert 'access_token' in data
    
    # Test protected endpoint
    token = data['access_token']
    response = client.get(
        '/api/protected',
        headers={'Authorization': f'Bearer {token}'}
    )
    assert response.status_code == 200
```

## Deployment and Configuration

### Environment Configuration
- Use environment variables for configuration
- Implement environment-specific settings
- Secure sensitive configuration
- Document configuration options

```python
# .env example
FLASK_APP=myproject
FLASK_ENV=development
SECRET_KEY=your-secret-key
DATABASE_URL=postgresql://user:pass@localhost/dbname
REDIS_URL=redis://localhost:6379/0

# .flaskenv example
FLASK_APP=myproject
FLASK_ENV=development
```

### Production Deployment
- Configure production WSGI server (Gunicorn, uWSGI)
- Set up proper process management
- Implement logging configuration
- Use reverse proxy (Nginx, Apache) in front of Flask

```python
# Production server configuration
# gunicorn.conf.py
import multiprocessing

bind = "0.0.0.0:5000"
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "gevent"
keepalive = 5
timeout = 120
accesslog = "-"
errorlog = "-"
loglevel = "info"

# Example nginx config
"""
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
"""
```

### Logging Configuration
- Implement comprehensive logging
- Configure different log levels
- Set up log rotation
- Include contextual information in logs

```python
# myproject/config.py
import logging
import os
from logging.handlers import RotatingFileHandler

class Config:
    # ...
    LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO')
    LOG_DIR = os.environ.get('LOG_DIR', 'logs')
    
    @staticmethod
    def init_logging(app):
        if not os.path.exists(Config.LOG_DIR):
            os.mkdir(Config.LOG_DIR)
        
        # Set log level
        log_level = getattr(logging, Config.LOG_LEVEL)
        
        # Configure root logger
        logging.basicConfig(level=log_level)
        
        # Configure app logger
        app_logger = logging.getLogger('myproject')
        app_logger.setLevel(log_level)
        
        # Create file handler
        file_handler = RotatingFileHandler(
            os.path.join(Config.LOG_DIR, 'myproject.log'),
            maxBytes=10 * 1024 * 1024,  # 10 MB
            backupCount=10
        )
        file_formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        file_handler.setFormatter(file_formatter)
        
        # Add handler to logger
        app_logger.addHandler(file_handler)
        
        # Configure SQLAlchemy logging if in debug mode
        if app.debug:
            logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

# In application factory
def create_app(config_name='default'):
    # ...
    config[config_name].init_logging(app)
    # ...
```

## Documentation and Tooling

### API Documentation
- Use Flask-RESTful or similar for API structure
- Implement Swagger/OpenAPI documentation
- Document request/response formats
- Include authentication requirements

```python
# Using Flask-RESTful with Swagger docs
from flask_restful import Api
from flask_restful_swagger_2 import swagger, Schema

api = Api(app)

class UserModel(Schema):
    type = 'object'
    properties = {
        'id': {
            'type': 'integer',
        },
        'username': {
            'type': 'string',
        },
        'email': {
            'type': 'string',
        },
    }
    required = ['username', 'email']

class UserResource(Resource):
    @swagger.doc({
        'tags': ['users'],
        'summary': 'Get a user by ID',
        'parameters': [
            {
                'name': 'id',
                'in': 'path',
                'type': 'integer',
                'required': True,
                'description': 'The ID of the user'
            }
        ],
        'responses': {
            '200': {
                'description': 'User',
                'schema': UserModel,
            },
            '404': {
                'description': 'User not found'
            }
        }
    })
    def get(self, id):
        user = User.query.get_or_404(id)
        return user.to_dict()

api.add_resource(UserResource, '/api/users/<int:id>')
```

### Code Quality Tools
- Use linters (flake8, pylint) for code quality
- Implement type checking with mypy
- Set up automated code formatting
- Configure pre-commit hooks

```ini
# setup.cfg
[flake8]
max-line-length = 88
exclude = .git,__pycache__,build,dist
ignore = E203, W503

[mypy]
python_version = 3.9
warn_return_any = True
warn_unused_configs = True
disallow_untyped_defs = True
disallow_incomplete_defs = True

[mypy.plugins.flask.*]
follow_imports = silent

[mypy.plugins.sqlalchemy.*]
follow_imports = silent
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
```

## Common Patterns and Extensions

### Task Queues
- Use Celery for background tasks
- Implement job scheduling with Celery Beat
- Configure task result backends
- Handle task failures and retries

```python
# myproject/extensions.py
from celery import Celery

celery = Celery()

# myproject/tasks.py
from myproject.extensions import celery, db
from myproject.models.user import User

@celery.task
def send_welcome_email(user_id):
    """Send welcome email to new user."""
    with celery.app.app_context():
        user = User.query.get(user_id)
        if user:
            # Send email logic here
            user.welcome_email_sent = True
            db.session.commit()
            return True
    return False

# In application factory
def create_app(config_name='default'):
    # ...
    app.config.update(
        CELERY_BROKER_URL=app.config['CELERY_BROKER_URL'],
        CELERY_RESULT_BACKEND=app.config['CELERY_RESULT_BACKEND']
    )
    celery.conf.update(app.config)
    
    class ContextTask(celery.Task):
        def __call__(self, *args, **kwargs):
            with app.app_context():
                return self.run(*args, **kwargs)
    
    celery.Task = ContextTask
    # ...

# Usage in views
@api_bp.route('/users', methods=['POST'])
def create_user():
    data = request.get_json() or {}
    
    # Create user
    user = User(**data)
    user.save()
    
    # Send welcome email asynchronously
    send_welcome_email.delay(user.id)
    
    return jsonify(user.to_dict()), 201
```

### Rate Limiting
- Implement rate limiting for API endpoints
- Use Redis or similar for distributed rate limiting
- Create different limits for various endpoint types
- Document rate limits for API consumers

```python
# Using Flask-Limiter
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    key_func=get_remote_address,
    default_limits=["200 per day", "50 per hour"]
)

# In application factory
def create_app(config_name='default'):
    # ...
    limiter.init_app(app)
    # ...

# In views
@api_bp.route('/rate-limited', methods=['GET'])
@limiter.limit("10 per minute")
def rate_limited_endpoint():
    return jsonify({'message': 'This endpoint is rate limited'})

# Dynamic limits based on user
@api_bp.route('/user-limited', methods=['GET'])
@jwt_required()
@limiter.limit(lambda: get_user_limit(get_jwt_identity()))
def user_limited_endpoint():
    return jsonify({'message': 'User-specific rate limit'})

def get_user_limit(user_id):
    user = User.query.get(user_id)
    if user and user.is_premium:
        return "100 per minute"
    return "10 per minute"
```

### WebSockets
- Implement WebSockets for real-time communication
- Use Flask-SocketIO or similar
- Handle connection management
- Implement proper error handling

```python
# myproject/extensions.py
from flask_socketio import SocketIO

socketio = SocketIO()

# In application factory
def create_app(config_name='default'):
    # ...
    socketio.init_app(app, cors_allowed_origins="*")
    # ...

# myproject/sockets.py
from flask_socketio import emit, join_room, leave_room
from flask_jwt_extended import decode_token
from myproject.extensions import socketio
from myproject.models.user import User

@socketio.on('connect')
def handle_connect():
    token = request.args.get('token')
    if not token:
        return False  # Reject connection
    
    try:
        decoded = decode_token(token)
        user_id = decoded['sub']
        user = User.query.get(user_id)
        if not user:
            return False
    except:
        return False
    
    return True

@socketio.on('join')
def handle_join(data):
    room = data.get('room')
    if room:
        join_room(room)
        emit('status', {'msg': f'Joined room: {room}'})

@socketio.on('leave')
def handle_leave(data):
    room = data.get('room')
    if room:
        leave_room(room)
        emit('status', {'msg': f'Left room: {room}'})

@socketio.on('message')
def handle_message(data):
    room = data.get('room')
    message = data.get('message')
    
    if room and message:
        emit('message', {
            'user': 'username',
            'message': message
        }, room=room)
```

### Email Handling
- Use Flask-Mail or similar for email sending
- Create reusable email templates
- Implement asynchronous email sending
- Set up email error handling

```python
# myproject/extensions.py
from flask_mail import Mail

mail = Mail()

# In application factory
def create_app(config_name='default'):
    # ...
    mail.init_app(app)
    # ...

# myproject/email.py
from flask import render_template, current_app
from flask_mail import Message
from threading import Thread
from myproject.extensions import mail

def send_async_email(app, msg):
    with app.app_context():
        mail.send(msg)

def send_email(subject, recipients, text_body, html_body, sender=None, attachments=None):
    msg = Message(
        subject,
        recipients=recipients,
        sender=sender or current_app.config['MAIL_DEFAULT_SENDER']
    )
    msg.body = text_body
    msg.html = html_body
    
    if attachments:
        for attachment in attachments:
            msg.attach(*attachment)
    
    # Send asynchronously
    Thread(
        target=send_async_email,
        args=(current_app._get_current_object(), msg)
    ).start()

def send_password_reset_email(user):
    token = user.get_reset_password_token()
    send_email(
        subject='Reset Your Password',
        recipients=[user.email],
        text_body=render_template('email/reset_password.txt', user=user, token=token),
        html_body=render_template('email/reset_password.html', user=user, token=token)
    )
```