###################################################################
# Makefile for Quartus
#
# 2016 by Sebastian Hahn, Christian Hoffmann
# 2017-2018 additional modifications by Christian Hoffmann
###################################################################

###################################################################
# Project Configuration:
#
# Specify the FPGA model, name of the design (project), Quartus-path,
# and the Quartus II settings file (.qsf)
###################################################################

###################################################################
# USB-Blaster chain connect Probleme
#
# Scheint so, als müsse die udev-lib v0 nach v1 gelinkt sein
# => ln -sf /lib/x86_64-linux-gnu/libudev.so.1.6.xx  /lib/x86_64-linux-gnu/libudev.so.0
# (xx durch die installierte Version ersetzen)
#
# evtl. auch noch folgende udev-rules hinzufügen:
# /etc/udev/rules.d/51-altera-usbblaster.rules
#
# SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666"
# SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666"
# SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", MODE="0666"
# SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", MODE="0666"
# SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE="0666"
###################################################################


FAMILY    	 = "Cyclone IV E"
PART      	 = EP4CE22F17C6
BOARDFILE 	 = assignments.dat
PROJECT 	 = MyProject
SRCS 		 = top_level.v
PATH := /opt/altera/12.1sp1/quartus/bin/:$(PATH)
PATH := /opt/altera/14.0/quartus/bin/:$(PATH)
PATH := /opt/altera/17.0/quartus/bin/:$(PATH)
PATH := /opt/altera/18.0/quartus/bin/:$(PATH)
PATH := /opt/altera/18.1/quartus/bin/:$(PATH)
PATH := /opt/altera/20.1/quartus/bin/:$(PATH)
TOP_LEVEL_ENTITY = top_level
ASSIGNMENT_FILES = $(PROJECT).qpf $(PROJECT).qsf


###################################################################
# Targets
#
# all:     build everything
# clean:   remove output files and database
# cleaner: remove even more files
# program: program your device with the compiled design
# upload:  write to EPCS64 (permanently)
# sim:	   iverilog compilation (no quartus)
# vhdl:    I don't remember why this. ;) -- creates simulation/ folder
###################################################################

###################################################################
# Argument-Lists
###################################################################

GLB_ARGS = --no_banner
MAP_ARGS = --read_settings_files=on $(addprefix --source=,$(SRCS))
FIT_ARGS = --part=$(PART) --read_settings_files=on
ASM_ARGS =
STA_ARGS =
JIC_ARGS = -c -d EPCS64 -s EP4CE22
PRG_ARGS = --mode=jtag 
UPL_ARGS = --mode=JTAG --cable="USB-Blaster" 


###################################################################
# Target definitions
###################################################################

all: 	$(ASSIGNMENT_FILES) asm sta

clean:
	rm -rf *.rpt *.chg *.htm *.eqn *.pin *.sof *.pof *.jdi *.summary *.sld *.smsg *.qws *.jic *.log *.done db incremental_db 

cleaner:	clean
	rm -rf *.qpf *.qsf *.qdf sim.vvp simulation/

program: all $(PROJECT).sof
	killall -9 jtagd 2> /dev/null ; true
	quartus_pgm $(GLB_ARGS) $(PRG_ARGS) -o "P;$(PROJECT).sof"

upload: jic $(PROJECT).jic
	killall -9 jtagd 2> /dev/null ; true
	quartus_pgm $(GLB_ARGS) $(UPL_ARGS) -o "pvbi;$(PROJECT).jic"

sim:
	iverilog -o sim.vvp *.v

vhdl:	all $(PROJECT).sof
	quartus_eda $(GLB_ARGS) $(PROJECT)

map: 	$(PROJECT).map.rpt
fit: 	$(PROJECT).fit.rpt
asm: 	$(PROJECT).asm.rpt
sta: 	$(PROJECT).sta.rpt $(PROJECT).sdc
jic: 	$(PROJECT).jic.rpt 

$(PROJECT).map.rpt: $(SRCS)
	quartus_map $(GLB_ARGS) $(MAP_ARGS) $(PROJECT)

$(PROJECT).fit.rpt: $(PROJECT).map.rpt
	quartus_fit $(GLB_ARGS) $(FIT_ARGS) $(PROJECT)

$(PROJECT).asm.rpt: $(PROJECT).fit.rpt
	quartus_asm $(GLB_ARGS) $(ASM_ARGS) $(PROJECT)

$(PROJECT).sta.rpt: $(PROJECT).fit.rpt
	quartus_sta $(GLB_ARGS) $(STA_ARGS) $(PROJECT)

$(PROJECT).jic.rpt: all $(PROJECT).sof
	quartus_cpf $(GLB_ARGS) $(JIC_ARGS) $(PROJECT).sof $(PROJECT).jic

$(ASSIGNMENT_FILES):
	quartus_sh --prepare -f $(FAMILY) -t $(TOP_LEVEL_ENTITY) $(PROJECT)
	echo >> $(PROJECT).qsf
	cat $(BOARDFILE) >> $(PROJECT).qsf
