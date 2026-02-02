"""
CLI module for cc-nvd-python (AI Model Switcher)
"""

import argparse
import subprocess
import sys
import os


def main():
    """Main CLI entry point for cc-nvd-python."""
    parser = argparse.ArgumentParser(
        prog="cc-nvd",
        description="cc-nvd-python (AI Model Switcher) CLI"
    )

    parser.add_argument(
        "command",
        choices=["serve", "test", "demo"],
        help="Command to execute"
    )

    parser.add_argument(
        "--port",
        type=int,
        default=8089,
        help="Port to run the server on (default: 8089)"
    )

    parser.add_argument(
        "--host",
        default="0.0.0.0",
        help="Host to bind the server to (default: 0.0.0.0)"
    )

    args = parser.parse_args()

    if args.command == "serve":
        serve(args.host, args.port)
    elif args.command == "test":
        run_tests()
    elif args.command == "demo":
        run_demo()


def serve(host="0.0.0.0", port=8089):
    """Start the cc-nvd-python server."""
    print(f"🚀 Starting cc-nvd-python server on {host}:{port}")
    print(f"🌍 Web interface: http://localhost:{port}/")
    print(f"📚 API docs: http://localhost:{port}/docs")

    try:
        # Run uvicorn with the server module
        subprocess.run([
            "uvicorn", "server:app",
            "--host", host,
            "--port", str(port)
        ], check=True)
    except subprocess.CalledProcessError as e:
        print(f"❌ Server failed to start: {e}")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\n🛑 Server stopped")
        sys.exit(0)


def run_tests():
    """Run the test suite."""
    print("🧪 Running tests...")
    try:
        subprocess.run(["pytest", "tests/"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"❌ Tests failed: {e}")
        sys.exit(1)
    except FileNotFoundError:
        print("❌ pytest not found. Please install test dependencies.")
        sys.exit(1)


def run_demo():
    """Run the demo script."""
    print("🎮 Running cc-nvd-python demo...")
    try:
        subprocess.run([sys.executable, "demo.py"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"❌ Demo failed: {e}")
        sys.exit(1)
    except FileNotFoundError:
        print("❌ demo.py not found.")
        sys.exit(1)


if __name__ == "__main__":
    main()