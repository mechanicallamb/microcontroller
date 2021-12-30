----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/29/2021 06:41:28 AM
-- Design Name: 
-- Module Name: branchLogic_TB - Behavioral
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

entity branchLogic_TB is
--  Port ( );
end branchLogic_TB;

architecture Behavioral of branchLogic_TB is


Component Branch_Logic_Unit is 

    generic(condition_bitlength : integer;
                pzn_bitlength : integer);
    
    port(
    
        condition : in std_logic_vector((condition_bitlength - 1) downto 0);
        poszeroneg : in std_logic_vector((pzn_bitlength - 1 ) downto 0);
        
        branch : out std_logic
         
         );


end component;


signal condition_tb : std_logic_vector(2 downto 0);
signal poszeroneg_tb : std_logic_vector(2 downto 0);
signal branch_tb : std_logic;

begin

    BLU_TB : branch_logic_unit generic map(
                                            condition_bitlength => 3,
                                            pzn_bitlength => 3
                                          )
                                          
                               port map(
                               
                                    condition => condition_tb,
                                    poszeroneg => poszeroneg_tb,
                                    branch => branch_tb
                               
                               );
                               
                               
    process
    
        begin
            
            
            condition_tb <= "111";
            poszeroneg_tb <= "000";
            
            wait for 5 ns;
            
            poszeroneg_tb <= "111";
            
            wait for 5 ns;
            
            poszeroneg_tb <= "101";
            
            wait for 5 ns;
            
            condition_tb <= "101";
            
            wait for 5 ns;
            
            poszeroneg_tb <= "001";
            
            wait for 5 ns;
            
            
            condition_tb <= "000";
            
            wait for 5 ns;
            condition_tb <= "001";
            
            wait for 5 ns;
            condition_tb <= "010";
            
            wait for 5 ns;
            condition_tb <= "011";
            
            wait for 5 ns;
            condition_tb <= "100";
            
            wait for 5 ns;
            condition_tb <= "101";
            
            wait for 5 ns;
            condition_tb <= "110";
            
            wait for 5 ns;
            condition_tb <= "111";
            
            wait for 5 ns;
            
            
            
            poszeroneg_tb <= "101";
            
            wait for 5 ns;
            
            
            condition_tb <= "000";
            
            wait for 5 ns;
            condition_tb <= "001";
            
            wait for 5 ns;
            condition_tb <= "010";
            
            wait for 5 ns;
            condition_tb <= "011";
            
            wait for 5 ns;
            condition_tb <= "100";
            
            wait for 5 ns;
            condition_tb <= "101";
            
            wait for 5 ns;
            condition_tb <= "110";
            
            wait for 5 ns;
            condition_tb <= "111";
            
            wait for 5 ns;
        
        
        
    end process;
                                


end Behavioral;
