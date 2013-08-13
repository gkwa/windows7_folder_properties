!include LogicLib.nsh
!include FileFunc.nsh
!include MUI2.NSH
!include nsDialogs.nsh
!include nsProcess.nsh

Name "${name}"
OutFile "${outfile}"

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "Streambox $(^Name) Installer"

# use this as installdir
InstallDir '$PROGRAMFILES\Streambox\${name}'
#...butif this reg key exists, use this installdir instead of the above line
InstallDirRegKey HKLM 'Software\Streambox\${name}' InstallDir

VIAddVersionKey ProductName "tool-reset-explorer-preferences"
VIAddVersionKey FileDescription "Tool to automate resetting Explorer preferences"
VIAddVersionKey Language "English"
VIAddVersionKey LegalCopyright "@Streambox"
VIAddVersionKey CompanyName "Streambox"
VIAddVersionKey ProductVersion "${version}"
VIAddVersionKey FileVersion "${version}"
VIProductVersion "${version}"

;--------------------------------
; docs
# http://nsis.sourceforge.net/Docs
# http://nsis.sourceforge.net/Macro_vs_Function
# http://nsis.sourceforge.net/Adding_custom_installer_pages
# http://nsis.sourceforge.net/ConfigWrite
# loops
# http://nsis.sourceforge.net/Docs/Chapter2.html#\2.3.6

;--------------------------------


var debug

;--------------------------------
;Interface Configuration

!define MUI_WELCOMEPAGE_TITLE "Welcome to the Streambox setup wizard."
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_ABORTWARNING

UninstallText "This will uninstall ${name}"

;--------------------------------
;Pages

!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections

;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Functions

Function .onInit

	SetSilent silent

	SetAutoClose true
	##############################
	# did we call with "/debug"
	StrCpy $debug 0
	${GetParameters} $0
	ClearErrors
	${GetOptions} $0 '/debug' $1
	${IfNot} ${Errors}
		StrCpy $debug 1
		SetAutoClose false #leave installer window open when /debug
	${EndIf}
	ClearErrors

FunctionEnd

Function .onInstSuccess
FunctionEnd

Section section1 section_section1

	SetOutPath '$TEMP'
	${If} 1 == $debug
		exec '"$WINDIR\explorer.exe" "$TEMP"'
	${EndIf}

	SetOutPath '$TEMP\${name}'
	ExpandEnvStrings $0 %COMSPEC%
	File reduce_security_powershell.bat
	nsExec::ExecToLog '"$0" /c "$TEMP\${name}\reduce_security_powershell.bat"'

	File HideFileExt.ps1
	File HideFileExt_controller.bat
	ExpandEnvStrings $0 %COMSPEC%
	ExecWait '"$0" /c "$TEMP\${name}\HideFileExt_controller.bat"'


	SetOutPath '$TEMP'
	${If} 0 == $debug
		rmdir /r '$TEMP\${name}'
	${EndIf}


SectionEnd

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
