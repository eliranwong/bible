# DartBible
Bible Tools written in <a href="dart.dev">Dart programming language</a>.

Developed from version 2.4.0

# aim
To develop a set of cross-platform codes on bible tools

# objectives
To develop a command line version of bible app

To develop a cross-platform mobile app

# progress
The command line version is taking shape ...

At the moment, you may try commands like:

To open John 3:16 in KJV bible:
* dart bin/main.dart open KJV John 3:16

To open multiple verses (e.g. John 3:16-18, Rom 5:8, 3:23, 2Ti 3:14-16, Ge 1:5, 8, 13) in KJV bible:
* dart bin/main.dart open KJV John 3:16-18, Rom 5:8, 3:23, 2Ti 3:14-1, Ge 1:5, 8, 13

To search for verses containing "Christ Jesus":
* dart bin/main.dart search KJV Christ Jesus

To search for verses containing "Christ", followed by "Jesus" anywhere in the rest of the same verse:
* dart bin/main.dart search KJV Christ.*?Jesus

To compare John 3:16 in all installed bibles:
* dart bin/main.dart compare ALL John 3:16

To compare John 3:16 only in CUV and KJV:
* dart bin/main.dart compare CUV_KJV John 3:16

<i><b>Remarks:</b></i>
* Please use "," instead of ";" to separate verses in command lines.
* Common abbreviations are supported.
* Regular expression is turned on by default for searching bibles.  Use \ to escape characters like ()[].*? .

# siblings
For offline desktop version, we have:
UniqueBible.app at <a href="https://github.com/eliranwong/UniqueBible">https://github.com/eliranwong/UniqueBible</a>.

For online versions, iOS app, ...
Visit <a href="https://BibleTools.app">https://BibleTools.app</a> for more apps / information.
