# 100 fps fullHD converting

# Introduction #

Introducing fanic Color Space, probably the fastest color space conversion routines for ARM NEON.



# Details #

Supported formats :
  * BGRA - the standard 32bit format, native to most mobile GPUs
  * BGR565 - also called RGB565, the standard/legacy 16bit format
  * YUV422 - UYVY to be precise.
  * YUV420 - NV21, planar Y followed by U and V interleaved

fanic Color Space is capable of converting every format listed above to any of other ones in a single pass, and mostly takes less than 10ms for a fullHD (1920\*1080) image even on aged Coretex-A8 at merely 800Mhz clock rate.