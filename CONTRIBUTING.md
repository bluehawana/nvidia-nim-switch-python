# Contributing to cc-nvd-python

Thank you for your interest in contributing to cc-nvd-python! This document provides guidelines for contributing to the project.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct (TBD).

## How to Contribute

### Reporting Bugs

- Ensure the bug hasn't already been reported by searching [GitHub Issues](https://github.com/yourusername/cc-nvd-python/issues)
- If you're unable to find an existing issue, [open a new one](https://github.com/yourusername/cc-nvd-python/issues/new)
- Include a clear title and description
- Provide as much relevant information as possible (version, OS, steps to reproduce, etc.)

### Suggesting Enhancements

- Open a new issue with a clear title and description
- Explain why the enhancement would be useful
- Provide examples if possible

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature or bug fix
3. Make your changes
4. Add tests if applicable
5. Ensure all tests pass
6. Update documentation as needed
7. Submit a pull request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/cc-nvd-python.git
cd cc-nvd-python

# Install dependencies
uv sync --frozen

# Run tests
uv run pytest

# Start development server
uv run uvicorn server:app --reload
```

## Coding Standards

- Follow PEP 8 for Python code
- Use type hints where possible
- Write clear, descriptive commit messages
- Keep pull requests focused on a single change
- Add tests for new functionality

## Questions?

Feel free to open an issue or contact the maintainers if you have any questions!