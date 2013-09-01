STM32F0-Discovery Application Template
======================================

Sourced from https://github.com/szczys/stm32f0-discovery-basic-template/ which
is based on is based on [an example template for the F4 Discovery board](http://jeremyherbert.net/get/stm32f4_getting_started) put together by
Jeremy Herbert.

This Eclipse project is for use when compiling programs for STM32F05xx ARM
microcontrollers using arm-none-eabi-gcc. I'm using the
[Code Sourcery G++:Lite Edition](http://www.mentor.com/embedded-software/sourcery-tools /sourcery-codebench/editions/lite-edition/) toolchain. I configured Eclipse-
CDT with the GNU ARM Eclipse plugin based on instructions from
[ODev](http://www.stf12.org/developers/ODeV.html#widget7)--as a result, the
Makefile gets generated automatically by Eclipse.

Subfolders:
-----------

1. **STM32F0xx_StdPeriph_Lib_V1.1.0/**
   * This is the standard peripheral driver library produced by STM. It requires adding the preprocessor macro USE_STDPERIPH_DRIVER to settings for building C and C++ sources.

   * The file '**stm32f0xx_conf.h**' is used to configure the peripheral library. This has been placed under Sources. The file can be taken from one of the several examples available with the peripheral library.

2. startup/
   * Folder contains device specific files:
   * **startup_stm32f0xx.S** is the startup file taken from the STM32F0-Discovery firmware package.
   * Linker Script (**stm32f0.ld**)

4. Source/
   * All source files for this particular project (including main.c).
   * **system_stm32f0xx.c** can be generated using an XLS file developed by STM. This sets up the system clock values for the project. The file included in this repository is taken from the STM32F0-Discovery firmware package. It is found in the following directory:
      * Libraries/CMSIS/ST/STM32F0xx/Source/Templates/

5. OpenOCD/
   * This contains a procedure file used to write the image to the board via OpenOCD

Building the Project
--------------------

Eclipse makes this very simple if the GNU ARM plugin is installed. The
toolchain is discovered automatically (as long as it is available on the
PATH). You should import this as an existing project using
File->Import->General->Existing Project into Workspace.

Build creates a folder called 'Debug' containing makefile and the build
artifacts. Thereafter it is possible to run **make all** from the command line
directly from within the Debug folder. Note: if any configuration opitons or
build dependencies are changed, the makefile under **Debug** can be
regenerated from the Eclipse IDE.

Building the Debug configuration produces a **stm32f0-discovery.hex** binary
artifact under Debug. This is the firmware which needs to be loaded on the
target.

Loading the image on the board
------------------------------

Build OpenOCD
~~~~~~~~~~~~~

OpenOCD must be installed with stlink enabled. Clone [the git repository](http://openocd.git.sourceforge.net/git/gitweb.cgi?p=openocd/openocd;a=summary) and use these commands to compile/install it:

    ./bootstrap
    ./configure --prefix=/usr --enable-maintainer-mode --enable-stlink
    make 

If there is an error finding the .cfg file, please double-check the
OPENOCD_BOARD_DIR constant at the top of the Makefile (in this template
directory, not in OpenOCD).

In my case, OpenOCD's sources (and binaries) resided under **<workspacedir>/openocd-code/**.

UDEV Rule for the Discovery Board
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are not able to communicate with the STM32F0-Discovery board without
root privileges you should follow the step from [the stlink repo readme file](https://github.com/texane/stlink#readme) for adding a udev rule for this
hardware.

Finally
~~~~~~~

    $ <path_to_openocd-code>/src/openocd -s <path_to_openocd-code>/tcl/ -f interface/stlink-v2.cfg -f <path_to_openocd-code>/tcl/target/stm32f0x_stlink.cfg -f <path_to_project_folder>/OpenOCD/stm32_program.cfg
