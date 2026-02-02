# 🎯 Manual Testing Steps - Do This Now!

## Step 1: Open the Web Interface 🌐

**Open your browser and go to**: http://localhost:8089/

You should see:
- ✅ A header saying "NVIDIA NIM Model Switcher"
- ✅ Current model card showing the active model
- ✅ A search bar
- ✅ A grid of 182 available models
- ✅ Each model has a "Switch to this model" button

**Try this**:
1. Scroll through the models
2. Use the search bar to find "deepseek"
3. Click "Switch to this model" on any model
4. You should see a notification "Model switched successfully"

---

## Step 2: Test Model Switching 🔄

**In your terminal**, run:

```bash
# Go to hongyanab folder
cd ~/Projects/hongyanab

# Check current model
nim-status

# Switch to DeepSeek
nim-switch deepseek-v3.1

# Verify the switch
nim-status
```

**Then refresh your browser** (http://localhost:8089/) and you should see the new model!

---

## Step 3: Start Claude Code from hongyanab 💻

**In your terminal** (from hongyanab folder):

```bash
cd ~/Projects/hongyanab

# Option 1: Use the nim-claude command
nim-claude
```

**OR**

```bash
# Option 2: Manual method
export ANTHROPIC_BASE_URL=http://localhost:8089
claude -dangerously-skip-permissions
```

This will start Claude Code using NVIDIA NIM models!

---

## Step 4: Talk to Claude Code 💬

Once Claude Code starts, try these commands:

```
@claude What model are you using right now?
```

Claude should respond with the NVIDIA NIM model name (not "Claude")!

Try asking:
```
@claude Can you write a simple Python function to add two numbers?
```

---

## Step 5: Switch Models While Using Claude Code 🔄

**Without closing Claude Code**:

1. Open a new terminal window
2. Run: `nim-switch qwen-coder`
3. Go back to Claude Code
4. Ask: `@claude What model are you using now?`

The model should have changed!

---

## Step 6: Use the Web Interface to Switch 🌐

1. Keep Claude Code open
2. Open browser: http://localhost:8089/
3. Search for "llama"
4. Click "Switch to this model" on "meta/llama-3.1-8b-instruct"
5. Go back to Claude Code
6. Ask: `@claude What model are you?`

You should see it's now using Llama!

---

## 🎯 What You Should See

### In Browser (http://localhost:8089/):
```
┌─────────────────────────────────────────┐
│   NVIDIA NIM Model Switcher             │
│                                         │
│   Current Model                         │
│   ┌───────────────────────────────────┐ │
│   │ deepseek-ai/deepseek-v3.1        │ │
│   │ Provider: deepseek-ai            │ │
│   │ Settings: temp=1.0, max=81920    │ │
│   └───────────────────────────────────┘ │
│                                         │
│   Available Models                      │
│   [Search: ___________]                 │
│                                         │
│   ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│   │ Model 1 │ │ Model 2 │ │ Model 3 │ │
│   │ [Switch]│ │ [Switch]│ │ [Switch]│ │
│   └─────────┘ └─────────┘ └─────────┘ │
└─────────────────────────────────────────┘
```

### In Terminal:
```bash
$ nim-status
✅ NVIDIA NIM Proxy is running
📊 Current Model: deepseek-ai/deepseek-v3.1

$ nim-switch qwen-coder
✅ Switched to: qwen/qwen3-coder-480b-a35b-instruct
```

### In Claude Code:
```
You: @claude What model are you?
Claude: I'm running on qwen/qwen3-coder-480b-a35b-instruct
```

---

## 🐛 Troubleshooting

### "Cannot open http://localhost:8089/"
```bash
# Check if server is running
nim-status

# If not running, start it
nim-start
```

### "Claude Code not found"
```bash
# Check if Claude Code is installed
which claude

# If not installed, you need to install Claude Code first
```

### "Model not switching"
```bash
# Check server logs
tail -f ~/Projects/nvidia-nim-switch-python/server_output.log

# Restart server
nim-stop
nim-start
```

---

## ✅ Success Criteria

You've successfully tested when:
- ✅ You can see the web interface in your browser
- ✅ You can click buttons to switch models
- ✅ You can run `nim-switch` from hongyanab folder
- ✅ You can start Claude Code from hongyanab folder
- ✅ Claude Code responds using NVIDIA NIM models
- ✅ You can switch models while Claude Code is running

---

## 📝 Next Steps

After successful testing:
1. ✅ Confirm all features work
2. ✅ Document any issues
3. ✅ Share on LinkedIn
4. ✅ Add screenshots to README

---

**Now go ahead and try these steps!** 🚀
