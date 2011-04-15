//
//  Copyright 2010 Deep IT. All rights reserved.
//

INSTRUCTION : http://deepit.ru/products/XcodeColors/info/
XcodeColors

XcodeColors is an easy-to-use plugin for Xcode 3 & 4 developers.

It was developed by Deep IT and it is absolutely free for any use (open source & commercial).
This project is designed to simplify software debugging process by colorizing debugger console output.
What's included:
XcodeColors - SIMBL plugin, unzip & install to ~/Library/Application Support/SIMBL/Plugins/
ColorSup - an example of a useful add-on (header and implementation) for advanced colored output
ColorLog - demo project (includes ColorSup add-on, XcodeColors needed)
Notes for developers still working under Mac OS X 10.5

SIMBL works just fine on 10.6, but old SIMBL compiled for 10.4 & 10.5 has no active GC, so it won't work with Xcode where GC is enabled, so our injection won't work either.
You can still use our solution with one additional step - manual patching via gdb. In that case you won't even need SIMBL. This method also works on 10.6 without SIMBL at all.
Just add the following code to the ~/.gdbinit:
define xcodecolors
 attach Xcode
	p (char)[[NSBundle bundleWithPath:@"~/Library/Application Support/SIMBL/Plugins/XcodeColors.bundle"] load]
 detach
end
then run Xcode, then gdb from the Terminal and type xcodecolors command in the gdb:
~ $ gdb -q
(gdb) xcodecolors
Attaching to process ...
Reading symbols for shared libraries ...
.. done
0x00007fff84d242fa in mach_msg_trap ()
$1 = 1 '\001'
(gdb) quit
This step is required only once after Xcode start.
Afraid of doing such changes?

Don't be!
The above instructions are now part of the history, as starting from version 1.0.6,
XcodeColors uses the standard Xcode plug-in format, so you can just unzip it to ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins, and rename to XcodeColors.xcplugin
For your convenience, here is the renamed version: XcodeColors.xcplugin
XcodeColors for Leopard and Snow Leopard DevTools
Language:	English
Version:	1.0.6 (September 27, 2010)
Size:	62 Kb
Requirements:	Mac OS X 10.5 or later
	Download XcodeColors Full
