---
description: "Best practices for MLOps (Machine Learning Operations) lifecycle management"
globs: "*.py,*.ipynb,*.yaml,*.yml,Dockerfile,requirements.txt,setup.py,config.json,params.yaml,dvc.yaml"
alwaysApply: false
---

# MLOps Best Practices

## Key Principles

- Implement reproducible ML pipelines with version control for data, code, and models
- Create automated CI/CD workflows for machine learning projects
- Apply proper model deployment and serving strategies
- Utilize appropriate experiment tracking and model registry solutions
- Implement effective monitoring for model performance and data drift
- Follow infrastructure-as-code practices for ML environments
- Create robust testing strategies for ML components

## Pipeline Organization

- Design modular ML pipelines with clear separation of concerns
- Implement proper data versioning with tools like DVC
- Create reproducible feature engineering steps
- Apply appropriate hyperparameter management
- Use pipeline orchestration tools (Airflow, Kubeflow, etc.)
- Implement proper pipeline triggers and scheduling
- Create effective artifact management
- Document pipeline architecture and dependencies
- Implement proper error handling and retry logic
- Apply appropriate pipeline debugging capabilities

## Experiment Management

- Implement proper experiment tracking
- Create effective model versioning
- Apply appropriate hyperparameter logging
- Use standardized metric tracking
- Implement proper experiment metadata
- Create reproducible experiment configurations
- Apply distributed training when appropriate
- Implement proper experiment comparisons
- Use effective visualization for experiment results
- Document experiment design decisions

## Model Lifecycle Management

- Implement proper model packaging
- Create effective model registry practices
- Apply appropriate model versioning
- Use effective model metadata management
- Implement proper model staging (dev, staging, prod)
- Create robust model approval workflows
- Apply appropriate model lineage tracking
- Implement model rollback capabilities
- Use systematic A/B testing for model updates
- Follow proper model retirement procedures

## Infrastructure Management

- Implement infrastructure as code for ML environments
- Create scalable training infrastructure
- Apply appropriate resource management
- Use container orchestration effectively
- Implement proper GPU/TPU utilization
- Create effective environment reproducibility
- Apply proper environment isolation
- Use appropriate cloud resource optimization
- Implement cost-effective scaling strategies
- Document infrastructure dependencies

## Testing and Quality

- Implement proper data validation tests
- Create effective model validation strategies
- Apply appropriate unit tests for pipeline components
- Use integration tests for pipeline workflows
- Implement proper performance benchmarking
- Create effective model performance tests
- Apply appropriate data drift detection
- Implement model behavior tests
- Use proper CI/CD test automation
- Document testing requirements and procedures

## Monitoring and Observability

- Implement proper model performance monitoring
- Create effective data drift detection
- Apply appropriate feature drift detection
- Use proper alerting mechanisms
- Implement effective logging strategies
- Create dashboards for key metrics
- Apply appropriate real-time monitoring
- Implement proper debugging capabilities
- Use effective incident response workflows
- Document monitoring requirements

## Security and Compliance

- Implement proper access control for models and data
- Create effective data privacy measures
- Apply appropriate model security practices
- Use secure model serving strategies
- Implement proper audit trails
- Create effective compliance documentation
- Apply appropriate encryption for sensitive data
- Implement proper vulnerability management
- Use secure API design for model serving
- Document security and compliance requirements
