STM32F0-Discovery Demo Application using FreeRTOSv7.5.2
=======================================================

This Eclipse project adds FreeRTOS to the demo application which comes
preloaded on the STM32F0-Discovery boards. It could serve as a template when
compiling programs for STM32F05xx ARM micro-controllers using arm-none-eabi-gcc.

Toolchain used:
[Code Sourcery G++:Lite Edition](http://www.mentor.com/embedded-software/sourcery-tools /sourcery-codebench/editions/lite-edition/).

Eclipse-CDT needs to be configured with the GNU ARM Eclipse plugin; helpful
instructions may be found from
[ODev](http://www.stf12.org/developers/ODeV.html#widget7).

Code Organization
-----------------

* All source files for this particular project (including main.c) are contained within the subfolder **Source/**.
  * **Source/system_stm32f0xx.c** is the place where system clocks are initialized. It comes out of an excel sheet developed by STM. The file included in this repository is taken from the STM32F0-Discovery firmware package.

* The **startup/** folder contains device specific files:
   * **startup_stm32f0xx.S** is the startup file taken from the STM32F0-Discovery firmware package.
   * Linker Script (**stm32f0.ld**) is a copy (with slight modifications) from one of the templates within the peripheral library.

* **OpenOCD/** contains a script file used to write the HEX image to the board via [OpenOCD](http://openocd.sourceforge.net/).

Externals
---------

### STM32F0xx_StdPeriph_Lib_V1.1.0

This is the standard peripheral driver library produced by STM--it can be
located as one of the application notes attached to the STM's micro-controller
specific support page. This project assumes that the folder containing the
sources for the peripheral library will be unpacked at the top level--i.e. as
a sibling of **Source/**.  It further requires adding the preprocessor macro
**USE_STDPERIPH_DRIVER** to Eclipse settings for building C and C++ sources.
The file '**stm32f0xx_conf.h**' is used to configure the peripheral library.
This has been placed under Sources. The file can be taken from one of the
several examples available with the peripheral library.

### FreeRTOS

Downloaded directly from [source](www.freertos.org) and placed at
**Source/FreeRTOS/**. The files for the ARM_CM0 port have been enabled in
Eclipse settings; together with one of the memory allocators. You might want
to take a look at FreeRTOSConfig.h.

### OpenOCD

OpenOCD needs to be compiled for STLINK support. Sources may be obtained by
cloning [the git repository](http://openocd.git.sourceforge.net/git/gitweb.cgi?p=openocd/openocd;a=summary). You can place this cloned folder anywhere.

Building the Project
--------------------

Eclipse makes this very simple if the GNU ARM plugin is installed. The
toolchain is discovered automatically (as long as it is available on the
PATH). You should import this as an existing project using
File->Import->General->Existing Project into Workspace.

Build creates a folder called 'Debug' containing makefile and the build
artifacts. Thereafter it is possible to run **make all** from the command line
directly from within the Debug folder. Note: if any configuration options or
build dependencies are changed, the makefile under **Debug** can be
regenerated from the Eclipse IDE.

Building the Debug configuration produces a **stm32f0-discovery.hex** binary
artifact under **Debug/**. This is the firmware which needs to be loaded on
the target.

Loading the image on the board
------------------------------

### Build OpenOCD

OpenOCD must be installed with stlink enabled. Clone [the git repository](http://openocd.git.sourceforge.net/git/gitweb.cgi?p=openocd/openocd;a=summary) and use these commands to compile/install it:

    ./bootstrap
    ./configure --prefix=/usr --enable-maintainer-mode --enable-stlink
    make

If there is an error finding the .cfg file, please double-check the
OPENOCD_BOARD_DIR constant at the top of the Makefile (in this template
directory, not in OpenOCD).

In my case, OpenOCD's sources (and binaries) resided under **<workspacedir>/openocd-code/**.

### UDEV Rule for the Discovery Board

If you are not able to communicate with the STM32F0-Discovery board without
root privileges you should follow the step from [the stlink repo readme file](https://github.com/texane/stlink#readme) for adding a udev rule for this
hardware.

### Finally

    $ <path_to_openocd-code>/src/openocd -s <path_to_openocd-code>/tcl/ -f interface/stlink-v2.cfg -f <path_to_openocd-code>/tcl/target/stm32f0x_stlink.cfg -f <path_to_project_folder>/OpenOCD/stm32_program.cfg


Acknowledgement
---------------

Sourced partly from https://github.com/szczys/stm32f0-discovery-basic-template/ which
is based on is based on [an example template for the F4 Discovery board](http://jeremyherbert.net/get/stm32f4_getting_started) put together by Jeremy Herbert.
