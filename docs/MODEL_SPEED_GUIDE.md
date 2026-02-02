# 🚀 Model Speed Guide

## Understanding Model Performance

Not all AI models are created equal! Some respond in seconds, others take much longer. This guide helps you choose the right model for your needs.

---

## 🎯 Speed Categories

### ⚡ Fast Models (< 10B parameters)
**Response Time**: 1-3 seconds  
**Best For**: Quick tasks, rapid iteration, testing

**Examples**:
- `meta/llama-3.1-8b-instruct` - Very fast, good quality
- `google/gemma-2-9b-it` - Fast and efficient
- `microsoft/phi-3-medium-4k-instruct` - Compact and quick
- `deepseek-ai/deepseek-coder-6.7b-instruct` - Fast coding model

**Use When**:
- ✅ You need quick responses
- ✅ Testing and prototyping
- ✅ Simple questions
- ✅ Code completion
- ✅ Quick translations

---

### 🚀 Medium Models (10B-70B parameters)
**Response Time**: 3-8 seconds  
**Best For**: Balanced performance and quality

**Examples**:
- `meta/llama-3.1-70b-instruct` - Great balance
- `nvidia/llama-3.1-nemotron-70b-instruct` - NVIDIA optimized
- `qwen/qwq-32b-preview` - Good reasoning
- `deepseek-ai/deepseek-r1-distill-qwen-32b` - Reasoning model

**Use When**:
- ✅ You need good quality responses
- ✅ Complex questions
- ✅ Code generation
- ✅ Analysis tasks
- ✅ Balanced speed/quality

---

### 🐢 Slow Models (> 70B parameters)
**Response Time**: 10-30+ seconds  
**Best For**: Maximum quality, complex reasoning

**Examples**:
- `deepseek-ai/deepseek-v3.1` - Excellent reasoning
- `qwen/qwen3-coder-480b-a35b-instruct` - Best coding quality
- `deepseek-ai/deepseek-r1` - Advanced reasoning

**Use When**:
- ✅ You need the best quality
- ✅ Complex reasoning tasks
- ✅ Critical code generation
- ✅ In-depth analysis
- ✅ You can wait for results

---

## 📊 Speed vs Quality Trade-off

```
Fast (⚡)     Medium (🚀)    Slow (🐢)
│              │              │
│              │              │
Speed ████████ ████████████   ████████████████
Quality ████   ████████████   ████████████████
```

---

## 🎯 How to Use Speed Indicators

### In the Web Interface

1. **Sort by Speed**
   - Click "Sort by: Speed"
   - Fastest models appear first
   - Perfect for finding quick models

2. **Filter by Speed**
   - Select "⚡ Fast Only" to see only fast models
   - Select "🚀 Medium+" to see fast and medium models
   - Select "🐢 All Speeds" to see everything

3. **Visual Indicators**
   - Each model shows a speed badge
   - ⚡ = Fast (green)
   - 🚀 = Medium (orange)
   - 🐢 = Slow (red)

4. **Size Badges**
   - Shows parameter count (8B, 70B, etc.)
   - Smaller = Faster
   - Larger = Better quality

---

## 💡 Recommendations by Use Case

### For Coding
```bash
# Fast iteration
nim-switch meta/llama-3.1-8b-instruct

# Balanced
nim-switch nvidia/llama-3.1-nemotron-70b-instruct

# Best quality
nim-switch qwen/qwen3-coder-480b-a35b-instruct
```

### For Reasoning
```bash
# Quick reasoning
nim-switch qwen/qwq-32b-preview

# Best reasoning
nim-switch deepseek-ai/deepseek-v3.1
```

### For General Chat
```bash
# Fast responses
nim-switch meta/llama-3.1-8b-instruct

# Balanced
nim-switch meta/llama-3.1-70b-instruct
```

---

## 🔄 Quick Switching Strategy

### Start Fast, Go Slow When Needed

```bash
# Start with fast model for exploration
nim-switch meta/llama-3.1-8b-instruct

# Switch to medium for better quality
nim-switch nvidia/llama-3.1-nemotron-70b-instruct

# Switch to slow for critical tasks
nim-switch deepseek-ai/deepseek-v3.1
```

---

## 📈 Performance Tips

### 1. Use Fast Models for:
- Initial exploration
- Quick questions
- Testing prompts
- Rapid iteration
- Simple tasks

### 2. Use Medium Models for:
- Production code
- Complex questions
- Analysis
- Most daily tasks

### 3. Use Slow Models for:
- Critical decisions
- Complex reasoning
- Best quality output
- Final production code

---

## 🎯 Real-World Example

### Scenario: Building a Feature

```bash
# Phase 1: Planning (use fast model)
nim-switch meta/llama-3.1-8b-instruct
# Ask: "What's the best approach for this feature?"
# Response time: 2 seconds ⚡

# Phase 2: Implementation (use medium model)
nim-switch nvidia/llama-3.1-nemotron-70b-instruct
# Ask: "Write the implementation"
# Response time: 5 seconds 🚀

# Phase 3: Review (use slow model)
nim-switch deepseek-ai/deepseek-v3.1
# Ask: "Review this code for issues"
# Response time: 15 seconds 🐢
# But highest quality!
```

---

## 🔍 How Speed is Determined

Speed is based on:
1. **Parameter Count** - Fewer parameters = Faster
2. **Architecture** - Some architectures are optimized
3. **Model Type** - Distilled models are faster
4. **NVIDIA Optimization** - Some models are optimized for NIM

---

## ⚙️ Technical Details

### Parameter Counts
- **1B-10B**: ⚡ Fast (1-3 seconds)
- **10B-70B**: 🚀 Medium (3-8 seconds)
- **70B+**: 🐢 Slow (10-30+ seconds)

### Special Cases
- **Distilled models**: Usually faster than base models
- **Quantized models**: Faster with slight quality trade-off
- **NVIDIA optimized**: Faster on NIM infrastructure

---

## 🎉 Summary

- ⚡ **Fast**: Quick responses, good for iteration
- 🚀 **Medium**: Balanced speed and quality
- 🐢 **Slow**: Best quality, worth the wait

**Pro Tip**: Start fast, switch to slow only when you need maximum quality!

---

*Last updated: February 2, 2026*
