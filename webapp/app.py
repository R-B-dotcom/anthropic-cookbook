from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from flask import Flask, render_template, request

REPO_ROOT = Path(__file__).resolve().parents[1]
SUPPORTED_EXTENSIONS = {".ipynb", ".md"}
COLLECTION_DIRS = ["skills", "tool_use", "multimodal", "misc", "third_party", "finetuning"]


@dataclass(frozen=True)
class Recipe:
    title: str
    path: str
    category: str
    extension: str


def humanize_title(file_path: Path) -> str:
    stem = file_path.stem.replace("_", " ").replace("-", " ")
    return " ".join(word.capitalize() for word in stem.split())


def discover_recipes() -> list[Recipe]:
    recipes: list[Recipe] = []

    for top_dir in COLLECTION_DIRS:
        base = REPO_ROOT / top_dir
        if not base.exists():
            continue

        for file_path in base.rglob("*"):
            if file_path.suffix not in SUPPORTED_EXTENSIONS or not file_path.is_file():
                continue

            relative = file_path.relative_to(REPO_ROOT)
            category = relative.parts[0]
            recipes.append(
                Recipe(
                    title=humanize_title(file_path),
                    path=str(relative),
                    category=category,
                    extension=file_path.suffix.lstrip(".").upper(),
                )
            )

    recipes.sort(key=lambda item: (item.category.lower(), item.title.lower()))
    return recipes


def filter_recipes(
    recipes: Iterable[Recipe], query: str = "", category: str = "all", extension: str = "all"
) -> list[Recipe]:
    query = query.strip().lower()

    filtered: list[Recipe] = []
    for recipe in recipes:
        if query and query not in f"{recipe.title} {recipe.path}".lower():
            continue
        if category != "all" and recipe.category != category:
            continue
        if extension != "all" and recipe.extension.lower() != extension:
            continue
        filtered.append(recipe)

    return filtered


app = Flask(__name__, template_folder="templates", static_folder="static")
ALL_RECIPES = discover_recipes()


@app.get("/")
def index() -> str:
    query = request.args.get("q", "")
    category = request.args.get("category", "all")
    extension = request.args.get("type", "all").lower()

    recipes = filter_recipes(ALL_RECIPES, query=query, category=category, extension=extension)

    categories = sorted({recipe.category for recipe in ALL_RECIPES})
    types = sorted({recipe.extension.lower() for recipe in ALL_RECIPES})

    return render_template(
        "index.html",
        recipes=recipes,
        total_count=len(ALL_RECIPES),
        query=query,
        categories=categories,
        selected_category=category,
        types=types,
        selected_type=extension,
    )


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=8000)
