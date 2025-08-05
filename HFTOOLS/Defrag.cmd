@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
REM --------------------------------------------------------------------
REM Utility to defragment INIs and INFs.
REM Author: Mimo
REM Version: 1.0
REM WWW: http://mimo.zxq.net
REM Known problems: Unicode files are not supported

REM Mostly cosmetic edits made by ultra_code (or just ultra :) )
REM -------------------------------------------------------------------------

REM -------------------------------------------------------------------------
REM Function: DfrgInf - Defragments an INF/INI/SIF-file or any other file 
REM           with this layout.
REM Parameters:
REM   %1 - Path and name of the INF-file (*.IN_)
REM   %2 - 1 = compressed, 0 = uncompressed
REM   %3 - 1 = Unicode, 0 = ANSI
REM -------------------------------------------------------------------------

IF EXIST %~1 (
	REM Copy the original file to a temp folder (eventually decompress it)
	ECHO Defragging %~1
	SET "tmpFolder=~tmpdfrg"
	RD /Q /S !tmpFolder! >NUL 2>&1
	MD !tmpFolder!
	COPY %~1 !tmpFolder! >NUL
	IF "%~2"=="1" (
		EXPAND -R !tmpFolder!\%~n1%~x1 >NUL
		DEL !tmpFolder!\%~n1%~x1 >NUL
	)
	
	REM Step 1: Extract the original *.SIF/*.INF/*.INI in separate files
	REM (one file per section)
	
	FOR /F %%F IN ('DIR /B !tmpFolder!') DO (
		SET "tmpInf=!tmpFolder!\%%F"
		SET "tmpPrefix=!tmpFolder!\~dfrg_"
		SET "section="
		DEL !tmpPrefix!*.tmp >NUL 2>&1
		FOR /F "eol=| delims=|" %%A IN ('TYPE !tmpInf!') DO (
			SET "line=%%A"
			SET "firstChar=!line:~0,1!"
			IF "!firstChar!"=="[" (
				SET "section=!line:[=!"
				SET "section=!section:]=!"
				SET "sectFile=!section!"
				SET "sectFile=!sectFile:/=~!"
				SET "sectFile=!sectFile:\=~!"
				SET "sectFile=!sectFile:"=~!"
				SET "sectFile=!tmpPrefix!!sectFile:?=~!.tmp"
				IF NOT EXIST !sectFile! (
					ECHO !section!:!sectFile!>>!tmpFolder!\Sections
				)
			) ELSE IF NOT "!section!"=="" (
				CMD /A /C ECHO %%A>>!sectFile!
			)
		)
		
		REM Step 2: Combine the section-files to a new complete file
		REM (sections in the original order)
		
		DEL !tmpInf!>NUL
		IF "%~3"=="1" (
			COPY "%~dp0Unicode.txt" !tmpInf! >NUL
		)
		CMD /A /C ECHO/>>!tmpInf!
		FOR /F "tokens=1,2 delims=:" %%S IN ('TYPE !tmpFolder!\Sections') DO (
			CMD /A /C ECHO [%%S]>>!tmpInf!
			IF EXIST %%T (
				COPY !tmpInf!+%%T !tmpInf! >NUL 2>&1
				DEL %%T
			)
			CMD /A /C ECHO/>>!tmpInf!
		)
		DEL !tmpFolder!\Sections>NUL
	)
	REM
	REM Copy the new file to the original location (eventually compress it)
	REM
	IF "%~2"=="1" (
		MAKECAB !tmpInf! /L %~dp1 >NUL
	) ELSE (
		COPY !tmpInf! %~1 >NUL
	)
	RD /Q /S !tmpFolder! >NUL 2>&1
)
