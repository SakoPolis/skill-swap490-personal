#!/usr/bin/env python3
"""Show Cloud API code in the repository and attempt to list deployed functions.

Usage:
  python scripts/show_cloud_api.py scan    # find candidate cloud function files
  python scripts/show_cloud_api.py view <path>  # print file with line numbers
  python scripts/show_cloud_api.py list-deployed  # call firebase/gcloud CLI if available

The script searches common directories (`functions`, `cloud_functions`, `api`, `backend`) and
returns files with extensions .js, .ts, .py, .dart and files that contain common cloud function
signature snippets.
"""

from __future__ import annotations
import argparse
import os
import re
import subprocess
import sys
from typing import List


ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
EXTS = ('.js', '.ts', '.py', '.dart')
DIR_HINTS = ('functions', 'cloud_functions', 'api', 'backend')
SNIPPETS = [
    r"functions\.https\.onRequest",
    r"exports\.",
    r"module\.exports",
    r"onCall\(|onRequest\(|app\.get\(|app\.post\(",
]


def find_candidate_files(root: str = ROOT) -> List[str]:
    matches = []
    for dirpath, dirnames, filenames in os.walk(root):
        # quick prune: only search under directories that include our hints or root itself
        rel = os.path.relpath(dirpath, root)
        parts = rel.split(os.sep)
        if rel != '.' and not any(h in parts for h in DIR_HINTS):
            # still allow top-level files (rel=='.') and continue scanning children
            # but skip branches that are deep and not in hints to speed up
            # we still look at their filenames in case they match snippets
            pass
        for fn in filenames:
            if fn.endswith(EXTS):
                path = os.path.join(dirpath, fn)
                if file_looks_like_function(path):
                    matches.append(os.path.normpath(path))
    return sorted(matches)


def file_looks_like_function(path: str) -> bool:
    try:
        with open(path, 'r', encoding='utf-8') as f:
            sample = f.read(8192)
    except Exception:
        return False
    for pat in SNIPPETS:
        if re.search(pat, sample):
            return True
    # also accept files that live under directories named like our hints
    lower = path.lower()
    if any(f"{os.sep}{h}{os.sep}" in lower for h in DIR_HINTS):
        return True
    return False


def print_file(path: str) -> None:
    if not os.path.isabs(path):
        path = os.path.join(os.getcwd(), path)
    if not os.path.exists(path):
        print(f"File not found: {path}")
        return
    try:
        with open(path, 'r', encoding='utf-8') as f:
            for i, line in enumerate(f, start=1):
                sys.stdout.write(f"{i:4d}: {line}")
    except Exception as e:
        print(f"Error reading file: {e}")


def run_subprocess(cmd: List[str]) -> int:
    try:
        proc = subprocess.run(cmd, check=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        print(proc.stdout)
        return proc.returncode
    except FileNotFoundError:
        print(f"Command not found: {cmd[0]}")
        return 127


def list_deployed_functions() -> None:
    # Try firebase CLI
    print("Attempting to list deployed functions via `firebase functions:list`...")
    rc = run_subprocess(['firebase', 'functions:list'])
    if rc == 127:
        print("Firebase CLI not found, trying gcloud...")
        rc2 = run_subprocess(['gcloud', 'functions', 'list'])
        if rc2 == 127:
            print("Neither `firebase` nor `gcloud` CLIs are available in PATH.")
            print("To view deployed functions, install Firebase CLI (npm i -g firebase-tools) or gcloud SDK.")


def main() -> None:
    parser = argparse.ArgumentParser(description='Show Cloud API code and deployed functions')
    sub = parser.add_subparsers(dest='cmd')

    sub.add_parser('scan', help='Scan repository for candidate cloud function files')
    v = sub.add_parser('view', help='Print a file with line numbers')
    v.add_argument('path', help='Path to file to view')
    sub.add_parser('list-deployed', help='Attempt to list deployed functions using firebase/gcloud CLI')

    args = parser.parse_args()
    if args.cmd == 'scan':
        print(f"Scanning repository root: {ROOT}")
        files = find_candidate_files(ROOT)
        if not files:
            print("No candidate cloud function files found.")
            print("Try running from repo root or adjust DIR_HINTS/EXTS in the script.")
            return
        print(f"Found {len(files)} candidate file(s):")
        for p in files:
            print(f" - {p}")
    elif args.cmd == 'view':
        print_file(args.path)
    elif args.cmd == 'list-deployed':
        list_deployed_functions()
    else:
        parser.print_help()


if __name__ == '__main__':
    main()
