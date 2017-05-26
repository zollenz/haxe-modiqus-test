<CsoundSynthesizer>

/***********/
/* Options */
/***********/

<CsOptions>
-o dac -+rtaudio=auhal
</CsOptions>
<CsInstruments>

/*********************/
/* Header statements */
/*********************/

sr = 44100
;kr = 4410    
ksmps = 32
nchnls = 2
0dbfs = 1

giSine		ftgen 1, 0, 1024, 10, 1
giTriangle	ftgen 2, 0, 1024, 7, 0, 256, 1, 512, -1, 256, 0
giSawtooth	ftgen 3, 0, 1024, 7, 0, 512, 1, 0, -1, 512, 0
giSquare	ftgen 4, 0, 1024, 7, 1, 512, 1, 0, -1, 512, -1

instr 1

SNAmpChn 	sprintf "%f", p1
SNAmpChn 	strcat SNAmpChn, ".NoteAmplitude"

puts SNAmpChn, 1

kNAmpChn	chnget SNAmpChn
kAmpChn	lineto kNAmpChn, 0.1

prints "kNAmpChn: %f\n", kNAmpChn

asound oscili p4, p5, 1
outs asound * kAmpChn, asound * kAmpChn
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>