"""
Demo script for cc-nvd-python (AI Model Switcher)
This script demonstrates the key features of cc-nvd-python.
"""

import requests
import time
import webbrowser
import os

def demo_cc_nvd():
    """Demonstrate cc-nvd-python features."""

    base_url = "http://localhost:8089"

    print("🚀 cc-nvd-python Demo Script")
    print("=" * 50)

    # Check if server is running
    try:
        response = requests.get(f"{base_url}/health", timeout=5)
        if response.status_code == 200:
            print("✅ Server is running")
        else:
            print("❌ Server is not responding")
            return
    except requests.exceptions.ConnectionError:
        print("⚠️  Server is not running. Please start with: cc-nvd serve")
        return
    except Exception as e:
        print(f"❌ Error connecting to server: {e}")
        return

    print("\n1. Getting current model...")
    try:
        response = requests.get(f"{base_url}/v1/models/current")
        if response.status_code == 200:
            current_model = response.json()
            print(f"   Current model: {current_model['id']}")
        else:
            print(f"   Error: {response.status_code}")
    except Exception as e:
        print(f"   Error: {e}")

    print("\n2. Listing available models...")
    try:
        response = requests.get(f"{base_url}/v1/models")
        if response.status_code == 200:
            models = response.json()
            print(f"   Found {len(models['data'])} models")
            print("   Some available models:")
            for i, model in enumerate(models['data'][:5]):
                print(f"     {i+1}. {model['id']}")
            if len(models['data']) > 5:
                print(f"     ... and {len(models['data']) - 5} more")
        else:
            print(f"   Error: {response.status_code}")
    except Exception as e:
        print(f"   Error: {e}")

    print("\n3. Opening web interface...")
    try:
        webbrowser.open(base_url)
        print("   Web interface opened in your browser")
        print("   Visit: http://localhost:8089/")
    except Exception as e:
        print(f"   Could not open browser: {e}")
        print("   Visit manually: http://localhost:8089/")

    print("\n4. API Documentation...")
    print("   Visit: http://localhost:8089/docs")

    print("\n" + "=" * 50)
    print("🎉 Demo complete!")
    print("🔄 Try switching models using the web interface or API")

if __name__ == "__main__":
    demo_cc_nvd()