-- Project Name: 
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 04:24:24 AM
-- Design Name: 
-- Module Name: Demux - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity ControlUnit is 
	
		generic(
		
			aluControlWordLength : integer;
			pznLength : integer;
			constOpLength : integer;
			instructionLength : integer; --input
			dataBitLength : integer; 
			addressSpaceBitLength : integer; --bits to address program memory (Program_Memory_ROM)
			microProgramAddressBitlength : integer; --num bits to access microOp program address (Program_Address_ROM)
			branchLogicPZNRegisterBitLength : integer; --bits held by PZN register
			branchLogicConditionLength : integer;
			
		);
		
				
		port(
				
		
		
		);
	

end entity;


architecture ControlUnitArch of ControlUnit is




	begin
	
	
	

end architecture;
