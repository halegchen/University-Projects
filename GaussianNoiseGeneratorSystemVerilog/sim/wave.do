onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /noise_tb/CK
add wave -noupdate /noise_tb/RB
add wave -noupdate /noise_tb/ST
add wave -noupdate -radix unsigned /noise_tb/p_addr
add wave -noupdate -radix unsigned /noise_tb/q_addr
add wave -noupdate -radix unsigned /noise_tb/r_addr
add wave -noupdate -radix unsigned /noise_tb/s_addr
add wave -noupdate -radix unsigned /noise_tb/trans/ram_pool/ad1
add wave -noupdate -radix unsigned /noise_tb/trans/ram_pool/ad2
add wave -noupdate /noise_tb/trans/ram_pool/ce1
add wave -noupdate /noise_tb/trans/ram_pool/ce2
add wave -noupdate -radix unsigned /noise_tb/trans/ram_pool/di1
add wave -noupdate /noise_tb/trans/ram_pool/we1
add wave -noupdate /noise_tb/trans/cnt3
add wave -noupdate -radix unsigned /noise_tb/trans/ram_pool/dq1
add wave -noupdate -radix unsigned /noise_tb/trans/ram_pool/dq2
add wave -noupdate /noise_tb/trans/ram_pool/we2
add wave -noupdate -radix unsigned /noise_tb/trans/ram_pool/di2
add wave -noupdate -radix hexadecimal /noise_tb/trans/ram_pool/mem
add wave -noupdate /noise_tb/trans/init
add wave -noupdate /noise_tb/trans/sel_addr
add wave -noupdate /noise_tb/trans/sel_ram
add wave -noupdate /noise_tb/trans/rom_init/cen
add wave -noupdate -radix unsigned /noise_tb/trans/rom_init/adr
add wave -noupdate -radix hexadecimal /noise_tb/trans/rom_init/dout
add wave -noupdate -radix unsigned /noise_tb/trans/A_o
add wave -noupdate -radix unsigned /noise_tb/trans/B_o
add wave -noupdate -radix unsigned /noise_tb/trans/r1
add wave -noupdate -radix unsigned /noise_tb/trans/r2
add wave -noupdate -radix unsigned /noise_tb/trans/r3
add wave -noupdate -radix unsigned /noise_tb/trans/r33
add wave -noupdate -radix unsigned /noise_tb/trans/r4
add wave -noupdate -radix unsigned /noise_tb/trans/rt
add wave -noupdate -radix unsigned /noise_tb/trans/rp
add wave -noupdate -radix unsigned /noise_tb/trans/rq
add wave -noupdate -radix unsigned /noise_tb/trans/rr
add wave -noupdate -radix unsigned /noise_tb/trans/rs
add wave -noupdate -radix unsigned /noise_tb/trans/rpo
add wave -noupdate -radix unsigned /noise_tb/trans/rqo
add wave -noupdate -radix unsigned /noise_tb/trans/rro
add wave -noupdate -radix unsigned /noise_tb/trans/rso
add wave -noupdate -radix unsigned /noise_tb/C
add wave -noupdate /noise_tb/trans/sel_pqrs
add wave -noupdate /noise_tb/trans/sel_C
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10368 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {10330 ns} {10424 ns}
