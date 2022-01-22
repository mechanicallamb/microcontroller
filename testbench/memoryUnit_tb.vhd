----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/22/2022 04:35:23 AM
-- Design Name: 
-- Module Name: memoryUnit_tb - Behavioral
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
use std.env.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memoryUnit_tb is
--  Port ( );
end memoryUnit_tb;

architecture Behavioral of memoryUnit_tb is
    
    component DATA_STORAGE is

         generic(
            
            addressWidth : integer;
            dataWidth : integer;
            data_init_file : string --for loading memory such as ROMs
            
            
         );
         
         port(
         
            address : in std_logic_vector(addressWidth - 1 downto 0);
            write_enable : in std_logic;
            clk : in std_logic;
            dataIn : in std_logic_vector(dataWidth - 1 downto 0);
            
            dataOut : out std_logic_vector(dataWidth - 1 downto 0)
         
         );
     
    end component;

    signal address_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal writeEn_tb : std_logic := '0';
    signal clk_tb : std_logic := '0';
    signal dataIn_tb : std_logic_vector(7 downto 0) := (others => '0');
    signal dataOut_tb : std_logic_vector(7 downto 0) := (others => '0');
    
    begin
    
    Data_storage_tb : DATA_STORAGE generic map(
                            
                            addressWidth => 4,
                            dataWidth => 8,
                            data_init_file => ""
    
                        )
                        port map(
                        
                            address => address_tb,
                            write_enable => writeEn_tb,
                            clk => clk_tb,
                            dataIn => dataIn_tb,
                            dataOut => dataOut_tb
                        
                        
                        );
     
     
        
     process
     
        begin
        
        --confirm memory is empty
        for I in 0 to 2 ** address_tb'length - 1 loop
            
            address_tb <= std_logic_vector((unsigned(address_tb) + 1));
            clk_tb <= not(clk_tb);
            wait for 2 ns;
            
            clk_tb <= not(clk_tb);
            wait for 2 ns;
            
        end loop;
            
        clk_tb <= '0';
        wait for 2 ns;
        
        --try to write with write disabled
        
        dataIn_tb <= "01101110";
        address_tb <= "0011";
        
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        wait for 10 ns;
        
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        wait for 10 ns;
        
        --try to write
        
        writeEn_tb <= '1';
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --write to every location
        
        address_tb <= "0000";
        dataIn_tb <= "00000001";
        
        for I in 0 to 2 ** address_tb'length - 1 loop
            
            address_tb <= std_logic_vector(unsigned(address_tb) + 1);
            dataIn_tb <= std_logic_vector(unsigned(dataIn_tb) + 1);
            clk_tb <= '1';
            wait for 10 ns;
            clk_tb <= '0';
            wait for 10 ns;
            
        end loop;
        
        --loop through again to check contents
        address_tb <= "0000";
        writeEn_tb <= '0';
        clk_tb <= '0';
        
        wait for 5 ns;
        for I in 0 to 2 ** address_tb'length - 1 loop
            
            clk_tb <= not(clk_tb);
            wait for 2 ns;
            address_tb <= std_logic_vector(unsigned(address_tb) + 1);
            clk_tb <= not(clk_tb);
            
        end loop;
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
     end process;
     
     
end Behavioral;
