# General
!include "MUI2.nsh"
!define MY_APP "phpbox"
Name "phpbox"
OutFile "phpbox.exe"
ShowInstDetails show
AllowRootDirInstall true
RequestExecutionLevel user

Function .onInit
   StrCpy "$INSTDIR" "$WINDIR" 2
   StrCpy "$INSTDIR" "$INSTDIR\${MY_APP}"
FunctionEnd

# Pages
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
  
# Languages 
!insertmacro MUI_LANGUAGE "English"

# Installer Sections
Section "Base" SecBase
	SectionIn RO 
	SetOutPath "$INSTDIR"

	inetc::get http://windows.php.net/downloads/releases/php-5.6.16-nts-Win32-VC11-x86.zip $INSTDIR\php.zip
	CreateDirectory "$INSTDIR\php"
	nsisunz::UnzipToLog "$INSTDIR\php.zip" "$INSTDIR\php"
	Delete $INSTDIR\php.zip
	
  	File README.md
  
	WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Composer" SecComposer
	inetc::get https://getcomposer.org/composer.phar $INSTDIR\php\composer.phar
	File composer.bat
SectionEnd

Section "Gettext" SecGettext
	inetc::get https://github.com/mlocati/gettext-iconv-windows/releases/download/v0.19.6-v1.14/gettext0.19.6-iconv1.14-static-32.exe $INSTDIR\gettexticonv.exe
	Exec "$INSTDIR\gettexticonv.exe /silent"
	Delete $INSTDIR\gettexticonv.exe
SectionEnd

Section "PHP CS Fixer" SecCsFixer
	inetc::get http://get.sensiolabs.org/php-cs-fixer.phar $INSTDIR\php\php-cs-fixer.phar
	File php-cs-fixer.bat
SectionEnd


# Language strings
LangString DESC_SecBase ${LANG_ENGLISH} "Base functionality, mandatory."
LangString DESC_SecComposer ${LANG_ENGLISH} "composer, dependency management for PHP"
LangString DESC_SecGettext ${LANG_ENGLISH} "Gettext and iconv console tools"
LangString DESC_SecCsFixer ${LANG_ENGLISH} "PHP CS Fixer"

# Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecBase} $(DESC_SecBase)
!insertmacro MUI_DESCRIPTION_TEXT ${SecComposer} $(DESC_SecComposer)
!insertmacro MUI_DESCRIPTION_TEXT ${SecGettext} $(DESC_SecGettext)
!insertmacro MUI_DESCRIPTION_TEXT ${SecCsFixer} $(DESC_SecCsFixer)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Uninstaller Section
Section "Uninstall"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir /r /REBOOTOK  "$INSTDIR"
SectionEnd