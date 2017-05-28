#!/bin/bash -e

BIN=.gg/exe/bin
PATH=`pwd`/$BIN:$PATH
MAGIC="##GGTHUNK##"

# Run with GCC
$BIN/x86_64-linux-musl-gcc -g -O2 -c -S -frandom-seed=winstein -o remake.s.gold $DATADIR/examples/remake.i

# Create thunk
GG_DIR=.gg/ ../models/gg-model-compile -g -O2 -c -S -frandom-seed=winstein -o remake.s $DATADIR/examples/remake.i


# Assert it's a thunk
if [ $MAGIC != `head -c 11 remake.s` ]; then
  echo "Failed to create thunk"
  exit 1
fi


# execute thunk
../frontend/gg-execute remake.s


# check difference
diff remake.s remake.s.gold


# Clean up
# Note: Not cleaning up .gg directory
rm -f remake.s.gold
rm -f remake.s
find .gg -maxdepth 1 -type f -delete

exit 0