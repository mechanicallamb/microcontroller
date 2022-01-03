----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/01/2022 04:11:24 AM
-- Design Name: 
-- Module Name: counter_tb - Behavioral
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

entity counter_tb is
--  Port ( );
end counter_tb;

architecture Behavioral of counter_tb is


component Counter is
    
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
end component;


signal dataIn_tb : std_logic_vector(3 downto 0) := (others => '0');
signal dataOut_tb : std_logic_vector(3 downto 0);
signal carryOut_tb : std_logic;

signal reset_tb : std_logic := '0';
signal clk_tb : std_logic := '0';
signal load_tb : std_logic := '0';
signal count_tb : std_logic := '0';



begin


    COUNTER_TB : counter generic map(bitlength => 4)
                        port map(
                        
                            data_in => dataIn_tb,
                            data_out => dataOut_tb,
                            carry_out => carryOut_tb,
                            asyn_reset => reset_tb,
                            clk => clk_tb,
                            load => load_tb,
                            count => count_tb
                        
                        );



    
    
    process
    

    
        begin
        

        
        
        --reset
        reset_tb <= '1';
        wait for 5 ns;
        
        --load value
        
        reset_tb <= '0';
        load_tb <= '1';
        wait for 5 ns;
        
        clk_tb <= '1';
        wait for 5 ns;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        --increment value
        
        load_tb <= '0';
        count_tb <= '1';
        clk_tb <= '1';
        wait for 5 ns;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        for i in 0 to 100 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        
        clk_tb <= '0';
        
        wait for 5 ns;
        
        --decrememnt
        load_tb <= '0';
        count_tb <= '0';
        
         for i in 0 to 100 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        
        clk_tb <= '0';
        
        wait for 5 ns;
        
        --no-op
        
        count_tb <= '1';
        load_tb <= '1';
        
        
        for i in 0 to 100 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        
        clk_tb <= '0';
        
        wait for 5 ns;
        
        --reset and attempt to modify
        load_tb <= '0';
        reset_tb <= '1';
        count_tb <= '1';
        
        for i in 0 to 100 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        
        clk_tb <= '0';
        
        wait for 5 ns;
        
        count_tb <= '0';
        
        for i in 0 to 100 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        
        clk_tb <= '0';
        
        wait for 5 ns;
        
        datain_tb <= "1111";
        count_tb <= '0';
        load_tb <= '1';
        wait for 5 ns;
        
        clk_tb <= '1';
        wait for 5 ns;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        reset_tb <= '0';
        wait for 5 ns;
        
        clk_tb <= '1';
        wait for 5 ns;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        reset_tb <= '1';
        wait for 5 ns;
        
        
    end process;

end Behavioral;
