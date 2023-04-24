rem  Batchdatei zum Ausdrucken der gemessenen
rem  Zirkon Spektren :  a 3 F 3 -> z 3 F 3
rem  Spektren sind in den Dateien ZR??.SCR gespeichert
rem  Alle Spektren enthalten vier Screens (  1 kB) = 800 MHz Scanweite
rem  bis auf ZR10.SCR, bei dem es sich um 25 Screens handelt ( 5 GHz )
rem  Vor dem Ausdrucken ist die HERCULES Hardcopy-Routine aufzurufen.
rem
rem  Aufruf der Batchdatei von DOS aus:  z.B.: DISP ZR10
rem
rem  Programmeingaben:  ZR1..ZR9 -> 1, 4
rem                     ZR10     -> 1, 20
rem
hgc full hprint
copy %1.scr mess.tmp
dispzr
