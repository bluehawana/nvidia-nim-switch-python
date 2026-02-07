# NVIDIA NIM Model Compatibility

This document lists all tested models and their compatibility status with the NVIDIA NIM Switch.

**Last Updated:** February 04, 2026  
**Total Models Tested:**      182  
**Working Models:**      113  
**Success Rate:** 62.1%

## ✅ Working Models (     113 total)

The following models have been tested and confirmed working:

```
abacusai/dracarys-llama-3.1-70b-instruct
ai21labs/jamba-1.5-mini-instruct
baichuan-inc/baichuan2-13b-chat
bytedance/seed-oss-36b-instruct
deepseek-ai/deepseek-r1-distill-qwen-32b
deepseek-ai/deepseek-r1-distill-qwen-7b
deepseek-ai/deepseek-v3.1
deepseek-ai/deepseek-v3.1-terminus
google/gemma-2-27b-it
google/gemma-2-2b-it
google/gemma-2-9b-it
google/gemma-3-12b-it
google/gemma-3-1b-it
google/gemma-3-27b-it
google/gemma-3n-e2b-it
google/gemma-3n-e4b-it
google/gemma-7b
google/shieldgemma-9b
gotocompany/gemma-2-9b-cpt-sahabatai-instruct
ibm/granite-3.3-8b-instruct
ibm/granite-guardian-3.0-8b
igenius/colosseum_355b_instruct_16k
igenius/italia_10b_instruct_16k
institute-of-science-tokyo/llama-3.1-swallow-70b-instruct-v0.1
institute-of-science-tokyo/llama-3.1-swallow-8b-instruct-v0.1
marin/marin-8b-instruct
mediatek/breeze-7b-instruct
meta/llama-3.1-405b-instruct
meta/llama-3.1-70b-instruct
meta/llama-3.1-8b-instruct
meta/llama-3.2-11b-vision-instruct
meta/llama-3.2-1b-instruct
meta/llama-3.2-3b-instruct
meta/llama-3.2-90b-vision-instruct
meta/llama-3.3-70b-instruct
meta/llama-4-maverick-17b-128e-instruct
meta/llama-4-scout-17b-16e-instruct
meta/llama-guard-4-12b
meta/llama3-70b-instruct
meta/llama3-8b-instruct
microsoft/phi-3-medium-128k-instruct
microsoft/phi-3-medium-4k-instruct
microsoft/phi-3-mini-128k-instruct
microsoft/phi-3-mini-4k-instruct
microsoft/phi-3-small-128k-instruct
microsoft/phi-3-small-8k-instruct
microsoft/phi-3.5-mini-instruct
microsoft/phi-3.5-vision-instruct
microsoft/phi-4-mini-flash-reasoning
minimaxai/minimax-m2
minimaxai/minimax-m2.1
mistralai/devstral-2-123b-instruct-2512
mistralai/magistral-small-2506
mistralai/mamba-codestral-7b-v0.1
mistralai/mathstral-7b-v0.1
mistralai/ministral-14b-instruct-2512
mistralai/mistral-7b-instruct-v0.2
mistralai/mistral-7b-instruct-v0.3
mistralai/mistral-large-3-675b-instruct-2512
mistralai/mistral-medium-3-instruct
mistralai/mistral-nemotron
mistralai/mistral-small-24b-instruct
mistralai/mistral-small-3.1-24b-instruct-2503
mistralai/mixtral-8x22b-instruct-v0.1
mistralai/mixtral-8x7b-instruct-v0.1
moonshotai/kimi-k2-instruct
moonshotai/kimi-k2-instruct-0905
moonshotai/kimi-k2-thinking
moonshotai/kimi-k2.5
nvidia/llama-3.1-nemoguard-8b-content-safety
nvidia/llama-3.1-nemoguard-8b-topic-control
nvidia/llama-3.1-nemotron-70b-reward
nvidia/llama-3.1-nemotron-nano-4b-v1.1
nvidia/llama-3.1-nemotron-nano-8b-v1
nvidia/llama-3.1-nemotron-nano-vl-8b-v1
nvidia/llama-3.1-nemotron-safety-guard-8b-v3
nvidia/llama-3.1-nemotron-ultra-253b-v1
nvidia/llama-3.3-nemotron-super-49b-v1
nvidia/llama-3.3-nemotron-super-49b-v1.5
nvidia/llama3-chatqa-1.5-8b
nvidia/nemotron-4-mini-hindi-4b-instruct
nvidia/nemotron-content-safety-reasoning-4b
nvidia/nemotron-mini-4b-instruct
nvidia/nemotron-nano-12b-v2-vl
nvidia/nvidia-nemotron-nano-9b-v2
nvidia/riva-translate-4b-instruct-v1.1
nvidia/usdcode-llama-3.1-70b-instruct
openai/gpt-oss-120b
openai/gpt-oss-120b
openai/gpt-oss-20b
openai/gpt-oss-20b
opengpt-x/teuken-7b-instruct-commercial-v0.4
qwen/qwen2-7b-instruct
qwen/qwen2.5-7b-instruct
qwen/qwen2.5-coder-32b-instruct
qwen/qwen2.5-coder-7b-instruct
qwen/qwen3-235b-a22b
qwen/qwen3-coder-480b-a35b-instruct
qwen/qwen3-next-80b-a3b-instruct
qwen/qwq-32b
rakuten/rakutenai-7b-chat
rakuten/rakutenai-7b-instruct
sarvamai/sarvam-m
speakleash/bielik-11b-v2.3-instruct
speakleash/bielik-11b-v2.6-instruct
stockmark/stockmark-2-100b-instruct
thudm/chatglm3-6b
tiiuae/falcon3-7b-instruct
tokyotech-llm/llama-3-swallow-70b-instruct-v0.1
upstage/solar-10.7b-instruct
utter-project/eurollm-9b-instruct
yentinglin/llama-3-taiwan-70b-instruct
z-ai/glm4.7
```

## ❌ Non-Working Models (      69 total)

The following models returned errors during testing (may require paid tier or special access):

<details>
<summary>Click to expand failed models list</summary>

```
01-ai/yi-large
adept/fuyu-8b
ai21labs/jamba-1.5-large-instruct
aisingapore/sea-lion-7b-instruct
baai/bge-m3
bigcode/starcoder2-15b
bigcode/starcoder2-7b
databricks/dbrx-instruct
deepseek-ai/deepseek-coder-6.7b-instruct
deepseek-ai/deepseek-r1-distill-llama-8b
deepseek-ai/deepseek-r1-distill-qwen-14b
deepseek-ai/deepseek-v3.2
google/codegemma-1.1-7b
google/codegemma-7b
google/deplot
google/gemma-2b
google/gemma-3-4b-it
google/paligemma
google/recurrentgemma-2b
ibm/granite-3.0-3b-a800m-instruct
ibm/granite-3.0-8b-instruct
ibm/granite-34b-code-instruct
ibm/granite-8b-code-instruct
meta/codellama-70b
meta/llama2-70b
microsoft/kosmos-2
microsoft/phi-3-vision-128k-instruct
microsoft/phi-3.5-moe-instruct
microsoft/phi-4-mini-instruct
microsoft/phi-4-multimodal-instruct
mistralai/codestral-22b-instruct-v0.1
mistralai/mistral-large
mistralai/mistral-large-2-instruct
mistralai/mixtral-8x22b-v0.1
nv-mistralai/mistral-nemo-12b-instruct
nvidia/cosmos-reason2-8b
nvidia/embed-qa-4
nvidia/llama-3.1-nemotron-51b-instruct
nvidia/llama-3.1-nemotron-70b-instruct
nvidia/llama-3.2-nemoretriever-1b-vlm-embed-v1
nvidia/llama-3.2-nemoretriever-300m-embed-v1
nvidia/llama-3.2-nemoretriever-300m-embed-v2
nvidia/llama-3.2-nv-embedqa-1b-v1
nvidia/llama-3.2-nv-embedqa-1b-v2
nvidia/llama3-chatqa-1.5-70b
nvidia/mistral-nemo-minitron-8b-8k-instruct
nvidia/mistral-nemo-minitron-8b-base
nvidia/nemoretriever-parse
nvidia/nemotron-3-nano-30b-a3b
nvidia/nemotron-4-340b-instruct
nvidia/nemotron-4-340b-reward
nvidia/nemotron-nano-3-30b-a3b
nvidia/nemotron-parse
nvidia/neva-22b
nvidia/nv-embed-v1
nvidia/nv-embedcode-7b-v1
nvidia/nv-embedqa-e5-v5
nvidia/nv-embedqa-mistral-7b-v2
nvidia/nvclip
nvidia/riva-translate-4b-instruct
nvidia/streampetr
nvidia/vila
qwen/qwen3-next-80b-a3b-thinking
snowflake/arctic-embed-l
writer/palmyra-creative-122b
writer/palmyra-fin-70b-32k
writer/palmyra-med-70b
writer/palmyra-med-70b-32k
zyphra/zamba2-7b-instruct
```

</details>

## 🔄 Testing Your Own Setup

To test all models on your deployment:

```bash
./scripts/test_all_models.sh http://localhost:8089
```

Or against a remote server:

```bash
./scripts/test_all_models.sh https://your-domain.com
```

---

**Note:** Model availability depends on your NVIDIA API key tier. Free tier has limited access.
