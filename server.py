"""
cc-nvd-python Server Entry Point

Main entry point that imports the app from the api module.
Run with: uv run uvicorn server:app --host 0.0.0.0 --port 8089
"""

from api.app import app, create_app

__all__ = ["app", "create_app"]


def main():
    """Main entry point for the application."""
    import uvicorn
    import argparse

    parser = argparse.ArgumentParser(description="cc-nvd-python server")
    parser.add_argument("--host", default="0.0.0.0", help="Host to bind to")
    parser.add_argument("--port", type=int, default=8089, help="Port to bind to (default: 8089)")
    parser.add_argument("--log-level", default="info", help="Log level")

    args = parser.parse_args()

    uvicorn.run(app, host=args.host, port=args.port, log_level=args.log_level)


if __name__ == "__main__":
    main()