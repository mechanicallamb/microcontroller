----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 12:33:56 AM
-- Design Name: 
-- Module Name: Register_File - Behavioral
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

entity Register_File is

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

end Register_File;

architecture Behavioral of Register_File is
    
 
    
    --components--
    component reg is
        generic(bitlength : integer);
        port(
                data_in : in std_logic_vector((bitlength - 1) downto 0);
                data_out : out std_logic_vector((bitlength - 1) downto 0);
                asyn_reset : in std_logic;
                enable : in std_logic;
                clk : in std_logic      
            );
    end component reg;
    
    use work.vector_array.all;
    component mux is 
    
        generic(datalength : integer;
                selectorlength : integer);
        
        port(
                data_in : in array_of_vect;
                selector : in std_logic_vector((selectorlength - 1) downto 0);
                data_out : out std_logic_vector((datalength - 1) downto 0)              
        );
    
    end component mux;
    
   
    component demux is
        
        generic(datalength : integer;
                selectorlength : integer);
    
        port(
            data_in : in std_logic_vector((datalength - 1) downto 0);
            selector : in std_logic_vector((selectorlength - 1 ) downto 0);
            data_out : out array_of_vect
            );
       
    end component demux;
    
    --signals--
    
    signal data_in_demux_to_regs : array_of_vect;
    signal data_from_regs_to_mux : array_of_vect;
    signal enableSignals : std_logic_vector(7 downto 0);

    
    
begin

    --test_demux <= data_in_demux_to_regs(0);

    REG_GEN: for I in 0 to 7 generate
        REGN: reg generic map(bitlength => 4) port map(
            data_in => data_in_demux_to_regs(I),
            data_out => data_from_regs_to_mux(I),
            clk => clk_regfile,
            asyn_reset => reset_regfile,
            enable => enableSignals(I)
            
        );
       end generate;
   
    DEMUX_DATA_GEN: demux generic map(datalength => 4,
                              selectorlength => 3)
                  port map(
                    data_in => Destination_Data,
                    selector => Destination_Address,
                    data_out(0) => data_in_demux_to_regs(0),
                    data_out(1) => data_in_demux_to_regs(1),
                    data_out(2) => data_in_demux_to_regs(2),
                    data_out(3) => data_in_demux_to_regs(3),
                    data_out(4) => data_in_demux_to_regs(4),
                    data_out(5) => data_in_demux_to_regs(5),
                    data_out(6) => data_in_demux_to_regs(6),
                    data_out(7) => data_in_demux_to_regs(7)
                    
              
                  );
                  
                  
    DEMUX_ADDRESS_GEN: demux generic map(datalength => 1,
                              selectorlength => 3)
                  port map(
                    data_in(0) => read_write,
                    selector => Destination_Address,
                    data_out(0)(0) => enableSignals(0),
                    data_out(1)(0) => enableSignals(1),
                    data_out(2)(0) => enableSignals(2),
                    data_out(3)(0) => enableSignals(3),
                    data_out(4)(0) => enableSignals(4),
                    data_out(5)(0) => enableSignals(5),
                    data_out(6)(0) => enableSignals(6),
                    data_out(7)(0) => enableSignals(7)
                  );
                  
                  
    MUX_A: mux generic map(datalength => 4,
                              selectorlength => 3)
                  port map(
                   data_in(0) => data_from_regs_to_mux(0),
                   data_in(1) => data_from_regs_to_mux(1),
                   data_in(2) => data_from_regs_to_mux(2),
                   data_in(3) => data_from_regs_to_mux(3),
                   data_in(4) => data_from_regs_to_mux(4),
                   data_in(5) => data_from_regs_to_mux(5),
                   data_in(6) => data_from_regs_to_mux(6),
                   data_in(7) => data_from_regs_to_mux(7),
                   
                   selector => Register_A_Address,
                   
                   data_out => Out_Data_A
                   
                   
                  );
                  
                  
     MUX_B: mux generic map(datalength => 4,
                              selectorlength => 3)
                  port map(
                  
                   data_in(0) => data_from_regs_to_mux(0),
                   data_in(1) => data_from_regs_to_mux(1),
                   data_in(2) => data_from_regs_to_mux(2),
                   data_in(3) => data_from_regs_to_mux(3),
                   data_in(4) => data_from_regs_to_mux(4),
                   data_in(5) => data_from_regs_to_mux(5),
                   data_in(6) => data_from_regs_to_mux(6),
                   data_in(7) => data_from_regs_to_mux(7),
                   
                   selector => Register_B_Address,
                   
                   data_out => Out_Data_B
                   
                  );
end Behavioral;
