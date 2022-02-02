transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/altera_projects/usbfunc {C:/altera_projects/usbfunc/Block1.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/usbfunc {C:/altera_projects/usbfunc/ls_usb_send.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/usbfunc {C:/altera_projects/usbfunc/ls_usb_recv.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/usbfunc {C:/altera_projects/usbfunc/ls_usb_core.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/usbfunc/db {C:/altera_projects/usbfunc/db/altiobuf0.v}
vlog -vlog01compat -work work +incdir+C:/altera_projects/usbfunc {C:/altera_projects/usbfunc/uart_cntlr.v}

vlog -vlog01compat -work work +incdir+C:/altera_projects/usbfunc/simulation/modelsim {C:/altera_projects/usbfunc/simulation/modelsim/Block1.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  block1

add wave *
view structure
view signals
run -all
