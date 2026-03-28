#!/bin/bash
# Post-build script: strip unnecessary JARs for CLI-only JMeter
set -e
cd "$(dirname "$0")"
mkdir -p lib/_unused lib/ext/_unused bin/_unused
KEEP_EXT="ApacheJMeter_core ApacheJMeter_functions ApacheJMeter_http ApacheJMeter_components ApacheJMeter_java"
for jar in lib/ext/ApacheJMeter_*.jar; do
  [ -f "$jar" ] || continue
  name=$(basename "$jar" .jar)
  keep=false
  for k in $KEEP_EXT; do [ "$name" = "$k" ] && keep=true; done
  $keep || mv "$jar" lib/ext/_unused/ 2>/dev/null || true
done
KEEP_LIB="bsh caffeine commons-jexl commons-lang3 commons-io commons-codec commons-logging dnsjava groovy-jsr223 httpclient httpcore httpmime jackson javax.activation jorphan jspecify json-path json-smart accessors-smart asm jsoup kotlin-stdlib log4j oro rhino slf4j stax2 woodstox xstream"
for jar in lib/*.jar; do
  [ -f "$jar" ] || continue
  name=$(basename "$jar")
  keep=false
  for k in $KEEP_LIB; do case "$name" in ${k}*) keep=true;; esac; done
  $keep || mv "$jar" lib/_unused/ 2>/dev/null || true
done
echo "Strip complete: $(ls lib/*.jar lib/ext/*.jar 2>/dev/null | wc -l) active JARs"
