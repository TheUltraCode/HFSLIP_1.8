@ECHO OFF
REM --------------------------------------------------------------------
REM Brief Descr.: This batch will be called by HFSLIP. It calls the 
REM               defragment-utility for specific files.
REM Author: Mimo
REM Version: 1.0
REM WWW: http://mimo.zxq.net
REM --------------------------------------------------------------------

ECHO Defragmenting files (INFs and INIs):

ECHO - SOURCESS\I386\SYSOC.IN_
CALL "%~dp0Defrag.cmd" SOURCESS\I386\SYSOC.IN_ 1 0

