"""Command-line tool to validate and pretty-print YAML"""

import argparse
import sys

from ruamel.yaml import YAML


def parse_args():
    description = (
        "A simple command line interface to validate and pretty-print YAML objects."
    )
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument(
        "infile",
        nargs="?",
        type=argparse.FileType(encoding="utf-8"),
        help="a JSON file to be validated or pretty-printed",
        default=sys.stdin,
    )
    parser.add_argument(
        "outfile",
        nargs="?",
        type=argparse.FileType("w", encoding="utf-8"),
        help="write the output of infile to outfile",
        default=sys.stdout,
    )
    return parser.parse_args()


def main():
    options = parse_args()
    yaml = YAML()
    with options.infile as infile, options.outfile as outfile:
        try:
            yaml.dump(yaml.load(infile), outfile)
        except ValueError as ex:
            raise SystemExit from ex


if __name__ == "__main__":
    try:
        main()
    except BrokenPipeError as exc:
        sys.exit(exc.errno)
