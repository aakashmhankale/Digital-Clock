
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name alarm -dir "D:/alarm/planAhead_run_1" -part xc7a100tcsg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/alarm/digi.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/alarm} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "digi.ucf" [current_fileset -constrset]
add_files [list {digi.ucf}] -fileset [get_property constrset [current_run]]
link_design
