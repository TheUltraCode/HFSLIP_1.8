@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
REM HFSLIP by TommyP
REM Current maintainer - ultra_code (or just ultra :) )
REM Please let me know of typos, issues, errors, regressions from prior versions, or improvements you want to make to this code. :D

REM This script can be ran on Windows NT OSes from 2000 onwards, ALTHOUGH if you do run this on 2000, you will require REG.exe from XP to be
REM placed inside of HFTOOLS at the very least. Frankly, though, I would recommend just running this script under Vista or later (NT6+).

REM A couple of formatting standards I've used:
REM   * All white-space code indentation is done with TABs, not 4 SPACEs, because I believe it's more compatbile with CMD.
REM   * All SETs are surrounded by appropriate double-quotation marks.
REM   * All variables meant to be integer-only use the /A switch prior to the setting of the variable.
REM   * All "local" variables are "deleted" when done with (some other variable types are deleted as well).
REM   * All file extensions are in lower case.
REM   * All commands with switches after them have their switches separated from them by a space (e.g. DIR /B vs DIR/B). Switches themselves can
REM     be joined together however (e.g. DIR /B/A-D).
REM   * CMD commands, batch statements, etc., are for the most part capitalized.
REM   * Parentheses are used when possible with all code blocks, from IFs to FORs; NOTHING is to be left to the programmer to interpret.
REM   * Escapes like "&" that allow for multiple commands on one line are used sparingly.
REM   * Newlines created by ECHOs are done by "ECHO/" (supposedly this causes the least amount of potential issues).
REM   * Variables read from HFANSWER.ini that are supposed to be integers are compared with "==" because I cannot assume 100% of the time they
REM     will be integers. However, integer variables inside of HFSLIP will always be compared with integer-only comparators.
REM   * Comments are ideally supposed to follow normal English grammatical structure (i.e. capitalize letters that should be, periods at the end
REM     of sentences, etc.). Key word is ideally. Some comments I cannot help but feel like I want to leave them the way they are. :P
REM   * Functions are roughly ordered in the order they are called from in "main" (i.e. the *main* part of this script that isn't a function - it
REM     has two subroutine labels in it though for skipping code) or from other functions, and are grouped mostly by category (this is a
REM     subjective matter).

REM Please look for "TODO"s (in caps) throughout this script for things I have questions on, worry about, etc.


REM &@& - any changes made by evgnb that I am wary of.

REM @; - the nearest text piped into HFSLIPWU.inf that evgnb had commented with "::" reverted back to the original ";" from prior versions.

REM *@* - any changes made by evgnb that I have reverted to the implementation in 1.7.10K V9 or 1.7.8 because it results in unsuccessful execution
REM with 2000 + I trust the older implementation better. Sometimes follows @;.

REM todo - any TODO's written by evgnb, distinct from those I have written in capital.

REM Any Russian comments left by evgnb I Google-translated from Russian into English for a rough-idea of what they were trying to convey.

REM Nested IF structures might be necessary because if you chain multiple IF statements together, only the *last* IF statement in a chain evokes
REM the accompanying ELSE statement if false. All prior chained IF statements skip the whole code block.
REM TODO Check to see if there are any other situations like this in this code... nearly 1800 IF statements to check. If you want to suffer, this
REM is the way to help yourself. Only IF code blocks where we *need* an ELSE statement must be corrected.

REM HFSLIP2000 should be (?) some version of 1.7.10 *before* 1.7.10's maintainer(s) decided to make the changes to "HKLM" registry entries.



REM ++++++++++++++++++++++++++++++ Main ++++++++++++++++++++++++++++++



REM ******************** Environment Setup ********************


REM ---------- Some Initial Setup ----------

IF NOT "%1"=="outputset" (
	REM Redirect output to textfile.
	IF EXIST HFANSWER.ini (
		FOR /F "delims=" %%I IN ('FINDSTR /R "OUTPUTFILE=" HFANSWER.ini') DO (SET "%%I")
	)
	IF DEFINED OUTPUTFILE (
		START "" CMD /C %~n0 outputset ^> !OUTPUTFILE! ^2^>^&^1
		EXIT
	)
)

SET "CLS=CLS"
IF DEFINED OUTPUTFILE (
	SET "CLS=CLS 1^>NUL"
	ECHO Writing to !OUTPUTFILE!... >CON
)

SET "T1=TommyP's NT5.X Slipstreamer - HFSLIP"
TITLE %T1%

REM HFSBUILD = YYMMDD
SET /A "HFSBUILD=250803"
SET "HFSVER=1.8"
REM PREP is the directory HFSLIP is running is, the base directory.
SET "PREP=%~dps0"
SET "PREP=%PREP:~0,-1%"
REM To inline, or not to inline...
SET "MCEROLLUP=KB900325"
SET "MCEMP10CUM=KB913800"
SET "SW1=/q /n /z"
SET "SW2=/Q:A /R:N"
IF NOT DEFINED SOURCESS (SET "SOURCESS=%PREP%\SOURCESS")
IF %SOURCESS:~-1%==\ (SET "SOURCESS=%SOURCESS:~0,-1%")
REM Check if SOURCESS is a full path, not just a drive letter.
SET "SOURCESSPATH=!%SOURCESS%"
IF NOT DEFINED SOURCESSPATH (SET "SOURCESS=%PREP%\SOURCESS")
SET "SOURCESSPATH="

REM Read from HFANSWER.ini.
IF EXIST HFANSWER.ini (
	FOR /F "delims=" %%I IN ('FINDSTR /R "=" HFANSWER.ini') DO (SET "%%I")
)

REM ---------- Prompts ----------

ECHO/>CON
ECHO =============================== HFSLIP SUMMARY ================================>CON
ECHO/>CON
ECHO This program integrates Windows Updates into an installable source.            >CON
ECHO/>CON
ECHO Supported updates:                                                             >CON
ECHO/>CON
ECHO/Windows 2000 SP4:                                                              >CON
ECHO     IE6 SP1, DX9, WMP9, MDAC 2.8 SP1, WUA30, security updates                  >CON
ECHO/>CON
ECHO Windows XP SP3:                                                                >CON
ECHO     IE7, IE8, DX9, WMP10/11, WUA30, security updates                           >CON
ECHO/>CON
ECHO Windows Server 2003 SP2:                                                       >CON
ECHO     DX9, WUA30, security updates                                               >CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO ===============================================================================>CON
PAUSE>CON
%CLS%
ECHO/>CON
ECHO =============================== HFSLIP CREDITS ================================>CON
ECHO/>CON
ECHO        MSFN HFSLIP Forum: https://www.msfn.org/board/forum/129-hfslip/         >CON
ECHO                Ultra's GitHub: https://github.com/TheUltraCode                 >CON
ECHO/>CON
ECHO                             Original contributors:                             >CON
ECHO      Thanks to 7yler, antonio_king, Bilou Gateux, boooggy, CEoCEo, fenyo,      >CON
ECHO      Fred Vorck (FDV), Ga$h, EmRoD, ivans2605, Jazkal, Kiki, Kramy, Lupo,      >CON
ECHO       Oleg II, Super-Magician, TAiN, the_guy, Tomcat76, Wendy (os2fan2),       >CON
ECHO      whitehorses, XibaD, Yzöwl, Mim0, Acheron, evgnb, and countless others     >CON
ECHO           for their input and comments, and testing of this script.            >CON
ECHO/>CON
ECHO/>CON
ECHO         Thanks to TommyP for coming up with this script to begin with.         >CON
ECHO              Thanks to Tomcat76 for his support with my endeavor.              >CON
ECHO                                   - ultra                                      >CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO ===============================================================================>CON
PAUSE>CON
%CLS%
REM First option: doesn't need to see HFSLIP layout, folder structure already prepared, defined file compression in HFANSWER.ini,
REM doesn't need to run :AHTESTEXP with either the "HFCLEANUP" or "MAKEISO" parameter, won't use the final SOURCESS
REM files in a multi-boot disc, and thus just start HFSLIP. A nice short-cut perhaps, although not sure when this would be used.

REM Second option: doesn't need to see the HFSLIP layout, does need the folder structure prepared, defined file compression
REM and the paramter for :AHTESTEXP in HFANSWER.ini, and won't use the final SOURCESS files in a multi-boot disc.

REM Third option: default.
IF "%RELEASE%"=="N" (
	CALL :FILECOMP
	GOTO :START
) ELSE IF "%RELEASE%"=="AUTORUN" (
	CALL :FOLDERINIT 1
	CALL :FILECOMP
	CALL :AHTESTEXP
	GOTO :START
) ELSE (
	CALL :FOLDERINIT 0
)

ECHO/>CON
ECHO ================================ HFSLIP LAYOUT ================================>CON
ECHO/>CON
ECHO File and Folder Format:                                                        >CON
ECHO               - HFANSWER.ini (HFSLIP answer file; run-time parameters)         >CON
ECHO FDVFILES      - FDV's fileset                                                  >CON
ECHO HF            - Non-renamed hotfix and critical updates files                  >CON
ECHO HF            - The Service Pack installer                                     >CON
ECHO HFAAO         - Application addons (SVCPACK.inf and SYSOC.inf types)           >CON
ECHO HFCABS        - CAB files: IE6 (Win2K), LegitCheckControl, Flash Player        >CON
ECHO HFCLEANUP     - Reduce your source (at your own risk)                          >CON
ECHO HFGUIRUNONCE  - MSI files and silent EXEs to be installed at 1st GUI logon     >CON
ECHO HFSVCPACK     - Switchless installers (installed at T-13)                      >CON
ECHO HFSVCPACK     - REG files, INF files and CMD files (installed at T-13)         >CON
ECHO HFSVCPACK_SW1 - MSI files (installed at T-13 with /qn /norestart switch)       >CON
ECHO HFSVCPACK_SW1 - EXEs that need a /quiet /norestart switch (installed at T-13)  >CON
ECHO HFSVCPACK_SW2 - EXEs that need a /Q:A /R:N switch (installed at T-13)          >CON
ECHO HFTOOLS       - HFSLIP "tools":                                                >CON
ECHO                  - 7za (compression/decompression)                             >CON
ECHO                  - bbie.exe (boot image extractor)                             >CON
ECHO                  - CMDOW.exe or cWnd.exe (hides DOS box that pops up at T-13)  >CON
ECHO                  - modifyPE.exe or PEChecksum.exe (modifies Windows checksums) >CON
ECHO                  - CDIMAGE.exe or mkisofs.exe (ISO-creation utility)           >CON
ECHO                  - PatchPAE3.exe (mutli-functional tool by evgnb; experimental)>CON
ECHO REPLACE       - To add files to the SOURCESS folder (see instructions)         >CON
ECHO SOURCE        - Dump your installation CD source here including the root files >CON
ECHO/>CON
ECHO ===============================================================================>CON
PAUSE>CON
%CLS%
IF NOT DEFINED AHTEST (
	ECHO/>CON
	ECHO =============================== HFSLIP CHOICES ================================>CON
	ECHO/>CON
	ECHO      IF you wish to either go through with "HFCLEANUP" or "MAKEISO", type      >CON
	ECHO              one of them verbatim, otherwise hit ENTER to contine.             >CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO ===============================================================================>CON
	SET /P "AHTEST="
)
CALL :AHTESTEXP
%CLS%
IF NOT DEFINED DRIVERCOMP (
	ECHO/>CON
	ECHO ============================= HFSLIP COMPRESSION ==============================>CON
	ECHO/>CON
	ECHO What driver compression level do you want?                                     >CON
	ECHO/>CON
	ECHO 1.  Merge into single DRIVER.cab, highest compression:                         >CON
	ECHO     * Slow compress time, fast txtmode copy, slow extract.                     >CON
	ECHO/>CON
	ECHO 2.  Merge into single DRIVER.cab, medium compression:                          >CON
	ECHO     * Moderate compress time, moderate txtmode copy, moderate extract.         >CON
	ECHO/>CON
	ECHO 3.  Merge into single DRIVER.cab, low compression:                             >CON
	ECHO     * Fast compress time, slow txtmode copy, fast extract.                     >CON
	ECHO/>CON
	ECHO 4.  No merge, creates SPX.cab, highest compression:                            >CON
	ECHO     * Slow compress time, fast txtmode copy, slow extract.                     >CON
	ECHO/>CON
	ECHO 5.  No merge, creates SPX.cab, medium compression:                             >CON
	ECHO     * Moderate compress time, moderate txtmode copy, moderate extract.         >CON
	ECHO/>CON
	ECHO 6.  No merge, creates SPX.cab, low compression:                                >CON
	ECHO     * Fast compress time, slow txtmode copy, fast extract.                     >CON
	ECHO/>CON
	ECHO Enter 1, 2, 3, 4, 5 or 6.  Default is 1.                                       >CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO ===============================================================================>CON
	SET /P "DRIVERCOMP="
)
CALL :FILECOMP
%CLS%
IF NOT DEFINED MBOOTPATH IF NOT "%SBOOTPATH%"=="1" (
	ECHO/>CON
	ECHO ============================== HFSLIP MULTI-BOOT ==============================>CON
	ECHO/>CON
	ECHO If you are making a multiboot CD, what folder/pathname will this OS reside in  >CON
	ECHO on your new CD?                                                                >CON
	ECHO/>CON
	ECHO The format to enter is: ^<subfolder^>\                                         >CON
	ECHO/>CON
	ECHO Example: Pro\                                                                  >CON
	ECHO/>CON
	ECHO Note: You must type in the \ at the end if you enter a multiboot path.         >CON
	ECHO/>CON
	ECHO/>CON
	ECHO IMPORTANT^^!                                                                   >CON
	ECHO It is not possible to use the new source made by HFSLIP both in the context    >CON
	ECHO of a CD with a single OS and in the context of a multiboot CD.  It is either   >CON
	ECHO one or the other.                                                              >CON
	ECHO/>CON
	ECHO/>CON
	ECHO Enter your pathname in the format shown above or press ENTER to bypass.        >CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO ===============================================================================>CON
	SET /P "MBOOTPATH="
)
IF DEFINED SBOOTPATH (SET "SBOOTPATH=")
%CLS%
IF EXIST FDVFILES\SFC.dl_ IF EXIST FDVFILES\SFCFILES.dl_ (SET /A "SFCFIX=1")
IF EXIST REPLACE\I386\SFC* (SET /A "SFCFIX=1")
IF EXIST HFEXPERT\APPREPLACEMENT\SFC* (SET /A "SFCFIX=1")
IF EXIST SOURCE\cdromsp5.tst (SET /A "SFCFIX=1")
IF EXIST HF\w2ksp5* (SET /A "SFCFIX=1")

IF DEFINED SFCFIX (
	ECHO/>CON
	ECHO ============================== HFSLIP CAT FILES ===============================>CON
	ECHO/>CON
	ECHO Security catalog files are used to make the System File Protection feature     >CON
	ECHO aware of the fact that a version of one or more files which is different       >CON
	ECHO from the original on the installation CD needs to be installed and that it     >CON
	ECHO should be accepted.                                                            >CON
	ECHO/>CON
	ECHO/>CON
	ECHO A custom version of sfc.dll, sfc_os.dll or sfcfiles.dll or a copy of USP5      >CON
	ECHO disabling System File Protection was detected.  This means that the Catalog    >CON
	ECHO files which come with the hotfixes and application addons you include are      >CON
	ECHO no longer required.  Additionally, removing them may speed up the Windows      >CON
	ECHO installation procedure.                                                        >CON
	ECHO/>CON
	ECHO/>CON
	ECHO Should HFSLIP remove the *.cat files from the SVCPACK folder?                  >CON
	ECHO/>CON
	ECHO/>CON
	ECHO Entering "Y" will delete the *.cat files, otherwise they will be left alone.   >CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO/>CON
	ECHO ===============================================================================>CON
	SET /P THACATS=
	IF /I "%THACATS%"=="Y" (SET /A "DELCATS=1")
	SET "THACATS="
	SET "SFCFIX="
)
%CLS%

:START
REM ******************** Testing Requirements ********************

REM ---------- Groundwork ----------

REM Delete SOURCESS, then recreate enough of it.
IF NOT "%DIAGNOSTIC%"=="1" (
	IF EXIST %SOURCESS% IF /I NOT "%PREP%"=="%SOURCESS%" (RD /Q/S %SOURCESS%)
	MD %SOURCESS%\I386\SVCPACK
)

CALL :CHECKWINVER

REM Patches SOURCE with provided service packs; allows for backup of SOURCE.
CALL :CHECKSOURCE

REM Find host OS - based on code posted by Yzöwl on MSFN.org.
SET "HostOS=Unknown"
FOR /F "delims=" %%I IN ('NET CONFIG WORK^|FIND /I " Windows "') DO (
	ECHO %%I|FIND "2000" >NUL 2>&1 && (
		SET "HostOS=2000"
		GOTO :HOSD
	)
	ECHO %%I|FIND "2002" >NUL 2>&1 && (
		SET "HostOS=XP"
		GOTO :HOSD
	)
	ECHO %%I|FIND "XP" >NUL 2>&1 && (
		SET "HostOS=XP"
		GOTO :HOSD
	)
	ECHO %%I|FIND "2003" >NUL 2>&1 && (
		SET "HostOS=2003"
		GOTO :HOSD
	)
	ECHO %%I|FINDSTR /I "Vista 7 8 8.1 10 11" >NUL 2>&1 && (
		SET "HostOS=Vista"
		GOTO :HOSD
	)
)

REM TODO This bit doesn't quite make sense. If you are on a pre-Vista OS, you *are* usually *the* admin. And on Vista+ OSes, it makes sense *to* run
REM this script without UAC and with admin privileges. Further testing required?
:HOSD
IF NOT "%HostOS%"=="Vista" (
	REGEDIT/S/E ADMIN1.txt "HKEY_USERS\.DEFAULT\Software\Microsoft\NetDDE"
	IF EXIST ADMIN1.txt (
		DEL /Q/F ADMIN1.txt
	) ELSE (
		ECHO/>CON
		ECHO You are advised to run HFSLIP with administrative privileges.>CON
		PAUSE>CON
	)
)

CALL :GETLANG

REM ---------- Dependency Tests ----------

REM 2024/7/27
REM There are parts of the codes that explicitely required the stand-alone 7-zip executable to function since no alternative is provided to complete the task otherwise.
REM Therefore, I will just assume 7za IS in HFTOOLS, and removed other means of doing things wihout 7za.

REM Check for 7za.exe requirement.
IF NOT EXIST HFTOOLS\7za.exe (
	ECHO 7za.exe was not found in the HFTOOLS folder. It is required to extract various files.>CON
	ECHO Please add 7za.exe to your HFTOOLS and re-run HFSLIP.>CON
	ECHO/>CON
	ECHO Press any key to quit.>CON
	PAUSE >NUL
	EXIT
)

REM Check for modifyPE.exe requirement.
IF EXIST HF\IE7*.exe (
	IF "%VERSION%"=="2003" (
		SET /A "MPEREQ=1"
	) ELSE IF "%VERSION%"=="XP" (
		IF NOT DEFINED IE7SVCPACK IF NOT DEFINED IE7GUILOGON IF NOT DEFINED CDTAG (SET /A "MPEREQ=1")
		IF DEFINED IE7SVCPACK (
			SET /A "MPEREQ=1"
		) ELSE IF DEFINED IE7GUILOGON (
			SET /A "MPEREQ=1"
		)
	)
)
IF EXIST HFCABS\OPUC*.cab (SET /A "MPEREQ=1")
IF EXIST HFEXPERT\CODECS (SET /A "MPEREQ=1")
IF EXIST HFEXPERT\APPREPLACEMENT (SET /A "MPEREQ=1")
IF EXIST HFEXPERT\WIN (SET /A "MPEREQ=1")
IF DEFINED MPEREQ (
	IF EXIST HFTOOLS\PECHECKSUM.exe (
		SET "MODIFYPE=HFTOOLS\PECHECKSUM.exe"
	) ELSE (
		IF "%HostOS%"=="Vista" (
			ECHO/>CON
			ECHO HFSLIP has detected that you need PEChecksum.exe for your setup, but this file>CON
			ECHO was not found in the HFTOOLS folder.>CON
			ECHO/>CON
			ECHO Press any key to quit.>CON
			PAUSE>NUL
			EXIT
		) ELSE (
			IF EXIST HFTOOLS\MODIFYPE.exe (
				SET "MODIFYPE=HFTOOLS\MODIFYPE.exe"
			) ELSE (
				ECHO/>CON
				ECHO HFSLIP has detected that you need either modifyPE.exe or PEChecksum.exe>CON
				ECHO for your setup, but neither was found in the HFTOOLS folder.>CON
				ECHO/>CON
				ECHO Press any key to quit.>CON
				PAUSE>NUL
				EXIT
			)
		)
	)
	SET "MPEREQ="
)

REM Check for the wbemoc.cab requirement for XP SP3.
IF "%VERSION%"=="XP" IF %SP% EQU 3 (
	IF EXIST HFCABS\wbemoc.cab (
		CALL :WBEMFIX
	) ELSE (
		ECHO/>CON
		ECHO ERROR:
		ECHO For Windows XP SP3 you need a fix for wbemoc.inf.>CON
		ECHO Please get wbemoc.cab and put it in HFCABS.>CON
		ECHO/>CON
		PAUSE>CON
		EXIT
	)
)

REM ---------- Components ----------

REM *@*
REM 2020-08-07: now we have internal CMDHIDE written in VBS.
REM SET CMDHIDE=CMDHIDE.VBS

REM *@*
REM 2024/7/14
REM Extract wscript.exe from the SOURCE\I386 folder and place it into the SOURCESS\I386\SVCPACK.
REM Uncomment this only if you want to re-implement evgnb's VBSscript implementation, assuming you can make it work, assuming this is what evgnb
REM meant by needing to include this executable in that directory.
REM IF NOT EXIST SOURCESS\I386\SVCPACK\wscript.exe (EXPAND SOURCE\I386\WSCRIPT.ex_ -R SOURCESS\I386\SVCPACK)

IF EXIST HFEXPERT\WIN\SYSTEM32\CMDOW.exe (SET "CMDHIDE=CMDOW @ /HID")
IF EXIST HFTOOLS\CMDOW.exe (
	SET "CMDHIDE=CMDOW @ /HID"
	COPY /Y HFTOOLS\CMDOW.exe WORK\I386E >NUL
)

REM cWnd stands for "child window" from a brief search. I'm unsure where to get that specific exectubale to test it, and if it works in all situations.

IF EXIST HFEXPERT\WIN\SYSTEM32\cWnd.exe ("SET CMDHIDE=cWnd.exe /hide @")
IF EXIST HFTOOLS\cWnd.exe (
	SET "CMDHIDE=cWnd.exe /hide @"
	COPY /Y HFTOOLS\cWnd.exe WORK\I386E >NUL
)

REM ---------- Preparations ----------

IF "%VERSION%"=="2000" (
	SET "T1=HFSLIP 2000"
	TITLE %T1%
	SET "SHORTOSNAME=win2k"
	SET /A "OSLEVEL=14"
	SET "BDACAB=BDANT"
	SET /A "DXNT=1"
	SET /A "IERNONCE=1"
	
	SET "VERSIONIE=2KIE5"
	IF EXIST HFCABS\IEW2K_1.cab (
		SET "VERSIONIE=2KIE6"
		SET /A "SLIPIE6=1"
	) ELSE IF EXIST HFCABS\_IE6_HFSLIP.cab (
		SET "VERSIONIE=2KIE6"
		SET /A "SLIPIE6=1"
	)
	
	IF EXIST HFTOOLS\REG.exe (
		SET "REGEXE=HFTOOLS\REG"
	) ELSE IF EXIST HFEXPERT\WIN\SYSTEM32\REG.exe (
		SET "REGEXE=HFEXPERT\WIN\SYSTEM32\REG"
	) ELSE IF EXIST %SYSTEMROOT%\SYSTEM32\REG.exe (
		SET "REGEXE=REG"
	) ELSE IF EXIST SOURCE\SUPPORT\TOOLS\SUPPORT.cab (
		MD WORK\SUPPCAB
		EXPAND SOURCE\SUPPORT\TOOLS\SUPPORT.cab -F:* WORK\SUPPCAB >NUL
		SET "REGEXE=WORK\SUPPCAB\REG"
	)
	
	REM REG.exe is not included in Windows 2000. Thus, this patch cannot be applied if this script is ran under 2000 without additional files.
	IF DEFINED REGEXE (
		REM Adds 48-bit LBA support - Thanks to Wendy/os2fan2 for the tip.
		COPY SOURCE\I386\SETUPREG.HIV %SOURCESS%\I386 >NUL
		!REGEXE! load HKLM\HFSLIP "%SOURCESS%\I386\SETUPREG.HIV" >NUL
		!REGEXE! add HKLM\HFSLIP\ControlSet001\Services\atapi\Parameters /v EnableBigLba /t reg_dword /d 00000001 /f >NUL
		!REGEXE! unload HKLM\HFSLIP >NUL
		
		REM 2024/8/1
		REM I guess XP's REG.exe does not create SETUPREG.HIV*.blf and SETUPREG.HIV*.regtrans-ms files as compared to 7's.
		REM Thus, any errors piped to NUL.
		ATTRIB -R -A -S -H %SOURCESS%\I386\SETUPREG.HIV*.blf 2>NUL
		ATTRIB -R -A -S -H %SOURCESS%\I386\SETUPREG.HIV.log* 2>NUL
		ATTRIB -R -A -S -H %SOURCESS%\I386\SETUPREG.HIV*.regtrans-ms 2>NUL
		DEL /F /Q %SOURCESS%\I386\SETUPREG.HIV*.blf 2>NUL
		DEL /F /Q %SOURCESS%\I386\SETUPREG.HIV.log* 2>NUL
		DEL /F /Q %SOURCESS%\I386\SETUPREG.HIV*.regtrans-ms 2>NUL
		
		SET /A "LBASUPPORT=1"
	)
	
	IF EXIST FDVFILES\WIN2K IF EXIST HFCLEANUP\* IF NOT DEFINED FDVT (
		ECHO/>CON
		ECHO Do you want to overwrite and clean out FDV's INF files with HFCLEANUP files?>CON
		ECHO/>CON
		ECHO Enter "Y" to overwrite. Default is no.>CON
		ECHO/>CON
		SET /P "FDVT="
	)
	IF EXIST FDVFILES\WIN2K (
		COPY FDVFILES\*.* WORK\FDV >NUL
		SET "VERSIONIE=FDV"
	)
) ELSE IF "%VERSION%"=="XP" (
	SET "T1=HFSLIP XP"
	TITLE %T1%
	SET /A "OSLEVEL=2%SP%"
	IF %SP% EQU 3 (
		SET "SHORTOSNAME=winxpsp3"
		SET /A "MPLEVEL=33"
	) ELSE IF %SP% EQU 2 (
		SET "SHORTOSNAME=winxpsp2"
		IF EXIST SOURCE\I386\wmlaunch.ex* (
			SET /A "MPLEVEL=41"
		) ELSE (
			SET /A "MPLEVEL=31"
		)
	) ELSE IF %SP% LSS 2 (
		SET "BDACAB=BDAXP"
		SET /A "DXNT=1"
		SET "SHORTOSNAME=winxp"
		SET /A "MPLEVEL=21"
	)
	
	IF EXIST SOURCE\CMPNENTS\MEDIACTR\I386 (SET /A "XPMCE=1")
	IF EXIST SOURCE\CMPNENTS\NETFX\I386 (SET /A "XPNETFX=1")
	
	REM The following VERSIONIE SET to "IE6" only serves to provide ERRORREPORT with a string.
	SET "VERSIONIE=IE6"
	IF EXIST HF\IE7-WindowsXP-x* (
		FOR /F %%I IN ('DIR /B HF\IE7-WindowsXP-x*') DO (
			SET "IE7EXE=%%I"
			SET "VERSIONIE=IE7"
		)
	)
	IF EXIST HF\IE8-WindowsXP-x* (
		FOR /F %%I IN ('DIR /B HF\IE8-WindowsXP-x*') DO (
			SET "IE8EXE=%%I"
			SET "VERSIONIE=IE8"
			REM TODO
			REM This variable initialization bothers me.
			REM First, why the hell would this be SET *here* of all places? This variable is only relevant in :HF.
			REM Second, I'm assuming that DefExcHF could be defined in HFANSWER.ini, because :HF as far as I can tell is not CALL'd prior.
			REM So, why would DefExcHF be defined in HFANSWER.ini!?!
			REM Third, what is with that tab? Surely it was a typo, no?
			
			REM Unless someone brings up a good answer for the above three questions, the following code will be appropriately moved into :HF.
			REM SET "DefExcHF=%DefExcHF% \-win IE8	"
		)
	)
	IF EXIST SOURCE\I386\SVCPACK\IE8.cat (SET "VERSIONIE=IE8")
	IF EXIST FDVFILES\WINXP (
		COPY FDVFILES\*.* WORK\FDV >NUL
		SET "VERSIONIE=FDV"
	)
	
	IF EXIST FDVFILES\WINXP IF EXIST HFCLEANUP\* IF NOT DEFINED FDVT (
		ECHO/>CON
		ECHO Do you want to overwrite and clean out FDV's INF files with HFCLEANUP files?>CON
		ECHO/>CON
		ECHO Enter "Y" to overwrite. Default is no.>CON
		ECHO/>CON
		SET /P "FDVT="
	)
) ELSE IF "%VERSION%"=="2003" (
	SET "T1=HFSLIP 2003"
	TITLE %T1%
	SET "SHORTOSNAME=srv2k3"
	SET /A "OSLEVEL=3%SP%"
	IF %SP% EQU 2 (
		SET /A "MPLEVEL=42"
		SET /A "DXNT=1"
	) ELSE IF %SP% EQU 1 (
		SET /A "MPLEVEL=41"
		SET /A "DXNT=1"
	) ELSE IF %SP% EQU 0 (
		SET /A "MPLEVEL=31"
	)
	
	IF EXIST HF\IE7-WindowsS* (
		FOR /F %%I IN ('DIR /B HF\IE7-WindowsServer2003-x*') DO (SET "IE7EXE=%%I")
	)
	
	IF EXIST FDVFILES\WIN2K3 (
		COPY FDVFILES\*.* WORK\FDV >NUL
		SET "VERSIONIE=FDV"
	)
	REM TODO Shouldn't there be a similar prompt for HFCLEANUP?
)

ECHO/>CON
ECHO ============================ HFSLIP OS INFORMATION ============================>CON
ECHO/>CON
IF "%HostOS%"=="Vista" (
	ECHO     Host OS:            Vista or newer >CON
) ELSE (
	ECHO     Host OS:            %HostOS% >CON
)
ECHO/>CON
ECHO     Target OS:          %VERSION% >CON
REM The space after SP is important.
ECHO     Service Pack:       %SP% >CON
ECHO     Localization:       %Localization% >CON
ECHO     LCIDD:              %LCIDD% >CON
ECHO/>CON
IF "%VERSION%"=="2000" IF DEFINED LBASUPPORT (
	ECHO     48-bit LBA Support: Added>CON
) ELSE (
	ECHO/>CON
)
ECHO/>CON
ECHO/>CON
ECHO     HFSLIP has completed some preparations and is now ready to begin work.>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO/>CON
ECHO ===============================================================================>CON
PAUSE>CON

SET /A "SPCNT=%SP%+1"
SET "SPUPDATE=SP%SPCNT%"
SET "SPCNT="

REM Native time calculator / Part 1 / Tomcat76.
SET "SDATE=%DATE%"
SET "STIME=%TIME%"


REM ******************** Slipstreaming ********************


REM ---------- Begin Slipstreaming ----------

CALL :SYSOC_INIT
CALL :TXTSETUP_INIT
CALL :DOSNET_INIT
CALL :HFSLIP_INIT
CALL :UPDATE_INIT

IF DEFINED XPNETFX IF EXIST HF\NDP1*.exe (
	ECHO Expanding NETFX.cab...
	MD %SOURCESS%\CMPNENTS\NETFX\I386 WORK\MCE\NETFX10
	EXPAND SOURCE\CMPNENTS\NETFX\I386\NETFX.cab -F:* WORK\MCE\NETFX10 >NUL
)

IF "%VERSION%"=="XP" IF EXIST HF\*%MCEROLLUP%*.exe (
	FOR /F %%I IN ('DIR /B HF\*%MCEROLLUP%*.exe') DO (
		IF /I "%%I"=="%MCEROLLUP%.exe" (
			DEL /Q/F HF\%%I
		) ELSE (
			SET "MCERUEXE=%%I"
			HF\%%I /Q /X:HF
		)
	)
	IF NOT EXIST HF\wmfdist95.exe (
		MOVE HF\bin\wmfdist95.exe HF >NUL
		ECHO>>WORK\FILESTODEL.txt HF\wmfdist95.exe
	)
	IF DEFINED XPMCE (
		IF EXIST HF\WMP11* (DEL /Q/F HF\bin\*Media10*)
		IF EXIST HF\*912024*.exe IF EXIST HF\bin\*888795* (DEL /Q/F HF\bin\*888795*)
		FOR /F %%I IN ('DIR /B HF\bin\*%MCEROLLUP%*') DO (COPY /Y HF\bin\%%I WORK\MCERU1.exe >NUL)
		DEL /Q/F HF\bin\*%MCEROLLUP%*
		FOR /F %%I IN ('DIR /B HF\bin\*KB*') DO (
			XCOPY /Y HF\bin\%%I HF
			ECHO>>WORK\FILESTODEL.txt HF\%%I
		)
	)
	RD /Q/S HF\bin
)

SET /A "HFSLP=99"

REM Update Rollup 1 for Windows 2000 SP4.
IF "%VERSION%"=="2000" IF EXIST HF\*891861*.exe (
	FOR /F %%I IN ('DIR /B HF\*891861*.exe') DO (
		SET "HF=%%I"
		CALL :HF1EXTRACT
		IF DEFINED SERVER (
			FOR /F %%I IN ('DIR /B/A-D/S HF\*899591*.exe') DO (SET /A "DELRDPWD=1")
			IF DEFINED DELRDPWD (
				DEL /Q/F WORK\I386E\rdpwd.sys
				SET "DELRDPWD="
			)
		)
	)
	TITLE %T1%
)

REM TODO Does this apply to 2003?
REM Windows XP Genuine Advantage Notification.
IF NOT "%VERSION%"=="2000" IF EXIST HF\WindowsXP-KB905474*Standalone.exe (
	FOR /F %%I IN ('DIR /B HF\WindowsXP-KB905474*Standalone.exe') DO (
		HF\%%I /Q:A /T:"%PREP%\HF" /C
		REN HF\WGANOT~1.exe WindowsZ-wga.exe
		ECHO>>WORK\FILESTODEL.txt HF\WindowsZ-wga.exe
	)
)

REM IE7 stuff.
IF NOT DEFINED IE7EXE (
	REM My guess is these variables were commenly defined in HFANSWER.ini, so if the IE7 executable was missing, delete these variables.
	SET "IE7SLIPSTREAM="
	SET "IE7SVCPACK="
	SET "IE7GUILOGON="
) ELSE (
	IF NOT DEFINED IE7SVCPACK IF NOT DEFINED IE7GUILOGON (SET /A "IE7SLIPSTREAM=1")
	REM *** Block for 2k3 slipstreaming / remove if no longer necessary ***
	IF "%VERSION%"=="2003" (
		SET "IE7SLIPSTREAM="
		IF NOT DEFINED IE7GUILOGON (SET /A "IE7SVCPACK=1")
	)
)
IF "%IE7SLIPSTREAM%"=="1" IF NOT DEFINED CDTAG (
	ECHO/>CON
	ECHO WARNING>CON
	ECHO You want to slipstream IE7 but no valid CD tag was found in the SOURCE folder.>CON
	ECHO HFSLIP will instead create a new package which will be installed separately>CON
	ECHO during Windows setup.>CON
	ECHO/>CON
	PAUSE>CON
	SET /A "IE7SVCPACK=1"
	SET "IE7SLIPSTREAM="
)
REM More of the same extra-careful-to-delete-variables mindset.
IF "%IE7SLIPSTREAM%"=="1" (
	SET "IE7GUILOGON="
	SET "IE7SVCPACK="
) ELSE IF "%IE7SVCPACK%"=="1" (
	SET "IE7GUILOGON="
	SET "IE7SLIPSTREAM="
)

REM IE6 vs IE7
IF "%VERSION%"=="2000" (
	IF DEFINED SLIPIE6 (
		CALL :IE6SLIP
		SET "SLIPIE6="
	)
) ELSE (
	IF DEFINED IE7EXE IF NOT DEFINED IE7SLIPSTREAM (CALL :IE7INT)
)

REM Windows Media Player
CALL :WMSLIP

REM TODO
REM According to Wikipedia:
REM * 2000 pre-SP2 came with WMP6.4, and SP2+ with 7.1.
REM * XP pre-SP2 came with WMP8, and SP2+ with 9.
REM * 2003 pre-SP1 came with WMP9, and SP1+ with 10.
REM If someone wants to add the code in to reflect that information to be displayed in HFSLIP.log, be my guest.
REM This does mean that if you are *not* slipstreaming a newer or the latest version of WMP into SOURCESS, MPLEVEL might not be defined, and thus
REM in turn the associated MPFLDRx variables.
IF DEFINED MPLEVEL (
	IF !MPLEVEL! EQU 31 (
		SET "MPFLDRA=WMP9"
		SET "MPFLDRB=WMP9NL"
		SET "MPFLDRC=WM9NL"
		SET "MPFLDRD=WM9"
	) ELSE IF !MPLEVEL! EQU 32 (
		SET "MPFLDRA=WMP9"
		SET "MPFLDRB=WMP9L"
		SET "MPFLDRC=WM9L"
		SET "MPFLDRD=WM9"
	) ELSE IF !MPLEVEL! EQU 33 (
		SET "MPFLDRD=WM9"
	) ELSE IF !MPLEVEL! EQU 41 (
		SET "MPFLDRA=WMP10"
		SET "MPFLDRB=WMP10NL"
		SET "MPFLDRC=WM10NL"
	) ELSE IF !MPLEVEL! EQU 42 (
		SET "MPFLDRA=WMP10"
		SET "MPFLDRB=WMP10L"
		SET "MPFLDRC=WM10L"
	) ELSE IF !MPLEVEL! EQU 43 (
		REM "EMERALD" seems to be the code-name for Windows XP Media Center Edition 2005 Update Rollup 2.
		REM Thus, this would have to be a special version of WMP.
		SET "MPFLDRA=EMERALD"
	) ELSE IF !MPLEVEL! EQU 51 (
		SET "MPFLDRA=WMP11"
		SET "MPFLDRC=WM11"
	)
)

SET /A "HFSLP=199"

REM Installs a "a permanent copy of Package Installer for Windows to enable software updates to have a significantly smaller download size."
REM XP SP3 does not have this stock even though SP3 was released after this update was released.
IF EXIST HF\*898461*.exe (
	FOR /F %%I IN ('DIR /B/OD HF\*898461*.exe') DO (SET "PKGINST=%%I")
	ECHO !PKGINST!
	HF\!PKGINST! /Q /X:TEMP
	SET "PKGINST="
	FOR /F "tokens=2,3 delims==" %%I IN ('FINDSTR /I PkgInstallerVer TEMP\UPDATE\update_SP2QFE.inf') DO (SET "TXTDIR00=%%I")
	ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Preinstall","Path",0x20000,"%%SYSTEMROOT%%\system32\PreInstall"
	ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\KB898461","Installed",0x10001,1
	COPY TEMP\UPDATE\UPDATE.exe TEMP\update.ref >NUL
	COPY TEMP\UPDATE\UPDSPAPI.dll TEMP\updspapi.ref >NUL
	COPY TEMP\UPDATE\SPCUSTOM.dll TEMP\spcustom.ref >NUL
	MOVE /Y TEMP\UPDATE\*.cat WORK\SVCPACK >NUL
	XCOPY /DY TEMP WORK\I386E
	CALL :CLEANTEMP
	ECHO/
)

REM Remote Desktop Connection (Terminal Services Clients 6.1/6.0) for XP SP2.
REM AFAI can tell, XP SP3 does include this or a newer version stock.
IF EXIST HF\*952155*.exe (
	FOR /F %%I IN ('DIR /B/OD HF\*952155*.exe') DO (SET "TSCINST=%%I")
) ELSE IF EXIST HF\*925876*.exe IF NOT %OSLEVEL% EQU 23 (
	FOR /F %%I IN ('DIR /B/OD HF\*925876*.exe') DO (SET "TSCINST=%%I")
)
IF DEFINED TSCINST (
	ECHO !TSCINST!
	HF\!TSCINST! /Q /X:TEMP
	IF NOT EXIST TEMP\SP%SP%QFE (
		REN TEMP\SP2QFE SP%SP%QFE
		REN "TEMP\UPDATE\update_SP2QFE.inf" update_SP%SP%QFE.inf
	)
	FINDSTR /VI "HKCU" TEMP\UPDATE\update_SP%SP%QFE.inf>TSC.inf
	MOVE /Y TSC.inf TEMP\UPDATE\update_SP%SP%QFE.inf >NUL
	COPY /Y TEMP\update\tscupdatecustom.dll TEMP\TSCUPDC.dll >NUL
	CALL :MIDHF1CALLER
	SET "TSCINST="
)

REM Hotfixes
IF EXIST HF\*.exe (CALL :HF)
IF EXIST HF\BASIC\*.exe (
	SET /A "HFDEEP=1"
	DIR /B HF\BASIC\*.exe>WORK\HFBASIC0.txt
	FINDSTR /VIR "IE7 DX9\-" WORK\HFBASIC0.txt>WORK\HFBASIC.txt
	FOR /F %%I IN (WORK\HFBASIC.txt) DO (
		SET "HF=%%I"
		IF DEFINED HF (
			CALL :HFBASIC
			SET "HF="
		)
	)
)
IF EXIST HF\NOREG\*.exe (
	SET /A "HFDEEP=1"
	DIR /B HF\NOREG\*.exe>WORK\HFNOREG0.txt
	FINDSTR /VIR "IE7 DX9\-" WORK\HFNOREG0.txt>WORK\HFNOREG.txt
	FOR /F %%I IN (WORK\HFNOREG.txt) DO (
		SET "HF=%%I"
		IF DEFINED HF (
			CALL :HFNOREG
			SET "HF="
		)
	)
)
TITLE %T1%

REM IE7 vs IE8
IF "%IE7SLIPSTREAM%"=="1" (
	SET /A "HFSLP+=1"
	CALL :IE7SLIP
)
REM Executable-specific rules.
IF DEFINED IE8EXE (
	SET /A "HFSLP=900"
	CALL :IE8SLIP
) ELSE (
	IF EXIST HF\IE8-WindowsXP*.exe (
		CALL :IE8_FIXES
		TITLE %T1%
	)
)

REM Windows Update Agent
IF EXIST HF\*WindowsUpdateAgent*-x86.exe (CALL :WUA)

REM Windows Installer 4.5
REM WI 4.5 is the last version for OSes prior to 7.
REM It is not included in XP SP3.
IF "%VERSION%"=="XP" IF EXIST HF\WindowsXP-KB942288-*-x86.exe (CALL :MSI45 XP sp3qfe)
IF "%VERSION%"=="2003" IF EXIST HF\WindowsServer2003-KB942288-*-x86.exe (CALL :MSI45 Server2003 sp2qfe)
REM TODO Does WI 3.1 for 2000 require any special slipstream procedure?

REM CAB Processing
IF EXIST HFCABS\*.cab (CALL :PROCESSCABS)

REM MSXML
IF EXIST HF\MSXML*.* (CALL :MSXML)

REM TODO Doesn't this just work fine by itself without the code in :HF1COMMON_A?
REM gdiplus (2000)
IF "%VERSION%"=="2000" IF EXIST HF\gdiplus*.exe (
	MD WORK\GDI2K
	FOR /F %%I IN ('DIR /B HF\gdiplus*.exe') DO (HF\%%I /Q:A /T:"%PREP%\WORK" /C)
	HFTOOLS\7za.exe x WORK\gdiplus.exe -o"%PREP%\WORK\GDI2K" -r >NUL
	XCOPY /DY WORK\GDI2K\gdiplus.dll WORK\I386E
)

REM DirectX 9
IF EXIST HF\directx*redist.exe (
	FOR /F %%I IN ('DIR /B/ON HF\directx*redist.exe') DO (SET "DX9REDIST=%%I")
)
IF DEFINED DX9REDIST IF "!DX9REDIST!"=="directx_9c_redist.exe" IF EXIST HFCABS\_DX9core_%VERSION%SP%SP%_HFSLIP.cab (SET "DX9REDIST=")
IF DEFINED DX9REDIST (
	TITLE %T1% - DirectX9C Redist
	ECHO/
	ECHO Processing DirectX9C Redistributable ^(!DX9REDIST!^)
	ECHO/
	
	MD WORK\DXREDIST
	HF\!DX9REDIST! /Q:A /T:"%PREP%\WORK\DXREDIST" /C
	ECHO Checking if DX9 core files need to be copied into HFCABS...
	IF EXIST HFCABS\_DX9core_%VERSION%SP%SP%_HFSLIP.cab (
		ECHO _DX9core_%VERSION%SP%SP%_HFSLIP.cab already exists
	) ELSE (
		IF NOT DEFINED BDACAB (
			IF NOT DEFINED DXNT (ECHO Not applicable.)
		) ELSE IF NOT EXIST HFCABS\%BDACAB%.cab (
			COPY WORK\DXREDIST\%BDACAB%.cab HFCABS >NUL
			ECHO %BDACAB%.cab
			ECHO>>WORK\FILESTODEL.txt HFCABS\%BDACAB%.cab
		)
		IF DEFINED DXNT IF NOT EXIST HFCABS\dxnt.cab (
			COPY WORK\DXREDIST\dxnt.cab HFCABS >NUL
			ECHO dxnt.cab
			ECHO>>WORK\FILESTODEL.txt HFCABS\dxnt.cab
		)
	)
	IF EXIST WORK\DXREDIST\*x86.cab (
		ECHO Checking if extra DX9 packages need to be copied into HFCABS...
		DEL /Q/F WORK\DXREDIST\*MDX*
		IF NOT DEFINED BDACAB (DEL /Q/F WORK\DXREDIST\dxdllreg*)
		FOR /F %%I IN ('DIR /B/ON WORK\DXREDIST\*x86.cab') DO (
			IF NOT EXIST HFCABS\%%I (
				COPY WORK\DXREDIST\%%I HFCABS >NUL
				ECHO %%I
				ECHO>>WORK\FILESTODEL.txt HFCABS\%%I
			)
		)
	)
	SET "DX9REDIST="
	TITLE %T1%
)

REM TODO This DXNT variable limits DX9C slipstreaming to 2003 SP1+, XP pre-SP2, and 2000 - the latter two OSes not shipping with DX9C.
REM Only the DX9EXTRAs will be slipstreamed if using another OS.
REM From what is shown via dxdiag.exe in regards to 2000 SP4, slipstreaming DX9C via HFSLIP seemingly only bumps the version of ddrawx.dll
REM from 5.00.2134.0001 (size 24336) when done via the installer vs 5.03.0000.0900 (size 24064). Whether that version bump is significant, IDK.
IF DEFINED DXNT IF EXIST HFCABS\*DX*.cab (CALL :DX9C)
CALL :DX9EXTRA

IF EXIST HFAAO\* (CALL :HFAAO)

CALL :POSTHFX

CALL :SVCPACK_1STLOGON_INST

IF EXIST HFEXPERT (
	FOR /F %%I IN ('DIR /B HFEXPERT') DO (SET /A "HFEXPERTFILES=1")
)
IF DEFINED HFEXPERTFILES (
	CALL :HFEXPERT
	SET "HFEXPERTFILES="
)

REM Adding files from SOURCE into SOURCESS.
TITLE %T1% - Copying Source
IF EXIST HFTOOLS\EXCLUDE.txt (
	XCOPY /DE SOURCE %SOURCESS% /EXCLUDE:HFTOOLS\EXCLUDE.txt
) ELSE (
	XCOPY /DE SOURCE %SOURCESS%
)
IF EXIST SOURCE\I386\SFCFILES.dl_ IF EXIST SOURCE\I386\SFCFILES.dll (DEL /Q/F %SOURCESS%\I386\SFCFILES.dll)
TITLE %T1%

REM Running specific HFTOOLS.
IF EXIST HFTOOLS\HFSLIP_PRE*.cmd (
	FOR /F %%I IN ('DIR /B/ON HFTOOLS\HFSLIP_PRE*.cmd') DO (CALL HFTOOLS\%%I)
)

REM evgnb:
REM :SVCPACK deletes *.cat files if DELCATS=1.
REM CALL SFC/WFP patch and set DELCATS=1 before :INTEGRATE and :SVCPACK.

REM What if you don't want these patches applied? Now they're controlled via HFANSWER.ini.
REM By default, it will NOT apply these patches.
REM The HFANSWER.ini file will be included in HFTOOLS going forward, with the relavent values set to "0", disabling the patches.
IF "%SFCWFPPATCH%"=="1" (CALL :SFCWFPDRM)

REM Disable Driver Signing patch
IF "%CERTPATCH%"=="1" (CALL :DIGICERTOFF)

REM PAE patch
REM Using PatchPAE3 v0.0.0.48 beta-6 included with 1.7.11debug, it does not work with either the SP4.cab or the DRIVER.cab kernel files, thus I wouldn't bother to try enabling this patch.
REM Used Windows 7 SP1 with VC++ 10 redists installed - coult not get it or the earlier beta-3 on evgnb's Github page (evgen_b) to work with the files.
REM Perhaps the Russian kernel files have a slightly different binary?
IF "%PHADEXPATCH%"=="1" (CALL :PAEPATCH)
TITLE %T1%

REM evgnb:
REM After :INTEGRATE - files in i386 already compressed with CAB.
REM After :CABCOMPACT - files compressed in DRIVER.cab archive.

CALL :INTEGRATE

CALL :SVCPACK

IF DEFINED MULTICAB (
	CALL :SPXCAB
) ELSE (
	CALL :CABEXPAND
)

IF EXIST HFEXPERT\STORAGE\*.sys (CALL :HFSTOR)

CALL :CLOSURE

IF EXIST HF\XPIZE* (
	CALL :XPIZE
	TITLE %T1%
)

IF NOT DEFINED MULTICAB (
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif [SourceDisksFiles]
	ECHO/>>%SOURCESS%\I386\DOSNET.inf
	ECHO>>%SOURCESS%\I386\DOSNET.inf [Files]
	IF EXIST HFCLEANUP\* (
		CALL :HFCLEANUP
		TITLE %T1%
	)
	IF EXIST HFEXPERT\DRIVERCAB (CALL :HFEDRVCAB)
	IF DEFINED DRVPASS (CALL :CABCOMPACT)
)

IF EXIST HFCLEANUP\*.EXT (CALL :DELBIN)
IF EXIST HFEXPERT\WIN\* (CALL :HFEWIN)
IF EXIST HFEXPERT\PROGRAMFILES\* (
	CALL :HFEPRG
	TITLE %T1%
)


IF "%VERSIONIE%"=="FDV" (
	COPY /Y WORK\FDV\*.* %SOURCESS%\I386 >NUL
	CALL :FDVFILESCLEANUP
)

REM REPLACE-ing files.
CALL :ISNOTEMPTY REPLACE
IF DEFINED NOTEMPTY (
	REM NT 5.X OSes do not allow files to have a "." at the beginning of a file/folder name. Vista and newer does.
	FOR /F "delims=" %%I IN ('DIR /B/A-D-H-S/S REPLACE ^| FINDSTR /C:"\\\." /V') DO (
		SET "FULLREPLACEPATH=%%I"
		SET "REPLACEPATH=!FULLREPLACEPATH:%PREP%\REPLACE\=!"
		SET "REPLACEPATH=!REPLACEPATH:%%~nxi=!"
		XCOPY /RSY "%%I" "%SOURCESS%\!REPLACEPATH!"
	)
	SET "NOTEMPTY="
	SET "FULLREPLACEPATH="
	SET "REPLACEPATH="
)

REM Running specific HFTOOLS again.
IF EXIST HFTOOLS\HFSLIP_POST*.cmd (
	FOR /F %%I IN ('DIR /B/ON HFTOOLS\HFSLIP_POST*.cmd') DO (CALL HFTOOLS\%%I)
)

IF EXIST HFBACKUP\I386 (
	RD /Q/S SOURCE
	REN HFBACKUP SOURCE
)

IF EXIST WORK\FILESTODEL.txt (
	FOR /F "delims=" %%I IN (WORK\FILESTODEL.txt) DO (
		IF EXIST %%I (DEL /Q/F %%I)
	)
)

RD /Q/S WORK

REM What if you don't want this patch applied? Now it's controlled via HFANSWER.ini.
REM By default, it will NOT apply this patch.
REM The HFANSWER.ini file will be included in HFTOOLS going forward, with the relavent value set to "0", disabling the patch.
IF "%OEMKEYCHANGE%"=="1" IF "%VERSION%"=="2000" (CALL :OEMKEYEDIT)

REM The following works for the values of DATE and TIME in North America. Perhaps it varies globally depending on localization.
REM YEAR/MM/DD - HH:MM:SS.MS
SET "FINTIME=%date:~10,4%/%date:~4,2%/%date:~7,2% - %time%"
CALL :ERRORREPORT

CALL :TIMECALC

IF NOT "%NOLOGCOPY%"=="1" (COPY /Y HFSLIP.log %SOURCESS% >NUL)

CALL :MAKEISO

TITLE %T1% - Finished
ECHO/>CON
ECHO All hotfixes integrated into a folder called %SOURCESS%.>CON
ECHO/>CON
PAUSE>CON
EXIT

REM ---------- Slipstreaming Complete ----------



REM ++++++++++++++++++++++++++++++ Functions ++++++++++++++++++++++++++++++



REM ******************** Pre-START Setup ********************


REM ---------- Folder Initialization ----------
:FOLDERINIT
REM If the parameter provided is equal to 1, only rebuild the WORK directory structure.
IF %~1 NEQ 1 (
	FOR %%I IN (FDVFILES HF HFCABS HFSVCPACK HFSVCPACK_SW1 HFSVCPACK_SW2 HFGUIRUNONCE HFTOOLS SOURCE REPLACE) DO (
		IF NOT EXIST %%I (MD %%I)
	)
	
	CALL :ISNOTEMPTY SOURCE
	IF NOT DEFINED NOTEMPTY (
		ECHO/>CON
		ECHO You didn't read the instructions. You didn't fill the SOURCE folder.>CON
		ECHO/>CON
		ECHO Copy the Windows SOURCE to the SOURCE folder and re-run HFSLIP.>CON
		ECHO/>CON
		PAUSE
		EXIT
	)
	SET "NOTEMPTY="
	
	REM 2020-08-07:
	ATTRIB -R -A -S -H SOURCE\*.* /S /D
	
	IF EXIST WORK\FILESTODEL.txt (
		FOR /F "delims=" %%I IN (WORK\FILESTODEL.txt) DO (
			IF EXIST %%I (DEL /Q/F %%I)
		)
	)

	IF EXIST SP (RD /Q/S SP)
	IF NOT EXIST TEMP (
		MD TEMP
	) ELSE (
		CALL :CLEANTEMP
	)

	IF EXIST SP.ddf (DEL /Q/F SP.ddf)
	IF EXIST SP.txt (DEL /Q/F SP.txt)
	IF EXIST UC.ddf (DEL /Q/F UC.ddf)
)

IF EXIST WORK (RD /Q/S WORK)
MD WORK\DX9 WORK\DX9EXTRA WORK\DX9_X3DA WORK\FDV WORK\INFS WORK\SVCPACK WORK\I386E WORK\CDROOT WORK\IE6EXP WORK\MSXML WORK\RED
GOTO :EOF
REM ---------- ----------

REM ---------- File Compression ----------
:FILECOMP
SET /A "COMPMEM=21"
IF "%DRIVERCOMP%"=="2" (
	SET /A "COMPMEM=20"
) ELSE IF "%DRIVERCOMP%"=="3" (
	SET /A "COMPMEM=18"
) ELSE IF "%DRIVERCOMP%"=="4" (
	SET /A "MULTICAB=1"
) ELSE IF "%DRIVERCOMP%"=="5" (
	SET /A "MULTICAB=1"
	SET /A "COMPMEM=20"
) ELSE IF "%DRIVERCOMP%"=="6" (
	SET /A "MULTICAB=1"
	SET /A "COMPMEM=18"
)
GOTO :EOF
REM ---------- ----------

REM ---------- Check Variables from HFANSWER.ini ----------
:AHTESTEXP
IF /I "%AHTEST%"=="HFCLEANUP" (
	SET /A "DIAGNOSTIC=1"
	SET "T1=AHTEST"
	TITLE %T1%
	CALL :ADDFFLAGS
	CALL :HFCLEANUP
	CALL :CABCOMPACT
	CALL :MAKEISO
	RD /Q/S WORK
	PAUSE>CON
	EXIT
) ELSE IF /I "%AHTEST%"=="MAKEISO" IF EXIST %SOURCESS% (
	SET "T1=AHTEST"
	TITLE %T1%
	CALL :MAKEISO
	PAUSE>CON
	EXIT
)
GOTO :EOF
REM ---------- ----------


REM ******************** Post-START Setup ********************


REM ---------- Check Windows Version ----------
:CHECKWINVER
REM Thanks seabee. 
FOR /F "tokens=2,3,4* delims=, " %%I IN ('FINDSTR /BIL "Product=" SOURCE\I386\PRODSPEC.ini') DO (
	SET "V1=%%I"
	SET "V2=%%J"
	SET "V3=%%K"
)
IF "%V1%"=="2000" (
	SET "VERSION=2000"
	IF "%V2%"=="Server" (
		SET /A "SERVER=1"
	) ELSE IF "%V3%"=="Server" (
		SET /A "SERVER=1"
	)
) ELSE IF "%V1%"=="XP" (
	SET "VERSION=XP"
	ECHO %V2%|FIND /I "Profess" >NUL 2>&1 && SET "SUBTAG=ip"
	IF "%V2%"=="Home" (
		SET "SUBTAG=ic"
	) ELSE IF "%V3%"=="familiale" (
		SET "SUBTAG=ic"
	)
) ELSE IF "%V2%"=="2003" (
	SET "VERSION=2003"
	SET /A "SERVER=1"
	IF "%V3%"=="Standard" (
		SET "SUBTAG=is"
	) ELSE IF "%V3%"=="Enterprise" (
		SET "SUBTAG=ia"
	) ELSE IF "%V3%"=="Datacenter" (
		SET "SUBTAG=id"
	) ELSE IF "%V3%"=="Web" (
		SET "SUBTAG=ib"
	)
)

IF NOT "%V1%"=="2000" IF "%SUBTAG%"=="" (
	ECHO ERROR>CON
	ECHO Can't detect OS version, please add a "SUBTAG=i?" line, without the quotes, in>CON
	ECHO HFANSWER.ini where '?' is 'c' for XP Home, 'p' for XP Pro, 's' for 2003 Std,>CON
	ECHO 'a' for 2003 Enterprise, 'd' for 2003 Datacenter or 'b' for 2003 Web.>CON
	ECHO/>CON
	ECHO Press any key to quit.>CON
	PAUSE>CON
	RD /Q/S WORK
	EXIT
)

IF EXIST SOURCE\WIN51 (
	FOR /F %%I IN ('DIR /B SOURCE\WIN51') DO (SET "CDTAG=%%I")
) ELSE IF EXIST SOURCE\CDROM_NT.5 (
	FOR /F %%I IN ('DIR /B SOURCE\CDROM_NT.5') DO (SET "CDTAG=%%I")
)

REM Check Service Pack version.
IF EXIST SOURCE\I386\SP*.cat (
	FOR /F "tokens=2 delims=Pp." %%I IN ('DIR /B/ON SOURCE\I386\SP*.cat') DO (SET /A "SP=%%I")
)
IF NOT DEFINED SP (
	IF EXIST SOURCE\cdromsp5.tst (
		SET /A "SP=4"
	) ELSE IF EXIST SOURCE\CDROMSP*.TST (
		FOR /F "tokens=2 delims=Pp." %%I IN ('DIR /B/ON SOURCE\CDROMSP*.TST') DO (SET /A "SP=%%I")
	) ELSE IF EXIST SOURCE\WIN51*.SP* (
		FOR /F %%I IN ('DIR /B/ON SOURCE\WIN51*.SP*') DO (ECHO>>SPTMP.txt %%~xI)
		FOR /F "tokens=2 delims=Pp" %%I IN (SPTMP.txt) DO (SET /A "SP=%%I")
		DEL /Q/F SPTMP.txt
	)
)
IF NOT DEFINED SP (SET /A "SP=0")
GOTO :EOF
REM ---------- ----------

REM Thanks to Kramy for providing the required directives for USP5 Slipstreaming and the backup routine!
REM ---------- Check SOURCE ----------
:CHECKSOURCE
REM Check for unclean source.
FOR %%I IN (HFSL HFGUI nlite) DO (
	IF EXIST SOURCE\I386\%%I* (SET /A "NOCLEANSRC=1")
)
IF DEFINED NOCLEANSRC (
	ECHO/>CON
	ECHO ERROR: The SOURCE folder contains a source that was previously patched by>CON
	ECHO        either HFSLIP or nLite. HFSLIP can only work with a clean source.>CON
	ECHO/>CON
	ECHO Press any key to quit.>CON
	PAUSE>NUL
	EXIT
)

REM Clean SOURCE SVCPACK folder of non-".cat" files/folders.
IF EXIST SOURCE\I386\SVCPACK IF NOT EXIST SOURCE\cdromsp5.tst (
	FOR /F "delims=" %%I IN ('DIR /B/A-D SOURCE\I386\SVCPACK ^| FINDSTR /VIR "\.cat$"') DO (
		SET /A "NOCLEANSRC=2"
		DEL /Q/F "SOURCE\I386\SVCPACK\%%I"
		ECHO Removed SOURCE\I386\SVCPACK\%%I
	)
)
IF NOT DEFINED NOCLEANSRC (SET /A "NOCLEANSRC=0")

IF EXIST SOURCE\cdromsp5.tst (
	SET /A "SP=5"
)
IF NOT DEFINED BACKUPSOURCE IF "%VERSION%"=="2000" IF %SP% LSS 5 IF EXIST HF\w2ksp5*.exe (SET /A "BACKUPSOURCE=1")
IF "%BACKUPSOURCE%"=="2" (
	GOTO :MAKEBACKUP
) ELSE IF NOT "%BACKUPSOURCE%"=="1" (
	GOTO :HFSPACK
)
ECHO/>CON
ECHO Would you like HFSLIP to make a backup of the CD source?>CON
ECHO It will be restored at the end.>CON
ECHO/>CON
ECHO Press Enter to make a backup.>CON
ECHO Enter "N" to skip making a backup.>CON
SET /P "DOBACKUP="
IF /I "%DOBACKUP%"=="N" (GOTO :HFSPACK)

:MAKEBACKUP
ECHO Backing up source.
MD HFBACKUP
XCOPY /DEQ SOURCE HFBACKUP

:HFSPACK
SET "DOBACKUP="
IF "%VERSION%"=="XP" IF %SP% LSS 3 (
	IF EXIST HF\*936929* (
		FOR /F %%I IN ('DIR /B HF\*936929*.exe') DO (SET "XPSP3=%%I")
	)
	IF EXIST HF\*835935* (
		FOR /F %%I IN ('DIR /B HF\*835935*.exe') DO (SET "XPSP2=%%I")
	)
	IF EXIST HF\xpsp2*.exe (
		FOR /F %%I IN ('DIR /B HF\xpsp2*.exe') DO (SET "XPSP2=%%I")
	)
	IF EXIST HF\xpsp1*.exe (
		FOR /F %%I IN ('DIR /B HF\xpsp1*.exe') DO (SET "XPSP1=%%I")
	)
	IF EXIST HF\xpsp1a*.exe IF %SP% EQU 1 (
		FOR /F %%I IN ('FINDSTR /IR "MSJAVA\.dll" SOURCE\I386\LAYOUT.inf') DO (SET /A "SP1G=1")
	)
)
IF "%VERSION%"=="2000" (
	IF EXIST HF\w2ksp5*.exe (
		IF %SP% LSS 5 (
			ECHO Extracting Gurgelmeyer USP5 installer...
			FOR /F %%I IN ('DIR /B HF\w2ksp5*.exe') DO (HF\%%I /Q /X:SP\)
			ECHO Slipstreaming Gurgelmeyer USP5 into Windows 2000...
		)
	) ELSE IF EXIST HF\w2ksp4*.exe (
		IF %SP% LSS 4 (
			ECHO Extracting SP4 installer...
			FOR /F %%I IN ('DIR /B HF\w2ksp4*.exe') DO (HF\%%I /Q /X:SP\)
			ECHO Slipstreaming SP4 into Windows 2000...
		)
	)
) ELSE IF "%VERSION%"=="XP" (
	IF DEFINED XPSP3 (
		FOR %%I IN (BROWSEUI IEPEERS MSHTML SHDOCVW SHLWAPI URLMON) DO (
			IF EXIST SOURCE\I386\%%I.dll (
				IF NOT EXIST SOURCE\I386\%%I.dl_ (
					ATTRIB SOURCE\I386\%%I.dll -R
					MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX SOURCE\I386\%%I.dll /L SOURCE\I386 >NUL
				)
				DEL /Q/F SOURCE\I386\%%I.dll
			)
		)
		ECHO Extracting SP3 installer...
		HF\!XPSP3! /Q /X:SP\
		ECHO Slipstreaming SP3 into Windows XP...
		DEL /Q/F SP\i386\update\setupapi.dll
	) ELSE IF DEFINED XPSP2 (
		ECHO Extracting SP2 installer...
		HF\!XPSP2! /Q /X:SP\
		ECHO Slipstreaming SP2 into Windows XP...
		DEL /Q/F SP\i386\update\setupapi.dll
	) ELSE IF DEFINED SP1G (
		ECHO Extracting SP1a installer...
		HF\%XPSP1% /Q /X:SP\i386\
		ECHO Slipstreaming SP1a into Windows XP...
	) ELSE IF %SP% EQU 0 (
		IF DEFINED XPSP1 (
			ECHO Extracting SP1 installer...
			HF\!XPSP1! /Q /X:SP\i386\
			ECHO Slipstreaming SP1 into Windows XP...
		)
	)
) ELSE IF "%VERSION%"=="2003" (
	IF EXIST HF\*914961*.exe (
		IF %SP% LSS 2 (
			ECHO Extracting SP2 installer...
			FOR /F %%I IN ('DIR /B HF\*914961*.exe') DO (HF\%%I /Q /X:SP\)
			ECHO Slipstreaming SP2 into Windows Server 2003...
		)
	) ELSE IF EXIST HF\*889101*.exe (
		IF %SP% LSS 1 (
			ECHO Extracting SP1 installer...
			FOR /F %%I IN ('DIR /B HF\*889101*.exe') DO (HF\%%I /Q /X:SP\)
			ECHO Slipstreaming SP1 into Windows Server 2003...
		)
	)
)
SET "XPSP1="
SET "XPSP2="
SET "XPSP3="
SET "SP1G="
IF EXIST SP\i386 (
	IF EXIST HFTOOLS\update.exe (COPY /Y HFTOOLS\update.exe SP\i386\update >NUL)
	IF EXIST SOURCE\I386\SVCPACK.IN* (DEL /Q/F SOURCE\I386\SVCPACK.IN*)
	SP\i386\update\update.exe -u -n -o -q -s:"%~dp0SOURCE\"
	RD /Q/S SP
	ECHO Finished slipstreaming the Service Pack.
	SET /A "HFSLIPSVPACK=1"
)
IF EXIST SOURCE\cdromsp5.tst (
	IF EXIST SOURCE\I386\SVCPACK\spsetup.exe (ECHO>>WORK\SVCMAIN.txt SPSETUP.exe /q /n /z)
	IF EXIST SOURCE\I386\SVCPACK\setupusp.exe (ECHO>>WORK\SVCMAIN.txt SETUPUSP.exe /q /n /z)
	FOR /F %%I IN ('FINDSTR /IR /C:"USP 5\.1" SOURCE\cdromsp5.tst') DO (SET "VERSIONIE=2KIE6")
)

IF "%VERSION%"=="2000" IF %SP% LSS 4 (
	SET /A "OLDWIN=1"
) ELSE IF "%VERSION%"=="XP" IF %SP% LSS 2 (
	SET /A "OLDWIN=1"
)
IF DEFINED OLDWIN (
	ECHO/>CON
	ECHO Warning: Your source OS needs to be patched, but HFSLIP failed to detect>CON
	ECHO          an accepted Service Pack. It is strongly recommended you close>CON
	ECHO          HFSLIP now and correct the problem.>CON
	ECHO/>CON
	PAUSE>CON
	SET "OLDWIN="
)
ECHO/
GOTO :EOF
REM ---------- ----------

REM ---------- Get Language ----------
:GETLANG
IF NOT DEFINED LCIDD IF EXIST SOURCE\I386\FP*0EXT.IN* (
	FOR /F %%I IN ('DIR /B SOURCE\I386\FP*0EXT.IN*') DO (
		COPY SOURCE\I386\%%~nI.inf WORK >NUL 2>&1 || EXPAND SOURCE\I386\%%~nI.in_ -R WORK >NUL
		TYPE WORK\%%~nI.inf>WORK\GETLCIDD.txt
	)
	FOR /F "tokens=3 delims= " %%I IN ('FINDSTR /BI "FrontPageLangID" WORK\GETLCIDD.txt') DO (SET /A "LCIDD=%%~I")
)
IF "%LCIDD%"=="1033" (
	FOR /F %%I IN ('FINDSTR /IR "¢¢" SOURCE\I386\PRODSPEC.ini') DO (SET /A "LCIDD=1032")
)

IF DEFINED LCIDD (
	CALL :SETLANGCODES
	GOTO :EOF
)

FINDSTR /I Localization SOURCE\I386\PRODSPEC.ini>LNG.txt
FOR /F "tokens=1 delims=" %%I IN (LNG.txt) DO (SET %%I)
IF "%Localization%"=="Arabic" (
	SET /A "LCIDD=1025"
) ELSE IF "%Localization%"=="Traditional Chinese" (
	SET /A "LCIDD=1028"
) ELSE IF "%Localization%"=="Czech" (
	SET /A "LCIDD=1029"
) ELSE IF "%Localization%"=="Dansk" (
	SET /A "LCIDD=1030"
) ELSE IF "%Localization%"=="German" (
	SET /A "LCIDD=1031"
) ELSE IF "%Localization%"=="English" (
	SET /A "LCIDD=1033"
) ELSE IF "%Localization%"=="Finnish" (
	SET /A "LCIDD=1035"
) ELSE IF "%Localization%"=="Hebrew" (
	SET /A "LCIDD=1037"
) ELSE IF "%Localization%"=="Magyar" (
	SET /A "LCIDD=1038"
) ELSE IF "%Localization%"=="Italiano" (
	SET /A "LCIDD=1040"
) ELSE IF "%Localization%"=="Japanese" (
	SET /A "LCIDD=1041"
) ELSE IF "%Localization%"=="Korean" (
	SET /A "LCIDD=1042"
) ELSE IF "%Localization%"=="Dutch" (
	SET /A "LCIDD=1043"
) ELSE IF "%Localization%"=="Polski" (
	SET /A "LCIDD=1045"
) ELSE IF "%Localization%"=="Russian" (
	SET /A "LCIDD=1049"
) ELSE IF "%Localization%"=="Swedish" (
	SET /A "LCIDD=1053"
) ELSE IF "%Localization%"=="Chinese(PRC)" (
	SET /A "LCIDD=2052"
)

IF DEFINED LCIDD (
	CALL :SETLANGCODES
	GOTO :EOF
)

FOR /F %%I IN ('FINDSTR /IR "=Portugu.s" LNG.txt') DO (SET /A "LCIDD=2070")
FOR /F %%I IN ('FINDSTR /IR "(Brasil)" LNG.txt') DO (SET /A "LCIDD=1046")
FOR /F %%I IN ('FINDSTR /IR "¢¢" LNG.txt') DO (SET /A "LCIDD=1032")
FOR /F %%I IN ('FINDSTR /IR "=Fran.ais" LNG.txt') DO (SET /A "LCIDD=1036")
FOR /F %%I IN ('FINDSTR /IR "=T.rk.e" LNG.txt') DO (SET /A "LCIDD=1055")
FOR /F %%I IN ('FINDSTR /IR "=Espa.ol" LNG.txt') DO (SET /A "LCIDD=3082")
FOR /F "delims=;" %%I IN ('FINDSTR "Merknad" SOURCE\I386\PRODSPEC.ini') DO (SET /A "LCIDD=1044")
DEL /Q/F LNG.txt
IF DEFINED LCIDD (
	CALL :SETLANGCODES
) ELSE (
	ECHO HFSLIP was unable to determine the language of your source OS.  As a result,>CON
	ECHO some updates such as the Windows Update Agent cannot be slipstreamed properly.>CON
	PAUSE>CON
)
GOTO :EOF
REM ---------- ----------

REM ---------- Set Language Variables ----------
:SETLANGCODES
IF "%LCIDD%"=="1025" (
	SET "Localization=Arabic"
	SET "LNG=ARA"
	SET "LG=AR"
	SET "LG3=401"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="1028" (
	SET "Localization=Chinese (Taiwan)"
	SET "LNG=CHT"
	SET "LG=ZHTW"
	SET "LG3=404"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="1029" (
	SET "Localization=Czech"
	SET "LNG=CSY"
	SET "LG=CS"
	SET "LG3=405"
	SET /A "NOIE7STRNGSRCH=1
) ELSE IF "%LCIDD%"=="1030" (
	SET "Localization=Danish"
	SET "LNG=DAN"
	SET "LG=DA"
	SET "LG3=406"
) ELSE IF "%LCIDD%"=="1031" (
	SET "Localization=German"
	SET "LNG=DEU"
	SET "LG=DE"
	SET "LG3=407"
) ELSE IF "%LCIDD%"=="1032" (
	SET "Localization=Greek"
	SET "LNG=ELL"
	SET "LG=EL"
	SET "LG3=408"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="1033" (
	SET "Localization=English"
	SET "LNG=ENU"
	SET "LG=EN"
	SET "LG3=409"
) ELSE IF "%LCIDD%"=="1035" (
	SET "Localization=Finnish"
	SET "LNG=FIN"
	SET "LG=FI"
	SET "LG3=40b"
) ELSE IF "%LCIDD%"=="1036" (
	SET "Localization=French"
	SET "LNG=FRA"
	SET "LG=FR"
	SET "LG3=40c"
) ELSE IF "%LCIDD%"=="1037" (
	SET "Localization=Hebrew"
	SET "LNG=HEB"
	SET "LG=HE"
	SET "LG3=40d"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="1038" (
	SET "Localization=Hungarian"
	SET "LNG=HUN"
	SET "LG=HU"
	SET "LG3=40e"
) ELSE IF "%LCIDD%"=="1040" (
	SET "Localization=Italian"
	SET "LNG=ITA"
	SET "LG=IT"
	SET "LG3=410"
) ELSE IF "%LCIDD%"=="1041" (
	SET "Localization=Japanese"
	SET "LNG=JPN"
	SET "LG=JA"
	SET "LG3=411"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="1042" (
	SET "Localization=Korean"
	SET "LNG=KOR"
	SET "LG=KO"
	SET "LG3=412"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="1043" (
	SET "Localization=Dutch"
	SET "LNG=NLD"
	SET "LG=NL"
	SET "LG3=413"
) ELSE IF "%LCIDD%"=="1044" (
	SET "Localization=Norwegian"
	SET "LNG=NOR"
	SET "LG=NO"
	SET "LG3=414"
) ELSE IF "%LCIDD%"=="1045" (
	SET "Localization=Polish"
	SET "LNG=PLK"
	SET "LG=PL"
	SET "LG3=415"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="1046" (
	SET "Localization=Portuguese (Brazil)"
	SET "LNG=PTB"
	SET "LG=PTBR"
	SET "LG3=416"
) ELSE IF "%LCIDD%"=="1049" (
	SET "Localization=Russian"
	SET "LNG=RUS"
	SET "LG=RU"
	SET "LG3=419"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="1053" (
	SET "Localization=Swedish"
	SET "LNG=SVE"
	SET "LG=SV"
	SET "LG3=41d"
) ELSE IF "%LCIDD%"=="1055" (
	SET "Localization=Turkish"
	SET "LNG=TRK"
	SET "LG=TR"
	SET "LG3=41f"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="2052" (
	SET "Localization=Chinese (China)"
	SET "LNG=CHS"
	SET "LG=ZHCN"
	SET "LG3=804"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="2070" (
	SET "Localization=Portuguese"
	SET "LNG=PTG"
	SET "LG=PT"
	SET "LG3=816"
) ELSE IF "%LCIDD%"=="3076" (
	SET "Localization=Chinese (Hong Kong)"
	SET "LNG=CHT"
	SET "LG=ZHTW"
	SET "LG3=404"
	SET /A "NOIE7STRNGSRCH=1"
) ELSE IF "%LCIDD%"=="3082" (
	SET "Localization=Spanish"
	SET "LNG=ESN"
	SET "LG=ES"
	SET "LG3=c0a"
)
GOTO :EOF
REM ---------- ----------

REM ---------- WBEMOC.inf Fix ----------
:WBEMFIX
MD WORK\WBEMFIX
EXPAND HFCABS\wbemoc.cab -F:* WORK\WBEMFIX >NUL
IF NOT EXIST WORK\WBEMFIX\wbemoc*.txt (GOTO :EOF)
IF "%LNG%"=="ENU" (
	REN "WORK\WBEMFIX\wbemoc_ENU_%SUBTAG%.txt" wbemoc.inf
) ELSE (
	REN "WORK\WBEMFIX\wbemoc_UNI_%SUBTAG%.txt" wbemoc.inf
	IF EXIST WORK\WBEMFIX\wbemoc_%LNG%_str.txt (
		CMD /U/C "TYPE WORK\WBEMFIX\wbemoc_%LNG%_str.txt>>WORK\WBEMFIX\wbemoc.inf"
	) ELSE (
		CMD /U/C "TYPE WORK\WBEMFIX\wbemoc_UNI_str.txt>>WORK\WBEMFIX\wbemoc.inf"
	)
)
MAKECAB /D CompressionMemory=21 /D CompressionType=LZX WORK\WBEMFIX\wbemoc.inf /L WORK\WBEMFIX >NUL
REN WORK\WBEMFIX\wbemoc.in_ WBEMOC.in_
MOVE /Y WORK\WBEMFIX\WBEMOC.in_ %SOURCESS%\I386 >NUL
GOTO :EOF
REM ---------- ----------

REM ---------- TXTSETUP.sif Initialization ----------
:TXTSETUP_INIT
REM TODO Figure out what defining "EE" in HFANSWER.ini does.
IF DEFINED EE (
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif [SourceDisksFiles]
	GOTO :EOF
)
COPY SOURCE\I386\TXTSETUP.sif/A %SOURCESS%\I386\TXTSETUP.sif/B >NUL
IF "%VERSIONIE%"=="FDV" (MOVE /Y WORK\FDV\TXTSETUP.sif %SOURCESS%\I386)
ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
ECHO>>%SOURCESS%\I386\TXTSETUP.sif [SourceDisksFiles]
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLIPWU.inf = 1,,,,,,,20,0,0
SET /A "TXTDIRH9=1"
GOTO :EOF
REM ---------- ----------

REM ---------- DOSNET.inf Initialization ----------
:DOSNET_INIT
REM TODO Why are we checking IF DOSNET.inf EXISTs when most likely it *doesn't* EXIST at this point? Shouldn't I then check if TXTSETUP.sif
REM EXISTS in the function prior too if that's the case?
IF DEFINED EE IF EXIST %SOURCESS%\I386\DOSNET.inf (
	ECHO/>>%SOURCESS%\I386\DOSNET.inf
	ECHO>>%SOURCESS%\I386\DOSNET.inf [Files]
	GOTO :EOF
)
COPY SOURCE\I386\DOSNET.inf %SOURCESS%\I386 >NUL
IF "%VERSIONIE%"=="FDV" (MOVE /Y WORK\FDV\DOSNET.inf %SOURCESS%\I386)
ECHO/>WORK\DNOSDIR.txt
ECHO>>WORK\DNOSDIR.txt [OptionalSrcDirs]
ECHO>>WORK\DNOSDIR.txt svcpack
ECHO/>>%SOURCESS%\I386\DOSNET.inf
ECHO>>%SOURCESS%\I386\DOSNET.inf [Files]
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLIPWU.inf
GOTO :EOF
REM ---------- ----------

REM ---------- SYSOC.inf Initialization ----------
:SYSOC_INIT
REM Do the SYSOC.in_ file (the seed).
REM Thanks to LUPO for crafting this unicode stuff to make languages work correctly.

IF DEFINED EE (EXPAND -R %SOURCESS%\I386\SYSOC.in_ WORK)
IF NOT DEFINED EE IF NOT "%VERSIONIE%"=="FDV" IF EXIST SOURCE\I386\SYSOC.in_ (
	EXPAND -R SOURCE\I386\SYSOC.in_ WORK >NUL
) ELSE IF EXIST SOURCE\I386\SYSOC.inf (
	COPY /Y SOURCE\I386\SYSOC.inf WORK >NUL
)
IF "%VERSIONIE%"=="FDV" (MOVE /Y WORK\FDV\SYSOC.in_ WORK\SYSOC.inf)
REM Edited for flexibility.
FINDSTR /L "[Version]" WORK\SYSOC.inf >NUL
IF ERRORLEVEL 1 (SET /A "SYSOCUNI=1")
ECHO/>WORK\SYSOCOC.txt
ECHO>>WORK\SYSOCOC.txt [Components]
GOTO :EOF
REM ---------- ----------

REM ---------- HFSLIPWU.inf + HFREGWU.txt Initialization ----------
:HFSLIP_INIT
ECHO>%SOURCESS%\I386\HFSLIPWU.inf [Version]
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf Signature="$WINDOWS NT$"
ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [Optional Components]
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf WinUpdate
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf CLEANUP
ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [WinUpdate]
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf CopyFiles    = CFAdo,CFOle,PFIE,PFIELCID,PFIELG4,PFWMC2,PFWMP,PFWMPLCID,PFWMPNWS,PFWMPROX,PFWMPSKINS,MUIfall,NDIAG,SOFTDIST,SYS32,PFILES4,PFILES5
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf DelFiles     =
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf AddReg       = ROROE,HFSLIPREG
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf DelReg       =
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf UpdateInis   = AddLinks
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf OptionDesc   = "Hotfix Registry Edit"
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf Tip          = "Hotfix Registry Edit"
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf Modes        = 0,1,2,3
ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [CLEANUP]
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf CopyFiles  =
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf DelFiles   =
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf AddReg     = OTHER
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf OptionDesc = "HFSLIP OTHER"
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf Tip        = "Hotfix Registry Edit"
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf Modes      = 0,1,2,3
IF DEFINED CDTAG (
	ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [SourceDisksNames]
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf 1="Windows CD","!CDTAG!",,"\I386"
)

ECHO/>>WORK\HFREGWU.txt
ECHO>>WORK\HFREGWU.txt [RegisterFiles]
ECHO>>WORK\HFREGWU.txt RegisterDlls = ROROE

REM *@*
REM 2020-08-07:
REM "RegisterFiles moved to batch file HFSLPGUI.cmd"
REM "RegisterFiles transferred to the batnik HFSLPGUI.cmd"
REM ECHO/>>WORK\HFREGWU.txt
REM ECHO>>WORK\HFREGWU.txt [HFSLIPREG]
REM ECHO/>>WORK\HFREGWU.txt
REM ECHO>>WORK\HFREGWU.txt ;REGISTER inf/dll/etc T-18 before SVCPACK

REM only for RunOnceEx, simple RunOnce w/o Ex - not started on T-18!
REM IF DEFINED CMDHIDE (
REM 	ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\HFSLPGUI",HFSLPGUI,,"WScript.exe %%10%%\HFSLIP\!CMDHIDE! %%10%%\HFSLIP\HFSLPGUI.cmd BEFORESVCPACK"
REM ) ELSE (
REM 	ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\HFSLPGUI",HFSLPGUI,,"cmd.exe /c %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.cmd BEFORESVCPACK"
REM )

ECHO/>>WORK\HFREGWU.txt
ECHO>>WORK\HFREGWU.txt [HFSLIPREG]
ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\HFSLIPTotalSlipstream","DisplayName",0,"HFSLIP Total Slipstream (%HFSVER%-%HFSBUILD%)"
ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\HFSLIPTotalSlipstream","UninstallString",0,"CMD /C ECHO>ER.REG REGEDIT4&ECHO>>ER.REG [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\HFSLIPTotalSlipstream]&REGEDIT /S ER.REG&DEL /Q/F ER.REG"

REM TODO Wouldn't evgnb's patches make these irrelevant, or are they complimentary?

REM 2020-08-07: [merged from HFSLIP2000-1.0.2.cmd]
REM Disable warning during the setup that x:\i386\*.*_ is not signed, and if I want to install it anyway.
REM "https://msfn.org/board/topic/32125-hfslip-original-thread/page/13/?tab=comments#comment-353016"
REM HFSLIP (original thread) - by pene
ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Driver Signing","Policy",0x30001,0
REM but it's not working while hardware drivers install:
REM https://msfn.org/board/topic/158481-how-to-permanently-disable-driver-signing-during-windows-setup/
REM or use PatchPAE3 Version: 0.0.0.48 beta-6+

REM TODO Might require evgnb's :DIGICERTOFF patch.
REM todo: If W2K pre-SP2 then SfcDisable???
REM Disable WFP - SFC.dll (2000 SP2+) or SFC_OS.dll (XP) patch [SfcDisable == SFCSetting]
IF "%CERTPATCH%"=="1" (
	ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","SFCSetting",0x10001,0xFFFFFF9D
)

REM TODO The following line came from 1.7.10K V9. WHY ARE WE REGISTERING setupapi.dll?!?!? Just confused... Disabled until explained.
REM ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZA","1",0,"rundll32.exe %%11%%\setupapi.dll,InstallHinfSection RegisterFiles 128 %%17%%\HFSLIPWU.inf"
ECHO/>>WORK\ROROEWU.txt
ECHO>>WORK\ROROEWU.txt [ROROE]

REM *@*
REM create empty (size=0) file
REM TYPE NUL > WORK\ROROEWU.txt
GOTO :EOF
REM ---------- ----------

REM ---------- HFSLIP.cmd Initialization ----------
:UPDATE_INIT
REM *@*
REM ECHO>>WORK\HFSLIP.cmd.txt :SVCPACK
REM ECHO>>WORK\HFSLIP.cmd.txt SET HFSLIP=%%~2\..\
REM ECHO>>WORK\HFSLIP.cmd.txt SET HFSLIPSVC=%%~2\
REM ECHO/>>WORK\HFSLIP.cmd.txt
REM ECHO>>WORK\HFSLIP.cmd.txt REM T-13 SVCPACK.inf::SetupHotfixesToRun::CMDIDE.VBS
REM ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd SET HFSLIP=%%~dp0..\
REM ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd SET HFSLIPSVC=%%~dp0

ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd @ECHO OFF
IF DEFINED CMDHIDE (ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd !CMDHIDE!)
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd TITLE HFSLIP
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd FOR %%%%I IN ^(C D E F G H I J K L M N O P Q R S T U V W X Y Z^) DO (
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd 	IF EXIST %%%%I:\%MBOOTPATH%I386\SVCPACK ^(
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd 		SET "HFSLIP=%%%%I:\%MBOOTPATH%I386\"
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd 		SET "HFSLIPSVC=%%%%I:\%MBOOTPATH%I386\SVCPACK\"
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd 	^)
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd ^)

GOTO :EOF
REM ---------- ----------


REM ******************** Main ********************


REM ---------- Processing HFCABS ----------
:PROCESSCABS
TITLE %T1% - Basic CAB Files
ECHO/
ECHO Processing Basic CAB Files
ECHO/

MD WORK\CABS
DIR /B HFCABS>WORK\CABS.txt
FOR /F %%I IN ('FINDSTR /I "MUWEB MUCAT MUCLTUI WUWEB OPUC LEGIT OGA IEAWSDC SWFLASH" WORK\CABS.txt') DO (EXPAND -R HFCABS\%%I -F:* WORK\CABS >NUL)
IF EXIST WORK\CABS\legitcheck*.dll IF EXIST HF\*905474*.exe (
	XCOPY /DHY WORK\CABS\legitcheck*.dll WORK\I386E
	DEL /Q/F WORK\CABS\legitcheck*.dll
)
IF EXIST WORK\CABS\flash*.ocx (CALL :FLASHIT)
IF EXIST WORK\CABS\*.dll (DIR /B WORK\CABS\*.dll>>WORK\NSFREGt.txt)
IF EXIST WORK\CABS\*.cat (MOVE /Y WORK\CABS\*.cat WORK\SVCPACK)
IF EXIST WORK\CABS\opuc.dll (%MODIFYPE% WORK\CABS\opuc.dll -c)
IF EXIST WORK\CABS\*.dll.mui_* (XCOPY /DHY WORK\CABS\*.dll.mui_* WORK\I386E)
IF EXIST WORK\CABS\*.dll (XCOPY /DHY WORK\CABS\*.dll WORK\I386E)
IF EXIST WORK\CABS\FP_AX_CAB_INSTALLER.exe (
	IF NOT EXIST HFSVCPACK\FP_AX_CAB_INSTALLER.exe (ECHO>>WORK\FILESTODEL.txt HFSVCPACK\FP_AX_CAB_INSTALLER.exe)
	XCOPY /DHY WORK\CABS\FP_AX_CAB_INSTALLER.exe HFSVCPACK
)
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Flash Player ----------
:FLASHIT
TITLE %T1% - Flash Player
ECHO/
ECHO Processing Flash Player
ECHO/

SET /A "TXTDIR03=1"
IF EXIST SOURCE\I386\FLASH.OC* (
	SET "FLASHOCX=flash.ocx"
) ELSE (
	SET "FLASHOCX=swflash.ocx"
)
FOR /F %%I IN ('DIR /B WORK\CABS\flash*.ocx') DO (
	SET "FLASHOCXN=%%I"
	MOVE /Y WORK\CABS\%%I WORK\I386E\%FLASHOCX%
)
FOR /F %%I IN ('DIR /B WORK\CABS\*flash.inf') DO (FINDSTR /VI "Copy DelF waveF" WORK\CABS\%%I>WORK\I386E\swflash.inf)
IF "%VERSION%"=="XP" (
	FINDSTR /VBIR "flash\.ocx swflash\.ocx" %SOURCESS%\I386\TXTSETUP.sif>TXTSETUP.sif
	MOVE /Y TXTSETUP.sif %SOURCESS%\I386 >NUL
) ELSE (
	REM @;
	ECHO>>WORK\ROROEWU.txt ;SWFLASH
	REM *@*
	REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\swflash.inf,,1
	ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZCSWF,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\swflash.inf,DefaultInstall"
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif swflash.inf = 1,,,,,,,999,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swflash.inf
)
IF EXIST WORK\CABS\FlashUt*.exe FOR /F %%I IN ('DIR /B WORK\CABS\FlashUt*.exe') DO (
	MOVE /Y WORK\CABS\%%I WORK\I386E\swflash.exe
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif swflash.exe = 1,,,,,,,1003,0,0,%%I
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swflash.exe
)
IF EXIST WORK\CABS\FlashUt*.dll FOR /F %%I IN ('DIR /B WORK\CABS\FlashUt*.dll') DO (
	MOVE /Y WORK\CABS\%%I WORK\I386E\swflash.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif swflash.dll = 1,,,,,,,1003,0,0,%%I
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swflash.dll
)
IF EXIST WORK\CABS\FlashPlayerUpdateService.exe FOR /F %%I IN ('DIR /B WORK\CABS\FlashPlayerUpdateService.exe') DO (
	MOVE /Y WORK\CABS\%%I WORK\I386E\swflash.svc
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif swflash.svc = 1,,,,,,,1003,0,0,%%I
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swflash.svc
)
IF EXIST WORK\CABS\activex.vch FOR /F %%I IN ('DIR /B WORK\CABS\activex.vch') DO (
	MOVE /Y WORK\CABS\%%I WORK\I386E\activex.vch
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif activex.vch = 1,,,,,,,1003,0,0,%%I
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,activex.vch
)
IF EXIST WORK\CABS\mms.cfg FOR /F %%I IN ('DIR /B WORK\CABS\mms.cfg') DO (
	MOVE /Y WORK\CABS\%%I WORK\I386E\swflash.cfg
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif swflash.cfg = 1,,,,,,,1003,0,0,%%I
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swflash.cfg
)
IF EXIST WORK\CABS\Flash*.cpl FOR /F %%I IN ('DIR /B WORK\CABS\Flash*.cpl') DO (
	MOVE /Y WORK\CABS\%%I WORK\I386E\swflash.cpl
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif swflash.cpl = 1,,,,,,,2,0,0,%%I
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swflash.cpl
)
IF EXIST WORK\CABS\FlashPlayerApp.exe FOR /F %%I IN ('DIR /B WORK\CABS\FlashPlayerApp.exe') DO (
	MOVE /Y WORK\CABS\%%I WORK\I386E\swflcpl.exe
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif swflcpl.exe = 1,,,,,,,2,0,0,%%I
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swflcpl.exe
)
IF EXIST WORK\CABS\*.job FOR /F "delims=" %%I IN ('DIR /B WORK\CABS\*.job') DO (
		SET /A "TXTDIR37=1"
	MOVE /Y "WORK\CABS\%%I" WORK\I386E\swflash.job
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif swflash.job = 1,,,,,,,1037,0,0,"%%I"
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swflash.job
)

ECHO>>%SOURCESS%\I386\TXTSETUP.sif %FLASHOCX% = 1,,,,,,,1003,0,0,%FLASHOCXN%
IF NOT "%VERSION%"=="XP" (ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%FLASHOCX%)
SET "FLASHOCX="
SET "FLASHOCXN="
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- SVCPACK and First Logon Installers ----------
:SVCPACK_1STLOGON_INST
IF EXIST HF\*917275* IF NOT EXIST HFSVCPACK_SW1\msdrmclient.msi IF NOT EXIST HFGUIRUNONCE\msdrmclient.msi (
	FOR /F %%I IN ('DIR /B HF\*917275*') DO (HF\%%I /Q /X:WORK)
	XCOPY /DY WORK\msdrmclient.msi HFSVCPACK_SW1 >NUL
	ECHO>>WORK\FILESTODEL.txt HFSVCPACK_SW1\msdrmclient.msi
	XCOPY /DY WORK\rmclientbackcompat.msi HFSVCPACK_SW1 >NUL
	ECHO>>WORK\FILESTODEL.txt HFSVCPACK_SW1\rmclientbackcompat.msi
)
IF EXIST HF\*979099* IF NOT EXIST HFSVCPACK_SW1\msdrmclient.msi IF NOT EXIST HFGUIRUNONCE\msdrmclient.msi (
	FOR /F %%I IN ('DIR /B HF\*979099*') DO (HF\%%I /Q /X:WORK)
	XCOPY /DY WORK\msdrmclient.msi HFSVCPACK_SW1 >NUL
	ECHO>>WORK\FILESTODEL.txt HFSVCPACK_SW1\msdrmclient.msi
	XCOPY /DY WORK\rmclientbackcompat.msi HFSVCPACK_SW1 >NUL
	ECHO>>WORK\FILESTODEL.txt HFSVCPACK_SW1\rmclientbackcompat.msi
)
IF EXIST HFSVCPACK_SW1\*.msi (
	TITLE %T1% - MSI Files
	ECHO/
	ECHO MSI Files.
	ECHO/
	
	FOR /F %%I IN ('DIR /B/ON HFSVCPACK_SW1\*.msi') DO (
		ECHO %%I
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /i %%HFSLIPSVC%%%%I /qn /norestart ALLUSERS=1
	)
	TITLE %T1%
)
IF EXIST WORK\MCERU1.exe (
	ECHO>>WORK\HFSLPGUI.txt MCERU1.exe %SW1% /n
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif MCERU1.exe = 1,,,,,,,999,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,MCERU1.exe
	MOVE WORK\MCERU1.exe %SOURCESS%\I386 >NUL
	IF EXIST HF\*Center2005* (
		SET /A "MCEUP=1"
		FOR /F %%I IN ('DIR /B/ON HF\*Center2005*') DO (
			IF NOT "%%I"=="%MCERUEXE%" (
				ECHO>>WORK\HFSLPGUI.txt MCEUP!MCEUP!.exe %SW1% /n
				ECHO>>%SOURCESS%\I386\TXTSETUP.sif MCEUP!MCEUP!.exe = 1,,,,,,,999,0,0
				ECHO>>%SOURCESS%\I386\DOSNET.inf d1,MCEUP!MCEUP!.exe
				COPY HF\%%I %SOURCESS%\I386\MCEUP!MCEUP!.exe >NUL
				SET /A "MCEUP+=1"
			)
		)
		SET "MCEUP="
	)
)
FOR /F %%I IN ('DIR /B HFGUIRUNONCE') DO (SET /A "GUICNT=1")
IF DEFINED GUICNT (
	TITLE %T1% - GUIRunOnce Apps
	ECHO/
	ECHO Processing GUIRunOnce Apps
	ECHO/
	
	FOR /F "delims=" %%I IN ('DIR /B/ON HFGUIRUNONCE') DO (
		IF /I "%%~xI"==".msi" (
			ECHO %%I
			ECHO>>WORK\HFSLPGUI.txt MSIEXEC /i %%I /qn /norestart ALLUSERS=1
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFGUI!GUICNT!.msi = 1,,,,,,,999,0,0,"%%I"
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFGUI!GUICNT!.msi
			COPY "HFGUIRUNONCE\%%I" WORK\I386E\HFGUI!GUICNT!.msi >NUL
		) ELSE IF /I "%%~xI"==".exe" (
			ECHO %%I
			ECHO>>WORK\HFSLPGUI.txt %%I
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFGUI!GUICNT!.exe = 1,,,,,,,999,0,0,"%%I"
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFGUI!GUICNT!.exe
			COPY "HFGUIRUNONCE\%%I" %SOURCESS%\I386\HFGUI!GUICNT!.exe >NUL
		) ELSE IF /I "%%~xI"==".cmd" (
			ECHO %%I
			ECHO>>WORK\HFSLPGUI.txt CALL "%%I"
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFGUI!GUICNT!.cmd = 1,,,,,,,999,0,0,"%%I"
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFGUI!GUICNT!.cmd
			COPY "HFGUIRUNONCE\%%I" WORK\I386E\HFGUI!GUICNT!.cmd >NUL
		) ELSE IF /I "%%~xI"==".REG" (
			ECHO %%I
			ECHO>>WORK\HFSLPGUI.txt REGEDIT /S "%%I"
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFGUI!GUICNT!.REG = 1,,,,,,,999,0,0,"%%I"
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFGUI!GUICNT!.REG
			COPY "HFGUIRUNONCE\%%I" WORK\I386E\HFGUI!GUICNT!.REG >NUL
		) ELSE IF /I "%%~xI"==".inf" (
			ECHO %%I
			ECHO>>WORK\HFSLPGUI.txt rundll32.exe advpack.dll,LaunchINFSection %%I,DefaultInstall
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFGUI!GUICNT!.inf = 1,,,,,,,999,0,0,"%%I"
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFGUI!GUICNT!.inf
			COPY "HFGUIRUNONCE\%%I" WORK\I386E\HFGUI!GUICNT!.inf >NUL
		)
		SET /A "GUICNT+=1"
	)
	SET "GUICNT="
	TITLE %T1%
)
FOR /F %%I IN ('DIR /B/ON HFINFS\*.inf') DO (
	COPY "HFINFS\%%I" %SOURCESS%\I386 >NUL
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,999,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I
	REM *@*
	REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\%%I,,1
	REM TODO Hopefully I did this correctly.
	ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZA","!HFSLP!",,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\%%I,DefaultInstall"
	SET /A "HFSLP+=1"
)

IF EXIST HF\*926139* (SET /A "PSHELL=926139")
IF EXIST HF\*926140* (SET /A "PSHELL=926140")
IF DEFINED PSHELL (
	FOR /F %%I IN ('DIR /B HF\*!PSHELL!*') DO (COPY HF\%%I %SOURCESS%\I386\PSHELL.exe >NUL)
	ECHO>>WORK\HFSLPGUI.txt PSHELL.exe /passive /norestart
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif PSHELL.exe = 1,,,,,,,999,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,PSHELL.exe
	SET "PSHELL="
)
IF EXIST %SOURCESS%\I386\IE7_INST.exe (
	IF DEFINED IE7FCNT (
		ECHO>>WORK\HFSLPGUI.txt IE7_INST.exe
	) ELSE (
		ECHO>>WORK\HFSLPGUI.txt IE7_INST.exe /passive /norestart /update-no%IE7BKPSW%
	)
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif IE7_INST.exe = 1,,,,,,,999,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,IE7_INST.exe
)
GOTO :EOF
REM ---------- ----------

REM ---------- Slipstream Hotfixes ----------
:INTEGRATE
TITLE %T1% - Slipstreaming
ECHO/
ECHO Slipstreaming New Files
ECHO/

IF EXIST %SOURCESS%\I386\hscupd.cab (
	MOVE WORK\I386E\hscupd.exe %SOURCESS%\I386 >NUL
	DEL /Q/F %SOURCESS%\I386\hscupd.ex_
)
IF EXIST WORK\SUPPCABNEW (
	ECHO/
	ECHO Checking for updated SUPPORT\TOOLS\SUPPORT.cab content...
	IF NOT EXIST WORK\SUPPCAB (
		MD WORK\SUPPCAB
		EXPAND %SOURCESS%\SUPPORT\TOOLS\SUPPORT.cab -F:* WORK\SUPPCAB >NUL
	)
	XCOPY /DY WORK\SUPPCABNEW WORK\SUPPCAB
	DEL /Q/F %SOURCESS%\SUPPORT\TOOLS\SUPPORT.cab
	ECHO/
	ECHO Creating new SUPPORT.cab package...
	CALL :UNICAB1
	ECHO>>UC.ddf .Set CabinetNameTemplate=SUPPORT.cab
	ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\SUPPORT\TOOLS
	FOR /F %%I IN ('DIR /B/ON WORK\SUPPCAB') DO (ECHO>>UC.ddf WORK\SUPPCAB\%%I)
	CALL :UNICAB2
	ECHO/
)
FOR /F %%I IN ('DIR /B/A-D/ON WORK\I386E') DO (
	ECHO Processing %%I...
	IF EXIST %SOURCESS%\I386\%%I (
		COPY /Y WORK\I386E\%%I %SOURCESS%\I386 >NUL
	) ELSE (
		MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX WORK\I386E\%%I /L %SOURCESS%\I386 >NUL
	)
)
ECHO/
ECHO Locating compressed files in I386 subfolders
SET "BASEDIR=%SOURCESS%\I386\"
DIR /B/AD %SOURCESS%\I386>WORK\SSSI386SUB0.txt
FINDSTR /VBI "SVCPACK" WORK\SSSI386SUB0.txt>WORK\SSSI386SUB.txt
FOR /F "delims=" %%I IN (WORK\SSSI386SUB.txt) DO (DIR /B/S/A-D/ON "%SOURCESS%\I386\%%I">>WORK\SSSI386SUBALL.txt)
FINDSTR /ER "_" WORK\SSSI386SUBALL.txt>WORK\COMPRESSED.txt
FOR /F %%I IN (WORK\COMPRESSED.txt) DO (SET /A "COMPRESSED=1")
IF DEFINED COMPRESSED (
	FOR /F "delims=" %%I IN (WORK\COMPRESSED.txt) DO (
		SET "DIRNAME=%%~dpI"
		SET "PATHNAME=!DIRNAME:%BASEDIR%=!"
		FOR /F "tokens=1 delims=_" %%A IN ('ECHO %%~nxI') DO (
			IF EXIST WORK\I386E\!PATHNAME!%%A* (
				ECHO Processing !PATHNAME!%%A_  ******** -4-
				FOR /F "delims=" %%Q IN ('DIR /B WORK\I386E\!PATHNAME!%%A*') DO (
					IF EXIST %SOURCESS%\I386\!PATHNAME!%%Q (XCOPY /EHY WORK\I386E\!PATHNAME!%%Q %SOURCESS%\I386\!PATHNAME! >NUL)
					MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX WORK\I386E\!PATHNAME!%%Q /L %SOURCESS%\I386\!PATHNAME! >NUL
				)
				DEL /Q/F WORK\I386E\!PATHNAME!%%A*
			)
		)
	)
	SET "COMPRESSED="
	SET "DIRNAME="
	SET "PATHNAME="
)

SET "BASEDIR=%~dp0"
ECHO/
ECHO Locating remaining subfolder files
FOR /F %%I IN ('DIR /B/AD WORK\I386E') DO (
	IF EXIST %SOURCESS%\I386\%%I (XCOPY /EHY WORK\I386E\%%I %SOURCESS%\I386\%%I >NUL)
)

REM New section for non-I386 files from hotfixes -- Use for other stuff?
SET "BASEDIR=%~dp0WORK\CDROOT\"
FOR /F %%I IN ('DIR /B WORK\CDROOT') DO (SET /A "CDROOTSTUFF=1")
IF DEFINED CDROOTSTUFF (
	ECHO/
	ECHO Copying non-I386 files
	FOR /F "delims=" %%I IN ('DIR /B/S/A-D/ON WORK\CDROOT') DO (
		SET "ABSPATH=%%~dpI"
		SET "RELPATH=!ABSPATH:%BASEDIR%=!"
		FOR /F "delims=" %%Q IN ('DIR /B WORK\CDROOT\!RELPATH!%%~nxI') DO (
			ECHO Processing !RELPATH!%%~nxI ******** -5-
			IF NOT EXIST %SOURCESS%\!RELPATH! (MD %SOURCESS%\!RELPATH!)
			IF EXIST %SOURCESS%\!RELPATH!%%~nxI (
				COPY /Y WORK\CDROOT\!RELPATH!%%~nxI %SOURCESS%\!RELPATH! >NUL
			) ELSE (
				MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX WORK\CDROOT\!RELPATH!%%~nxI /L %SOURCESS%\!RELPATH! >NUL
			)
		)
	)
	SET "CDROOTSTUFF="
	SET "ABSPATH="
	SET "RELPATH="
)
SET "BASEDIR=%~dp0"
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- SVCPACK ----------
:SVCPACK
TITLE %T1% - SVCPACK
ECHO/
ECHO Processing SVCPACK.inf
ECHO/

ECHO>SVCPACK.inf [Version]
ECHO>>SVCPACK.inf Signature="$Windows NT$"
ECHO>>SVCPACK.inf MajorVersion=5
IF "%VERSION%"=="2000" (
	ECHO>>SVCPACK.inf MinorVersion=0
	ECHO>>SVCPACK.inf BuildNumber=2195
) ELSE IF "%VERSION%"=="XP" (
	ECHO>>SVCPACK.inf MinorVersion=1
	ECHO>>SVCPACK.inf BuildNumber=2600
) ELSE IF "%VERSION%"=="2003" (
	ECHO>>SVCPACK.inf MinorVersion=2
	ECHO>>SVCPACK.inf BuildNumber=3790
)
ECHO/>>SVCPACK.inf
ECHO>>SVCPACK.inf [SetupData]
ECHO>>SVCPACK.inf CatalogSubDir="i386\SVCPACK"
ECHO/>>SVCPACK.inf
ECHO>>SVCPACK.inf [ProductCatalogsToInstall]
IF EXIST WORK\SVCPACK\*.cat (XCOPY /DEHY WORK\SVCPACK %SOURCESS%\I386\SVCPACK)
IF DEFINED DELCATS (
	IF DEFINED DELCATS_OVERRIDE (
		MD WORK\CATFORCE
		FOR /F "tokens=2 delims==" %%I IN ('FINDSTR /BIR "DELCATS_OVERRIDE" HFANSWER.ini') DO (
			IF EXIST %SOURCESS%\I386\SVCPACK\%%I.cat (MOVE /Y %SOURCESS%\I386\SVCPACK\%%I.cat WORK\CATFORCE >NUL)
		)
	)
	IF EXIST %SOURCESS%\I386\SVCPACK\*.cat (DEL /Q/F %SOURCESS%\I386\SVCPACK\*.cat)
	IF EXIST WORK\CATFORCE\*.cat (MOVE /Y WORK\CATFORCE\*.cat %SOURCESS%\I386\SVCPACK >NUL)
)
IF EXIST %SOURCESS%\I386\SVCPACK\*.cat (DIR /B %SOURCESS%\I386\SVCPACK\*.cat>>SVCPACK.inf)
REM SVCPACK.inf ; this parograms runs from CD, directory is cd_drive:\I386\SVCPACK.
ECHO/>>SVCPACK.inf
ECHO>>SVCPACK.inf [SetupHotfixesToRun]
IF "%INSTALLRC%"=="1" (ECHO>>SVCPACK.inf "..\winnt32.exe /cmdcons /dudisable /unattend")
IF EXIST HFSVCPACK\*.exe (
	FOR /F "delims=" %%I IN ('DIR /B/ON HFSVCPACK\*.exe') DO (ECHO>>SVCPACK.inf %%I)
)


REM Tweaks
REM 2020-08-07: bugfix - "in Windows 2000 %path% during installation is only in system32, so you need to specify the full path."
IF EXIST HFSVCPACK\*.REG (
	FOR /F "delims=" %%I IN ('DIR /B/ON HFSVCPACK\*.REG') DO (ECHO>>WORK\HFSLIPCMDP1.cmd %%SYSTEMROOT%%\regedit.exe /s "%%HFSLIPSVC%%%%I")
)
IF EXIST HFSVCPACK\*.inf (
	FOR /F "delims=" %%I IN ('DIR /B/ON HFSVCPACK\*.inf') DO (ECHO>>WORK\HFSLIPCMDP1.cmd rundll32.exe advpack.dll,LaunchINFSection %%HFSLIPSVC%%%%I,,1)
)


IF EXIST HFSVCPACK_SW1\*.exe (
	FOR /F "delims=" %%I IN ('DIR /B/ON HFSVCPACK_SW1\*.exe') DO (ECHO>>SVCPACK.inf %%I %SW1%)
)
IF EXIST HFSVCPACK_SW2\*.exe (
	FOR /F "delims=" %%I IN ('DIR /B/ON HFSVCPACK_SW2\*.exe') DO (
		IF /I NOT "%%I"=="MP10Setup.exe" (ECHO>>SVCPACK.inf %%I %SW2%)
	)
)
IF EXIST HF\*840374* (
	ECHO>>SVCPACK.inf Q840374.exe %SW1% /o /n
	FOR /F %%I IN ('DIR /B HF\*840374*') DO (COPY HF\%%I %SOURCESS%\I386\SVCPACK\Q840374.exe >NUL)
)
IF EXIST HF\*914798* (
	ECHO>>SVCPACK.inf Q914798.exe %SW1% /nobackup
	FOR /F %%I IN ('DIR /B HF\*914798*') DO (COPY HF\%%I %SOURCESS%\I386\SVCPACK\Q914798.exe >NUL)
)
IF EXIST HF\*832483* (
	ECHO>>SVCPACK.inf "Q832483.exe /C:""dahotfix.exe /q /n"" /q:a"
	FOR /F %%I IN ('DIR /B HF\*832483*') DO (COPY HF\%%I %SOURCESS%\I386\SVCPACK\Q832483.exe >NUL)
)
IF EXIST HF\*923789* IF NOT EXIST HFCABS\SWFLASH.cab (
	ECHO>>SVCPACK.inf Q923789.exe %SW2%
	FOR /F %%I IN ('DIR /B HF\*923789*') DO (COPY HF\%%I %SOURCESS%\I386\SVCPACK\Q923789.exe >NUL)
)
IF EXIST HF\*cdwizard* (
	ECHO>>SVCPACK.inf CDWIZARD.exe %SW1%
	FOR /F %%I IN ('DIR /B HF\*cdwizard*') DO (COPY HF\%%I %SOURCESS%\I386\SVCPACK\CDWIZARD.exe >NUL)
)
IF EXIST HF\*wmcsetup* (
	ECHO>>SVCPACK.inf WMCSETUP.exe /q /n /z
	FOR /F %%I IN ('DIR /B HF\*wmcsetup*') DO (COPY HF\%%I %SOURCESS%\I386\SVCPACK\WMCSETUP.exe >NUL)
)
IF EXIST HF\*StepByStep* (
	ECHO>>SVCPACK.inf STEPBYS.exe /q /n /z /o
	FOR /F %%I IN ('DIR /B HF\*StepByStep*') DO (COPY HF\%%I %SOURCESS%\I386\SVCPACK\STEPBYS.exe >NUL)
)
IF EXIST %SOURCESS%\I386\SVCPACK\IE7_INST.exe (
	IF DEFINED IE7FCNT (
		ECHO>>SVCPACK.inf IE7_INST.exe
	) ELSE (
		ECHO>>SVCPACK.inf IE7_INST.exe %SW1% /update-no%IE7BKPSW%
	)
)
IF EXIST HFSVCPACK\*.cmd (DIR /B/ON HFSVCPACK\*.cmd>>SVCPACK.inf)
IF EXIST WORK\SVCMAIN.txt (
	FOR /F %%I IN (WORK\SVCMAIN.txt) DO (ECHO>>WORK\SVCBASE.txt %%I)
	FINDSTR /VBI /G:WORK\SVCBASE.txt SVCPACK.inf>WORK\SVCREAL.txt
	TYPE WORK\SVCMAIN.txt>>WORK\SVCREAL.txt
	TYPE WORK\SVCREAL.txt>SVCPACK.inf
)
IF EXIST FDVFILES\DELDIRS.cmd (
  COPY FDVFILES\DELDIRS.cmd %SOURCESS%\I386\SVCPACK\DELDIRS.cmd >NUL
  ECHO>>SVCPACK.inf DELDIRS.cmd
)
IF EXIST %SOURCESS%\I386\SVCPACK.IN* (DEL /Q/F %SOURCESS%\I386\SVCPACK.IN*)
MOVE SVCPACK.inf %SOURCESS%\I386
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- SPXCAB ----------
:SPXCAB
FOR /F %%I IN (WORK\DRV.txt) DO (
	IF EXIST WORK\I386E\%%I (
		SET /A "SPXPASS=1"
		SET /A "DRVUPD=1"
	)
)
IF EXIST HFEXPERT\SPXCAB (SET /A "SPXPASS=1")
IF NOT DEFINED SPXPASS (GOTO :EOF)
SET "SPXPASS="

TITLE %T1% - SPX.cab
ECHO/
ECHO Creating New SPX.cab
ECHO/

MD WORK\SPXCAB
ECHO/
IF DEFINED DRVUPD (
	ECHO Adding updated driver files
	FOR /F %%I IN (WORK\DRV.txt) DO (
		IF EXIST WORK\I386E\%%I (
			ECHO %%I
			COPY WORK\I386E\%%I WORK\SPXCAB >NUL
		)
	)
	SET "DRVUPD="
)
IF EXIST HFEXPERT\SPXCAB (CALL :HFEDRVCAB)
FINDSTR /IR "\[driver \[sp \." SOURCE\I386\DRVINDEX.inf>WORK\DRVCAB1.txt
FINDSTR /VR "=" WORK\DRVCAB1.txt>WORK\DRVCAB.txt
DIR /B/ON WORK\SPXCAB>WORK\SPXCABFILES.txt
FOR /F "tokens=2,3* delims== " %%I IN ('FINDSTR /BI Cabfiles SOURCE\I386\DRVINDEX.inf') DO (SET "CABFILESLINE=%%I")
ECHO>%SOURCESS%\I386\DRVINDEX.inf [Version]
ECHO>>%SOURCESS%\I386\DRVINDEX.inf Signature="$Windows NT$"
ECHO>>%SOURCESS%\I386\DRVINDEX.inf CabFiles=%CABFILESLINE%,SPX
FINDSTR /VBI /G:WORK\SPXCABFILES.txt WORK\DRVCAB.txt>>%SOURCESS%\I386\DRVINDEX.inf
ECHO>>%SOURCESS%\I386\DRVINDEX.inf [SPX]
TYPE WORK\SPXCABFILES.txt>>%SOURCESS%\I386\DRVINDEX.inf
FINDSTR /BIR "\[Cabs driver= sp1= sp2= sp3= sp4= sp5=" SOURCE\I386\DRVINDEX.inf>>%SOURCESS%\I386\DRVINDEX.inf
ECHO>>%SOURCESS%\I386\DRVINDEX.inf SPX=SPX.cab
SET "CABFILESLINE="

CALL :UNICAB1
ECHO>>UC.ddf .Set CabinetNameTemplate=SPX.cab
ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\I386
FOR /F %%I IN ('DIR /B/ON WORK\SPXCAB') DO (ECHO>>UC.ddf WORK\SPXCAB\%%I)
CALL :UNICAB2
FINDSTR /VBI DriverCabName %SOURCESS%\I386\TXTSETUP.sif>TXTSETUP.sif
ECHO>>TXTSETUP.sif SPX.cab = 1,,,,,,_x,39,0,0
MOVE /Y TXTSETUP.sif %SOURCESS%\I386
IF EXIST %SOURCESS%\I386\DOSNET.inf (ECHO>>%SOURCESS%\I386\DOSNET.inf d1,SPX.cab)
FOR /F "tokens=2,3* delims== " %%I IN ('FINDSTR /BI DriverCabName SOURCE\I386\TXTSETUP.sif') DO (SET "DRVCABLINE=%%I")
ECHO>WORK\TXTSDATA.txt DriverCabName=%DRVCABLINE%,SPX.cab
ECHO>>WORK\TXTFFLAG.txt SPX.cab = 16
SET "DRVCABLINE="
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- CAB EXPAND ----------
:CABEXPAND
REM DRVPASS is a "global" variable.
FOR /F %%I IN (WORK\DRV.txt) DO (
	IF EXIST WORK\I386E\%%I (
		SET /A "DRVPASS=1"
		SET /A "DRVUPD=1"
	)
)
FOR /F %%I IN ('DIR /B FDVFILES') DO (SET /A "DRVPASS=1")
IF EXIST HFCLEANUP (
	FOR /F %%I IN ('DIR /B HFCLEANUP') DO (
		IF /I NOT "%%~xI"==".EXT" (SET /A "DRVPASS=1")
	)
)
IF EXIST SOURCE\I386\SP%SP%.cab (SET /A "DRVPASS=1")
IF EXIST HFEXPERT\DRIVERCAB (SET /A "DRVPASS=1")
IF NOT DEFINED DRVPASS (GOTO :EOF)

TITLE %T1% - DRIVER.cab
ECHO/
ECHO Preparing New DRIVER.cab
ECHO/

DEL /Q/F %SOURCESS%\I386\DRIVER.cab
MD %SOURCESS%\I386\DRIVER
EXPAND SOURCE\I386\DRIVER.cab -F:* %SOURCESS%\I386\DRIVER
IF EXIST SOURCE\I386\SP%SP%.cab (
	DEL /Q/F %SOURCESS%\I386\SP*.cab
	MD WORK\SPUP
	EXPAND SOURCE\I386\SP%SP%.cab -F:* WORK\SPUP
	XCOPY /DEHY WORK\SPUP %SOURCESS%\I386\DRIVER
	ECHO Merged extracted driver packages into one folder.
	ECHO>WORK\TXTSDATA.txt DriverCabName=DRIVER.cab
	FINDSTR /VBI "DriverC SP1.cab SP2.cab SP3.cab SP4.cab SP5.cab" %SOURCESS%\I386\TXTSETUP.sif>TXTSETUP.sif
	MOVE /Y TXTSETUP.sif %SOURCESS%\I386
	IF EXIST %SOURCESS%\I386\DOSNET.inf (
		FINDSTR /VI "\,SP1.cab \,SP2.cab \,SP3.cab SP4.cab SP5.cab" %SOURCESS%\I386\DOSNET.inf>DOSNET.inf
		MOVE /Y DOSNET.inf %SOURCESS%\I386
	)
)

IF "%DX9%"=="Slipstreamed" (DEL /Q/F %SOURCESS%\I386\DRIVER\KS.sys)
IF DEFINED DRVUPD (
	ECHO/
	ECHO Adding updated driver files from hotfixes.
	FOR /F %%I IN (WORK\DRV.txt) DO (
		IF EXIST WORK\I386E\%%I (
			ECHO %%I
			COPY /Y WORK\I386E\%%I %SOURCESS%\I386\DRIVER >NUL
		)
	)
	SET "DRVUPD="
)
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Storage Drivers ----------
:HFSTOR
REM Thanks to OLEG II and Yzöwl for another great idea!
TITLE %T1% - Storage Drivers
ECHO/
ECHO Processing Storage Drivers
ECHO/

DIR /B HFEXPERT\STORAGE>HFSTOR.txt
DIR /B HFEXPERT\STORAGE\STORAGE*.ini>HFSTORI.txt
FOR /F %%I IN ('FINDSTR /VG:HFSTORI.txt HFSTOR.txt') DO (
	MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX HFEXPERT\STORAGE\%%I /L %SOURCESS%\I386 >NUL
	IF EXIST %SOURCESS%\I386\DOSNET.inf (ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I)
	IF /I "%%~xI"==".sys" (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,3_,4,1,,,1,4
		ECHO>>WORK\DNFF2.txt d1,%%I
	) ELSE IF /I "%%~xI"==".inf" (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,20,0,0,,1,20
	) ELSE (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,2,0,0,,1,2
	)
)
ECHO/>>WORK\STORSIF.txt
ECHO>>WORK\STORSIF.txt [SCSI.Load]
FOR /F %%I IN (HFSTORI.txt) DO (
	FOR /F "EOL=[ delims== " %%J IN ('FIND /V "\" ^<HFEXPERT\STORAGE\%%I') DO (
		IF EXIST HFEXPERT\STORAGE\%%J.sys (
			ECHO>>WORK\STORSIF.txt %%J = %%J.sys,4
		)
	)
)
FOR /F %%I IN (HFSTORI.txt) DO (
	ECHO/>>WORK\STORSIF.txt
	TYPE HFEXPERT\STORAGE\%%I>>WORK\STORSIF.txt
)
ECHO/>>WORK\STORSIF.txt
DEL /Q/F HFSTOR*.txt
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Cleanup ----------
:CLOSURE
REM Close SYSOC, HFSLIPWU, TXTSETUP and DOSNET.
TITLE %T1% - Closure
ECHO/
ECHO Cleanup
ECHO/

IF NOT DEFINED EE (
	IF EXIST WORK\SYSOCTMP.txt (TYPE WORK\SYSOCTMP.txt>>WORK\SYSOCOC.txt)
	ECHO>>WORK\SYSOCOC.txt WinUpdate=ocgen.dll,OcEntry,HFSLIPWU.inf,HIDE,7
	IF EXIST %SOURCESS%\I386\HFSLIPSD.inf (ECHO>>WORK\SYSOCOC.txt ShowDesktop=ocgen.dll,OcEntry,HFSLIPSD.inf,HIDE,7)
	IF EXIST WORK\SYSOCAAO.txt (TYPE WORK\SYSOCAAO.txt>>WORK\SYSOCOC.txt)
)
IF EXIST WORK\SYSOCOC.txt (
	IF DEFINED SYSOCUNI (
		CMD /U/C "TYPE WORK\SYSOCOC.txt>>WORK\SYSOC.inf"
	) ELSE (
		TYPE WORK\SYSOCOC.txt>>WORK\SYSOC.inf
	)
	IF EXIST SOURCE\I386\SYSOC.in_ (
		MAKECAB WORK\SYSOC.inf /L %SOURCESS%\I386 >NUL
	) ELSE IF EXIST SOURCE\I386\SYSOC.inf (
		COPY /Y WORK\SYSOC.inf %SOURCESS%\I386 >NUL
	)
)
IF EXIST WORK\HFSLPGUI.txt (CALL :HFSLIPGUI_CMD)
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLPGUI.inf = 1,,,,,,,999,0,0
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLPGUI.inf
ECHO>%SOURCESS%\I386\HFSLPGUI.inf [Version]
ECHO>>%SOURCESS%\I386\HFSLPGUI.inf Signature="$WINDOWS NT$"
ECHO>>%SOURCESS%\I386\HFSLPGUI.inf [HFSLIPGUI_Rem]
ECHO>>%SOURCESS%\I386\HFSLPGUI.inf AddReg=AddReg.Rem
ECHO>>%SOURCESS%\I386\HFSLPGUI.inf [HFSLIPGUI_Run]
ECHO>>%SOURCESS%\I386\HFSLPGUI.inf AddReg=AddReg.Run
ECHO>>%SOURCESS%\I386\HFSLPGUI.inf [AddReg.Rem]
IF NOT DEFINED NOCLEANUP (
	ECHO>>%SOURCESS%\I386\HFSLPGUI.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",HFSLIPGUI,0x20000,"CMD /C RD /Q/S %%WINDIR%%\HFSLIP"
)

IF EXIST WORK\HFSLIPCMDP1.cmd (
	REM *@*
	REM CALL :UPDATE_INIT
	REM TYPE WORK\HFSLIPCMDP1.cmd>>WORK\HFSLIP.cmd.txt
	
	TYPE WORK\HFSLIPCMDP1.cmd>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd
	
	REM TODO In HFSLIP2000, additional code is tacked-onto HFSLIP.cmd. Not Sure if it's meaningful. Further testing would be required.
	
	REM IF NOT EXIST HFSVCPACK\*.exe (
	REM 	TYPE WORK\HFSLIPCMDP1.cmd>>SOURCESS\I386\SVCPACK\HFSLIP.cmd
	REM ) ELSE (
	REM 	ECHO>>SOURCESS\I386\SVCPACK\HFSLIP.cmd IF EXIST %%SYSTEMROOT%%\HFSLIP.TMP GOTO :PART2
	REM 	ECHO>>SOURCESS\I386\SVCPACK\HFSLIP.cmd ECHO/^>%%SYSTEMROOT%%\HFSLIP.TMP
	REM 	TYPE WORK\HFSLIPCMDP1.cmd>>SOURCESS\I386\SVCPACK\HFSLIP.cmd
	REM 	ECHO>>SOURCESS\I386\SVCPACK\HFSLIP.cmd GOTO :EOF
	REM 	ECHO>>SOURCESS\I386\SVCPACK\HFSLIP.cmd :PART2
	REM )
)

REM Fix Jan 7 2009.
ECHO>>%SOURCESS%\I386\HFSLPGUI.inf HKLM,"Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0002E510-0000-0000-C000-000000000046}","Compatibility Flags",0x10001,0x400
IF EXIST WORK\HFSLPGUI.txt (
	REM *@*
	REM ECHO/>>WORK\HFSLIP.cmd.txt
	REM ECHO>>WORK\HFSLIP.cmd.txt REM prepare RunOnce for 1st user logon
	REM ECHO>>WORK\HFSLIP.cmd.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.inf,HFSLIPGUI_Run
	ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.inf,HFSLIPGUI_Run
	ECHO>>%SOURCESS%\I386\HFSLPGUI.inf [AddReg.Run]
	REM fix jan 7 2009
	ECHO>>%SOURCESS%\I386\HFSLPGUI.inf HKLM,"Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0002E510-0000-0000-C000-000000000046}","Compatibility Flags",0x10001,0x400
	IF DEFINED CMDHIDE (
		REM *@*
		REM ECHO>>%SOURCESS%\I386\HFSLPGUI.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",HFSLIPGUI,0x20000,"WScript.exe %%10%%\HFSLIP\!CMDHIDE! %%10%%\HFSLIP\HFSLPGUI.cmd RUNONCE"
		ECHO>>%SOURCESS%\I386\HFSLPGUI.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",HFSLIPGUI,0x20000,"CMD /C !CMDHIDE!&%%SYSTEMROOT%%\HFSLIP\HFSLPGUI.cmd"
	) ELSE (
		REM *@*
		REM ECHO>>%SOURCESS%\I386\HFSLPGUI.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",HFSLIPGUI,0x20000,"cmd.exe /C %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.cmd RUNONCE"
		ECHO>>%SOURCESS%\I386\HFSLPGUI.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",HFSLIPGUI,0x20000,"CMD /C %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.cmd"
	)
) ELSE (
	REM *@*
	REM ECHO>>WORK\RGSVRWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.inf,HFSLIPGUI_Rem
	ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.inf,HFSLIPGUI_Rem
)
REM *@*
REM IF NOT EXIST WORK\HFSLIP.cmd.txt (GOTO :CL_NOSVCPCK)

REM [SetupHotfixesToRun] lines in SVCPACK.inf runs from CD [not drive C:],
REM directory is cd_drive:\I386\SVCPACK; CatalogSubDir="i386\SVCPACK" is line from SVCPACK.inf.
REM This is hack for ugly CreateProcessW in svcpack.dll, that run every lines in SVCPACK.inf::SetupHotfixesToRun section.
REM You need copy wscript.exe to I386\SVCPACK to use VBScript in SetupHotfixesToRun 
REM CreateProcessW adds to left part every line string "...i386\SVCPACK\" and you may run programs in that directory only.

REM *@*
REM ECHO>>%SOURCESS%\I386\SVCPACK.inf wscript.exe "%%10%%\HFSLIP\CMDHIDE.VBS" %%10%%\HFSLIP\HFSLPGUI.cmd SVCPACK
REM COPY /b /y WORK\I386E\wscript.exe %SOURCESS%\I386\SVCPACK\wscript.exe
REM :CL_NOSVCPCK
REM ECHO>>%SOURCESS%\I386\SVCPACK.inf ;END OF FILE

REM 2020-08-07:
REM ECHO>>%SOURCESS%\I386\TXTSETUP.sif CMDHIDE.VBS = 1,,,,,,,999,0,0
REM ECHO>>%SOURCESS%\I386\DOSNET.inf d1,CMDHIDE.VBS
REM ECHO> %SOURCESS%\I386\CMDHIDE.VBS REM Simple cmdhide implementation in VBScript - run command with hide window
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS Set objArgs = WScript.Arguments
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS strCmd = ""
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS For Each strArg In objArgs
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS     If CBool ^(   InStr^(strArg, chr^(32^)^) + Instr^(strArg, chr^(9^)^)   ^) Then strArg=Chr^(34^) ^& strArg ^& Chr^(34^)
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS     strCmd = strCmd ^& strArg ^& " "
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS Next
REM SVCPACK.inf fix - get path of WSH-server in i386\SVCPACK to determine CD path to hotfixes to install

REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS strPath=CreateObject^("Scripting.FileSystemObject"^).GetParentFolderName^(WScript.FullName^)
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS strPath=Chr^(34^) ^& strPath ^& Chr^(34^)
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS If WScript.Arguments.Count^>1 Then If Ucase^(WScript.Arguments^(1^)^) = "SVCPACK" Then strCmd = strCmd ^& strPath
REM reaplce to intWindowStyle=1 for visible cmd.exe window for debug

REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS intWindowStyle=0
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS bWaitOnReturn=True
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS On Error Resume Next
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS     WScript.CreateObject^("WScript.Shell"^).Run strCmd, intWindowStyle, bWaitOnReturn
REM ECHO>>%SOURCESS%\I386\CMDHIDE.VBS On Error Goto 0

IF EXIST %SOURCESS%\I386\SVCPACK\HFSLIP.cmd (ECHO>>%SOURCESS%\I386\SVCPACK.inf HFSLIP.cmd)

IF EXIST WORK\HHIVADD.txt (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLPHIV.inf = 1,,,,,,_x,3,,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLPHIV.inf
	ECHO>>WORK\HIVEINFS.txt AddReg = HFSLPHIV.inf,AddReg
	ECHO>%SOURCESS%\I386\HFSLPHIV.inf [Version]
	ECHO>>%SOURCESS%\I386\HFSLPHIV.inf Signature="$Windows NT$"
	ECHO>>%SOURCESS%\I386\HFSLPHIV.inf [AddReg]
	TYPE WORK\HHIVADD.txt>>%SOURCESS%\I386\HFSLPHIV.inf
	IF EXIST WORK\HHIVSTR.txt (
		ECHO>>%SOURCESS%\I386\HFSLPHIV.inf [Strings]
		TYPE WORK\HHIVSTR.txt>>%SOURCESS%\I386\HFSLPHIV.inf
	)
)
ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
ECHO>>%SOURCESS%\I386\TXTSETUP.sif [WinntDirectories]
IF EXIST WORK\TXTNTDIR.txt (TYPE WORK\TXTNTDIR.txt>>%SOURCESS%\I386\TXTSETUP.sif)
IF DEFINED TXTDIRH9 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 999 = HFSLIP)
IF DEFINED TXTDIR00 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1000 = "system32\PreInstall\WinSE\!TXTDIR00!")
IF DEFINED TXTDIR01 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1001 = "system32\Windows Media\Server")
IF DEFINED TXTDIR02 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1002 = "system32\netmon")
IF DEFINED TXTDIR03 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1003 = "system32\Macromed\Flash")
IF DEFINED TXTDIR04 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1004 = "system32\drivers\umdf")
IF DEFINED TXTDIR05 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1005 = "system32\%MUICD%")
IF DEFINED TXTDIR06 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1006 = "system32\!TXTDIR06!")
IF DEFINED TXTDIR07 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1007 = "system32\BITS")
IF DEFINED TXTDIR08 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1008 = "system32\MUI\!TXTDIR08!")
IF DEFINED TXTDIR09 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1009 = "system32\MUI\0%LG3%")
IF DEFINED TXTDIR30 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1030 = "Network Diagnostic")
IF DEFINED TXTDIR31 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1031 = "WBEM")
IF DEFINED TXTDIR32 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1032 = "Offline Web Pages")
IF DEFINED TXTDIR33 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1033 = "Downloaded Program Files")
IF DEFINED TXTDIR34 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1034 = "inf\IEM\0%LG3%")
IF DEFINED TXTDIR35 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1035 = "Installer\TSClientMsiTrans")
IF DEFINED TXTDIR36 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1036 = "Microsoft.NET\Framework\v1.0.3705")
IF DEFINED TXTDIR37 (ECHO>>%SOURCESS%\I386\TXTSETUP.sif 1037 = "Tasks")
IF EXIST WORK\TXTSDATA.txt (
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif [SetupData]
	TYPE WORK\TXTSDATA.txt>>%SOURCESS%\I386\TXTSETUP.sif
)
IF EXIST WORK\HIVEINFS.txt (
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif [HiveInfs.Fresh]
	TYPE WORK\HIVEINFS.txt>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif [HiveInfs.Upgrade]
	TYPE WORK\HIVEINFS.txt>>%SOURCESS%\I386\TXTSETUP.sif
)
IF EXIST WORK\TXTOTHER.txt (
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	TYPE WORK\TXTOTHER.txt>>%SOURCESS%\I386\TXTSETUP.sif
)
IF NOT DEFINED EE (CALL :ADDFFLAGS)
IF EXIST WORK\TXTFFLAG.txt (
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif [FileFlags]
	TYPE WORK\TXTFFLAG.txt>>%SOURCESS%\I386\TXTSETUP.sif
)
IF EXIST WORK\STORSIF.txt (TYPE WORK\STORSIF.txt>>%SOURCESS%\I386\TXTSETUP.sif)
IF EXIST WORK\DNFF2.txt (
	ECHO/>>%SOURCESS%\I386\DOSNET.inf
	ECHO>>%SOURCESS%\I386\DOSNET.inf [FloppyFiles.2]
	TYPE WORK\DNFF2.txt>>%SOURCESS%\I386\DOSNET.inf
)
IF EXIST WORK\DNOSDIR.txt (TYPE WORK\DNOSDIR.txt>>%SOURCESS%\I386\DOSNET.inf)
IF DEFINED EE (GOTO :EOF)
TYPE WORK\HFREGWU.txt>>%SOURCESS%\I386\HFSLIPWU.inf
IF EXIST WORK\ADDLNK.txt (
	ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [AddLinks]
	TYPE WORK\ADDLNK.txt>>%SOURCESS%\I386\HFSLIPWU.inf
)
IF EXIST WORK\HFS_SOFTDIST.txt (ECHO>>WORK\HFSDST.txt SOFTDIST=10,"SoftwareDistribution")
IF EXIST WORK\HFS_SYS32.txt (ECHO>>WORK\HFSDST.txt SYS32=11)
IF EXIST WORK\HFSDST.txt (
	ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [DestinationDirs]
	TYPE WORK\HFSDST.txt>>%SOURCESS%\I386\HFSLIPWU.inf
)
IF DEFINED CUSTSATSDF (ECHO>>WORK\HFSSDF.txt custsat.dll=1)
IF EXIST WORK\HFSSDF.txt (
	ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [SourceDisksFiles]
	TYPE WORK\HFSSDF.txt>>%SOURCESS%\I386\HFSLIPWU.inf
)
IF EXIST WORK\HFS_*.txt FOR /F "tokens=2 delims=_." %%I IN ('DIR /B WORK\HFS_*.txt') DO (
	ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [%%I]
	TYPE WORK\HFS_%%I.txt>>%SOURCESS%\I386\HFSLIPWU.inf
)
IF EXIST WORK\HFSPF4.txt (
	ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [PFILES4]
	TYPE WORK\HFSPF4.txt>>%SOURCESS%\I386\HFSLIPWU.inf
)
IF EXIST WORK\HFSPF5.txt (
	ECHO/>>%SOURCESS%\I386\HFSLIPWU.inf
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf [PFILES5]
	TYPE WORK\HFSPF5.txt>>%SOURCESS%\I386\HFSLIPWU.inf
)

TYPE WORK\ROROEWU.txt>>%SOURCESS%\I386\HFSLIPWU.inf
IF EXIST WORK\RGSVRWU.txt (
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf ;REGISTER FILES
	TYPE WORK\RGSVRWU.txt>>%SOURCESS%\I386\HFSLIPWU.inf
)

IF DEFINED IERNONCE (
	REM *@*
	REM ECHO/>>WORK\HFSLIP.cmd.txt
	REM ECHO>>WORK\HFSLIP.cmd.txt REM FINALIZES THE DX9 INSTALLATION - 2K
	REM ECHO>>WORK\HFSLIP.cmd.txt rundll32.exe iernonce.dll,RunOnceExProcess
	REM ECHO/>>WORK\HFSLIP.cmd.txt
	ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd rundll32.exe iernonce.dll,RunOnceExProcess
	SET "IERNONCE="
)
REM *@*
REM IF EXIST WORK\hscupd.cmd FINDSTR /I HSCUpd WORK\hscupd.cmd>>WORK\HFSLIP.cmd.txt

IF EXIST WORK\hscupd.cmd (FINDSTR /I HSCUpd WORK\hscupd.cmd>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd)
FOR /F "delims=" %%I IN ('DIR /B HFSVCPACK') DO (
	COPY /Y "HFSVCPACK\%%I" %SOURCESS%\I386\SVCPACK >NUL
)
FOR /F "delims=" %%I IN ('DIR /B HFSVCPACK_SW1') DO (
	COPY /Y "HFSVCPACK_SW1\%%I" %SOURCESS%\I386\SVCPACK >NUL
)
FOR /F "delims=" %%I IN ('DIR /B HFSVCPACK_SW2') DO (
	COPY /Y "HFSVCPACK_SW2\%%I" %SOURCESS%\I386\SVCPACK >NUL
)
REM I hate Windows Media Player 10.
IF EXIST HFSVCPACK_SW2\MP10Setup.exe (
	REM *@*
	REM ECHO>>WORK\HFSLIP.cmd.txt %%HFSLIPSVC%%MP10Setup.exe /C:"setup_wm.exe /Q:A /R:N /DisallowSystemRestore"
	ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd %%HFSLIPSVC%%MP10Setup.exe /C:"setup_wm.exe /Q:A /R:N /DisallowSystemRestore"
)
REM *@*
REM 2020-08-07: [merged from HFSLIP2000-1.0.2.cmd]
REM At final, cleanup *.TMP
REM WORK\HFSLIPCMDP1.cmd - %SOURCESS%\I386\SVCPACK\HFSLIP.cmd
REM ECHO>>WORK\HFSLIP.cmd.txt IF EXIST %%SYSTEMROOT%%\*.TMP ^(
REM ECHO>>WORK\HFSLIP.cmd.txt    ATTRIB -R %%SYSTEMROOT%%\*.TMP
REM ECHO>>WORK\HFSLIP.cmd.txt    DEL /Q/F %%SYSTEMROOT%%\*.TMP
REM ECHO>>WORK\HFSLIP.cmd.txt ^)
REM ECHO>>WORK\HFSLIP.cmd.txt GOTO :EOF
REM ECHO>>WORK\HFSLIP.cmd.txt EXIT

ECHO/>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd IF EXIST %%SYSTEMROOT%%\*.TMP ^(
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd 	ATTRIB -R %%SYSTEMROOT%%\*.TMP
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd 	DEL /Q/F %%SYSTEMROOT%%\*.TMP
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd ^)
ECHO>>%SOURCESS%\I386\SVCPACK\HFSLIP.cmd EXIT /b

REM ECHO/>>%SOURCESS%\I386\HFSLPGUI.cmd
REM TYPE WORK\HFSLIP.cmd.txt>>%SOURCESS%\I386\HFSLPGUI.cmd
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Finalize HFSLIPGUI.cmd ----------
:HFSLIPGUI_CMD
REM *@*
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd @ECHO OFF
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd ECHO [%%1] [%%2] [%%3]
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd CD %%SYSTEMROOT%%\HFSLIP
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd IF "%%1"=="BEFORESVCPACK" ^(GOTO :BEFORESVCPACK^)
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd IF "%%1"=="RUNONCE" ^(GOTO :RUNONCE^)
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd IF "%%1"=="SVCPACK" ^(GOTO :SVCPACK^)
REM ECHO/>>%SOURCESS%\I386\HFSLPGUI.cmd
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd REM else auto-install script on T-18
REM CHO>>%SOURCESS%\I386\HFSLPGUI.cmd SET SSIP=Y
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd %%SYSTEMROOT%%\REGEDIT /S/E SSIP1.txt "HKEY_LOCAL_MACHINE\SYSTEM\Setup"
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd TYPE SSIP1.txt^>SSIP2.txt
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd FOR /F %%%%I IN ^('FINDSTR /IR "SystemSetupInProgress.=dword:00000000" SSIP2.txt'^) DO ^(SET SSIP=N^)
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd IF "%%SSIP%%"=="Y" ^(rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.inf,HFSLIPGUI_Run^)
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd GOTO :EOF
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd EXIT
REM ECHO/>>%SOURCESS%\I386\HFSLPGUI.cmd
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd :RUNONCE
REM TYPE WORK\HFSLPGUI.txt>>%SOURCESS%\I386\HFSLPGUI.cmd
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd rundll32.exe advpack.dll,LaunchINFSection %%WINDIR%%\HFSLIP\HFSLPGUI.inf,HFSLIPGUI_Rem
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd GOTO :EOF
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd EXIT

REM 2020-08-07: "W2k does not understand the RegisterDlls directive in inf files, so we move it to a separate batch file:"
REM ECHO/>>%SOURCESS%\I386\HFSLPGUI.cmd
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd :BEFORESVCPACK
REM TYPE WORK\ROROEWU.txt>>%SOURCESS%\I386\HFSLPGUI.cmd
REM IF EXIST WORK\RGSVRWU.txt (
REM 	ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd ::REGISTER FILES
REM 	TYPE WORK\RGSVRWU.txt>>%SOURCESS%\I386\HFSLPGUI.cmd
REM )
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd GOTO :EOF
REM ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd EXIT
REM ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLPGUI.cmd = 1,,,,,,,999,0,0
REM ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLPGUI.cmd

ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd @ECHO OFF
IF DEFINED CMDHIDE (ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd !CMDHIDE!)
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd CD %%SYSTEMROOT%%\HFSLIP
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd SET SSIP=Y
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd %%SYSTEMROOT%%\REGEDIT /S/E SSIP1.txt "HKEY_LOCAL_MACHINE\SYSTEM\Setup"
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd TYPE SSIP1.txt^>SSIP2.txt
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd FOR /F %%%%I IN ^('FINDSTR /IR "SystemSetupInProgress.=dword:00000000" SSIP2.txt'^) DO ^(SET "SSIP=N"^)
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd IF "%%SSIP%%"=="Y" ^(
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd 	rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLPGUI.inf,HFSLIPGUI_Run
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd 	EXIT /b
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd ^)
TYPE WORK\HFSLPGUI.txt>>%SOURCESS%\I386\HFSLPGUI.cmd
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd rundll32.exe advpack.dll,LaunchINFSection %%WINDIR%%\HFSLIP\HFSLPGUI.inf,HFSLIPGUI_Rem
ECHO>>%SOURCESS%\I386\HFSLPGUI.cmd EXIT /b
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLPGUI.cmd = 1,,,,,,,999,0,0
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLPGUI.cmd

GOTO :EOF
REM ---------- ----------

REM ---------- CAB Compact ----------
:CABCOMPACT
TITLE %T1% - DRIVER.cab
ECHO/
ECHO Creating Updated DRIVER.cab and Driver Information File
ECHO/

CALL :UNICAB1
ECHO>>UC.ddf .Set CabinetNameTemplate=DRIVER.cab
ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\I386
FOR /F %%I IN ('DIR /B/ON %SOURCESS%\I386\DRIVER') DO (ECHO>>UC.ddf %SOURCESS%\I386\DRIVER\%%I)

ECHO Creating new DRIVER.cab...
MAKECAB /F UC.ddf
DEL /Q/F UC.ddf SETUP.inf SETUP.RPT

ECHO>%SOURCESS%\I386\DRVINDEX.inf [Version]
ECHO>>%SOURCESS%\I386\DRVINDEX.inf Signature="$Windows NT$"
ECHO>>%SOURCESS%\I386\DRVINDEX.inf CabFiles=driver
ECHO>>%SOURCESS%\I386\DRVINDEX.inf [driver]
DIR /B/ON %SOURCESS%\I386\DRIVER>>%SOURCESS%\I386\DRVINDEX.inf
ECHO>>%SOURCESS%\I386\DRVINDEX.inf [Cabs]
ECHO>>%SOURCESS%\I386\DRVINDEX.inf driver=DRIVER.cab
RD /Q/S %SOURCESS%\I386\DRIVER
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Useless Binaries ----------
:DELBIN
IF DEFINED VERSION IF EXIST HFCLEANUP\!VERSION!SP%SP%.EXT (SET "DELBINFILE=!VERSION!SP%SP%.EXT")
IF NOT DEFINED DELBINFILE (
	FOR /F %%I IN ('DIR /B HFCLEANUP\*.EXT') DO (SET "DELBINFILE=%%I")
)
IF DEFINED DELBINFILE (
	ECHO/
	ECHO Removing duplicate and/or obsolete files in %SOURCESS%\I386...
	FOR /F "delims=" %%I IN (HFCLEANUP\!DELBINFILE!) DO (
		IF EXIST "%SOURCESS%\I386\%%I" (
			DEL /Q/F "%SOURCESS%\I386\%%I"
			ECHO Removed %%I
		)
	)
	SET "DELBINFILE="
)
GOTO :EOF
REM ---------- ----------

REM ---------- FDV Cleanup Utility ----------
:FDVFILESCLEANUP
TITLE %T1% - FDV Cleanup
ECHO/
ECHO FDV Cleanup
ECHO/

REM @;
ECHO>>%SOURCESS%\I386\HFSLIPWU.inf ;FDV
REM *@*
REM ECHO>>%SOURCESS%\I386\HFSLIPWU.inf 11,,rundll32.exe,,,"advpack.dll,LaunchINFSection %%10%%\inf\ie.inf,FDVPATCH"
REM ECHO>>%SOURCESS%\I386\HFSLIPWU.inf 11,,rundll32.exe,,,"advpack.dll,LaunchINFSection %%10%%\inf\shell.inf,FDVPATCH"
REM ECHO>>%SOURCESS%\I386\HFSLIPWU.inf 11,,rundll32.exe,,,"advpack.dll,LaunchINFSection %%10%%\inf\axant5.inf,FDVPATCH"
ECHO>>SOURCESS\I386\HFSLIPWU.inf HKLM,"Software\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",990,0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\inf\ie.inf,FDVPATCH"
ECHO>>SOURCESS\I386\HFSLIPWU.inf HKLM,"Software\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",991,0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\inf\shell.inf,FDVPATCH"
ECHO>>SOURCESS\I386\HFSLIPWU.inf HKLM,"Software\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",992,0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\inf\axant5.inf,FDVPATCH"

IF EXIST FDVFILES\TXTSETUP.sif (
	ECHO Gathering data to edit setup information files...
	FINDSTR /B ";" FDVFILES\TXTSETUP.sif>>WORK\FDVTXT1.txt
	FINDSTR ",,," WORK\FDVTXT1.txt>>WORK\FDVTXT2.txt
	FOR /F "tokens=1 delims=;= " %%I IN (WORK\FDVTXT2.txt) DO (ECHO>>WORK\FDVTXT.txt %%I)
	ECHO Deleting from setup information files:
	FOR /F %%I IN (WORK\FDVTXT.txt) DO (
		ECHO %%I
		FINDSTR /VI "%%I" %SOURCESS%\I386\HFSLIPWU.inf>HFSLIPWU.inf
		MOVE /Y HFSLIPWU.inf %SOURCESS%\I386
		FINDSTR /VBI "%%I" %SOURCESS%\I386\TXTSETUP.sif>TXTSETUP.sif
		MOVE /Y TXTSETUP.sif %SOURCESS%\I386
		IF EXIST %SOURCESS%\I386\DOSNET.inf (
			FINDSTR /VEI "%%I" %SOURCESS%\I386\DOSNET.inf>DOSNET.inf
			MOVE /Y DOSNET.inf %SOURCESS%\I386
		)
	)
)
IF EXIST FDVFILES\DELFILES.txt (
	ECHO Removing files from new source...
	FOR /F %%I IN (FDVFILES\DELFILES.txt) DO (
		IF EXIST %SOURCESS%\I386\%%I (
			ECHO %SOURCESS%\I386\%%I
			DEL /Q/F %SOURCESS%\I386\%%I
		)
		SET "FDVFILEEXT=%%~xI"
		IF NOT DEFINED FDVFILEEXT (
			IF EXIST %SOURCESS%\I386\%%I._ (
				ECHO %SOURCESS%\I386\%%I._
				DEL /Q/F %SOURCESS%\I386\%%I._
			)
		) ELSE IF EXIST %SOURCESS%\I386\%%I_ (
			ECHO %SOURCESS%\I386\%%I_
			DEL /Q/F %SOURCESS%\I386\%%I_
		) ELSE (
			SET "FDVFILEEXT=!FDVFILEEXT:~0,-1!"
			IF EXIST %SOURCESS%\I386\%%~nI!FDVFILEEXT!_ (
				ECHO %SOURCESS%\I386\%%~nI!FDVFILEEXT!_
				DEL /Q/F %SOURCESS%\I386\%%~nI!FDVFILEEXT!_
			)
		)
		SET "FDVFILEEXT="
	)
)
TITLE %T1%
GOTO :EOF
REM ---------- ----------


REM ******************** Internet Explorer ********************


REM ---------- IE6 Slipstreamer ----------
:IE6SLIP
TITLE %T1% - IE6SP1
ECHO/
ECHO Processing Internet Explorer 6 SP1
ECHO/

MD WORK\IE6EXP2 WORK\OE6EXP
IF EXIST HFCABS\_IE6_HFSLIP.cab IF EXIST HFCABS\_IE6b_HFSLIP.cab IF EXIST HFCABS\_OE6_HFSLIP.cab (SET /A "IE6CCABS=1")
IF NOT DEFINED IE6CCABS (
	CALL :IE6_EXPAND
) ELSE (
	ECHO Expanding custom IE6 cabs...
	EXPAND HFCABS\_IE6_HFSLIP.cab -F:* WORK\IE6EXP >NUL
	EXPAND HFCABS\_IE6b_HFSLIP.cab -F:* WORK\IE6EXP2 >NUL
	EXPAND HFCABS\_OE6_HFSLIP.cab -F:* WORK\OE6EXP >NUL
	SET "IE6CCABS="
)
SET /A "HFSLP+=1"
MOVE WORK\IE6EXP\IEEXCEP.inf WORK\INFS\%HFSLP%.inf
CALL :HFSLIPINFCREATOR1
SET /A "HFSLP+=1"
MOVE WORK\OE6EXP\MSOE50.inf WORK\INFS\%HFSLP%.inf
CALL :HFSLIPINFCREATOR1
SET /A "HFSLP+=1"
MOVE WORK\OE6EXP\WAB50.inf WORK\INFS\%HFSLP%.inf
CALL :HFSLIPINFCREATOR1
SET /A "HFSLP+=1"
MOVE WORK\OE6EXP\OEEXCEP.inf WORK\INFS\%HFSLP%.inf
CALL :HFSLIPINFCREATOR1
SET /A "HFSLP+=1"
IF EXIST HFCABS\SCRIP*.cab IF NOT EXIST HF\SCRIP*.exe IF NOT EXIST HF\*SCRIPT56*.exe (
	EXPAND HFCABS\SCRIP*.cab -F:* WORK\IE6EXP >NUL
	MOVE WORK\IE6EXP\SCRIP*.inf WORK\INFS\%HFSLP%.inf
	CALL :HFSLIPINFCREATOR1
	SET /A "HFSLP+=1"
)
CALL :IEBRANDING
ECHO/
ECHO>>WORK\HFSDST.txt PFIE=16422,"Internet Explorer"
ECHO>>WORK\HFS_PFIE.txt dw15.exe
IF DEFINED LCIDD IF NOT EXIST HFCLEANUP\ZZ_TommyP_IEGARBAGE.* (
	SET /A "DWINTLREN=1"
	ECHO>>WORK\HFSDST.txt PFIELCID=16422,"Internet Explorer\!LCIDD!"
	ECHO>>WORK\HFS_PFIELCID.txt dwintl.dll,dwil!LCIDD!.dll
)
MOVE /Y WORK\IE6EXP\*.cat WORK\SVCPACK
MOVE /Y WORK\OE6EXP\*.cat WORK\SVCPACK
MOVE /Y WORK\IE6EXP\*.* WORK\I386E
MOVE /Y WORK\OE6EXP\*.* WORK\I386E
MOVE /Y WORK\IEBRAND\*.* WORK\I386E
XCOPY /DY WORK\IE6EXP2 WORK\I386E
ECHO/
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- IE6 Slipstreamer - CAB EXPAND ----------
:IE6_EXPAND
ECHO Expanding IE6 cabs...
EXPAND HFCABS\IEW2K_1.cab -F:* WORK\IE6EXP >NUL
EXPAND HFCABS\IEW2K_2.cab -F:* WORK\IE6EXP >NUL
EXPAND HFCABS\IEW2K_3.cab -F:* WORK\IE6EXP >NUL
EXPAND HFCABS\IEW2K_4.cab -F:* WORK\IE6EXP >NUL
MOVE /Y WORK\IE6EXP\comctl32.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\corpol.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\cryptdlg.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\csseqchk.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\dhtmled.ocx WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\dw15.exe WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\dwintl.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\html32.cnv WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\msconv97.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\msencode.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\msxml3.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\msxml3r.dll WORK\IE6EXP2
MOVE /Y WORK\IE6EXP\tdc.ocx WORK\IE6EXP2
DEL /Q/F WORK\IE6EXP\dummy.cat WORK\IE6EXP\fixie.inf WORK\IE6EXP\iew2kuni.inf WORK\IE6EXP\msxml.inf
DEL /Q/F WORK\IE6EXP\msxml3a.dll WORK\IE6EXP\removbak.inf WORK\IE6EXP\setupwbv.dll WORK\IE6EXP\w2kexcp.exe
EXPAND HFCABS\MAILNEWS.cab -F:* WORK\OE6EXP >NUL
EXPAND HFCABS\OEEXCEP.cab -F:* WORK\OE6EXP >NUL
EXPAND HFCABS\WAB.cab -F:* WORK\OE6EXP >NUL
FINDSTR /VBIR "\[DefaultInstall RequiredEngine CopyFiles AddReg BackupReg DelReg RegisterOCXs CustomDestination ComponentName ComponentVersion" WORK\OE6EXP\oeexcep.inf>oeexcep.inf
FINDSTR /VI "DisplayName" WORK\OE6EXP\msoe50.inf>msoe50.inf
MOVE /Y oeexcep.inf WORK\OE6EXP >NUL
MOVE /Y msoe50.inf WORK\OE6EXP >NUL
DEL /Q/F WORK\OE6EXP\9xmig.dll
ECHO/
ECHO Creating custom source cabs for future use...
FOR %%I IN (IE6 IE6b OE6) DO (
	IF EXIST HFCABS\_%%I_HFSLIP.cab (DEL /Q/F HFCABS\_%%I_HFSLIP.cab)
)
CALL :UNICAB1
ECHO>>UC.ddf .Set CabinetNameTemplate=_IE6_HFSLIP.cab
ECHO>>UC.ddf .Set DiskDirectory1=HFCABS
FOR /F %%I IN ('DIR /B WORK\IE6EXP') DO (ECHO>>UC.ddf WORK\IE6EXP\%%I)
CALL :UNICAB2
CALL :UNICAB1
ECHO>>UC.ddf .Set CabinetNameTemplate=_IE6b_HFSLIP.cab
ECHO>>UC.ddf .Set DiskDirectory1=HFCABS
FOR /F %%I IN ('DIR /B WORK\IE6EXP2') DO (ECHO>>UC.ddf WORK\IE6EXP2\%%I)
CALL :UNICAB2
CALL :UNICAB1
ECHO>>UC.ddf .Set CabinetNameTemplate=_OE6_HFSLIP.cab
ECHO>>UC.ddf .Set DiskDirectory1=HFCABS
FOR /F %%I IN ('DIR /B WORK\OE6EXP') DO (ECHO>>UC.ddf WORK\OE6EXP\%%I)
CALL :UNICAB2

GOTO :EOF
REM ---------- ----------

REM ---------- IE7 Slipstreamer ----------
:IE7SLIP
TITLE %T1% - IE7
ECHO/
ECHO Processing Internet Explorer 7
ECHO/

MD WORK\IE7
HF\%IE7EXE% /Q /X:WORK\IE7
FINDSTR /I "MuiCultureDirectory" WORK\IE7\UPDATE\update.inf>WORK\muicult.txt
FOR /F "tokens=2 delims== " %%I IN ('FINDSTR /VIR "\." WORK\muicult.txt') DO (SET "MUICD=%%~I")
COPY WORK\IE7\UPDATE\EULA.RTF WORK\IE7\IE7Eula.rtf >NUL
FOR /F %%I IN ('DIR /B WORK\IE7\UPDATE\*.inf') DO (
	COPY WORK\IE7\UPDATE\%%I "WORK\INFS\%HFSLP%.inf" >NUL
	CALL :HFSLIPINFCREATOR1
)
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf     ProductIDCode               = "%IE7PIDCODE%"

SET /A "TXTDIR05=1"
SET /A "TXTDIR31=1"
SET /A "TXTDIR32=1"
SET /A "TXTDIR33=1"
SET /A "TXTDIR34=1"
SET /A "CUSTSATSDF=1"

IF "%VERSION%"=="XP" IF %SP% EQU 3 (
	DEL /Q/F WORK\IE7\browseui.dll WORK\IE7\html.iec WORK\IE7\ieencode.dll
	DEL /Q/F WORK\IE7\msls31.dll WORK\IE7\shdocvw.dll WORK\IE7\shlwapi.dll
	DEL /Q/F WORK\IE7\jscript.dll WORK\IE7\vbscript.dll
)

ECHO>>WORK\HFSDST.txt PFIE=16422,"Internet Explorer"
ECHO>>WORK\HFSDST.txt PFIELG4=16422,"Internet Explorer\%MUICD%"

ECHO>>WORK\HFS_PFIE.txt custsat.dll
ECHO>>WORK\HFS_PFIE.txt ieproxy.dll

ECHO>>WORK\HFSSDF.txt ieproxy.dll=1
ECHO>>WORK\HFSSDF.txt hmmapi.mui=1
ECHO>>WORK\HFSSDF.txt iedw.mui=1
ECHO>>WORK\HFSSDF.txt iexplore.mui=1

ECHO>>WORK\HFS_PFIELG4.txt hmmapi.dll.mui,hmmapi.mui
ECHO>>WORK\HFS_PFIELG4.txt iedw.exe.mui,iedw.mui
ECHO>>WORK\HFS_PFIELG4.txt iexplore.exe.mui,iexplore.mui

REM Regsvr32 [/u] [/n] [/i[:cmdline]] dllname
REM /u - Unregister server
REM /i - Call DllInstall passing it an optional [cmdline]; when it is used with /u, it calls dll uninstall
REM /n - do not call DllRegisterServer; this option must be used with /i
REM /s - Silent; display no message boxes

REM *@*
REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s "%%ProgramFiles%%\Internet Explorer\ieproxy.dll"
REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s /i /n %%SYSTEMROOT%%\system32\ieframe.dll
REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s %%SYSTEMROOT%%\system32\actxprxy.dll
ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","100",0,"%%11%%\regsvr32 /s """%%16422%%\Internet Explorer\ieproxy.dll""""
ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","101",0,"%%11%%\regsvr32 /s /i /n """%%11%%\ieframe.dll""""
ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","102",0,"%%11%%\regsvr32 /s """%%11%%\actxprxy.dll""""

ECHO>>%SOURCESS%\I386\TXTSETUP.sif ieproxy.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif hmmapi.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif iedw.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif iexplore.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif advpack.mui = 1,,,,,,,2,0,0,advpack.dll.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif ieframe.mui = 1,,,,,,,2,0,0,ieframe.dll.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeedsb.dll = 1,,,,,,,2,0,0,msfeedsbs.dll
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeedss.exe = 1,,,,,,,2,0,0,msfeedssync.exe
ECHO>>%SOURCESS%\I386\TXTSETUP.sif winfxdoc.exe = 1,,,,,,,2,0,0,WinFXDocObj.exe

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ieproxy.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,hmmapi.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,iedw.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,iexplore.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,advpack.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ieframe.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeedsb.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeedss.exe
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,winfxdoc.exe

FOR /F "tokens=1,2 delims=," %%I IN ('FINDSTR /I "wav...8" WORK\IE7\UPDATE\UPDATE.inf') DO (
	IF NOT DEFINED %%~JDONE (
		FOR /F "tokens=* delims= " %%A IN ('ECHO %%I') DO (
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%~J = 1,,,,,,,26,0,0,%%A
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%~J
		)
	)
	SET "%%~JDONE=1"
)
ECHO>>%SOURCESS%\I386\TXTSETUP.sif htmliec.mui = 1,,,,,,,1005,0,0,html.iec.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif inetcpl.mui = 1,,,,,,,1005,0,0,inetcpl.cpl.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeedsb.mui = 1,,,,,,,1005,0,0,msfeedsbs.dll.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif winfxdoc.mui = 1,,,,,,,1005,0,0,WinFXDocObj.exe.mui

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,htmliec.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,inetcpl.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeedsb.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,winfxdoc.mui

FOR /F "delims=." %%I IN ('DIR /B WORK\IE7\*DLL.MUI') DO (
	IF /I NOT "%%I"=="msfeedsbs" (
		ECHO>>WORK\IE7DLL.txt %%I
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I.mui = 1,,,,,,,1005,0,0,%%I.dll.mui
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I.mui
	)
)
FOR /F "delims=." %%I IN ('DIR /B WORK\IE7\*EXE.MUI') DO (
	IF /I NOT "%%I"=="WinFXDocObj" (
		ECHO>>WORK\IE7EXE.txt %%I
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I.mui = 1,,,,,,,1005,0,0,%%I.exe.mui
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I.mui
	)
)
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeedsb.mof = 1,,,,,,,1031,0,0,msfeedsbs.mof
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeeds.mof = 1,,,,,,,1031,0,0
ECHO>>%SOURCESS%\I386\TXTSETUP.sif webcheck.ini = 1,,,,,,,1032,0,0,desktop.ini
ECHO>>%SOURCESS%\I386\TXTSETUP.sif occache.ini = 1,,,,,,,1033,0,0,desktop.ini

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeedsb.mof
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeeds.mof
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,webcheck.ini
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,occache.ini

FOR /F %%I IN ('DIR /B WORK\IE7\*.IEM') DO (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,1034,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I
)

CALL :IE7_IE8_FIXES
XCOPY /DY WORK\IE7\UPDATE\*.cat WORK\SVCPACK >NUL
XCOPY /DY WORK\IE7\*.* WORK\I386E
ECHO/

IF EXIST HF\IE7*-KB*.exe (
	FOR /F %%I IN ('DIR /B HF\IE7*-KB*.exe') DO (
		SET "HF=%%I"
		SET /A "IE7HFX=1"
		CALL :HF1EXTRACT
	)
)
IF EXIST HF\BASIC\IE7*-KB*.exe (
	FOR /F %%I IN ('DIR /B HF\BASIC\IE7*-KB*.exe') DO (
		SET "HF=%%I"
		SET /A "IE7HFX=1"
		CALL :HFBASIC
	)
)
IF EXIST HF\NOREG\IE7*-KB*.exe (
	FOR /F %%I IN ('DIR /B HF\NOREG\IE7*-KB*.exe') DO (
		SET "HF=%%I"
		SET /A "IE7HFX=1"
		CALL :HFNOREG
	)
)
TITLE %T1% - IE7

IF EXIST HFCABS\BRANDING.cab (CALL :IEBRANDING)
IF DEFINED MOREBRAND (XCOPY /DY WORK\IEBRAND WORK\I386E >NUL)
CALL :IEACCESS_INF

WORK\IE7\UPDATE\idndl.exe /Q /X:TEMP
CALL :HF1COMMON_B
WORK\IE7\UPDATE\nlsdl.exe /Q /X:TEMP
CALL :HF1COMMON_B
IF NOT %OSLEVEL% EQU 23 (
	WORK\IE7\UPDATE\xmllitesetup.exe /Q /X:TEMP
	CALL :HF1COMMON_A
	CALL :HF1COMMON_B
)
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- IE7 Integrator ----------
:IE7INT
TITLE %T1% - Pre-IE7
ECHO/
ECHO Preparing for Internet Explorer 7
ECHO/

IF EXIST HFCABS\BRANDING.cab (CALL :IEBRANDING)
SET /A "IE7INFINST=0"
SET /A "IE7FCNT=0"
ECHO Extracting MSIE7
MD WORK\IE7
HF\%IE7EXE% /Q /X:WORK\IE7
SET /A "IE7HFX=1"
IF EXIST HF\IE7*-KB*.exe (
	ECHO Integrating MSIE7 hotfixes from HF folder
	FOR /F %%I IN ('DIR /B/ON HF\IE7*-KB*.exe') DO (
		ECHO %%I
		HF\%%I /Q /X:TEMP
		CALL :IE7INTCOPY
		SET /A "IE7INFINST+=1"
		ECHO>WORK\IE7\UPDATE!IE7INFINST!.inf [Version]
		ECHO>>WORK\IE7\UPDATE!IE7INFINST!.inf Signature="$WINDOWS NT$"
		IF EXIST TEMP\UPDATE\updHFSLP.inf (
			TYPE TEMP\UPDATE\updHFSLP.inf>>WORK\IE7\UPDATE!IE7INFINST!.inf
		) ELSE (
			FOR /F %%I IN ('DIR /B TEMP\UPDATE\*.inf') DO (TYPE TEMP\UPDATE\%%I>>WORK\IE7\UPDATE!IE7INFINST!.inf)
		)
		ECHO>>WORK\IE7UPDINF.txt rundll32.exe %%SYSTEMROOT%%\SYSTEM32\advpack.dll,LaunchINFSection UPDATE!IE7INFINST!.inf,ProductInstall.GlobalRegistryChanges.Install
		CALL :CLEANTEMP
	)
)
SET "IE7INFINS="
IF EXIST HF\BASIC\IE7*-KB*.exe (
	ECHO Integrating MSIE7 hotfixes from HF\BASIC folder
	FOR /F %%I IN ('DIR /B/ON HF\BASIC\IE7*-KB*.exe') DO (
		ECHO %%I
		HF\BASIC\%%I /Q /X:TEMP
		CALL :IE7INTCOPY
		SET "HF=%%I"
		CALL :PARSE_KB
		CALL :CLEANTEMP
	)
)
IF EXIST HF\NOREG\IE7*-KB*.exe (
	ECHO Integrating MSIE7 hotfixes from HF\NOREG folder
	FOR /F %%I IN ('DIR /B/ON HF\NOREG\IE7*-KB*.exe') DO (
		ECHO %%I
		HF\NOREG\%%I /Q /X:TEMP
		CALL :IE7INTCOPY
		CALL :CLEANTEMP
	)
)
SET "IE7HFX="
CALL :IE7_IE8_FIXES
IF DEFINED MOREBRAND (
	ECHO Adding extra IEAK files
	XCOPY /DY WORK\IEBRAND WORK\IE7 >NUL
)
ECHO Creating updated MSIE7 installer
IF DEFINED IE7SVCPACK (
	SET "IE7INSTSW= /quiet"
	SET "IE7TARGET=\SVCPACK"
) ELSE (
	SET "IE7INSTSW= /passive"
)
IF "%IE7BACKUP%"=="0" (SET "IE7BKPSW= /nobackup")
CALL :UNICAB1
ECHO>>UC.ddf .Set CabinetNameTemplate=UPDATE.cab
ECHO>>UC.ddf .Set DiskDirectory1=WORK\IE7
FOR /F %%I IN ('DIR /B WORK\IE7\update') DO (ECHO>>UC.ddf WORK\IE7\update\%%I)
CALL :UNICAB2
ECHO>WORK\IE7\SETUP.cmd @ECHO OFF

REM evgnb:
REM todo: VBScript for AppLaunched=%%AppLaunched%%
REM It's old version cmdhide.exe, new version uses CMDHIDE.VBS:
IF DEFINED CMDHIDE (ECHO>>WORK\IE7\SETUP.cmd !CMDHIDE!)

ECHO>>WORK\IE7\SETUP.cmd MD update
ECHO>>WORK\IE7\SETUP.cmd EXPAND UPDATE.cab -F:* update ^>NUL
ECHO>>WORK\IE7\SETUP.cmd update\iesetup.exe%IE7INSTSW% /norestart /update-no%IE7BKPSW%
SET "IE7INSTSW="
IF EXIST WORK\IE7UPDINF.txt (TYPE WORK\IE7UPDINF.txt>>WORK\IE7\SETUP.cmd)
IF EXIST WORK\IE7\ieframe2.dll (
	ECHO>>WORK\IE7\SETUP.cmd COPY /Y ieframe2.dll %%SYSTEMROOT%%\SYSTEM32
	ECHO>>WORK\IE7\SETUP.cmd %%SYSTEMROOT%%\SYSTEM32\REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /t REG_EXPAND_SZ /v ZZZieframe1 /d "CMD /C REN %%SYSTEMROOT%%\SYSTEM32\ieframe.dll ieframe.old&REN %%SYSTEMROOT%%\SYSTEM32\ieframe2.dll ieframe.dll" /f
	ECHO>>WORK\IE7\SETUP.cmd %%SYSTEMROOT%%\SYSTEM32\REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /t REG_EXPAND_SZ /v ZZZieframe2 /d "CMD /C %%SYSTEMROOT%%\SYSTEM32\REG ADD """HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce""" /t REG_EXPAND_SZ /v ieframeold /d """CMD /C DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\ieframe.old""" /f" /f
)
ECHO>>WORK\IE7\SETUP.cmd EXIT /b
ECHO>IE7.SED [Version]
ECHO>>IE7.SED Class=IEXPRESS
ECHO>>IE7.SED SEDVersion=3
ECHO>>IE7.SED [Options]
ECHO>>IE7.SED PackagePurpose=InstallApp
ECHO>>IE7.SED ShowInstallProgramWindow=0
ECHO>>IE7.SED HideExtractAnimation=0
ECHO>>IE7.SED UseLongFileName=1
ECHO>>IE7.SED InsideCompressed=0
ECHO>>IE7.SED CAB_FixedSize=0
ECHO>>IE7.SED CAB_ResvCodeSigning=0
ECHO>>IE7.SED RebootMode=N
ECHO>>IE7.SED TargetName=%%TargetName%%
ECHO>>IE7.SED FriendlyName=%%FriendlyName%%
ECHO>>IE7.SED AppLaunched=%%AppLaunched%%
ECHO>>IE7.SED PostInstallCmd=%%PostInstallCmd%%
ECHO>>IE7.SED SourceFiles=SourceFiles
ECHO>>IE7.SED [Strings]
ECHO>>IE7.SED TargetName=%SOURCESS%\I386%IE7TARGET%\IE7_INST.exe
ECHO>>IE7.SED FriendlyName=Windows Internet Explorer 7
ECHO>>IE7.SED AppLaunched=SETUP.cmd
ECHO>>IE7.SED PostInstallCmd=^<None^>
FOR /F %%I IN ('DIR /B/A-D WORK\IE7') DO (
	ECHO>>IE7.SED FILE!IE7FCNT!="%%I"
	ECHO>>IE7b.txt %%FILE!IE7FCNT!%%=
	SET /A "IE7FCNT+=1"
)
ECHO>>IE7.SED [SourceFiles]
ECHO>>IE7.SED SourceFiles0=%~dp0WORK\IE7\
ECHO>>IE7.SED [SourceFiles0]
TYPE IE7b.txt>>IE7.SED
IEXPRESS /N /Q /M IE7.SED
DEL /Q/F IE7.SED IE7b.txt
%MODIFYPE% %SOURCESS%\I386%IE7TARGET%\IE7_INST.exe -c
ECHO/
SET "IE7TARGET="
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- IE7 Integrator - Copy ----------
:IE7INTCOPY
CALL :MID_BA_51
COPY TEMP\UPDATE\*.cat WORK\SVCPACK >NUL
REM Fix for bug with the new ieframe.dll binary.
IF "%IE7GUILOGON%"=="1" IF EXIST TEMP\ieframe.dll (REN TEMP\ieframe.dll ieframe2.dll)
REM Temp fix for file creation date issue with Oct'07 IE7 installer.
REM Upd. Nov 11 - if HFX with ieframe.dll.mui: ieframe.dll.mui force-copied, others replace existing ones if newer.
REM             - if HFX without ieframe.dll.mui: files newer than 8-Mar-2007 replace existing ones.
IF EXIST TEMP\ieframe.dll.mui (
	MOVE /Y TEMP\ieframe.dll.mui WORK\IE7
	XCOPY /DHY TEMP WORK\IE7 >NUL
) ELSE (
	XCOPY /HY /D:03-08-2007 TEMP WORK\IE7 >NUL
)
GOTO :EOF
REM ---------- ----------

REM ---------- IE8 Slipstreamer ----------
:IE8SLIP
TITLE %T1% - IE8
ECHO/
ECHO Processing Internet Explorer 8
ECHO/

MD WORK\IE8
HF\%IE8EXE% /Q /X:WORK\IE8
FINDSTR /I "MuiCultureDirectory" WORK\IE8\UPDATE\update.inf>WORK\muicult.txt
FOR /F "tokens=2 delims== " %%I IN ('FINDSTR /VIR "\." WORK\muicult.txt') DO (SET "MUICD=%%~I")
COPY WORK\IE8\UPDATE\EULA.RTF WORK\IE8\IE8Eula.rtf >NUL
FOR /F %%I IN ('DIR /B WORK\IE8\UPDATE\*.inf') DO (
	COPY WORK\IE8\UPDATE\%%I "WORK\INFS\%HFSLP%.inf" >NUL
	CALL :HFSLIPINFCREATOR1
)

SET /A "TXTDIR05=1"
SET /A "TXTDIR31=1"
SET /A "TXTDIR32=1"
SET /A "TXTDIR33=1"
SET /A "TXTDIR34=1"

ECHO>>WORK\HFSDST.txt PFIE=16422,"Internet Explorer"
ECHO>>WORK\HFSDST.txt PFIELG4=16422,"Internet Explorer\%MUICD%"

ECHO>>WORK\HFSSDF.txt ieproxy.dll=1
ECHO>>WORK\HFSSDF.txt hmmapi.mui=1
ECHO>>WORK\HFSSDF.txt iexplore.mui=1

ECHO>>WORK\HFS_PFIE.txt ieproxy.dll

ECHO>>WORK\HFS_PFIELG4.txt hmmapi.dll.mui,hmmapi.mui
ECHO>>WORK\HFS_PFIELG4.txt iexplore.exe.mui,iexplore.mui

ECHO>>WORK\RENAME.cmd REN "WORK\I386E\ExtExport.exe" extexprt.exe
ECHO>>WORK\RENAME.cmd REN "WORK\I386E\ie8props.propdesc" ie8props.pro
ECHO>>WORK\RENAME.cmd REN "WORK\I386E\jsdebuggeride.dll" jsdbgide.dll
ECHO>>WORK\RENAME.cmd REN "WORK\I386E\jsdebuggeride.dll.mui" jsdbgide.mui
ECHO>>WORK\RENAME.cmd REN "WORK\I386E\JSProfilerCore.dll" jspfcore.dll
ECHO>>WORK\RENAME.cmd REN "WORK\I386E\jsprofilerui.dll" jsprflui.dll

ECHO>>WORK\HFSSDF.txt ie8props.pro=1
ECHO>>WORK\HFSSDF.txt iexplore.mui=1
ECHO>>WORK\HFSSDF.txt iecompat.dll=1
ECHO>>WORK\HFSSDF.txt iedvtool.dll=1
ECHO>>WORK\HFSSDF.txt jsdbgui.dll=1
ECHO>>WORK\HFSSDF.txt jsdbgide.dll=1
ECHO>>WORK\HFSSDF.txt jspfcore.dll=1
ECHO>>WORK\HFSSDF.txt jsprflui.dll=1
ECHO>>WORK\HFSSDF.txt pdm.dll=1
ECHO>>WORK\HFSSDF.txt sqmapi.dll=1
ECHO>>WORK\HFSSDF.txt xpshims.dll=1

ECHO>>WORK\HFS_PFIE.txt ie8props.propdesc,ie8props.pro
ECHO>>WORK\HFS_PFIE.txt iexplore.exe.mui,iexplore.mui
ECHO>>WORK\HFS_PFIE.txt iecompat.dll
ECHO>>WORK\HFS_PFIE.txt iedvtool.dll
ECHO>>WORK\HFS_PFIE.txt jsdbgui.dll
ECHO>>WORK\HFS_PFIE.txt jsdebuggeride.dll,jsdbgide.dll
ECHO>>WORK\HFS_PFIE.txt JSProfilerCore.dll,jspfcore.dll
ECHO>>WORK\HFS_PFIE.txt jsprofilerui.dll,jsprflui.dll
ECHO>>WORK\HFS_PFIE.txt pdm.dll
ECHO>>WORK\HFS_PFIE.txt sqmapi.dll
ECHO>>WORK\HFS_PFIE.txt xpshims.dll

ECHO>>%SOURCESS%\I386\TXTSETUP.sif ieproxy.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif hmmapi.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif iexplore.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif extexprt.exe = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif ie8props.pro = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif iecompat.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif iedvtool.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif jsdbgui.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif jsdbgide.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif jspfcore.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif jsprflui.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif pdm.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif sqmapi.dll = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif xpshims.dll = 1,,,,,,,,3,3

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ieproxy.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,hmmapi.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,iexplore.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,extexprt.exe
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ie8props.pro
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,iecompat.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,iedvtool.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,jsdbgui.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,jsdbgide.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,jspfcore.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,jsprflui.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,pdm.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,sqmapi.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,xpshims.dll

ECHO>>WORK\RENAME.cmd REN "WORK\I386E\JSProfilerCore.dll.mui" jspfcore.mui
ECHO>>WORK\RENAME.cmd REN "WORK\I386E\jsprofilerui.dll.mui" jsprflui.mui

ECHO>>WORK\HFSSDF.txt iedvtool.mui=1
ECHO>>WORK\HFSSDF.txt jsdbgui.mui=1
ECHO>>WORK\HFSSDF.txt jsdbgide.mui=1
ECHO>>WORK\HFSSDF.txt jspfcore.mui=1
ECHO>>WORK\HFSSDF.txt jsprflui.mui=1

ECHO>>WORK\HFS_PFIELG4.txt iedvtool.dll.mui,iedvtool.mui
ECHO>>WORK\HFS_PFIELG4.txt jsdbgui.dll.mui,jsdbgui.mui
ECHO>>WORK\HFS_PFIELG4.txt jsdebuggeride.dll.mui,jsdbgide.mui
ECHO>>WORK\HFS_PFIELG4.txt JSProfilerCore.dll.mui,jspfcore.mui
ECHO>>WORK\HFS_PFIELG4.txt jsprofilerui.dll.mui,jsprflui.mui

ECHO>>%SOURCESS%\I386\TXTSETUP.sif iedvtool.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif jsdbgui.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif jsdbgide.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif jspfcore.mui = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif jsprflui.mui = 1,,,,,,,,3,3

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,iedvtool.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,jsdbgui.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,jsdbgide.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,jspfcore.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,jsprflui.mui

ECHO>>WORK\HFREGWU.txt HKU,".DEFAULT\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{6E32070A-766D-4EE6-879C-DC1FA91D2FC3}\iexplore\AllowedDomains\microsoft.com",,,

REM *@*
REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s "%%ProgramFiles%%\Internet Explorer\ieproxy.dll"
REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s /i /n %%SYSTEMROOT%%\system32\ieframe.dll
REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s %%SYSTEMROOT%%\system32\actxprxy.dll
ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","100",0,"%%11%%\regsvr32 /s """%%16422%%\Internet Explorer\ieproxy.dll""""
ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","101",0,"%%11%%\regsvr32 /s /i /n """%%11%%\ieframe.dll""""
ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","102",0,"%%11%%\regsvr32 /s """%%11%%\actxprxy.dll""""

ECHO>>%SOURCESS%\I386\TXTSETUP.sif advpack.mui = 1,,,,,,,2,0,0,advpack.dll.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif ieframe.mui = 1,,,,,,,2,0,0,ieframe.dll.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeedsb.dll = 1,,,,,,,2,0,0,msfeedsbs.dll
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeedss.exe = 1,,,,,,,2,0,0,msfeedssync.exe
ECHO>>%SOURCESS%\I386\TXTSETUP.sif winfxdoc.exe = 1,,,,,,,2,0,0,WinFXDocObj.exe
ECHO>>%SOURCESS%\I386\TXTSETUP.sif ie4uinit.mui = 1,,,,,,,2,0,0,ie4uinit.exe.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif iedkcs32.mui = 1,,,,,,,2,0,0,iedkcs32.dll.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msdbg2.dll = 1,,,,,,,2,0,0
ECHO>>%SOURCESS%\I386\TXTSETUP.sif mshta.mui = 1,,,,,,,2,0,0,mshta.exe.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msrating.mui = 1,,,,,,,2,0,0,msrating.dll.mui

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,advpack.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ieframe.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeedsb.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeedss.exe
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,winfxdoc.exe
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ie4uinit.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,iedkcs32.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msdbg2.dll
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mshta.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msrating.mui

FOR /F "tokens=1,2 delims=," %%I IN ('FINDSTR /I "wav...8" WORK\IE8\UPDATE\UPDATE.inf') DO (
	IF NOT DEFINED %%~JDONE (
		FOR /F "tokens=* delims= " %%A IN ('ECHO %%I') DO (
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%~J = 1,,,,,,,26,0,0,%%A
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%~J
		)
	)
	SET %%~JDONE=1
)
ECHO>>%SOURCESS%\I386\TXTSETUP.sif htmliec.mui = 1,,,,,,,1005,0,0,html.iec.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif inetcpl.mui = 1,,,,,,,1005,0,0,inetcpl.cpl.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeedsb.mui = 1,,,,,,,1005,0,0,msfeedsbs.dll.mui
ECHO>>%SOURCESS%\I386\TXTSETUP.sif winfxdoc.mui = 1,,,,,,,1005,0,0,WinFXDocObj.exe.mui

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,htmliec.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,inetcpl.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeedsb.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,winfxdoc.mui

REM TODO Why are we using IE7's file names? Shouldn't we create IE8's own?
FOR /F "delims=." %%I IN ('DIR /B WORK\IE8\*DLL.MUI') DO (
	IF /I NOT "%%I"=="msfeedsbs" IF /I NOT "%%I"=="jsdebuggeride" IF /I NOT "%%I"=="JSProfilerCore" IF /I NOT "%%I"=="jsprofilerui" (
		ECHO>>WORK\IE7DLL.txt %%I
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I.mui = 1,,,,,,,1005,0,0,%%I.dll.mui
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I.mui
	)
)
FOR /F "delims=." %%I IN ('DIR /B WORK\IE8\*EXE.MUI') DO (
	IF /I NOT "%%I"=="WinFXDocObj" (
		ECHO>>WORK\IE7EXE.txt %%I
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I.mui = 1,,,,,,,1005,0,0,%%I.exe.mui
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I.mui
	)
)

ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeedsb.mof = 1,,,,,,,1031,0,0,msfeedsbs.mof
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msfeeds.mof = 1,,,,,,,1031,0,0
ECHO>>%SOURCESS%\I386\TXTSETUP.sif webcheck.ini = 1,,,,,,,1032,0,0,desktop.ini
ECHO>>%SOURCESS%\I386\TXTSETUP.sif occache.ini = 1,,,,,,,1033,0,0,desktop.ini

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeedsb.mof
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msfeeds.mof
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,webcheck.ini
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,occache.ini

FOR /F %%I IN ('DIR /B WORK\IE8\*.IEM') DO (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,1034,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I
)

REM Easier to SET an unfittingly-named variable to pass a check than to engineer a new solution. :P
SET /A "IE7SLIPSTREAM=1"
CALL :IE7_IE8_FIXES
SET "IE7SLIPSTREAM="
XCOPY /DY WORK\IE8\UPDATE\*.cat WORK\SVCPACK >NUL
XCOPY /DY WORK\IE8\*.* WORK\I386E

CALL :IE8_FIXES
TITLE %T1% - IE8

IF EXIST HFCABS\BRANDING.cab (CALL :IEBRANDING)
IF DEFINED MOREBRAND (XCOPY /DY WORK\IEBRAND WORK\I386E >NUL)
CALL :IEACCESS_INF

IF EXIST SOURCE\I386\xmllite.dl* (DEL /Q/F WORK\IE8\support\xmllite.dll)
XCOPY /DY WORK\IE8\support WORK\I386E
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- IE BRANDING.cab ----------
:IEBRANDING
MD WORK\IEBRAND
EXPAND HFCABS\BRANDING.cab -F:* WORK\IEBRAND >NUL
FOR %%I IN (INSTALL SETUP) DO (
	IF EXIST WORK\IEBRAND\%%I.inf (DEL /Q/F WORK\IEBRAND\%%I.inf)
)
IF EXIST WORK\IEBRAND\*.inf (
	FOR /F %%I IN ('DIR /B/ON WORK\IEBRAND\*.inf') DO (
		SET /A "HFSLP+=1"
		FINDSTR /VI "RequiredEngine" WORK\IEBRAND\%%I>>%SOURCESS%\I386\HFSLP!HFSLP!.inf
		DEL /Q/F WORK\IEBRAND\%%I
		REM *@*
		REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLP%HFSLP%.inf,,1
		ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZA","!HFSLP!",0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\HFSLP!HFSLP!.inf,DefaultInstall"
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLP!HFSLP!.inf = 1,,,,,,,999,0,0
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLP!HFSLP!.inf
	)
)
FOR /F %%I IN ('DIR /B WORK\IEBRAND') DO (SET /A "MOREBRAND=1")
GOTO :EOF
REM ---------- ----------

REM ---------- IEACCESS.inf ----------
:IEACCESS_INF
EXPAND SOURCE\I386\IEACCESS.in_ -R WORK >NUL
FINDSTR /L "[ShowIE]" WORK\IEACCESS.inf >NUL
IF ERRORLEVEL 1 (
	ECHO>>IEACCESS.cmd @ECHO OFF
	ECHO>>IEACCESS.cmd SET "IEACCESS="
	ECHO>>IEACCESS.cmd FIND /V /I "[Show" WORK\IEACCESS.inf^>WORK\IEACCESS1.inf
	ECHO>>IEACCESS.cmd FIND /V /I "[Hide" WORK\IEACCESS1.inf^>WORK\IEACCESS2.inf
	ECHO>>IEACCESS.cmd FIND /V /I "Commandline" WORK\IEACCESS2.inf^>WORK\IEACCESS3.inf
	ECHO>>IEACCESS.cmd FIND /V /I "TickCount" WORK\IEACCESS3.inf^>WORK\IEACCESS4.inf
	ECHO>>IEACCESS.cmd FOR /F "delims=" %%%%I IN ^('FIND /V /I "----------" WORK\IEACCESS4.inf'^) DO ^(
	ECHO>>IEACCESS.cmd 	IF DEFINED IEACCESS ^(ECHO^>^>WORK\I386E\ieaccess.inf %%%%I^)
	ECHO>>IEACCESS.cmd 	SET "IEACCESS=1"
	ECHO>>IEACCESS.cmd ^)
	ECHO>>IEACCESS.cmd EXIT /b
	ECHO>>IEACCESS.cmd ECHO^>^>WORK\I386E\ieaccess.inf [ShowIE]
	ECHO>>IEACCESS.cmd ECHO^>^>WORK\I386E\ieaccess.inf Commandline="%%%%11%%%%\ie4uinit.exe -show"
	ECHO>>IEACCESS.cmd ECHO^>^>WORK\I386E\ieaccess.inf TickCount=500
	ECHO>>IEACCESS.cmd ECHO^>^>WORK\I386E\ieaccess.inf [HideIE]
	ECHO>>IEACCESS.cmd ECHO^>^>WORK\I386E\ieaccess.inf Commandline="%%%%11%%%%\ie4uinit.exe -hide"
	ECHO>>IEACCESS.cmd ECHO^>^>WORK\I386E\ieaccess.inf TickCount=500
	CMD /U/C "IEACCESS.cmd"
	DEL /Q/F IEACCESS.cmd
) ELSE (
	FINDSTR /VIBR "\[Show \[Hide Commandline TickCount" WORK\IEACCESS.inf>WORK\I386E\ieaccess.inf
	ECHO>>WORK\I386E\ieaccess.inf [ShowIE]
	ECHO>>WORK\I386E\ieaccess.inf Commandline="%%11%%\ie4uinit.exe -show"
	ECHO>>WORK\I386E\ieaccess.inf TickCount=500
	ECHO>>WORK\I386E\ieaccess.inf [HideIE]
	ECHO>>WORK\I386E\ieaccess.inf Commandline="%%11%%\ie4uinit.exe -hide"
	ECHO>>WORK\I386E\ieaccess.inf TickCount=500
)
REM ---------- ----------

REM ---------- IE7/IE8 Fixes ----------
:IE7_IE8_FIXES
FINDSTR /VIR "Welcome PhishingFilter RunOnceHasShown RunOnceLastShown RunOnceComplete UseClearType" WORK\%VERSIONIE%\ieuinit.inf>ieuinit.inf
MOVE /Y ieuinit.inf WORK\%VERSIONIE% >NUL
IF "%VERSION%"=="XP" IF NOT "%IE7SLIPSTREAM%"=="1" (GOTO :EOF)
ECHO>MKSDINF.cmd @ECHO OFF
ECHO>>MKSDINF.cmd ECHO^>%SOURCESS%\I386\HFSLIPSD.inf [Version]
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf Signature="$WINDOWS NT$"
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf [Optional Components]
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf ShowDesktop
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf [ShowDesktop]
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf CopyFiles=Copy.ShowDesktop
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf OptionDesc="%%%%ShowDesktop%%%%"
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf Tip="%%%%ShowDesktop%%%%"
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf Modes=0,1,2,3
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf [SourceDisksNames]
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf 1="Windows CD","%CDTAG%",,"\I386"
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf [SourceDisksFiles]
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf sdesktop.scf=1
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf [DestinationDirs]
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf Copy.ShowDesktop=53,"%%%%ApplicationData%%%%\%%%%QuickLaunchDir%%%%"
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf [Copy.ShowDesktop]
ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf %%%%ShowDesktop%%%%,sdesktop.scf
EXPAND SOURCE\I386\SHELL.in_ -R WORK >NUL
FINDSTR /L "ShowDesktop" WORK\SHELL.inf >NUL
IF ERRORLEVEL 1 (
	IF DEFINED NOIE7STRNGSRCH (
		ECHO>>MKSDINF.cmd TYPE WORK\SHELL.inf^>^>%SOURCESS%\I386\HFSLIPSD.inf
	) ELSE (
		REM TODO Why is the first instance of "ShowDesktop" and "QuickLaunch" intentionally being skipped?
		ECHO>>MKSDINF.cmd ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf [Strings]
		ECHO>>MKSDINF.cmd FOR /F "delims=" %%%%I IN ^('FIND /I "ShowDesktop" WORK\SHELL.inf'^) DO ^(
		ECHO>>MKSDINF.cmd 	IF DEFINED SHOWD1 ^(ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf %%%%I^)
		ECHO>>MKSDINF.cmd 	SET /A "SHOWD1=1"
		ECHO>>MKSDINF.cmd ^)
		ECHO>>MKSDINF.cmd FOR /F "delims=" %%%%I IN ^('FIND /I "QuickLaunch" WORK\SHELL.inf'^) DO ^(
		ECHO>>MKSDINF.cmd 	IF DEFINED SHOWD2 ^(ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf %%%%I^)
		ECHO>>MKSDINF.cmd 	SET /A "SHOWD2=1"
		ECHO>>MKSDINF.cmd ^)
	)
	REM TODO Shouldn't there be two quotation marks instead of one?
	ECHO>>MKSDINF.cmd FOR /F "tokens=2 delims=\" %%%%I IN ^('FIND /I "U_SHELL_FOLDERS_APPDATA=" SOURCE\I386\HIVEDEF.inf'^) DO ^(
	ECHO>>MKSDINF.cmd 	IF DEFINED SHOWD3 ^(ECHO^>^>%SOURCESS%\I386\HFSLIPSD.inf ApplicationData     = "%%%%I^)
	ECHO>>MKSDINF.cmd 	SET /A "SHOWD3=1"
	ECHO>>MKSDINF.cmd ^)
	CMD /U/C "MKSDINF.cmd"
) ELSE (
	CALL MKSDINF.cmd
	ECHO>>%SOURCESS%\I386\HFSLIPSD.inf [Strings]
	FOR /F "tokens=2 delims=\" %%I IN ('FINDSTR /BIR "U_SHELL_FOLDERS_APPDATA=" SOURCE\I386\HIVEDEF.inf') DO (
		ECHO>>%SOURCESS%\I386\HFSLIPSD.inf ApplicationData     = "%%I
	)
	FINDSTR /BIR "ShowDesktop QuickLaunch" WORK\SHELL.inf>>%SOURCESS%\I386\HFSLIPSD.inf
)
DEL /Q/F MKSDINF.cmd
ECHO>%SOURCESS%\I386\sdesktop.scf [Shell]
ECHO>>%SOURCESS%\I386\sdesktop.scf Command=2
ECHO>>%SOURCESS%\I386\sdesktop.scf IconFile=explorer.exe,3
ECHO>>%SOURCESS%\I386\sdesktop.scf [Taskbar]
ECHO>>%SOURCESS%\I386\sdesktop.scf Command=ToggleDesktop

ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLIPSD.inf = 1,,,,,,,20,0,0
ECHO>>%SOURCESS%\I386\TXTSETUP.sif sdesktop.scf = 1,,,,,,,,3,3

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLIPSD.inf
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,sdesktop.scf
GOTO :EOF
REM ---------- ----------

REM ---------- IE8 Fixes ----------
:IE8_FIXES
TITLE %T1% - IE8 Hotfixes
ECHO/
ECHO Processing Internet Explorer 8 Hotfixes
ECHO/
IF EXIST HF\IE8*-KB*.exe (
	FOR /F %%I IN ('DIR /B HF\IE8*-KB*.exe') DO (
		SET "HF=%%I"
		SET /A "IE8HFX=1"
		CALL :HF1EXTRACT
	)
)
IF EXIST HF\BASIC\IE8*-KB*.exe (
	FOR /F %%I IN ('DIR /B HF\BASIC\IE8*-KB*.exe') DO (
		SET "HF=%%I"
		SET /A "IE8HFX=1"
		CALL :HFBASIC
	)
)
IF EXIST HF\NOREG\IE8*-KB*.exe (
	FOR /F %%I IN ('DIR /B HF\NOREG\IE8*-KB*.exe') DO (
		SET "HF=%%I"
		SET /A "IE8HFX=1"
		CALL :HFNOREG
	)
)
SET "IE8HFX="
GOTO :EOF
REM ---------- ----------


REM ******************** Windows Media Player ********************


REM ---------- Windows Media Player ----------
:WMSLIP
TITLE %T1% - WMP
ECHO/
ECHO Processing Windows Media
ECHO/

SET "DefWMPReg=reg.devices,Reg.Codecs,V9Reg.Core,V9Reg.Core.AddOnly,V9Reg.Univ,V9.RegPUI,WMPAddReg.PUI,WMPAddReg.OSPUI,WMP.ARP"
IF "%VERSION%"=="2000" (
	SET "DefWMPReg=AddReg.CDRW,%DefWMPReg%"
	IF EXIST HF\MPSetup.exe (
		SET /A "MPLEVEL=31"
		ECHO Processing MPSetup.exe...
		HF\MPSetup.exe /Q:A /T:"%PREP%\TEMP" /C
	)
	IF EXIST HF\WindowsMedia9-KB891122*.exe IF NOT EXIST HF\wmfdist.exe (
		FOR /F %%I IN ('DIR /B HF\WindowsMedia9-KB891122*.exe') DO (
			MD WORK\WMFD
			HF\%%I /Q /X:WORK\WMFD
			MOVE WORK\WMFD\wmfdist.exe HF >NUL
			ECHO>>WORK\FILESTODEL.txt HF\wmfdist.exe
		)
	)
	IF EXIST HF\wmfdist.exe (
		SET /A "MPLEVEL=32"
		ECHO Processing wmfdist.exe...
		MD TEMP\WMPCOD
		HFTOOLS\7za.exe x HF\wmfdist.exe -o"%PREP%\TEMP\WMPCOD" -r >NUL
		IF EXIST TEMP\setup_wm.exe (DEL /Q/F TEMP\WMPCOD\setup_wm.exe)
		REM 2020-08-07:
		ATTRIB -R -A -S -H TEMP\*.*  /S /D
		XCOPY /DHY TEMP\WMPCOD TEMP >NUL
		RD /Q/S TEMP\WMPCOD
	)
	IF EXIST HF\wmp6cdcs.exe (
		ECHO Processing wmp6cdcs.exe...
		MD TEMP\MP6CDCS
		HF\wmp6cdcs.exe /Q:A /T:"%PREP%\TEMP\MP6CDCS" /C
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32","msacm.msaudio1",,"msaud32.acm"
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\drivers.desc","msaud32.acm",,"Windows Media Audio Codec"
		IF NOT EXIST TEMP\MP4SDMOD.dll (
			ECHO>>WORK\HHIVADD.txt HKCR,"Windows Media\WMSDK\VideoDecode\MP4S","DllName",,"mp4sdmod.dll"
			ECHO>>WORK\HHIVADD.txt HKCR,"Windows Media\WMSDK\VideoDecode\M4S2","DllName",,"mp4sdmod.dll"
		)
		ECHO>TEMP\WMV9VCM.inf [Version]
		ECHO>>TEMP\WMV9VCM.inf Signature="$WINDOWS NT$"
		FINDSTR /VBIR "\[Version Signature Advanced Required CopyFiles" TEMP\MP6CDCS\WMV9VCM.inf>>TEMP\WMV9VCM.inf
		REM 2020-08-07:
		ATTRIB -R -A -S -H TEMP\*.*  /S /D
		DEL /Q/F TEMP\MP6CDCS\*.inf TEMP\MP6CDCS\*.txt
		XCOPY /DHY TEMP\MP6CDCS TEMP >NUL
		RD /Q/S TEMP\MP6CDCS
	)
) ELSE (
	SET "DefWMPReg=%DefWMPReg%,reg.wmdm.autoplay,V9Reg.XP,WMP.SPAD,WMP.Reg.IEHard,Reg.WMDMHandler,Fraunhofer.Reg,Reg.Version,Reg.WPD,Reg.UMWDF"
	IF EXIST HF\WMP11*.exe IF NOT EXIST HF\WMP11\*.exe (
		IF EXIST HF\WMP11 (RD /Q/S HF\WMP11)
		SET /A "RDWMP11DIR=1"
		MD TEMP\WMP11
		FOR /F %%I IN ('DIR /B HF\WMP11*.exe') DO (
			ECHO Extracting %%I...
			HF\%%I /Q:A /T:"%PREP%\TEMP\WMP11" /C
		)
	)
	IF NOT EXIST TEMP\WMP11\*.exe (
		IF DEFINED MPLEVEL (CALL :LEGACYWMP)
	) ELSE (
		IF DEFINED XPMCE IF EXIST HF\*%MCEMP10CUM%*.exe (
			MD TEMP\MP10CUM
			FOR /F %%I IN ('DIR /B HF\*%MCEMP10CUM%*.exe') DO (HF\%%I /Q /X:TEMP\MP10CUM)
			REM 2020-08-07:
			ATTRIB -R -A -S -H TEMP\*.*  /S /D
			MOVE /Y TEMP\MP10CUM\update\*.cat WORK\SVCPACK >NUL
			MOVE /Y TEMP\MP10CUM\EasyCDBlock.inf WORK\I386E >NUL
			MOVE /Y TEMP\MP10CUM\wpdtrace.dll TEMP >NUL
			RD /Q/S TEMP\MP10CUM
		)
		SET /A "MPLEVEL=51"
		ECHO Extracting WMP11 components...
		MD TEMP\APPC TEMP\UMDF TEMP\MSC
		IF EXIST TEMP\WMP11\mymusic.inf (
			COPY TEMP\WMP11\mymusic.inf TEMP >NUL
			COPY TEMP\WMP11\*.W* TEMP >NUL
		)
		IF EXIST TEMP\wmp11\wmp11.exe (TEMP\WMP11\wmp11.exe /Q /X:TEMP)
		REM 2020-08-07:
		ATTRIB -R -A -S -H TEMP\*.*  /S /D
		IF NOT %OSLEVEL% EQU 23 IF EXIST TEMP\WMP11\wmpappcompat.exe (
			TEMP\WMP11\wmpappcompat.exe /Q /X:TEMP\APPC
			COPY TEMP\APPC\SP2QFE\* TEMP >NUL
			COPY TEMP\APPC\UPDATE\update_*.inf TEMP\APPC.inf >NUL
			MOVE /Y TEMP\APPC\UPDATE\*.cat WORK\SVCPACK >NUL
		)
		IF NOT EXIST SOURCE\I386\WUDF* IF EXIST TEMP\WMP11\umdf.exe (TEMP\WMP11\umdf.exe /Q /X:TEMP\UMDF)
		IF EXIST TEMP\WMP11\*MSComp*.* IF NOT EXIST SOURCE\I386\msdelta.dl* (
			FOR /F %%I IN ('DIR /B TEMP\WMP11\*MSComp*') DO (TEMP\WMP11\%%I /Q /X:TEMP\MSC)
		)
		IF EXIST TEMP\WMP11\wmfdist11.exe (
			MD TEMP\WMPCOD
			TEMP\WMP11\wmfdist11.exe /Q /X:TEMP\WMPCOD
		)
		IF EXIST TEMP\UMDF (COPY TEMP\UMDF\* TEMP >NUL 2>&1)
		IF EXIST TEMP\MSC (COPY TEMP\MSC\i386\* TEMP >NUL)
		IF EXIST TEMP\WMPCOD\wpdinstallutil.dll (DEL /Q/F TEMP\WMPCOD\wpdinstallutil.dll >NUL)
		IF EXIST TEMP\WMPCOD\LOCBIN\*.* (
			COPY TEMP\WMPCOD\LOCBIN\wpdshextres.dll.%LG3% TEMP\wpdshextres.dll >NUL
			XCOPY /DHY TEMP\WMPCOD\*.* TEMP >NUL
		)
		IF EXIST TEMP\UPDATE\*.cat (MOVE /Y TEMP\UPDATE\*.cat WORK\SVCPACK >NUL)
		IF EXIST TEMP\UMDF\UPDATE\*.cat (MOVE /Y TEMP\UMDF\UPDATE\*.cat WORK\SVCPACK >NUL)
		IF EXIST TEMP\MSC\UPDATE\*.cat (MOVE /Y TEMP\MSC\UPDATE\*.cat WORK\SVCPACK >NUL)
		IF EXIST TEMP\WMPCOD\UPDATE\*.cat (MOVE /Y TEMP\WMPCOD\UPDATE\*.cat WORK\SVCPACK >NUL)
		IF EXIST TEMP\UPDATE\update.inf (FINDSTR /VI "UninstallString" TEMP\UPDATE\update.inf>TEMP\WMP11b.inf)
		IF EXIST TEMP\UMDF\UPDATE\*.inf (COPY TEMP\UMDF\UPDATE\*.inf TEMP\UMDF.inf >NUL)
		IF EXIST TEMP\MSC\UPDATE\*.inf (COPY TEMP\MSC\UPDATE\*.inf TEMP\MSC.inf >NUL)
		IF EXIST temp\wmpcod\update\*.inf (COPY TEMP\WMPCOD\UPDATE\*.inf TEMP\WMFD.inf >NUL)
		
		REM 2020-08-07:
		ATTRIB -R -A -S -H TEMP\*.*  /S /D
		RD /Q/S TEMP\UPDATE TEMP\APPC TEMP\UMDF TEMP\MSC TEMP\WMPCOD
		DEL /Q/F TEMP\wudfcusto*.dll TEMP\*.bmp TEMP\*.jpg TEMP\*.png
	)
)

REM Checks to see if the TEMP directory is empty.
REM The old code of simply checking whether or not the "TEMP" directory exists hasn't worked since at least 1.7.10K V9 (maybe earlier versions).
REM This is because TEMP has been made a permanent directory post-TommyP (?), and thus it is more appropriate to check whehter or not it's empty,
REM not missing/non-existant. Scroll further down to see why this check is important.

CALL :ISNOTEMPTY TEMP
IF NOT DEFINED NOTEMPTY (GOTO :EOF)
SET "NOTEMPTY="

SET /A "HFSLP=150"
ECHO>>WORK\HFSDST.txt PFWMP=16422,"Windows Media Player"
IF EXIST TEMP\custsat.dll (SET /A "CUSTSATSDF=1")
IF EXIST TEMP\*.LNG (
	FOR /F "tokens=2 delims=Mm." %%I IN ('DIR /B TEMP\*.LNG') DO (
		SET "WMLNG=%%I"
		SET /A "DWINTLREN=1"
	)
)
IF EXIST TEMP\wmburn.exe (DEL /Q/F TEMP\wmpband.dll TEMP\unicows.dll TEMP\9xmigrat.dll TEMP\migrate.dll TEMP\w95*.dll)
IF EXIST TEMP\advpack.dll (DEL /Q/F TEMP\advpack.dll)
IF EXIST TEMP\msoobci.dll (
	MOVE /Y TEMP\msoobci.dll WORK\I386E
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif msoobci.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msoobci.dll
	ECHO>>WORK\HFSSDF.txt msoobci.dll=1
	ECHO>>WORK\HFS_PFWMP.txt msoobci.dll
)
DIR /B TEMP\*.dll>>WORK\NSFREGt.txt
IF EXIST TEMP\wmsetsdk.exe (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmsetsdk.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmsetsdk.exe
	ECHO>>WORK\HFSSDF.txt wmsetsdk.exe=1
	ECHO>>WORK\HFS_PFWMP.txt wmsetsdk.exe
)
IF EXIST TEMP\eula.txt (
	REN TEMP\eula.txt wmp_eula.txt
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmp_eula.txt = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmp_eula.txt
	ECHO>>WORK\HFSSDF.txt wmp_eula.txt=1
	ECHO>>WORK\HFS_PFWMP.txt eula.txt,wmp_eula.txt
)
REM The old looks.
IF "%INCALLSKINS%"=="1" (
	FOR %%I IN (Atomic Bluesky Canvas Classic Goo Heart Iconic Optik Pyrite Radio Roundlet Rusty Splat Toothy) DO (
		IF EXIST SOURCE\I386\%%I.wm* (
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I.wmz = 1,,,,,,,,3,3
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I.wmz
			ECHO>>WORK\HFSSDF.txt %%I.wmz=1
			ECHO>>WORK\HFS_PFWMPSKINS.txt %%I.wmz
			SET /A "SKINSADDED=1"
		)
	)
	IF EXIST SOURCE\I386\HEADSP~1.wm* (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif HEADSP~1.wmz = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HEADSP~1.wmz
		ECHO>>WORK\HFSSDF.txt HEADSP~1.wmz=1
		ECHO>>WORK\HFS_PFWMPSKINS.txt Headspace.wmz,HEADSP~1.wmz
		SET /A "SKINSADDED=1"
	)
	IF EXIST SOURCE\I386\MINIPL~1.wm* (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif MINIPL~1.wmz = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,MINIPL~1.wmz
		ECHO>>WORK\HFSSDF.txt MINIPL~1.wmz=1
		ECHO>>WORK\HFS_PFWMPSKINS.txt Miniplayer.wmz,MINIPL~1.wmz
		SET /A "SKINSADDED=1"
	)
	IF EXIST SOURCE\I386\pro.wm* (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif pro.wmz = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,pro.wmz
		ECHO>>WORK\HFSSDF.txt pro.wmz=1
		ECHO>>WORK\HFS_PFWMPSKINS.txt Windows Classic.wmz,pro.wmz
		SET /A "SKINSADDED=1"
	)
	IF EXIST SOURCE\I386\personal.wm* (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif personal.wmz = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,personal.wmz
		ECHO>>WORK\HFSSDF.txt personal.wmz=1
		ECHO>>WORK\HFS_PFWMPSKINS.txt Windows XP.wmz,personal.wmz
		SET /A "SKINSADDED=1"
	)
) ELSE IF "%INCWMPCSKIN%"=="1" IF EXIST SOURCE\I386\CLASSIC.wm* (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif Classic.wmz = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,Classic.wmz
	ECHO>>WORK\HFSSDF.txt Classic.wmz=1
	ECHO>>WORK\HFS_PFWMPSKINS.txt Classic.wmz
	SET /A "SKINSADDED=1"
)
IF EXIST TEMP\wmplayer.exe (SET /A "SKINSADDED=1")
IF DEFINED SKINSADDED (
	ECHO>>WORK\HFSDST.txt PFWMPSKINS=16422,"Windows Media Player\Skins"
	SET "SKINSADDED="
)

REM Since :WMSLIP is called without any checks as to whether is needs to be called (i.e. is anything WMP-related being slip-streamed), with the
REM old check above, the following code would execute. This would result in .ini entries being added that resulted in the setup program for
REM Windows 2000 to look for a file that didn't exist, among other things.

IF "%VERSION%"=="2000" (
	IF EXIST TEMP\drm.inf (DEL /Q/F TEMP\drm.inf TEMP\fhg.inf)
	IF EXIST HFCLEANUP\*dowsMed* (SET /A "NOWMPLOGPI=1")
	IF EXIST HFCLEANUP\*WMP* (SET /A "NOWMPLOGPI=1")
	IF DEFINED NOWMPLOGPI (
		DEL /Q/F TEMP\setup_wm.exe
	) ELSE (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif setup_wm.exe = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,setup_wm.exe
		ECHO>>WORK\HFSSDF.txt setup_wm.exe=1
		ECHO>>WORK\HFS_PFWMP.txt setup_wm.exe
		IF EXIST TEMP\blackbox.dll (
			IF EXIST FDVFILES\TXTSETUP.sif (
				SET /A "NOWMPLOGPI=1"
				FINDSTR /BIR "laprxy\.dll logagent\.exe" FDVFILES\TXTSETUP.sif>WORK\FDVLAPLOG.txt
				FOR /F "delims==	 " %%I IN (WORK\FDVLAPLOG.txt) DO (
					ECHO>>WORK\HFSSDF.txt %%I=1
					ECHO>>WORK\HFS_SYS32.txt %%I
					IF "%%I"=="logagent.exe" (SET "NOWMPLOGPI=")
				)
			) ELSE (
				ECHO>>WORK\HFSSDF.txt laprxy.dll=1
				ECHO>>WORK\HFS_SYS32.txt laprxy.dll
				ECHO>>WORK\HFSSDF.txt logagent.exe=1
				ECHO>>WORK\HFS_SYS32.txt logagent.exe
			)
		)
	)
)
REM WMP9 Core
IF EXIST TEMP\wmburn.exe (
	IF "%ForceWMP9Streaming%"=="1" (ECHO>>WORK\HFREGWU.txt HKU,".DEFAULT\Software\Microsoft\MediaPlayer\Preferences","ForceOnline",0x10001,1)
	IF "%LCIDD%"=="1031" (
		DEL /Q/F TEMP\dwintl.dll
		IF NOT EXIST WORK\I386E\dwintl.dll (COPY SOURCE\I386\dwintl.dll WORK\I386E >NUL 2>&1 || EXPAND SOURCE\I386\dwintl.dl_ -R WORK\I386E >NUL)
	)
	ECHO>>WORK\HFSDST.txt PFWMPLCID=16422,"Windows Media Player\%WMLNG%"
	ECHO>>WORK\HFS_PFWMPLCID.txt dwintl.dll,dwil%WMLNG%.dll
	COPY /Y TEMP\wmp.inf WORK\I386E >NUL
	DEL /Q/F TEMP\iexpress.inf TEMP\setup_wm.inf TEMP\skins*.inf TEMP\9SeriesDefault.wmz TEMP\wmexpack.*
	IF EXIST TEMP\QuickSilver.wmz (DEL /Q/F TEMP\QuickSilver.wmz)
	REN "TEMP\9SeriesDefault_.wmz" 9SeriesD.wmz
	REN TEMP\PidGen.dll WMPidGen.dll
	ECHO>>WORK\HHIVADD.txt HKCR,"Windows Media\WMSDK\AudioDecode\85","DllName",,"l3codeca.acm"
	
	REM *@*
	REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s "%%ProgramFiles%%\Windows Media Player\mpvis.dll"
	ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","110",0,"%%11%%\regsvr32 /s """%%16422%%\Windows Media Player\mpvis.dll""""
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif 9SeriesD.wmz = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif Compact.wmz = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif Revert.wmz = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmplayer.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif migrate.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif npdrmv2.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif npdrmv2.zip = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif WMPidGen.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpns.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpns.jar = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mpvis.dll = 1,,,,,,,,3,3	
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,9SeriesD.wmz
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,Compact.wmz
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,Revert.wmz
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmplayer.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,migrate.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,npdrmv2.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,npdrmv2.zip
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,WMPidGen.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpns.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpns.jar
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mpvis.dll
	
	ECHO>>WORK\HFSSDF.txt 9SeriesD.wmz=1
	ECHO>>WORK\HFSSDF.txt Compact.wmz=1
	ECHO>>WORK\HFSSDF.txt Revert.wmz=1
	ECHO>>WORK\HFSSDF.txt wmplayer.exe=1
	ECHO>>WORK\HFSSDF.txt migrate.exe=1
	ECHO>>WORK\HFSSDF.txt npdrmv2.dll=1
	ECHO>>WORK\HFSSDF.txt npdrmv2.zip=1
	ECHO>>WORK\HFSSDF.txt WMPidGen.dll=1
	ECHO>>WORK\HFSSDF.txt wmpns.dll=1
	ECHO>>WORK\HFSSDF.txt wmpns.jar=1
	ECHO>>WORK\HFSSDF.txt mpvis.dll=1
	
	ECHO>>WORK\HFS_PFWMPSKINS.txt 9SeriesDefault.wmz,9SeriesD.wmz
	ECHO>>WORK\HFS_PFWMPSKINS.txt Compact.wmz
	ECHO>>WORK\HFS_PFWMPSKINS.txt Revert.wmz
	
	ECHO>>WORK\HFS_PFWMP.txt wmplayer.exe
	ECHO>>WORK\HFS_PFWMP.txt custsat.dll
	ECHO>>WORK\HFS_PFWMP.txt dw15.exe
	ECHO>>WORK\HFS_PFWMP.txt migrate.exe
	ECHO>>WORK\HFS_PFWMP.txt npdrmv2.dll
	ECHO>>WORK\HFS_PFWMP.txt npdrmv2.zip
	ECHO>>WORK\HFS_PFWMP.txt PidGen.dll,WMPidGen.dll
	ECHO>>WORK\HFS_PFWMP.txt wmpns.dll
	ECHO>>WORK\HFS_PFWMP.txt wmpns.jar
	ECHO>>WORK\HFS_PFWMP.txt mpvis.dll
	
	REM ROXY... OH...
	ECHO>>WORK\HFSDST.txt PFWMPROX=16422,"Windows Media Player\Roxio"
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmburn.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmburn.rxc = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif rsl.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wm%WMLNG%.lng = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif engsetup.exe = 1,,,,,,,999,0,0
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmburn.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmburn.rxc
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,rsl.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wm%WMLNG%.lng
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,engsetup.exe
	
	ECHO>>WORK\HFSSDF.txt wmburn.exe=1
	ECHO>>WORK\HFSSDF.txt wmburn.rxc=1
	ECHO>>WORK\HFSSDF.txt rsl.dll=1
	ECHO>>WORK\HFSSDF.txt wm%WMLNG%.lng=1
	
	ECHO>>WORK\HFS_PFWMPROX.txt wmburn.exe
	ECHO>>WORK\HFS_PFWMPROX.txt wmburn.rxc
	ECHO>>WORK\HFS_PFWMPROX.txt rsl.dll
	ECHO>>WORK\HFS_PFWMPROX.txt wm%WMLNG%.lng
	
	REM MS screwups.
	FINDSTR /VIR "\[WMP\. \,5 49452" TEMP\roxio.inf>WORK\roxio.inf
	ECHO>>WORK\roxio.inf [WMP.Destination]
	ECHO>>WORK\roxio.inf 49000,49001,49002=ProgramFilesDir,5
	ECHO>>WORK\roxio.inf 49450,49451,49452=WMPDirectory,5
	ECHO>>WORK\roxio.inf 49500,49501,49502=RoxioDirectory,5
	ECHO>>WORK\roxio.inf 49600,49601,49602=RoxioOldWMBurnDir,5
	MOVE /Y WORK\roxio.inf TEMP
	REN TEMP\roxio.inf zroxio.inf >NUL
)
REM WMP10 Core
IF EXIST TEMP\QuickSi.wmz (
	COPY /Y TEMP\WMP10.inf WORK\I386E >NUL
	DEL /Q/F TEMP\*.PNG
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif 9SeriesD.wmz = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif QuickSi.wmz = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmlaunch.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpenc.exe = 1,,,,,,,,3,3
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,9SeriesD.wmz
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,QuickSi.wmz
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmlaunch.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpenc.exe
	
	ECHO>>WORK\HFSSDF.txt 9SeriesD.wmz=1
	ECHO>>WORK\HFSSDF.txt QuickSi.wmz=1
	ECHO>>WORK\HFSSDF.txt wmlaunch.exe=1
	ECHO>>WORK\HFSSDF.txt wmpenc.exe=1
	
	ECHO>>WORK\HFS_PFWMPSKINS.txt 9SeriesDefault.wmz,9SeriesD.wmz
	ECHO>>WORK\HFS_PFWMPSKINS.txt QuickSilver.wmz,QuickSi.wmz
	ECHO>>WORK\HFS_PFWMP.txt wmlaunch.exe
	ECHO>>WORK\HFS_PFWMP.txt wmpenc.exe
	
	IF %OSLEVEL% EQU 23 DEL /Q/F TEMP\custsat.dll
	IF "%VERSION%"=="XP" IF %SP% EQU 1 (
		REM *@*
		REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s "%%ProgramFiles%%\Windows Media Player\mpvis.dll"
		REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s "%%ProgramFiles%%\Windows Media Player\wmpband.dll"
		ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","110",0,"%%11%%\regsvr32 /s """%%16422%%\Windows Media Player\mpvis.dll""""
		ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","111",0,"%%11%%\regsvr32 /s """%%16422%%\Windows Media Player\wmpband.dll""""
		
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif Revert.wmz = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif migrate.exe = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif mpvis.dll = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpband.dll = 1,,,,,,,,3,3
		
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,Revert.wmz
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,migrate.exe
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mpvis.dll
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpband.dll
		
		ECHO>>WORK\HFSSDF.txt Revert.wmz=1
		ECHO>>WORK\HFSSDF.txt migrate.exe=1
		ECHO>>WORK\HFSSDF.txt mpvis.dll=1
		ECHO>>WORK\HFSSDF.txt wmpband.dll=1
		
		ECHO>>WORK\HFS_PFWMPSKINS.txt Revert.wmz
		
		ECHO>>WORK\HFS_PFWMP.txt migrate.exe
		ECHO>>WORK\HFS_PFWMP.txt custsat.dll
		ECHO>>WORK\HFS_PFWMP.txt mpvis.dll
		ECHO>>WORK\HFS_PFWMP.txt wmpband.dll
		
		REM New to old.
		COPY TEMP\mpvis.dll TEMP\wmpvis.dll >NUL
	)
)
REM WMP11 Main
IF EXIST TEMP\wmpeffects.dll (
	SET "DefWMPReg=%DefWMPReg%,Product.Add.Reg,Reg.FSDKVersion,HideReg.WMP10.Qfe,UmdfInstall_Add_Reg,Info_AddReg,Hide.WMC20.Uninstall"
	
	REM *@*
	REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s "%%ProgramFiles%%\Windows Media Player\wmpband.dll"
	REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s "%%ProgramFiles%%\Windows Media Player\wmpnssci.dll"
	ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","111",0,"%%11%%\regsvr32 /s """%%16422%%\Windows Media Player\wmpband.dll""""
	ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","112",0,"%%11%%\regsvr32 /s """%%16422%%\Windows Media Player\wmpnssci.dll""""
	
	IF NOT EXIST SOURCE\I386\wmlaunch.ex* (
		REM *@*
		REM ECHO>>WORK\RGSVRWU.txt "%%ProgramFiles%%\Windows Media Player\WMPEnc.exe" /RegServer
		ECHO>>WORK\HFSLIPCMDP1.cmd "%%PROGRAMFILES%%\Windows Media Player\WMPEnc.exe" /RegServer
	)
	
	REM *@*
	REM ECHO>>WORK\RGSVRWU.txt "%%ProgramFiles%%\Windows Media Player\WMPNetwk.exe" install
	REM ECHO>>WORK\RGSVRWU.txt %%SYSTEMROOT%%\INF\unregmp2.exe /Shortcuts /RegExts /ObfuscateSyncPlaylists /MigrateWMC
	ECHO>>WORK\HFSLIPCMDP1.cmd "%%PROGRAMFILES%%\Windows Media Player\WMPNetwk.exe" install
	ECHO>>WORK\HFSLIPCMDP1.cmd %%SYSTEMROOT%%\inf\unregmp2.exe /Shortcuts /RegExts /ObfuscateSyncPlaylists /MigrateWMC
	COPY /Y TEMP\wmp11.inf WORK\I386E >NUL
	
	REM Core
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\wmpeffects.dll" wmpeffex.dll
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\wmdbexport.exe" wmdbxprt.exe
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\LegitLibM.dll" LegitLbM.dll
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpeffex.dll = 1,,,,,,,2,0,0,wmpeffects.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmdbxprt.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpeffex.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmdbxprt.exe
	
	IF NOT EXIST SOURCE\I386\wmlaunch.ex* (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpenc.exe = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmlaunch.exe = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpenc.exe
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmlaunch.exe
		
		ECHO>>WORK\HFSSDF.txt wmpenc.exe=1
		ECHO>>WORK\HFSSDF.txt wmlaunch.exe=1
		ECHO>>WORK\HFS_PFWMP.txt wmpenc.exe
		ECHO>>WORK\HFS_PFWMP.txt wmlaunch.exe
	)
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpnetwk.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpnscfg.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpnssci.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmpshare.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif LegitLbM.dll = 1,,,,,,,,3,3
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpnetwk.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpnscfg.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpnssci.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmpshare.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,LegitLbM.dll
	
	ECHO>>WORK\HFSSDF.txt wmdbxprt.exe=1
	ECHO>>WORK\HFSSDF.txt wmpnetwk.exe=1
	ECHO>>WORK\HFSSDF.txt wmpnscfg.exe=1
	ECHO>>WORK\HFSSDF.txt wmpnssci.dll=1
	ECHO>>WORK\HFSSDF.txt wmpshare.exe=1
	ECHO>>WORK\HFSSDF.txt LegitLbM.dll=1
	
	ECHO>>WORK\HFS_PFWMP.txt wmdbexport.exe,wmdbxprt.exe
	ECHO>>WORK\HFS_PFWMP.txt wmpnetwk.exe
	ECHO>>WORK\HFS_PFWMP.txt wmpnscfg.exe
	ECHO>>WORK\HFS_PFWMP.txt wmpnssci.dll
	ECHO>>WORK\HFS_PFWMP.txt wmpshare.exe
	ECHO>>WORK\HFS_PFWMP.txt LegitLibM.dll,LegitLbM.dll
	
	REM WMC
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\connectionmanager.xml" connman.xml
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\contentdirectory.xml" contdir.xml
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\mediareceiverregistrar.xml" mrecreg.xml
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\connectionmanager_stub.xml" connmans.xml
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\contentdirectory_stub.xml" contdirs.xml
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\mediareceiverregistrar_stub.xml" mrecregs.xml
	
	ECHO>>WORK\HFSDST.txt PFWMPNWS=16422,"Windows Media Player\Network Sharing"
	ECHO>>WORK\HFSDST.txt PFWMC2=16422,"Windows Media Connect 2"
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif connman.xml = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif contdir.xml = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mrecreg.xml = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmccds.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif WMCCFG.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif WMCCPL.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wmcsci.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif connmans.xml = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif contdirs.xml = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mrecregs.xml = 1,,,,,,,,3,3
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,connman.xml
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,contdir.xml
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mrecreg.xml
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmccds.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,WMCCFG.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,WMCCPL.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wmcsci.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,connmans.xml
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,contdirs.xml
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mrecregs.xml
	
	ECHO>>WORK\HFSSDF.txt connman.xml=1
	ECHO>>WORK\HFSSDF.txt contdir.xml=1
	ECHO>>WORK\HFSSDF.txt mrecreg.xml=1
	ECHO>>WORK\HFSSDF.txt wmccds.exe=1
	ECHO>>WORK\HFSSDF.txt WMCCFG.exe=1
	ECHO>>WORK\HFSSDF.txt WMCCPL.dll=1
	ECHO>>WORK\HFSSDF.txt wmcsci.dll=1
	ECHO>>WORK\HFSSDF.txt connmans.xml=1
	ECHO>>WORK\HFSSDF.txt contdirs.xml=1
	ECHO>>WORK\HFSSDF.txt mrecregs.xml=1
	
	ECHO>>WORK\HFS_PFWMPNWS.txt connectionmanager.xml,connman.xml
	ECHO>>WORK\HFS_PFWMPNWS.txt contentdirectory.xml,contdir.xml
	ECHO>>WORK\HFS_PFWMPNWS.txt mediareceiverregistrar.xml,mrecreg.xml
	
	ECHO>>WORK\HFS_PFWMC2.txt wmccds.exe
	ECHO>>WORK\HFS_PFWMC2.txt WMCCFG.exe
	ECHO>>WORK\HFS_PFWMC2.txt WMCCPL.dll
	ECHO>>WORK\HFS_PFWMC2.txt wmcsci.dll
	ECHO>>WORK\HFS_PFWMC2.txt connectionmanager.xml,connmans.xml
	ECHO>>WORK\HFS_PFWMC2.txt contentdirectory.xml,contdirs.xml
	ECHO>>WORK\HFS_PFWMC2.txt mediareceiverregistrar.xml,mrecregs.xml
	REM Extra
	IF NOT EXIST SOURCE\I386\WUDF* (
		ECHO>>WORK\RENAME.cmd REN "WORK\I386E\WUDFCoinstaller.dll" wudfcoin.dll
		ECHO>>WORK\RENAME.cmd REN "WORK\I386E\WudfPlatform.dll" wudfplat.dll
		
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wudfcoin.dll = 1,,,,,,,2,0,0,WUDFCoinstaller.dll
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wudfplat.dll = 1,,,,,,,2,0,0,WudfPlatform.dll
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wudfcoin.dll
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wudfplat.dll
	)
)
REM Codecs
IF EXIST TEMP\WMP11\wmfdist11.exe (
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\PortableDeviceApi.dll" PDvApi.dll
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\PortableDeviceClassExtension.dll" PDvClass.dll
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\PortableDeviceTypes.dll" PDvTypes.dll
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\PortableDeviceWiaCompat.dll" PDvWiaCm.dll
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\PortableDeviceWMDRM.dll" PDvWMDRM.dll
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\wpdshextautoplay.exe" wpdshext.exe
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\wpdshextres.dll" wpdshext.res
	ECHO>>WORK\RENAME.cmd REN "WORK\I386E\WPDShServiceObj.dll" wpdshsrv.dll
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif PDvApi.dll = 1,,,,,,,2,0,0,PortableDeviceApi.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif PDvClass.dll = 1,,,,,,,2,0,0,PortableDeviceClassExtension.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif PDvTypes.dll = 1,,,,,,,2,0,0,PortableDeviceTypes.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif PDvWiaCm.dll = 1,,,,,,,2,0,0,PortableDeviceWiaCompat.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif PDvWMDRM.dll = 1,,,,,,,2,0,0,PortableDeviceWMDRM.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wpdshext.exe = 1,,,,,,,2,0,0,wpdshextautoplay.exe
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wpdshext.res = 1,,,,,,,2,0,0,wpdshextres.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif wpdshsrv.dll = 1,,,,,,,2,0,0,WPDShServiceObj.dll
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,PDvApi.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,PDvClass.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,PDvTypes.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,PDvWiaCm.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,PDvWMDRM.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wpdshext.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wpdshext.res
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wpdshsrv.dll
	
	IF NOT EXIST SOURCE\I386\wpdmtpdr.dl* (
		SET /A "TXTDIR04=1"
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wpdmtpdr.dll = 1,,,,,,,1004,0,0
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wpdmtpdr.dll
	)
)
IF EXIST TEMP\*.WPL (
	FOR /F %%I IN ('DIR /B TEMP\*.WPL') DO (
		IF NOT EXIST SOURCE\I386\%%~nI.WP* (DEL /Q/F TEMP\%%I)
	)
)
IF EXIST TEMP\control.xml (DEL /Q/F TEMP\control.xml)
IF EXIST TEMP\mymusic.inf (DEL /Q/F TEMP\mymusic.inf)
IF EXIST TEMP\wpdmtp*.inf (MOVE /Y TEMP\wpdmtp*.inf WORK\I386E >NUL)
IF EXIST TEMP\*.cat (MOVE /Y TEMP\*.cat WORK\SVCPACK >NUL)

IF EXIST TEMP\*.inf (
	FOR /F %%I IN ('DIR /B/ON TEMP\*.inf') DO (
		SET /A "HFSLP+=1"
		SET "HFSLP2=%%I"
		CALL :WMPINFCREATOR
		DEL /Q/F TEMP\%%I
	)
)
SET "DefWMPReg="
SET "NOWMPLOGPI="
IF DEFINED RDWMP11DIR (
	RD /Q/S TEMP\WMP11
	SET "RDWMP11DIR="
)
XCOPY /DHY TEMP WORK\I386E
CALL :CLEANTEMP
ECHO/
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Windows Media Player - Legacy WMP (Pre-WMP11) ----------
:LEGACYWMP
IF EXIST HF\MP10Setup.exe IF %MPLEVEL% LSS 41 (
	SET /A "MPLEVEL=42"
	ECHO Processing MP10Setup.exe...
	MD TEMP
	HF\MP10Setup.exe /Q:A /T:"%PREP%\TEMP" /C
)
IF EXIST HF\*%MCEMP10CUM%*.exe IF %MPLEVEL% GEQ 41 (
	SET /A "MPLEVEL=43"
	ECHO Processing %MCEMP10CUM%...
	MD TEMP\MP10CUM
	FOR /F %%I IN ('DIR /B HF\*%MCEMP10CUM%*.exe') DO (HF\%%I /Q /X:TEMP\MP10CUM)
	REM 2020-08-07:
	ATTRIB -R -A -S -H TEMP\*.*  /S /D
	MOVE /Y TEMP\MP10CUM\update\*.cat WORK\SVCPACK >NUL
	DEL /Q/F TEMP\MP10CUM\empty.cat TEMP\MP10CUM\%MCEMP10CUM%.exe TEMP\MP10CUM\spu*
	XCOPY /DY TEMP\MP10CUM TEMP >NUL
)
IF EXIST HF\WindowsMedia-KB891122*.exe IF %MPLEVEL% LSS 42 IF NOT EXIST HF\wmfdist95.exe (
	FOR /F %%I IN ('DIR /B HF\WindowsMedia-KB891122*.exe') DO (
		MD WORK\WMFD
		HF\%%I /Q /X:WORK\WMFD
		MOVE WORK\WMFD\wmfdist95.exe HF >NUL
		ECHO>>WORK\FILESTODEL.txt HF\wmfdist95.exe
	)
)
IF EXIST HF\wmfdist95.exe IF %MPLEVEL% LSS 43 (
	ECHO Processing wmfdist95.exe...
	MD WORK\WMFD2
	HFTOOLS\7za.exe x HF\wmfdist95.exe -o"%PREP%\WORK\WMFD2" -r >NUL
	IF EXIST WORK\WMFD2\MFPLAT.dll (
		SET /A "MPLEVEL=43"
	) ELSE (
		IF %MPLEVEL% GEQ 42 (GOTO :LEGACYWMP2)
		SET /A "MPLEVEL=42"
	)
	MD TEMP\X
	XCOPY /DY WORK\WMFD2 TEMP >NUL
	REM 2020-08-07:
	ATTRIB -R -A -S -H TEMP\*.*  /S /D
)
IF NOT EXIST TEMP\*.inf (GOTO :EOF)
:LEGACYWMP2
IF "%VERSION%"=="XP" IF %SP% GEQ 2 (
	IF EXIST TEMP\codecs10.inf (DEL /Q/F TEMP\codecs10.inf)
	IF DEFINED XPMCE (
		FOR %%I IN (WMDM10 WMFSDK10 WPD10 wpdmtp) DO (DEL /Q/F TEMP\%%I.inf)
	)
)
FOR %%I IN (DRM10 MPCD10 MPPRE10 MPSTUB10 skins skinsmui WMSET10 wmsetsdk) DO (
	IF EXIST TEMP\%%I.inf (DEL /Q/F TEMP\%%I.inf)
)
IF EXIST TEMP\EasyCDBlock.inf (MOVE /Y TEMP\EasyCDBlock.inf WORK\I386E >NUL)
GOTO :EOF
REM ---------- ----------

REM ---------- Add WMP Entries into HFSLIPx.inf ----------
:WMPINFCREATOR
IF "%HFSLP2%"=="WMV9VCM.inf" (
	COPY TEMP\%HFSLP2% %SOURCESS%\I386\HFSLP%HFSLP%.inf >NUL
	GOTO :WMPROROE
)
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf [Version]
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf Signature="$WINDOWS NT$"
ECHO/>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
IF "%HFSLP2%"=="wudf_update.inf" (
	REM *@*
	REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLP%HFSLP%.inf,DefaultInstall.Services
	ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZA","%HFSLP%",0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\HFSLP%HFSLP%.inf,DefaultInstall.Services"
	TYPE TEMP\%HFSLP2%>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
	GOTO :WMPTXTDSN
)
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf [DefaultInstall]
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=%DefWMPReg%
IF "%HFSLP2%"=="WMFSDK.inf" IF NOT DEFINED NOWMPLOGPI (ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf RunPostSetupCommands=RunPost)
IF "%HFSLP2%"=="wmp.inf" (
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf RunPostSetupCommands=HelperUtility.Install
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf CustomDestination=WMP.Destination
)
IF "%HFSLP2%"=="zroxio.inf" (
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf RunPreSetupCommands=InstallEngine
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf CustomDestination=WMP.Destination
)
ECHO/>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
FINDSTR /VI "DefaultInstall" TEMP\%HFSLP2%>>%SOURCESS%\I386\HFSLP%HFSLP%.inf

:WMPROROE
REM *@*
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLP%HFSLP%.inf,,1
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZA","%HFSLP%",0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\HFSLP%HFSLP%.inf,DefaultInstall"

:WMPTXTDSN
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLP%HFSLP%.inf = 1,,,,,,,999,0,0
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLP%HFSLP%.inf
GOTO :EOF
REM ---------- ----------


REM ******************** DirectX 9 ********************


REM ---------- DX9C ----------
:DX9C
TITLE %T1% - DX9C
ECHO/
ECHO Processing DirectX
ECHO/

IF EXIST HFCABS\_DX9core_%VERSION%SP%SP%_HFSLIP.cab (
	ECHO Expanding custom DX9core source cab...
	MD WORK\DX9HFSLP
	EXPAND HFCABS\_DX9core_%VERSION%SP%SP%_HFSLIP.cab -F:* WORK\DX9HFSLP >NUL
) ELSE (
	IF %OSLEVEL% GEQ 31 (
		CALL :DX9C_PREP
	) ELSE (
		GOTO :DX9C_BASIC
	)
)
REM The real stuff.
ECHO Processing DirectX9c core components...
IF %OSLEVEL% GEQ 31 (
	SET "DX9=Updated"
	DIR /B WORK\DX9HFSLP\*.dll>>WORK\NSFREGt.txt
	ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\DirectPlay\Service Providers\Internet TCP/IP Connection For DirectPlay","NATHelp",,"dpnhupnp.dll"
	REM @;
	ECHO>>WORK\ROROEWU.txt ;DX9C
	REM *@*
	REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dmusic.inf,,1
	REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dsound.inf,,1
	ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ600,,"rundll32.exe %%11%%\advpack.Dll,LaunchINFSection %%10%%\INF\dmusic.inf,DefaultInstall"
	ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ601,,"rundll32.exe %%11%%\advpack.Dll,LaunchINFSection %%10%%\INF\dsound.inf,DefaultInstall"
)
ECHO/
MOVE /Y WORK\DX9HFSLP\*.cat WORK\SVCPACK
XCOPY /DHY WORK\DX9HFSLP WORK\I386E
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- DX9C - Prep ----------
:DX9C_PREP
IF DEFINED BDACAB IF EXIST HFCABS\!BDACAB!.cab (
	ECHO Expanding !BDACAB!.cab...
	EXPAND HFCABS\!BDACAB!.cab -F:* WORK\DX9 >NUL
)
REM TODO Is this DXNT check really necessary if this code will only ever run because of an earlier DXNT check for function DX9C?
IF DEFINED DXNT IF EXIST HFCABS\dxnt.cab (
	ECHO Expanding dxnt.cab...
	EXPAND HFCABS\dxnt.cab -F:* WORK\DX9 >NUL
)
MD WORK\DX9HFSLP
IF %OSLEVEL% GEQ 31 (
	DEL /Q/F WORK\DX9\ksreg.inf
	MOVE WORK\DX9\dm* WORK\DX9HFSLP >NUL
	MOVE WORK\DX9\dsound.inf WORK\DX9HFSLP >NUL
	MOVE WORK\DX9\dswave.dll WORK\DX9HFSLP >NUL
	MOVE WORK\DX9\dxnetsrv.cat WORK\DX9HFSLP >NUL
	MOVE WORK\DX9\ks*.inf WORK\DX9HFSLP >NUL
	MOVE WORK\DX9\ksolay.ax WORK\DX9HFSLP >NUL
)
ECHO Creating custom DX9core source cab for future use...
CALL :UNICAB1
ECHO>>UC.ddf .Set CabinetNameTemplate=_DX9core_%VERSION%SP%SP%_HFSLIP.cab
ECHO>>UC.ddf .Set DiskDirectory1=HFCABS
FOR /F %%I IN ('DIR /B WORK\DX9HFSLP') DO (ECHO>>UC.ddf WORK\DX9HFSLP\%%I)
CALL :UNICAB2
GOTO :EOF
REM ---------- ----------

REM ---------- DX9C - Basic ----------
:DX9C_BASIC
IF "%VERSION%"=="2000" (
	EXPAND HFCABS\BDANT.cab -F:* WORK\DX9
) ELSE (
	EXPAND HFCABS\BDAXP.cab -F:* WORK\DX9
)
EXPAND HFCABS\DXNT.cab -F:* WORK\DX9

REM Abort if CAB broken.
IF NOT EXIST WORK\DX9\KS.sys (
	ECHO/>CON
	ECHO WARNING: One or more of the DirectX 9 cabs is corrupt.>CON
	ECHO HFSLIP will abort slipstreaming of DirectX 9.>CON
	ECHO/>CON
	PAUSE>CON
	GOTO :EOF
)

REM Main DX9 install INF.
ECHO>%SOURCESS%\I386\HFSLIPDX.inf [version]
ECHO>>%SOURCESS%\I386\HFSLIPDX.inf signature="$WINDOWS NT$"
ECHO/>>%SOURCESS%\I386\HFSLIPDX.inf
ECHO>>%SOURCESS%\I386\HFSLIPDX.inf [DefaultInstall]
ECHO>>%SOURCESS%\I386\HFSLIPDX.inf AddReg=add.reg
ECHO>>%SOURCESS%\I386\HFSLIPDX.inf DelReg=keys.del,Product.Del.Reg
ECHO/>>%SOURCESS%\I386\HFSLIPDX.inf

IF "%VERSION%"=="2000" (
	REN WORK\DX9\dx9w2k.cat dxnt.cat
	REN WORK\DX9\DX9BDA.cat DXBDA.cat
	DEL /Q/F WORK\DX9\D3D8THK.dll WORK\DX9\MSPQM.sys WORK\DX9\MSVIDCTL.dll WORK\DX9\QUARTZ.dll
	REN WORK\DX9\joy.w2k joy.cpl
	FOR /F %%I IN ('DIR /B WORK\DX9\*.W2K') DO (REN WORK\DX9\%%~nI.w2k %%~nI.dll)
	FINDSTR /VIR "DefaultInstall quartz\.w2k" WORK\DX9\dxntunp.inf>>%SOURCESS%\I386\HFSLIPDX.inf
	REM W2KROLLUP shit.
	IF EXIST WORK\I386E\dplayx.dll (DEL /Q/F WORK\I386E\dplayx.dll)
	IF EXIST WORK\I386E\dpwsockx.dll (DEL /Q/F WORK\I386E\dpwsockx.dll)
) ELSE (
	DEL /Q/F WORK\DX9\d3dim.dll WORK\DX9\d3dpmesh.dll WORK\DX9\d3dramp.dll WORK\DX9\d3drm.dll WORK\DX9\d3dxof.dll WORK\DX9\diactfrm.dll
	DEL /Q/F WORK\DX9\dimap.dll WORK\DX9\dinput.dll WORK\DX9\dinput8.dll WORK\DX9\dsound.vxd WORK\DX9\dxapi.sys WORK\DX9\gcdef.dll
	DEL /Q/F WORK\DX9\pid.dll WORK\DX9\dx9w2k.cat
)
IF "%VERSION%"=="XP" (
	REN WORK\DX9\dxapi.xpg dxapi.sys
	REN WORK\DX9\joy.xpg joy.cpl
	FOR /F %%I IN ('DIR /B WORK\DX9\*.XPG') DO (REN WORK\DX9\%%~nI.xpg %%~nI.dll)
	FINDSTR /VI "DefaultInstall" WORK\DX9\dxxp.inf>>%SOURCESS%\I386\HFSLIPDX.inf
) ELSE (
	DEL /Q/F WORK\DX9\dxxp.cat
)

REM Special DX9 fix fix.
IF EXIST WORK\I386E\QUARTZ.dll (DEL /Q/F WORK\I386E\QUARTZ.dll)

REM No need to register MSHTML again.....
REN WORK\DX9\DXBDA.inf DXBD_.inf
FINDSTR /VIR /C:"MSHTML\.dll" WORK\DX9\DXBD_.inf>WORK\I386E\dxbda.inf

IF EXIST WORK\I386E\MSDMO.dll (DEL /Q/F WORK\I386E\MSDMO.dll)
DEL /Q/F WORK\DX9\DXBD_.inf WORK\DX9\dxntunp.inf WORK\DX9\dxxp.inf WORK\DX9\dxnetsrv.inf WORK\DX9\*.W2K WORK\DX9\*.XPG WORK\DX9\dxnetsrv.cat
DEL /Q/F WORK\DX9\*.CHM WORK\DX9\*.FON WORK\DX9\*.HLP WORK\DX9\*.ini WORK\DX9\*.PNG WORK\DX9\dxnt.inf WORK\DX9\dimaps.inf
REN "WORK\DX9\Mpeg2Data.ax" mpg2data.ax

MOVE /Y WORK\DX9\*.cat WORK\SVCPACK
XCOPY /DEHY WORK\DX9 WORK\I386E

REM Final DX9 install INF.
ECHO>%SOURCESS%\I386\HFSLIPDY.inf [version]
ECHO>>%SOURCESS%\I386\HFSLIPDY.inf signature="$WINDOWS NT$"
ECHO>>%SOURCESS%\I386\HFSLIPDY.inf ;FINALIZES THE DX9 INSTALLATION
ECHO/>>%SOURCESS%\I386\HFSLIPDY.inf
ECHO>>%SOURCESS%\I386\HFSLIPDY.inf [DefaultInstall]
ECHO>>%SOURCESS%\I386\HFSLIPDY.inf AddReg=add.reg
ECHO>>%SOURCESS%\I386\HFSLIPDY.inf DelReg=keys.del,Product.Del.Reg
ECHO/>>%SOURCESS%\I386\HFSLIPDY.inf
ECHO>>%SOURCESS%\I386\HFSLIPDY.inf [add.reg]
IF "%VERSION%"=="2000" (
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",010,,"RUNDLL32.exe streamci,StreamingDeviceSetup {97ebaacc-95bd-11d0-a3ea-00a0c9223196},{53172480-4791-11D0-A5D6-28DB04C10000},{53172480-4791-11D0-A5D6-28DB04C10000}"
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",020,,"RUNDLL32.exe streamci,StreamingDeviceSetup {DDF4358E-BB2C-11D0-A42F-00A0C9223196},{97EBAACB-95BD-11D0-A3EA-00A0C9223196},{97EBAACB-95BD-11D0-A3EA-00A0C9223196}"
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",030,,"RUNDLL32.exe streamci,StreamingDeviceSetup {96E080C7-143C-11D1-B40F-00A0C9223196},{3C0D501A-140B-11D1-B40F-00A0C9223196},{3C0D501A-140B-11D1-B40F-00A0C9223196}"
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",040,,"rundll32.exe streamci,StreamingDeviceSetup {8E60217D-A2EE-47f8-B0C5-0F44C55F66DC},GLOBAL,{FD0A5AF4-B41D-11d2-9C95-00C04F7971E0},%%10%%\inf\mpe.inf,BDAcodec"
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",050,,"rundll32.exe streamci,StreamingDeviceSetup {D84D449B-62FB-4ebb-B969-5183ED3DFB51},GLOBAL,{71985F4A-1CA1-11d3-9CC8-00C04F7971E0},%%10%%\inf\streamip.inf,BDAcodec"
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",060,,"rundll32.exe streamci,StreamingDeviceSetup {03884CB6-E89A-4deb-B69E-8DC621686E6A},GLOBAL,{FD0A5AF4-B41D-11d2-9C95-00C04F7971E0},%%10%%\inf\slip.inf,VBIcodec"
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",070,,"rundll32.exe streamci,StreamingDeviceSetup {562370a8-f8dd-11d2-bc64-00a0c95ec22e},GLOBAL,{07DAD660-22F1-11d1-A9F4-00C04FBBDE8F},%%10%%\inf\CCDECODE.inf,CCDECODE.Interface.Install"
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",080,,"rundll32.exe streamci,StreamingDeviceSetup {07DAD662-22F1-11d1-A9F4-00C04FBBDE8F},GLOBAL,{07DAD660-22F1-11d1-A9F4-00C04FBBDE8F},%%10%%\inf\NABTSFEC.inf,NABTSFEC.Interface.Install"
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",090,,"rundll32.exe streamci,StreamingDeviceSetup {70BC06E0-5666-11d3-A184-00105AEF9F33},GLOBAL,{07DAD660-22F1-11d1-A9F4-00C04FBBDE8F},%%10%%\inf\WSTCODEC.inf,WSTCODEC.Interface.Install"
)
ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ",100,,"%%11%%\dxdllreg.exe"

REM *@*
REM ECHO>>WORK\ROROEWU.txt ::DX9C Basic
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLIPDX.inf,,1
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dxver.inf,,1
REM IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\diactfrm.inf,,1)
REM IF NOT "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dpvoice.inf,,1)
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dmusic.inf,,1
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dsound.inf,,1
REM IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dinput.inf,Win2KRegInstall)
REM IF "%VERSION%"=="XP" (ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dinput.inf,WinXPRegInstall)
REM IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\ksreg.inf,KS.Registration)
REM 2020-08-07: bugfix
REM IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dplay.inf,GameVoice)
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dplay.inf,DPlayNAT
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dxdllreg.inf,DirectShow
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dxdllreg.inf,DirectSound
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dxdllreg.inf,DirectPlay
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dxdllreg.inf,DxDiag
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dxdllreg.inf,DX8RetailDLLs
REM IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\dxbda.inf,BDADllRegister)

ECHO>>WORK\ROROEWU.txt ;DX9C
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ600,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\HFSLIPDX.inf,DefaultInstall"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ602,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dxver.inf,DefaultInstall"
IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ603,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\diactfrm.inf,DefaultInstall")
IF NOT "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ604,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dpvoice.inf,DefaultInstall")
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ605,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dmusic.inf,DefaultInstall"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ606,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dsound.inf,DefaultInstall"
IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ607,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dinput.inf,Win2KRegInstall")
IF "%VERSION%"=="XP" (ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ607,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dinput.inf,WinXPRegInstall")
IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ608,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\ksreg.inf,KS.Registration")

IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ609,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dplay.inf,GameVoice")
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ610,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dplay.inf,DPlayNAT"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ611,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dxdllreg.inf,DirectShow"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ612,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dxdllreg.inf,DirectSound"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ613,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dxdllreg.inf,DirectPlay"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ614,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dxdllreg.inf,DxDiag"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ615,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dxdllreg.inf,DX8RetailDLLs"
IF "%VERSION%"=="2000" (ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ616,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dxbda.inf,BDADllRegister")
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ617,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dsound.inf,DefaultInstall"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZZ618,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\INF\dmusic.inf,DefaultInstall"
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ","101",0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\HFSLIPDY.inf,DefaultInstall"

REM *@*
REM "(fucked up & between ECHO and ECHO, or you can throw out the empty one)"
REM "and all because this is spherical SHIT coding in a vacuum"
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLIPDY.inf,,1

FOR /F %%I IN ('DIR /B WORK\DX9') DO (ECHO>>WORK\NSFREGNOT.txt %%I)
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLIPDX.inf = 1,,,,,,,999,0,0
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLIPDX.inf
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLIPDY.inf = 1,,,,,,,999,0,0
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLIPDY.inf
ECHO>>%SOURCESS%\I386\TXTSETUP.sif mpg2data.ax = 1,,,,,,,2,0,0,mpeg2data.ax
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mpg2data.ax
IF "%VERSION%"=="2000" (
	FINDSTR /VBI "ksolay\.ax ksproxy\.ax kstvtune\.ax ksuser\.dll kswdmcap\.ax ksxbar\.ax msyuv\.dll pid\.dll ccdecode\.sys msdv\.sys mskssrv\.sys mspclock\.sys mstee\.sys" %SOURCESS%\I386\TXTSETUP.sif>WORK\TXTSDX9.txt
	MOVE /Y WORK\TXTSDX9.txt %SOURCESS%\I386\TXTSETUP.sif
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif ksolay.ax = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif ksproxy.ax = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif kstvtune.ax = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif ksuser.dll = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif kswdmcap.ax = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif ksxbar.ax = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mciqtz32.dll = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif msyuv.dll = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif pid.dll = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif ccdecode.sys = 1,,,,,,,4,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif msdv.sys = 1,,,,,,,4,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mskssrv.sys = 1,,,,,,,4,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mspclock.sys = 1,,,,,,,4,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mstee.sys = 1,,,,,,,4,0,0
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ksproxy.ax
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,kstvtune.ax
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ksuser.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,kswdmcap.ax
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ksxbar.ax
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mciqtz32.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msyuv.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,pid.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ccdecode.sys
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msdv.sys
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mskssrv.sys
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mspclock.sys
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mstee.sys
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,stream.sys
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,swenum.sys
)
ECHO/
SET "DX9=Slipstreamed"
IF EXIST HF\*-DX9-*.exe (
	FOR /F %%I IN ('DIR /B HF\*-DX9-*.exe') DO (
		SET "HF=%%I"
		CALL :HF1EXTRACT
	)
)
IF EXIST HF\BASIC\*-DX9-*.exe (
	FOR /F %%I IN ('DIR /B HF\BASIC\*-DX9-*.exe') DO (
		SET "HF=%%I"
		CALL :HFBASIC
	)
)
IF EXIST HF\NOREG\*-DX9-*.exe (
	FOR /F %%I IN ('DIR /B HF\NOREG\*-DX9-*.exe') DO (
		SET "HF=%%I"
		CALL :HFNOREG
	)
)

IF EXIST HF\*-DirectX9-*.exe (
	FOR /F %%I IN ('DIR /B HF\*-DirectX9-*.exe') DO (
		SET "HF=%%I"
		CALL :HF1EXTRACT
	)
)
IF EXIST HF\BASIC\*-DirectX9-*.exe (
	FOR /F %%I IN ('DIR /B HF\BASIC\*-DirectX9-*.exe') DO (
		SET "HF=%%I"
		CALL :HFBASIC
	)
)
IF EXIST HF\NOREG\*-DirectX9-*.exe (
	FOR /F %%I IN ('DIR /B HF\NOREG\*-DirectX9-*.exe') DO (
		SET "HF=%%I"
		CALL :HFNOREG
	)
)
TITLE %T1% - DX9C
GOTO :EOF
REM ---------- ----------

REM ---------- DX9 Extras ----------
:DX9EXTRA
TITLE %T1% - DX9C Extras
ECHO/
ECHO Processing DirectX9C Extras
ECHO/

SET /A "HFDX=130"
IF EXIST HFCABS\*d3d*_x86.cab (
	FOR /F %%I IN ('DIR /B/A-D/ON HFCABS\*d3d*_x86.cab') DO (EXPAND HFCABS\%%I -F:* WORK\DX9EXTRA >NUL)
)
IF EXIST HFCABS\*xinput_x86.cab (
	FOR /F %%I IN ('DIR /B/A-D/ON HFCABS\*xinput_x86.cab') DO (EXPAND HFCABS\%%I -F:* WORK\DX9EXTRA >NUL)
)
IF EXIST HFCABS\*XAudio_x86.cab (
	FOR /F %%I IN ('DIR /B/A-D/ON HFCABS\*XAudio_x86.cab') DO (EXPAND HFCABS\%%I -F:* WORK\DX9EXTRA >NUL)
)
IF EXIST %SOURCESS%\I386\HFSLIPDY.inf IF EXIST HFCABS\dxdllreg_x86.cab (
	EXPAND HFCABS\dxdllreg_x86.cab -F:* WORK\DX9EXTRA >NUL
	ECHO>>%SOURCESS%\I386\HFSLIPDY.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZ","110",,"%%11%%\dxdllreg.exe -PATCH"
)
IF EXIST HFCABS\*XACT_x86.cab (
	FOR /F %%I IN ('DIR /B/A-D/ON HFCABS\*XACT_x86.cab') DO (
		EXPAND HFCABS\%%I -F:* WORK\DX9EXTRA >NUL
		IF EXIST WORK\DX9EXTRA\x3da* (
			XCOPY /DHY WORK\DX9EXTRA\x3da* WORK\DX9_X3DA >NUL
			DEL /Q/F WORK\DX9EXTRA\x3da*
		)
	)
)
IF EXIST HFCABS\*X3DAudio_x86.cab (
	FOR /F %%I IN ('DIR /B/A-D/ON HFCABS\*X3DAudio_x86.cab') DO (
		EXPAND HFCABS\%%I -F:* WORK\DX9EXTRA >NUL
		XCOPY /DHY WORK\DX9EXTRA\x3da* WORK\DX9_X3DA >NUL
		DEL /Q/F WORK\DX9EXTRA\x3da*
	)
)
IF EXIST WORK\DX9EXTRA\d3dx10_* (
	FOR /F "tokens=2* delims=_" %%I IN ('DIR /B/A-D/ON WORK\DX9EXTRA\d3dx10_*.dll') DO (
		REN WORK\DX9EXTRA\d3dx10_%%I d3d10_%%I
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif d3d10_%%I = 1,,,,,,,2,0,0,d3dx10_%%I
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,d3d10_%%I
	)
)
IF EXIST WORK\DX9EXTRA\d3dcompiler* (
	FOR /F "tokens=2* delims=_" %%I IN ('DIR /B/A-D/ON WORK\DX9EXTRA\d3dcompiler*.dll') DO (
		REN WORK\DX9EXTRA\d3dcompiler_%%I d3dco_%%I
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif d3dco_%%I = 1,,,,,,,2,0,0,d3dcompiler_%%I
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,d3dco_%%I
	)
)
IF EXIST WORK\DX9EXTRA\d3dcsx* (
	FOR /F "tokens=2* delims=_" %%I IN ('DIR /B/A-D/ON WORK\DX9EXTRA\d3dcsx*.dll') DO (
		REN WORK\DX9EXTRA\d3dcsx_%%I d3dcsx_%%I
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif d3dcsx_%%I = 1,,,,,,,2,0,0,d3dcsx_%%I
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,d3dcsx_%%I
	)
)
IF EXIST WORK\DX9EXTRA\xinput9_1_0.dll (
	REN "WORK\DX9EXTRA\xinput9_1_0.dll" xinp1_0.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif xinp1_0.dll = 1,,,,,,,2,0,0,xinput9_1_0.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,xinp1_0.dll
)
IF EXIST WORK\DX9EXTRA\xinput*.dll (
	FOR /F "tokens=1,2* delims=ut" %%I IN ('DIR /B/ON WORK\DX9EXTRA\xinput*.dll') DO (
		REN "WORK\DX9EXTRA\%%Iut%%J" %%I%%J
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I%%J = 1,,,,,,,2,0,0,%%Iut%%J
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I%%J
	)
)
IF EXIST WORK\DX9EXTRA\xact*.dll (
	FOR /F "tokens=1,2* delims=gine" %%I IN ('DIR /B/ON WORK\DX9EXTRA\xact*.dll') DO (
		REN "WORK\DX9EXTRA\%%Iengine%%J" %%I%%J
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I%%J = 1,,,,,,,2,0,0,%%Iengine%%J
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I%%J
		REM *@*
		REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s %%SYSTEMROOT%%\system32\%%Iengine%%J
		ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","!HFDX!",0,"%%11%%\regsvr32 /s """%%11%%\%%Iengine%%J""""
		SET /A "HFDX+=1"
	)
)
IF EXIST WORK\DX9EXTRA\XAPOFX*.dll (
	FOR /F "tokens=1,2 delims=_" %%I IN ('DIR /B/ON/L WORK\DX9EXTRA\XAPOFX*.dll') DO (
		REN "WORK\DX9EXTRA\%%I_%%J" %%I%%J
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I%%J = 1,,,,,,,2,0,0,%%I_%%J
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I%%J
	)
)
IF EXIST WORK\DX9EXTRA\XAudio*.dll (
	FOR /F "tokens=1,2* delims=io" %%I IN ('DIR /B/ON WORK\DX9EXTRA\XAudio*.dll') DO (
		REN "WORK\DX9EXTRA\%%Iio%%J" %%I%%J
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I%%J = 1,,,,,,,2,0,0,%%Iio%%J
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I%%J
		REM *@*
		REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s %%SYSTEMROOT%%\system32\%%Iio%%J
		ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","!HFDX!",0,"%%11%%\regsvr32 /s """%%11%%\%%Iio%%J""""
		SET /A "HFDX+=1"
	)
)
SET "HFDX="
IF EXIST WORK\DX9EXTRA\*.inf (DEL /Q/F WORK\DX9EXTRA\*.inf)
IF EXIST WORK\DX9EXTRA\*.cat (MOVE /Y WORK\DX9EXTRA\*.cat WORK\SVCPACK)
IF EXIST WORK\DX9EXTRA\*.dll (XCOPY /DHY WORK\DX9EXTRA WORK\I386E)
IF EXIST WORK\DX9_X3DA\*.dll (
	IF EXIST WORK\DX9_X3DA\*.inf (DEL /Q/F WORK\DX9_X3DA\*.inf)
	IF EXIST WORK\DX9_X3DA\*.cat (MOVE /Y WORK\DX9_X3DA\*.cat WORK\SVCPACK)
	FOR /F "tokens=1,2,3* delims=uo" %%I IN ('DIR /B/ON WORK\DX9_X3DA') DO (
		REN "WORK\DX9_X3DA\%%Iu%%Jo%%K" %%I%%K
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I%%K = 1,,,,,,,2,0,0,%%Iu%%Jo%%K
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I%%K
	)
	XCOPY /DHY WORK\DX9_X3DA WORK\I386E
)
TITLE %T1%
GOTO :EOF
REM ---------- ----------


REM ******************** Other Products/Software ********************


REM ---------- MDAC 2.8 Gold and SP1 - for 2K and XPSP1 ----------
:MDAC28
TITLE %T1% - MDAC
ECHO/
ECHO Processing MDAC
ECHO/

ECHO>M.inf [Version]
ECHO>>M.inf Signature="$Windows NT$"
ECHO>>M.inf [DefaultInstall]
ECHO>>M.inf AddReg=MDAC,BIDInt
IF "%VERSION%"=="2000" (ECHO>>M.inf RunPostSetupCommands=RunPost:1)
ECHO>>M.inf [MDAC]
ECHO>>M.inf HKLM,"%%VROOT3%%","/MSADC",0x00020002,"%%16427%%\System\msadc,,5"
FINDSTR /BIR "HKLM" TEMP\sqlnet.inf>>M.inf
ECHO>>M.inf [BIDInt]
ECHO>>M.inf HKLM,"Software\Microsoft\BidInterface",,2
ECHO>>M.inf [BIDInt.security]
ECHO>>M.inf "D:P(A;OICI;GR;;;BU)(A;OICI;GR;;;PU)(A;OICI;GA;;;BA)(A;OICI;GA;;;CO)(A;OICI;GA;;;SY)"
IF "%VERSION%"=="2000" (
	ECHO>>M.inf [RunPost]
	ECHO>>M.inf %%10%%\mui\muisetup.exe /$_fromMDAC_$
)
ECHO>>M.inf [Strings]
FINDSTR /BIR "VROOT3" TEMP\mdacxpak.inf>>M.inf
FINDSTR /BIR "VIAKey" TEMP\sqlnet.inf>>M.inf
SET /A "HFSLP+=1"
MOVE M.inf %SOURCESS%\I386\HFSLP%HFSLP%.inf >NUL
CALL :TYPE2ROROE
DEL /Q/F TEMP\*m.cat TEMP\d* TEMP\j* TEMP\msv* TEMP\mt* TEMP\se*
MD TEMP\MDAC TEMP\MDACx
EXPAND TEMP\mdacxpak.cab -F:* TEMP\MDACx >NUL
DEL /Q/F TEMP\mdacxpak.cab
FOR /F %%I IN ('DIR /B TEMP\*.cab') DO (EXPAND TEMP\%%I -F:* TEMP\MDAC >NUL)
MOVE /Y TEMP\MDACx\* TEMP\MDAC >NUL
FINDSTR /VBI "Copyfiles" TEMP\MDAC\bidintrx.inf>WORK\I386E\bidintrx.inf
DEL /Q/F TEMP\MDAC\bidintrx.inf TEMP\MDAC\msxml3a.dll TEMP\MDAC\oledb32a.dll
IF "%VERSION%"=="2000" (MOVE TEMP\muisetup.exe TEMP\MDAC >NUL)
XCOPY /DY TEMP\*.cat WORK\SVCPACK >NUL
XCOPY /DY TEMP\MDAC WORK\I386E
CALL :CLEANTEMP

ECHO>>WORK\RENAME.cmd REN WORK\I386E\mdacreadme.htm mdacrdme.htm
ECHO>>WORK\RENAME.cmd REN WORK\I386E\mtxoci7x_win2k.reg mtx7x_2k.reg
ECHO>>WORK\RENAME.cmd REN WORK\I386E\mtxoci7x_winnt.reg mtx7x_nt.reg
ECHO>>WORK\RENAME.cmd REN WORK\I386E\mtxoci80_win2k.reg mtx80_2k.reg
ECHO>>WORK\RENAME.cmd REN WORK\I386E\mtxoci80_winnt.reg mtx80_nt.reg
ECHO>>WORK\RENAME.cmd REN WORK\I386E\mtxoci81_win2k.reg mtx81_2k.reg
ECHO>>WORK\RENAME.cmd REN WORK\I386E\mtxoci81_winnt.reg mtx81_nt.reg

ECHO>>WORK\HFSLPGUI.txt %%WINDIR%%\system32\secedit.exe /configure /cfg %%WINDIR%%\INF\bidintrx.inf /db %%WINDIR%%\INF\bidintrx.sdb
ECHO>>WORK\HFSDST.txt CFAdo=16427,"System\ado"
ECHO>>WORK\HFSDST.txt CFOle=16427,"System\Ole DB"
REM *@*
REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s %%SYSTEMROOT%%\system32\odbcconf.dll
ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","120",0,"%%11%%\regsvr32 /s """%%11%%\odbcconf.dll""""

IF "%VERSION%"=="2000" (
	ECHO>>WORK\TXTNTDIR.txt 123 = mui
	REM *@*
	REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s "%%CommonProgramFiles%%\System\OLE DB\sqlxmlx.dll"
	ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","121",0,"%%11%%\regsvr32 /s """%%16427%%\System\OLE DB\sqlxmlx.dll""""
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif cliconf.chm = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif msado25.tlb = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif msado26.tlb = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif msdaorar.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif msdatl3.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif muisetup.exe = 1,,,,,,,123,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif sqloledb.rll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif sqlsodbc.chm = 1,,,,,,,2,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif sqlsoldb.chm = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif sqlxmlx.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif sqlxmlx.rll = 1,,,,,,,,3,3
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,cliconf.chm
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msado25.tlb
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msado26.tlb
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msdaorar.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msdatl3.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,muisetup.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,sqloledb.rll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,sqlsodbc.chm
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,sqlsoldb.chm
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,sqlxmlx.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,sqlxmlx.rll
	
	ECHO>>WORK\HFSSDF.txt msado25.tlb=1
	ECHO>>WORK\HFSSDF.txt msado26.tlb=1
	ECHO>>WORK\HFSSDF.txt msdaorar.dll=1
	ECHO>>WORK\HFSSDF.txt msdatl3.dll=1
	ECHO>>WORK\HFSSDF.txt sqloledb.rll=1
	ECHO>>WORK\HFSSDF.txt sqlsoldb.chm=1
	ECHO>>WORK\HFSSDF.txt sqlxmlx.dll=1
	ECHO>>WORK\HFSSDF.txt sqlxmlx.rll=1
	
	ECHO>>WORK\HFS_CFAdo.txt msado25.tlb
	ECHO>>WORK\HFS_CFAdo.txt msado26.tlb
	
	ECHO>>WORK\HFS_CFOle.txt msdaorar.dll
	ECHO>>WORK\HFS_CFOle.txt msdatl3.dll
	ECHO>>WORK\HFS_CFOle.txt sqloledb.rll
	ECHO>>WORK\HFS_CFOle.txt sqlsoldb.chm
	ECHO>>WORK\HFS_CFOle.txt sqlxmlx.dll
	ECHO>>WORK\HFS_CFOle.txt sqlxmlx.rll
)
ECHO>>%SOURCESS%\I386\TXTSETUP.sif msado27.tlb = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif mtx7x_2k.reg = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif mtx7x_nt.reg = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif mtx80_2k.reg = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif mtx80_nt.reg = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif mtx81_2k.reg = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif mtx81_nt.reg = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif newudl.reg = 1,,,,,,,,3,3
ECHO>>%SOURCESS%\I386\TXTSETUP.sif nonewudl.reg = 1,,,,,,,,3,3

ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msado27.tlb
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mtx7x_2k.reg
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mtx7x_nt.reg
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mtx80_2k.reg
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mtx80_nt.reg
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mtx81_2k.reg
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mtx81_nt.reg
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,newudl.reg
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,nonewudl.reg

ECHO>>WORK\HFSSDF.txt msado27.tlb=1
ECHO>>WORK\HFSSDF.txt mtx7x_2k.reg=1
ECHO>>WORK\HFSSDF.txt mtx7x_nt.reg=1
ECHO>>WORK\HFSSDF.txt mtx80_2k.reg=1
ECHO>>WORK\HFSSDF.txt mtx80_nt.reg=1
ECHO>>WORK\HFSSDF.txt mtx81_2k.reg=1
ECHO>>WORK\HFSSDF.txt mtx81_nt.reg=1
ECHO>>WORK\HFSSDF.txt newudl.reg=1
ECHO>>WORK\HFSSDF.txt nonewudl.reg=1

ECHO>>WORK\HFS_CFAdo.txt msado27.tlb

ECHO>>WORK\HFS_CFOle.txt mtxoci7x_win2k.reg,mtx7x_2k.reg
ECHO>>WORK\HFS_CFOle.txt mtxoci7x_winnt.reg,mtx7x_nt.reg
ECHO>>WORK\HFS_CFOle.txt mtxoci80_win2k.reg,mtx80_2k.reg
ECHO>>WORK\HFS_CFOle.txt mtxoci80_winnt.reg,mtx80_nt.reg
ECHO>>WORK\HFS_CFOle.txt mtxoci81_win2k.reg,mtx81_2k.reg
ECHO>>WORK\HFS_CFOle.txt mtxoci81_winnt.reg,mtx81_nt.reg
ECHO>>WORK\HFS_CFOle.txt newudl.reg
ECHO>>WORK\HFS_CFOle.txt nonewudl.reg
ECHO/
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Windows Update Agent ----------
:WUA
TITLE %T1% - WUA
ECHO/
ECHO Processing Windows Update Agent
ECHO/

MD TEMP\WUA
FOR /F %%I IN ('DIR /B/ON HF\*WindowsUpdateAgent*-x86.exe') DO (SET "WUAHFX=%%I")
HF\%WUAHFX% /Q /X:TEMP
SET "WUAHFX="
REM 2020-08-07:
ATTRIB -R -A -S -H TEMP\*.*  /S /D
REM Clear out the junk.
DEL /Q/F TEMP\*.inf TEMP\%LG%\eula.rtf
IF EXIST HF\*891861*.exe (DEL /Q/F TEMP\MSXML3.dll TEMP\%LG%\MSXML3R.dll)
IF "%VERSION%"=="2000" (
	IF EXIST WORK\I386E\WINHTTP.dll (DEL /Q/F TEMP\WINHTTP.dll)
) ELSE (
	DEL /Q/F TEMP\WINHTTP.dll TEMP\MSXML3.dll TEMP\%LG%\MSXML3R.dll
)
IF EXIST TEMP\IUENGINE.dll (
	DEL /Q/F TEMP\*MUI* TEMP\%LG%\wusetupr.dll
) ELSE (
	REN TEMP\wuauhelp.chm_%LG% wuauhelp.chm
	REN TEMP\wuapi.dll.mui_%LG% wuapi.mui
	REN TEMP\wuaucpl.cpl.mui_%LG% wuaucpl.mui
	REN TEMP\wuaueng.dll.mui_%LG% wuaueng.mui
	REN TEMP\wucltui.dll.mui_%LG% wucltui.mui
	DEL /Q/F TEMP\*.cab TEMP\*CHM_* TEMP\*MUI_* TEMP\%LG%\*MUI*
)
SET "BASEWUA=wuapi wuau\.a wuauserv wucltui wups wuweb wuauhelp"
IF EXIST TEMP\IUENGINE.dll (
	FINDSTR /VR "%BASEWUA% wuaucpl\.cpl[^.] wuauclt wuaueng" %SOURCESS%\I386\TXTSETUP.sif>TXTSETUP.sif
	FINDSTR /VR "%BASEWUA% wuaucpl\.cpl[^.] wuauclt wuaueng" %SOURCESS%\I386\DOSNET.inf>DOSNET.inf
) ELSE (
	FINDSTR /VR "%BASEWUA% wuaucpl\.cpl[^.] wuauclt\. wuaueng\." %SOURCESS%\I386\TXTSETUP.sif>TXTSETUP.sif
	FINDSTR /VR "%BASEWUA% wuaucpl\.cpl[^.] wuauclt\. wuaueng\." %SOURCESS%\I386\DOSNET.inf>DOSNET.inf
	
	ECHO>>TXTSETUP.sif wuapi.mui = 1,,,,,,,2,0,0,wuapi.dll.mui
	ECHO>>TXTSETUP.sif wuaucpl.mui = 1,,,,,,,2,0,0,wuaucpl.cpl.mui
	ECHO>>TXTSETUP.sif wuaueng.mui = 1,,,,,,,2,0,0,wuaueng.dll.mui
	ECHO>>TXTSETUP.sif wucltui.mui = 1,,,,,,,2,0,0,wucltui.dll.mui
	
	ECHO>>DOSNET.inf d1,wuapi.mui
	ECHO>>DOSNET.inf d1,wuaucpl.mui
	ECHO>>DOSNET.inf d1,wuaueng.mui
	ECHO>>DOSNET.inf d1,wucltui.mui
)
SET "BASEWUA="
MOVE /Y TXTSETUP.sif %SOURCESS%\I386
MOVE /Y DOSNET.inf %SOURCESS%\I386
MOVE /Y TEMP\*.cat WORK\SVCPACK
MOVE /Y TEMP\*.* TEMP\WUA >NUL
MOVE /Y TEMP\%LG%\*.* TEMP\WUA >NUL
DIR /B TEMP\WUA\*.dll>>WORK\NSFREGt.txt
XCOPY /DHY TEMP\WUA WORK\I386E
CALL :CLEANTEMP
REM Nullifying AU.inf.
COPY SOURCE\I386\AU.inf WORK >NUL 2>&1 || EXPAND SOURCE\I386\AU.in_ -R WORK >NUL
TYPE WORK\AU.inf>WORK\AU2.inf
FINDSTR /R "[;=[]" WORK\AU2.inf>WORK\AU3.inf
FINDSTR /VR "11,," WORK\AU3.inf>WORK\I386E\AU.inf
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Microsoft Installer 4.5 ----------
:MSI45
TITLE %T1% - MS Installer 4.5
ECHO/
ECHO Processing Microsoft Installer 4.5
ECHO/

FOR /F %%I IN ('DIR /B/ON HF\Windows%~1-KB942288*-x86.exe') DO (
	SET "MSIHFX=%%I"
	SET /A "TXTDIR09=1"
)
HF\%MSIHFX% /Q /X:TEMP
SET "MSIHFX="
REM 2020-08-07:
ATTRIB -R -A -S -H TEMP\*.*  /S /D

REN TEMP\%~2\msimsg.dll.%LG%-*.mui msimsg.mui

REM SPECIAL LANGUAGE FIXES
IF NOT EXIST TEMP\%~2\msimsg.mui (
	IF "%LG%"=="PTBR" (REN TEMP\%~2\msimsg.dll.pt-br.mui msimsg.mui)
	IF "%LG%"=="ZHTW" (REN TEMP\%~2\msimsg.dll.zh-tw.mui msimsg.mui)
	IF "%LG%"=="ZHCN" (REN TEMP\%~2\msimsg.dll.zh-cn.mui msimsg.mui)
	IF "%LG%"=="ZHHK" (REN TEMP\%~2\msimsg.dll.zh-hk.mui msimsg.mui)
)

DEL /Q/F TEMP\%~2\msimsg.dll.*-*.MUI

ECHO>>%SOURCESS%\I386\TXTSETUP.sif msimsg.mui = 1,,,,,,,1009,0,0,msimsg.dll.mui
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,msimsg.mui

XCOPY /DHY TEMP\%~2 WORK\I386E
IF EXIST TEMP\UPDATE\*.cat (MOVE /Y TEMP\UPDATE\*.cat WORK\SVCPACK)
CALL :CLEANTEMP
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- MSXML Files ----------
:MSXML
TITLE %T1% - MSXML
ECHO/
ECHO Processing MSXML
ECHO/

COPY HF\MSXML*.* WORK\MSXML >NUL
CD WORK\MSXML
MD EX OUT
IF EXIST *6-kb88* (
	REN *6-kb88* XML2UP.exe
	XML2UP.exe /QUIET /X:EX
	COPY /Y EX\FILES\* OUT >NUL
	COPY /Y EX\UPDATE\*.cat %PREP%\WORK\SVCPACK >NUL
)
IF EXIST MS*.exe (
	FOR /F %%I IN ('DIR /B MS*.exe') DO (%%I /QUIET /X:"%PREP%\WORK\MSXML")
)
IF EXIST MSXML*.msi (
	FOR /F %%I IN ('DIR /B *.msi') DO (MSIEXEC /A %%I TARGETDIR="%PREP%\WORK\MSXML\EX" /QN)
	XCOPY /DHY EX\SYSTEM\*.dll OUT >NUL
	IF EXIST EX\SYSTEM\*.cat (COPY /Y EX\SYSTEM\*.cat %PREP%\WORK\SVCPACK >NUL)
)
IF EXIST OUT\*a.dll (DEL /Q/F OUT\*a.dll)
CD %PREP%
XCOPY /DY WORK\MSXML\OUT\* WORK\I386E
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- XPIZE ----------
:XPIZE
TITLE %T1% - XPize
ECHO/
ECHO Slipstreaming XPize
ECHO/

IF NOT "%FORCEXPIZESLIP%"=="1" (
	IF DEFINED XPIZESW (
		ECHO>>%SOURCESS%\I386\SVCPACK.inf XPIZE.exe !XPIZESW!
		FOR /F %%I IN ('DIR /B/ON HF\XPIZE*') DO (COPY /Y HF\%%I %SOURCESS%\I386\SVCPACK\XPIZE.exe >NUL)
	)
	GOTO :EOF
)

FOR /F %%I IN ('DIR /B/ON HF\XPIZE*') DO (SET "XPIZE=%%I")
ECHO Please wait while HFSLIP slipstreams XPize. This may take a while.
%PREP%\HF\%XPIZE% /S /mode=i386 /source=%SOURCESS%
SET "XPIZE="
ECHO Slipstreaming XPize completed.
GOTO :EOF
REM ---------- ----------


REM ******************** Utilities ********************


REM ---------- Empty Directory Checker ----------
:ISNOTEMPTY
FOR /F %%I IN ('DIR /B %~1') DO (
	SET /A "NOTEMPTY=1"
)
GOTO :EOF
REM ---------- ----------

REM ---------- File Flags ----------
:ADDFFLAGS
IF NOT DEFINED VERSION (CALL :CHECKWINVER)
IF NOT "%VERSION%"=="XP" (GOTO :EOF)
FINDSTR /IE "16" %SOURCESS%\I386\TXTSETUP.sif>FF1.txt
FINDSTR /IR "\." FF1.txt>FF2.txt
FOR /F "delims== " %%I IN (FF2.txt) DO (ECHO>>FF3.txt %%I)
ECHO>>TXTFF.txt BNTS.dll
ECHO>>TXTFF.txt SAPICPL.HLP
ECHO>>TXTFF.txt SNIFFPOL.dll
ECHO>>TXTFF.txt SPEECH.CHM
ECHO>>TXTFF.txt SSDPAPI.dll
ECHO>>TXTFF.txt SSDPSRV.dll
ECHO>>TXTFF.txt SSTUB.dll
ECHO>>TXTFF.txt TSHOOT.dll
ECHO>>TXTFF.txt UDHISAPI.dll
ECHO>>TXTFF.txt UPNP.dll
ECHO>>TXTFF.txt UPNPCONT.exe
ECHO>>TXTFF.txt UPNPHOST.dll
FOR /F %%I IN ('FINDSTR /VBI /G:FF3.txt TXTFF.txt') DO (ECHO>>WORK\TXTFFLAG.txt %%I = 16)
DEL /Q/F FF1.txt FF2.txt FF3.txt TXTFF.txt
FOR /F %%I IN (WORK\TXTFFLAG.txt) DO (SET /A "AFFLAGS=1")
IF NOT DEFINED AFFLAGS (GOTO :EOF)
SET "AFFLAGS="
IF "%DIAGNOSTIC%"=="1" (
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif [FileFlags]
	TYPE WORK\TXTFFLAG.txt>>%SOURCESS%\I386\TXTSETUP.sif
)
GOTO :EOF
REM ---------- ----------

REM ---------- Universal CABer 1 ----------
:UNICAB1
ECHO>UC.ddf .Set Cabinet=on
ECHO>>UC.ddf .Set Compress=on
ECHO>>UC.ddf .Set CompressionType=LZX
ECHO>>UC.ddf .Set CompressionMemory=%COMPMEM%
ECHO>>UC.ddf .Set FolderSizeThreshold=5000000
ECHO>>UC.ddf .Set MaxDiskSize=CDROM
GOTO :EOF
REM ---------- ----------

REM ---------- Universal CABer 2 ----------
:UNICAB2
MAKECAB /F UC.ddf >NUL
DEL /Q/F UC.ddf SETUP.inf SETUP.RPT
GOTO :EOF
REM ---------- ----------

REM ---------- Clean TEMP ----------
:CLEANTEMP
CALL :ISNOTEMPTY TEMP
IF DEFINED NOTEMPTY (
	REM 2020-08-07:
	ATTRIB -R -A -S -H TEMP\*.*  /S /D
	SET "NOTEMPTY="
)
FOR /D %%I IN (TEMP\*) DO (RD /S /Q "%%I")
DEL TEMP\* /Q
GOTO :EOF
REM ---------- ----------

REM ---------- Error Report ----------
:ERRORREPORT
IF NOT DEFINED MBOOTPATH (SET "MBOOTPATH=Default")
IF NOT DEFINED CDTAG (SET "CDTAG=Undefined")
REM 2024/8/20
REM The following SET'ing of VERSION before :MAKEISO causes problems with some checks in :MAKESIO.
REM Thus, making :ERRORREPORT-specific variables.
REM Decided to do the same for SP, just-in-case.
IF "%VERSION%"=="2000" (
	IF DEFINED V3 (
		SET "VERSIONER=2000 %V2% Server"
	) ELSE (
		SET "VERSIONER=2000 %V2%"
	)
) ELSE IF "%VERSION%"=="XP" (
	IF "%V2%"=="Home" (
		SET "VERSIONER=XP Home Edition"
	) ELSE IF DEFINED XPMCE (
		SET "VERSIONER=XP Media Center Edition 2005"
	) ELSE (
		SET "VERSIONER=XP Professional"
	)
) ELSE IF "%VERSION%"=="2003" (
	SET "VERSIONER=Server 2003 %V3% Edition"
)
IF %SP% EQU 0 (
	SET "SPER=Gold"
) ELSE IF EXIST %SOURCESS%\cdromsp5.tst (
	SET "SPER=SP%SP% ^(USP5.x^)"
) ELSE (
	SET "SPER=SP%SP%"
)

ECHO>HFSLIP.log                  This file is automatically generated by HFSLIP
ECHO>>HFSLIP.log    Use of HFSLIP for anything other than personal non-commercial purposes 
ECHO>>HFSLIP.log                             is not allowed.
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log                         Copyright(C) TommyP 2005-2010
ECHO/>>HFSLIP.log
IF "%HostOS%"=="Vista" (
	ECHO>>HFSLIP.log Host OS         - Windows %HostOS% or newer
) ELSE (
	ECHO>>HFSLIP.log Host OS         - Windows %HostOS%
)
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log HFSLIP Version  - %HFSVER%-%HFSBUILD%
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log HFSLIP Path     - %PREP%
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log OS in SOURCESS  - Windows %VERSIONER% %SPER% %Localization%
SET "VERSIONER="
SET "SPER="
IF "%VERSION%"=="2000" IF DEFINED LBASUPPORT (
	ECHO>>HFSLIP.log                   [48-bit LBA Support Added]
	ECHO/>>HFSLIP.log
)
IF DEFINED HFSLIPSVPACK (ECHO>>HFSLIP.log                   [Service Pack Slipstreamed By HFSLIP])
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log Time Finished   - %FINTIME%
ECHO/>>HFSLIP.log
IF NOT "%VERSION%"=="2003" (
	ECHO>>HFSLIP.log MSIE Version    - %VERSIONIE%
	ECHO/>>HFSLIP.log
)
IF DEFINED DX9 (
	ECHO>>HFSLIP.log DirectX         - DirectX9 !DX9!
	ECHO/>>HFSLIP.log
)
IF DEFINED MPLEVEL IF !MPLEVEL! GEQ 31 IF !MPLEVEL! LEQ 51 (
	ECHO>>HFSLIP.log WMP             - %MPFLDRA%
	ECHO/>>HFSLIP.log
)
IF NOT DEFINED MULTICAB (
	ECHO>>HFSLIP.log Drivers         - DRIVER.cab Updated
) ELSE IF EXIST %SOURCESS%\I386\SPX.cab (
	ECHO>>HFSLIP.log Drivers         - SPX.cab Added
) ELSE (
	ECHO>>HFSLIP.log Drivers         - No updates
)
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log CD Install Path - %MBOOTPATH%
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log CDTAG           - %CDTAG%
ECHO/>>HFSLIP.log
IF EXIST FDVFILES\ie.in_ (
	ECHO>>HFSLIP.log Mods            - FDV Fileset
	SET /A "LOGMODS=1"
)
IF DEFINED HFCBASE (
	ECHO>>HFSLIP.log Mods            - HFCLEANUP
	SET /A "LOGMODS=1"
)
IF DEFINED DELCATS (
	IF DEFINED DELCATS_OVERRIDE (
		ECHO>>HFSLIP.log Mods            - CAT Files Removed ^(with overrides^)
	) ELSE (
		ECHO>>HFSLIP.log Mods            - CAT Files Removed ^(no overrides^)
	)
	SET /A "LOGMODS=1"
)
IF DEFINED LOGMODS (
	ECHO/>>HFSLIP.log
	SET "LOGMODS="
)
IF %NOCLEANSRC% EQU 1 (
	ECHO>>HFSLIP.log WARNING         - Previously Patched Source Detected
	ECHO/>>HFSLIP.log
)
IF %NOCLEANSRC% EQU 2 (
	ECHO>>HFSLIP.log INFO            - Non-CAT files removed from SOURCE\I386\SVCPACK to avoid errors during Windows setup
	ECHO/>>HFSLIP.log
)
IF DEFINED OUTPUTFILE (
	ECHO>>HFSLIP.log OUTPUT          - Command output was written to !OUTPUTFILE!
	ECHO/>>HFSLIP.log
)
ECHO>>HFSLIP.log ===============================================================================
ECHO>>HFSLIP.log Files in your HF folder:
IF EXIST HF\BASIC\*.exe (
	FOR /F %%I IN ('DIR /B/ON HF\BASIC\*.exe') DO (ECHO>>HFSLIP.log BASIC\%%I)
)
IF EXIST HF\NOREG\*.exe (
	FOR /F %%I IN ('DIR /B/ON HF\NOREG\*.exe') DO (ECHO>>HFSLIP.log NOREG\%%I)
)
FOR /F %%I IN ('DIR /A-D HF') DO (SET /A "HFFILES=1")
IF DEFINED HFFILES (
	DIR /B/A-D/ON HF>>HFSLIP.log
	SET "HFFILES="
)
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log Files in your HFCABS folder:
DIR /B/ON HFCABS>>HFSLIP.log
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log Files in your HFGUIRUNONCE folder:
DIR /B/ON HFGUIRUNONCE>>HFSLIP.log
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log Files in your HFSVCPACK folder:
DIR /B/ON HFSVCPACK>>HFSLIP.log
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log Files in your HFSVCPACK_SW1 folder:
DIR /B/ON HFSVCPACK_SW1>>HFSLIP.log
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log Files in your HFSVCPACK_SW2 folder:
DIR /B/ON HFSVCPACK_SW2>>HFSLIP.log
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log Files in your HFTOOLS folder:
DIR /B/ON HFTOOLS>>HFSLIP.log
ECHO/>>HFSLIP.log
IF EXIST HFAAO (
	ECHO>>HFSLIP.log Files in your HFAAO folder:
	DIR /B HFAAO>>HFSLIP.log
	ECHO/>>HFSLIP.log
)
IF EXIST HFEXPERT (
	ECHO>>HFSLIP.log Files in your HFEXPERT folder:
	DIR /B/ON/A-D-H-S/S HFEXPERT | FINDSTR /C:"\\\." /V>>HFSLIP.log
	ECHO/>>HFSLIP.log
)
IF EXIST HFCLEANUP (
	ECHO>>HFSLIP.log Files in your HFCLEANUP folder:
	DIR /B HFCLEANUP>>HFSLIP.log
	ECHO/>>HFSLIP.log
)
ECHO>>HFSLIP.log Files in your REPLACE folder:
CALL :ISNOTEMPTY REPLACE
IF DEFINED NOTEMPTY (
	DIR /B/ON/A-D-H-S/S REPLACE | FINDSTR /C:"\\\." /V>>HFSLIP.log
	SET "NOTEMPTY="
)
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log ===============================================================================
GOTO :EOF
REM ---------- ----------

REM For :MAKEISO ook evgnb's code, cleaned it up, and removed the flaky timestamp feature (WMIC has been known to lock-up execution for reasons
REM still unknown). Instead, going against what HFSLIP has done since the beginning and instead just including time of completion inside of
REM HFSLIP.log. Time of completion is recorded before :ERRORREPORT is CALL'd, which comes before :MAKEISO itself.

REM Used files:
REM HFTOOLS\CDIMAGE.exe [default] or HFTOOLS\MKISOFS.exe for make ISO.
REM HFTOOLS\DVDBURN.exe [default] or HFTOOLS\CDBURN.exe for burn ISO.
REM HFTOOLS\boot.bin - BOOT sector for CD ISO file.
REM HFTOOLS\BBIE.exe - tool for extract HFTOOLS\boot.bin from Windows Setup CD-ROM, if file boot.bin not present.

REM ---------- MAKEISO ----------
:MAKEISO
IF "%MAKENOISO%"=="1" IF /I NOT "%AHTEST%"=="MAKEISO" (GOTO :EOF)
TITLE %T1% - ISO Creation
ECHO/
ECHO Processing ISO Image
ECHO/

SET /A "ISOEXE=0"
IF EXIST HFTOOLS\MKISOFS.exe (SET /A "ISOEXE=1")
REM Force CDIMAGE.
IF EXIST HFTOOLS\CDIMAGE.exe (SET /A "ISOEXE=2")
IF %ISOEXE% EQU 0 (
	ECHO/>CON
	ECHO HFTOOLS\MKISOFS.exe or HFTOOLS\CDIMAGE.exe not found - can't create ISO.>CON
	ECHO/>CON
	PAUSE>CON
	GOTO :EOF
)

REM Creating BOOT sector from physical disc if it not in HFTOOLS.
IF NOT EXIST HFTOOLS\boot.bin (
	ECHO/>CON
	ECHO Warning! HFTOOLS\boot.bin not found, will try to extract BOOT sector from Windows Setup CD-ROM.>CON
	
	IF NOT EXIST HFTOOLS\BBIE.exe (
		ECHO/>CON
		ECHO HFTOOLS\BBIE.exe not found, can't extract BOOT sector.>CON
		ECHO/>CON
		PAUSE>CON
		GOTO :EOF
	)
	
	REM Physical CD-ROM check. Will use first Windows Setup disc detected.
	FOR %%I IN (D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
		IF EXIST %%I:\ IF EXIST %%I:\I386 (
			IF NOT DEFINED CDDRIVE (SET "CDDRIVE=%%I")
		)
	)
	
	IF NOT DEFINED CDDRIVE (
		ECHO/>CON
		ECHO Can't find Windows Setup CD-ROM.>CON
		ECHO/>CON
		PAUSE>CON
		GOTO :EOF
	)
	
	DEL /F /Q IMAGE1.BIN >NUL 2>&1
	HFTOOLS\BBIE.exe !CDDRIVE!:
	
	IF NOT EXIST IMAGE1.BIN (
		ECHO/>CON
		ECHO Can't extract BOOT sector from Windows Setup CD-ROM ^(DRIVE !CDDRIVE!:^).>CON
		ECHO/>CON
		PAUSE>CON
		GOTO :EOF
	)
	
	MOVE IMAGE1.BIN HFTOOLS\boot.bin
	SET "CDDRIVE="
)

ECHO/
ECHO Creating ISO
ECHO/

IF NOT DEFINED CDIMGSW (SET "CDIMGSW=-h -j1 -m")
IF NOT DEFINED MKISSW (SET "MKISSW=-relaxed-filenames -d -D -N -J -no-emul-boot -no-iso-translate -boot-load-size 4")

IF NOT DEFINED VERSION (CALL :CHECKWINVER)
IF "%VERSION%"=="2000" (
	SET "BASENAME=W2000SP%SP%"
) ELSE IF "%VERSION%"=="XP" (
	SET "BASENAME=WXPSP%SP%"
) ELSE IF "%VERSION%"=="2003" (
	SET "BASENAME=W2003SP%SP%"
)
REM ISOTITLE cannot be larger than 16 characters long.
IF NOT DEFINED ISOTITLE (SET "ISOTITLE=%BASENAME%-%HFSBUILD%")
SET "ISONAME=%BASENAME%-%HFSVER%.iso"
SET "BASENAME="
IF EXIST "%ISONAME%" (DEL /F /Q "%ISONAME%")

IF %ISOEXE% EQU 2 (
	HFTOOLS\CDIMAGE.exe -l"%ISOTITLE%" %CDIMGSW% -bHFTOOLS\boot.bin %SOURCESS% "%ISONAME%"
) ELSE (
	COPY HFTOOLS\boot.bin %SOURCESS% > NUL
	HFTOOLS\mkisofs.exe %MKISSW% -b boot.bin -o "%ISONAME%" -V "%ISOTITLE%" %SOURCESS%
	DEL /q /f %SOURCESS%\boot.bin
)
SET "ISOEXE="

ECHO/>CON
ECHO Your ISO is here: %PREP%\%ISONAME%>CON
ECHO/>CON

REM TODO Neither the following CDBURN.exe nor DVDBURN.exe were included with any version of HFSLIP since at least 1.7.8.
REM Do we still want the disc burning code still included in HFSLIP, or no?
REM Personally, I think it would simplify the code. Besides, there are more mature burning utilties out there than whatever those two programs
REM were surely.

REM Burning ROM.
SET /A "CDEXE=0"
IF EXIST HFTOOLS\CDBURN.exe (
	SET /A "CDEXE=1"
	SET "CDBURNAPP=HFTOOLS\CDBURN.exe"
)
REM Force DVDBURN.
IF EXIST HFTOOLS\DVDBURN.exe (
	SET /A "CDEXE=2"
	SET "CDBURNAPP=HFTOOLS\DVDBURN.exe"
)

REM "throw it away without explanation"
IF %CDEXE% EQU 0 (GOTO :EOF)
IF "%NOBURNISO%"=="1" (GOTO :EOF)
REM TODO IF CDBURNSW1 is not DEFINED in HFANSWER.ini, then the disc will not be burned to disc. Find out what that parameter is.
IF NOT DEFINED CDBURNSW1 (GOTO :EOF)

IF %CDEXE% EQU 2 IF NOT DEFINED CDBURNSW2 (SET "CDBURNSW2=-max")

TITLE %T1% - Burning ISO Image
ECHO/
ECHO Burning "%ISONAME%".
ECHO/
%CDBURNAPP% %CDBURNSW1% "%ISONAME%" %CDBURNSW2%
ECHO/

SET "CDEXE="
SET "ISONAME="
GOTO :EOF
REM ---------- ----------

REM ---------- Time-to-Slipstream Calculator ----------
:TIMECALC
REM Native time calculator / Part 2 / Tomcat76.
REM Can process time until the next day at 1 second before midnight.
ECHO>AMPMS.txt %STIME%
SET "EDATE=%DATE%"
ECHO>AMPME.txt %TIME%
FOR /F "tokens=1,2,3 delims=:., " %%I IN (AMPMS.txt) DO (
	SET "STIMEH=%%I"
	SET "STIMEM=%%J"
	SET "STIMES=%%K"
)
FOR /F "tokens=1,2,3 delims=:., " %%I IN (AMPME.txt) DO (
	SET "ETIMEH=%%I"
	SET "ETIMEM=%%J"
	SET "ETIMES=%%K"
)
IF %STIMEM% LSS 10 (SET "STIMEM=%STIMEM:~1,1%")
IF %STIMES% LSS 10 (SET "STIMES=%STIMES:~1,1%")
IF %ETIMEM% LSS 10 (SET "ETIMEM=%ETIMEM:~1,1%")
IF %ETIMES% LSS 10 (SET "ETIMES=%ETIMES:~1,1%")
FOR /F %%I IN ('FINDSTR /I "AM PM" AMPME.txt') DO (CALL :MIL_CONV)
SET /A "THRS=%ETIMEH%-%STIMEH%"
SET /A "TMIN=%ETIMEM%-%STIMEM%"
SET /A "TSEC=%ETIMES%-%STIMES%"
ECHO>TTEST.txt %TSEC%
FOR /F %%I IN ('FINDSTR /R "\-" TTEST.txt') DO (SET /A "SERROR=1")
IF DEFINED SERROR (
	SET /A "TSEC=(60-%STIMES%)+%ETIMES%"
	SET /A "TMIN-=1"
)
ECHO>TTEST.txt %TMIN%
FOR /F %%I IN ('FINDSTR /R "\-" TTEST.txt') DO (SET /A "MERROR=1")
IF DEFINED SERROR (
	SET /A "NSTIMEM=59"
) ELSE (
	SET /A "NSTIMEM=60"
)
IF DEFINED MERROR (
	SET /A "NETIMEH=23"
	SET /A "NSTIMEM-=%STIMEM%"
	SET /A "TMIN=%NSTIMEM%+%ETIMEM%"
	SET /A "THRS-=1"
) ELSE (
	SET /A "NETIMEH=24"
)
ECHO>TTEST.txt %THRS%
FOR /F %%I IN ('FINDSTR /R "\-" TTEST.txt') DO (SET /A "HERROR=1")
IF NOT "%SDATE%"=="%EDATE%" (SET /A "HERROR=1")
IF DEFINED HERROR (
	SET /A "ETIMEH+=%NETIMEH%"
	SET /A "THRS=%ETIMEH%-%STIMEH%"
)
DEL /Q/F TTEST.txt AMPMS.txt AMPME.txt
IF %TSEC% LSS 10 (SET "TSEC=0%TSEC%")
IF %THRS% GEQ 1 (
	IF %TMIN% LSS 10 (
		SET "TMIN=%THRS%h0%TMIN%"
	) ELSE (
		SET "TMIN=%THRS%h%TMIN%"
	)
)
ECHO/>>HFSLIP.log
ECHO>>HFSLIP.log HFSLIP run time: %TMIN%m%TSEC%s
ECHO/
ECHO/
ECHO HFSLIP run time: %TMIN%m%TSEC%s
ECHO/
ECHO/

SET "EDATE=" & SET "STIMEH=" & SET "STIMEM=" & SET "STIMES=" & SET "ETIMEH=" & SET "ETIMEM=" & SET "ETIMES="
SET "THRS=" & SET "TMIN=" & SET "TSEC=" & SET "NSTIMEM=" & SET "NETIMEH="
SET "SERROR=" & SET "MERROR=" & SET "HERROR="
GOTO :EOF
REM ---------- ----------

REM ---------- Time-to-Slipstream Calculator - "Millisecond" (?) Conversion ----------
:MIL_CONV
FOR /F %%I IN ('FINDSTR /I "AM" AMPMS.txt') DO (SET "AMPMS=AM")
FOR /F %%I IN ('FINDSTR /I "AM" AMPME.txt') DO (SET "AMPME=AM")
FOR /F %%I IN ('FINDSTR /I "PM" AMPMS.txt') DO (SET "AMPMS=PM")
FOR /F %%I IN ('FINDSTR /I "PM" AMPME.txt') DO (SET "AMPME=PM")
REM Midnight to zero
IF "%AMPMS%"=="AM" IF "%STIMEH%"=="12" (SET /A "STIMEH=0")
IF "%AMPME%"=="AM" IF "%ETIMEH%"=="12" (SET /A "ETIMEH=0")
REM Noon remains at 12 / Other PMs +12
IF "%AMPMS%"=="PM" IF NOT "%STIMEH%"=="12" (SET /A "STIMEH+=12")
IF "%AMPME%"=="PM" IF NOT "%ETIMEH%"=="12" (SET /A "ETIMEH+=12")
SET "AMPMS="
SET "AMPME="
GOTO :EOF
REM ---------- ----------


REM ******************** Hotfixes ********************


REM ---------- Hotfixes ----------
:HF
SET "IGNORESP=889101 891861 835935 914961 936929 W2KSP xpsp"
SET "IGNORETZ=912475 918093 928388 929120 931836 933360 938977 940427 942763 943000"
SET "DefExcHF=%IGNORESP% %IGNORETZ% Center2005 %MCEMP10CUM% 898461 891122 926139 926140 888111 840374 832483 913433 923789 914798 925876 952155 942288 dowsSearch wmp11\-win IE7\- IE8\- DX9\- NDP1 directx_ dotnet rights gdiplus MPSetup MP1.Setup WM9Codecs wmp6cdcs wmfdist gdidet wmcsetup cdwizard xpize dateAgent StepByStep supporttools 905474\-...\-x86\-Standalone 968930"
IF "VERSIONIE"=="IE8" (SET "DefExcHF=%DefExcHF% \-win IE8")
SET "IGNORESP="
SET "IGNORETZ="
DIR /B/A-D/OGN/ON HF\*.exe>HF.txt
FINDSTR /LI /C:WINDOWS HF.txt>HFT1.txt
FINDSTR /VIR "%DefExcHF% 817787 833989 917344\-56 Script56" HFT1.txt>HF1.txt
FINDSTR /IR "888111 MDAC253 MDAC281 Q......_WXP_SP._ W2K_SP5 scrip...\.exe" HF.txt>>HF1.txt
IF DEFINED XPNETFX (FINDSTR /BIR "NDP1" HF.txt>>HF1.txt)
FOR /F %%I IN (HF1.txt) DO (SET /A "T1HF=1")
IF DEFINED T1HF (
	FINDSTR /VBI /G:HF1.txt HF.txt>HFT2.txt
	SET "T1HF="
) ELSE (
	TYPE HF.txt>HFT2.txt
)
FINDSTR /VIR "%DefExcHF% WXP_SP2 msxml.\- msxml....\-" HFT2.txt>HF2.txt
DEL /Q/F HF.txt HFT1.txt HFT2.txt
FOR /F %%I IN (HF1.txt) DO (
	SET "HF=%%I"
	CALL :HF1EXTRACT
)
FOR /F %%I IN (HF2.txt) DO (
	SET "HF=%%I"
	CALL :HF2EXTRACT
)
TITLE %T1%
DEL /Q/F HF1.txt HF2.txt
GOTO :EOF
REM ---------- ----------

REM ---------- Type 1 Hotfixes ----------

REM ---------- HF1 Extract ----------
:HF1EXTRACT
TITLE %T1% - Processing %HF%
ECHO %HF%
HF\%HF% /Q /X:TEMP
ATTRIB -R -A -S -H TEMP\*.*  /S /D

:MIDHF1CALLER
REM "what kind of file is updHFSLP.inf with lines that do not contain "SDPROP" - ???"
REM "some update for security update for Active Directory"
IF EXIST TEMP\ntdsa.dll IF NOT DEFINED SERVER (FINDSTR /VI "SDPROP" TEMP\UPDATE\update.inf>TEMP\UPDATE\updHFSLP.inf)
IF EXIST TEMP\createcab.cmd (FINDSTR /VIR "createcab\.cmd" TEMP\UPDATE\update.inf>TEMP\UPDATE\updHFSLP.inf)
CALL :HF1COMMON_A
IF EXIST TEMP\UPDATE\*.inf (CALL :HFINFS)
CALL :HF1COMMON_B
GOTO :EOF
REM ---------- ----------

REM "makeweight. here update\update_SP3GDR.inf update\update_SP3QFE.inf is cleaned in the new format of hotfixes xp-sp3 or 2003 (in which delta compression)"
REM "Why - it’s unclear, because as a result, all files from WindowsXP-KB2423089-x86-RUS.exe, etc. XP hotfixes will be removed. No ???"
REM ---------- Hotfix INFs ----------
:HFINFS
DIR /B TEMP\UPDATE\*.inf>TSINF.txt
IF EXIST TEMP\UPDATE\*HFSLP.inf (
	FOR /F %%I IN ('FINDSTR /VI "HFSLP" TSINF.txt') DO (
		IF EXIST TEMP\UPDATE\%%I (DEL /Q/F TEMP\UPDATE\%%I)
	)
)
IF EXIST TEMP\UPDATE\*SP%SP%QFE*.inf (
	FOR /F %%I IN ('FINDSTR /VI "SP%SP%QFE" TSINF.txt') DO (
		IF EXIST TEMP\UPDATE\%%I (DEL /Q/F TEMP\UPDATE\%%I)
	)
)
IF EXIST TEMP\UPDATE\*SP%SP%GDR*.inf (
	FOR /F %%I IN ('FINDSTR /VI "SP%SP%GDR" TSINF.txt') DO (
		IF EXIST TEMP\UPDATE\%%I (DEL /Q/F TEMP\UPDATE\%%I)
	)
)
IF EXIST TEMP\UPDATE\*RTMQFE*.inf (
	FOR /F %%I IN ('FINDSTR /VI "RTMQFE" TSINF.txt') DO (
		IF EXIST TEMP\UPDATE\%%I (DEL /Q/F TEMP\UPDATE\%%I)
	)
)
IF EXIST TEMP\UPDATE\*RTMGDR*.inf (
	FOR /F %%I IN ('FINDSTR /VI "RTMGDR" TSINF.txt') DO (
		IF EXIST TEMP\UPDATE\%%I (DEL /Q/F TEMP\UPDATE\%%I)
	)
)
IF EXIST TEMP\UPDATE\update_*.inf (
	FOR /F %%I IN ('FINDSTR /VIR "update_" TSINF.txt') DO (
		IF EXIST TEMP\UPDATE\%%I (DEL /Q/F TEMP\UPDATE\%%I)
	)
)
IF EXIST TEMP\UPDATE\update.inf (
	FOR /F %%I IN ('FINDSTR /VIR "update\." TSINF.txt') DO (
		IF EXIST TEMP\UPDATE\%%I (DEL /Q/F TEMP\UPDATE\%%I)
	)
)

DEL /Q/F TSINF.txt
FOR /F %%I IN ('DIR /B/ON TEMP\UPDATE\*.inf') DO (SET "HFXINF=%%I")
REM "and if there are several HFXINFs???"
IF NOT DEFINED HFXINF (GOTO :EOF)
SET /A "HFSLP+=1"
COPY TEMP\UPDATE\%HFXINF% "WORK\INFS\%HFSLP%.inf"
SET "HFXINF="
CALL :HFSLIPINFCREATOR1
GOTO :EOF
REM ---------- ----------

REM ---------- HFSLIPx.inf Creator 1 ----------
:HFSLIPINFCREATOR1
ECHO>%SOURCESS%\I386\HFSLP%HFSLP%.inf [Version]
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf Signature="$WINDOWS NT$"
ECHO/>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf [DefaultInstall]
IF NOT "%VERSION%"=="2000" (
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=Product.Add.Reg
) ELSE (
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=Product.Add.Reg,keys.add,MSI.AddReg,Actsetup.Reg,User.AddReg,Base.IE.AddReg,Common.Add.Reg,AppCompatSetup.reg,NoPrompt.AddReg,RegisterActiveSetup,Reg.WPD,MTP.AutoPlayRegistration,reg.devices,Reg.Codecs,Fraunhofer.Reg,V9Reg.Core,V9Reg.Core.AddOnly,V9Reg.Univ,WMP.ARP,V9.RegPUI,WMPAddReg.PUI,WMPAddReg.OSPUI,V9Reg.XP,WMP.SPAD,WMP.Reg.IEHard,Reg.WMDMHandler
	IF EXIST TEMP\UPDATE\sp5.cat (
		IF NOT EXIST HF\MDAC_TYP.exe (ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=MDAC.Conditional.Reg)
		IF "%VERSIONIE%"=="2KIE5" (
			ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=OE.AddReg,IE.AddReg,JScript.AddReg,IE501SP4.AddReg
			ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf DelReg=OE.DelReg,IE.DelReg,IE5.DelReg,IE501SP4.DelReg
		)
	)
)
IF EXIST TEMP\msiexec.exe IF NOT "%VERSION%"=="2000" (ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=MSI.AddReg)
IF EXIST TEMP\scripten.inf IF EXIST TEMP\wscript.hlp (ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=RegisterActiveSetup,AddReg.WSH,AddReg.Extensions.NT)
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf DelReg=Product.Del.Reg,keys.del
IF EXIST TEMP\rspndr.exe (
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=RespReg
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf [RespReg]
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce","Responder",0x20000,"%%SYSTEMROOT%%\SYSTEM32\rspndr.exe -i"
)
IF EXIST TEMP\UPDATE\*925876* (
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf RunPostSetupCommands=RunPost
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf [RunPost]
	ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf "wscript /B %%SYSTEMROOT%%\Installer\TSClientMsiTrans\tscinst.vbs"
)
ECHO/>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
FINDSTR /VI "DefaultInstall" WORK\INFS\%HFSLP%.inf>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
REM *@*
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLP%HFSLP%.inf,,1
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZA","%HFSLP%",0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\HFSLP%HFSLP%.inf,DefaultInstall"
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLP%HFSLP%.inf = 1,,,,,,,999,0,0
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLP%HFSLP%.inf
GOTO :EOF
REM ---------- ----------

REM ---------- Hotfix Basic ----------
:HFBASIC
TITLE %T1% - Processing %HF%
MD TEMP
HF\BASIC\%HF% /Q /X:TEMP
ATTRIB -R -A -S -H TEMP\*.*  /S /D
CALL :PARSE_KB
CALL :HF1COMMON_A
CALL :HF1COMMON_B
GOTO :EOF
REM ---------- ----------

REM ---------- Parse Update ----------
:PARSE_KB
FOR /F "tokens=2,3 delims=-" %%I IN ('ECHO %HF%') DO (
	SET "KBNUMBER=%%I"
	SET "KBNUMBERB=%%J"
)
FOR /F "delims=Ww" %%I IN ('ECHO %KBNUMBER%') DO (
	IF /I "%%I"=="indo" (SET "KBNUMBER=%KBNUMBERB%")
)
ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\%KBNUMBER%","Installed",0x10001,1
SET "KBNUMBER="
SET "KBNUMBERB="
GOTO :EOF
REM ---------- ----------

REM ---------- Hotfix No Registry Entry ---------- 
:HFNOREG
TITLE %T1% - Processing %HF%
MD TEMP
HF\NOREG\%HF% /Q /X:TEMP
ATTRIB -R -A -S -H TEMP\*.*  /S /D
CALL :HF1COMMON_A
CALL :HF1COMMON_B
GOTO :EOF
REM ---------- ----------

REM ---------- HF1 Common A ----------
:HF1COMMON_A
IF EXIST TEMP\UPDATE\*898543* IF NOT "%LNG%"=="ENU" (
	FOR /F %%I IN ('DIR /B TEMP\SP%SP%QFE') DO (
		IF /I NOT "%%I"=="msobmain.dll" (DEL /Q/F TEMP\SP%SP%QFE\%%I)
	)
)

REM Workaround for Internet Explorer 8.
IF "%VERSIONIE%"=="IE8" (
	IF EXIST TEMP\UPDATE\*951978* (
		DEL /Q/F TEMP\SP%SP%QFE\jscript.dll
		DEL /Q/F TEMP\SP%SP%QFE\vbscript.dll
	)
	IF NOT DEFINED IE8HFX (
		IF EXIST TEMP\SP%SP%QFE\html.iec (
			FOR /F %%I IN ('DIR /B TEMP\SP%SP%QFE') DO (
				IF /I NOT "%%I"=="shdocvw.dll" IF /I NOT "%%I"=="browseui.dll" (
					DEL /Q/F TEMP\SP%SP%QFE\%%I
					ECHO DEL TEMP\SP%SP%QFE\%%I
				)
			)
		)
	)
)

IF "%VERSION%"=="2000" (
	CALL :BANDAID2K
	
	REM 2024/8/12
	REM TODO SPUPDATE was originally a string with a value of ("SP"+string(%SP%+1)), but the following code changed it to an integer value
	REM of (%SP%+1), removing the preceding "SP" string. I am going to assume that it was an oversight and corrected it back to a string
	REM with "SP" preceeding the updated integer value. If this assumption is wrong, please let me know.
	
	REM 2020-08-07: [merged from HFSLIP2000-1.0.2.cmd]
	REM Force slipstream XP/2003 updates into Windows 2000
	SET /A "SPBKP=%SP%"
	FOR %%I IN (1 2 3) DO (
		SET /A "SP=%%I"
		SET /A "SPCNT=!SP!+1"
		SET "SPUPDATE=SP!SPCNT!"
		CALL :MID_BA_51 2>NUL
	)
	REM 2024/8/12
	REM Resetting SUPDATE back to what is should be.
	SET /A "SP=!SPBKP!"
	SET /A "SPCNT=!SP!+1"
	SET "SPUPDATE=SP!SPCNT!"
	SET "SPBKP="
	SET "SPCNT="
	
	REM TODO Is this still necessary?
	REM Add gdiplus.dll to Windows 2000
	IF EXIST TEMP\ASMS (
		FOR /R TEMP\ASMS %%I IN (*.dll) DO (
			XCOPY /DEHY "%%I" TEMP >NUL
		)
		RD /Q/S TEMP\ASMS
	)
	
	IF EXIST TEMP\DX9 IF "%DX9%"=="Slipstreamed" (MOVE /Y TEMP\DX9\* TEMP >NUL)
	REM bandaid for WMP hotfix 12/13/08	next two lines
	IF EXIST TEMP\WM41 (MOVE /Y TEMP\WM41\* TEMP >NUL)
	REM	IF EXIST TEMP\WM9L MOVE /Y TEMP\WM9L\* TEMP >NUL
	REM OCT 16 2009
	IF EXIST TEMP\WM8 (MOVE /Y TEMP\WM8\* TEMP >NUL)
	IF EXIST TEMP\WM9 (MOVE /Y TEMP\WM9\* TEMP >NUL)
	IF EXIST TEMP\WM9L (MOVE /Y TEMP\WM9L\* TEMP >NUL)
	
	IF EXIST TEMP\ARA_mmc.exe.mui (
		ECHO>>WORK\HFSDST.txt MUIfall=10,"MUI\fallback"
		FOR /F "tokens=1,2 delims=_" %%I IN ('DIR /B TEMP\*.exe.mui') DO (
			ECHO>>WORK\RENAME.cmd REN "WORK\I386E\%%I_%%J" %%I_mmc.mui
			CALL :SETHEX4ALL %%I
			ECHO>>WORK\HFSSDF.txt %%I_mmc.mui=1
			ECHO>>WORK\HFS_MUIfall.txt !HEX4ALL!\mmc.exe.mui,%%I_mmc.mui
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I_mmc.mui = 1,,,,,,,,3,3
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I_mmc.mui
		)
		FOR /F "tokens=1,2 delims=_" %%I IN ('DIR /B TEMP\*.dll.mui') DO (
			ECHO>>WORK\RENAME.cmd REN "WORK\I386E\%%I_%%J" %%I_mmcm.mui
			CALL :SETHEX4ALL %%I
			ECHO>>WORK\HFSSDF.txt %%I_mmcm.mui=1
			ECHO>>WORK\HFS_MUIfall.txt !HEX4ALL!\mmcndmgr.dll.mui,%%I_mmcm.mui
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I_mmcm.mui = 1,,,,,,,,3,3
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I_mmcm.mui
		)
	)
) ELSE IF "%VERSION%"=="XP" (
	IF EXIST TEMP\*K3.inf (DEL /Q/F TEMP\*K3.inf)
	IF EXIST TEMP\*2003.inf (DEL /Q/F TEMP\*2003.inf)
	IF EXIST TEMP\UPDATE\*K3.inf (DEL /Q/F TEMP\UPDATE\*K3.inf)
	IF EXIST TEMP\UPDATE\*2003.inf (DEL /Q/F TEMP\UPDATE\*2003.inf)
	IF EXIST TEMP\UPDATE\*NET.cat (DEL /Q/F TEMP\UPDATE\*NET.cat)
	IF EXIST TEMP\UPDATE\*2k3.cat (DEL /Q/F TEMP\UPDATE\*2k3.cat)
	CALL :BANDAIDXP2K3
	IF EXIST TEMP\UPDATE\*928470* IF "%SUBTAG%"=="ic" (
		FOR /F %%I IN ('DIR /B/A-D/S TEMP\windowsupdatepkg') DO (MOVE /Y "%%I" TEMP >NUL)
		FOR /F "tokens=2 delims=," %%I IN ('FINDSTR /IR "\.Files=11," TEMP\UPDATE\updHFSLP.inf') DO (SET "TXTDIR06=%%~I")
	)
) ELSE (
	IF EXIST TEMP\*XP.inf (DEL /Q/F TEMP\*XP.inf)
	IF EXIST TEMP\UPDATE\*XP.inf (DEL /Q/F TEMP\UPDATE\*XP.inf)
	IF EXIST TEMP\UPDATE\*XP.cat (DEL /Q/F TEMP\UPDATE\*XP.cat)
	CALL :BANDAIDXP2K3
	IF EXIST TEMP\mscorees.dll (
		FOR /F "tokens=3 delims=." %%I IN ('FINDSTR /BIR "\[CopyAlways\.Mui\." TEMP\UPDATE\updHFSLP.inf') DO (SET "TXTDIR08=%%I")
	)
)

REM MPFLDRD=WM9
REM MPFLDRA=WMP9   | WMP10 | WMP11   | EMERALD
REM MPFLDRB=WMP9NL | WMP9L | WMP10NL | WMP10L
REM MPFLDRC=WM9NL  | WM9L  | WM10NL  | WM10L | WM11

REM "this works despite the error (that the directory is empty for the MOVE command)"
REM "There is a syntax error in the file name, folder name, or volume label."
REM ADD LINE BELOW 12/23/08
IF DEFINED MPFLDRD IF EXIST TEMP\!MPFLDRD! (MOVE /Y TEMP\!MPFLDRD!\*.* TEMP >NUL)
IF DEFINED MPFLDRA IF EXIST TEMP\!MPFLDRA! (MOVE /Y TEMP\!MPFLDRA!\*.* TEMP >NUL)
IF DEFINED MPFLDRB IF EXIST TEMP\!MPFLDRB! (MOVE /Y TEMP\!MPFLDRB!\*.* TEMP >NUL)
IF DEFINED MPFLDRC IF EXIST TEMP\!MPFLDRC! (MOVE /Y TEMP\!MPFLDRC!\*.* TEMP >NUL)

IF EXIST TEMP\ROOT (XCOPY /SEHY TEMP\ROOT WORK\CDROOT)
IF EXIST TEMP\createcab.cmd (DEL /Q/F TEMP\createcab.cmd)
FOR %%I IN (files commonfiles %SHORTOSNAME%) DO (
	IF EXIST TEMP\%%I (MOVE /Y TEMP\%%I\* TEMP >NUL)
)
IF EXIST TEMP\WM8\mpg4ds32.ax (MOVE /Y TEMP\WM8\mpg4ds32.ax TEMP >NUL)

REM "makeweight. here TEMP\SP3GDR\ TEMP\SP3QFE\ TEMP\SP2QFE\ is cleaned in the new xp-sp3 or 2003 hotfix format (in which delta compression)"
REM "Why - it’s unclear, because as a result, all files from WindowsXP-KB2423089-x86-RUS.exe, etc. XP hotfixes will be removed. or not?"

DIR /B/AD TEMP>TSDIR.txt
FOR /F %%I IN ('FINDSTR /I "GDR QFE" TSDIR.txt') DO (
	IF EXIST TEMP\%%I (RD /Q/S TEMP\%%I)
)
FOR /F %%I IN ('FINDSTR /BI "win2k winxp srv2k3 SP ip ic is ia id ib xp pconfig files common symbols Emerald WMP WM9 WM1 wind 56bit dx root" TSDIR.txt') DO (
	IF EXIST TEMP\%%I (RD /Q/S TEMP\%%I)
)
DEL /Q/F TSDIR.txt
GOTO :EOF
REM ---------- ----------

REM ---------- BANDAID2K Hotfixes ----------
:BANDAID2K
REM BAND AID FIX FOR BAND AID MSFT HOTFIX
IF EXIST TEMP\*XP.inf (DEL /Q/F TEMP\*XP.inf)
IF EXIST TEMP\*K3.inf (DEL /Q/F TEMP\*K3.inf)
IF EXIST TEMP\*2003.inf (DEL /Q/F TEMP\*2003.inf)
IF EXIST TEMP\UPDATE\*XP.inf (DEL /Q/F TEMP\UPDATE\*XP.inf)
IF EXIST TEMP\UPDATE\*XP_*.inf (DEL /Q/F TEMP\UPDATE\*XP_*.inf)
IF EXIST TEMP\UPDATE\*K3.inf (DEL /Q/F TEMP\UPDATE\*K3.inf)
IF EXIST TEMP\UPDATE\*2003.inf (DEL /Q/F TEMP\UPDATE\*2003.inf)
IF EXIST TEMP\UPDATE\*NET.cat (DEL /Q/F TEMP\UPDATE\*NET.cat)
IF EXIST TEMP\UPDATE\*XP.cat (DEL /Q/F TEMP\UPDATE\*XP.cat)
IF EXIST TEMP\UPDATE\*2k3.cat (DEL /Q/F TEMP\UPDATE\*2k3.cat)
IF "%VERSIONIE%"=="2KIE6" (
	IF EXIST TEMP\RTMQFE (
		XCOPY /EHY TEMP\RTMQFE\*.* TEMP >NUL
		IF EXIST TEMP\UPDATE\*RTMQFE.inf (REN TEMP\UPDATE\*RTMQFE.inf updHFSLP.inf)
	) ELSE IF EXIST TEMP\RTMGDR (
		XCOPY /EHY TEMP\RTMGDR\*.* TEMP >NUL
		IF EXIST TEMP\UPDATE\*RTMGDR.inf (REN TEMP\UPDATE\*RTMGDR.inf updHFSLP.inf)
	)
	IF EXIST TEMP\xpsp2_binarydrop (MOVE /Y TEMP\xpsp2_binarydrop\*.* TEMP >NUL)
)
IF "%VERSIONIE%"=="FDV" (
	IF EXIST HFCABS\IEW2K_1.cab (
		IF EXIST TEMP\xpsp2_binarydrop (MOVE /Y TEMP\xpsp2_binarydrop\*.* TEMP >NUL)
	) ELSE IF EXIST HFCABS\_IE6_HFSLIP.cab (
		IF EXIST TEMP\xpsp2_binarydrop (MOVE /Y TEMP\xpsp2_binarydrop\*.* TEMP >NUL)
	)
)
GOTO :EOF
REM ---------- ----------

REM ---------- Set HEX4ALL ----------
:SETHEX4ALL
IF "%1"=="ARA" (
	SET "HEX4ALL=0401"
) ELSE IF "%1"=="CHT" (
	SET "HEX4ALL=0404"
) ELSE IF "%1"=="CSY" (
	SET "HEX4ALL=0405"
) ELSE IF "%1"=="DAN" (
	SET "HEX4ALL=0406"
) ELSE IF "%1"=="DEU" (
	SET "HEX4ALL=0407"
) ELSE IF "%1"=="ELL" (
	SET "HEX4ALL=0408"
) ELSE IF "%1"=="ITA" (
	SET "HEX4ALL=0410"
) ELSE IF "%1"=="JPN" (
	SET "HEX4ALL=0411"
) ELSE IF "%1"=="KOR" (
	SET "HEX4ALL=0412"
) ELSE IF "%1"=="NLD" (
	SET "HEX4ALL=0413"
) ELSE IF "%1"=="NOR" (
	SET "HEX4ALL=0414"
) ELSE IF "%1"=="PLK" (
	SET "HEX4ALL=0415"
) ELSE IF "%1"=="PTB" (
	SET "HEX4ALL=0416"
) ELSE IF "%1"=="RUS" (
	SET "HEX4ALL=0419"
) ELSE IF "%1"=="FIN" (
	SET "HEX4ALL=040b"
) ELSE IF "%1"=="FRA" (
	SET "HEX4ALL=040c"
) ELSE IF "%1"=="HEB" (
	SET "HEX4ALL=040d"
) ELSE IF "%1"=="HUN" (
	SET "HEX4ALL=040e"
) ELSE IF "%1"=="SVE" (
	SET "HEX4ALL=041d"
) ELSE IF "%1"=="CHS" (
	SET "HEX4ALL=0804"
) ELSE IF "%1"=="PTG" (
	SET "HEX4ALL=0816"
) ELSE IF "%1"=="TRK" (
	SET "HEX4ALL=041f"
) ELSE IF "%1"=="ESN" (
	SET "HEX4ALL=0c0a"
)
GOTO :EOF
REM ---------- ----------

REM ---------- BANDAIDXP and 2003 Hotfixes ----------
:BANDAIDXP2K3
REM Bandaid fix for bandaid MSFT Hotfix.
IF EXIST TEMP\*2K.inf (DEL /Q/F TEMP\*2K.inf)
IF EXIST TEMP\UPDATE\*2K.inf (DEL /Q/F TEMP\UPDATE\*2K.inf)
IF EXIST TEMP\UPDATE\*2K_*.inf (DEL /Q/F TEMP\UPDATE\*2K_*.inf)
IF EXIST TEMP\UPDATE\*2K.cat (DEL /Q/F TEMP\UPDATE\*2K.cat)
:MID_BA_51
IF DEFINED IE7HFX IF %SP% EQU 3 IF NOT EXIST TEMP\SP3QFE IF EXIST TEMP\SP2QFE (
	XCOPY /EHY TEMP\SP2QFE\*.* TEMP >NUL
	REN TEMP\UPDATE\*SP2QFE*.inf updHFSLP.inf
)
IF %SP% GEQ 1 IF NOT EXIST TEMP\UPDATE\update_SP%SP%*.inf IF EXIST TEMP\UPDATE\update_%SPUPDATE%QFE.inf (
	IF EXIST TEMP\%SPUPDATE%QFE (REN TEMP\%SPUPDATE%QFE SP%SP%QFE)
	REN TEMP\UPDATE\update_%SPUPDATE%QFE.inf update_SP%SP%QFE.inf
)
IF EXIST TEMP\UPDATE\*SP%SP%QFE*.inf (
	IF EXIST TEMP\SP%SP%QFE (XCOPY /EHY TEMP\SP%SP%QFE\*.* TEMP >NUL)
	REN TEMP\UPDATE\*SP%SP%QFE*.inf updHFSLP.inf
) ELSE IF EXIST TEMP\UPDATE\*SP%SP%GDR*.inf (
	IF EXIST TEMP\SP%SP%GDR (XCOPY /EHY TEMP\SP%SP%GDR\*.* TEMP >NUL)
	REN TEMP\UPDATE\*SP%SP%GDR*.inf updHFSLP.inf
) ELSE IF EXIST TEMP\UPDATE\*RTMQFE*.inf (
	IF EXIST TEMP\RTMQFE (XCOPY /DHY TEMP\RTMQFE\*.* TEMP >NUL)
	REN TEMP\UPDATE\*RTMQFE*.inf updHFSLP.inf
) ELSE IF EXIST TEMP\UPDATE\*RTMGDR*.inf (
	IF EXIST TEMP\RTMGDR (XCOPY /DHY TEMP\RTMGDR\*.* TEMP >NUL)
	REN TEMP\UPDATE\*RTMGDR*.inf updHFSLP.inf
)
IF EXIST TEMP\%SUBTAG%\*.* (XCOPY /DHY TEMP\%SUBTAG%\*.* TEMP >NUL)
IF EXIST TEMP\%SPUPDATE% (XCOPY /DEHY TEMP\%SPUPDATE%\*.* TEMP >NUL)
GOTO :EOF
REM ---------- ----------

REM ---------- HF1 Common B ----------
:HF1COMMON_B
IF "%VERSION%"=="2000" (
	IF EXIST TEMP\UPDATE\*896358* IF NOT "%LNG%"=="ENU" IF EXIST WORK\I386E\itss.dll (DEL /Q/F WORK\I386E\itss.dll WORK\I386E\itircl.dll)
	IF EXIST TEMP\UPDATE\SP5.cat (
		COPY TEMP\EMPTY.cat WORK\SVCPACK\oem0.cat
		IF EXIST HF\MDAC_TYP.exe (DEL /Q/F TEMP\ODBC32.dll TEMP\ODBCBCP.dll TEMP\ODBCCP32.dll TEMP\SQLSRV32.dll)
	)
	
	REM 2020-08-07: [merged from HFSLIP2000-1.0.2.cmd]
	REM Rename to xpsp3res.dll when slipstreaming XP updates into 2000
	IF EXIST TEMP\spru0*.dll REN TEMP\spru0*.dll xpsp3res.dll
	IF EXIST TEMP\sprs0*.dll REN TEMP\sprs0*.dll xpsp3res.dll
) ELSE IF "%VERSION%"=="2003" (
	IF EXIST TEMP\w03*3%LG3%.dll IF NOT EXIST TEMP\w03a3409.dll (REN TEMP\w03*3%LG3%.dll w03a3409.dll)
	IF EXIST TEMP\w03*2%LG3%.dll IF NOT EXIST TEMP\w03a2409.dll (REN TEMP\w03*2%LG3%.dll w03a2409.dll)
) ELSE IF "%VERSION%"=="XP" (
	IF EXIST TEMP\spru0*.dll (REN TEMP\spru0*.dll xpsp3res.dll)
	IF EXIST TEMP\sprs0*.dll (REN TEMP\sprs0*.dll xpsp3res.dll)
	IF EXIST TEMP\sprv0*.dll (REN TEMP\sprv0*.dll xpsp4res.dll)
	IF %SP% EQU 1 (
		IF DEFINED MPFLDRA (
			IF EXIST TEMP\UPDATE\*828026* (
				DEL /Q/F TEMP\wmp*.dll
				ECHO DEL TEMP\wmp*.dll
			)
		) ELSE (
			IF EXIST TEMP\wmpcore8.dll (REN TEMP\wmpcore8.dll wmpcore.dll)
		)
		IF EXIST TEMP\ivfsrc.ax (
			FOR /F %%I IN ('DIR /B/A-D TEMP') DO (ECHO>>WORK\NSFREGNOT.txt %%I)
		)
	)
)
IF EXIST TEMP\NTPRINT.cat (MOVE /Y TEMP\NTPRINT.cat WORK\I386E)
IF EXIST TEMP\UPDATE\*.cat (XCOPY /DY TEMP\UPDATE\*.cat WORK\SVCPACK >NUL)
IF EXIST TEMP\*.cat (
	XCOPY /DY TEMP\*.cat WORK\SVCPACK >NUL
	DEL /Q/F TEMP\*.cat
)
IF EXIST TEMP\UPDATE (RD /Q/S TEMP\UPDATE)

REM Temp fix for file creation date issue with Oct'07 IE7 installer.
REM Upd. Nov 11 - if HFX with ieframe.dll.mui: ieframe.dll.mui force-copied, others replace existing ones if newer.
REM             - if HFX without ieframe.dll.mui: files newer than 8-Mar-2007 replace existing ones.
IF DEFINED IE7HFX (
	IF NOT EXIST TEMP\ieframe.dll.mui (
		XCOPY /HY /D:03-08-2007 TEMP WORK\I386E
	) ELSE (
		ECHO  Force-copied TEMP\ieframe.dll.mui
		MOVE /Y TEMP\ieframe.dll.mui WORK\I386E
		XCOPY /DHY TEMP WORK\I386E
	)
	SET "IE7HFX="
	CALL :CLEANTEMP
	ECHO/
	GOTO :EOF
)

XCOPY /DEHY TEMP WORK\I386E
CALL :CLEANTEMP
ECHO/
GOTO :EOF
REM ---------- ----------

REM ---------- HF2 Extract ----------
:HF2EXTRACT
TITLE %T1% - Processing %HF%
ECHO %HF%

REM 2020-08-07: [merged from HFSLIP2000-1.0.2.cmd]
REM Have to use 7ZA to unpack new rvkroots in 2000.
IF /I "%HF%"=="rvkroots.exe" IF "%HostOS%"=="2000" (
	HFTOOLS\7za.exe x HF\%HF% -o"%PREP%\TEMP" -r >NUL
	GOTO :MIDHF2CALLER
)
HF\%HF% /Q:A /T:"%PREP%\TEMP" /C
:MIDHF2CALLER
ATTRIB -R -A -S -H TEMP\*.*  /S /D

REM TODO CALL or GOTO, that is the question.
IF EXIST TEMP\mdacxpak.cab (GOTO :MDAC28)
IF EXIST TEMP\ADVPACK.dll (DEL /Q/F TEMP\ADVPACK.dll)
IF EXIST TEMP\SETUP.* (DEL /Q/F TEMP\SETUP.*)
IF EXIST TEMP\*INST.exe (DEL /Q/F TEMP\*INST.exe)
IF EXIST TEMP\INSTMSI*.exe (DEL /Q/F TEMP\INSTMSI*.exe)
IF EXIST TEMP\*QFE.inf (DEL /Q/F TEMP\*QFE.inf)
IF EXIST TEMP\UPDATEBR.inf (DEL /Q/F TEMP\UPDATEBR.inf)
IF EXIST TEMP\*_D.inf (DEL /Q/F TEMP\*_D.inf)
IF EXIST TEMP\*prereq.inf (DEL /Q/F TEMP\*prereq.inf)
IF EXIST TEMP\*DLvl.inf (DEL /Q/F TEMP\*DLvl.inf)
IF EXIST TEMP\fontinst.* (DEL /Q/F TEMP\fontinst.*)
IF EXIST TEMP\*WinME.* (DEL /Q/F TEMP\*WinME.*)
IF EXIST TEMP\KB832414* (DEL /Q/F TEMP\KB832414*.inf)
IF NOT "%VERSION%"=="2000" IF EXIST TEMP\*2K.* (DEL /Q/F TEMP\*2K.*)
IF NOT "%VERSION%"=="XP" (
	IF EXIST TEMP\*XP.* (DEL /Q/F TEMP\*XP.*)
	IF EXIST TEMP\*XPx.* (DEL /Q/F TEMP\*XPx.*)
)
IF NOT "%VERSION%"=="2003" (
	IF EXIST TEMP\*K3.* (DEL /Q/F TEMP\*K3.*)
	IF EXIST TEMP\*003.* (DEL /Q/F TEMP\*003.*)
	IF EXIST TEMP\*NET.* (DEL /Q/F TEMP\*NET.*)
)
IF EXIST TEMP\*.inf (
	FOR /F %%I IN ('DIR /B TEMP\*.inf') DO (
		SET /A "HFSLP+=1"
		COPY TEMP\%%I "WORK\INFS\%%I" >NUL
		SET "HFSLP2=%%I"
		CALL :HFSLIPINFCREATOR2
	)
)
REM Workaround for May 2013 Root Certificates Update.
IF EXIST TEMP\updroots.exe (
	IF EXIST HF\rvkroots.exe (
		FOR /F %%I IN ('FINDSTR "5...1...2.4.8.4" TEMP\updroots.exe') DO (DEL /F/Q TEMP\updroots.exe)
	)
)
IF EXIST TEMP\*.cat (
	XCOPY /DY TEMP\*.cat WORK\SVCPACK >NUL
	DEL /Q/F TEMP\*.cat
)
IF EXIST TEMP\*.inf (DEL /Q/F TEMP\*.inf)
XCOPY /DEHY TEMP WORK\I386E
CALL :CLEANTEMP
ECHO/
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- HFSLIPx.inf Creator 2 ----------
:HFSLIPINFCREATOR2
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf [Version]
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf Signature="$WINDOWS NT$"
ECHO/>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf [DefaultInstall]
IF "%HFSLP2%"=="aolsupp.inf" (ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf CustomDestination=MSIExploreDestinationSection)
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf RegisterDlls=WMWPD.Register,DRMOCX.Register,OCX.Register,WMPOCX.Register,WMPOCX.RegWMV,regwmp.codecs
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=keys.add,AddReg.SetupKey,Product.Add.Reg,MSI.AddReg,Actsetup.Reg,User.AddReg,Base.IE.AddReg,Common.Add.Reg,AppCompatSetup.reg,NoPrompt.AddReg,RegisterActiveSetup,AddReg.Extensions.NT,Reg.WPD,MTP.AutoPlayRegistration,reg.devices,Reg.Codecs,Fraunhofer.Reg,V9Reg.Core,V9Reg.Core.AddOnly,V9Reg.Univ,WMP.ARP,V9.RegPUI,WMPAddReg.PUI,WMPAddReg.OSPUI,V9Reg.XP,WMP.SPAD,WMP.Reg.IEHard,Reg.WMDMHandler,AddReg,AddReg.NT,AddUninst,AddReg.95,Aol.Reg.Entries,AddRegSection
IF EXIST TEMP\scripten.inf IF EXIST TEMP\wscript.hlp (ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf AddReg=RegisterActiveSetup,AddReg.WSH,AddReg.Extensions.NT)
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf DelReg=keys.del,Product.Del.Reg,Reg.Del
ECHO>>%SOURCESS%\I386\HFSLP%HFSLP%.inf ; RunPostSetupCommands=RunPost,RunPostSetupCmds,PostInstall
ECHO/>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
FINDSTR /VI "DefaultInstall npwmsdrm.dll npdrmv2.dll npdrmv2.zip" WORK\INFS\%HFSLP2%>>%SOURCESS%\I386\HFSLP%HFSLP%.inf
:TYPE2ROROE
REM *@*
REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\HFSLP%HFSLP%.inf,,1
ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZA","%HFSLP%",0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\HFSLP%HFSLP%.inf,DefaultInstall"
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLP%HFSLP%.inf = 1,,,,,,,999,0,0
ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLP%HFSLP%.inf
GOTO :EOF
REM ---------- ----------

REM ---------- Hotfix Cleanup ----------
:HFCLEANUP
TITLE %T1% - HFCLEANUP
ECHO/
ECHO Reducing Installation Source
ECHO/

REM ---------------------------------
REM FILES
REM RDV=Remove drivers
REM     List of files with 2 character extention, e.g. DRIVER.sys should be DRIVER.SY
REM     Files listed here are deleted from extracted DRIVER.cab and i386 folder
REM     Entries are removed from TXTSETUP.sif, DOSNET.inf, LAYOUT.sif, SYSSETUP.inf, SYCOC.
REM     HFSLIP automatically generates the DRIVER.inf file
REM
REM REM=Remove files
REM     List of files with 2 character extention, e.g. DRIVER.sys should be DRIVER.SY
REM     Files listed here are deleted from i386 folder
REM     Entries are removed from TXTSETUP.sif, DOSNET.inf, LAYOUT.sif, SYSSETUP.inf, SYCOC.
REM 
REM RIN=Remove INF section files
REM     Semicolon delimited list
REM     Example of a line:     INFNAME.IN;TEXT_TO_REMOVE
REM         INFNAME.IN....      Note it is .IN, not .inf
REM         TEXT_TO_REMOVE..... The INF is opened and the TEXT_TO_REMOVE line is removed from the INF file
REM     NAME_OF_RIN_FILE should be same as NAME_OF_REM FILE
REM     HFSLIP will remove any entries from the NAME_OF_REM FILE from the INFNAME.inf file
REM ---------------------------------

REM Prep if user wants to mod FDVS fileset.
IF "%DIAGNOSTIC%"=="1" (
	TITLE %T1% - HFCLEANUP - DRIVER.cab
	ECHO/
	ECHO Expanding Driver.cab
	ECHO/
	
	MD %SOURCESS%\I386\DRIVER
	EXPAND %SOURCESS%\I386\DRIVER.cab -F:* %SOURCESS%\I386\DRIVER
	DEL /Q/F %SOURCESS%\I386\DRIVER.cab
	ECHO All files extracted. Cleanup ready to begin.>CON
	PAUSE>CON
	TITLE %T1% - HFCLEANUP
)
IF NOT "%DIAGNOSTIC%"=="1" IF /I "%FDVT%"=="Y" (
	FOR /F "delims=." %%I IN ('DIR /B WORK\FDV\*.in_') DO (
		REN WORK\FDV\%%I.in_ %%I.inf
		MAKECAB work\FDV\%%I.inf /L WORK\FDV
		DEL /Q /F WORK\FDV\%%I.inf
		MOVE /Y WORK\FDV\%%I.in_ %SOURCESS%\I386
	)
	MOVE /Y WORK\FDV\*.inf %SOURCESS%\I386
)

:HFCLEANUP2
REM HFCBASE is a "global" variable.
FOR /F %%I IN ('DIR /B HFCLEANUP') DO (
	SET /A "HFCFULL=1"
	IF /I NOT "%%~xI"==".EXT" (SET /A "HFCBASE=1")
)
IF NOT DEFINED HFCFULL (GOTO :EOF)
SET "HFCFULL="
IF NOT DEFINED HFCBASE IF NOT "%DIAGNOSTIC%"=="1" (GOTO :EOF)
ECHO/
ECHO Processing HFCLEANUP

IF EXIST HFCLEANUP\*.RDV (
	REM Delete the driver files.
	FOR /F "delims=." %%I IN ('DIR /B HFCLEANUP\*.RDV') DO (
		ECHO DELETING DRIVERS - %%I
		FOR /F %%J IN (HFCLEANUP\%%I.RDV) DO (
			IF NOT EXIST %SOURCESS%\DRIVER\%%I (MD %SOURCESS%\DRIVER\%%I)
			IF NOT EXIST %SOURCESS%\DRIVERCAB\%%I (MD %SOURCESS%\DRIVERCAB\%%I)
			IF EXIST %SOURCESS%\I386\%%J* (MOVE %SOURCESS%\I386\%%J* %SOURCESS%\DRIVER\%%I >NUL)
			IF EXIST %SOURCESS%\I386\DRIVER\%%J* (MOVE %SOURCESS%\I386\DRIVER\%%J* %SOURCESS%\DRIVERCAB\%%I >NUL)
			ECHO %%J>>WORK\RED\FILTER.txt
		)
  )
)

IF EXIST HFCLEANUP\*.REM (
	REM Delete the junk binaries.
	FOR /F "delims=." %%I IN ('DIR /B HFCLEANUP\*.REM') DO (
		ECHO DELETING FILES - %%I
		IF NOT EXIST %SOURCESS%\OPTIONAL\%%I (MD %SOURCESS%\OPTIONAL\%%I)
		FOR /F %%J IN (HFCLEANUP\%%I.REM) DO (
			IF EXIST %SOURCESS%\I386\%%J* (MOVE %SOURCESS%\I386\%%J* %SOURCESS%\OPTIONAL\%%I >NUL)
			ECHO %%J>>WORK\RED\FILTER.txt
		)
   )
)

IF EXIST WORK\RED\FILTER.txt (
	ECHO Updating SYSOC.inf
	EXPAND -R %SOURCESS%\I386\SYSOC.in_ >NUL
	DEL /Q /F %SOURCESS%\I386\SYSOC.in_
	REN %SOURCESS%\I386\SYSOC.inf SYSOC_TEMP.inf
	FINDSTR /V /I /G:WORK\RED\FILTER.txt %SOURCESS%\I386\SYSOC_TEMP.inf > SYSOC.inf
	MAKECAB SYSOC.inf /L %SOURCESS%\I386 >NUL
	DEL /Q /F %SOURCESS%\I386\SYSOC_TEMP.inf
	DEL /Q /F SYSOC.inf
	
	ECHO Updating SYSSETUP.inf
	EXPAND -R %SOURCESS%\I386\SYSSETUP.in_ >NUL
	DEL /Q /F %SOURCESS%\I386\SYSSETUP.in_
	REN %SOURCESS%\I386\SYSSETUP.inf SYSSETUP_TEMP.inf
	FINDSTR /V /I /G:WORK\RED\FILTER.txt %SOURCESS%\I386\SYSSETUP_TEMP.inf > SYSSETUP.inf
	MAKECAB SYSSETUP.inf /L %SOURCESS%\I386 >NUL
	DEL /Q /F %SOURCESS%\I386\SYSSETUP_TEMP.inf
	DEL /Q /F SYSSETUP.inf
	
	REM TODO Understand the following.
	REM *@*
	REM Why did evgnb comment all of this out? >
	ECHO Updating WBEMOC.inf
	EXPAND -R %SOURCESS%\I386\WBEMOC.in_ >NUL
	DEL /Q /F %SOURCESS%\I386\WBEMOC.in_
	REN SOURCESS\I386\WBEMOC.inf WBEMOC_TEMP.inf
	FINDSTR /V /I /G:WORK\RED\FILTER.txt %SOURCESS%\I386\WBEMOC_TEMP.inf > WBEMOC.inf
	MAKECAB WBEMOC.inf /L %SOURCESS%\I386 >NUL
	DEL /Q /F %SOURCESS%\I386\WBEMOC_TEMP.inf
	DEL /Q /F WBEMOC.inf
	
	REM And why was this commented out originally in 1.7.8? >>
	ECHO Updating DOSNET.inf
	FINDSTR /V /B /I /G:WORK\RED\FILTER.txt %SOURCESS%\I386\DOSNET.inf > DOSNET.inf
	MOVE DOSNET.inf %SOURCESS%\I386\DOSNET.inf
	REM <<
	
	ECHO Updating LAYOUT.inf ... This takes a few seconds
	FINDSTR /V /B /I /G:WORK\RED\FILTER.txt %SOURCESS%\I386\LAYOUT.inf > LAYOUT.inf
	MOVE LAYOUT.inf %SOURCESS%\I386\LAYOUT.inf
	REM <
	
	ECHO Updating TXTSETUP.sif ... This takes a few seconds
	FINDSTR /V /B /I /G:WORK\RED\FILTER.txt %SOURCESS%\I386\TXTSETUP.sif > TXTSETUP.sif
	MOVE TXTSETUP.sif %SOURCESS%\I386\TXTSETUP.sif
)

IF EXIST HFCLEANUP\*.RIN (
	ECHO/
	ECHO Expand INFs to be gutted
	ECHO/
	FOR /F "delims=." %%I IN ('DIR /B HFCLEANUP\*.RIN') DO (
		FOR /F "delims=;" %%J IN (HFCLEANUP\%%I.RIN) DO (
			IF NOT EXIST WORK\RED\%%JF IF EXIST %SOURCESS%\I386\%%J_ (
				EXPAND -R %SOURCESS%\I386\%%J_ WORK\RED
				ECHO %%JF
			)
			IF NOT EXIST WORK\RED\%%JF IF EXIST %SOURCESS%\I386\%%JF (
				COPY /Y %SOURCESS%\I386\%%JF WORK\RED
				ECHO %%JF
			)
		)
	)
	
	IF EXIST WORK\RED\INTL.inf (DEL /Q /F WORK\RED\INTL.inf && TYPE %SOURCESS%\I386\INTL.inf>>WORK\RED\INTL.inf)
	IF EXIST %SOURCESS%\I386\WMS (RD /Q /s %SOURCESS%\I386\WMS)
	IF EXIST %SOURCESS%\AUTORUN.inf (DEL /Q /F %SOURCESS%\AUTORUN.inf)
	IF EXIST %SOURCESS%\READ1ST.txt (DEL /Q /F %SOURCESS%\READ1ST.txt)
	IF EXIST %SOURCESS%\SETUP.exe (DEL /Q /F %SOURCESS%\SETUP.exe)
	IF EXIST %SOURCESS%\SPNOTES.HTM (DEL /Q /F %SOURCESS%\SPNOTES.HTM)
	
	ECHO/
	ECHO Gut the INF files
	ECHO/
	FOR /F "delims=." %%I IN ('DIR /B HFCLEANUP\*.RIN') DO (
		FOR /F "tokens=1,2 delims=;" %%J IN (HFCLEANUP\%%I.RIN) DO (
			ECHO Processing %%J, filtering string %%I
			IF EXIST WORK\RED\%%JF (
				FINDSTR /V /I /C:"%%K" WORK\RED\%%JF > WORK\RED\T.inf
				DEL WORK /Q /F WORK\RED\%%JF
				REN WORK\RED\T.inf %%JF
			)
			IF EXIST WORK\RED\%%JF IF EXIST HFCLEANUP\%%I.REM (
				FINDSTR /V /I /G:HFCLEANUP\%%I.REM WORK\RED\%%JF > WORK\RED\T.inf
				DEL WORK /Q /F WORK\RED\%%JF
				REN WORK\RED\T.inf %%JF
			)
			IF EXIST WORK\RED\%%JF IF EXIST HFCLEANUP\%%I.RDV (
				FINDSTR /V /I /G:HFCLEANUP\%%I.RDV WORK\RED\%%JF > WORK\RED\T.inf
				DEL WORK /Q /F WORK\RED\%%JF
				REN WORK\RED\T.inf %%JF      
			)
		)
	)
	
	ECHO/
	ECHO Recab the INF files
	ECHO/
	FOR /F "delims=." %%I IN ('DIR /B WORK\RED\*.inf') DO (
		IF EXIST %SOURCESS%\I386\%%I.in_ (
			DEL %SOURCESS%\I386\%%I.in_
			MAKECAB WORK\RED\%%I.inf /L %SOURCESS%\I386
		)
		IF EXIST %SOURCESS%\I386\%%I.inf (
			DEL %SOURCESS%\I386\%%I.inf
			COPY WORK\RED\%%I.inf %SOURCESS%\I386\%%I.inf
		)
	)
	
	IF EXIST WORK\RED\TXTSETUP.sif (
		DEL %SOURCESS%\I386\TXTSETUP.sif
		COPY WORK\RED\TXTSETUP.sif %SOURCESS%\I386\TXTSETUP.sif
	)
)

REM Runs the INF file DEFAULTINSTALL section.
IF EXIST HFCLEANUP\*.inf (
	DIR HFCLEANUP\*.inf /A-D /OGN /B >WORK\HFEXPERTINF.txt
	COPY /Y HFCLEANUP\*.inf %SOURCESS%\I386 >NUL
	SET /A "HFSLP=10"
	REM @;
	ECHO>>%SOURCESS%\I386\HFSLIPWU.inf ;HFCLEANUP
	FOR /F %%I IN (WORK\HFEXPERTINF.txt) DO (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,999,0,0
		IF EXIST %SOURCESS%\I386\DOSNET.inf (ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I)
		ECHO>>%SOURCESS%\I386\HFSLIPWU.inf HKLM,"Software\Microsoft\Windows\CurrentVersion\RunOnce",ZZHFCU!HFSLP!,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\%%I,DefaultInstall"
		SET /A "HFSLP+=1"
	)
)
REM Fix mplayer2.inf - I hate Microsoft.
IF EXIST HFCLEANUP\*WINDOWSMEDIAPLAYER9*.^REM IF EXIST %SOURCESS%\I386\MPLAYER2.ex_ (
	EXPAND -R %SOURCESS%\I386\MPLAYER2.in_ >NUL
	DEL /Q /F %SOURCESS%\I386\MPLAYER2.in_
	ECHO>>%SOURCESS%\I386\MPLAYER2.inf [WMPCOPY.PLUGIN]
	ECHO>>%SOURCESS%\I386\MPLAYER2.inf MPLAYER2.exe
	MAKECAB %SOURCESS%\I386\MPLAYER2.inf /L %SOURCESS%\I386 >NUL
	DEL /Q /F %SOURCESS%\I386\MPLAYER2.inf
)


IF "%DIAGNOSTIC%"=="1" IF EXIST HFCLEANUP\*.EXT (CALL :DELBIN)
IF "%DIAGNOSTIC%"=="1" (
	ECHO Cleanup complete and setup files modified.>CON
	ECHO/>CON
	ECHO Enter "Y" to begin cleanup again.>CON
	SET /P "DIAGNOSTIC2="
	IF /I "!DIAGNOSTIC2!"=="Y" (
		SET "DIAGNOSTIC2=N"
		RD /Q /S WORK\RED
		MD WORK\RED
		CALL :HFCLEANUP2
	) ELSE (
		SET "DIAGNOSTIC2="
	)
)
IF EXIST %SOURCESS%\OPTIONAL (RD /Q /S %SOURCESS%\OPTIONAL)
IF EXIST %SOURCESS%\DRIVERCAB (RD /Q /S %SOURCESS%\DRIVERCAB)
IF EXIST %SOURCESS%\DRIVER (RD /Q /S %SOURCESS%\DRIVER)
GOTO :EOF
REM ---------- ----------


REM ******************** Hotfixes - EXPERT ********************


REM ---------- HFEXPERT ----------
:HFEXPERT
REM Thanks Yzöwl. Your scripts kick ass.
REM Modded for flexibility.
TITLE %T1% - HFEXPERT
ECHO/
ECHO Processing HFEXPERT
ECHO/

IF EXIST HFEXPERT\CODECS (
	FOR /F %%I IN ('DIR /B HFEXPERT\CODECS') DO (SET /A "HFXCPASS=1")
)
IF EXIST HFEXPERT\APPREPLACEMENT (
	FOR /F %%I IN ('DIR /B HFEXPERT\APPREPLACEMENT') DO (SET /A "HFXAPASS=1")
)
IF EXIST HFEXPERT\HIVEINSTALL (
	FOR /F %%I IN ('DIR /B HFEXPERT\HIVEINSTALL') DO (SET /A "HFXHPASS=1")
)
IF DEFINED HFXCPASS (
	CALL :HFECODEC
	SET "HFXCPASS="
)
IF DEFINED HFXAPASS (
	CALL :HFEAPPS
	SET "HFXAPASS="
)
IF DEFINED HFXHPASS (
	CALL :HFEHIVE
	SET "HFXHPASS="
)
IF EXIST HFEXPERT\AUTOIT\*.exe (CALL :HFEAU)
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT Codecs ----------
:HFECODEC
TITLE %T1% - HFEXPERT - Codecs
ECHO/
ECHO Processing HFEXPERT Codecs
ECHO/

MD TEMP\CODECS
XCOPY HFEXPERT\CODECS TEMP\CODECS >NUL
REM * FIX FOR DX9 COLLISION -- KEEP CODEC QASF, KEEP DX9 MSDMO
IF EXIST WORK\I386E\QASF.dll IF EXIST TEMP\CODECS\QASF.dll (MOVE /Y TEMP\CODECS\QASF.dll WORK\I386E)
IF EXIST WORK\I386E\MSDMO.dll IF EXIST TEMP\CODECS\MSDMO.dll (
	ECHO When including DirectX9, consider removing>CON
	ECHO MSDMO.dll from your codec package next time.>CON
	PAUSE>CON
	DEL /Q/F TEMP\CODECS\MSDMO.dll
)
DIR /B/A-D TEMP\CODECS>TEMP\HFEXPERT.txt
FINDSTR /R ".........\." TEMP\HFEXPERT.txt>TEMP\CLONG.txt
FOR /F %%I IN (TEMP\CLONG.txt) DO (SET /A "CODNBR=99")
IF NOT DEFINED CODNBR (
	TYPE TEMP\HFEXPERT.txt>TEMP\CSHORT.txt
) ELSE (
	FINDSTR /VBI /G:TEMP\CLONG.txt TEMP\HFEXPERT.txt>TEMP\CSHORT.txt
	FOR /F "tokens=1 delims=" %%I IN (TEMP\CLONG.txt) DO (
		SET "SFN1=%%~nI"
		SET "SFN2=%%~xI"
		SET /A "CODNBR+=1"
		REN "TEMP\CODECS\!SFN1!!SFN2!" HFCDC!CODNBR!!SFN2!
		IF /I NOT "!SFN2!"==".inf" (ECHO>>TEMP\HFCODTXT.txt HFCDC%%I!SFN2! = 1,,,,,,,2,0,0,"!SFN1!!SFN2!")
	)
)
SET "CODNBR="
IF EXIST TEMP\CODECS\*.inf (
	DIR /B/A-D TEMP\CODECS\*.inf>TEMP\HFEXPERTINF.txt
	MOVE /Y TEMP\CODECS\*.inf %SOURCESS%\I386
)
FINDSTR /VIR "\.exe \.CPI \.CPL \.inf \.txt" TEMP\HFEXPERT.txt>TEMP\HFEXPERTREG.txt
SET /A "HFSLP=10"
IF EXIST TEMP\HFEXPERTINF.txt (
	REM @;
	ECHO>>WORK\ROROEWU.txt ;CODECS
	FOR /F %%I IN (TEMP\HFEXPERTINF.txt) DO (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,999,0,0
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I
		REM *@*
		REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\HFSLIP\%%I,,1
		ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZC!HFSLP!,,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%10%%\HFSLIP\%%I,DefaultInstall"
		SET /A "HFSLP+=1"
	)
)
IF EXIST TEMP\CSHORT.txt (
	FOR /F %%I IN ('FINDSTR /VIR "\.inf" TEMP\CSHORT.txt') DO (ECHO>>TEMP\HFCODTXT.txt %%I = 1,,,,,,,2,0,0)
)
TYPE TEMP\HFCODTXT.txt>>%SOURCESS%\I386\TXTSETUP.sif
FOR /F %%I IN (TEMP\HFCODTXT.txt) DO (
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I
	%MODIFYPE% TEMP\CODECS\%%I -c
)
FOR /F %%I IN (TEMP\HFEXPERTREG.txt) DO (
	REM *@*
	REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s %%SYSTEMROOT%%\system32\%%I
	ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",ZZC!HFSLP!,0,"%%11%%\regsvr32 /s """%%11%%\%%I""""
	SET /A "HFSLP+=1"
)
IF EXIST TEMP\CODECS\*.CP* (
	FOR /F %%I IN ('DIR /B TEMP\CODECS\*.CP*') DO (MOVE /Y TEMP\CODECS\%%I %SOURCESS%\I386)
)
XCOPY /HY TEMP\CODECS\*.* WORK\I386E
CALL :CLEANTEMP
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT App Replacement ----------
:HFEAPPS
TITLE %T1% - HFEXPERT - App Replacement
ECHO/
ECHO Processing HFEXPERT Application Replacement
ECHO/

REM Copies files to the sources and replaces the originals like TASKMGR.exe and MPLAYER2.exe
DIR /B/A-D HFEXPERT\APPREPLACEMENT>WORK\HFEXPERT.txt
XCOPY /HY HFEXPERT\APPREPLACEMENT\* WORK\I386E
FOR /F %%I IN (WORK\HFEXPERT.txt) DO (%MODIFYPE% WORK\I386E\%%I -c)
DEL /Q/F WORK\HFEXPERT.txt
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT Hives ----------
:HFEHIVE
TITLE %T1% - HFEXPERT - Hives
ECHO/
ECHO Processing HFEXPERT Hives
ECHO/

DIR /B/A-D HFEXPERT\HIVEINSTALL>WORK\HFEXPERT.txt
XCOPY /HY HFEXPERT\HIVEINSTALL\* %SOURCESS%\I386
FOR /F %%I IN (WORK\HFEXPERT.txt) DO (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,_x,3,,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I
	ECHO>>WORK\HIVEINFS.txt AddReg = %%I,setup
)
DEL /Q/F WORK\HFEXPERT.txt
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT .AU File Processing ----------
:HFEAU
TITLE %T1% - HFEXPERT - .AU File Processing
ECHO/
ECHO Processing HFEXPERT .AU File
ECHO/

FOR /F %%I IN ('DIR /B HFEXPERT\AUTOIT\AUTOIT*.exe') DO (SET "AUTOEXE=%%I")
IF NOT DEFINED AUTOEXE (GOTO :EOF)
COPY /Y HFEXPERT\AUTOIT\*.* %SOURCESS%\I386\SVCPACK
FOR /F %%I IN ('DIR /B/ON HFEXPERT\AUTOIT\*.AU*') DO (ECHO>>WORK\HFSLIPCMDP1.cmd %%HFSLIPSVC%%%AUTOEXE% %%HFSLIPSVC%%%%I)
SET "AUTOEXE="
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT Windows Files ----------
:HFEWIN
TITLE %T1% - HFEXPERT - Windows Files
ECHO/
ECHO Processing HFEXPERT Windows Files
ECHO/

REM Copies files to the Windows or WINNT folder. No other processing done to them.
ECHO/
ECHO HFEXPERT\WIN
MD TEMP\WIN WORK\I386Z
XCOPY /S HFEXPERT\WIN TEMP\WIN >NUL

FOR /F %%I IN ('DIR /B TEMP\WIN') DO (
	ECHO>>TEMP\HFEXPERT.txt %%I
)
IF EXIST TEMP\HFEXPERT.txt (
	XCOPY /HY TEMP\WIN\* WORK\I386Z
	FOR /F %%I IN (TEMP\HFEXPERT.txt) DO (
		%MODIFYPE% WORK\I386Z\%%I -c
		ECHO>>TEMP\HFWINTXT.txt %%I = 1,,,,,,,1,0,0
		ECHO>>TEMP\HFWINDOS.txt d1,%%I
	)
)

IF EXIST TEMP\WIN\SYSTEM32\* (CALL :HFESYS32)
CALL :HFEYzowl
TITLE %T1% - HFEXPERT - Windows Files

SET "BASEDIR=%~dp0"
IF NOT EXIST TEMP\HFWINTXT.txt (
	CALL :CLEANTEMP
	GOTO :EOF
)
FOR /F %%I IN (TEMP\HFWINTXT.txt) DO (ECHO>>TEMP\HFWINTXT2.txt %%I)
FINDSTR /VBI /G:TEMP\HFWINTXT2.txt %SOURCESS%\I386\TXTSETUP.sif>TEMP\TXTSETUP.sif
IF EXIST TEMP\TXTNTDIR.txt (
	ECHO/>>TEMP\TXTSETUP.sif
	ECHO>>TEMP\TXTSETUP.sif [WinntDirectories]
	TYPE TEMP\TXTNTDIR.txt>>TEMP\TXTSETUP.sif
)
ECHO/>>TEMP\TXTSETUP.sif
ECHO>>TEMP\TXTSETUP.sif [SourceDisksFiles]
TYPE TEMP\HFWINTXT.txt>>TEMP\TXTSETUP.sif
MOVE /Y TEMP\TXTSETUP.sif %SOURCESS%\I386
IF EXIST %SOURCESS%\I386\DOSNET.inf (
	FINDSTR /VBI /G:TEMP\HFWINDOS.txt %SOURCESS%\I386\DOSNET.inf>TEMP\DOSNET.inf
	ECHO/>>TEMP\DOSNET.inf
	ECHO>>TEMP\DOSNET.inf [Files]
	TYPE TEMP\HFWINDOS.txt>>TEMP\DOSNET.inf
	MOVE /Y TEMP\DOSNET.inf %SOURCESS%\I386
)
IF EXIST WORK\I386Z\*.cab (MOVE /Y WORK\I386Z\*.cab %SOURCESS%\I386)

REM Single-file packer:
FOR /F %%I IN ('DIR /B WORK\I386Z') DO (
	ECHO Processing %%I
	IF EXIST %SOURCESS%\I386\%%I (
		MOVE /Y WORK\I386Z\%%I %SOURCESS%\I386 >NUL
	) ELSE (
		MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX WORK\I386Z\%%I /L %SOURCESS%\I386 >NUL
	)
)

SET /A "SDFEXTRA=1"
CALL :CLEANTEMP
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT Windows Files - System32 Files ----------
:HFESYS32
TITLE %T1% - HFEXPERT - System32 Files
ECHO/
ECHO Processing HFEXPERT Windows Files - System32 Files
ECHO/

DIR /B/A-D TEMP\WIN\SYSTEM32>TEMP\HFEXPERT.txt
FOR /F %%I IN (TEMP\HFEXPERT.txt) DO (SET /A "HFESYS32FILES=1")
IF NOT DEFINED HFESYS32FILES (GOTO :EOF)
SET "HFESYS32FILES="
IF EXIST TEMP\WIN\SYSTEM32\*.CP* (MOVE /Y TEMP\WIN\SYSTEM32\*.CP* %SOURCESS%\I386)
XCOPY /HYQ TEMP\WIN\SYSTEM32\*.* WORK\I386Z >NUL
DEL /Q/F TEMP\WIN\SYSTEM32\*.* >NUL
FOR /F %%I IN (TEMP\HFEXPERT.txt) DO (
	ECHO>>TEMP\HFWINTXT.txt %%I = 1,,,,,,,2,0,0
	ECHO>>TEMP\HFWINDOS.txt d1,%%I
)
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT Windows Files - Yzöwl ----------
:HFEYzowl
TITLE %T1% - HFEXPERT - Yzowl
ECHO/
ECHO Processing HFEXPERT Windows Files - Yzöwl
ECHO/

SET /A "SIFDIR=1100"
SET "BASEDIR=%~dp0TEMP\WIN\"

REM 2020-08-07: very strange bugfix - disable autoconvert long file names to short file names

REM "here is a real jamb with long names!"
REM "example:"
REM P:\2K-HFS~1>dir /b /s /on /ad TEMP\WIN
REM P:\2K-HFS~1\TEMP\WIN\FONTS
REM P:\2K-HFS~1\TEMP\WIN\SYSTEM32
REM P:\2K-HFS~1>dir /b /s /on /ad "P:\2k-hfslip-orig\TEMP\WIN"
REM P:\2k-hfslip-orig\TEMP\WIN\FONTS
REM P:\2k-hfslip-orig\TEMP\WIN\SYSTEM32
REM "Conclusion: The DIR command (Windows 6.1.7601) is so smart that it is necessary"
REM "use dir /b /s /on /ad "%~dp0TEMP\WIN" instead of dir /b /s /on /ad TEMP\WIN"
REM "so that the command does not try to substitute short names instead of long ones,"
REM "and so that the PathName=!DirName:%basedir%=! construction will continue to work correctly."
REM "Although this doesn't happen in another similar section of code, it's possible that DIRCMD is being set implicitly somewhere!"

FOR /F "delims=" %%I IN ('DIR /B /S /ON /AD "%BASEDIR%"') DO (
	REM TODO Is this a check if BASEDIR even exists, or if the prior loop failed?
	IF ERRORLEVEL 0 (
		DIR /B /A-D "%%I" >NUL 2>&1 && (
			REM CALL :PATHS "%%~I"
			REM "we leave only the relative path [“cut off” the left part - basedir]"
			SET "DIRNAME=%%~I"
			SET "PATHNAME=!DIRNAME:%BASEDIR%=!"
			ECHO !PATHNAME!>>TEMP\XPERTDIR.txt
			XCOPY /HY TEMP\WIN\!PATHNAME!\* WORK\I386Z
		)
	)
)
SET "DIRNAME="
SET "PATHNAME="
IF NOT EXIST TEMP\XPERTDIR.txt (GOTO :EOF)
FOR /F "delims=" %%I IN (TEMP\XPERTDIR.txt) DO (
	SET /A "SIFDIR+=1"
	ECHO>>TEMP\TXTNTDIR.txt !SIFDIR! = "%%I"
	
	REM "and add entries about the files [HFEXPERT.txt - temporary for each subdirectory]"
	DIR /B /ON /A-D TEMP\WIN\%%I > TEMP\HFEXPERT.txt
	FOR /F "delims=" %%J IN (TEMP\HFEXPERT.txt) DO (
		ECHO>>TEMP\HFWINTXT.txt %%J = 1,,,,,,,!SIFDIR!,0,0
		ECHO>>TEMP\HFWINDOS.txt d1,%%J
	)
)
REM "XpertDir.txt - another directory in HFEXPERT\WIN, more precisely in TEMP\WIN"
REM "HFEXPERT.txt - a list of files in it."
REM "TEMP\WIN\SYSTEM32 - previously processed separately as an exception"
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT Program Files ----------
:HFEPRG
TITLE %T1% - HFEXPERT - Program Files
ECHO/
ECHO Processing HFEXPERT Program Files
ECHO/

REM Based on HFEXPERT code by Yzöwl!
FOR /F %%I IN ('DIR /B/S/A-D HFEXPERT\PROGRAMFILES') DO (SET /A "TEMPPRG=1")
IF NOT DEFINED TEMPPRG (GOTO :EOF)
SET "TEMPPRG="

IF NOT DEFINED CDTAG (
	ECHO Adding Program Files requires a valid CD tag.>CON
	ECHO/>CON
	PAUSE>CON
	GOTO :EOF
)

MD TEMP
FOR /F %%I IN ('DIR /B /A-D HFEXPERT\PROGRAMFILES') DO (
	SET /A "PFROOT=1"
)
IF DEFINED PFROOT (
	ECHO>>TEMP\HFEPRGDDIR.txt CopyFiles1=16422
	ECHO/>>TEMP\HFEPRGCFIL.txt
	ECHO>>TEMP\HFEPRGCFIL.txt [CopyFiles1]
	FOR /F "delims=" %%K in ('DIR /B/A-D HFEXPERT\PROGRAMFILES') DO (
		ECHO Processing %%K ***** -7-
		ECHO>>TEMP\HFEPRGSDF.txt "%%K"=1
		ECHO>>TEMP\HFEPRGCFIL.txt "%%K"
		IF /I "%%~xK"==".cab" (
			MOVE /Y "HFEXPERT\PROGRAMFILES\%%K" %SOURCESS%\I386\PFILES >NUL
		) ELSE (
			MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX "HFEXPERT\PROGRAMFILES\%%K" "%%K" /L %SOURCESS%\I386\PFILES >NUL
		)
	)
)

SET "BASEDIR=%~dp0HFEXPERT\PROGRAMFILES\"
FOR /F "delims=" %%I IN ('DIR /B/S/ON/AD HFEXPERT\PROGRAMFILES') DO (
	REM TODO Is this a check if HFEXPERT\PROGRAMFILES even exists, or if the prior loop failed?
	IF ERRORLEVEL 0 (
		DIR /B/A-D "%%I" >NUL 2>&1 && (
			SET "DIRNAME=%%~I"
			SET "ENDPATH=!DIRNAME:%BASEDIR%=!"
			ECHO !ENDPATH!>>TEMP\PRGDIR.txt
		)
	)
)
SET "DIRNAME="
SET "ENDPATH="
SET "BASEDIR=%~dp0"
IF NOT EXIST TEMP\PRGDIR.txt IF NOT DEFINED PFROOT (GOTO :EOF)
SET "PFROOT="

IF NOT DEFINED SDFEXTRA (
	ECHO/>>%SOURCESS%\I386\TXTSETUP.sif
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif [SourceDisksFiles]
	IF EXIST %SOURCESS%\I386\DOSNET.inf (
		ECHO/>>%SOURCESS%\I386\DOSNET.inf
		ECHO>>%SOURCESS%\I386\DOSNET.inf [Files]
	)
)
ECHO>>%SOURCESS%\I386\TXTSETUP.sif HFSLIPPF.inf = 1,,,,,,,20,0,0
IF EXIST %SOURCESS%\I386\DOSNET.inf (ECHO>>%SOURCESS%\I386\DOSNET.inf d1,HFSLIPPF.inf)

SET /A "CFCOUNT=0"
IF EXIST TEMP\PRGDIR.txt (
	FOR /F "tokens=1 delims=" %%I IN (TEMP\PRGDIR.txt) DO (
		SET "PRGSUBVAR=%%I"
		SET /A "CFCOUNT+=1"
		ECHO>>TEMP\HFEPRGDDIR.txt CopyFiles!CFCOUNT!=16422,"!PRGSUBVAR!"
		ECHO/>>TEMP\HFEPRGCFIL.txt
		ECHO>>TEMP\HFEPRGCFIL.txt [CopyFiles!CFCOUNT!]
		FOR /F "delims=" %%K IN ('DIR /B/ON/A-D "HFEXPERT\PROGRAMFILES\!PRGSUBVAR!"') DO (
			ECHO Processing %%K ***** -6-
			ECHO>>TEMP\HFEPRGSDF.txt "!PRGSUBVAR!\%%K"=1
			ECHO>>TEMP\HFEPRGCFIL.txt "%%K","!PRGSUBVAR!\%%K"
			IF /I "%%~xK"==".cab" (
				MOVE /Y "HFEXPERT\PROGRAMFILES\!PRGSUBVAR!\%%K" "%SOURCESS%\I386\PFILES\!PRGSUBVAR!" >NUL
			) ELSE (
				MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX "HFEXPERT\PROGRAMFILES\!PRGSUBVAR!\%%K" "%%K" /L "%SOURCESS%\I386\PFILES\!PRGSUBVAR!" >NUL
			)
		)
	)
	SET "PRGSUBVAR="
)
REM Puts CopyFiles on one line - thanks to Yzöwl.
FOR /L %%I IN (1,1,%CFCOUNT%) DO (
	IF NOT DEFINED CFALL (
		SET "CFALL=CopyFiles%%I"
	) ELSE (
		SET "CFALL=!CFALL!, CopyFiles%%I"
	)
)
SET "CFCOUNT="

ECHO>%SOURCESS%\I386\HFSLIPPF.inf [Version]
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf Signature="$WINDOWS NT$"
ECHO/>>%SOURCESS%\I386\HFSLIPPF.inf
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf [Optional Components]
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf PFInstall
ECHO/>>%SOURCESS%\I386\HFSLIPPF.inf
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf [PFInstall]
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf CopyFiles = %CFALL%
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf OptionDesc = "Program Files Unattended"
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf Tip = "Program Files Unattended"
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf Modes = 0,1,2,3
ECHO/>>%SOURCESS%\I386\HFSLIPPF.inf
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf [DestinationDirs]
TYPE TEMP\HFEPRGDDIR.txt>>%SOURCESS%\I386\HFSLIPPF.inf
ECHO/>>%SOURCESS%\I386\HFSLIPPF.inf
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf [SourceDisksNames]
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf 1="PFILES DIR","%CDTAG%",,"\I386\PFILES"
ECHO/>>%SOURCESS%\I386\HFSLIPPF.inf
ECHO>>%SOURCESS%\I386\HFSLIPPF.inf [SourceDisksFiles]
TYPE TEMP\HFEPRGSDF.txt>>%SOURCESS%\I386\HFSLIPPF.inf
TYPE TEMP\HFEPRGCFIL.txt>>%SOURCESS%\I386\HFSLIPPF.inf
EXPAND -R %SOURCESS%\I386\SYSOC.in_ TEMP >NUL
IF DEFINED SYSOCUNI (
	CMD /U/C "ECHO>>TEMP\SYSOC.inf PFInstall=ocgen.dll,OcEntry,HFSLIPPF.inf,HIDE,7"
) ELSE (
	ECHO>>TEMP\SYSOC.inf PFInstall=ocgen.dll,OcEntry,HFSLIPPF.inf,HIDE,7
)
MAKECAB TEMP\SYSOC.inf /L %SOURCESS%\I386 >NUL
SET "CFALL="
CALL :CLEANTEMP
GOTO :EOF
REM ---------- ----------

REM ---------- HFEXPERT DRIVER.cab ----------
:HFEDRVCAB
TITLE %T1% - HFEXPERT - DRIVER.cab
ECHO/
ECHO Processing HFEXPERT DRIVER.cab
ECHO/

IF DEFINED SPXPASS (
	SET "DRVSRC=HFEXPERT\SPXCAB"
	SET "DRVDEST=WORK\SPXCAB"
) ELSE (
	SET "DRVSRC=HFEXPERT\DRIVERCAB"
	SET "DRVDEST=%SOURCESS%\I386\DRIVER"
)
ECHO/
ECHO Adding files from %DRVSRC%
FOR /F "delims=" %%I IN ('DIR /B/A-D-H-S/S "%DRVSRC%" ^| FINDSTR /C:"\\\." /V') DO (
	IF /I NOT "%%~xI"==".inf" (
		ECHO %%~nI%%~xI
		XCOPY /HY "%%I" %DRVDEST% >NUL
	) ELSE (
		XCOPY /HY "%%I" %SOURCESS%\I386 >NUL
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%~nI%%~xI = 1,,,,,,,20,0,0
		IF EXIST %SOURCESS%\I386\DOSNET.inf (ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%~nI%%~xI)
	)
)
SET "DRVSRC="
SET "DRVDEST="
TITLE %T1%
GOTO :EOF
REM ---------- ----------


REM ******************** Hotfixes - Application Addons ********************


REM ---------- Application Addons ----------
:HFAAO
TITLE %T1% - App Addons
ECHO/
ECHO Processing App Addons
ECHO/

FOR /F "delims=" %%I IN ('DIR /B HFAAO') DO (SET /A "AAOTBP=1")
IF NOT DEFINED AAOTBP GOTO :EOF
FOR /F "delims=" %%I IN ('DIR /B/A-D/ON HFAAO') DO (
	ECHO/
	ECHO Processing %%I
	HFTOOLS\7za.exe x "HFAAO\%%I" -o"%PREP%\TEMP\AAO" -r >NUL
	CALL :PROCESS_AAO
)
SET "AAOTBP="
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Application Addons - Processing ----------
:PROCESS_AAO
IF EXIST TEMP\AAO\RVMUp*.in* (SET /A "RVMUP=1")
DIR /B/A-D/S TEMP\AAO>TEMP\CHKCMP.txt
FOR /F "delims=" %%I IN ('FINDSTR /IER "_" TEMP\CHKCMP.txt') DO (
	EXPAND -R "%%I" >NUL
	DEL /Q/F "%%I"
)
IF EXIST TEMP\AAO\SVCPACK (
	XCOPY /DEHYQ TEMP\AAO\SVCPACK\* %SOURCESS%\I386\SVCPACK
	RD /Q/S TEMP\AAO\SVCPACK
)
IF EXIST TEMP\AAO\ASMS (
	IF NOT EXIST WORK\I386E\ASMS (MD WORK\I386E\ASMS)
	XCOPY /DEHYQ TEMP\AAO\ASMS WORK\I386E\ASMS
	RD /Q/S TEMP\AAO\ASMS
)
IF EXIST TEMP\AAO\LANG (
	IF NOT EXIST WORK\I386E\LANG (MD WORK\I386E\LANG)
	XCOPY /DEHYQ TEMP\AAO\LANG WORK\I386E\LANG
	RD /Q/S TEMP\AAO\LANG
)
IF EXIST TEMP\AAO\PRO (
	IF "%SUBTAG%"=="ip" (MOVE /Y TEMP\AAO\PRO\* TEMP\AAO >NUL)
	RD /Q/S TEMP\AAO\PRO
)
IF EXIST TEMP\AAO\HOME (
	IF "%SUBTAG%"=="ic" (MOVE /Y TEMP\AAO\HOME\* TEMP\AAO >NUL)
	RD /Q/S TEMP\AAO\HOME
)
IF NOT EXIST TEMP\AAO\ENTRIES_*.ini IF EXIST TEMP\AAO\ENTRIES*.ini (REN TEMP\AAO\ENTRIES*.ini ENTRIES_.ini)
FOR /F %%I IN ('DIR /B TEMP\AAO\ENTRIES_*.ini') DO (SET "AAOINI=%%I")
IF EXIST TEMP\AAO\LgtCkCtl.dll IF EXIST WORK\I386E\LegitCheckControl.dll (
	FINDSTR /VBIR "LgtCkCtl.dll ;" TEMP\AAO\%AAOINI%>TEMP\INI.ini
	DEL /Q/F TEMP\AAO\%AAOINI% TEMP\AAO\LgtCkCtl.dll
)
IF EXIST TEMP\AAO\%AAOINI% (
	FINDSTR /VBIR ";" TEMP\AAO\%AAOINI%>TEMP\INI.ini
	DEL /Q/F TEMP\AAO\%AAOINI%
)
ECHO/>>TEMP\INI.ini
FOR /F %%I IN ('FINDSTR /BIR "\[filenames" TEMP\INI.ini') DO (SET /A "AAOVAR=1")
IF DEFINED AAOVAR (
	SET "SSECTION=filenames"
	SET "AAODEST=TEMP\STRINGS1.txt"
	CALL :AAOCOPY
	FOR /F "tokens=1,2 delims==" %%I IN (TEMP\STRINGS1.txt) DO (ECHO>>TEMP\STRINGS.txt %%I = %%J)
	REM TODO What variables are we SETing?
	FOR /F "tokens=1,2,3" %%I IN (TEMP\STRINGS.txt) DO (SET "%%I=%%K")
	SET "AAOVAR="
)
FOR /F "delims=&" %%I IN (TEMP\INI.ini) DO (
	FOR /F "delims=" %%Z IN ('ECHO %%I') DO (ECHO>TEMP\TMPAAO.txt %%Z)
	FOR /F "delims=[]" %%Z IN ('FINDSTR /BR "\[" TEMP\TMPAAO.txt') DO (
		IF /I NOT "%%Z"=="general" (
			SET /A "AAOHEAD=1"
			ECHO>TEMP\NEWSECT.txt %%Z
		)
	)
	IF EXIST TEMP\NEWSECT.txt (
		FOR /F "delims=" %%Z IN (TEMP\NEWSECT.txt) DO (
			IF DEFINED AAOHEAD (
				SET "AAOHEAD="
			) ELSE (
				TYPE TEMP\TMPAAO.txt>>"TEMP\%%Z.txt"
			)
		)
	)
)

IF EXIST TEMP\GUIRunOnce.txt (
	SET "SSECTION=GUIRunOnce"
	SET "AAODEST=WORK\HFSLPGUI.txt"
	CALL :AAOCOPY
)
IF EXIST TEMP\sysoc.txt (
	IF DEFINED RVMUP (
		TYPE TEMP\sysoc.txt>>WORK\SYSOCTMP.txt
	) ELSE (
		TYPE TEMP\sysoc.txt>>WORK\SYSOCAAO.txt
	)
)
IF EXIST TEMP\txtsetup_dirs.txt (TYPE TEMP\txtsetup_dirs.txt>>WORK\TXTNTDIR.txt)
IF EXIST TEMP\txtsetup_fileflags.txt (TYPE TEMP\txtsetup_fileflags.txt>>WORK\TXTFFLAG.txt)
IF EXIST TEMP\txtsetup_files_pro.txt (
	IF "%SUBTAG%"=="ip" (
		TYPE TEMP\txtsetup_files_pro.txt>>TEMP\txtsetup_files.txt
	) ELSE (
		FOR /F "delims==" %%I IN (TEMP\txtsetup_files_pro.txt) DO (
			IF EXIST TEMP\AAO\%%I (DEL /Q/F TEMP\AAO\%%I)
		)
	)
)
IF EXIST TEMP\txtsetup_files_home.txt (
	IF "%SUBTAG%"=="ic" (
		TYPE TEMP\txtsetup_files_home.txt>>TEMP\txtsetup_files.txt
	) ELSE (
		FOR /F "delims==" %%I IN (TEMP\txtsetup_files_home.txt) DO (
			IF EXIST TEMP\AAO\%%I (DEL /Q/F TEMP\AAO\%%I)
		)
	)
)
IF EXIST TEMP\txtsetup_files.txt (
	IF NOT DEFINED RVMUP (
		FINDSTR /C:"100,,," TEMP\txtsetup_files.txt>TEMP\TXT100.txt
		FOR /F %%I IN (TEMP\TXT100.txt) DO (SET /A "AAO100=1")
	)
	IF NOT DEFINED AAO100 (
		TYPE TEMP\txtsetup_files.txt>>%SOURCESS%\I386\TXTSETUP.sif
	) ELSE (
		FOR /F "tokens=1,2 delims==" %%J IN (TEMP\TXT100.txt) DO (
			ECHO>TEMP\TXT100A.txt  %%K
			FOR /F "tokens=1* delims=100" %%Q IN (TEMP\TXT100A.txt) DO (ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%J= 1%%R)
		)
		SET "AAO100="
	)
)
IF EXIST %SOURCESS%\I386\DOSNET.inf (
	IF EXIST TEMP\dosnet_files.txt (TYPE TEMP\dosnet_files.txt>>%SOURCESS%\I386\DOSNET.inf)
	IF "%SUBTAG%"=="ip" IF EXIST TEMP\dosnet_files_pro.txt (TYPE TEMP\dosnet_files_pro.txt>>%SOURCESS%\I386\DOSNET.inf)
	IF "%SUBTAG%"=="ic" IF EXIST TEMP\dosnet_files_home.txt (TYPE TEMP\dosnet_files_home.txt>>%SOURCESS%\I386\DOSNET.inf)
)
IF EXIST TEMP\EditFile.txt (
	FOR /F "tokens=1,2,3 delims=," %%I IN (TEMP\EditFile.txt) DO (
		SET "AAOBASEFILE=%%I"
		SET "AAONEWSECT=%%J"
		SET "AAOFINDSECT=%%K"
		CALL :AAOEDITFILE
	)
)
IF EXIST TEMP\AAO\MSDMO.dll IF EXIST WORK\I386E\MSDMO.dll (DEL /Q/F TEMP\AAO\MSDMO.dll)
IF EXIST TEMP\AAO\QASF.dll IF EXIST WORK\I386E\QASF.dll (DEL /Q/F WORK\I386E\QASF.dll)
IF EXIST TEMP\AAO\*.cab (MOVE /Y TEMP\AAO\*.cab %SOURCESS%\I386)
XCOPY /DHY TEMP\AAO\*.* WORK\I386E
IF EXIST TEMP\FileMove.txt (
	CD %SOURCESS%\I386
	FOR /F "tokens=1,2 delims=," %%I IN (%PREP%\TEMP\FileMove.txt) DO (
		IF NOT EXIST "%%~dJ%%~pJ" (MD "%%~dJ%%~pJ")
		SET "AAOEXT=%%~xJ"
		ECHO>_AAOWILD.txt %%~nJ
		FOR /F %%I IN ('FINDSTR /R "\*" _AAOWILD.txt') DO (SET /A "AAOWILD=1")
		DEL /Q/F _AAOWILD.txt
		IF DEFINED AAOEXT (
			MOVE /Y %%I "%%~dJ%%~pJ%%~nJ%%~xJ"
			SET "AAOEXT="
		) ELSE (
			IF DEFINED AAOWILD (
				MOVE /Y %%I "%%~dJ%%~pJ" >NUL
				SET "AAOWILD="
			) ELSE (
				MOVE /Y %%I "%%~dJ%%~pJ%%~nJ"
			)
		)
	)
	CD %PREP%
)
IF EXIST TEMP\DirDelete.txt (
	FOR /F "delims=" %%I IN (TEMP\DirDelete.txt) DO (RD /Q/S %SOURCESS%\I386\%%I)
)
IF EXIST TEMP\STRINGS.txt (
	FOR /F %%I IN (TEMP\STRINGS.txt) DO (SET %%I=)
)
SET "RVMUP="
SET "AAOINI="
CALL :CLEANTEMP
GOTO :EOF
REM ---------- ----------

REM ---------- Application Addons - Processing - Copy ----------
:AAOCOPY
FOR /F "delims=" %%I IN (TEMP\INI.ini) DO (
	ECHO>TEMP\TMPAAO.txt %%I
	FOR /F "delims=" %%Z IN ('FINDSTR /BIR /C:"\[%SSECTION%\]" TEMP\TMPAAO.txt') DO (SET /A "WEROLL=1")
	IF DEFINED WEROLL (
		SET "WEROLL="
		FOR /F "delims=" %%Z IN ('FINDSTR /BR "\[" TEMP\TMPAAO.txt') DO (
			IF /I NOT "%%Z"=="[%SSECTION%]" (SET /A "WESTOP=1")
		)
		IF DEFINED WESTOP (
			SET "WESTOP="
			GOTO :EOF
		)
		IF /I NOT "%%I"=="[%SSECTION%]" (ECHO>>%AAODEST% %%I)
	)
)

GOTO :EOF
REM ---------- ----------

REM ---------- Application Addons - Processing - Edit File ----------
:AAOEDITFILE
IF /I "%AAOBASEFILE%"=="I386\SVCPACK.inf" (
	IF EXIST "TEMP\%AAOFINDSECT%.txt" (TYPE "TEMP\%AAOFINDSECT%.txt">>WORK\SVCMAIN.txt)
) ELSE (
	IF EXIST %SOURCESS%\%AAOBASEFILE% (
		FOR /F "delims=" %%I IN ('FINDSTR /BIR /C:"\[%AAONEWSECT%\]" %SOURCESS%\%AAOBASEFILE%') DO (SET /A "AAOSECTPRES=1")
		IF DEFINED AAOSECTPRES (
			SET "AAOSRCEDIT=%SOURCESS%\%AAOBASEFILE%"
			SET "AAOSECTPRES="
			CALL :AAOSTRIP
		)
		ECHO/>>%SOURCESS%\%AAOBASEFILE%
		ECHO>>%SOURCESS%\%AAOBASEFILE% [%AAONEWSECT%]
		IF EXIST TEMP\AAOEDITTEMP.txt (
			TYPE TEMP\AAOEDITTEMP.txt>>%SOURCESS%\%AAOBASEFILE%
			DEL /Q/F TEMP\AAOEDITTEMP.txt
		)
		IF EXIST "TEMP\%AAOFINDSECT%.txt" (TYPE "TEMP\%AAOFINDSECT%.txt">>%SOURCESS%\%AAOBASEFILE%)
	)
)
GOTO :EOF
REM ---------- ----------

REM ---------- Application Addons - Processing - Edit File - Strip ----------
:AAOSTRIP
FOR /F "delims=" %%I IN (%AAOSRCEDIT%) DO (
	ECHO>TEMP\TMPAAO.txt %%I
	IF NOT DEFINED WESTRIP (
		FOR /F "delims=" %%Z IN ('FINDSTR /BIR /C:"\[%AAONEWSECT%\]" TEMP\TMPAAO.txt') DO (SET /A "WESTRIP=1")
	)
	IF DEFINED WESTRIP (
		FOR /F "delims=" %%Z IN ('FINDSTR /BR "\[" TEMP\TMPAAO.txt') DO (
			IF /I NOT "%%Z"=="[%AAONEWSECT%]" (SET "WESTRIP=")
		)
	)
	FOR /F "delims=" %%Z IN ('FINDSTR /BR "\[" TEMP\TMPAAO.txt') DO (ECHO/>>TEMP\AAOEDITDEST.txt)
	IF NOT DEFINED WESTRIP (
		ECHO>>TEMP\AAOEDITDEST.txt %%I
	) ELSE (
		SET "WESTRIP="
		FOR /F "delims=" %%Z IN (TEMP\TMPAAO.txt) DO (
			IF /I NOT "%%Z"=="[%AAONEWSECT%]" (ECHO>>TEMP\AAOEDITTEMP.txt %%Z)
		)
	)
)
IF EXIST TEMP\AAOEDITDEST.txt (
	DEL /Q/F %SOURCESS%\%AAOBASEFILE%
	MOVE /Y TEMP\AAOEDITDEST.txt %SOURCESS%\%AAOBASEFILE%
)

GOTO :EOF
REM ---------- ----------


REM ******************** Post-Hotfixes Handling ********************


REM ---------- Post-Hotfix Handling ----------
:POSTHFX
TITLE %T1% - Post-Hotfix Binaries
ECHO/
ECHO Processing Post-Hotfix Binaries
ECHO/

FOR %%I IN (7 8 9) DO (
	IF EXIST WORK\I386E\wmpcore%%I.dll (DEL /Q/F WORK\I386E\wmpcore%%I.dll)
)
IF EXIST WORK\SVCPACK\EMPTY.cat (DEL /Q/F WORK\SVCPACK\EMPTY.cat)
IF EXIST WORK\SVCPACK\DUMMY.cat (DEL /Q/F WORK\SVCPACK\DUMMY.cat)
IF EXIST WORK\SVCPACK\*_ME.cat (DEL /Q/F WORK\SVCPACK\*_ME.cat)
IF EXIST WORK\I386E\W95INF*.dll (DEL /Q/F WORK\I386E\W95INF*.dll)
IF EXIST WORK\I386E\IECUSTOM.dll (DEL /Q/F WORK\I386E\IECUSTOM.dll)
IF EXIST WORK\I386E\*UNINSTALL.dll (DEL /Q/F WORK\I386E\*UNINSTALL.dll)
IF EXIST WORK\I386E\UPDCUSTOM.dll (DEL /Q/F WORK\I386E\UPDCUSTOM.dll)
IF EXIST WORK\I386E\EULA.txt (DEL /Q/F WORK\I386E\EULA.txt)
IF EXIST WORK\I386E\xpsp1hfm.exe (DEL /Q/F WORK\I386E\xpsp1hfm.exe)
IF EXIST WORK\I386E\spad0*.chm (DEL /Q/F WORK\I386E\spad0*.chm)
IF EXIST WORK\I386E\DAHOTFIX.* (DEL /Q/F WORK\I386E\DAHOTFIX.*)
IF EXIST WORK\I386E\DASETUP.* (DEL /Q/F WORK\I386E\DASETUP.*)
IF EXIST WORK\I386E\cstupd*.dll (DEL /Q/F WORK\I386E\cstupd*.dll)
IF EXIST WORK\I386E\fsdkreboot.exe (DEL /Q/F WORK\I386E\fsdkreboot.exe)
IF EXIST WORK\I386E\sprecovr.exe (DEL /Q/F WORK\I386E\sprecovr.exe)
IF EXIST WORK\I386E\*description.xml (DEL /Q/F WORK\I386E\*description.xml)
IF EXIST WORK\I386E\*_custom.dll (DEL /Q/F WORK\I386E\*_custom.dll)
IF EXIST WORK\I386E\kb*rg.inf (DEL /Q/F WORK\I386E\kb*rg.inf)
IF EXIST WORK\I386E\mrtstub.exe (DEL /Q/F WORK\I386E\mrtstub.exe)
IF EXIST WORK\I386E\dpcdll.dll (DEL /Q/F WORK\I386E\dpcdll.dll)
IF EXIST WORK\I386E\ipmntdpc.dll (DEL /Q/F WORK\I386E\ipmntdpc.dll)
IF EXIST WORK\I386E\ftpsvc2.dll (REN WORK\I386E\ftpsvc2.dll ftpsv251.dll)

IF "%VERSION%"=="2000" (
	CALL :POSTHANDLING_2K
) ELSE (
	IF EXIST WORK\I386E\tscupdc.dll IF NOT EXIST SOURCE\I386\lhmstsc.ex* (
		SET /A "TXTDIR05=1"
		SET /A "TXTDIR35=1"
		IF NOT DEFINED MUICD (
			FOR /F "tokens=2 delims==" %%I IN ('FINDSTR /BI "LH_TSC_LANGDIR" WORK\I386E\lhtsc.inf') DO (SET "MUICD=%%~I")
		)
		REM TODO Maybe evgnb's wscript code could work if reworked a bit... but is that worth it?
		REM *@*
		REM ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce","TSClientMSIUninstaller",,"wscript /B %%SYSTEMROOT%%\Installer\TSClientMsiTrans\tscuinst.vbs"
		REM ECHO>>WORK\RGSVRWU.txt rundll32.exe %%SYSTEMROOT%%\HFSLIP\tscupdc.dll,ProcessShortcuts %%SYSTEMROOT%%\system32\!MUICD!\mstsc.exe.mui
		ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce","TSClientMSIUninstaller",,"CMD /C ""cscript %%SYSTEMROOT%%\Installer\TSClientMsiTrans\tscuinst.vbs"""
		ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","TSCSH",0,"%%11%%\rundll32 %%10%%\HFSLIP\tscupdc.dll,ProcessShortcuts %%11%%\!MUICD!\mstsc.exe.mui"
		ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\lhmstsc.exe %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\mstsc.exe
		ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\mstsc.exe
		ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\lhmstsc.exe mstsc.exe
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif tscupdc.dll = 1,,,,,,,999,0,0
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif aaclient.mui = 1,,,,,,,1005,0,0,aaclient.dll.mui
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif lhmstsc.mui = 1,,,,,,,1005,0,0,mstsc.exe.mui
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif lhmstscx.mui = 1,,,,,,,1005,0,0,mstscax.dll.mui
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif tscinst.vbs = 1,,,,,,,1035,0,0
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif tscuinst.vbs = 1,,,,,,,1035,0,0
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif w2k3rd.mst = 1,,,,,,,1035,0,0
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif w2k3s1rd.mst = 1,,,,,,,1035,0,0
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wxprd.mst = 1,,,,,,,1035,0,0
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wxpsp1rd.mst = 1,,,,,,,1035,0,0
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif wxpsp2rd.mst = 1,,,,,,,1035,0,0
		
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,tscupdc.dll
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,aaclient.mui
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,lhmstsc.mui
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,lhmstscx.mui
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,tscinst.vbs
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,tscuinst.vbs
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,w2k3rd.mst
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,w2k3s1rd.mst
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wxprd.mst
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wxpsp1rd.mst
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,wxpsp2rd.mst
		REN WORK\I386E\lhmstscx.dll mstscax.dll
	)
	REM TODO What purpose does the presumably "external" variable NOREGMOF serve? What does not including polprocl.mof do?
	IF NOT "%NOREGMOF%"=="1" IF EXIST WORK\I386E\polprocl.mof (
		REM TODO Are these lines that were removed from 1.7.10K V9 (minus the last one) needed? For what?
		REM The "/x" flag seems to be for extra-logging. Was this code just for debugging, but never removed?
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {376B771D-8C14-4AFF-874B-677C3423F8F8} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {5A01A639-CF6C-441D-9EF3-B59C4375FF87} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {337240B1-42C2-4384-AAFF-D347A6D2CC5E} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {362C838B-54FF-4197-847B-8927FF1742EE} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {E606D790-404B-46F7-8DE6-C1FAE06CAC67} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {4583EB96-6167-4B87-8F0E-A12A128B3EB0} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {200B6216-5FA0-4DAA-BC41-500CE1ADCF97} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {B01ED954-EB4F-401F-9CDE-98895FE6F367} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {2765750D-7888-4D77-AD27-A71EC00AFF53} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd MSIEXEC /x {D787C24E-809D-4C48-BF53-EC5C76689A13} /quiet
		ECHO>>WORK\HFSLIPCMDP1.cmd %%SYSTEMROOT%%\system32\wbem\mofcomp.exe %%SYSTEMROOT%%\system32\wbem\polprocl.mof
	)
	IF "%VERSION%"=="XP" (
		CALL :POSTHANDLING_XP
	) ELSE (
		CALL :POSTHANDLING_2K3
	)
)
IF EXIST WORK\RENAME.cmd (CALL WORK\RENAME.cmd)
IF EXIST WORK\I386E\spuninst.exe (DEL /Q/F WORK\I386E\spuninst.exe)
IF EXIST WORK\I386E\spupdsvc.exe (DEL /Q/F WORK\I386E\spupdsvc.exe)
IF EXIST WORK\I386E\hscupd.cmd (
	MOVE WORK\I386E\hscupd.cmd WORK >NUL
	MOVE WORK\I386E\hscupd.cab %SOURCESS%\I386 >NUL
)
IF EXIST WORK\I386E\capicom*.msi (
	FOR /F %%I IN ('DIR /B WORK\I386E\capicom*.msi') DO (
		XCOPY /DY WORK\I386E\%%I HFSVCPACK_SW1 >NUL
		ECHO>>WORK\FILESTODEL.txt HFSVCPACK_SW1\%%I
		DEL /Q/F WORK\I386E\%%I
	)
)
IF EXIST WORK\I386E\msi3*.dll (
	IF NOT EXIST WORK\I386E\msi.dll (
		MOVE /Y WORK\I386E\msi3*.dll WORK\I386E\msi.dll >NUL
	) ELSE (
		XCOPY /DY WORK\I386E\msi3*.dll WORK\I386E\msi.dll >NUL
		DEL /Q/F WORK\I386E\msi3*.dll
	)
)
IF EXIST WORK\I386E\LegitCheckControl.dll (
	REN "WORK\I386E\LegitCheckControl.dll" LCC.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif LCC.dll = 1,,,,,,,2,0,0,LegitCheckControl.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,LCC.dll
)
IF EXIST WORK\I386E\OGACheckControl.dll (
	REN "WORK\I386E\OGACheckControl.dll" OGA.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif OGA.dll = 1,,,,,,,2,0,0,OGACheckControl.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,OGA.dll
)
IF EXIST WORK\I386E\MicrosoftUpdateCatalogWebControl.dll (
	REN "WORK\I386E\MicrosoftUpdateCatalogWebControl.dll" MUCtlgWC.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif MUCtlgWC.dll = 1,,,,,,,2,0,0,MicrosoftUpdateCatalogWebControl.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,MUCtlgWC.dll
)
IF EXIST WORK\I386E\mucltui.dll.mui_* (
	REN "WORK\I386E\mucltui.dll.mui_*" mucltui.mui
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mucltui.mui = 1,,,,,,,2,0,0,mucltui.dll.mui
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mucltui.mui
)

IF EXIST WORK\I386E\easycdblock.inf (
	SET /A "HFSLP+=1"
	REN "WORK\I386E\easycdblock.inf" ezcdblck.inf >NUL
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif ezcdblck.inf = 1,,,,,,,20,0,0,easycdblock.inf
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ezcdblck.inf
	REM *@*
	REM ECHO>>WORK\ROROEWU.txt rundll32.exe advpack.dll,LaunchINFSection %%SYSTEMROOT%%\INF\easycdblock.inf,EZCDBlockInstall
	ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZA","%HFSLP%",0,"RunDll32.exe %%11%%\AdvPack.Dll,LaunchINFSection %%17%%\easycdblock.inf,EZCDBlockInstall"
)
IF EXIST WORK\I386E\acadproc.dll (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif acadproc.dll = 1,,,,,,,60,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,acadproc.dll
)
IF EXIST WORK\I386E\bits*.exe IF EXIST WORK\I386E\qmgr.dll (
	COPY WORK\I386E\qmgr.dll WORK\I386E\qmgr2.dll >NUL
	SET /A "TXTDIR07=1"
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif qmgr2.dll = 1,,,,,,,1007,0,0,qmgr.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,qmgr2.dll
)
IF EXIST WORK\I386E\custsat.dll IF NOT EXIST SOURCE\I386\CUSTSAT.dl_ (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif custsat.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,custsat.dll
)
IF EXIST HFCABS\MUWEB*.cab (
	ECHO>>WORK\ADDLNK.txt setup.ini,progman.groups,,"SMRoot=""..\"""
	ECHO>>WORK\ADDLNK.txt setup.ini,SMRoot,,"""Microsoft Update"",""%%11%%\rundll32.exe %%11%%\muweb.dll,LaunchMUSite"",""%%11%%\muweb.dll"",0,,"%%11%%""
	IF EXIST HFCABS\MUAuth.cab (
		MAKECAB /D CompressionMemory=%COMPMEM% /D CompressionType=LZX HFCABS\MUAuth.cab /L %SOURCESS%\I386 >NUL
		ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Policies\Microsoft\Internet Explorer","Windows Update Menu Text",0,"Microsoft Update"
		ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services","DefaultService",0,"7971f918-a847-4430-9279-4a52d1efe18d"
		ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d","AuthorizationCab",0,"muauth.cab"
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif MUAuth.cab = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,MUAuth.cab
		ECHO>>WORK\HFSSDF.txt MUAuth.cab=1
		ECHO>>WORK\HFS_SOFTDIST.txt AuthCabs\7971f918-a847-4430-9279-4a52d1efe18d\MUAuth.cab,MUAuth.cab
	)
)
IF EXIST WORK\I386E\updroots.exe (
	IF EXIST WORK\I386E\authroots.sst (
		REN WORK\I386E\authroots.sst authroot.sst
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif authroot.sst = 1,,,,,,,999,0,0,authroots.sst
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,authroot.sst
		ECHO>>WORK\HFSLIPCMDP1.cmd %%SYSTEMROOT%%\HFSLIP\updroots.exe %%SYSTEMROOT%%\HFSLIP\authroots.sst
	)
	IF EXIST WORK\I386E\delroots.sst (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif delroots.sst = 1,,,,,,,999,0,0
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,delroots.sst
		ECHO>>WORK\HFSLIPCMDP1.cmd %%SYSTEMROOT%%\HFSLIP\updroots.exe -d %%SYSTEMROOT%%\HFSLIP\delroots.sst
	)
	IF EXIST WORK\I386E\roots.sst (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif roots.sst = 1,,,,,,,999,0,0
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,roots.sst
		ECHO>>WORK\HFSLIPCMDP1.cmd %%SYSTEMROOT%%\HFSLIP\updroots.exe -l %%SYSTEMROOT%%\HFSLIP\roots.sst
	)
	IF EXIST WORK\I386E\disallowedcert.sst (
		REN WORK\I386E\disallowedcert.sst rvkcert.sst
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif rvkcert.sst = 1,,,,,,,999,0,0
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,rvkcert.sst
		ECHO>>WORK\HFSLIPCMDP1.cmd %%SYSTEMROOT%%\HFSLIP\updroots.exe -l -u %%SYSTEMROOT%%\HFSLIP\rvkcert.sst
	)
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif updroots.exe = 1,,,,,,,999,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,updroots.exe
	IF EXIST WORK\I386E\updroots.sst (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif updroots.sst = 1,,,,,,,999,0,0
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,updroots.sst
		ECHO>>WORK\HFSLIPCMDP1.cmd %%SYSTEMROOT%%\HFSLIP\updroots.exe %%SYSTEMROOT%%\HFSLIP\updroots.sst
	)
)
REM BrowserChoice
IF EXIST WORK\I386E\browserchoice.exe (
	REN "WORK\I386E\browserchoice.exe" brchoice.exe
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif brchoice.exe = 1,,,,,,,2,0,0,browserchoice.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,brchoice.exe
)

REM KB2564958
IF EXIST WORK\I386E\uiautomationcore.dll (
	REN "WORK\I386E\uiautomationcore.dll" uiacore.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif uiacore.dll = 1,,,,,,,2,0,0,uiautomationcore.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,uiacore.dll
	ECHO>>WORK\NSFREGt.txt uiautomationcore.dll
)

REM ADDREG
ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\GdiDetectionTool","GDITool",0x10001,1
REM Be wary of the following kinds of variables - those with a single pair of double-quotes in the string.
SET "SFTACTX=HKLM,^"SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility"
IF DEFINED HFDEEP (CALL :POSTHANDLING_DEEP)
IF NOT DEFINED IE7EXE (
	IF NOT DEFINED _890046KILLBIT (ECHO>>WORK\HHIVADD.txt %SFTACTX%\{F5BE8BD2-7DE6-11D0-91FE-00C04FD701A5}","Compatibility Flags",0x10001,0x400)
) ELSE (
	REM MUWEB-MUCATWEB-OPUC-OFFICE11-OFFICE12
	ECHO>>WORK\HFREGWU.txt HKU,".DEFAULT\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{6E32070A-766D-4EE6-879C-DC1FA91D2FC3}\iexplore","Flags",0x10001,4
	ECHO>>WORK\HFREGWU.txt HKU,".DEFAULT\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{5AE58FCF-6F6A-49B2-B064-02492C66E3F4}\iexplore","Flags",0x10001,4
	ECHO>>WORK\HFREGWU.txt HKU,".DEFAULT\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{C7DB51B4-BCF7-4923-8874-7F1A0DC92277}\iexplore","Flags",0x10001,4
	ECHO>>WORK\HFREGWU.txt HKU,".DEFAULT\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{4453D895-F2A1-4A38-A285-1EF9BD3F6D5D}\iexplore","Flags",0x10001,4
	ECHO>>WORK\HFREGWU.txt HKU,".DEFAULT\Software\Microsoft\Windows\CurrentVersion\Ext\Stats\{C9712B19-838B-45A5-ABF2-9A315DDDED50}\iexplore","Flags",0x10001,4
)
IF /I NOT "%NoKillBits%"=="1" (
	ECHO>>WORK\HFREGWU.txt %SFTACTX%\{22FD7C0A-850C-4A53-9821-0B0915C96139}","Compatibility Flags",0x10001,0x400
	ECHO>>WORK\HFREGWU.txt %SFTACTX%\{314111B8-A502-11D2-BBCA-00C04F8EC294}","Compatibility Flags",0x10001,0x400
	ECHO>>WORK\HFREGWU.txt %SFTACTX%\{314111C6-A502-11D2-BBCA-00C04F8EC294}","Compatibility Flags",0x10001,0x400
	ECHO>>WORK\HFREGWU.txt %SFTACTX%\{5F810AFC-BB5F-4416-BE63-E01DD117BD6C}","Compatibility Flags",0x10001,0x400
	ECHO>>WORK\HFREGWU.txt %SFTACTX%\{3BEE4890-4FE9-4A37-8C1E-5E7E12791C1F}","Compatibility Flags",0x10001,0x400
	ECHO>>WORK\HFREGWU.txt %SFTACTX%\{40F23EB7-B397-4285-8F3C-AACE4FA40309}","Compatibility Flags",0x10001,0x400
	ECHO>>WORK\HFREGWU.txt %SFTACTX%\{47206204-5ECA-11D2-960F-00C04F8EE628}","Compatibility Flags",0x10001,0x400
	ECHO>>WORK\HFREGWU.txt %SFTACTX%\{0002E510-0000-0000-C000-000000000046}","Compatibility Flags",0x10001,0x400
)
REM New binaries.
FOR /F "tokens=1 delims==	 " %%I IN ('FINDSTR ",,," %SOURCESS%\I386\TXTSETUP.sif') DO (ECHO>>WORK\FULLSRC.txt %%I)
FINDSTR /BIR "[^=]*\." SOURCE\I386\DRVINDEX.inf>>WORK\DRV.txt
TYPE WORK\DRV.txt>>WORK\FULLSRC.txt
IF NOT "%VERSION%"=="2000" (
	ECHO>>WORK\FULLSRC.txt unattend.txt
	ECHO>>WORK\FULLSRC.txt usetup.exe
	ECHO>>WORK\FULLSRC.txt winnt32.exe
	ECHO>>WORK\FULLSRC.txt winnt32u.dll
	ECHO>>WORK\FULLSRC.txt winnt32.hlp
	ECHO>>WORK\FULLSRC.txt dosnet.inf
	ECHO>>WORK\FULLSRC.txt setupacc.txt
	ECHO>>WORK\FULLSRC.txt winnt32.msi
	ECHO>>WORK\FULLSRC.txt winnt32i.msi
	ECHO>>WORK\FULLSRC.txt bootfix.bin
	ECHO>>WORK\FULLSRC.txt setupldr.bin
	ECHO>>WORK\FULLSRC.txt winnt.exe
	ECHO>>WORK\FULLSRC.txt winnt32a.dll
	ECHO>>WORK\FULLSRC.txt hwcomp.dat
	ECHO>>WORK\FULLSRC.txt filelist.dat
	ECHO>>WORK\FULLSRC.txt setupldr.exe
	ECHO>>WORK\FULLSRC.txt startrom.com
	ECHO>>WORK\FULLSRC.txt startrom.n12
	ECHO>>WORK\FULLSRC.txt oschoice.exe
	ECHO>>WORK\FULLSRC.txt ristndrd.sif
	ECHO>>WORK\FULLSRC.txt rinorprt.sif
	ECHO>>WORK\FULLSRC.txt osc.cab
	ECHO>>WORK\FULLSRC.txt dbg.exe
	ECHO>>WORK\FULLSRC.txt mdmssys.inf
	ECHO>>WORK\FULLSRC.txt comsdupd.exe
	ECHO>>WORK\FULLSRC.txt faxpatch.exe
	ECHO>>WORK\FULLSRC.txt HWDB.dll
	ECHO>>WORK\FULLSRC.txt scripto.dll
	ECHO>>WORK\FULLSRC.txt RUNW32.BAT
	ECHO>>WORK\FULLSRC.txt SYSPARSE.exe
	ECHO>>WORK\FULLSRC.txt WINNTBBA.dll
	ECHO>>WORK\FULLSRC.txt WSDU.dll
	ECHO>>WORK\FULLSRC.txt WSDUENG.dll
	ECHO>>WORK\FULLSRC.txt tscupdc.dll
)
DIR /B/A-D WORK\I386E>WORK\NSFALL.txt
FINDSTR /VIB /G:WORK\FULLSRC.txt WORK\NSFALL.txt>WORK\NSFALLt.txt
FINDSTR /VIR "bitsinst\.exe ris\.vbs \.xml" WORK\NSFALLt.txt>WORK\NSFALL1.txt
FOR /F %%I IN (WORK\NSFALL1.txt) DO (ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I)
FOR /F %%I IN ('FINDSTR /VIER "\.sys \.inf \.adm \.chm \.chq \.ttc \.ttf \.htt \.hlp \.mfl \.mof" WORK\NSFALL1.txt') DO (ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,2,0,0)
FOR /F %%I IN ('FINDSTR /IER "\.sys" WORK\NSFALL1.txt') DO (ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,4,0,0)
FOR /F %%I IN ('FINDSTR /IER "\.inf \.adm" WORK\NSFALL1.txt') DO (ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,20,0,0)
FOR /F %%I IN ('FINDSTR /IER "\.chm \.chq \.hlp" WORK\NSFALL1.txt') DO (ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,21,0,0)
FOR /F %%I IN ('FINDSTR /IER "\.ttc \.ttf" WORK\NSFALL1.txt') DO (ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,22,0,0)
FOR /F %%I IN ('FINDSTR /IER "\.htt" WORK\NSFALL1.txt') DO (ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,31,0,0)
FOR /F %%I IN ('FINDSTR /IER "\.mfl \.mof" WORK\NSFALL1.txt') DO (ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,35,0,0)
IF EXIST WORK\NSFREGt.txt (FINDSTR /VIB /G:WORK\FULLSRC.txt WORK\NSFREGt.txt>WORK\NSFREGt1.txt)
FINDSTR /IR "\.ax \.acm \.ocx msxml.\.dll" WORK\NSFALL1.txt>>WORK\NSFREG0.txt
FOR /F %%I IN (WORK\NSFREG0.txt) DO (SET /A "NSFREG0=1")
IF NOT DEFINED NSFREG0 IF NOT EXIST WORK\NSFREGt1.txt (GOTO :EOF)
IF EXIST WORK\NSFREGt1.txt (
	IF NOT DEFINED NSFREG0 (
		TYPE WORK\NSFREGt1.txt>>WORK\NSFREG0.txt
	) ELSE (
		FINDSTR /VIB /G:WORK\NSFREG0.txt WORK\NSFREGt1.txt>WORK\NSFREGt2.txt
		TYPE WORK\NSFREGt2.txt>>WORK\NSFREG0.txt
		SET "NSFREG0="
	)
)
ECHO>>WORK\NSFREGNOT.txt asferror.dll
ECHO>>WORK\NSFREGNOT.txt wmpcd.dll
ECHO>>WORK\NSFREGNOT.txt wmpcore.dll
ECHO>>WORK\NSFREGNOT.txt wmploc.dll
ECHO>>WORK\NSFREGNOT.txt WdfApi.dll
ECHO>>WORK\NSFREGNOT.txt wmerror.dll
ECHO>>WORK\NSFREGNOT.txt msdmo.dll
ECHO>>WORK\NSFREGNOT.txt wmidx.dll
ECHO>>WORK\NSFREGNOT.txt wpdmtpdr.dll
ECHO>>WORK\NSFREGNOT.txt wpdtrace.dll
ECHO>>WORK\NSFREGNOT.txt wpd_ci.dll
ECHO>>WORK\NSFREGNOT.txt mcwmadrm.dll
ECHO>>WORK\NSFREGNOT.txt sncmaud.dll
ECHO>>WORK\NSFREGNOT.txt sncmsplt.dll
ECHO>>WORK\NSFREGNOT.txt wpdshextres.dll
ECHO>>WORK\NSFREGNOT.txt npdrmv2.dll
ECHO>>WORK\NSFREGNOT.txt WMPidGen.dll
ECHO>>WORK\NSFREGNOT.txt wmpns.dll
ECHO>>WORK\NSFREGNOT.txt mpvis.dll
ECHO>>WORK\NSFREGNOT.txt rsl.dll
ECHO>>WORK\NSFREGNOT.txt wmpband.dll
ECHO>>WORK\NSFREGNOT.txt msnp.ax
ECHO>>WORK\NSFREGNOT.txt WUDFCoinstaller.dll
ECHO>>WORK\NSFREGNOT.txt WudfPlatform.dll
ECHO>>WORK\NSFREGNOT.txt custsat.dll
ECHO>>WORK\NSFREGNOT.txt legitlibm.dll
ECHO>>WORK\NSFREGNOT.txt spmsg.dll
ECHO>>WORK\NSFREGNOT.txt msdelta.dll
ECHO>>WORK\NSFREGNOT.txt mfplat.dll
ECHO>>WORK\NSFREGNOT.txt wuauserv.dll
FINDSTR /VIB /G:WORK\NSFREGNOT.txt WORK\NSFREG0.txt>WORK\NSFREG.txt
FOR /F %%I IN (WORK\NSFREG.txt) DO (SET /A "NSFREG=1")
IF NOT DEFINED NSFREG (GOTO :EOF)
SET "NSFREG="
SET /A "HFSLP=200"
FOR /F %%I IN (WORK\NSFREG.txt) DO (
	REM *@*
	REM ECHO>>WORK\RGSVRWU.txt regsvr32.exe /s %%SYSTEMROOT%%\system32\%%I
	ECHO>>WORK\RGSVRWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZB","!HFSLP!",0,"%%11%%\regsvr32 /s """%%11%%\%%I""""
	SET /A "HFSLP+=1"
)
TITLE %T1%
GOTO :EOF
REM ---------- ----------

REM ---------- Post-Hotfix Handling - Windows 2000 ----------
:POSTHANDLING_2K
IF EXIST WORK\I386E\WMS (
	IF EXIST SOURCE\I386\WMS4.cab (
		ECHO/
		ECHO Updating WMS4.cab...
		MD WORK\WMS
		EXPAND SOURCE\I386\WMS4.cab -F:* WORK\WMS >NUL
		XCOPY /DY WORK\I386E\WMS WORK\WMS >NUL
		CALL :UNICAB1
		ECHO>>UC.ddf .Set CabinetNameTemplate=WMS4.cab
		ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\I386
		FOR /F %%I IN ('DIR /B/ON WORK\WMS') DO ECHO>>UC.ddf WORK\WMS\%%I
		CALL :UNICAB2
	)
	RD /Q/S WORK\I386E\WMS
)
IF EXIST HF\*891861*.exe IF EXIST WORK\I386E\nscm.exe (
	SET /A "TXTDIR01=1"
	SET /A "TXTDIR02=1"
	ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Updates\DataAccess\Q832483","ProductVersion",0,"2.53.6200.1"
	ECHO>>WORK\HHIVADD.txt HKLM,"SYSTEM\CurrentControlSet\Control\HAL","14140000FFFFFFFF",0x10001,16
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif nscm.exe = 1,,,,,,,1001,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif nsiislog.dll = 1,,,,,,,1001,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif nsisapi.exe = 1,,,,,,,1001,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif nspmon.exe = 1,,,,,,,1001,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif netmon.exe = 1,,,,,,,1002,0,0
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,nscm.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,nsiislog.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,nsisapi.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,nspmon.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,netmon.exe
	
	ECHO>>WORK\HFSLPGUI.txt %%WINDIR%%\system32\secedit.exe /configure /cfg %%WINDIR%%\inf\hfsecper.inf /db %%WINDIR%%\security\templates\hfsecper.sdb /log %%WINDIR%%\security\logs\hfsecper.log
	ECHO>>WORK\HFSLPGUI.txt %%WINDIR%%\system32\secedit.exe /configure /cfg %%WINDIR%%\inf\hfsecupd.inf /db %%WINDIR%%\security\templates\hfsecupd.sdb /log %%WINDIR%%\security\logs\hfsecupd.log
)
IF EXIST WORK\I386E\dw15.exe (
	ECHO>>WORK\HFSSDF.txt dw15.exe=1
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif dw15.exe = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,dw15.exe
)
IF DEFINED DWINTLREN (
	IF %SP% LSS 5 IF "%VERSIONIE%"=="2KIE6" IF NOT EXIST HFCLEANUP\ZZ_TommyP_IEGARBAGE.* (
		COPY WORK\I386E\dwintl.dll WORK\I386E\dwil%LCIDD%.dll >NUL
		ECHO>>WORK\HFSSDF.txt dwil%LCIDD%.dll=1
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif dwil%LCIDD%.dll = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,dwil%LCIDD%.dll
	)
	IF DEFINED WMLNG IF NOT EXIST WORK\I386E\dwil!WMLNG!.dll (
		COPY WORK\I386E\dwintl.dll WORK\I386E\dwil!WMLNG!.dll >NUL
		ECHO>>WORK\HFSSDF.txt dwil!WMLNG!.dll=1
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif dwil!WMLNG!.dll = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,dwil!WMLNG!.dll
	)
	IF NOT "%LCIDD%"=="1031" (DEL /Q/F WORK\I386E\dwintl.dll)
)
IF EXIST WORK\I386E\rdpwd.sys IF NOT DEFINED SERVER (DEL /Q/F WORK\I386E\rdpwd.sys)
IF "%VERSIONIE%"=="2KIE6" IF EXIST WORK\I386E\danim.dll (
	REN WORK\I386E\danim.dll danim2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\danim.dll ^(DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\danim.dll^)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\danim2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\danim.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\danim.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\danim2.dll danim.dll
)
IF NOT "%LNG%"=="ENU" IF EXIST WORK\I386E\webvw.dll (
	REN WORK\I386E\webvw.dll webvw2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\WEBVW.dll ^(DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\webvw.dll^)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\webvw2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\webvw.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\webvw.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\webvw2.dll webvw.dll
)
IF NOT "%V3%"=="Server" (
	REM Rollup files for ADV and DTC only; exclude PRO and SVR.
	IF EXIST WORK\I386E\cluscfg.exe DEL /Q/F WORK\I386E\cluscfg.exe
	IF EXIST WORK\I386E\clussvc.exe DEL /Q/F WORK\I386E\clussvc.exe
	IF EXIST WORK\I386E\cluster.inf DEL /Q/F WORK\I386E\cluster.inf
	IF EXIST WORK\I386E\mqclus.dll DEL /Q/F WORK\I386E\mqclus.dll
)
IF EXIST WORK\I386E\nntp* (
	REM Rollup files for Servers only; exclude PRO.
	IF NOT DEFINED SERVER (
		DEL /Q/F WORK\I386E\nntp*
	) ELSE (
		ECHO/
		ECHO Updating INS.cab...
		MD WORK\SVRINS
		EXPAND SOURCE\I386\INS.cab -F:* WORK\SVRINS >NUL
		FOR /F %%I IN ('DIR /B WORK\I386E\nntp*') DO (REN WORK\I386E\%%I "nntp_%%I")
		FOR /F %%I IN ('DIR /B WORK\I386E\nntp_*') DO (XCOPY /DYQ WORK\I386E\%%I WORK\SVRINS >NUL)
		CALL :UNICAB1
		ECHO>>UC.ddf .Set CabinetNameTemplate=INS.cab
		ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\I386
		FOR /F %%I IN ('DIR /B/ON WORK\SVRINS') DO (ECHO>>UC.ddf WORK\SVRINS\%%I)
		CALL :UNICAB2
		DEL /Q/F WORK\I386E\nntp_*
	)
)
IF EXIST WORK\SVCPACK\*911280* IF EXIST SOURCE\SUPPORT\TOOLS\SUPPORT.cab (
	MD WORK\SUPPCABNEW
	MOVE /Y WORK\I386E\netdiag.exe WORK\SUPPCABNEW
)
GOTO :EOF
REM ---------- ----------

REM ---------- Post-Hotfix Handling - Windows XP ----------
:POSTHANDLING_XP
IF NOT DEFINED NOBTHPORTFIX IF EXIST WORK\I386E\bthport.sys (
	ECHO>>WORK\HFSLIPCMDP1.cmd IF NOT EXIST %%SYSTEMROOT%%\system32\drivers\bthport.sys IF EXIST "%%HFSLIP%%bthport.sy_" ^(
	ECHO>>WORK\HFSLIPCMDP1.cmd 	EXPAND -R "%%HFSLIP%%bthport.sy_" %%SYSTEMROOT%%\system32\drivers
	ECHO>>WORK\HFSLIPCMDP1.cmd ^)
)
IF NOT %OSLEVEL% EQU 23 (
	IF EXIST WORK\I386E\lhmstsc.chm (REN WORK\I386E\lhmstsc.chm mstsc.chm)
	IF EXIST WORK\I386E\lhrdesk.chm (REN WORK\I386E\lhrdesk.chm rdsktpw.chm)
)
IF %SP% GEQ 3 (SET /A "_890046KILLBIT=1")
IF %SP% GEQ 2 (
	IF EXIST HFCABS\Legit*.cab (ECHO>>WORK\HFREGWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Ext\CLSID","{17492023-C23A-453E-A040-C7C580BBF700}",,"1")
) ELSE (
	IF EXIST HF\*833987*.exe (ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Updates\Windows XP\SP2\KB833987","Type",0,"Update")
	ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\ProtocolDefaults","shell",0x10001,0
	IF EXIST WORK\I386E\bitsinst.exe (
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif bitsinst.exe = 1,,,,,,,2,0,0
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,bitsinst.exe
		REM @;
		ECHO>>WORK\ROROEWU.txt ;BITS
		REM *@*
		REM 2020-08-07: bugfix - invalid section use in modern ROROEWU.txt with BITS - AddReg instead RegisterDlls
		REM ECHO>>WORK\ROROEWU.txt bitsinst.exe /setbackupfilter
		ECHO>>WORK\ROROEWU.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx\ZZZxpsp1","bitsupdate",0,"CMD /C """%%SYSTEMROOT%%\SYSTEM32\bitsinst.exe /setbackupfilter""""
	)
	IF EXIST WORK\I386E\sql*20.dll (
		ECHO>>WORK\TXTNTDIR.txt 181 = PeerNet
		FOR /F %%I IN ('DIR /B WORK\I386E\sql*20.dll') DO (
			ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I = 1,,,,,,,181,0,0
			ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I
		)
	)
)
IF EXIST WORK\SVCPACK\*896344* (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif archvapp.inf = 1,,,,,,,111,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif cobramsg.dll = 1,,,,,,,111,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif guitrna.dll = 1,,,,,,,111,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif migisma.dll = 1,,,,,,,111,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif migwiza.exe = 1,,,,,,,111,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif scripta.dll = 1,,,,,,,111,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif sysmoda.dll = 1,,,,,,,111,0,0
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,archvapp.inf
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,cobramsg.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,guitrna.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,migisma.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,migwiza.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,scripta.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,sysmoda.dll
)
IF DEFINED TXTDIR00 (
	COPY WORK\I386E\spmsg.dll WORK\I386E\spmsg.ref >NUL
	REN WORK\I386E\spuninst.exe spuninst.ref
	REN WORK\I386E\spupdsvc.exe spupdsvc.ref
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif spcustom.ref = 1,,,,,,,1000,0,0,spcustom.dll.ref
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif spmsg.ref = 1,,,,,,,1000,0,0,spmsg.dll.ref
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif spuninst.ref = 1,,,,,,,1000,0,0,spuninst.exe.ref
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif spupdsvc.ref = 1,,,,,,,1000,0,0,spupdsvc.exe.ref
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif update.ref = 1,,,,,,,1000,0,0,update.exe.ref
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif updspapi.ref = 1,,,,,,,1000,0,0,updspapi.dll.ref
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,spcustom.ref
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,spmsg.ref
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,spuninst.ref
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,spupdsvc.ref
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,update.ref
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,updspapi.ref
)
IF DEFINED TXTDIR06 (
	REN WORK\I386E\plutilsmanaged.dll plutmngd.dll
	REN WORK\I386E\plcertmgrmanaged.dll plcmmngd.dll
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif plutmngd.dll = 1,,,,,,,2,0,0,plutilsmanaged.dll
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif plcmmngd.dll = 1,,,,,,,2,0,0,plcertmgrmanaged.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,plutmngd.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,plcmmngd.dll
	
	FOR /F "tokens=1 delims=." %%I IN ('DIR /B WORK\I386E\pl*.resources.dll') DO (
		REN WORK\I386E\%%I.resources.dll %%I.res
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif %%I.res = 1,,,,,,,1006,0,0,%%I.resources.dll
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,%%I.res
	)
)
IF EXIST WORK\I386E\xpnetdg.exe (
	SET /A "TXTDIR30=1"
	SET /A "CUSTSATSDF=1"
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif xpnetdg.exe = 1,,,,,,,1030,0,0,xpnetdiag.exe
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif xpnetdg.xsl = 1,,,,,,,1030,0,0,xpnetdiag.xsl
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,xpnetdg.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,xpnetdg.xsl
	
	ECHO>>WORK\HFSDST.txt NDIAG=10,"Network Diagnostic"
	ECHO>>WORK\HFS_NDIAG.txt custsat.dll
)
IF EXIST WORK\I386E\msmsgs.exe (
	ECHO/
	ECHO Updating MMSSETUP.cab with newer msmsgs.exe binary...
	MD WORK\MMSSETUP
	EXPAND SOURCE\I386\MMSSETUP.cab -F:* WORK\MMSSETUP >NUL
	XCOPY /DYQ WORK\I386E\msmsgs.exe WORK\MMSSETUP >NUL
	CALL :UNICAB1
	ECHO>>UC.ddf .Set CabinetNameTemplate=MMSSETUP.cab
	ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\I386
	FOR /F %%I IN ('DIR /B/ON WORK\MMSSETUP') DO (ECHO>>UC.ddf WORK\MMSSETUP\%%I)
	CALL :UNICAB2
	DEL /Q/F WORK\I386E\msmsgs.exe
)
IF EXIST WORK\IE7DLL.txt (
	REN "WORK\I386E\jsprofilerui.dll" jsprflui.dll
	REN "WORK\I386E\msfeedsbs.dll" msfeedsb.dll
	REN "WORK\I386E\msfeedssync.exe" msfeedss.exe
	REN "WORK\I386E\WinFXDocObj.exe" winfxdoc.exe
	REN "WORK\I386E\msfeedsbs.mof" msfeedsb.mof
	REN "WORK\I386E\inetcpl.cpl.mui" inetcpl.mui
	REN "WORK\I386E\html.iec.mui" htmliec.mui
	REN "WORK\I386E\msfeedsbs.dll.mui" msfeedsb.mui
	REN "WORK\I386E\WinFXDocObj.exe.mui" winfxdoc.mui
	
	FOR /F %%I IN (WORK\IE7DLL.txt) DO (ECHO>>WORK\RENAME.cmd REN "WORK\I386E\%%I.dll.MUI" %%I.mui)
	FOR /F %%I IN (WORK\IE7EXE.txt) DO (ECHO>>WORK\RENAME.cmd REN "WORK\I386E\%%I.exe.MUI" %%I.mui)
	
	REN WORK\I386E\iesetup.dll iesetup2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\iesetup.dll (DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\iesetup.dll)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\iesetup2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\iesetup.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\iesetup.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\iesetup2.dll iesetup.dll
	REN WORK\I386E\mshtml.dll mshtml2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\mshtml.dll (DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\mshtml.dll)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\mshtml2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\mshtml.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\mshtml.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\mshtml2.dll mshtml.dll
	REN WORK\I386E\msrating.dll msratng2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\msrating.dll (DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\msrating.dll)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\msratng2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\msrating.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\msrating.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\msratng2.dll msrating.dll
	REN WORK\I386E\inseng.dll inseng2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\inseng.dll (DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\inseng.dll)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\inseng2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\inseng.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\inseng.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\inseng2.dll inseng.dll
	REN WORK\I386E\webcheck.dll webchck2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\webcheck.dll (DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\webcheck.dll)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\webchck2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\webcheck.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\webcheck.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\webchck2.dll webcheck.dll
	REN WORK\I386E\imgutil.dll imgutil2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\imgutil.dll (DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\imgutil.dll)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\imgutil2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\imgutil.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\imgutil.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\imgutil2.dll imgutil.dll
	REN WORK\I386E\inetcpl.cpl inetcpl2.cpl
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\inetcpl.cpl (DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\inetcpl.cpl)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\inetcpl2.cpl %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\inetcpl.cpl
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\inetcpl.cpl
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\inetcpl2.cpl inetcpl.cpl
	REN WORK\I386E\pngfilt.dll pngfilt2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd IF EXIST %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\pngfilt.dll (DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\pngfilt.dll)
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\SYSTEM32\pngfilt2.dll %%SYSTEMROOT%%\SYSTEM32\DLLCACHE\pngfilt.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\SYSTEM32\pngfilt.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\SYSTEM32\pngfilt2.dll pngfilt.dll
)
IF DEFINED IE8EXE (
	REM Part of rhadamants slipstream.
	REN WORK\I386E\dxtmsft.dll dxtmsft2.dll
	REN WORK\I386E\dxtrans.dll dxtrans2.dll
	REN WORK\I386E\mshtmled.dll mshtmld2.dll
	REN WORK\I386E\mstime.dll mstime2.dll
	
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\system32\dxtmsft2.dll %%SYSTEMROOT%%\system32\dllcache\dxtmsft.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\system32\dxtmsft.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\system32\dxtmsft2.dll dxtmsft.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\system32\dxtrans2.dll %%SYSTEMROOT%%\system32\dllcache\dxtrans.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\system32\dxtrans.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\system32\dxtrans2.dll dxtrans.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\system32\mshtmld2.dll %%SYSTEMROOT%%\system32\dllcache\mshtmled.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\system32\mshtmled.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\system32\mshtmld2.dll mshtmled.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\system32\mstime2.dll %%SYSTEMROOT%%\system32\dllcache\mstime.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\system32\mstime.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\system32\mstime2.dll mstime.dll
	REN WORK\I386E\iepeers.dll iepeers2.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\system32\iepeers2.dll %%SYSTEMROOT%%\system32\dllcache\iepeers.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd DEL /Q/F %%SYSTEMROOT%%\system32\iepeers.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\system32\iepeers2.dll iepeers.dll
	REM Problem with wininet.dll in IE7 for Server 2003 and in IE8 - Replace at T-13.
	REN WORK\I386E\wininet.dll wininet3.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd COPY /Y %%SYSTEMROOT%%\system32\wininet3.dll %%SYSTEMROOT%%\system32\dllcache\wininet.dll
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\system32\wininet.dll wininet.old
	ECHO>>WORK\HFSLIPCMDP1.cmd REN %%SYSTEMROOT%%\system32\wininet3.dll wininet.dll
	
	REM Delaying replacement of wininet.dll requires delaying replacement of iertutil.dll and urlmon.dll - Replace from SYSOC.inf.
	REN WORK\I386E\urlmon.dll urlmon3.dll
	ECHO>>WORK\HFS_SYS32.txt iertutil.dll
	ECHO>>WORK\HFS_SYS32.txt urlmon.dll,urlmon3.dll
	ECHO>>WORK\HFSSDF.txt iertutil.dll=1
	ECHO>>WORK\HFSSDF.txt urlmon3.dll=1
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif iertutil.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif urlmon3.dll = 1,,,,,,,,3,3
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,iertutil.dll
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,urlmon3.dll
)
IF NOT DEFINED IE8EXE (
	IF EXIST WORK\I386E\jsprofilerui.dll (REN "WORK\I386E\jsprofilerui.dll" jsprflui.dll)
	IF EXIST WORK\I386E\msfeedsbs.dll (REN "WORK\I386E\msfeedsbs.dll" msfeedsb.dll)
)

IF DEFINED XPNETFX IF EXIST HF\NDP1.0sp3*.exe (
	SET /A "TXTDIR36=1"
	REN WORK\I386E\netfxupdate.exe netfxupd.exe
	
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif gacutil.exe = 1,,,,,,,1036,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif netfxupd.exe = 1,,,,,,,1036,0,0,netfxupdate.exe
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif SetRegNI.exe = 1,,,,,,,1036,0,0
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif ToGac.exe = 1,,,,,,,1036,0,0
	
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,gacutil.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,netfxupd.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,SetRegNI.exe
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ToGac.exe
	
	FOR /F %%I IN ('DIR /B WORK\MCE\NETFX10') DO (
		IF EXIST WORK\I386E\%%I (
			XCOPY /DY WORK\I386E\%%I WORK\MCE\NETFX10 >NUL
			DEL /Q/F WORK\I386E\%%I
			SET /A "NETFX10=1"
		)
	)
	IF DEFINED NETFX10 (
		ECHO/
		ECHO Updating NETFX.cab...
		CALL :UNICAB1
		ECHO>>UC.ddf .Set CabinetNameTemplate=NETFX.cab
		ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\CMPNENTS\NETFX\I386
		FOR /F %%I IN ('DIR /B/ON WORK\MCE\NETFX10') DO (ECHO>>UC.ddf WORK\MCE\NETFX10\%%I)
		CALL :UNICAB2
		SET "NETFX10="
	)
)
GOTO :EOF
REM ---------- ----------

REM ---------- Post-Hotfix Handling - Windows Server 2003 ----------
:POSTHANDLING_2K3
IF EXIST SOURCE\I386\NETFX.cab (
	ECHO/
	ECHO Processing NETFX.cab...
	MD WORK\NETFX11
	EXPAND SOURCE\I386\NETFX.cab -F:* WORK\NETFX11 >NUL
	FOR /F %%I IN ('DIR /B WORK\NETFX11') DO (
		IF EXIST WORK\I386E\%%I (
			XCOPY /DY WORK\I386E\%%I WORK\NETFX11 >NUL
			DEL /Q/F WORK\I386E\%%I
			SET /A "NETFX11=1"
		)
	)
	IF DEFINED NETFX11 (
		CALL :UNICAB1
		ECHO>>UC.ddf .Set CabinetNameTemplate=NETFX.cab
		ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\I386
		FOR /F %%I IN ('DIR /B/ON WORK\NETFX11') DO (ECHO>>UC.ddf WORK\NETFX11\%%I)
		CALL :UNICAB2
		SET "NETFX11="
	)
)
IF EXIST SOURCE\I386\WMS.cab (
	ECHO/
	ECHO Processing WMS.cab...
	MD WORK\WMS
	EXPAND SOURCE\I386\WMS.cab -F:* WORK\WMS >NUL
	FOR /F %%I IN ('DIR /B WORK\WMS') DO (
		IF EXIST WORK\I386E\%%I (
			XCOPY /DY WORK\I386E\%%I WORK\WMS >NUL
			DEL /Q/F WORK\I386E\%%I
			SET /A "WMSNEW=1"
		)
	)
	IF DEFINED WMSNEW (
		CALL :UNICAB1
		ECHO>>UC.ddf .Set CabinetNameTemplate=WMS.cab
		ECHO>>UC.ddf .Set DiskDirectory1=%SOURCESS%\I386
		FOR /F %%I IN ('DIR /B/ON WORK\WMS') DO (ECHO>>UC.ddf WORK\WMS\%%I)
		CALL :UNICAB2
		SET "WMSNEW="
	)
)
IF EXIST WORK\I386E\lhmstsc.chm (REN WORK\I386E\lhmstsc.chm mstscs.chm)
IF EXIST WORK\I386E\lhrdesks.chm (REN WORK\I386E\lhrdesks.chm rdsktps.chm)
IF EXIST WORK\I386E\w03a3409.dll IF NOT EXIST SOURCE\I386\w03a3409.dl_ (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif w03a3409.dll = 1,,,,,,,2,0,0,,1,2
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,w03a3409.dll
)
IF EXIST WORK\I386E\w03a2409.dll IF NOT EXIST SOURCE\I386\w03a2409.dl_ (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif w03a2409.dll = 1,,,,,,,2,0,0,,1,2
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,w03a2409.dll
)
IF EXIST WORK\I386E\ws03res.dll IF NOT EXIST SOURCE\I386\ws03res.dl_ (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif ws03res.dll = 1,,,,,,,2,0,0,,1,2
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,ws03res.dll
)
IF DEFINED TXTDIR08 IF EXIST WORK\I386E\mscorees.dll (
	ECHO>>%SOURCESS%\I386\TXTSETUP.sif mscorees.dll = 1,,,,,,,1008,0,0
	ECHO>>%SOURCESS%\I386\DOSNET.inf d1,mscorees.dll
)
IF %SP% GEQ 2 (
	SET /A "_890046KILLBIT=1"
) ELSE (
	IF EXIST WORK\SVCPACK\*908981* (
		ECHO>>WORK\HFSDST.txt PFILES4=65620,"microsoft shared\web server extensions\50\bin"
		ECHO>>WORK\HFSDST.txt PFILES5=65620,"microsoft shared\web server extensions\50\isapi"
		
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif cfgwiz.exe = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif fp5avss.dll = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif fpexedll.dll = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif owsrmadm.exe = 1,,,,,,,,3,3
		ECHO>>%SOURCESS%\I386\TXTSETUP.sif fpcount.exe = 1,,,,,,,,3,3
		
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,cfgwiz.exe
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,fp5avss.dll
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,fpexedll.dll
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,owsrmadm.exe
		ECHO>>%SOURCESS%\I386\DOSNET.inf d1,fpcount.exe
		
		ECHO>>WORK\HFSSDF.txt cfgwiz.exe=1
		ECHO>>WORK\HFSSDF.txt fp5avss.dll=1
		ECHO>>WORK\HFSSDF.txt fpexedll.dll=1
		ECHO>>WORK\HFSSDF.txt owsrmadm.exe=1
		ECHO>>WORK\HFSSDF.txt fpcount.exe=1
		
		ECHO>>WORK\HFSPF4.txt cfgwiz.exe
		ECHO>>WORK\HFSPF4.txt fp5avss.dll
		ECHO>>WORK\HFSPF4.txt fpexedll.dll
		ECHO>>WORK\HFSPF4.txt owsrmadm.exe
		
		ECHO>>WORK\HFSPF5.txt fpcount.exe
	)
	IF %SP% EQU 1 IF NOT "%SUBTAG%"=="is" IF NOT "%SUBTAG%"=="ib" (ECHO>>WORK\HHIVADD.txt HKLM,"SYSTEM\CurrentControlSet\Services\EventLog\System\Clussvc","EventMessageFile",0x20008,";%%SYSTEMROOT%%\system32\ws03res.dll;%%SYSTEMROOT%%\system32\w03a2409.dll")
)
ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\microsoft.com\update","http",0x10001,2
ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\windowsupdate.com\download","http",0x10001,2

GOTO :EOF
REM ---------- ----------

REM ---------- Post-Hotfix Handling - "Deep" ----------
:POSTHANDLING_DEEP
IF NOT "%VERSION%"=="2003" (
	IF EXIST WORK\I386E\msxml3.dll (
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f22-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f1b-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f1c-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f1d-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f1e-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f21-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f1f-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f20-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f28-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f29-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
		ECHO>>WORK\HHIVADD.txt %SFTACTX%\{f5078f26-c551-11d3-89b9-0000f81fe221}","Compatibility Flags",0x10001,0x400
	)
	IF EXIST WORK\I386E\shell32.dll (
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Cached","{1cdb2949-8f65-4355-8456-263e7c208a5d} {000214e6-0000-0000-c000-000000000046}",0x10003,0x1
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Cached","{1e9b04fb-f9e5-4718-997b-b8da88302a47} {000214e8-0000-0000-c000-000000000046}",0x10003,0x1
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Cached","{1e9b04fb-f9e5-4718-997b-b8da88302a48} {000214e8-0000-0000-c000-000000000046}",0x10003,0x1
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Cached","{750FDF0E-2A26-11D1-A3EA-080036587F03} {000214E8-0000-0000-C000-000000000046}",0x10003,0x1
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Cached","{A4DF5659-0801-4A60-9607-1C48695EFDA9} {000214E6-0000-0000-C000-000000000046}",0x10003,0x1
	)
)
IF "%VERSION%"=="2000" (
	ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon","BufferPolicyReads",0x10001,1
	IF DEFINED SERVER IF EXIST WORK\I386E\ntdsa.dll (ECHO>>WORK\HHIVADD.txt HKLM,"SYSTEM\CurrentControlSet\Services\EventLog\Directory Service\NTDS SDPROP","EventMessageFile",0x20020,"%%SYSTEMROOT%%\system32\ntdsmsg.dll;%%SYSTEMROOT%%\system32\sp3res.dll")
	IF EXIST WORK\I386E\kerberos.dll (ECHO>>WORK\HHIVADD.txt HKLM,"SYSTEM\CurrentControlSet\Services\EventLog\System\Kerberos","EventMessageFile",0x20000,"%%SYSTEMROOT%%\system32\kerberos.dll;%%SYSTEMROOT%%\system32\sp3res.dll")
	IF EXIST WORK\I386E\localspl.dll (ECHO>>WORK\HHIVADD.txt HKLM,"SYSTEM\CurrentControlSet\Services\Eventlog\System\Print","EventMessageFile",0x20000,"%%SYSTEMROOT%%\system32\localspl.dll;%%SYSTEMROOT%%\system32\sp3res.dll")
	IF EXIST WORK\I386E\ipsec.sys (ECHO>>WORK\HHIVADD.txt HKLM,"SYSTEM\CurrentControlSet\Services\IPSec","NoDefaultExempt",0x10003,1)
) ELSE IF "%VERSION%"=="XP" (
	IF EXIST WORK\I386E\p2p*.dll (
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\PeerNet\PNRP",,0x10
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\PeerNet\PNRP\IPV6-Global",,0x10
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\PeerNet\PNRP\IPV6-Global\Global_",,0x10
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\PeerNet\PNRP\IPV6-Global","SeedServer",0x0,"pnrpv2.ipv6.microsoft.com;pnrpv21.ipv6.microsoft.com"
		ECHO>>WORK\HHIVADD.txt HKLM,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\PeerNet\PNRP\IPV6-Global\Global_","SeedServer",0x0,"pnrpv2.ipv6.microsoft.com;pnrpv21.ipv6.microsoft.com"
	)
	IF EXIST WORK\I386E\usb*.sys (
		ECHO>>WORK\HHIVADD.txt HKLM,"SYSTEM\CurrentControlSet\Services\usb","EnIdleEndPointSupportEx",0x10001,0x1
		ECHO>>WORK\HHIVADD.txt HKLM,"SYSTEM\CurrentControlSet\Services\usb","EnableIdleTimer",0x10001,0x1
	)
)
GOTO :EOF
REM ---------- ----------


REM ******************** evgnb Patches ********************


REM This subroutine patch SFC.dll (Win2000 with SP2+) or SFC_OS.dll (WinXP)
REM to disable WFP if HKLM/SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SFCSetting=0xFFFFFF9D
REM and SfcDisable -> SFCSetting after this patch
REM PatchPAE3 Version: 0.0.0.48 beta-5+
REM ---------- SCP/WFP-Disabling Patch ----------
:SFCWFPDRM
TITLE %T1% - SFC/WFP
ECHO/
ECHO Processing SFC/WFP Patch
ECHO/

IF NOT EXIST HFTOOLS\PatchPAE3.exe (
	ECHO HFTOOLS\PatchPAE3.exe not found.
	GOTO :EOF
)
REM 2024/7/17
REM Made the logic a bit more specific.
IF "%VERSION%"=="2000" (
	IF NOT EXIST WORK\I386E\sfc.dll (EXPAND SOURCE\I386\SFC.dl_ -R WORK\I386E)
	HFTOOLS\PatchPAE3.exe -type bypass_wfp -o WORK\I386E\sfcnew.dll WORK\I386E\sfc.dll
) ELSE IF "%VERSION%"=="XP" (
	IF NOT EXIST WORK\I386E\sfc_os.dll (EXPAND SOURCE\I386\SFC_OS.dl_ -R WORK\I386E)
	HFTOOLS\PatchPAE3.exe -type bypass_wfp -o WORK\I386E\sfc_osnew.dll WORK\I386E\sfc_os.dll
) ELSE (CALL)
REM The above CALL *should* SET ERRORLEVEL to 1.

REM TODO Make sure straight-reading ERRORLEVEL instead of first assigning its value to a "local" variable works as intended.
IF ERRORLEVEL 0 (
	IF "%VERSION%"=="2000" (
		DEL /F /Q WORK\I386E\sfc.dll
		REN WORK\I386E\sfcnew.dll sfc.dll
	) ELSE (
		DEL /F /Q WORK\I386E\sfc_os.dll
		REN WORK\I386E\sfc_osnew.dll sfc_os.dll
	)
	REM "don't eat the cat! Meow!"
	SET /A "DELCATS=1"
) ELSE (
	ECHO SFC/WFP patch failed.
	DEL /F /Q WORK\I386E\sfcnew.dll >NUL 2>&1
	DEL /F /Q WORK\I386E\sfc_osnew.dll >NUL 2>&1
)
GOTO :EOF
REM ---------- ----------

REM This subroutine patch setupapi.dll in Windows 2000.
REM Windows assume HKLM\SOFTWARE\Microsoft\Driver Signing\Policy [and non-driver signing policy] == 0.
REM PatchPAE3 Version: 0.0.0.48 beta-6+
REM ---------- Driver Certificate-Ignoring Patch ----------
:DIGICERTOFF
TITLE %T1% - Driver Signing
ECHO/
ECHO Processing Driver Signing Patch
ECHO/

IF NOT EXIST HFTOOLS\PatchPAE3.exe (
	ECHO HFTOOLS\PatchPAE3.exe not found.
	GOTO :EOF
)
IF NOT DEFINED DELCATS (
	ECHO Driver Signing patch skipped.
	GOTO :EOF
)

IF NOT EXIST WORK\I386E\setupapi.dll (EXPAND SOURCE\I386\SETUPAPI.dl_ -R WORK\I386E -F:* WORK\I386E\setupapi.dll)

IF "%VERSION%"=="2000" (
	HFTOOLS\PatchPAE3.exe -type setupapi_digicert -o WORK\I386E\setupapi_new.dll WORK\I386E\setupapi.dll
) ELSE (CALL)
REM The above CALL *should* SET ERRORLEVEL to 1.

REM TODO Make sure straight-reading ERRORLEVEL instead of first assigning its value to a "local" variable works as intended.
IF ERRORLEVEL 0 (
	DEL /F /Q WORK\I386E\setupapi.dll
	REN WORK\I386E\setupapi_new.dll setupapi.dll
) ELSE (
	ECHO Driver Signing patch failed.
	DEL /F /Q WORK\I386E\setupapi_new.dll >NUL 2>&1
)
GOTO :EOF
REM ---------- ----------

REM This subroutine patch ntkrnlpa.exe and ntkrpamp.exe in Windows 2000 to use more than 4 Gb RAM.
REM ---------- PAE Patch ----------
:PAEPATCH
TITLE %T1% - PAE
ECHO/
ECHO Processing PAE Patch
ECHO/

IF NOT EXIST HFTOOLS\PatchPAE3.exe (
	ECHO HFTOOLS\PatchPAE3.exe not found.
	GOTO :EOF
)
IF NOT DEFINED DELCATS (
	ECHO PAE patch skipped.
	GOTO :EOF
)

IF NOT EXIST WORK\I386E\ntkrnlpa.exe (EXPAND SOURCE\I386\SP%SP%.cab -F:ntkrnlpa.exe WORK\I386E)
IF NOT EXIST WORK\I386E\ntkrnlpa.exe (EXPAND SOURCE\I386\DRIVER.cab -F:ntkrnlpa.exe WORK\I386E)
IF NOT EXIST WORK\I386E\ntkrpamp.exe (EXPAND SOURCE\I386\SP%SP%.cab -F:ntkrpamp.exe WORK\I386E)
IF NOT EXIST WORK\I386E\ntkrpamp.exe (EXPAND SOURCE\I386\DRIVER.cab -F:ntkrpamp.exe WORK\I386E)

IF "%VERSION%"=="2000" (
	HFTOOLS\PatchPAE3.exe -type kernel -o WORK\I386E\ntkrnlpa-new.exe WORK\I386E\ntkrnlpa.exe
) ELSE (CALL)
SET /A "el1=%ERRORLEVEL%"
IF "%VERSION%"=="2000" (
	HFTOOLS\PatchPAE3.exe -type kernel -o WORK\I386E\ntkrpamp-new.exe WORK\I386E\ntkrpamp.exe
) ELSE (CALL)
REM The above CALLs SET ERRORLEVEL to 1.
SET /A "el2=%ERRORLEVEL%"

IF %el1% EQU 0 IF %el2% EQU 0 (
	DEL /F /Q WORK\I386E\ntkrnlpa.exe
	REN WORK\I386E\ntkrnlpa-new.exe ntkrnlpa.exe
	DEL /F /Q WORK\I386E\ntkrpamp.exe
	REN WORK\I386E\ntkrpamp-new.exe ntkrpamp.exe
) ELSE (
	ECHO PAE patch failed.
	DEL /F /Q WORK\I386E\ntkrnlpa-new.exe >NUL 2>&1
	DEL /F /Q WORK\I386E\ntkrpamp-new.exe >NUL 2>&1
)
GOTO :EOF
REM ---------- ----------

REM 2024/7/16
REM Moved into its own dedicated subroutine, formatted similar to other evgnb subroutines.
REM This subroutine is used to change a retail source of Windows 2000 into an OEM one.
REM ---------- Retail-to-OEM ----------
:OEMKEYEDIT
REM 2020-08-07:
DEL /F /Q SOURCESS\I386\SETUPP.IN2
FOR /F "tokens=*" %%I IN (SOURCESS\I386\SETUPP.ini) DO (
	SET "PROD_STR=%%I"
	SET "PROD_PID=!PROD_STR:~0,4!"
	IF /I "!PROD_PID!" == "Pid=" (SET "PROD_STR=!PROD_STR:~0,-3!270")
	ECHO !PROD_STR!>>SOURCESS\I386\SETUPP.IN2
)
SET "PROD_STR="
SET "PROD_PID="
DEL /F /Q SOURCESS\I386\SETUPP.ini
REN SOURCESS\I386\SETUPP.IN2 SETUPP.ini

GOTO :EOF
REM ---------- ----------

