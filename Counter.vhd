----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 02:16:34 AM
-- Design Name: 
-- Module Name: Counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter is
    
    generic(bitlength : integer);
    
    port(
    
        data_in : in std_logic_vector((bitlength - 1) downto 0);
        data_out : out std_logic_vector((bitlength - 1) downto 0);
        carry_out : out std_logic;
        
        asyn_reset : in std_logic;
        clk : in std_logic;
        load : in std_logic;
        count : in std_logic
        
            
    );
end Counter;

architecture Behavioral of Counter is

component reg is 
    
    generic (bitlength : integer);
    
    port(
        
        data_in : in std_logic_vector((bitlength - 1) downto 0);
        data_out : out std_logic_vector((bitlength - 1) downto 0);
        
        asyn_reset : in std_logic;
        clk : in std_logic;
        enable : in std_logic
        
    );
    
end component;

use work.mux_array_pkg.all;
component mux is

    generic(datalength : integer;
            selectorlength : integer);
    
    
    port(
        
        data_in : in mux_array(2** selectorlength - 1 downto 0)(datalength - 1 downto 0);--this line is required or mux outputs opposite value
                                                                                          --if you want data_in(0), it will give data_in(7)
                                                                                          --if there are 8 data in vectors and you try to access
                                                                                          --data_in(0) (and vice versa)
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_out : out std_logic_vector((datalength - 1) downto 0)
    
    );
    
end component;

signal data_in_to_mux : std_logic_vector(bitlength -1 downto 0) := (others => '0');
signal prev_reg_to_mux : std_logic_vector( bitlength - 1 downto 0) := (others => '0');
signal mux_to_reg : std_logic_vector(bitlength - 1 downto 0) := (others => '0');
signal reg_out : std_logic_vector(bitlength - 1 downto 0) := (others => '0');
signal modified_to_mux : std_logic_vector(bitlength - 1 downto 0) := (others => '0');
--signal data_out_from_reg : std_logic_vector(bitlength - 1 downto 0);
--signal carry_out_count : std_logic;

--signal clk_ent : std_logic;
--signal reset_ent : std_logic;
--signal load_count : std_logic;
--signal count_count : std_logic;

signal reg_enable : std_logic := '1';

begin

data_in_to_mux <= data_in;
data_out <= reg_out;
prev_reg_to_mux <= reg_out;


--data_out <= data_out_from_reg;
--carry_out_count <= carry_out;
--reset_ent <= asyn_reset;
--load_count <= load;

    COUNT_REG : reg generic map( bitlength => bitlength)
                    port map(
                        
                        data_in => mux_to_reg,
                        data_out => reg_out,
                        asyn_reset => asyn_reset,
                        clk => clk,
                        enable => reg_enable
                    
                    );
                    
                    
    INPUT_MUX : mux generic map( datalength => bitlength,
                                selectorlength => 1)
                                
                    port map(
                        
                        data_in(0) => modified_to_mux,
                        data_in(1) => data_in_to_mux,
                        
                        data_out => mux_to_reg,
                        selector => (0 => load,
                                    others => '0')
                    
                    );
    
        
                    
                    


    process(clk, asyn_reset)
    
        variable liminalcount : integer := 0;
        
        begin
    
        --incrememnt if load = 0 and count = 1
        --decrememnt if load = 1 and count = 1
        --load if load = 1 and count = 0
        --no-op if load = 0 and count = 0
        
        if asyn_reset = '1' then
            --data_in_to_reg <= (others => '0');
            reg_enable <= '1';
        
        elsif rising_edge(clk) and load = '1' and count = '0' then
            reg_enable <= '1';
            --data_in_to_mux <= data_in;
     
        elsif rising_edge(clk) and load = '0' and count = '1' then
            --add
            reg_enable <= '1';
            liminalcount := to_integer(unsigned(prev_reg_to_mux));
            liminalcount := liminalcount + 1;
            modified_to_mux <= std_logic_vector(to_unsigned(liminalcount, prev_reg_to_mux'length));
        
        elsif rising_edge(clk) and load = '0' and count = '0' then
            --subtract
            reg_enable <= '1';
            liminalcount := to_integer(unsigned(prev_reg_to_mux));
            liminalcount := liminalcount - 1;
            modified_to_mux <= std_logic_vector(to_unsigned(liminalcount, prev_reg_to_mux'length));
        
        elsif rising_edge(clk) and load = '1' and count = '1' then
            --no-op, disable register
            reg_enable <= '0';
        end if;
    
    end process;


end Behavioral;
