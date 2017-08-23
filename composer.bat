@ECHO OFF
%~dp0\php7.1\php.exe -n -dextension=%~dp0\php7.1\ext\php_gd2.dll -dextension=%~dp0\php7.1\ext\php_fileinfo.dll -dextension=%~dp0\php7.1\ext\php_curl.dll -dextension=%~dp0\php7.1\ext\php_openssl.dll -dextension=%~dp0\php7.1\ext\php_mbstring.dll -dextension=%~dp0\php7.1\ext\php_intl.dll %~dp0\composer.phar %*
