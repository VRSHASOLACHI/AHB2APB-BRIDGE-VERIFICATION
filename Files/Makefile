UVM_HOME=$(MGLS_HOME)/verilog_src/uvm-1.2
QUESTA_UVM_HOME= $(MGLS_HOME)/verilog_src/questa_uvm_pkg-1.2
#VERILOG_FILES = sram_dut.sv sram_interface.sv sram_pkg.sv top.sv
#VERILOG_FILES = *.sv
VERILOG_FILES = design.sv interface.sv package.sv testbench.sv

UVM_FILES =  +incdir+${UVM_HOME}/src +define+UVM_NO_DEPRECATED +define+QUESTA ${UVM_HOME}/src/uvm.sv
UVM_DEBUG_FILES = +incdir+${QUESTA_UVM_HOME}/src ${QUESTA_UVM_HOME}/src/questa_uvm_pkg.sv ${UVM_HOME}/src/dpi/uvm_dpi.cc -ccflags "-DQUESTA"
UVM_DEBUG_OPTION = -classdebug -msgmode both -uvmcontrol=all 
TOPLEVEL = tb_top
UVM_VERBOSITY ?= UVM_HIGH
UVM_TESTNAME ?= my_test

help:
	@echo "Make targets:"
	@echo "> make questa_gui   	# Compile and run with Questa in GUI mode"
	@echo "> make questa_batch 	# Compile and run with Questa in batch mode"
	@echo "> make clean        	# Clean up all intermediate files"
	@echo "> make tar          	# Create a tar file for the current directory"
	@echo "> make help         	# This message"

# Questa section
questa_gui: 
	vlib work
	vmap work work
	vlog -64 +acc ${VERILOG_FILES} ${UVM_FILES} ${UVM_DEBUG_FILES} 
	vsim -64 ${UVM_DEBUG_OPTION} -L $(MGLS_HOME)/uvm-1.2 -do run.do ${TOPLEVEL}

questa_batch:  ${VERILOG_FILES} clean
	vlib work
	vmap work work
	vlog -64 +acc ${UVM_FILES} ${VERILOG_FILES}
	vsim -64 -c -L $(MGLS_HOME)/uvm-1.2 +UVM_VERBOSITY=$(UVM_VERBOSITY) +UVM_TESTNAME=$(UVM_TESTNAME) -do run.do ${TOPLEVEL} -sv_seed 5101

	vcover report -64 -all -details -annotate -output $(OUTPUTDIR)/cover.rpt test.ucdb
	vcover report -64 -details -annotate -instance=/testbench/dut -output $(OUTPUTDIR)/dut_cov.rpt -zeros test.ucdb
	vcover report -64 -details -annotate -du=sequence_detector -output $(OUTPUTDIR)/sequence_uncov.rpt -zeros test.ucdb
	vcover report -64 -annotate -hierarchical -output $(OUTPUTDIR)/cover_summary.rpt -zeros test.ucdb
	#vcover report -64 -annotate -cvg -details -output $(OUTPUTDIR)/cover_func.rpt -zeros test.ucdb
	#mv test.ucdb $(OUTPUTDIR)/test.ucdb



#############################################################################
# Housekeeping

DIR = $(shell basename `pwd`)

tar:	clean
	cd ..; \
	tar cvf ${DIR}.tar ${DIR}

clean:
	@# Questa stuff
	@rm -rf work transcript vsim.wlf
