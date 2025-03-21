---
description: "Guidelines for building efficient, reproducible, and maintainable data science workflows with the Python ecosystem"
globs: "*.py,*.ipynb"
---

# Python Data Science Stack Best Practices

## Environment Setup

- Use virtual environments for project isolation
- Implement proper dependency management (requirements.txt, environment.yml)
- Consider containerization for reproducibility
- Document environment setup procedures
- Use appropriate package management (pip, conda)
- Consider GPU support configuration when needed
- Implement proper version pinning
- Document hardware requirements
- Consider cloud environment configurations
- Use environment variables for sensitive information

## Project Structure

- Implement clear separation between data, code, and outputs
- Design for reproducible workflows
- Consider modular organization of code
- Implement proper documentation structure
- Design for appropriate version control
- Document project organization
- Consider cookiecutter templates for consistency
- Implement proper path handling
- Design for appropriate configuration management
- Consider test directories and organization

## Data Management

- Implement proper data versioning
- Design for appropriate data storage formats
- Consider data validation and cleaning pipelines
- Implement proper data partitioning
- Design for appropriate data documentation
- Document data schemas and sources
- Consider storage optimization strategies
- Implement proper data access patterns
- Design for appropriate data privacy handling
- Consider distributed data handling when appropriate

## Exploratory Data Analysis

- Implement structured EDA workflows
- Design for appropriate visualization techniques
- Consider interactive exploration tools
- Implement proper summary statistics
- Design for appropriate outlier detection
- Document exploration findings
- Consider automated EDA tools
- Implement proper feature relationship analysis
- Design for appropriate categorical data exploration
- Consider dimensionality reduction for exploration

## Data Preprocessing

- Implement proper feature scaling techniques
- Design for appropriate encoding strategies
- Consider missing value imputation
- Implement proper outlier handling
- Design for appropriate feature selection
- Document preprocessing steps
- Consider automated preprocessing pipelines
- Implement proper transformation pipelines
- Design for appropriate feature engineering
- Consider dimensionality reduction techniques

## Modeling Workflow

- Implement proper model selection strategies
- Design for appropriate validation techniques
- Consider hyperparameter optimization
- Implement proper model evaluation metrics
- Design for appropriate model persistence
- Document modeling decisions and rationales
- Consider model interpretability techniques
- Implement proper prediction pipelines
- Design for appropriate ensemble methods
- Consider model deployment requirements

## NumPy Usage

- Implement vectorized operations whenever possible
- Design for appropriate array memory management
- Consider advanced indexing techniques
- Implement proper broadcasting patterns
- Design for appropriate dtype selection
- Document array manipulation patterns
- Consider memory optimization techniques
- Implement proper random number generation
- Design for appropriate mathematical operations
- Consider specialized NumPy functions for performance

## Pandas Best Practices

- Implement proper DataFrame creation and manipulation
- Design for appropriate indexing strategies
- Consider method chaining for readability
- Implement proper groupby operations
- Design for appropriate merge and join strategies
- Document DataFrame transformations
- Consider categorical data types for efficiency
- Implement proper time series handling
- Design for appropriate missing data handling
- Consider optimized I/O operations

## Visualization Techniques

- Implement consistent visualization styles
- Design for appropriate plot types
- Consider interactive visualization when needed
- Implement proper figure organization
- Design for appropriate color usage
- Document visualization code
- Consider accessibility in visualizations
- Implement proper annotation strategies
- Design for appropriate sizing and layout
- Consider publication-quality visualizations

## Performance Optimization

- Implement memory-efficient operations
- Design for appropriate chunking of large datasets
- Consider parallelization when appropriate
- Implement proper caching strategies
- Design for appropriate algorithm selection
- Document performance bottlenecks and solutions
- Consider specialized libraries for performance
- Implement proper profiling techniques
- Design for appropriate I/O optimization
- Consider GPU acceleration when appropriate

## Reproducibility

- Implement proper random seed management
- Design for deterministic processing pipelines
- Consider containerized workflows
- Implement proper pipeline versioning
- Design for appropriate environment capture
- Document step-by-step reproduction procedures
- Consider automated workflow tools
- Implement proper logging for parameter tracking
- Design for appropriate result verification
- Consider reproducible reporting techniques

## Testing Data Science Code

- Implement proper unit testing for core functions
- Design for appropriate pipeline testing
- Consider data validation tests
- Implement proper model validation tests
- Design for appropriate statistical hypothesis testing
- Document testing approach
- Consider automated testing in CI/CD
- Implement proper test data management
- Design for appropriate test coverage
- Consider property-based testing for data transformations

## Documentation

- Implement comprehensive docstrings
- Design for appropriate notebook documentation
- Consider automatic documentation generation
- Implement proper README and project documentation
- Design for appropriate code comments
- Document data sources and licenses
- Consider literate programming approaches
- Implement proper function and parameter documentation
- Design for appropriate example usage documentation
- Consider documentation testing

## Collaboration

- Implement proper version control workflows
- Design for appropriate code review processes
- Consider pair analysis sessions
- Implement proper communication channels
- Design for appropriate knowledge sharing
- Document collaboration guidelines
- Consider collaborative tools integration
- Implement proper artifact sharing
- Design for appropriate team organization
- Consider cross-functional collaboration approaches

## Deployment Considerations

- Implement proper model serialization
- Design for appropriate inference APIs
- Consider containerization for deployment
- Implement proper monitoring of deployed models
- Design for appropriate scaling strategies
- Document deployment architecture
- Consider model updating procedures
- Implement proper versioning for deployed artifacts
- Design for appropriate error handling in production
- Consider integration with existing systems