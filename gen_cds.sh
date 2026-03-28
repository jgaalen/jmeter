#!/bin/bash
# Generate CDS archive for JMeter CLI mode
# Run this after building JMeter to speed up startup by ~10%
set -e
cd "$(dirname "$0")"

# Find Java
JAVA="${JAVA_HOME:-/usr}/bin/java"
if [ ! -x "$JAVA" ]; then
  JAVA=$(which java 2>/dev/null)
fi
if [ ! -x "$JAVA" ]; then
  echo "ERROR: java not found. Set JAVA_HOME or add java to PATH"
  exit 1
fi
echo "Using Java: $JAVA"

# Build classpath from lib/ and lib/ext/ JARs
CP=""
for jar in lib/*.jar lib/ext/*.jar; do
  [ -f "$jar" ] || continue
  [ -n "$CP" ] && CP="$CP:"
  CP="$CP$jar"
done

if [ -z "$CP" ]; then
  echo "ERROR: No JARs found in lib/ - build JMeter first"
  exit 1
fi

# Generate classlist via dry-run
echo "Generating classlist..."
"$JAVA" -Xshare:off -XX:DumpLoadedClassList=classlist_gen.txt -cp "$CP" org.apache.jmeter.NewDriver --version 2>/dev/null || true

# Dump CDS archive
echo "Dumping CDS archive..."
"$JAVA" -Xshare:dump -XX:SharedClassListFile=classlist_gen.txt -XX:SharedArchiveFile=lib/jmeter_cds.jsa -cp "$CP" 2>&1 | tail -5

SIZE=$(ls -lh lib/jmeter_cds.jsa 2>/dev/null | awk '{print $5}')
echo "CDS archive created: lib/jmeter_cds.jsa ($SIZE)"
