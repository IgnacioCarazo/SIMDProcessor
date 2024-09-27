transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/mixColumns {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/mixColumns/mix_columns.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/sub_bytes.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/shift_rows.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/key_expansion.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/aes_operations_unit.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/sub_word.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/xor_32bit.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/add_round_key.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/common {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/common/s_box.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/mixColumns {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/executeStage/mixColumns/mix_column.sv}
vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/testBenches {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/testBenches/tb_aes_operations_unit.sv}

vlog -sv -work work +incdir+C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/testBenches {C:/cosas_nacho/GitHub/SIMDProcessor/proyecto2Arqui2/testBenches/tb_aes_operations_unit.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_aes_operations_unit

add wave *
view structure
view signals
run -all
