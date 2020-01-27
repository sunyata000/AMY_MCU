#!/bin/bash -f
 
#-------------------
#Clear old lib files
#------------------- 
vdel  -lib podesm0o_lib   -all
vlib  podesm0o_lib
vdel -lib work         -all
vlib  work 




#------------------------
#Complie verilog files to PODESM0O_LIB
#------------------------  
 vlog \
     -work podesm0o_lib   \
     -sv \
	 -novopt  \
     -f ../../src/PODES_M0O/PODES_M0O_filelist.f 


#------------------------
#Complie Amy files
#------------------------   

 vlog \
     -work work   \
     -timescale 1ps/1ps \
	 +define+SPEEDUP_SIM\
     -f ../../src/ahbbus/ahbbus_filelist.f \
     -f ../../src/peri/peri_vlog_filelist.f \
	 -v ../simlib/altera/altera_mf.v \
     -f ../../src/amy/AMY_filelist.f
	



#------------------------
#Load program
#------------------------
rm -f program.txt
cp ../testcase/$1/$1.txt program.txt
#cp ../testcase/$1/$1.txt ram32x4096_init.rif


#------------------------
#Compile testbench
#------------------------
vlog \
      -timescale 1ps/1ps\
      -sv \
      +incdir+../testbench \
      +incdir+../testbench/header \
      -work work   \
      -novopt \
	  ../testbench/uart_monitor.v \
      ../testbench/pc_tracking.v \
      ../testbench/testbench.v \
      ../testcase/$2.v


#------------------------
#Run simulation
#------------------------
 vsim    \
      -c \
      -l simulation.log \
      -novopt +notimingchecks \
      -L work  \
      -L podesm0o_lib \
      work.testbench \
      -do ../testbench/run_finish
  