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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Program_Counter_Unit is
    
    generic(
    
        addressWidth : integer
    
    );
    
    port(
        load_pcu : in std_logic;
        count_pcu : in std_logic;
        J_Addr : in std_logic_vector((addressWidth - 1) downto 0);
        reset : in std_logic;
        clk : in std_logic;
        
        ready : out std_logic;
        next_addr : out std_logic_vector((addressWidth - 1) downto 0)
    
    );
    
end Program_Counter_Unit;

architecture Behavioral of Program_Counter_Unit is


    component counter is
        
        generic (bitlength : integer);
        port(
            data_in : in std_logic_vector((bitlength - 1) downto 0);
            data_out : out std_logic_vector((bitlength - 1) downto 0);
            carry_out : out std_logic;
            
            asyn_reset : in std_logic;
            clk : in std_logic;
            load : in std_logic;
            count : in std_logic
        );
    
    end component;
    
    component Comparator is
    
        generic(operandBitlength : integer;
                outputBitlength : integer);
                
        port(
            
            operandA : in std_logic_vector((operandBitlength - 1) downto 0);
            operandB : in std_logic_vector((operandBitlength - 1) downto 0);
            
            output : out std_logic_vector((outputBitlength - 1) downto 0)
            
            );
    
    
    end component;
    
    
    signal zero_wire : std_logic := '0';
    

begin
    
    

     ADDR_COUNTER: counter generic map(bitlength => addressWidth) 
     
        port map(
            
            data_in => J_Addr,
            data_out => next_addr,
            carry_out => zero_wire,
            
            asyn_reset => reset,
            clk => clk,
            load => load_pcu,
            count => count_pcu
            
        );
        
        
        process(next_addr)
        
        variable next_addrInt : integer := to_integer(unsigned(next_addr));
            begin
            
                if next_addrInt = 0 then
                    ready <= '1';
                    
                else
                    ready <= '0';
                    
                 end if;
                
        end process;




end Behavioral;
