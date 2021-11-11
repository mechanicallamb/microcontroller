----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 12:33:28 AM
-- Design Name: 
-- Module Name: Program_Counter_Unit - Behavioral
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

entity Program_Counter_Unit is
    
    port(
        mode : in std_logic;
        J_Addr : in std_logic_vector(7 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        
        ready : out std_logic;
        next_addr : out std_logic_vector(7 downto 0)
    
    );
    
end Program_Counter_Unit;

architecture Behavioral of Program_Counter_Unit is


    component counter is
        
        generic (bitlength : integer);
        port(
            data_in_count : in std_logic_vector((bitlength - 1) downto 0);
            data_out_count : out std_logic_vector((bitlength - 1) downto 0);
            carry_out_count : out std_logic;
            
            asyn_reset_count : in std_logic;
            clk_count : in std_logic;
            load_count : in std_logic;
            count_count : in std_logic
        );
    
    end component;

begin


     ADDR_COUNTER: counter generic map(bitlength => 8) 
        port map(
            
            data_in_count => J_Addr,
            data_out_count => next_addr,
            carry_out_count => '0',
            
            asyn_reset_count => reset,
            clk_count => clk,
            load_count => mode,
            count_count => not(mode)
            
        );
        
        
        process
            begin
            
                if next_addr = (others => '0') then
                    ready <= '1';
                    
                else
                    ready <= '0';
                    
                 end if;
                
        end process;




end Behavioral;
