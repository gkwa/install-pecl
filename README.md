<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [TODO](#todo)
    - [TODO using expect to automate pecl is not working](#todo-using-expect-to-automate-pecl-is-not-working)
- [Using curl to post to a web form](#using-curl-to-post-to-a-web-form)
    - [Given this form, this post works](#given-this-form-this-post-works)
    - [curl 417 Expectation Failed](#curl-417-expectation-failed)
        - [trace log1](#trace-log1)
        - [trace log2](#trace-log2)
    - [old notes, many failed attempts](#old-notes-many-failed-attempts)
        - [See if you can post to wizard from cli](#see-if-you-can-post-to-wizard-from-cli)
            - [log](#log)
- [remote debugging with xdebug](#remote-debugging-with-xdebug)
    - [TODO install precompiled xdebug dll for windows](#todo-install-precompiled-xdebug-dll-for-windows)
    - [Precompiled Windows Modules](#precompiled-windows-modules)
    - [install xdebug using pear pecl](#install-xdebug-using-pear-pecl)
        - [pecl install xdebug](#pecl-install-xdebug)
        - [log](#log)
- [chocolatey installs php](#chocolatey-installs-php)
    - [log](#log)
    - [Add pear batch file to your path](#add-pear-batch-file-to-your-path)
    - [Expect has not been ported to win64](#expect-has-not-been-ported-to-win64)
    - [teacup install Expect](#teacup-install-expect)
    - [curl download and run pear](#curl-download-and-run-pear)
    - [example expect script to install pecl](#example-expect-script-to-install-pecl)
    - [TODO find a way to get around installing activestate expect just to automate pecl](#todo-find-a-way-to-get-around-installing-activestate-expect-just-to-automate-pecl)
    - [dependendencies](#dependendencies)
        - [log](#log)
    - [the chocolatey php installer will put path in your env path, but not into system path](#the-chocolatey-php-installer-will-put-path-in-your-env-path-but-not-into-system-path)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

TODO
====

TODO using expect to automate pecl is not working
-------------------------------------------------

Using curl to post to a web form
================================

Given this form, this post works
--------------------------------

I want to send `php -i` output to <https://xdebug.org/wizard.php>

On this page <https://xdebug.org/wizard.php>, the form looks like this:

      <form method='post'>
        <textarea name='data'></textarea>

        <p>The information that you upload will not be stored.</p>

        <p><input type='submit'
               name='submit'
               value='Analyse my phpinfo() output' /></p>
      </form>

It works with `--header 'Expect: '`:

    php -i >source.txt
    curl --data-urlencode data@source.txt --data-urlencode submit='Analyse my phpinfo() output' \
        --header 'Expect: ' --insecure https://xdebug.org/wizard.php

It works with `--http1.0`: from
<http://stackoverflow.com/a/9214195/1495086>

    curl --data-urlencode data@source.txt --data-urlencode submit='Analyse my phpinfo() output' \
        --http1.0 --insecure https://xdebug.org/wizard.php

curl 417 Expectation Failed
---------------------------

What is this message about?

from <http://www.zingiri.com/2011/09/http-error-417-with-phps-curl>

> If someone else wonders about it, this is what’s happening …
>
> If the content length (of the request post data) is bigger than 1KB
> (&gt;=1025 bytes), the client (curl in our case) sends the request
> with a ="Expect: 100-continue"= header and without the actual post
> data, than awaits for a response with status 100, and than finally
> sends the actual post data.
>
> The problem is that many servers (lighttpd 1.4 among them, fixed at
> 1.5) doesn’t support that, which is exactly why we got the 417 error
> with the plugin.
>
> To make curl suppress that header, and just send the request/post data
> normally while ignoring the fact that the post data is more than 1KB,
> add the following piece of code:
>
> `curl_setopt($ch, CURLOPT_HTTPHEADER, array(‘Expect:’));`
>
> Adding a header with no value makes it overwrite the original value
> and suppress the header, which should make everything work fine.
>
> It should be noted that every time you set `CURLOPT_HTTPHEADER` it
> overwrites the original `HTTPHEADER` value and not appends to it, so
> if you already set it, you should simply add ‘Expect:’ to your
> existing `HTTPHEADER` array instead of adding the entire line.

-   <http://www.checkupdown.com/status/E417.html>
-   <http://www.khattam.info/417-expectation-failed-in-php-curl-while-submitting-multi-part-forms-2011-04-14.html>

<!-- -->

    [Administrator@SBX3512E41:/c/tools/php]$ curl -L --insecure -X POST -d @o https://xdebug.org/wizard.php
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
     <head>
      <title>417 - Expectation Failed</title>
     </head>
     <body>
      417 - Expectation Failed
     </body>
    </html>
    [Administrator@SBX3512E41:/c/tools/php]$

Work arounds

It works with `--http1.0`: from
<http://stackoverflow.com/a/9214195/1495086>

    curl --data-urlencode data@source.txt --data-urlencode submit='Analyse my phpinfo() output' \
        --http1.0 --insecure https://xdebug.org/wizard.php

It works with `--header 'Expect: '`:

    php -i >source.txt
    curl --data-urlencode data@source.txt --data-urlencode submit='Analyse my phpinfo() output' \
        --header 'Expect: ' --insecure https://xdebug.org/wizard.php

### trace log1

    [demo@demos-MBP:/tmp]$ curl --data-urlencode data@source.txt --data-urlencode submit='Analyse my phpinfo() output' --proxy-negotiate --insecure https://xdebug.org/wizard.php --silent --trace-ascii trace.txt --output out.txt; grep -iE 'HTTP.*Expectation Failed' trace.txt
    0000: HTTP/1.1 417 Expectation Failed
    [demo@demos-MBP:/tmp]$

### trace log2

    [demo@demos-MBP:/tmp]$ curl --data-urlencode data@source.txt --data-urlencode submit='Analyse my phpinfo() output' --http1.1 --insecure https://xdebug.org/wizard.php --trace-ascii /dev/stdout
    == Info:   Trying 82.113.146.227...
    == Info: Connected to xdebug.org (82.113.146.227) port 443 (#0)
    == Info: TLS 1.2 connection using TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
    == Info: Server certificate: xdebug.org
    == Info: Server certificate: Let's Encrypt Authority X1
    == Info: Server certificate: DST Root CA X3
    => Send header, 179 bytes (0xb3)
    0000: POST /wizard.php HTTP/1.1
    001b: Host: xdebug.org
    002d: User-Agent: curl/7.43.0
    0046: Accept: */*
    0053: Content-Length: 53924
    006a: Content-Type: application/x-www-form-urlencoded
    009b: Expect: 100-continue
    00b1:
    <= Recv header, 33 bytes (0x21)
    0000: HTTP/1.1 417 Expectation Failed
    <= Recv header, 25 bytes (0x19)
    0000: Content-Type: text/html
    <= Recv header, 21 bytes (0x15)
    0000: Content-Length: 363
    <= Recv header, 19 bytes (0x13)
    0000: Connection: close
    <= Recv header, 37 bytes (0x25)
    0000: Date: Sun, 31 Jan 2016 20:51:19 GMT
    <= Recv header, 58 bytes (0x3a)
    0000: Server: lighttpd/1.4.35-devel-debian/1.4.35-1-6-ga75f781
    <= Recv header, 2 bytes (0x2)
    0000:
    <= Recv data, 363 bytes (0x16b)
    0000: <?xml version="1.0" encoding="iso-8859-1"?>.<!DOCTYPE html PUBLI
    0040: C "-//W3C//DTD XHTML 1.0 Transitional//EN".         "http://www.
    0080: w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">.<html xmlns="http
    00c0: ://www.w3.org/1999/xhtml" xml:lang="en" lang="en">. <head>.  <ti
    0100: tle>417 - Expectation Failed</title>. </head>. <body>.  417
    0140: - Expectation Failed. </body>.</html>.
    <?xml version="1.0" encoding="iso-8859-1"?>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
             "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
     <head>
      <title>417 - Expectation Failed</title>
     </head>
     <body>
      417 - Expectation Failed
     </body>
    </html>
    == Info: Closing connection 0
    [demo@demos-MBP:/tmp]$

old notes, many failed attempts
-------------------------------

    man curl
    curl -L --insecure -X POST --data @o https://xdebug.org/wizard.php
    curl -L --insecure -X POST --data @o http://xdebug.org/wizard.php
    curl -L --insecure -X POST --data-urlencode @o http://xdebug.org/wizard.php
    curl -L --insecure -X POST --data-raw @o http://xdebug.org/wizard.php
    curl -D -L --insecure -X POST --data-raw @o http://xdebug.org/wizard.php
    curl --dump-header -L --insecure -X POST --data-raw @o http://xdebug.org/wizard.php
    curl --dump-header -L --insecure -X POST --data-raw @o https://xdebug.org/wizard.php
    curl -L --insecure -X POST --data-raw @o https://xdebug.org/wizard.php
    curl -D -H 'Expect:' -L --insecure --data @o https://xdebug.org/wizard.php
    curl  -H 'Expect:' -L --insecure --data @o https://xdebug.org/wizard.php
    hs curl
    curl --dump-header -L --insecure -X POST --data-raw @o https://xdebug.org/wizard.php -v
    curl --dump-header -L --insecure -X POST --data @o https://xdebug.org/wizard.php -v
    # curl  --dump-header -L --insecure -X POST --data @o https://xdebug.org/wizard.php -v
    curl  -H 'Expect: 100-continue'' -L --insecure --data @o https://xdebug.org/wizard.php
    curl  -H 'Expect: 100-continue' -L --insecure --data @o https://xdebug.org/wizard.php
    curl  -H 'Expect: 100-continue' -L --insecure --data-raw @o https://xdebug.org/wizard.php
    curl  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php
    curl  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v
    curl  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30"
    curl -X POST  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30"
    curl -X POST  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" --anyauth
    curl -X POST  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" --trace-ascii
    curl -X POST  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" --trace-ascii /dev/stdout
    curl -X POST  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" --trace-ascii /dev/stdout -F
    curl -X POST  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" -F
    curl -X POST  -H 'Expect: 100' -L --insecure --form @o https://xdebug.org/wizard.php -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30"
    curl -F text=@o -X POST  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v
    curl -F text=@o -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v
    curl -F text=@o -X POST  -H 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl -F text=@o -H 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl -F text=@o -L --insecure https://xdebug.org/wizard.php -v
    curl -F text=@o -H 'Expect: 100' -L --insecure https://xdebug.org/wizard.php
    curl -F text=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php
    curl -F text=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php -v
    curl -F data=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php -v
    curl -F value=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php -v
    curl --form data=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php -v
    curl --form data=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php -v curl --form data=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30"
    curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" --form data=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php -v curl --form data=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php
    curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30" --form data=@o -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v curl --form data=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php
    curl --form data=@o -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v curl --form data=@o -H 'Expect:' -L --insecure https://xdebug.org/wizard.php
    curl --form data=@o -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v curl --form data=@o -H 'Expect:' --insecure https://xdebug.org/wizard.php
    curl --form data=@o -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v curl --form data=@o -L --insecure https://xdebug.org/wizard.php
    curl --form data=@o -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v
    curl --form 'data=@o' -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v
    curl --form 'data=@o' -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v  | grep -i dll
    curl --form 'data=@o' -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii
    curl --form 'data=@o' -H 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout
    curl --form 'data=@o' --header 'Expect: ' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout
    curl --form 'data=@o' --header 'Expect: 100-continue' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout
    curl --form 'data=@o' --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout
    curl --form 'data=@o' --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout  | grep -i dll
    curl --quiet --form 'data=@o' --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout  | grep -i dll
    curl --silent --form 'data=@o' --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout  | grep -i dll
    curl --silent --form data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout  | grep -i dll
    curl --form data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --trace-ascii /dev/stdout
    curl --form data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --tr-encoding
    curl --data-urlencode --form data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --tr-encoding
    curl --form data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --header "Content-Type:text/xml"
    curl --form data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v --header "Content-Type:text/form-data"
    curl --form data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl -d @o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    cat o | curl -d @- --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl --data-urlencode data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl --data-urlencode 'data@o' --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl -d data@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl -d data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    # curl -d data=@o --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl -d data=@o1.txt --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl -d @o1.txt --header 'Expect: 100' -L --insecure https://xdebug.org/wizard.php -v
    curl -d @o1.txt -L --insecure https://xdebug.org/wizard.php -v
    curl -d @o1.txt --header 'Expect: 100' --insecure https://xdebug.org/wizard.php -v
    curl -d @o1.txt --header 'Expect: 100' --insecure https://xdebug.org/wizard.php
    curl -d @o1.txt --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --data-urlencode @o --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --request POST --data-urlencode @o --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --request POST --data-urlencode data=@o --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl -d @o2.txt --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl -d data@o2.txt --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl -d data=@o2.txt --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl -d data=@o1.txt --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --data @o1.txt --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --data-urlencode @o1.txt --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --data-urlencode @o --binary-data --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --data-urlencode @o --data-binary --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --data-encode @o --header 'Expect: ' --insecure https://xdebug.org/wizard.php
    curl --data-urlencode @o --header 'Expect: ' --insecure https://xdebug.org/wizard.php  --tr-encoding
    curl --data-urlencode data=@o --header 'Expect: ' --insecure https://xdebug.org/wizard.php  --tr-encoding
    hs | grep curl >out

### See if you can post to wizard from cli

    php -i >o
    curl -L --insecure -X POST --data @o https://xdebug.org/wizard.php

    curl -X POST  -H 'Expect: 100' -L --insecure --data-raw @o https://xdebug.org/wizard.php -v \
        -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30"

#### log

    [Administrator@SBX3512E41:/c/tools/php]$ curl -L --insecure -X POST -d @o https://xdebug.org/wizard.php
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
     <head>
      <title>417 - Expectation Failed</title>
     </head>
     <body>
      417 - Expectation Failed
     </body>
    </html>
    [Administrator@SBX3512E41:/c/tools/php]$

remote debugging with xdebug
============================

-   <https://xdebug.org/docs/remote>

TODO install precompiled xdebug dll for windows
-----------------------------------------------

    php -i | pbcopy

feed that online wizard <https://xdebug.org/wizard.php> to provide link
to xdebug binary I need. Fixme: how can I automate feeding this using
curl?

    cd /c/tools/php
    cp php.ini-development php.ini

    cd /c/tools/php/ext
    curl --insecure -LO http://xdebug.org/files/php_xdebug-2.4.0rc4-7.0-vc14-nts.dll
    chmod 777 /c/tools/php/ext
    # add this to [PHP] section in /c/tools/php/php.ini
    zend_extension = C:\tools\php\ext\php_xdebug-2.4.0rc4-7.0-vc14-nts.dll

Summary

    Xdebug installed: no
    Server API: Command Line Interface
    Windows: yes - Compiler: MS VC14 - Architecture: x86
    Zend Server: no
    PHP Version: 7.0.2
    Zend API nr: 320151012
    PHP API nr: 20151012
    Debug Build: no
    Thread Safe Build: no
    Configuration File Path: unknown
    Configuration File: unknown
    Extensions directory: C:\php

    Download php_xdebug-2.4.0rc4-7.0-vc14-nts.dll
    Move the downloaded file to C:\php
    Create php.ini in the same folder as where php.exe is and add the line
    zend_extension = C:\php\php_xdebug-2.4.0rc4-7.0-vc14-nts.dll
    If you like Xdebug, and thinks it saves you time and money, please have a look at the donation page.

Precompiled Windows Modules
---------------------------

<https://xdebug.org/docs/install>

There are a few precompiled modules for Windows, they are all for the
non-debug version of PHP. You can get those at the download page. Follow
these instructions to get Xdebug installed.

-   <https://xdebug.org/download.php>
-   <https://xdebug.org/wizard.php>
-   <https://xdebug.org/download.php>
-   <https://xdebug.org/files/php_xdebug-2.4.0rc4-7.0-vc14-nts.dll>

install xdebug using pear pecl
------------------------------

<https://xdebug.org/docs/install>

As of Xdebug 0.9.0 you can install Xdebug through PEAR/PECL. This only
works with with PEAR version 0.9.1-dev or higher and some UNIX.

Installing with PEAR/PECL is as easy as:

    pecl install xdebug

### pecl install xdebug

    C:\Users\Administrator>pecl install xdebug
    downloading xdebug-2.3.3.tgz ...
    Starting to download xdebug-2.3.3.tgz (268,381 bytes)
    ........................................................done: 268,381 bytes
    74 source files, building
    ERROR: The DSP xdebug.dsp does not exist.

    C:\Users\Administrator>

### log

<http://pear.php.net/bugs/bug.php?id=17016>

    pecl config-set php_suffix .exe

WARNING: php~bin~ php.exe appears to have a suffix .exe, but config
variable php~suffix~ does not match

    WARNING: php_bin C:\tools\php\php.exe appears to have a suffix .exe, but config variable php_suffix does not match

    pecl install xdebug

    C:\Users\Administrator>pecl install xdebug
    downloading xdebug-2.3.3.tgz ...
    Starting to download xdebug-2.3.3.tgz (268,381 bytes)
    ........................................................done: 268,381 bytes
    74 source files, building
    WARNING: php_bin C:\tools\php\php.exe appears to have a suffix .exe, but config variable php_suffix does not match
    ERROR: The DSP xdebug.dsp does not exist.

    C:\Users\Administrator>

chocolatey installs php
=======================

log
---

    1-13, 'all' or Enter to continue:
    Beginning install...
    Configuration written to C:\windows\pear.ini...
    Initialized registry...
    Preparing to install...
    installing phar://C:/cygwin/tmp/install-pecl/go-pear.phar/PEAR/go-pear-tarballs/Archive_Tar-1.4.0.tar...
    installing phar://C:/cygwin/tmp/install-pecl/go-pear.phar/PEAR/go-pear-tarballs/Console_Getopt-1.4.1.tar...
    installing phar://C:/cygwin/tmp/install-pecl/go-pear.phar/PEAR/go-pear-tarballs/PEAR-1.10.1.tar...
    installing phar://C:/cygwin/tmp/install-pecl/go-pear.phar/PEAR/go-pear-tarballs/Structures_Graph-1.1.1.tar...
    installing phar://C:/cygwin/tmp/install-pecl/go-pear.phar/PEAR/go-pear-tarballs/XML_Util-1.3.0.tar...
    install ok: channel://pear.php.net/Archive_Tar-1.4.0
    install ok: channel://pear.php.net/Console_Getopt-1.4.1
    install ok: channel://pear.php.net/Structures_Graph-1.1.1
    install ok: channel://pear.php.net/XML_Util-1.3.0
    install ok: channel://pear.php.net/PEAR-1.10.1
    PEAR: Optional feature webinstaller available (PEAR's web-based installer)
    PEAR: Optional feature gtkinstaller available (PEAR's PHP-GTK-based installer)
    PEAR: Optional feature gtk2installer available (PEAR's PHP-GTK2-based installer)

    PEAR: To install optional features use "pear install pear/PEAR#featurename"

    ******************************************************************************
    WARNING!  The include_path defined in the currently used php.ini does not contain the PEAR PHP directory you just specified:
    <c:\tools\tmp\pear>
    If the specified directory is also not in the include_path used by
    your scripts, you will have problems getting any PEAR packages working.

    Current include path           : .;C:\php\pear
    Configured directory           : c:\tools\tmp\pear
    Currently used php.ini (guess) :
    Press Enter to continue:

    install ok: channel://pear.php.net/Console_Getopt-1.4.1
    install ok: channel://pear.php.net/Structures_Graph-1.1.1
    install ok: channel://pear.php.net/XML_Util-1.3.0
    install ok: channel://pear.php.net/PEAR-1.10.1
    PEAR: Optional feature webinstaller available (PEAR's web-based installer)
    PEAR: Optional feature gtkinstaller available (PEAR's PHP-GTK-based installer)
    PEAR: Optional feature gtk2installer available (PEAR's PHP-GTK2-based installer)

    PEAR: To install optional features use "pear install pear/PEAR#featurename"

    ******************************************************************************
    WARNING!  The include_path defined in the currently used php.ini does not
    contain the PEAR PHP directory you just specified:
    <c:\tools\tmp\pear>
    If the specified directory is also not in the include_path used by
    your scripts, you will have problems getting any PEAR packages working.

    Current include path           : .;C:\php\pear
    Configured directory           : c:\tools\tmp\pear
    Currently used php.ini (guess) :
    Press Enter to continue:

     ** WARNING! Old version found at c:\tools\tmp, please remove it or be sure to us
    e the new c:\tools\tmp\pear.bat command

    The 'pear' command is now at your service at c:\tools\tmp\pear.bat

     ** The 'pear' command is not currently in your PATH, so you need to
     ** use 'c:\tools\tmp\pear.bat' until you have added
     ** 'c:\tools\tmp' to your PATH environment variable.

    Run it without parameters to see the available actions, try 'pear list'
    to see what packages are installed, or 'pear help' for help.

    For more information about PEAR, see:

      http://pear.php.net/faq.php
      http://pear.php.net/manual/

    Thanks for using go-pear!



     * WINDOWS ENVIRONMENT VARIABLES *
    For convenience, a REG file is available under c:\tools\tmpPEAR_ENV.reg .
    This file creates ENV variables for the current user.

    Double-click this file to add it to the current user registry.


    C:\cygwin\tmp\install-pecl>

Add pear batch file to your path
--------------------------------

Add path to `c:\tools\tmp\pear.bat` to your user path

    powershell -noprofile -executionpolicy unrestricted -command "(new-object System.Net.WebClient).DownloadFile('http://dl.dropbox.com/u/9140609/sb/ephemeral/pathed.exe','pathed.exe')"
    pathed -a "c:\tools\tmp"
    pathed -a "c:\users\administrator\install-pecl"

Expect has not been ported to win64
-----------------------------------

-   <https://community.activestate.com/faq/where-expect>

teacup install Expect
---------------------

    teacup install Expect

    Microsoft Windows [Version 6.1.7601]
    Copyright (c) 2010 Microsoft Corporation.  All rights reserved.

    C:\Users\Administrator>teacup install Expect
    Resolving Expect ... [package Expect 5.43.2 win32-ix86 @ http://teapot.activestate.com]
    Resolving Tcl 8.4 -is package ... [package Tcl 8.6.4 _ ... Installed outside repository, probing dependencies]

    Retrieving package Expect 5.43.2 win32-ix86 ...@ http://teapot.activestate.com ... Ok

    Installing into C:/tools/activetcl/lib/teapot

    Installing package Expect 5.43.2 win32-ix86

    C:\Users\Administrator>teacup install Expect

curl download and run pear
--------------------------

-   <http://jason.pureconcepts.net/2012/10/install-pear-pecl-mac-os-x/>

<!-- -->

    curl -O http://pear.php.net/go-pear.phar
    php -d detect_unicode=0 go-pear.phar

example expect script to install pecl
-------------------------------------

-   <http://stackoverflow.com/a/7245893/1495086>
-   <http://docs.activestate.com/activetcl/8.4/expect4win>
-   <http://stackoverflow.com/a/30826746/1495086>

TODO find a way to get around installing activestate expect just to automate pecl
---------------------------------------------------------------------------------

dependendencies
---------------

    # for expect since go-pear.phar doesn't support commandline switches
    # Expect has not been ported to win64
    choco install activetcl --forcex86 -yes
    c:/tools/activetcl/bin/teacup install Expect
    choco install vcredist2015 -yes
    choco install php -yes

    git clone git@github.com:TaylorMonacelli/install-pecl
    cd install-pecl
    make test2 # FIXME: this fails

    make test2

### log

    [Administrator@SBX3512E41:~(master)]$ php --version
    PHP 7.0.2 (cli) (built: Jan  6 2016 13:04:42) ( NTS )
    Copyright (c) 1997-2015 The PHP Group
    Zend Engine v3.0.0, Copyright (c) 1998-2015 Zend Technologies
    [Administrator@SBX3512E41:~(master)]$

the chocolatey php installer will put path in your env path, but not into system path
-------------------------------------------------------------------------------------

    [Administrator@SBX3512E41:~(master)]$ cmd /c reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path

    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
        Path    REG_SZ    C:\windows\system32;C:\windows;C:\windows\System32\Wbem;C:\windows\System32\WindowsPowerShell\v1.0\;C:\ProgramData\chocolatey\bin;

    [Administrator@SBX3512E41:~(master)]$ cmd /c reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path | tr : '\n'

    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
        Path    REG_SZ    C
    \windows\system32;C
    \windows;C
    \windows\System32\Wbem;C
    \windows\System32\WindowsPowerShell\v1.0\;C
    \ProgramData\chocolatey\bin;

    [Administrator@SBX3512E41:~(master)]$ cmd /c "reg query hkcu\environment /v Path"

    HKEY_CURRENT_USER\environment
        Path    REG_SZ    C:\cygwin\bin;C:\tools\php;

    [Administrator@SBX3512E41:~(master)]$

