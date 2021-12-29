----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 04:42:48 AM
-- Design Name: 
-- Module Name: Register_4bit - Behavioral
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

entity regFileTB is

end entity;


architecture tb of regfiletb is


component Register_File is
    
    generic(
        datalength : integer;
        addrLength : integer
    );
    
    port(
        
        Destination_Data : in std_logic_vector(3 downto 0);
        Destination_Address : in std_logic_vector(2 downto 0);
        
        Register_A_Address : in std_logic_vector(2 downto 0);
        Register_B_Address : in std_logic_vector(2 downto 0);
        
        clk_regfile : in std_logic;
        reset_regfile : in std_logic;
        read_write : in std_logic; --write on 1
        
        Out_Data_A : out std_logic_vector(3 downto 0);
        Out_Data_B : out std_logic_vector(3 downto 0)
        
        --test_demux : out std_logic_vector(3 downto 0)
    );

end component;


signal destData : std_logic_vector(3 downto 0) := "0000";
signal destAddr : std_logic_vector(2 downto 0) := "000";
signal regA : std_logic_vector(2 downto 0) := "000";
signal regB : std_logic_vector(2 downto 0) := "000";
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal wr : std_logic := '0';
signal outA : std_logic_vector(3 downto 0) := "0000";
signal outB : std_logic_vector(3 downto 0) := "0000";

--signal testDemux : std_logic_vector(3 downto 0) := "0000";


begin



	REGF_TB : register_file generic map(
	                           datalength => 4,
	                           addrLength => 3
	
	                       )
	
	                       port map(
	
							destination_data => destData,
							destination_address => destAddr,
							register_A_address => regA,
							register_B_address => regB,
							clk_regfile => clk,
							reset_regfile => reset,
							read_write => wr,
							out_data_A => outA,
							out_data_B => outB
							--test_demux => testDemux
	
						);





	process
		begin
		
			--load every register with a different value
    		reset <= '1';
			clk <= '0';
			wait for 10 ns;
			
			clk <= '1';
			wait for 10 ns;
			
			reset <= '0';
			clk <= '0';
			wait for 10 ns;
			
			
			wr <= '1';
			destaddr <= "000";
			destdata <= "1111";
		clk <= '1';
		wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "001";
			destdata <= "1001";
			clk <= '1';
			wait for 10 ns;
			
			regA <= "001";
			regB <= "001";
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "010";
			destdata <= "0011";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "011";
			destdata <= "0111";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "100";
			destdata <= "1010";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "101";
			destdata <= "1100";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "110";
			destdata <= "0110";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "111";
			destdata <= "0101";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "000";
			destdata <= "1111";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
--			destaddr <= "011";
--			destdata <= "1111";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			
			--cycle through the registers
			wr <= '0';
			regA <= "000";
			regB <= "001";
			
			wait for 10 ns;
			
			regA <= "001";
			regB <= "010";
			
			wait for 10 ns;
			
			regA <= "010";
			regB <= "011";
			
			wait for 10 ns;
			
			regA <= "011";
			regB <= "100";
			
			wait for 10 ns;
			
			regA <= "100";
			regB <= "101";
			
			wait for 10 ns;
			
			regA <= "101";
			regB <= "110";
			
			wait for 10 ns;
			
			regA <= "110";
			regB <= "111";
			
			wait for 10 ns;
			
			regA <= "111";
			regB <= "000";
			
			wait for 10 ns;
			
			regA <= "011";
			regB <= "001";
			
			wait for 10 ns;
			
			wr <= '1';
			
			wait for 20 ns;
			
			wait for 20 ns;
			
			
			---test for assignment with reset high
			reset <= '1';
			
			wait for 20 ns;
			
			wr <= '1';
			destaddr <= "000";
			destdata <= "1111";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "001";
			destdata <= "1001";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "010";
			destdata <= "0011";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "011";
			destdata <= "0111";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "100";
			destdata <= "1010";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "101";
			destdata <= "1100";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "110";
			destdata <= "0110";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			destaddr <= "111";
			destdata <= "0101";
			clk <= '1';
			wait for 10 ns;
			
			clk <= '0';
			wait for 10 ns;
			
			
			--cycle through the registers
			wr <= '0';
			regA <= "000";
			regB <= "001";
			
			wait for 10 ns;
			
			regA <= "001";
			regB <= "010";
			
			wait for 10 ns;
			
			regA <= "010";
			regB <= "011";
			
			wait for 10 ns;
			
			regA <= "011";
			regB <= "100";
			
			wait for 10 ns;
			
			regA <= "100";
			regB <= "101";
			
			wait for 10 ns;
			
			regA <= "101";
			regB <= "110";
			
			wait for 10 ns;
			
			regA <= "110";
			regB <= "111";
			
			wait for 10 ns;
			
			regA <= "111";
			regB <= "000";
			
			wait for 10 ns;
			
			regA <= "000";
			regB <= "001";
			
			wait for 10 ns;
			
			
	end process;
	
	
	
	
	
end architecture;