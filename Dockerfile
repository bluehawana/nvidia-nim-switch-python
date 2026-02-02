FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN pip install --no-cache-dir uv

# Copy project files
COPY . .

# Install Python dependencies
RUN uv sync --frozen

# Expose port
EXPOSE 8089

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8089/health || exit 1

# Run server
CMD ["uv", "run", "python", "server.py", "--host", "0.0.0.0", "--port", "8089"]
