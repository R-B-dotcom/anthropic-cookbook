# Anthropic Cookbook Web App

A lightweight Flask app to browse recipes in this repository.

## Quick start

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r webapp/requirements.txt
python webapp/app.py
```

Then open http://localhost:8000.

## Features

- Auto-discovers `.ipynb` and `.md` recipes in key cookbook folders.
- Search by title/path.
- Filter by top-level category and file type.
- Open matching recipes directly in GitHub.
