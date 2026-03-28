#!/usr/bin/env bash
#
# Build JMeter into the repo-root bin/ and lib/ layout (Gradle createDist).
# After this succeeds, you can run bin/jmeter.sh or package with create_jmeter_archive.sh.
#
# Usage:
#   ./build_jmeter.sh              # compile and sync jars (default)
#   ./build_jmeter.sh --clean      # ./gradlew clean createDist
#   ./build_jmeter.sh --full       # ./gradlew build then createDist (includes tests)
#   ./build_jmeter.sh -- --scan    # extra args passed to Gradle (after --)
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

if [[ ! -x ./gradlew ]]; then
    echo "Error: ./gradlew not found or not executable in ${ROOT}" >&2
    exit 1
fi

CLEAN=0
FULL=0
GRADLE_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            cat <<'EOF'
Build JMeter (Gradle) into repo-root bin/ and lib/ via createDist.

Usage:
  ./build_jmeter.sh              compile and sync jars (default)
  ./build_jmeter.sh --clean      ./gradlew clean createDist
  ./build_jmeter.sh --full       ./gradlew build then createDist (includes tests)
  ./build_jmeter.sh --full --clean   clean, then build, then createDist
  ./build_jmeter.sh -- --scan    extra Gradle args after --

Then: ./bin/jmeter.sh  or  ./create_jmeter_archive.sh
EOF
            exit 0
            ;;
        --clean)
            CLEAN=1
            shift
            ;;
        --full)
            FULL=1
            shift
            ;;
        --)
            shift
            GRADLE_ARGS+=("$@")
            break
            ;;
        *)
            GRADLE_ARGS+=("$1")
            shift
            ;;
    esac
done

if [[ "$(uname -s)" != Darwin ]] && [[ -z "${DISPLAY:-}" ]] && [[ -z "${JAVA_TOOL_OPTIONS:-}" || "${JAVA_TOOL_OPTIONS}" != *headless* ]]; then
    export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS:+${JAVA_TOOL_OPTIONS} }-Djava.awt.headless=true"
fi

if [[ "$FULL" -eq 1 ]]; then
    if [[ "$CLEAN" -eq 1 ]]; then
        echo "Clean + full build (tests)…"
        ./gradlew "${GRADLE_ARGS[@]}" clean build
    else
        echo "Running full build (tests)…"
        ./gradlew "${GRADLE_ARGS[@]}" build
    fi
    echo "Refreshing bin/ and lib/…"
    ./gradlew "${GRADLE_ARGS[@]}" createDist
else
    if [[ "$CLEAN" -eq 1 ]]; then
        ./gradlew "${GRADLE_ARGS[@]}" clean createDist
    else
        ./gradlew "${GRADLE_ARGS[@]}" createDist
    fi
fi

echo "Done. Run JMeter from ${ROOT}/bin/jmeter.sh or archive with ${ROOT}/create_jmeter_archive.sh"
