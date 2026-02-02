# Publishing to PyPI

This guide explains how to publish cc-nvd to PyPI.

## Prerequisites

1. Create accounts on:
   - [PyPI](https://pypi.org/account/register/)
   - [Test PyPI](https://test.pypi.org/account/register/)

2. Install required tools:
   ```bash
   pip install build twine
   ```

3. Create `~/.pypirc` with your credentials:
   ```ini
   [distutils]
   index-servers =
       pypi
       testpypi

   [pypi]
   username = __token__
   password = pypi-your-api-token

   [testpypi]
   repository = https://test.pypi.org/legacy/
   username = __token__
   password = pypi-your-test-api-token
   ```

## Building the Package

1. Update the version in `pyproject.toml`:
   ```toml
   [project]
   version = "1.0.1"  # Increment version
   ```

2. Build the package:
   ```bash
   python -m build
   ```

This creates:
- `dist/cc-nvd-1.0.1.tar.gz` (source distribution)
- `dist/cc_nvd-1.0.1-py3-none-any.whl` (wheel)

## Testing with Test PyPI

1. Upload to Test PyPI:
   ```bash
   twine upload --repository testpypi dist/*
   ```

2. Test installation:
   ```bash
   pip install --index-url https://test.pypi.org/simple/ cc-nvd
   ```

## Publishing to PyPI

1. Upload to PyPI:
   ```bash
   twine upload dist/*
   ```

2. Verify installation:
   ```bash
   pip install cc-nvd
   ```

## Automated Publishing with GitHub Actions

Create `.github/workflows/publish.yml`:

```yaml
name: Publish to PyPI

on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.10'

    - name: Install dependencies
      run: |
        pip install build twine

    - name: Build package
      run: python -m build

    - name: Publish to PyPI
      env:
        TWINE_USERNAME: __token__
        TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}
      run: twine upload dist/*
```

## Versioning Strategy

Follow semantic versioning:
- MAJOR version for incompatible API changes
- MINOR version for backward compatible functionality
- PATCH version for backward compatible bug fixes

Update version in:
1. `pyproject.toml`
2. `cc_nvd/__init__.py`
3. Documentation

## Checklist Before Publishing

- [ ] Update version numbers
- [ ] Update CHANGELOG.md
- [ ] Run tests: `pytest`
- [ ] Build package: `python -m build`
- [ ] Test install locally: `pip install dist/cc_nvd-*-py3-none-any.whl`
- [ ] Verify CLI works: `cc-nvd --help`
- [ ] Upload to Test PyPI and test
- [ ] Create GitHub release
- [ ] Publish to PyPI