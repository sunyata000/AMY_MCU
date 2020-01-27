#!/bin/bash -f
 
#-------------------
#Clear old lib files
#------------------- 
vdel  -lib podesm0o_lib   -all
vlib  podesm0o_lib
vdel -lib work         -all
vlib  work 



#------------------------
#get the argvs
#------------------------
#while ($#argv)
#      switch ($1)
#      case "-prog":
#              set PROG_FILE = $2
#              if (! -e testcase/$PROG_FILE/$PROG_FILE.txt) then
#                  echo "$PROG_FILE.txt doesnot exit...."
#                  exit 1
#              endif
#              shift; shift; breaksw
#      case "-help":
#             echo "## make_simv.csh :"
#             echo "## %> make_simv.csh \"
#             echo "## -prog <program name> \"
#             echo "## -test <test case name> \"
#             echo " "
#             shift; breaksw
#      case "-test":
#             set TEST_CASE = $2
#              if (! -e testcase/$TEST_CASE.v) then
#                  echo "$TEST_CASE.v doesnot exit...."
#                  exit 1
#              endif
#              shift; shift; breaksw
#      default:
#              echo "ARGVs don't exit...."
#              exit 1
#              breaksw
#      endsw
#end
             


#------------------------
#Complie verilog files to PODESM0O_LIB
#------------------------  
 vlog \
     -work podesm0o_lib   \
     -novopt -incr\
     -f ../../src/PODES_M0O/proc_unit/proc_unit_filelist.f \
     -f ../../src/PODES_M0O/PODES_M0O_filelist.f 


#------------------------
#Complie Amy files
#------------------------   

 vlog \
     -work work   \
     -timescale 1ps/1ps \
     -f ../../src/peripherals/peri_vlog_filelist.f 
     
 vlog \
     -work work   \
      +define+USE_RIF \
      +define+AHB_EMU \
	  -v ../simlib/altera/altera_mf.v \
     -f ../../src/AMY_filelist.f

 





#------------------------
#Load program
#------------------------
rm -f program.txt
cp ../testcase/$1/$1.txt ram32x4096_init.rif


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
  