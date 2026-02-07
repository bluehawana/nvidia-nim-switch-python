# For Non-Developers: Easy Guide

## What Is This?

This tool lets you use AI coding assistants (like Claude Code) **for FREE** using NVIDIA's free API instead of paying for an Anthropic subscription.

**No coding knowledge required!**

---

## Quick Start (3 Steps)

### Step 1: Start the Server
Open Terminal and type:
```bash
nim-start
```

You'll see: ✅ Server started successfully!

### Step 2: Choose Your AI Model
Type:
```bash
nim-web
```

This opens a webpage in your browser. **Just click on any model** to use it!

**Recommended models for beginners:**
- **Llama 3.1 8B** - Fast and good for most tasks ⚡
- **GLM 4.7** - Great for coding 🚀
- **Gemma 2 9B** - Good balance of speed and quality ⚡

**💡 Tip**: Keep this webpage open in a browser tab! You can switch models anytime by clicking on a different one.

### Step 3: Start Coding
Type:
```bash
nim-claude
```

Now you can chat with the AI and ask it to help you code!

---

## How to Switch Models (While Coding)

**Easy Way: Keep the web page open!**

When you ran `nim-web`, it opened a webpage. **Don't close it!** Keep it in a browser tab.

**To switch models:**
1. Switch to your browser tab (the one with http://localhost:8089/)
2. Click on a different model
3. Switch back to Claude Code
4. Your next message will use the new model!

**No need to open a second terminal!** Just switch between browser and Claude Code.

---

**Alternative (If you closed the browser):**

You can also use keyboard shortcuts in your terminal:
- **Mac**: Press `Cmd+T` to open a new tab in Terminal
- **Windows/Linux**: Press `Ctrl+Shift+T` to open a new tab

Then type `nim-web` in the new tab.

---

## Common Questions

### "Which model should I use?"

**For fast responses:**
- Llama 3.1 8B ⚡
- Gemma 2 2B ⚡
- Phi 3.5 Mini ⚡

**For better quality (slower):**
- GLM 4.7 🚀
- MiniMax M2.1 🚀
- Qwen 2.5 14B 🚀

**For complex tasks (slowest):**
- Qwen 2.5 72B 🐢
- Llama 3.1 70B 🐢

### "How do I know which model I'm using?"

When you start `nim-claude`, it shows:
```
📊 Model: meta/llama-3.1-8b-instruct
```

Or open the web interface (`nim-web`) - the current model is highlighted.

### "Can I use this without paying?"

**Yes! 100% free!** You're using NVIDIA's free API. No credit card, no subscription needed.

### "What if a model is too slow?"

Just switch to a faster model:
1. Press `Esc` in Claude Code to cancel the slow request
2. Open new Terminal: `nim-web`
3. Click on a faster model (look for ⚡ icon)
4. Go back to Claude Code and try again

### "Do I need to restart Claude Code when switching models?"

**No!** Just switch the model in the web interface or with `nim-switch`. The next message will automatically use the new model.

---

## All Commands (Cheat Sheet)

```bash
nim-start      # Start the server (do this first!)
nim-stop       # Stop the server
nim-web        # Open web page to switch models (EASIEST!)
nim-switch     # Quick model switch from terminal
nim-claude     # Start coding with AI
nim-status     # Check if server is running
nim-reset      # Fix connection issues
```

---

## Troubleshooting

### "It's stuck and not responding"

The model might be slow. Try this:
1. Press `Esc` in Claude Code
2. Open new Terminal: `nim-web`
3. Switch to a faster model (⚡ icon)
4. Try your message again

### "It says 'Connection Refused'"

The server isn't running. Type:
```bash
nim-start
```

Then try `nim-claude` again.

### "It's asking me to login"

Run this to fix:
```bash
nim-reset
nim-claude
```

---

## Video Tutorial (Coming Soon)

We're working on video tutorials to make this even easier!

---

## Need Help?

- Check the [User Guide](USER_GUIDE.md) for more details
- See [Model Speed Guide](MODEL_SPEED_GUIDE.md) for model recommendations
- Report issues on [GitHub](https://github.com/bluehawana/nvidia-nim-switch-python/issues)

---

## Summary

1. **Start server**: `nim-start`
2. **Choose model**: `nim-web` (click on a model)
3. **Start coding**: `nim-claude`
4. **Switch models anytime**: `nim-web` (no need to restart!)

**That's it! Enjoy free AI coding!** 🎉
