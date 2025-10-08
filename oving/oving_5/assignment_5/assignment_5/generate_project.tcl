cd [file dirname [file normalize [info script]]]
set origin_dir "."
source -notrace [file normalize "${origin_dir}/../procedures.tcl"]

set project_name [suggested_project_name]

set top_design $project_name
set top_design_testbench "${top_design}_tb"
set IP_directory ""


set source_files [list \
	{*}[glob -nocomplain -directory [file normalize "$origin_dir/source/"] -type f *] \
	{*}[include_from_file $origin_dir [file normalize "$origin_dir/include.txt"]] \
]

set sim_files [list \
	{*}[glob -nocomplain -directory [file normalize "$origin_dir/testbench/"] -type f *]\
]

genProj $project_name $top_design $top_design_testbench $source_files $sim_files $IP_directory