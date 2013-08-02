;/*
; * fanic - Fastest ARM NEON Implementation Challenge
; * fanic ColorSpace v1.0 - fastest color space conversion on ARM/NEON
; * fullHD @ 100fps on 800Mhz Coretex-A8
; *
; * Copyright (C) 2013 Jake Lee
; *
; * http://armneon.blogspot.com
; * http://code.google.com/p/fanic
; *
; * This program is free software: you can redistribute it and/or modify
; * it under the terms of the GNU General Public License as published by
; * the Free Software Foundation, either version 3 of the License, or
; * (at your option) any later version.
; *
; * This program is distributed in the hope that it will be useful,
; * but WITHOUT ANY WARRANTY; without even the implied warranty of
; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; * GNU General Public License for more details.
; *
; * You should have received a copy of the GNU General Public License
; * along with this program.  If not, see http://www.gnu.org/licenses/.
; */

	AREA	fanicColorSpace_neon, CODE, READONLY
	EXPORT	fanicBGR565toUYVY_q16
	EXPORT	fanicBGR565toYUV420NV21_q16
	EXPORT	fanicYUV420NV21toBGR565_q6
	EXPORT	fanicUYVYtoBGR565_q6
	EXPORT	fanicBGRAtoBGR565
	EXPORT	fanicBGR565toBGRA
	EXPORT	fanicUYVYtoBGRA_q6
	EXPORT	fanicYUV420NV21toBGRA_q6
	EXPORT	fanicBGRAtoUYVY_q16
	EXPORT	fanicBGRAtoYUV420NV21_q16
	EXPORT	fanicYUV420NV21toUYVY
	EXPORT	fanicUYVYtoYUV420NV21
	CODE32

fanicBGR565toBGRA	FUNCTION
        PLD      [r1,#0]
        VDUP.8   d27,r3
        PLD      [r1,#0x40]
        VDUP.8   d31,r3
        PLD      [r1,#0x80]
        SUB      r2,r2,#0x10
1
        PLD      [r1,#0xc0]
        VLD2.8   {d24,d26},[r1]!
        VLD2.8   {d28,d30},[r1]!
        VSHL.I8  d25,d26,#5
        VSRI.8   d26,d26,#5
        VSHL.I8  d29,d30,#5
        VSRI.8   d30,d30,#5
        VSRI.8   d25,d24,#3
        VSHL.I8  d24,d24,#3
        VSRI.8   d29,d28,#3
        VSHL.I8  d28,d28,#3
        VSRI.8   d25,d25,#6
        VSRI.8   d24,d24,#5
        VSRI.8   d29,d29,#6
        VSRI.8   d28,d28,#5
        VST4.8   {d24,d25,d26,d27},[r0]!
        VST4.8   {d28,d29,d30,d31},[r0]!
        SUBS     r2,r2,#0x10
        BPL      %b1
        ADDS     r2,r2,#0x10
        BXEQ     lr
        RSB      r2,r2,#0x10
        SUB      r1,r1,r2,LSL #1
        SUB      r0,r0,r2,LSL #2
        MOV      r2,#0
        B        %b1
        ENDFUNC


fanicBGR565toUYVY_q16	FUNCTION
        ADR      r12, bgrcoeff
        VLDM     r12,{d0-d1}
        VPUSH    {d8-d13}
        VMOV.I8  d3,#0x10
        VMOV.I8  d2,#0x80
        SUB      r2,r2,#0x10
1
        PLD      [r1,#0xc0]
        VLD2.8   {d16,d17,d18,d19},[r1]!
        VSHL.I8  d20,d18,#5
        VSHL.I8  d21,d19,#5
        VSRI.8   d18,d18,#5
        VSRI.8   d19,d19,#5
        VSRI.8   d20,d16,#3
        VSRI.8   d21,d17,#3
        VSHL.I8  d16,d16,#3
        VSHL.I8  d17,d17,#3
        VSHR.U8  d20,d20,#2
        VSHR.U8  d21,d21,#2
        VSRI.8   d16,d16,#5
        VSRI.8   d17,d17,#5
        VSHR.U8  d18,d18,#2
        VSHR.U8  d19,d19,#2
        VSHR.U8  d16,d16,#2
        VSHR.U8  d17,d17,#2
        VMOVL.U8 q11,d16
        VMOVL.U8 q12,d17
        VMOVL.U8 q13,d18
        VMOVL.U8 q14,d19
        VMOVL.U8 q15,d20
        VMOVL.U8 q2,d21
        VPADDL.U8 q8,q8
        VPADDL.U8 q9,q9
        VPADDL.U8 q10,q10
        VMULL.U16 q3,d22,d0[2]
        VMULL.U16 q4,d23,d0[2]
        VMULL.U16 q5,d24,d0[2]
        VMULL.U16 q6,d25,d0[2]
        VMLAL.U16 q3,d26,d0[1]
        VMLAL.U16 q4,d27,d0[1]
        VMLAL.U16 q5,d28,d0[1]
        VMLAL.U16 q6,d29,d0[1]
        VMLAL.U16 q3,d30,d0[0]
        VMLAL.U16 q4,d31,d0[0]
        VMLAL.U16 q5,d4,d0[0]
        VMLAL.U16 q6,d5,d0[0]
        VMULL.U16 q11,d16,d0[3]
        VMULL.U16 q12,d17,d0[3]
        VMULL.U16 q13,d18,d0[3]
        VMULL.U16 q14,d19,d0[3]
        VMLSL.U16 q11,d20,d1[3]
        VMLSL.U16 q12,d21,d1[3]
        VMLSL.U16 q13,d20,d1[0]
        VMLSL.U16 q14,d21,d1[0]
        VMLSL.U16 q11,d18,d1[2]
        VMLSL.U16 q12,d19,d1[2]
        VMLSL.U16 q13,d16,d1[1]
        VMLSL.U16 q14,d17,d1[1]
        VRSHRN.I32 d6,q3,#14
        VRSHRN.I32 d7,q4,#14
        VRSHRN.I32 d8,q5,#14
        VRSHRN.I32 d9,q6,#14
        VRSHRN.I32 d10,q11,#16
        VRSHRN.I32 d11,q12,#16
        VRSHRN.I32 d12,q13,#16
        VRSHRN.I32 d13,q14,#16
        VMOVN.I16 d17,q3
        VMOVN.I16 d19,q4
        VMOVN.I16 d16,q5
        VMOVN.I16 d18,q6
        VUZP.8   d17,d19
        VADD.I8  d16,d16,d2
        VADD.I8  d18,d18,d2
        VADD.I8  d17,d17,d3
        VADD.I8  d19,d19,d3
        VST4.8   {d16,d17,d18,d19},[r0]!
        SUBS     r2,r2,#0x10
        BPL      %b1
        ADDS     r2,r2,#0x10
        VPOPEQ   {d8-d13}
        BXEQ     lr
        RSB      r2,r2,#0x10
        SUB      r1,r1,r2,LSL #1
        SUB      r0,r0,r2,LSL #1
        MOV      r2,#0
        B        %b1
        ENDFUNC

fanicBGR565toYUV420NV21_q16	FUNCTION
        ADR      r12,bgrcoeff
        VLDM     r12,{d0-d1}
        LDR      r12,[sp,#0]
        PUSH     {r4,r5,lr}
        VPUSH    {d8-d15}
        ADD      r4,r2,r3,LSL #1
        ADD      r5,r0,r3
        VMOV.I8  q1,#0x80
        VMOV.I8  q2,#0x10
1
        SUB      lr,r3,#0x10
2
        PLD      [r2,#0xc0]
        VLD2.8   {d16,d17,d18,d19},[r2]!
        PLD      [r4,#0xc0]
        VLD2.8   {d22,d23,d24,d25},[r4]!
        VSHL.I8  d20,d18,#5
        VSHL.I8  d21,d19,#5
        VSRI.8   d18,d18,#5
        VSRI.8   d19,d19,#5
        VSRI.8   d20,d16,#3
        VSRI.8   d21,d17,#3
        VSHL.I8  d16,d16,#3
        VSHL.I8  d17,d17,#3
        VSHR.U8  d20,d20,#2
        VSHR.U8  d21,d21,#2
        VSRI.8   d16,d16,#5
        VSRI.8   d17,d17,#5
        VSHR.U8  d18,d18,#2
        VSHR.U8  d19,d19,#2
        VSHR.U8  d16,d16,#2
        VSHR.U8  d17,d17,#2
        VSHL.I8  d26,d24,#5
        VSHL.I8  d27,d25,#5
        VSRI.8   d24,d24,#5
        VSRI.8   d25,d25,#5
        VSRI.8   d26,d22,#3
        VSRI.8   d27,d23,#3
        VSHL.I8  d22,d22,#3
        VSHL.I8  d23,d23,#3
        VSHR.U8  d26,d26,#2
        VSHR.U8  d27,d27,#2
        VSRI.8   d22,d22,#5
        VSRI.8   d23,d23,#5
        VSHR.U8  d24,d24,#2
        VSHR.U8  d25,d25,#2
        VSHR.U8  d22,d22,#2
        VSHR.U8  d23,d23,#2
        VPADDL.U8 q14,q8
        VPADDL.U8 q15,q9
        VPADDL.U8 q3,q10
        VPADAL.U8 q14,q11
        VPADAL.U8 q15,q12
        VPADAL.U8 q3,q13
        VMULL.U16 q4,d28,d0[3]
        VMULL.U16 q5,d29,d0[3]
        VMLSL.U16 q4,d6,d1[3]
        VMLSL.U16 q5,d7,d1[3]
        VMLSL.U16 q4,d30,d1[2]
        VMLSL.U16 q5,d31,d1[2]
        VMULL.U16 q6,d30,d0[3]
        VMLSL.U16 q6,d6,d1[0]
        VMLSL.U16 q6,d28,d1[1]
        VMULL.U16 q7,d31,d0[3]
        VMLSL.U16 q7,d7,d1[0]
        VMLSL.U16 q7,d29,d1[1]
        VMOVL.U8 q14,d16
        VMOVL.U8 q15,d18
        VMOVL.U8 q3,d20
        VMOVL.U8 q8,d17
        VMOVL.U8 q9,d19
        VMOVL.U8 q10,d21
        VSHRN.I32 d8,q4,#16
        VSHRN.I32 d9,q5,#16
        VSHRN.I32 d10,q6,#16
        VSHRN.I32 d11,q7,#16
        VMULL.U16 q6,d28,d0[2]
        VMLAL.U16 q6,d6,d0[1]
        VMLAL.U16 q6,d30,d0[0]
        VMULL.U16 q7,d29,d0[2]
        VMLAL.U16 q7,d7,d0[1]
        VMLAL.U16 q7,d31,d0[0]
        VMULL.U16 q14,d16,d0[2]
        VMLAL.U16 q14,d20,d0[1]
        VMLAL.U16 q14,d18,d0[0]
        VMULL.U16 q15,d17,d0[2]
        VMLAL.U16 q15,d21,d0[1]
        VMLAL.U16 q15,d19,d0[0]
        VRSHRN.I16 d8,q4,#1
        VRSHRN.I16 d9,q5,#1
        VMOVL.U8 q3,d22
        VMOVL.U8 q5,d24
        VMOVL.U8 q8,d26
        VMOVL.U8 q9,d23
        VMOVL.U8 q10,d25
        VMOVL.U8 q11,d27
        VRSHRN.I32 d12,q6,#14
        VRSHRN.I32 d13,q7,#14
        VRSHRN.I32 d14,q14,#14
        VRSHRN.I32 d15,q15,#14
        VMULL.U16 q12,d6,d0[2]
        VMLAL.U16 q12,d16,d0[1]
        VMLAL.U16 q12,d10,d0[0]
        VMULL.U16 q13,d7,d0[2]
        VMLAL.U16 q13,d17,d0[1]
        VMLAL.U16 q13,d11,d0[0]
        VMULL.U16 q14,d18,d0[2]
        VMLAL.U16 q14,d22,d0[1]
        VMLAL.U16 q14,d20,d0[0]
        VMULL.U16 q15,d19,d0[2]
        VMLAL.U16 q15,d23,d0[1]
        VMLAL.U16 q15,d21,d0[0]
        VMOVN.I16 d12,q6
        VMOVN.I16 d13,q7
        VRSHRN.I32 d24,q12,#14
        VRSHRN.I32 d25,q13,#14
        VRSHRN.I32 d26,q14,#14
        VRSHRN.I32 d27,q15,#14
        VADD.I8  q4,q4,q1
        VADD.I8  q6,q6,q2
        VMOVN.I16 d24,q12
        VMOVN.I16 d25,q13
        VADD.I8  q12,q12,q2
        SUBS     lr,lr,#0x10
        VST2.8   {d8,d9},[r1]!
        VST1.8   {d12,d13},[r0]!
        VST1.8   {d24,d25},[r5]!
        BPL      %b2
        ADDS     lr,lr,#0x10
        BNE      %f3
        SUBS     r12,r12,#2
        MOV      r2,r4
        ADD      r4,r4,r3,LSL #1
        MOV      r0,r5
        ADD      r5,r5,r3
        BGT      %b1
        VPOP     {d8-d15}
        POP      {r4,r5,pc}
3
        RSB      lr,lr,#0x10
        SUB      r2,r2,lr,LSL #1
        SUB      r4,r4,lr,LSL #1
        SUB      r0,r0,lr
        SUB      r5,r5,lr
        SUB      r1,r1,lr
        MOV      lr,#0
        B        %b2
        ENDFUNC

bgrcoeff
        DCD      0x810641CA
        DCD      0xE0C41916
        DCD      0x245ABC6A
        DCD      0x94FD4BC6

fanicBGR565	FUNCTION
        PLD      [r1,#0]
        VMOV.I8  d1,#0x1f
        PLD      [r1,#0x40]
        VMOV.I8  d0,#0x3f
        PLD      [r1,#0x80]
        SUB      r2,r2,#0x10
1
        PLD      [r1,#0xc0]
        VLD4.8   {d24,d25,d26,d27},[r1]!
        VLD4.8   {d28,d29,d30,d31},[r1]!
        VRSHR.U8 d25,d25,#2
        VRSHR.U8 d24,d24,#3
        VRSHR.U8 d26,d26,#3
        VMIN.U8  d25,d25,d0
        VMIN.U8  d20,d24,d1
        VRSHR.U8 d29,d29,#2
        VRSHR.U8 d28,d28,#3
        VRSHR.U8 d30,d30,#3
        VMIN.U8  d29,d29,d0
        VMIN.U8  d22,d28,d1
        VSHL.I8  d27,d25,#2
        VQSHL.U8 d21,d26,#3
        VSHL.I8  d31,d29,#2
        VQSHL.U8 d23,d30,#3
        VSLI.8   d20,d25,#5
        VSRI.8   d21,d27,#5
        VSLI.8   d22,d29,#5
        VSRI.8   d23,d31,#5
        VST2.8   {d20,d21},[r0]!
        VST2.8   {d22,d23},[r0]!
        SUBS     r2,r2,#0x10
        BPL      %b1
        ADDS     r2,r2,#0x10
        BXEQ     lr
        RSB      r2,r2,#0x10
        SUB      r1,r1,r2,LSL #2
        SUB      r0,r0,r2,LSL #1
        MOV      r2,#0
        B        %b1
        ENDFUNC


fanicBGRAtoUYVY_q16	FUNCTION
        ADR      r12,bgrcoeff
        VLDM     r12,{d0-d1}
        VPUSH    {d8-d13}
        VMOV.I8  d3,#0x10
        VMOV.I8  d2,#0x80
        SUB      r2,r2,#0x10
1
        PLD      [r1,#0xc0]
        VLD4.8   {d16,d18,d20,d22},[r1]!
        VLD4.8   {d17,d19,d21,d23},[r1]!
        VMOVL.U8 q11,d16
        VMOVL.U8 q12,d17
        VMOVL.U8 q13,d18
        VMOVL.U8 q14,d19
        VMOVL.U8 q15,d20
        VMOVL.U8 q2,d21
        VPADDL.U8 q8,q8
        VPADDL.U8 q9,q9
        VPADDL.U8 q10,q10
        VMULL.U16 q3,d22,d0[2]
        VMULL.U16 q4,d23,d0[2]
        VMULL.U16 q5,d24,d0[2]
        VMULL.U16 q6,d25,d0[2]
        VMLAL.U16 q3,d26,d0[1]
        VMLAL.U16 q4,d27,d0[1]
        VMLAL.U16 q5,d28,d0[1]
        VMLAL.U16 q6,d29,d0[1]
        VMLAL.U16 q3,d30,d0[0]
        VMLAL.U16 q4,d31,d0[0]
        VMLAL.U16 q5,d4,d0[0]
        VMLAL.U16 q6,d5,d0[0]
        VMULL.U16 q11,d16,d0[3]
        VMULL.U16 q12,d17,d0[3]
        VMULL.U16 q13,d20,d0[3]
        VMULL.U16 q14,d21,d0[3]
        VMLSL.U16 q11,d18,d1[3]
        VMLSL.U16 q12,d19,d1[3]
        VMLSL.U16 q13,d18,d1[0]
        VMLSL.U16 q14,d19,d1[0]
        VMLSL.U16 q11,d20,d1[2]
        VMLSL.U16 q12,d21,d1[2]
        VMLSL.U16 q13,d16,d1[1]
        VMLSL.U16 q14,d17,d1[1]
        VRSHRN.I32 d6,q3,#16
        VRSHRN.I32 d7,q4,#16
        VRSHRN.I32 d8,q5,#16
        VRSHRN.I32 d9,q6,#16
        VSHRN.I32 d10,q11,#16
        VSHRN.I32 d11,q12,#16
        VSHRN.I32 d12,q13,#16
        VSHRN.I32 d13,q14,#16
        VMOVN.I16 d17,q3
        VMOVN.I16 d19,q4
        VRSHRN.I16 d16,q5,#2
        VRSHRN.I16 d18,q6,#2
        VUZP.8   d17,d19
        VADD.I8  d16,d16,d2
        VADD.I8  d18,d18,d2
        VADD.I8  d17,d17,d3
        VADD.I8  d19,d19,d3
        VST4.8   {d16,d17,d18,d19},[r0]!
        SUBS     r2,r2,#0x10
        BPL      %b1
        ADDS     r2,r2,#0x10
        VPOPEQ   {d8-d13}
        BXEQ     lr
        RSB      r2,r2,#0x10
        SUB      r1,r1,r2,LSL #2
        SUB      r0,r0,r2,LSL #1
        MOV      r2,#0
        B        %b1
        ENDFUNC


fanicBGRAtoYUV420NV21_q16	FUNCTION
        ADR      r12,bgrcoeff
        VLDM     r12,{d0-d1}
        LDR      r12,[sp,#0]
        PUSH     {r4,r5,lr}
        VPUSH    {d8-d15}
        ADD      r4,r2,r3,LSL #2
        ADD      r5,r0,r3
        VMOV.I8  q1,#0x80
        VMOV.I8  q2,#0x10
1
        SUB      lr,r3,#0x10
2
        PLD      [r2,#0xc0]
        VLD4.8   {d16,d18,d20,d22},[r2]!
        VLD4.8   {d17,d19,d21,d23},[r2]!
        PLD      [r4,#0xc0]
        VLD4.8   {d22,d24,d26,d28},[r4]!
        VLD4.8   {d23,d25,d27,d29},[r4]!
        VPADDL.U8 q14,q8
        VPADDL.U8 q15,q9
        VPADDL.U8 q3,q10
        VPADAL.U8 q14,q11
        VPADAL.U8 q15,q12
        VPADAL.U8 q3,q13
        VMULL.U16 q4,d28,d0[3]
        VMULL.U16 q5,d29,d0[3]
        VMLSL.U16 q4,d30,d1[3]
        VMLSL.U16 q5,d31,d1[3]
        VMLSL.U16 q4,d6,d1[2]
        VMLSL.U16 q5,d7,d1[2]
        VMULL.U16 q6,d6,d0[3]
        VMLSL.U16 q6,d30,d1[0]
        VMLSL.U16 q6,d28,d1[1]
        VMULL.U16 q7,d7,d0[3]
        VMLSL.U16 q7,d31,d1[0]
        VMLSL.U16 q7,d29,d1[1]
        VMOVL.U8 q14,d16
        VMOVL.U8 q15,d18
        VMOVL.U8 q3,d20
        VMOVL.U8 q8,d17
        VMOVL.U8 q9,d19
        VMOVL.U8 q10,d21
        VSHRN.I32 d8,q4,#16
        VSHRN.I32 d9,q5,#16
        VSHRN.I32 d10,q6,#16
        VSHRN.I32 d11,q7,#16
        VMULL.U16 q6,d28,d0[2]
        VMLAL.U16 q6,d30,d0[1]
        VMLAL.U16 q6,d6,d0[0]
        VMULL.U16 q7,d29,d0[2]
        VMLAL.U16 q7,d31,d0[1]
        VMLAL.U16 q7,d7,d0[0]
        VMULL.U16 q14,d16,d0[2]
        VMLAL.U16 q14,d18,d0[1]
        VMLAL.U16 q14,d20,d0[0]
        VMULL.U16 q15,d17,d0[2]
        VMLAL.U16 q15,d19,d0[1]
        VMLAL.U16 q15,d21,d0[0]
        VRSHRN.I16 d8,q4,#3
        VRSHRN.I16 d9,q5,#3
        VMOVL.U8 q3,d22
        VMOVL.U8 q5,d24
        VMOVL.U8 q8,d26
        VMOVL.U8 q9,d23
        VMOVL.U8 q10,d25
        VMOVL.U8 q11,d27
        VRSHRN.I32 d12,q6,#16
        VRSHRN.I32 d13,q7,#16
        VRSHRN.I32 d14,q14,#16
        VRSHRN.I32 d15,q15,#16
        VMULL.U16 q12,d6,d0[2]
        VMLAL.U16 q12,d10,d0[1]
        VMLAL.U16 q12,d16,d0[0]
        VMULL.U16 q13,d7,d0[2]
        VMLAL.U16 q13,d11,d0[1]
        VMLAL.U16 q13,d17,d0[0]
        VMULL.U16 q14,d18,d0[2]
        VMLAL.U16 q14,d20,d0[1]
        VMLAL.U16 q14,d22,d0[0]
        VMULL.U16 q15,d19,d0[2]
        VMLAL.U16 q15,d21,d0[1]
        VMLAL.U16 q15,d23,d0[0]
        VMOVN.I16 d12,q6
        VMOVN.I16 d13,q7
        VRSHRN.I32 d24,q12,#16
        VRSHRN.I32 d25,q13,#16
        VRSHRN.I32 d26,q14,#16
        VRSHRN.I32 d27,q15,#16
        VADD.I8  q4,q4,q1
        VADD.I8  q6,q6,q2
        VMOVN.I16 d24,q12
        VMOVN.I16 d25,q13
        VADD.I8  q12,q12,q2
        SUBS     lr,lr,#0x10
        VST2.8   {d8,d9},[r1]!
        VST1.8   {d12,d13},[r0]!
        VST1.8   {d24,d25},[r5]!
        BPL      %b2
        ADDS     lr,lr,#0x10
        BNE      %f3
        SUBS     r12,r12,#2
        MOV      r2,r4
        ADD      r4,r4,r3,LSL #2
        MOV      r0,r5
        ADD      r5,r5,r3
        BGT      %b1
        VPOP     {d8-d15}
        POP      {r4,r5,pc}
3
        RSB      lr,lr,#0x10
        SUB      r2,r2,lr,LSL #2
        SUB      r4,r4,lr,LSL #2
        SUB      r0,r0,lr
        SUB      r5,r5,lr
        SUB      r1,r1,lr
        MOV      lr,#0
        B        %b2
        ENDFUNC


fanicUYVYtoBGR565_q6	FUNCTION
        PLD      [r1,#0]
        VMOV.I8  d0,#0x4a
        PLD      [r1,#0x40]
        VMOV.I8  d1,#0x37
        PLD      [r1,#0x80]
        VMOV.I8  d2,#0x19
        SUB      r2,r2,#0x10
        VMOV.I8  d3,#0x34
        VPUSH    {d8-d15}
        VMOV.I8  d4,#0x66
        VMOV.I8  d5,#0x10
        VMOV.I8  d6,#0x80
        PLD      [r1,#0xc0]
        VLD4.8   {d28,d29,d30,d31},[r1]!
        VQSUB.U8 d29,d29,d5
        VQSUB.U8 d31,d31,d5
        VSUB.I8  d28,d28,d6
        VSUB.I8  d30,d30,d6
        VMULL.U8 q12,d29,d0
        VMLAL.S8 q12,d28,d1
        VMLAL.S8 q12,d28,d0
        VMULL.U8 q13,d29,d0
        VMLAL.S8 q13,d28,d1
        VMLAL.S8 q13,d28,d0
1
        VMULL.U8 q10,d29,d0
        VMLSL.S8 q10,d28,d2
        VMLSL.S8 q10,d30,d3
        VMULL.U8 q11,d29,d0
        VMLSL.S8 q11,d28,d2
        VMLSL.S8 q11,d30,d3
        VMULL.U8 q8,d29,d0
        VMLAL.S8 q8,d30,d4
        SUBS     r2,r2,#0x10
        VMULL.U8 q9,d29,d0
        VMLAL.S8 q9,d30,d4
        BMI      %f2
        PLD      [r1,#0xc0]
        VLD4.8   {d28,d29,d30,d31},[r1]!
        VQRSHRUN.S16 d8,q12,#6
        VQRSHRUN.S16 d12,q13,#6
        VQRSHRUN.S16 d9,q10,#6
        VQRSHRUN.S16 d13,q11,#6
        VQRSHRUN.S16 d10,q8,#6
        VQRSHRUN.S16 d14,q9,#6
        VQSUB.U8 d29,d29,d5
        VQSUB.U8 d31,d31,d5
        VSUB.I8  d28,d28,d6
        VSUB.I8  d30,d30,d6
        VZIP.8   d8,d12
        VMULL.U8 q12,d29,d0
        VZIP.8   d9,d13
        VMLAL.S8 q12,d28,d1
        VZIP.8   d10,d14
        VMLAL.S8 q12,d28,d0
        VSRI.8   d10,d9,#5
        VSRI.8   d14,d13,#5
        VSHL.I8  d9,d9,#3
        VSHL.I8  d13,d13,#3
        VSRI.8   d9,d8,#3
        VSRI.8   d13,d12,#3
        VST2.8   {d9,d10},[r0]!
        VMULL.U8 q13,d29,d0
        VMLAL.S8 q13,d28,d1
        VST2.8   {d13,d14},[r0]!
        VMLAL.S8 q13,d28,d0
        B        %b1
2
        ADDS     r2,r2,#0x10
        VQRSHRUN.S16 d8,q12,#6
        VQRSHRUN.S16 d12,q13,#6
        VQRSHRUN.S16 d9,q10,#6
        VQRSHRUN.S16 d13,q11,#6
        VQRSHRUN.S16 d10,q8,#6
        VQRSHRUN.S16 d14,q9,#6
        VZIP.8   d8,d12
        VZIP.8   d9,d13
        VZIP.8   d10,d14
        VSRI.8   d10,d9,#5
        VSRI.8   d14,d13,#5
        VSHL.I8  d9,d9,#3
        VSHL.I8  d13,d13,#3
        VSRI.8   d9,d8,#3
        VSRI.8   d13,d12,#3
        VST2.8   {d9,d10},[r0]!
        VST2.8   {d13,d14},[r0]!
        VPOPEQ   {d8-d15}
        BXEQ     lr
        RSB      r2,r2,#0x10
        SUB      r1,r1,r2,LSL #1
        SUB      r0,r0,r2,LSL #1
        MOV      r2,#0
        B        %b1
        ENDFUNC


fanicUYVYtoBGRA_q6	FUNCTION
        PLD      [r1,#0]
        VMOV.I8  d0,#0x4a
        PLD      [r1,#0x40]
        VMOV.I8  d1,#0x37
        PLD      [r1,#0x80]
        VMOV.I8  d2,#0x19
        SUB      r2,r2,#0x10
        VMOV.I8  d3,#0x34
        VPUSH    {d8-d15}
        VMOV.I8  d4,#0x66
        VMOV.I8  d5,#0x10
        VMOV.I8  d6,#0x80
        VDUP.8   q7,r3
        PLD      [r1,#0xc0]
        VLD4.8   {d28,d29,d30,d31},[r1]!
        VQSUB.U8 d29,d29,d5
        VQSUB.U8 d31,d31,d5
        VSUB.I8  d28,d28,d6
        VSUB.I8  d30,d30,d6
        VMULL.U8 q12,d29,d0
        VMLAL.S8 q12,d28,d1
        VMLAL.S8 q12,d28,d0
        VMULL.U8 q13,d29,d0
        VMLAL.S8 q13,d28,d1
        VMLAL.S8 q13,d28,d0
1
        VMULL.U8 q10,d29,d0
        VMLSL.S8 q10,d28,d2
        VMLSL.S8 q10,d30,d3
        VMULL.U8 q11,d29,d0
        VMLSL.S8 q11,d28,d2
        VMLSL.S8 q11,d30,d3
        VMULL.U8 q8,d29,d0
        VMLAL.S8 q8,d30,d4
        SUBS     r2,r2,#0x10
        VMULL.U8 q9,d29,d0
        VMLAL.S8 q9,d30,d4
        BMI      %f2
        PLD      [r1,#0xc0]
        VLD4.8   {d28,d29,d30,d31},[r1]!
        VQRSHRUN.S16 d8,q12,#6
        VQRSHRUN.S16 d9,q13,#6
        VQRSHRUN.S16 d10,q10,#6
        VQRSHRUN.S16 d11,q11,#6
        VQRSHRUN.S16 d12,q8,#6
        VQRSHRUN.S16 d13,q9,#6
        VQSUB.U8 d29,d29,d5
        VQSUB.U8 d31,d31,d5
        VSUB.I8  d28,d28,d6
        VSUB.I8  d30,d30,d6
        VZIP.8   d8,d9
        VMULL.U8 q12,d29,d0
        VZIP.8   d10,d11
        VMLAL.S8 q12,d28,d1
        VZIP.8   d12,d13
        VMLAL.S8 q12,d28,d0
        VST4.8   {d8,d10,d12,d14},[r0]!
        VMULL.U8 q13,d29,d0
        VMLAL.S8 q13,d28,d1
        VST4.8   {d9,d11,d13,d15},[r0]!
        VMLAL.S8 q13,d28,d0
        B        %b1
2
        ADDS     r2,r2,#0x10
        VQRSHRUN.S16 d8,q12,#6
        VQRSHRUN.S16 d9,q13,#6
        VQRSHRUN.S16 d10,q10,#6
        VQRSHRUN.S16 d11,q11,#6
        VQRSHRUN.S16 d12,q8,#6
        VQRSHRUN.S16 d13,q9,#6
        VZIP.8   d8,d9
        VZIP.8   d10,d11
        VZIP.8   d12,d13
        VST4.8   {d8,d10,d12,d14},[r0]!
        VST4.8   {d9,d11,d13,d15},[r0]!
        VPOPEQ   {d8-d15}
        BXEQ     lr
        RSB      r2,r2,#0x10
        SUB      r1,r1,r2,LSL #1
        SUB      r0,r0,r2,LSL #2
        MOV      r2,#0
        B        %b1
        ENDFUNC


fanicYUV420NV21toBGR565_q6	FUNCTION
        PLD      [r1,#0]
        VMOV.I8  d4,#0x66
        LDR      r12,[sp,#0]
        VMOV.I8  d5,#0x80
        PLD      [r1,r3]
        VMOV.I8  q3,#0x10
        PUSH     {r4-r6,lr}
        VMOV.I8  d0,#0x4a
        PLD      [r2,#0]
        VMOV.I8  d1,#0x37
        ADD      r5,r1,r3
        VMOV.I8  d2,#0x19
        PLD      [r1,#0x40]
        VMOV.I8  d3,#0x34
        VPUSH    {d8-d15}
        PLD      [r5,#0x40]
        ADD      r4,r0,r3,LSL #1
        PLD      [r2,#0x40]
        AND      r6,r3,#0xf
        PLD      [r1,#0x80]
        PLD      [r5,#0x80]
        PLD      [r2,#0x80]
1
        SUB      lr,r3,#0x10
        PLD      [r1,#0xc0]
        VLD2.8   {d20,d21},[r1]!
        PLD      [r2,#0xc0]
        VLD2.8   {d22,d23},[r2]!
        VQSUB.U8 q10,q10,q3
        VSUB.I8  d22,d22,d5
        VSUB.I8  d23,d23,d5
        VMULL.U8 q7,d20,d0
        VMLAL.S8 q7,d22,d1
        VMLAL.S8 q7,d22,d0
        VMULL.U8 q4,d21,d0
        VMLAL.S8 q4,d22,d1
        VMLAL.S8 q4,d22,d0
        VMULL.U8 q8,d20,d0
        VMLSL.S8 q8,d22,d2
        VMLSL.S8 q8,d23,d3
2
        VMULL.U8 q5,d21,d0
        VMLSL.S8 q5,d22,d2
        VMLSL.S8 q5,d23,d3
        VMULL.U8 q9,d20,d0
        VMLAL.S8 q9,d23,d4
        VMULL.U8 q6,d21,d0
        VMLAL.S8 q6,d23,d4
        VQRSHRUN.S16 d24,q7,#6
        VQRSHRUN.S16 d28,q4,#6
        PLD      [r5,#0xc0]
        VLD2.8   {d20,d21},[r5]!
        VQRSHRUN.S16 d25,q8,#6
        VQRSHRUN.S16 d29,q5,#6
        VQSUB.U8 q10,q10,q3
        VQRSHRUN.S16 d26,q9,#6
        VQRSHRUN.S16 d30,q6,#6
        VMULL.U8 q7,d20,d0
        VMLAL.S8 q7,d22,d1
        VMLAL.S8 q7,d22,d0
        VZIP.8   d24,d28
        VMULL.U8 q4,d21,d0
        VZIP.8   d25,d29
        VMLAL.S8 q4,d22,d1
        VZIP.8   d26,d30
        VMLAL.S8 q4,d22,d0
        VMULL.U8 q8,d20,d0
        VSRI.8   d26,d25,#5
        VSRI.8   d30,d29,#5
        VSHL.I8  d25,d25,#3
        VSHL.I8  d29,d29,#3
        VSRI.8   d25,d24,#3
        VSRI.8   d29,d28,#3
        VST2.8   {d25,d26},[r0]!
        VMLSL.S8 q8,d22,d2
        VMLSL.S8 q8,d23,d3
        VST2.8   {d29,d30},[r0]!
        VMULL.U8 q5,d21,d0
        VMLSL.S8 q5,d22,d2
        VMLSL.S8 q5,d23,d3
        VMULL.U8 q9,d20,d0
        VMLAL.S8 q9,d23,d4
        SUBS     lr,lr,#0x10
        VMULL.U8 q6,d21,d0
        VMLAL.S8 q6,d23,d4
        BMI      %f3
        PLD      [r1,#0xc0]
        VLD2.8   {d20,d21},[r1]!
        VQRSHRUN.S16 d24,q7,#6
        VQRSHRUN.S16 d28,q4,#6
        PLD      [r2,#0xc0]
        VLD2.8   {d22,d23},[r2]!
        VQSUB.U8 q10,q10,q3
        VSUB.I8  d22,d22,d5
        VSUB.I8  d23,d23,d5
        VQRSHRUN.S16 d25,q8,#6
        VQRSHRUN.S16 d29,q5,#6
        VQRSHRUN.S16 d26,q9,#6
        VQRSHRUN.S16 d30,q6,#6
        VMULL.U8 q7,d20,d0
        VMLAL.S8 q7,d22,d1
        VMLAL.S8 q7,d22,d0
        VZIP.8   d24,d28
        VMULL.U8 q4,d21,d0
        VZIP.8   d25,d29
        VMLAL.S8 q4,d22,d1
        VZIP.8   d26,d30
        VMLAL.S8 q4,d22,d0
        VSRI.8   d26,d25,#5
        VSRI.8   d30,d29,#5
        VSHL.I8  d25,d25,#3
        VSHL.I8  d29,d29,#3
        VSRI.8   d25,d24,#3
        VSRI.8   d29,d28,#3
        VST2.8   {d25,d26},[r4]!
        VMULL.U8 q8,d20,d0
        VMLSL.S8 q8,d22,d2
        VST2.8   {d29,d30},[r4]!
        VMLSL.S8 q8,d23,d3
        B        %b2
3
        ADDS     lr,lr,#0x10
        PLD      [r5,r3]
        VQRSHRUN.S16 d24,q7,#6
        VQRSHRUN.S16 d28,q4,#6
        VQRSHRUN.S16 d25,q8,#6
        VQRSHRUN.S16 d29,q5,#6
        VQRSHRUN.S16 d26,q9,#6
        VQRSHRUN.S16 d30,q6,#6
        VZIP.8   d24,d28
        VZIP.8   d25,d29
        VZIP.8   d26,d30
        VSRI.8   d26,d25,#5
        VSRI.8   d30,d29,#5
        VSHL.I8  d25,d25,#3
        VSHL.I8  d29,d29,#3
        VSRI.8   d25,d24,#3
        VSRI.8   d29,d28,#3
        VST2.8   {d25,d26},[r4]!
        VST2.8   {d29,d30},[r4]!
        BGT      %f4
        MOV      r1,r5
        ADD      r5,r5,r3
        MOV      r0,r4
        ADD      r4,r4,r3,LSL #1
        SUBS     r12,r12,#2
        PLD      [r5,#0x40]
        PLD      [r5,#0x80]
        BGT      %b1
        VPOP     {d8-d15}
        POP      {r4-r6,pc}
4
        SUB      r1,r1,r6
        SUB      r5,r5,r6
        SUB      r2,r2,r6
        SUB      r0,r0,r6,LSL #1
        SUB      r4,r4,r6,LSL #1
        MOV      lr,#0
        B        %b2
        ENDFUNC


fanicYUV420NV21toBGRA_q6	FUNCTION
        PLD      [r1,#0]
        VMOV.I8  d4,#0x66
        MOV      r12,sp
        VMOV.I8  d5,#0x80
        PLD      [r1,r3]
        VMOV.I8  q3,#0x10
        PUSH     {r4-r6,lr}
        VMOV.I8  d0,#0x4a
        PLD      [r2,#0]
        VMOV.I8  d1,#0x37
        ADD      r5,r1,r3
        VMOV.I8  d2,#0x19
        PLD      [r1,#0x40]
        VMOV.I8  d3,#0x34
        LDM      r12,{r12,lr}
        VPUSH    {d8-d15}
        PLD      [r5,#0x40]
        ADD      r4,r0,r3,LSL #2
        PLD      [r2,#0x40]
        VDUP.8   q15,lr
        AND      r6,r3,#0xf
        PLD      [r1,#0x80]
        PLD      [r5,#0x80]
        PLD      [r2,#0x80]
1
        SUB      lr,r3,#0x10
        PLD      [r1,#0xc0]
        VLD2.8   {d20,d21},[r1]!
        PLD      [r2,#0xc0]
        VLD2.8   {d22,d23},[r2]!
        VQSUB.U8 q10,q10,q3
        VSUB.I8  d22,d22,d5
        VSUB.I8  d23,d23,d5
        VMULL.U8 q7,d20,d0
        VMLAL.S8 q7,d22,d1
        VMLAL.S8 q7,d22,d0
        VMULL.U8 q4,d21,d0
        VMLAL.S8 q4,d22,d1
        VMLAL.S8 q4,d22,d0
        VMULL.U8 q8,d20,d0
        VMLSL.S8 q8,d22,d2
        VMLSL.S8 q8,d23,d3
2
        VMULL.U8 q5,d21,d0
        VMLSL.S8 q5,d22,d2
        VMLSL.S8 q5,d23,d3
        VMULL.U8 q9,d20,d0
        VMLAL.S8 q9,d23,d4
        VMULL.U8 q6,d21,d0
        VMLAL.S8 q6,d23,d4
        VQRSHRUN.S16 d24,q7,#6
        VQRSHRUN.S16 d25,q4,#6
        PLD      [r5,#0xc0]
        VLD2.8   {d20,d21},[r5]!
        VQRSHRUN.S16 d26,q8,#6
        VQRSHRUN.S16 d27,q5,#6
        VQSUB.U8 q10,q10,q3
        VQRSHRUN.S16 d28,q9,#6
        VQRSHRUN.S16 d29,q6,#6
        VMULL.U8 q7,d20,d0
        VMLAL.S8 q7,d22,d1
        VMLAL.S8 q7,d22,d0
        VZIP.8   d24,d25
        VMULL.U8 q4,d21,d0
        VZIP.8   d26,d27
        VMLAL.S8 q4,d22,d1
        VZIP.8   d28,d29
        VMLAL.S8 q4,d22,d0
        VMULL.U8 q8,d20,d0
        VST4.8   {d24,d26,d28,d30},[r0]!
        VMLSL.S8 q8,d22,d2
        VMLSL.S8 q8,d23,d3
        VST4.8   {d25,d27,d29,d31},[r0]!
        VMULL.U8 q5,d21,d0
        VMLSL.S8 q5,d22,d2
        VMLSL.S8 q5,d23,d3
        VMULL.U8 q9,d20,d0
        VMLAL.S8 q9,d23,d4
        SUBS     lr,lr,#0x10
        VMULL.U8 q6,d21,d0
        VMLAL.S8 q6,d23,d4
        BMI      %f3
        PLD      [r1,#0xc0]
        VLD2.8   {d20,d21},[r1]!
        VQRSHRUN.S16 d24,q7,#6
        VQRSHRUN.S16 d25,q4,#6
        PLD      [r2,#0xc0]
        VLD2.8   {d22,d23},[r2]!
        VQSUB.U8 q10,q10,q3
        VSUB.I8  d22,d22,d5
        VSUB.I8  d23,d23,d5
        VQRSHRUN.S16 d26,q8,#6
        VQRSHRUN.S16 d27,q5,#6
        VQRSHRUN.S16 d28,q9,#6
        VQRSHRUN.S16 d29,q6,#6
        VMULL.U8 q7,d20,d0
        VMLAL.S8 q7,d22,d1
        VMLAL.S8 q7,d22,d0
        VZIP.8   d24,d25
        VMULL.U8 q4,d21,d0
        VZIP.8   d26,d27
        VMLAL.S8 q4,d22,d1
        VZIP.8   d28,d29
        VMLAL.S8 q4,d22,d0
        VST4.8   {d24,d26,d28,d30},[r4]!
        VMULL.U8 q8,d20,d0
        VMLSL.S8 q8,d22,d2
        VST4.8   {d25,d27,d29,d31},[r4]!
        VMLSL.S8 q8,d23,d3
        B        %b2
3
        ADDS     lr,lr,#0x10
        PLD      [r5,r3]
        VQRSHRUN.S16 d24,q7,#6
        VQRSHRUN.S16 d25,q4,#6
        VQRSHRUN.S16 d26,q8,#6
        VQRSHRUN.S16 d27,q5,#6
        VQRSHRUN.S16 d28,q9,#6
        VQRSHRUN.S16 d29,q6,#6
        VZIP.8   d24,d25
        VZIP.8   d26,d27
        VZIP.8   d28,d29
        VST4.8   {d24,d26,d28,d30},[r4]!
        VST4.8   {d25,d27,d29,d31},[r4]!
        BGT      %f4
        MOV      r1,r5
        ADD      r5,r5,r3
        MOV      r0,r4
        ADD      r4,r4,r3,LSL #2
        SUBS     r12,r12,#2
        PLD      [r5,#0x40]
        PLD      [r5,#0x80]
        BGT      %b1
        VPOP     {d8-d15}
        POP      {r4-r6,pc}
4
        SUB      r1,r1,r6
        SUB      r5,r5,r6
        SUB      r2,r2,r6
        SUB      r0,r0,r6,LSL #2
        SUB      r4,r4,r6,LSL #2
        MOV      lr,#0
        B        %b2
        ENDFUNC


fanicYUV420NV21toUYVY	FUNCTION
        LDR      r12,[sp,#0]
        PUSH     {r4-r6,lr}
        ADD      r4,r1,r3
        AND      r5,r3,#0x1f
        ADD      r6,r0,r3,LSL #1
        RSB      r5,r5,#0x20
1
        SUB      lr,r3,#0x20
2
        PLD      [r2,#0xc0]
        VLD1.8   {d16,d17,d18,d19},[r2]!
        PLD      [r1,#0xc0]
        VLD1.8   {d20,d21,d22,d23},[r1]!
        PLD      [r4,#0xc0]
        VLD1.8   {d28,d29,d30,d31},[r4]!
        VSWP     q10,q9
        VMOV     q12,q8
        VMOV     q13,q14
        VMOV     q14,q10
        VST2.8   {d16,d17,d18,d19},[r0]!
        VST2.8   {d20,d21,d22,d23},[r0]!
        VST2.8   {d24,d25,d26,d27},[r6]!
        VST2.8   {d28,d29,d30,d31},[r6]!
        SUBS     lr,lr,#0x20
        BPL      %b2
        ADDS     lr,lr,#0x20
        BNE      %f3
        SUBS     r12,r12,#2
        MOV      r1,r4
        ADD      r4,r4,r3
        MOV      r0,r6
        ADD      r6,r6,r3,LSL #1
        BGT      %b1
        POP      {r4-r6,pc}
3
        SUB      r1,r1,r5
        SUB      r4,r4,r5
        SUB      r2,r2,r5
        SUB      r0,r0,r5,LSL #1
        SUB      r6,r6,r5,LSL #1
        MOV      lr,#0
        B        %b2
        ENDFUNC

fanicUYVYtoYUV420NV21	FUNCTION
        LDR      r12,[sp,#0]
        PUSH     {r4-r6,lr}
        AND      r5,r3,#0x1f
        ADD      r6,r2,r3,LSL #1
        ADD      r4,r0,r3
        RSB      r5,r5,#0x20
1
        SUB      lr,r3,#0x20
2
        PLD      [r2,#0xc0]
        VLD2.8   {d0,d1,d2,d3},[r2]!
        VLD2.8   {d4,d5,d6,d7},[r2]!
        PLD      [r6,#0xc0]
        VLD2.8   {d16,d17,d18,d19},[r6]!
        VLD2.8   {d20,d21,d22,d23},[r6]!
        VSWP     q2,q1
        VSWP     q10,q9
        VADDL.U8 q12,d0,d16
        VADDL.U8 q13,d1,d17
        VADDL.U8 q14,d2,d18
        VADDL.U8 q15,d3,d19
        VRSHRN.I16 d24,q12,#1
        VRSHRN.I16 d25,q13,#1
        VRSHRN.I16 d26,q14,#1
        VRSHRN.I16 d27,q15,#1
        VST1.8   {d4,d5,d6,d7},[r0]!
        VST1.8   {d20,d21,d22,d23},[r4]!
        VST1.8   {d24,d25,d26,d27},[r1]!
        SUBS     lr,lr,#0x20
        BPL      %b2
        ADDS     lr,lr,#0x20
        BNE      %f3
        SUBS     r12,r12,#2
        MOV      r2,r6
        ADD      r6,r6,r3,LSL #1
        MOV      r0,r4
        ADD      r4,r4,r3
        BGT      %b1
        POP      {r4-r6,pc}
3
        SUB      r2,r2,r5,LSL #1
        SUB      r6,r6,r5,LSL #1
        SUB      r0,r0,r5
        SUB      r4,r4,r5
        SUB      r1,r1,r5
        MOV      lr,#0
        B        %b2

        ENDFUNC
        END
