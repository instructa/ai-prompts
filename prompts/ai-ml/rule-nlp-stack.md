---
description: "Best practices for Natural Language Processing (NLP) application development"
globs: "*.py,*.ipynb,*.txt,*.csv,*.json,*.jsonl,requirements.txt,setup.py"
alwaysApply: false
---

# NLP Stack Best Practices

## Key Principles

- Design efficient and effective text processing pipelines
- Implement proper preprocessing techniques for textual data
- Apply appropriate tokenization and normalization methods
- Utilize effective language models and embeddings
- Implement proper evaluation metrics for NLP tasks
- Create scalable text processing workflows
- Follow best practices for multilingual NLP applications

## Text Preprocessing

- Implement proper tokenization for your language and task
- Create effective text normalization steps
- Apply appropriate cleaning techniques
- Use efficient data loading for large text corpora
- Implement proper handling of special characters
- Create consistent lowercase/uppercase handling
- Apply appropriate stopword removal when needed
- Implement proper punctuation handling
- Use effective sentence segmentation
- Create appropriate text standardization procedures

## Feature Engineering

- Implement effective vectorization techniques
- Create proper N-gram features when appropriate
- Apply appropriate word embeddings (word2vec, GloVe, etc.)
- Use contextualized embeddings effectively (BERT, RoBERTa, etc.)
- Implement proper feature scaling for text features
- Create effective sparse matrix representations
- Apply appropriate dimensionality reduction
- Use TF-IDF weighting effectively
- Implement proper vocabulary management
- Create custom features for domain-specific tasks

## Model Selection

- Choose appropriate models for specific NLP tasks
- Implement proper model architecture design
- Apply appropriate transfer learning techniques
- Use effective fine-tuning strategies for pretrained models
- Implement ensemble methods when beneficial
- Create efficient model deployment pipelines
- Apply proper attention mechanisms
- Use appropriate sequence modeling techniques
- Implement effective transformer architectures
- Create custom loss functions for specific tasks

## Language Models

- Use appropriate pretrained language models
- Implement proper contextual understanding
- Apply effective fine-tuning techniques
- Create domain-specific adaptations
- Use proper prompting techniques
- Implement effective model distillation when needed
- Apply appropriate few-shot learning techniques
- Create effective prompt engineering strategies
- Use model quantization for efficient deployment
- Implement proper caching for inference

## Multilingual Considerations

- Implement proper language detection
- Create effective cross-lingual models
- Apply appropriate language-specific preprocessing
- Use multilingual embeddings effectively
- Implement proper character encoding handling
- Create language-agnostic features when possible
- Apply appropriate translation techniques
- Use language-specific resources effectively
- Implement proper handling of low-resource languages
- Create effective evaluation for multilingual performance

## Task-Specific Techniques

- Implement effective techniques for text classification
- Create proper named entity recognition pipelines
- Apply appropriate sentiment analysis methods
- Use effective question answering techniques
- Implement proper text generation strategies
- Create effective summarization pipelines
- Apply appropriate machine translation techniques
- Use effective information extraction methods
- Implement proper topic modeling approaches
- Create appropriate text clustering techniques

## Evaluation and Testing

- Implement proper evaluation metrics for NLP tasks
- Create effective cross-validation strategies
- Apply appropriate benchmark datasets
- Use human evaluation when appropriate
- Implement proper baseline comparisons
- Create effective error analysis procedures
- Apply appropriate ablation studies
- Use statistical significance testing
- Implement proper model interpretability techniques
- Create appropriate test sets for real-world performance
