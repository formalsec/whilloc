#!/usr/bin/env python3
import os
import sys
import csv
import time
import glob
import json
import argparse
import subprocess

# Globals
MAPPING = {
    "black": 90,
    "red": 91,
    "green": 92,
    "yellow": 93,
    "blue": 94,
    "purple": 95,
    "cyan": 96,
    "white": 97
}

BOLD = "\033[1m"
PREFIX = "\033["
SUFFIX = "\033[0m"

TIME_LIMIT = 60
INST_LIMIT = 10


def progress(msg, curr, total, prev=0):
    status = round((curr / total) * 100)
    color = MAPPING.get("cyan")
    prog_str = f"{BOLD}{PREFIX}{color}m{status:3}%{SUFFIX}"
    sys.stdout.write("\r")
    sys.stdout.write(" " * prev)
    sys.stdout.write("\r")
    sys.stdout.write(f"[{prog_str}] {msg}")
    sys.stdout.flush()
    return len(msg) + 7


def warning(msg, prefix=None):
    if prefix:
        sys.stdout.write(prefix)
    color = MAPPING.get("purple")
    warn_str = f"{BOLD}{PREFIX}{color}mWARN{SUFFIX}"
    sys.stdout.write(f"[{warn_str}] {msg}\n")
    sys.stdout.flush()


def info(msg, prefix=None):
    if prefix:
        sys.stdout.write(prefix)
    color = MAPPING.get("green")
    warn_str = f"{BOLD}{PREFIX}{color}mINFO{SUFFIX}"
    sys.stdout.write(f"[{warn_str}] {msg}\n")
    sys.stdout.flush()


def indent(msg, prefix=None):
    if prefix:
        sys.stdout.write(prefix)
    color = MAPPING.get("white")
    ident_str = f"{BOLD}{PREFIX}{color}m....{SUFFIX}"
    sys.stdout.write(f"[{ident_str}] {msg}\n")
    sys.stdout.flush()

def read_json(f):
    with open(f, "r") as fd:
        return json.load(fd)

def execute_whilloc(test, config, output_dir):

    def _cmd(test, output_dir):
        return ([config["tool"], "-i", test]
                + config["tool_args"]
                + ["-o", output_dir])
    
    print ([config["tool"], "-i", test] + config["tool_args"] + ["-o", output_dir])
    try:
        result = subprocess.run(
            _cmd(test, output_dir),
            timeout=config["time_limit"],
            capture_output=True,
            check=True
        )
    except subprocess.CalledProcessError:
        warning(f"\"{test}\": crashed", prefix="\n")
        return None
    except subprocess.TimeoutExpired:
        warning(f"\"{test}\": timeout", prefix="\n")
        return None

    return result.stdout


def run_test(test, config):
    output_dir = os.path.join(
        config["workspace"],
        os.path.basename(os.path.dirname(test)),
        os.path.basename(test)
    )

    tstart = time.time()
    execute_whilloc(test, config, output_dir)
    tdelta = time.time() - tstart

    report_file = os.path.join(output_dir, "report.json")
    if not os.path.exists(report_file):
        warning(f"File not found \"{report_file}\"!", prefix="\n")
        return []

    report = read_json(report_file)

    return {
        "tint": tdelta,
        "paths": report["paths_explored"],
        "tloop": report["loop_time"],
        "tsolv": report["solver_time"],
    }


def run_tests(dir, config, output_file="results.csv"):
    results, errors = [], []
    tests = glob.glob(os.path.join(dir, "*"))
    for i, d in enumerate(tests):
        prev = 0
        sum_paths, sum_tint, sum_tloop, sum_tsolv = 0, 0.0, 0.0, 0.0
        info(f"Running tests in \"{d}\"...", prefix="\n" if i > 0 else "")
        tests = glob.glob(os.path.join(d, "*"))
        for i, test in enumerate(tests):
            prev = progress(f"Running \"{test}\"...", i+1, len(tests), prev=prev)

            result = run_test(test, config)
            if result == []:
                continue

            sum_tint += result["tint"]
            sum_paths += result["paths"]
            sum_tloop += float(result["tloop"])
            sum_tsolv += float(result["tsolv"])

        results.append([
            os.path.basename(d),
            len(tests),
            round(sum_paths),
            round(sum_tint, 3),
            round(sum_tloop, 3),
            round(sum_tsolv, 3)
        ])

    if errors:
        warning("Failed tests:", prefix="\n")
        for i, test in enumerate(errors):
            indent(f"{i+1}. \"{test}\"")

    info(f"Finished. Writing results to \"{output_file}\"...",
         prefix="" if errors else "\n")
    with open(output_file, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(['category', 'ni', 'sum-paths', 'Tint', 'Tloop', 'Tsolver'])
        writer.writerows(results)

def get_parser():
    parser = argparse.ArgumentParser(
        prog="./run.py",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument("--config", dest="config", action="store", default=None,
                        help="path to tool configuration")
    return parser


def parse(argv):
    parser = get_parser()
    return parser.parse_args(argv)


def main(argv=None):
    if argv is None:
        argv = sys.argv[1:]
    args = parse(argv)

    if args.config is None or not os.path.exists(args.config):
        warning(f"Please provide a valid configuration file!")
        return 1

    config = read_json(args.config)
    for test_dir in config["test_dirs"]:
        category = os.path.basename(test_dir)
        config_name = os.path.splitext(os.path.basename(args.config))[0]
        output_file = os.path.join("results", f"{config_name}_{category}.csv")
        if not os.path.exists("results"):
            os.makedirs("results")
        info(f"Running \"{category}\" benchmarks...")
        run_tests(test_dir, config,
                    output_file=output_file)

    return 0


if __name__ == "__main__":
    sys.exit(main())
