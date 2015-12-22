# General
!include "MUI2.nsh"
!include "EnvVarUpdate.nsh"
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

SectionGroup /e "PHP"
	Section "5.5" SecPhp55
		AddSize 19323
	
		# download and extract PHP
		inetc::get http://windows.php.net/downloads/releases/php-5.5.30-Win32-VC11-x86.zip $INSTDIR\php5.5.zip
		CreateDirectory "$INSTDIR\php5.5"
		nsisunz::UnzipToLog "$INSTDIR\php5.5.zip" "$INSTDIR\php5.5"
		Delete $INSTDIR\php5.5.zip
		
		# download xdebug extension
		inetc::get http://xdebug.org/files/php_xdebug-2.4.0rc3-5.5-vc11.dll $INSTDIR\php5.5\ext\php_xdebug.dll
	SectionEnd	
	
	Section "5.6" SecPhp56
		SectionIn RO 
		SetOutPath "$INSTDIR"
		AddSize 20766

		# download and extract PHP
		inetc::get http://windows.php.net/downloads/releases/php-5.6.16-Win32-VC11-x86.zip $INSTDIR\php5.6.zip
		CreateDirectory "$INSTDIR\php5.6"
		nsisunz::UnzipToLog "$INSTDIR\php5.6.zip" "$INSTDIR\php5.6"
		Delete $INSTDIR\php5.6.zip
		
		# download xdebug extension
		inetc::get http://xdebug.org/files/php_xdebug-2.4.0rc3-5.6-vc11.dll $INSTDIR\php5.6\ext\php_xdebug.dll
		
		File README.md
		File php.bat
		
		${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR"
	  
		WriteUninstaller "$INSTDIR\Uninstall.exe"
	SectionEnd
	
	Section "7.0" SecPhp70
		AddSize 21330
		
		# download and extract PHP
		inetc::get http://windows.php.net/downloads/releases/php-7.0.1-Win32-VC14-x86.zip $INSTDIR\php7.0.zip
		CreateDirectory "$INSTDIR\php7.0"
		nsisunz::UnzipToLog "$INSTDIR\php7.0.zip" "$INSTDIR\php7.0"
		
		# download xdebug extension
		inetc::get http://xdebug.org/files/php_xdebug-2.4.0rc3-7.0-vc14.dll $INSTDIR\php7.0\ext\php_xdebug.dll
		
		Delete $INSTDIR\php7.0.zip
	SectionEnd	
	
	Section "Composer" SecPhpComposer
		AddSize 1209
		inetc::get https://getcomposer.org/composer.phar $INSTDIR\php\composer.phar
		File composer.bat
	SectionEnd

	Section "CS Fixer" SecPhpCsFixer
		AddSize 1261
		inetc::get http://get.sensiolabs.org/php-cs-fixer.phar $INSTDIR\php\php-cs-fixer.phar
		File php-cs-fixer.bat
	SectionEnd

	Section "MD" SecPhpMd
		AddSize 820
		inetc::get http://static.phpmd.org/php/latest/phpmd.phar $INSTDIR\php\phpmd.phar
		File phpmd.bat
	SectionEnd
SectionGroupEnd

Section "Gettext" SecGettext
	AddSize 77926
	inetc::get https://github.com/mlocati/gettext-iconv-windows/releases/download/v0.19.6-v1.14/gettext0.19.6-iconv1.14-static-32.exe $INSTDIR\gettexticonv.exe
	ExecWait "$INSTDIR\gettexticonv.exe /silent"
	Delete $INSTDIR\gettexticonv.exe
SectionEnd

SectionGroup /e "NodeJS"
	Section "Base" SecNodeJs
		AddSize 26726
		inetc::get https://nodejs.org/dist/v4.2.3/node-v4.2.3-x86.msi $INSTDIR\nodejs.msi
		ExecWait '"$SYSDIR\msiExec" /i "$INSTDIR\nodejs.msi" /passive'
		Delete $INSTDIR\nodejs.msi
	SectionEnd
	
	Section "Grunt" SecNodeJsGrunt
		AddSize 1274
		ExecWait "npm install -g grunt-cli"
	SectionEnd
	
	Section "JsHint" SecNodeJsHint
		AddSize 650
		ExecWait "npm install -g jshint"
	SectionEnd	
SectionGroupEnd

# Language strings
LangString DESC_SecPhp55 ${LANG_ENGLISH} "PHP 5.5"
LangString DESC_SecPhp56 ${LANG_ENGLISH} "PHP 5.6"
LangString DESC_SecPhp70 ${LANG_ENGLISH} "PHP 7.0"
LangString DESC_SecPhpComposer ${LANG_ENGLISH} "composer, dependency management for PHP"
LangString DESC_SecGettext ${LANG_ENGLISH} "Gettext and iconv console tools"
LangString DESC_SecPhpCsFixer ${LANG_ENGLISH} "PHP CS Fixer"
LangString DESC_SecPhpMd ${LANG_ENGLISH} "PHP Mess Detecter to find possible bugs, suboptimal as well as overcomplicated code"
LangString DESC_SecNodeJs ${LANG_ENGLISH} "NodeJS"
LangString DESC_SecNodeJsGrunt ${LANG_ENGLISH} "Grunt"
LangString DESC_SecNodeJsHint ${LANG_ENGLISH} "JS Hint"

# Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecPhp55} $(DESC_SecPhp55)
!insertmacro MUI_DESCRIPTION_TEXT ${SecPhp56} $(DESC_SecPhp56)
!insertmacro MUI_DESCRIPTION_TEXT ${SecPhp70} $(DESC_SecPhp70)
!insertmacro MUI_DESCRIPTION_TEXT ${SecPhpComposer} $(DESC_SecPhpComposer)
!insertmacro MUI_DESCRIPTION_TEXT ${SecGettext} $(DESC_SecGettext)
!insertmacro MUI_DESCRIPTION_TEXT ${SecPhpCsFixer} $(DESC_SecPhpCsFixer)
!insertmacro MUI_DESCRIPTION_TEXT ${SecPhpMd} $(DESC_SecPhpMd)
!insertmacro MUI_DESCRIPTION_TEXT ${SecNodeJs} $(DESC_SecNodeJs)
!insertmacro MUI_DESCRIPTION_TEXT ${SecNodeJsGrunt} $(DESC_SecNodeJsGrunt)
!insertmacro MUI_DESCRIPTION_TEXT ${SecNodeJsHint} $(DESC_SecNodeJsHint)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Uninstaller Section
Section "Uninstall"
  Delete "$INSTDIR\Uninstall.exe"
  ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR"
  RMDir /r /REBOOTOK  "$INSTDIR"
SectionEnd