/*
 * fanic - Fastest ARM NEON Implementation Challenge
 * fanic ColorSpace v1.0 - fastest color space conversion on ARM/NEON
 * fullHD @ 100fps on 800Mhz Coretex-A8
 *
 * Copyright (C) 2013 Jake Lee
 *
 * http://armneon.blogspot.com
 * http://code.google.com/p/fanic
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see http://www.gnu.org/licenses/.
 */


/*
 * Supported formats :
 * To avoid confusion, elements are listed from lower to higher bytes/bits
 *
 * BGRA - Pretty much the standard 32bit RGB format. Also native to most mobile GPUs.
 * BGR565 - The standard/legacy 16bit RGB format, also called RGB565 to your confusion.
 * UYVY - Most commonly used YUV422 format.
 * NV21 - 'THE' YUV420, y planar and uv interleaved. Most common image format for mobile imaging
 *
 */


/*
 * How to use :
 *
 * fanic ColorSpace is OS independent. Just put the assembly file into your project,
 * include this header file where needed, and you can call the functions below as if
 * they were standard C functions.
 *
 * When converting to BGRA format, the initial alpha value can be specified.
 * If you don't know what to do, just put 255.
 *
 * fanic ColorSpace isn't only very very fast, but also quite accurate dealing with
 * the pixels due to the heavy NEON optimizations taken.
 *
 * However, there are certain conditions that have to be met :
 *
 * - EVERY pointer parameter has to point on an address multiple of four (alignment)
 * - When dealing with YUV420 data, height has to be a multiple of two
 * - Every function has its required minimum data size, usually 16 or 32 pixels.
 *
 * Pay attention to the individual function descriptions below
 *
 */


#ifndef FANIC_COLOR_SPACE_H
#define FANIC_COLOR_SPACE_H

void fanicBGRAtoBGR565(void * pDst, void * pSrc, unsigned int size);
// size has to be at least 16, multiple of two

void fanicBGRAtoUYVY_q16(void * pDst, void * pSrc, unsigned int size);
// size has to be at least 16, multiple of two

void fanicBGRAtoYUV420NV21_q16(void * pDstY, void * pDstUV, void * pSrc, unsigned int widh, unsigned int height);
// width has to be at least 16, multiple of four



void fanicBGR565toBGRA(void * pDst, void * pSrc, unsigned int size, unsigned int alpha);
// size has to be at least 16, multiple of two

void fanicBGR565toUYVY_q16(void * pDst, void * pSrc, unsigned int size);
// size has to be at least 16, multiple of two

void fanicBGR565toYUV420NV21_q16(void * pDstY, void * pDstUV, void * pSrc, unsigned int widh, unsigned int height);
// width has to be at least 16, multiple of four



void fanicUYVYtoBGRA_q6(void* pDst, void * pSrc, unsigned int size, unsigned int alpha);
// size has to be at least 16, multiple of two

void fanicUYVYtoBGR565_q6(void* pDst, void * pSrc, unsigned int size);
// size has to be at least 16, multiple of two

void fanicUYVYtoYUV420NV21(void * pDstY, void * pDstUV, void * pSrc, unsigned int width, unsigned int height);
// width has to be at least 32, multiple of four




void fanicYUV420NV21toBGRA_q6(void * pDst, void * pSrcY, void * pSrcUV, unsigned int width, unsigned int height, unsigned int alpha);
// width has to be at least 16, multiple of four

void fanicYUV420NV21toBGR565_q6(void * pDst, void * pSrcY, void * pSrcUV, unsigned int width, unsigned int height);
// width has to be at least 16, multiple of four

void fanicYUV420NV21toUYVY(void * pDst, void * pSrcY, void * pSrcUV, unsigned int width, unsigned int height);
// width has to be at least 32, multiple of four


#endif
