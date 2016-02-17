# PhpBox Installer

An NSIS installer helping you to get a number of useful tools on to your Windows computer if you want to develop PHP applications on your local computer.

## Download

If you simply wish to use phpBox, head over to https://github.com/ortic/phpbox/releases and download the lastest exe.

## Content

* PHP 5.5, 5.6, 7.0 [http://php.net](http://php.net)
* MySQL 5.7.10 [http://www.mysql.com](http://www.mysql.com)
* xDebug matching the PHP versions [http://xdebug.org](http://xdebug.org)
* PHP Mess Detecter [http://phpmd.org](http://phpmd.org)
* PHP Cs Fixer [https://github.com/FriendsOfPHP/PHP-CS-Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer)
* PHP composer [https://getcomposer.org/](https://getcomposer.org/)
* Gettext / Iconv [http://mlocati.github.io/gettext-iconv-windows](http://mlocati.github.io/gettext-iconv-windows)
* NodeJS [https://nodejs.org](https://nodejs.org)
* Wincachegrind [http://ceefour.github.io/wincachegrind](http://ceefour.github.io/wincachegrind)

## Required NSIS plugins

If you want to compile the installer yourself, install [NSIS](http://nsis.sourceforge.net/) and copy the two plugins below into the plugins directory of your NSIS installation.

* [http://nsis.sourceforge.net/Inetc_plug-in](http://nsis.sourceforge.net/Inetc_plug-in)
* [http://nsis.sourceforge.net/Nsisunz_plug-in](http://nsis.sourceforge.net/Nsisunz_plug-in)

## FAQ

* **Why not use vagrant?** Yes I know vagrant, it's great and if you're happy with, it, use it!
* **Why not use a WAMP stack?** I prefer something small on top of original components so that I can easily update them. Too many WAMP stacks use an outdated PHP version.
* **What's next?** I plan on adding a few more things like MySQL, Apache
