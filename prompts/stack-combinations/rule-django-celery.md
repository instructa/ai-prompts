---
description: "Best practices for using Django with Celery for asynchronous task processing"
globs: "*.py,celery.py,tasks.py,*.conf,settings.py"
---

# Django + Celery Stack Best Practices

The Django + Celery stack combines Django's web framework capabilities with Celery's distributed task queue system, enabling efficient handling of asynchronous tasks, background processing, and scheduled operations.

## Architecture and Setup

### Project Structure
- Organize Celery-related files in a consistent location
- Define Celery configuration in a dedicated module
- Keep task definitions separate from views and models
- Use appropriate namespacing for task modules

```
myproject/
├── manage.py
├── myproject/
│   ├── __init__.py     # Import celery.py here for autodiscovery
│   ├── settings.py     # Celery configuration settings
│   ├── celery.py       # Celery app configuration
│   └── urls.py
├── apps/
│   ├── app1/
│   │   ├── __init__.py
│   │   ├── models.py
│   │   ├── views.py
│   │   └── tasks.py    # App-specific tasks
│   └── app2/
│       ├── __init__.py
│       ├── models.py
│       ├── views.py
│       └── tasks.py    # App-specific tasks
└── celerybeat-schedule  # Beat database (gitignored)
```

### Celery Configuration
- Configure broker settings properly (Redis or RabbitMQ)
- Use result backends for task result storage
- Set appropriate task time limits and rate limits
- Configure concurrency based on server resources

```python
# settings.py
CELERY_BROKER_URL = 'redis://localhost:6379/0'
CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'
CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_TIMEZONE = 'UTC'
CELERY_TASK_TIME_LIMIT = 30 * 60  # 30 minutes
CELERY_TASK_SOFT_TIME_LIMIT = 60  # 1 minute
CELERY_WORKER_MAX_TASKS_PER_CHILD = 1000  # Restart worker after 1000 tasks
```

### Application Integration
- Enable task autodiscovery in Celery configuration
- Initialize Celery in a dedicated app module
- Configure Redis connection pooling
- Ensure Celery settings match Django settings

```python
# celery.py
import os
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')

app = Celery('myproject')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()

# __init__.py (project root)
from .celery import app as celery_app
__all__ = ('celery_app',)
```

## Task Design

### Task Definition
- Create focused, single-responsibility tasks
- Use descriptive task names with namespacing
- Implement proper error handling and retries
- Document task parameters and return values

```python
# tasks.py
from celery import shared_task
from celery.utils.log import get_task_logger

logger = get_task_logger(__name__)

@shared_task(
    name='app1.process_data',
    bind=True,
    max_retries=3,
    default_retry_delay=60,
    autoretry_for=(Exception,),
    retry_backoff=True,
)
def process_data(self, data_id):
    """
    Process data identified by data_id.
    
    Args:
        data_id: ID of the data to process
        
    Returns:
        dict: Processing results
    """
    logger.info(f"Processing data {data_id}")
    try:
        # Process data
        result = {'status': 'success', 'data_id': data_id}
        return result
    except Exception as exc:
        logger.error(f"Error processing data {data_id}: {exc}")
        self.retry(exc=exc)
```

### Task Parameters
- Pass IDs instead of entire objects to tasks
- Minimize data sent to tasks to reduce serialization overhead
- Avoid circular imports by passing identifiers
- Use JSON-serializable arguments

```python
# Good: Pass identifiers
@shared_task
def process_user_data(user_id):
    from myapp.models import User
    user = User.objects.get(id=user_id)
    # Process user data

# Bad: Pass whole objects (will be serialized)
@shared_task
def process_user_data(user):  # Not recommended
    # Process user data
```

### Task Chaining and Workflows
- Use Celery Canvas for complex task workflows
- Implement chains for sequential operations
- Use groups for parallel task execution
- Implement proper error handling in workflows

```python
from celery import chain, group

# Sequential tasks
result = chain(
    extract_data.s(data_id),
    transform_data.s(),
    load_data.s()
).apply_async()

# Parallel tasks
result = group(
    process_user.s(user_id) 
    for user_id in user_ids
).apply_async()
```

## Task Scheduling

### Periodic Tasks
- Use Celery Beat for scheduling recurring tasks
- Store periodic task definitions in settings
- Consider using django-celery-beat for dynamic scheduling
- Implement proper timezone handling

```python
# settings.py
from celery.schedules import crontab

CELERY_BEAT_SCHEDULE = {
    'daily-report': {
        'task': 'myapp.tasks.generate_daily_report',
        'schedule': crontab(hour=0, minute=0),  # Midnight
        'args': (),
    },
    'process-queue': {
        'task': 'myapp.tasks.process_queue',
        'schedule': 60.0,  # Every minute
        'args': (),
    },
}
```

### Dynamic Scheduling
- Implement django-celery-beat for database-backed schedules
- Use appropriate interval patterns (crontab vs. fixed intervals)
- Include proper timezone handling for global applications
- Document scheduled tasks and their purpose

```python
# Using django-celery-beat for dynamic scheduling
from django_celery_beat.models import PeriodicTask, CrontabSchedule

# Create schedule
schedule, _ = CrontabSchedule.objects.get_or_create(
    hour='3',
    minute='0',
    day_of_week='*',
    day_of_month='*',
    month_of_year='*',
)

# Create task
PeriodicTask.objects.get_or_create(
    name='generate-monthly-report',
    task='myapp.tasks.generate_monthly_report',
    crontab=schedule,
    args=json.dumps(['arg1', 'arg2']),
    kwargs=json.dumps({
        'param1': 'value1',
        'param2': 'value2',
    }),
)
```

## Error Handling and Monitoring

### Task Retry Mechanisms
- Configure appropriate retry policies
- Implement exponential backoff for retries
- Set max retry limits for failing tasks
- Handle permanent failures gracefully

```python
@shared_task(
    bind=True,
    max_retries=5,
    default_retry_delay=60,
    autoretry_for=(ConnectionError, IOError),
    retry_backoff=True,
    retry_backoff_max=600,  # Max 10 minutes between retries
    retry_jitter=True,
)
def process_external_api(self, data_id):
    try:
        # Process data
        pass
    except Exception as exc:
        logger.error(f"Failed to process data {data_id}: {exc}")
        self.retry(exc=exc)
```

### Logging and Monitoring
- Implement structured logging for tasks
- Set up monitoring for task execution times
- Track success/failure rates for tasks
- Use tools like Flower for Celery monitoring

```python
# settings.py
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'level': 'INFO',
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': 'celery.log',
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'celery': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
        },
    },
}
```

### Dead Letter Queues
- Implement dead letter queues for failed tasks
- Create monitoring for dead letter queues
- Establish processes for handling permanently failed tasks
- Document recovery procedures

```python
# settings.py
CELERY_ROUTES = {
    'myapp.tasks.critical_task': {
        'queue': 'critical',
        'routing_key': 'critical.task',
    },
}

# Set up dead letter queue in RabbitMQ
CELERY_BROKER_TRANSPORT_OPTIONS = {
    'queue_arguments': {
        'x-dead-letter-exchange': 'dead-letter',
        'x-dead-letter-routing-key': 'dead-letter',
    },
}
```

## Performance Optimization

### Resource Management
- Configure appropriate worker concurrency
- Use prefetch multiplier to optimize task distribution
- Implement resource-based rate limiting
- Monitor and optimize memory usage

```python
# celery.py or command line
app.conf.worker_concurrency = 8  # Number of worker processes
app.conf.worker_prefetch_multiplier = 4  # Number of tasks prefetched
app.conf.worker_max_tasks_per_child = 1000  # Restart workers periodically
```

### Task Prioritization
- Implement task prioritization with queue routing
- Set up separate queues for critical vs. non-critical tasks
- Configure workers for specific queues
- Document queue purposes and priorities

```python
# settings.py
CELERY_TASK_ROUTES = {
    'myapp.tasks.critical_task': {'queue': 'high_priority'},
    'myapp.tasks.daily_report': {'queue': 'low_priority'},
}

# Worker commands
# celery -A myproject worker -Q high_priority -c 4
# celery -A myproject worker -Q low_priority -c 2
```

### Database Optimization
- Use database connections efficiently in tasks
- Close connections explicitly when finished
- Use atomic transactions when appropriate
- Consider using bulk operations for efficiency

```python
@shared_task
def process_batch(user_ids):
    from django.db import connection
    
    try:
        # Process data
        # Use bulk operations
        User.objects.filter(id__in=user_ids).update(processed=True)
    finally:
        # Explicitly close connections
        connection.close()
```

## Deployment and Production

### Worker Management
- Run workers as separate services from web processes
- Configure appropriate process management (systemd, supervisor)
- Implement proper logging for worker processes
- Set up monitoring and health checks

```ini
# supervisor config for celery workers
[program:celery-worker]
command=/path/to/venv/bin/celery -A myproject worker -l INFO -Q default
directory=/path/to/project
user=celery
numprocs=1
stdout_logfile=/var/log/celery/worker.log
stderr_logfile=/var/log/celery/worker.error.log
autostart=true
autorestart=true
startsecs=10
stopwaitsecs=600

[program:celery-beat]
command=/path/to/venv/bin/celery -A myproject beat -l INFO
directory=/path/to/project
user=celery
numprocs=1
stdout_logfile=/var/log/celery/beat.log
stderr_logfile=/var/log/celery/beat.error.log
autostart=true
autorestart=true
startsecs=10
stopwaitsecs=10
```

### Broker Configuration
- Use production-grade broker (Redis or RabbitMQ)
- Configure broker redundancy and high availability
- Set proper connection timeouts and health checks
- Monitor broker performance and queue sizes

```python
# settings.py (RabbitMQ with HA)
CELERY_BROKER_URL = 'amqp://user:password@rabbitmq-server//vhost'
CELERY_BROKER_POOL_LIMIT = 10
CELERY_BROKER_CONNECTION_TIMEOUT = 10
CELERY_BROKER_CONNECTION_RETRY = True
CELERY_BROKER_CONNECTION_MAX_RETRIES = 5
```

### Security Considerations
- Secure broker connections with SSL/TLS
- Restrict broker access with strong authentication
- Configure proper task serialization (JSON, not pickle)
- Implement appropriate worker isolation

```python
# settings.py (Secure broker connection)
CELERY_BROKER_URL = 'rediss://:password@redis-server:6379/0'  # Note rediss (SSL)
CELERY_BROKER_USE_SSL = {
    'ssl_cert_reqs': ssl.CERT_REQUIRED,
    'ssl_ca_certs': '/path/to/CA.pem',
    'ssl_certfile': '/path/to/client.cert',
    'ssl_keyfile': '/path/to/client.key',
}
```

## Testing and Development

### Task Testing
- Create specific test cases for Celery tasks
- Use eager mode for synchronous task execution in tests
- Mock external dependencies when testing tasks
- Verify task results and side effects

```python
# tests.py
from django.test import TestCase
from unittest.mock import patch
from myapp.tasks import process_data

class TaskTestCase(TestCase):
    def setUp(self):
        # Enable eager mode for testing
        self.task_always_eager = settings.CELERY_TASK_ALWAYS_EAGER
        settings.CELERY_TASK_ALWAYS_EAGER = True
        
    def tearDown(self):
        settings.CELERY_TASK_ALWAYS_EAGER = self.task_always_eager
    
    @patch('myapp.tasks.external_api')
    def test_process_data(self, mock_api):
        # Setup mock
        mock_api.get_data.return_value = {'key': 'value'}
        
        # Execute task synchronously
        result = process_data.delay(1)
        
        # Verify result
        self.assertEqual(result.get(), {'status': 'success'})
        
        # Verify mock was called
        mock_api.get_data.assert_called_once_with(1)
```

### Development Environment
- Use Docker for local broker setup
- Configure separate settings for development
- Use eager mode for easy debugging
- Implement task visualization tools (Flower)

```yaml
# docker-compose.yml for development
version: '3'

services:
  redis:
    image: redis:6
    ports:
      - "6379:6379"
  
  rabbitmq:
    image: rabbitmq:3-management
    ports:
      - "5672:5672"
      - "15672:15672"
  
  flower:
    image: mher/flower
    command: --broker=redis://redis:6379/0
    ports:
      - "5555:5555"
    depends_on:
      - redis
```

## Common Patterns and Best Practices

### Task Results Management
- Decide whether to store task results deliberately
- Configure proper result expiration
- Handle task results asynchronously with callbacks
- Clean up old results periodically

```python
# settings.py
CELERY_RESULT_BACKEND = 'django-db'  # Store in database
CELERY_RESULT_EXPIRES = 60 * 60 * 24  # 1 day in seconds

# Using callbacks for result handling
@shared_task
def process_data(data_id):
    # Process data
    return result

@shared_task
def handle_result(result):
    # Handle the result
    pass

# Chain the tasks
process_data.apply_async(
    args=[data_id],
    link=handle_result.s(),
)
```

### Idempotent Tasks
- Design tasks to be idempotent (safe to run multiple times)
- Implement proper state tracking for tasks
- Use locking mechanisms for non-idempotent operations
- Document task idempotency guarantees

```python
@shared_task(bind=True)
def process_order(self, order_id):
    from myapp.models import Order
    
    # Get lock to prevent concurrent processing
    lock_id = f"order-processing-{order_id}"
    with redis_lock(lock_id, timeout=60*5):  # 5 minute timeout
        order = Order.objects.get(id=order_id)
        
        # Check if already processed
        if order.status == 'processed':
            logger.info(f"Order {order_id} already processed")
            return {'status': 'already_processed'}
        
        # Process order
        order.process()
        order.status = 'processed'
        order.save()
        
        return {'status': 'success'}
```

### Task Progress Tracking
- Implement progress tracking for long-running tasks
- Store progress updates in the result backend
- Use websockets for real-time progress updates
- Design user interfaces for task progress visualization

```python
@shared_task(bind=True)
def process_large_dataset(self, dataset_id):
    from myapp.models import Dataset
    dataset = Dataset.objects.get(id=dataset_id)
    
    total_items = dataset.items.count()
    
    for i, item in enumerate(dataset.items.all()):
        # Process item
        process_item(item)
        
        # Update progress
        progress = int(100 * (i + 1) / total_items)
        self.update_state(
            state='PROGRESS',
            meta={'current': i + 1, 'total': total_items, 'percent': progress}
        )
    
    return {'status': 'completed', 'processed': total_items}
```

### Task Routing by Data
- Implement sharding for data-dependent tasks
- Route related tasks to the same worker for data locality
- Use consistent hashing for task distribution
- Document routing strategies for maintenance

```python
# Task routing based on data
def get_queue_for_user(user_id):
    # Simple sharding based on user_id
    shard = user_id % 4
    return f"user_shard_{shard}"

@shared_task
def process_user_data(user_id):
    # Process user data
    pass

# When calling the task
from celery import current_app

queue = get_queue_for_user(user_id)
current_app.send_task(
    'myapp.tasks.process_user_data',
    args=[user_id],
    queue=queue
)
```