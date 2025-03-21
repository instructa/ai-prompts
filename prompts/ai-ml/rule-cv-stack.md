---
description: "Best practices for Computer Vision application development and deployment"
globs: "*.py,*.ipynb,*.h5,*.pb,*.onnx,*.pt,*.pth,*.xml,requirements.txt,setup.py"
alwaysApply: false
---

# Computer Vision Best Practices

## Key Principles

- Design efficient and effective image processing pipelines
- Implement proper preprocessing techniques for visual data
- Apply appropriate model architectures for vision tasks
- Utilize transfer learning and pretrained models effectively
- Implement robust evaluation methods for vision models
- Create scalable and efficient inference pipelines
- Follow best practices for data augmentation and management

## Image Preprocessing

- Implement proper image normalization
- Create effective resizing and scaling procedures
- Apply appropriate color space conversions
- Use efficient data loading for large image datasets
- Implement proper handling of image formats
- Create consistent preprocessing pipelines
- Apply appropriate noise reduction techniques
- Implement proper image enhancement when needed
- Use effective batch processing for images
- Create appropriate image standardization procedures

## Data Augmentation

- Implement effective geometric transformations
- Create proper color augmentations
- Apply appropriate noise injection
- Use cutout/random erasing techniques
- Implement proper mixing augmentations (MixUp, CutMix)
- Create effective augmentation pipelines
- Apply appropriate domain-specific augmentations
- Use augmentation libraries effectively
- Implement proper augmentation probability management
- Create test-time augmentation strategies

## Model Architecture

- Choose appropriate architectures for specific vision tasks
- Implement proper CNN design patterns
- Apply appropriate vision transformer models
- Use effective feature pyramid networks
- Implement proper attention mechanisms
- Create efficient backbone networks
- Apply appropriate neck and head architectures
- Use specialized architectures for detection/segmentation
- Implement transfer learning effectively
- Create custom architectures for domain-specific tasks

## Training Strategies

- Implement proper learning rate scheduling
- Create effective batch size selection
- Apply appropriate optimization algorithms
- Use progressive resizing techniques
- Implement proper regularization methods
- Create effective loss function selection
- Apply appropriate class imbalance handling
- Use proper gradient accumulation when needed
- Implement effective training/validation splits
- Create appropriate mixed precision training

## Transfer Learning

- Use appropriate pretrained models
- Implement proper feature extraction
- Apply effective fine-tuning strategies
- Create domain-specific adaptations
- Use progressive unfreezing techniques
- Implement proper layer-wise learning rates
- Apply appropriate knowledge distillation
- Use model pruning for efficiency
- Implement effective model quantization
- Create custom head architectures for specific tasks

## Object Detection

- Implement proper anchor design
- Create effective non-maximum suppression
- Apply appropriate IoU thresholds
- Use effective confidence thresholds
- Implement proper box regression techniques
- Create appropriate detection evaluation metrics
- Apply effective area-based sampling
- Use appropriate detection architectures
- Implement proper multi-scale detection
- Create effective detection visualization

## Segmentation Techniques

- Implement proper mask generation
- Create effective encoder-decoder architectures
- Apply appropriate boundary refinement
- Use effective post-processing techniques
- Implement proper multi-scale segmentation
- Create appropriate segmentation loss functions
- Apply effective class weighting strategies
- Use appropriate segmentation evaluation metrics
- Implement proper instance versus semantic segmentation
- Create effective segmentation visualization

## Deployment and Inference

- Implement efficient model export
- Create effective model optimization
- Apply appropriate hardware acceleration
- Use proper batch inference techniques
- Implement effective model quantization
- Create appropriate TensorRT/ONNX optimizations
- Apply proper mobile optimization techniques
- Use effective edge deployment strategies
- Implement proper model serving architecture
- Create appropriate latency/throughput optimizations
