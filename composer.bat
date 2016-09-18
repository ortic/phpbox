@ECHO OFF
%~dp0\php5.6\php.exe -n -dextension=%~dp0\php5.6\ext\php_gd2.dll -dextension=%~dp0\php5.6\ext\php_fileinfo.dll -dextension=%~dp0\php5.6\ext\php_curl.dll -dextension=%~dp0\php5.6\ext\php_openssl.dll -dextension=%~dp0\php5.6\ext\php_mbstring.dll -dextension=%~dp0\php5.6\ext\php_intl.dll %~dp0\php5.6\composer.phar %*
