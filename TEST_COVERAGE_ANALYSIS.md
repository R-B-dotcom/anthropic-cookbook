# Test Coverage Analysis

## Current State

The anthropic-cookbook repository contains **28 Python source files** and **45 Jupyter notebooks** across 6 main directories. Test coverage is minimal — only the `skills/text_to_sql/evaluation/tests/` directory has traditional test files.

### Existing Tests

| Location | Files | Framework | Notes |
|----------|-------|-----------|-------|
| `skills/text_to_sql/evaluation/tests/` | 7 test files + 1 utils | Custom (Promptfoo assertions) | Only validates SQL keyword presence, not correctness |

### Evaluation Configs (Not Traditional Tests)

Several directories use **Promptfoo** YAML-based evaluation configs for LLM output evaluation:
- `skills/citations/evaluation/promptfooconfig.yaml`
- `skills/classification/evaluation/promptfooconfig.yaml`
- `skills/retrieval_augmented_generation/evaluation/promptfooconfig_*.yaml`
- `skills/summarization/evaluation/promptfooconfig.yaml`

These evaluate LLM responses against datasets but don't test the Python utility code itself.

### Infrastructure Gaps

- No `pytest.ini`, `pyproject.toml`, or `setup.cfg` with test configuration
- No `conftest.py` fixtures
- No `requirements-test.txt` or test dependencies declared
- No CI/CD workflows (`.github/workflows/`)
- No code coverage tooling

---

## Proposed Test Improvements

### Priority 1: Unit Tests for Evaluation Utility Functions

These files contain pure logic that is easily testable without external dependencies:

#### 1.1 `skills/text_to_sql/evaluation/tests/utils.py`

The `extract_sql()` and `execute_sql()` functions are used by all text_to_sql tests but have no tests themselves.

**Proposed tests:**
- `extract_sql` correctly extracts SQL from `<sql>...</sql>` tags
- `extract_sql` returns empty string when no tags present
- `extract_sql` handles multiline SQL
- `extract_sql` handles nested angle brackets
- `execute_sql` handles invalid SQL gracefully (currently will raise unhandled exception)

#### 1.2 `skills/summarization/evaluation/custom_evals/bleu_eval.py`

The `nltk_bleu_eval()` and `get_assert()` functions perform BLEU score calculation.

**Proposed tests:**
- `nltk_bleu_eval` returns 1.0 for identical strings
- `nltk_bleu_eval` returns 0.0 for completely unrelated strings
- `nltk_bleu_eval` returns value between 0 and 1 for partial matches
- `get_assert` returns `{"pass": True, ...}` when score >= threshold
- `get_assert` returns `{"pass": False, ...}` when score < threshold
- `get_assert` correctly extracts `ground_truth` from context dict

#### 1.3 `skills/summarization/evaluation/custom_evals/rouge_eval.py`

The `rouge_eval()` and `get_assert()` functions perform ROUGE score calculation.

**Proposed tests:**
- `rouge_eval` returns high score for identical strings
- `rouge_eval` returns low score for unrelated strings
- `rouge_eval` uses all three ROUGE variants (rouge1, rouge2, rougeL)
- `get_assert` pass/fail threshold logic

#### 1.4 `skills/citations/evaluation/transform.py`

The `get_transform()` function extracts citation numbers from text.

**Proposed tests:**
- Extracts number from `[1]`, `[42]`, `[100]`
- Returns `"-1"` when no citation found
- Handles multiple citations (returns first match)
- Handles edge cases like `[]`, `[abc]`

#### 1.5 `skills/classification/evaluation/transform.py`

The `get_transform()` function extracts categories from XML-like tags.

**Proposed tests:**
- Extracts category from `<category>sports</category>`
- Handles whitespace within tags
- Returns raw output on malformed input (no tags)
- Handles empty category tags

---

### Priority 2: Unit Tests for VectorDB Classes

#### 2.1 `skills/retrieval_augmented_generation/evaluation/vectordb.py`

Both `VectorDB` and `SummaryIndexedVectorDB` contain testable logic:

**Proposed tests (with mocked Voyage API):**
- `load_data` skips when already loaded
- `load_data` loads from disk when pickle exists
- `search` uses cache for repeated queries
- `search` raises `ValueError` when no data loaded
- `search` respects `k` and `similarity_threshold` parameters
- `save_db` / `load_db` round-trip preserves data
- `_embed_and_store` batches correctly (128 items per batch)

---

### Priority 3: Unit Tests for Lambda Function Code

#### 3.1 `skills/contextual-embeddings/contextual-rag-lambda-function/`

This directory contains production-style Lambda code with no tests.

**`s3_adapter.py` proposed tests:**
- `write_output_to_s3` serializes JSON and calls put_object (mock boto3)
- `write_output_to_s3` returns False on ClientError
- `read_from_s3` deserializes JSON response body (mock boto3)
- `read_from_s3` handles ClientError gracefully
- `parse_s3_path` correctly splits `s3://bucket/key/path`
- `parse_s3_path` handles path without `s3://` prefix
- `parse_s3_path` raises ValueError for invalid paths

**`inference_adapter.py` proposed tests:**
- `invoke_model_with_response_stream` yields text from content_block_delta chunks
- `invoke_model_with_response_stream` stops on message_delta with stop_reason
- `invoke_model_with_response_stream` yields None on ClientError

**`lambda_function.py` proposed tests:**
- `lambda_handler` raises ValueError when inputFiles missing
- `lambda_handler` raises ValueError when bucketName missing
- `lambda_handler` processes multiple input files
- `lambda_handler` constructs correct output structure
- `lambda_handler` formats contextual_retrieval_prompt correctly

---

### Priority 4: Integration / Smoke Tests for Existing Text-to-SQL Tests

The current text_to_sql tests only check for keyword presence in generated SQL:

```python
required_elements = ['select', 'from employees', 'join departments', "name = 'engineering'"]
result = all(element in sql.lower() for element in required_elements)
```

**Proposed improvements:**
- Add tests that actually execute the generated SQL against the test database
- Validate result row counts and column types
- Test error handling for invalid/malicious SQL
- Add negative test cases (queries that should NOT match)

---

### Priority 5: Test Infrastructure

#### 5.1 Add `pyproject.toml` with test configuration

```toml
[tool.pytest.ini_options]
testpaths = ["skills"]
python_files = ["test_*.py"]
python_functions = ["test_*"]
```

#### 5.2 Add test dependencies file

A `requirements-test.txt` with:
```
pytest>=7.0
pytest-cov
pytest-mock
moto[s3]  # for AWS mocking
nltk
rouge-score
numpy
```

#### 5.3 Add CI/CD workflow

A `.github/workflows/test.yml` that:
- Runs pytest on push/PR
- Reports coverage
- Validates the evaluation configs parse correctly

#### 5.4 Add `conftest.py` with shared fixtures

Common fixtures for:
- Temporary SQLite databases
- Mocked boto3 clients
- Sample LLM outputs for assertion testing

---

## Coverage Summary

| Module | Current Coverage | Proposed Coverage |
|--------|-----------------|-------------------|
| text_to_sql/tests/utils.py | 0% (untested utility) | ~90% |
| summarization/custom_evals/ | 0% | ~85% |
| citations/transform.py | 0% | ~95% |
| classification/transform.py | 0% | ~95% |
| RAG/vectordb.py | 0% | ~80% |
| contextual-embeddings/ | 0% | ~75% |
| text_to_sql tests (quality) | Low (keyword-only) | Medium (execution-based) |

## Recommended Implementation Order

1. **Quick wins** — Transform functions and BLEU/ROUGE evals (small, pure functions, easy to test)
2. **VectorDB** — Requires mocking but tests critical search/cache logic
3. **Lambda functions** — Requires boto3 mocking but covers production-adjacent code
4. **Infrastructure** — pytest config, CI/CD, coverage reporting
5. **Text-to-SQL quality** — Upgrade existing tests from keyword-matching to execution-based validation
