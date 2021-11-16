----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 12:32:39 AM
-- Design Name: 
-- Module Name: Branch_Logic_Unit - Behavioral
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

entity Branch_Logic_Unit is
    generic(condition_bitlength : integer;
            pnz_bitlength : integer;
            compres_bitlength : integer);
    
    port(
    
        condition : in std_logic_vector((condition_bitlength - 1) downto 0);
        poszeroneg : in std_logic_vector((pnz_bitlength - 1 ) downto 0);
        
        branch : out std_logic
         
         );
    
end Branch_Logic_Unit;

architecture Behavioral of Branch_Logic_Unit is

use work.vector_array_d1w8.all;
component mux is

    generic(datalength : integer;
            selectorlength : integer);
            
    port(
        
        data_in : in array_of_vect;
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_out : out std_logic_vector((datalength - 1) downto 0)
    
    
    );
   


end component mux;


signal mux_in : std_logic_vector(7 downto 0);

begin

   BRA_MUX: mux generic map(datalength => 1, selectorlength => 3)
                port map(
                    
                    data_in(0)(0) => mux_in(0),
                    data_in(1)(0) => mux_in(1),
                    data_in(2)(0) => mux_in(2),
                    data_in(3)(0) => mux_in(3),
                    data_in(4)(0) => mux_in(4),
                    data_in(5)(0) => mux_in(5),
                    data_in(6)(0) => mux_in(6),
                    data_in(7)(0) => mux_in(7),
                    
                    selector => condition,
                    
                    data_out(0) => branch
                    
                );
                
                
                
                mux_in(0) <= '0';
                mux_in(1) <= poszeroneg(0);
                mux_in(2) <= poszeroneg(1);
                mux_in(3) <= poszeroneg(0) OR poszeroneg(1);
                mux_in(4) <= poszeroneg(2);
                mux_in(5) <= poszeroneg(2) OR poszeroneg(0);
                mux_in(6) <= poszeroneg(2) OR poszeroneg(1);
                mux_in(7) <= '1';

end Behavioral;
