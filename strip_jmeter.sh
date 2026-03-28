#!/bin/bash
# Post-build: strip unnecessary JARs for CLI-only JMeter
# Moves unused JARs to _unused/ dirs (recoverable, not deleted)
set -e
cd /bin

mkdir -p lib/_unused lib/ext/_unused

# === Keep ALL 15 sampler JARs in lib/ext/ ===
# Only strip non-sampler ext JARs (none currently, but future-proof)
KEEP_EXT=ApacheJMeter_bolt
