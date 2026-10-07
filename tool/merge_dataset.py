#!/usr/bin/env python3
"""Merge staged recipe batches into the final recipes.json.

Reads every assets/data/_staging/recipes_*.json (each a {"recipes":[...],
"_newIngredients":[...]} object), concatenates the recipes, folds any new
ingredients into ingredients.json (deduped by id), and writes recipes.json.

Run from the project root:  python3 tool/merge_dataset.py
"""
import glob
import json
import os

BASE = "assets/data"
STAGING = f"{BASE}/_staging"


def load(path):
    with open(path) as f:
        return json.load(f)


def main():
    ing_path = f"{BASE}/ingredients.json"
    ingredients_doc = load(ing_path)
    existing_ids = {i["id"] for i in ingredients_doc["ingredients"]}

    all_recipes = []
    new_ingredients = []
    recipe_ids = set()

    files = sorted(glob.glob(f"{STAGING}/recipes_*.json"))
    if not files:
        raise SystemExit("No staged recipe files found in " + STAGING)

    skipped = []
    for path in files:
        doc = load(path)
        batch = doc.get("recipes", [])
        kept = []
        for r in batch:
            if r["id"] in recipe_ids:
                skipped.append(r["id"])  # keep first occurrence, drop dupes
                continue
            recipe_ids.add(r["id"])
            kept.append(r)
        all_recipes.extend(kept)
        for ni in doc.get("_newIngredients", []):
            if ni["id"] not in existing_ids:
                existing_ids.add(ni["id"])
                new_ingredients.append(ni)
        print(f"  {os.path.basename(path)}: {len(batch)} recipes, "
              f"{len(doc.get('_newIngredients', []))} new ingredients")

    # Fold new ingredients into the dictionary.
    if new_ingredients:
        ingredients_doc["ingredients"].extend(new_ingredients)
        with open(ing_path, "w") as f:
            json.dump(ingredients_doc, f, indent=2, ensure_ascii=False)
            f.write("\n")
        print(f"Added {len(new_ingredients)} new ingredients: "
              f"{[n['id'] for n in new_ingredients]}")

    # Write merged recipes.
    out = {"version": 1, "recipes": all_recipes}
    with open(f"{BASE}/recipes.json", "w") as f:
        json.dump(out, f, indent=2, ensure_ascii=False)
        f.write("\n")

    # Report.
    cuisines = {}
    for r in all_recipes:
        cuisines[r["cuisine"]] = cuisines.get(r["cuisine"], 0) + 1
    print(f"\nMerged {len(all_recipes)} recipes -> {BASE}/recipes.json")
    print(f"Total ingredients now: {len(ingredients_doc['ingredients'])}")
    print(f"Cuisine distribution: {dict(sorted(cuisines.items()))}")


if __name__ == "__main__":
    main()
