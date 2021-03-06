# Massively-Parallel Video Encoding Using `gg`

[ExCamera](https://www.usenix.org/conference/nsdi17/technical-sessions/presentation/fouladi)
[project](http://github.com/excamera) has used functions-as-a-service
infrastructure to run interdependent video processing tasks with many-way
parallelism. To demonstrate the expressive power of `gg`, we also implemented
this scheme in terms of thunks.

## Prerequisites

1. Follow the instructions to compile and install the latest version of `gg` on
your machine.
2. Clone [this](https://github.com/excamera/excamera-static-bins) repository. It
contains the necessary static binaries.
3. Set `EXCAMERA_BIN_DIR` environment variable to the absolute path to the
repository that you just cloned.

## Encoding video

The input video that you want to compress must be in raw Y4M chunks. The
`Makefile` generator assumes that the file names are 8-digit serial numbers. A
possible directory structure is like this:

```
my-video/
├─ 00000000.y4m
├─ 00000001.y4m
├─ 00000001.y4m
├─ 00000001.y4m
├─ ...
╰─ 00003880.y4m
```

Each file usually contains a few frames, for example 6 frames. For more details
on this, please refer to ExCamera [paper](https://www.usenix.org/conference/nsdi17/technical-sessions/presentation/fouladi).

### Generating the `Makefile`

After the raw, uncompressed video files are ready, the next step is to generate
a `Makefile` for the pipeline. `gen_makefile.py` takes care of that. The command
line usage is:

```
gen_makefile.py <start> <end> <batch-size> <cq-level>
```

Where `<start>` is the first chunk's number (`0` in this example) and `<end>` is
the last chunk's number (`3880` in this example). Batch size is explained in the
paper, but you can set it to `16`. `<cq-level>` is the output quality, ranging
from 0 to 63 (the smaller, the better).

### Executing the pipeline

1. `gg-infer make -j$(nproc)`
2. `gg-force --engine=lambda --status --jobs=100 *.ivf`
