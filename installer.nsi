# General
!include "MUI2.nsh"
!include "EnvVarUpdate.nsh"
!include "AdvReplaceInFile.nsh"
!include "LogicLib.nsh"

!define MY_APP "phpbox"
!define MUI_COMPONENTSPAGE_NODESC

Name "phpbox"
OutFile "phpbox.exe"
InstallDir "c:\phpbox"
ShowInstDetails show
AllowRootDirInstall true
RequestExecutionLevel admin

Function .onInit
	UserInfo::GetAccountType
	pop $0
	${If} $0 != "admin" ;Require admin rights on NT4+
		MessageBox mb_iconstop "Administrator rights required!"
		SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
		Quit
	${EndIf}

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
	Section "5.5.30" SecPhp55
		AddSize 19323
	
		# download and extract PHP
		inetc::get http://windows.php.net/downloads/releases/php-5.5.30-Win32-VC11-x86.zip $INSTDIR\php5.5.zip
		CreateDirectory "$INSTDIR\php5.5"
		nsisunz::UnzipToLog "$INSTDIR\php5.5.zip" "$INSTDIR\php5.5"
		Delete $INSTDIR\php5.5.zip
		
		# download xdebug extension
		inetc::get http://xdebug.org/files/php_xdebug-2.4.0rc3-5.5-vc11.dll $INSTDIR\php5.5\ext\php_xdebug.dll
		
		# create php configuration file
		File /oname=$INSTDIR\php5.5\php.ini php55.ini
		File php55.bat
		
		Push $$PHPPATH #text to be replaced
		Push $INSTDIR\php5.6 #replace with
		Push all #replace all occurrences
		Push all #replace all occurrences
		Push $INSTDIR\php5.6\php.ini #file to replace in
		Call AdvReplaceInFile		
	SectionEnd	
	
	Section "5.6.18" SecPhp56
		SectionIn RO 
		SetOutPath "$INSTDIR"
		AddSize 20684

		# download and extract PHP
		inetc::get http://windows.php.net/downloads/releases/php-5.6.18-Win32-VC11-x86.zip $INSTDIR\php5.6.zip
		CreateDirectory "$INSTDIR\php5.6"
		nsisunz::UnzipToLog "$INSTDIR\php5.6.zip" "$INSTDIR\php5.6"
		Delete $INSTDIR\php5.6.zip
		
		# download xdebug extension
		inetc::get http://xdebug.org/files/php_xdebug-2.4.0rc4-5.6-vc11.dll $INSTDIR\php5.6\ext\php_xdebug.dll
		
		File README.md
		File php.bat
		
		# create php configuration file
		File /oname=$INSTDIR\php5.6\php.ini php56.ini
		
		Push $$PHPPATH #text to be replaced
		Push $INSTDIR\php5.6 #replace with
		Push all #replace all occurrences
		Push all #replace all occurrences
		Push $INSTDIR\php5.6\php.ini #file to replace in
		Call AdvReplaceInFile
		
		${EnvVarUpdate} $0 "PATH" "A" "HKCU" "$INSTDIR"
	  
		WriteUninstaller "$INSTDIR\Uninstall.exe"
	SectionEnd
	
	Section "7.0.3" SecPhp70
		AddSize 21330
		
		# download and extract PHP
		inetc::get http://windows.php.net/downloads/releases/php-7.0.3-Win32-VC14-x86.zip $INSTDIR\php7.0.zip
		CreateDirectory "$INSTDIR\php7.0"
		nsisunz::UnzipToLog "$INSTDIR\php7.0.zip" "$INSTDIR\php7.0"
		
		# download xdebug extension
		inetc::get http://xdebug.org/files/php_xdebug-2.4.0rc4-7.0-vc14.dll $INSTDIR\php7.0\ext\php_xdebug.dll
		
		# create php configuration file
		File /oname=$INSTDIR\php7.0\php.ini php70.ini
		File php7.bat
		
		Push $$PHPPATH #text to be replaced
		Push $INSTDIR\php7.0 #replace with
		Push all #replace all occurrences
		Push all #replace all occurrences
		Push $INSTDIR\php7.0\php.ini #file to replace in
		Call AdvReplaceInFile
		
		Delete $INSTDIR\php7.0.zip
	SectionEnd	
	
	Section "Composer" SecPhpComposer
		AddSize 1209
		inetc::get https://getcomposer.org/composer.phar $INSTDIR\php5.6\composer.phar
		File composer.bat
	SectionEnd

	Section "CS Fixer" SecPhpCsFixer
		AddSize 1261
		inetc::get http://get.sensiolabs.org/php-cs-fixer.phar $INSTDIR\php5.6\php-cs-fixer.phar
		File php-cs-fixer.bat
	SectionEnd

	Section "MD" SecPhpMd
		AddSize 820
		inetc::get http://static.phpmd.org/php/latest/phpmd.phar $INSTDIR\php5.6\phpmd.phar
		File phpmd.bat
	SectionEnd
SectionGroupEnd

Section "Gettext" SecGettext
	AddSize 77926
	inetc::get https://github.com/mlocati/gettext-iconv-windows/releases/download/v0.19.6-v1.14/gettext0.19.6-iconv1.14-static-32.exe $INSTDIR\gettexticonv.exe
	ExecWait "$INSTDIR\gettexticonv.exe /silent"
	Delete $INSTDIR\gettexticonv.exe
SectionEnd

Section "Wincachegrind" SecWincachegrind
    AddSize 802

    inetc::get https://github.com/ceefour/wincachegrind/releases/download/1.1/wincachegrind-1.1.zip $INSTDIR\wincachegrind.zip
    CreateDirectory "$INSTDIR\wincachegrind"
    nsisunz::UnzipToLog "$INSTDIR\wincachegrind.zip" "$INSTDIR\wincachegrind"
    Delete $INSTDIR\wincachegrind.zip
SectionEnd

SectionGroup /e "NodeJS"
	Section "NodeJS 4.2.6" SecNodeJs
		AddSize 9216
		inetc::get https://nodejs.org/dist/v4.2.6/node-v4.2.6-x86.msi $INSTDIR\nodejs.msi
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

SectionGroup /e "MySQL"
	Section "MySQL 5.7.10" SecMySQL
		AddSize 327680
		inetc::get http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.10-win32.zip $INSTDIR\mysql.zip
		nsisunz::UnzipToLog "$INSTDIR\mysql.zip" "$INSTDIR"
		Delete $INSTDIR\mysql.zip
	SectionEnd
	
	Section "Install MySQL Service" SecMySQLService
	
		CreateDirectory "$INSTDIR\mysql-data"
		File /oname=$INSTDIR\my.ini my.ini
	
		# replace mysql data path
		Push $$MYSQL_DATA_PATH #text to be replaced
		Push $INSTDIR\mysql-data #replace with
		Push all #replace all occurrences
		Push all #replace all occurrences
		Push $INSTDIR\my.ini #file to replace in
		Call AdvReplaceInFile	
	
		# replace mysql program path
		Push $$MYSQL_BASE_PATH #text to be replaced
		Push $INSTDIR\mysql-5.7.10-win32 #replace with
		Push all #replace all occurrences
		Push all #replace all occurrences
		Push $INSTDIR\my.ini #file to replace in
		Call AdvReplaceInFile
		
		ExecWait "$INSTDIR\mysql-5.7.10-win32\bin\mysqld --defaults-file=$INSTDIR\my.ini --initialize"
		ExecWait "$INSTDIR\mysql-5.7.10-win32\bin\mysqld --install --defaults-file=$INSTDIR\my.ini"
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
LangString DESC_SecWincachegrind ${LANG_ENGLISH} "Wincachegrind"
LangString DESC_SecMySQL ${LANG_ENGLISH} "MySQL"
LangString DESC_SecMySQLService ${LANG_ENGLISH} "Base"

# Uninstaller Section
Section "Uninstall"
  Delete "$INSTDIR\Uninstall.exe"
  ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "$INSTDIR"
  RMDir /r /REBOOTOK  "$INSTDIR"
SectionEnd

