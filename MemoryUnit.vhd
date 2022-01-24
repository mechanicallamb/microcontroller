----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/22/2022 02:19:20 AM
-- Design Name: 
-- Module Name: MemoryUnit - Behavioral
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
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DATA_STORAGE is

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
     
end DATA_STORAGE;

architecture Behavioral of DATA_STORAGE is

    type MEMORYTYPE is array(2**addressWidth - 1 downto 0) of bit_vector(dataWidth - 1 downto 0);
    impure function loadMemoryFromFile (filename : in string) return MEMORYTYPE is
        
        FILE memoryFile : text open read_mode is filename;
        variable RamFileLine : line;
        variable memoryUnit : MEMORYTYPE;
            
            
            begin
         
            for I in MEMORYTYPE'range loop
               readline (memoryFile, RamFileLine);
               read(RamFileLine, memoryUnit(I));
            end loop;
                
                return memoryUnit;
    end loadMemoryFromFile;
    
    impure function InitMemoryFromFile(filename : in string) return MEMORYTYPE is
            
            variable blankMemory : memoryType;
            
            begin
                if filename = "" then
                    blankMemory := (others => (others => '0'));
                    return blankMemory;
                else
                   return InitMemoryFromFile(filename);
                end if;
                
    end InitMemoryFromFile;
    
    
    --signal memoryData : MEMORYTYPE := initMemoryFromFile(data_init_file);
    signal memoryData : MEMORYTYPE := (others => (others => '0'));
begin

    process(clk)
    
        variable address_access : integer := 0;
        
        begin
        
            address_access := to_integer(unsigned(address));
            
            if(falling_Edge(clk) and write_enable = '1') then
                memorydata(address_access) <= to_bitVector(dataIn);
            elsif(rising_edge(clk)) then --or just make this asynchronus
                dataOut <= to_StdLogicVector(memoryData(address_access));
            else
                --do nothing
            end if;
            
     end process;

end Behavioral;


