@echo off
echo.
echo type everything in the modelsim cmd
echo.
:: gui one:
:: command line:
:: it has another flag before -novopt but i cant remember now
vsim -novopt work.MAC_4bit_tb 
:: inside modelsim
add wave -position insertpoint sim:/MAC_4bit_tb/MAC0/* 
run -all

:: cmd line ones:
:: it has another flag before -novopt but i cant remember now
:: command line:
vsim -c MAC_4bit
:: inside modelsim
vsim -novopt work.MAC_4bit_tb 
run -all
:: to re-run it
restart -f


