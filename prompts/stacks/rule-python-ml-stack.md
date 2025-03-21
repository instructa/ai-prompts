---
description: "Guidelines for building robust, efficient, and production-ready machine learning systems with Python"
globs: "*.py,*.ipynb"
---

# Python Machine Learning Stack Best Practices

## Environment and Infrastructure

- Use virtual environments for project isolation
- Implement proper dependency management
- Consider containerization for reproducibility
- Document hardware requirements
- Use appropriate package management (pip, conda)
- Consider GPU configuration for training
- Implement proper version pinning
- Document environment setup procedures
- Consider cloud environment configurations
- Use environment variables for configuration

## Project Structure

- Implement clear separation between model code, data pipelines, and evaluation
- Design for reproducible workflows
- Consider modular organization of code
- Implement proper documentation structure
- Design for appropriate version control
- Document project organization
- Consider cookiecutter templates for ML projects
- Implement proper path handling
- Design for appropriate configuration management
- Consider test directories and organization

## Data Management

- Implement proper data versioning
- Design for appropriate data storage formats
- Consider data validation and quality assurance
- Implement proper train/validation/test splitting
- Design for appropriate data documentation
- Document data schemas and sources
- Consider storage optimization strategies
- Implement proper data access patterns
- Design for appropriate data privacy handling
- Consider distributed data handling for large datasets

## Feature Engineering

- Implement proper feature selection techniques
- Design for appropriate feature transformation
- Consider automated feature engineering
- Implement proper feature scaling
- Design for appropriate categorical encoding
- Document feature engineering decisions
- Consider feature importance analysis
- Implement proper feature validation
- Design for appropriate dimensionality reduction
- Consider domain-specific feature engineering

## Model Selection and Training

- Implement systematic model selection processes
- Design for appropriate validation techniques
- Consider hyperparameter optimization strategies
- Implement proper cross-validation
- Design for appropriate model evaluation metrics
- Document model selection rationale
- Consider experiment tracking tools
- Implement proper early stopping criteria
- Design for appropriate regularization techniques
- Consider ensemble methods when appropriate

## Scikit-learn Best Practices

- Implement proper Pipeline and FeatureUnion usage
- Design for appropriate estimator selection
- Consider custom estimator implementation when needed
- Implement proper parameter grid design
- Design for appropriate cross-validation strategy
- Document scikit-learn workflow
- Consider memory constraints with large datasets
- Implement proper persistence of scikit-learn objects
- Design for appropriate preprocessing
- Consider scikit-learn extension libraries

## TensorFlow/Keras Best Practices

- Implement proper model architecture design
- Design for appropriate layer selection
- Consider custom layer implementation when needed
- Implement proper loss function selection
- Design for appropriate optimizer configuration
- Document model architecture decisions
- Consider TensorFlow dataset API for data loading
- Implement proper callback usage
- Design for appropriate batch size selection
- Consider TensorFlow Extended (TFX) for production

## PyTorch Best Practices

- Implement proper Dataset and DataLoader usage
- Design for appropriate model implementation
- Consider custom Module implementation when needed
- Implement proper optimizer selection
- Design for appropriate loss function configuration
- Document PyTorch workflow
- Consider GPU memory management
- Implement proper checkpoint saving and loading
- Design for appropriate gradient handling
- Consider torchscript for production deployment

## Model Evaluation

- Implement comprehensive evaluation metrics
- Design for appropriate performance benchmarking
- Consider confidence interval estimation
- Implement proper confusion matrix analysis
- Design for appropriate threshold optimization
- Document evaluation methodology
- Consider model calibration assessment
- Implement proper error analysis
- Design for appropriate baseline comparisons
- Consider domain-specific evaluation metrics

## Hyperparameter Optimization

- Implement proper hyperparameter search strategies
- Design for appropriate parameter spaces
- Consider Bayesian optimization approaches
- Implement proper parallelization of searches
- Design for appropriate cross-validation integration
- Document hyperparameter tuning methodology
- Consider early stopping criteria for efficiency
- Implement proper results tracking
- Design for appropriate hyperparameter importance analysis
- Consider automated hyperparameter optimization tools

## Experiment Tracking

- Implement proper experiment logging
- Design for appropriate metric tracking
- Consider tool selection (MLflow, Weights & Biases, etc.)
- Implement proper artifact tracking
- Design for appropriate experiment comparison
- Document experiment configurations
- Consider reproducibility of experiments
- Implement proper tagging and organization
- Design for appropriate collaboration features
- Consider integration with model registry

## Model Interpretability

- Implement appropriate feature importance analysis
- Design for model-agnostic interpretability
- Consider specific interpretability techniques for complex models
- Implement proper visualization of interpretability results
- Design for appropriate local vs. global explanations
- Document interpretation methodology
- Consider regulatory compliance requirements
- Implement proper partial dependence analysis
- Design for appropriate counterfactual explanations
- Consider fairness analysis

## Model Deployment

- Implement proper model serialization
- Design for appropriate inference APIs
- Consider containerization for deployment
- Implement proper monitoring of deployed models
- Design for appropriate scaling strategies
- Document deployment architecture
- Consider model updating procedures
- Implement proper versioning for deployed models
- Design for appropriate error handling in production
- Consider A/B testing strategies

## Performance Optimization

- Implement optimized data loading and preprocessing
- Design for appropriate batch processing
- Consider quantization techniques for inference
- Implement proper algorithm selection for training
- Design for appropriate hardware utilization
- Document performance optimization strategies
- Consider parallelization techniques
- Implement proper caching strategies
- Design for appropriate I/O optimization
- Consider optimization of inference latency

## Documentation

- Implement comprehensive docstrings
- Design for appropriate model documentation
- Consider model cards for transparency
- Implement proper README and project documentation
- Design for appropriate code comments
- Document data sources and licenses
- Consider automated documentation generation
- Implement proper function and parameter documentation
- Design for appropriate example usage documentation
- Consider documentation testing