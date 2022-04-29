@echo off
echo.
echo type everything in the modelsim cmd
echo.
echo now, we are running 8-bit!
echo.
:: inside modelsim
::echo vsim -novopt work.MAC_4bit_tb 
echo vsim -novopt work.MAC_8bit_tb 
echo.
echo run -all
echo.
echo to re-run it: restart -f
echo.

:: actual command execute from the cmd
::vsim -c MAC_4bit
vsim -c MAC_8bit

