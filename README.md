# Learning 68k Assembly for the Sega Mega Drive

These programs are the result of following [Big Evil Corporation](https://bigevilcorporation.co.uk/)'s [amazing series on developing for the Mega Drive](https://blog.bigevilcorporation.co.uk/2012/02/28/sega-megadrive-1-getting-started/), with some assistance from René Richard's [68k tutorials repo](https://github.com/db-electronics/68kTutorials).

## Running the Examples

I've been using [asmx](http://xi6.com/projects/asmx/) multi-CPU assembler due to its support for Unix and 68k assembly language. You'll need to compile it from source, but this is achievable with GCC. **Note** that you'll need to grab version 2.0 beta 5, as this is the only version to support end-to-end binary output, rather than merely providing object code.

To assemble the hello world example:

```sh
$ cd helloworld
$ asmx -e -b -C 68k main.asm
```

The produced binary (`main.asm.bin`) can be loaded by any emulator or even run on real hardware. I'm using [BlastEm](https://www.retrodev.com/blastem/) due to its 64-bit Linux support and debugging tools.