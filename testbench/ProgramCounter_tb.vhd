----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/30/2021 06:59:10 AM
-- Design Name: 
-- Module Name: ProgramCounter_tb - Behavioral
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

entity ProgramCounter_tb is
--  Port ( );
end ProgramCounter_tb;

architecture Behavioral of ProgramCounter_tb is



component Program_Counter_Unit is
    
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
    
end component;


signal load_tb : std_logic := '0';
signal Jaddr_tb : std_logic_vector(7 downto 0) := "00010000";
signal reset_tb : std_logic := '0';
signal clk_tb : std_logic := '0';
signal count_tb : std_logic := '0';
signal ready_tb : std_logic;
signal nextAddr_tb : std_logic_vector(7 downto 0);

begin


    PCU_TB : program_counter_unit generic map(addressWidth => 8)
                                  port map(
                                  
                                    load_pcu => load_tb,
                                    J_Addr => Jaddr_tb,
                                    reset => reset_tb,
                                    count_pcu => count_tb,
                                    clk => clk_tb,
                                    ready => ready_tb,
                                    next_addr => nextAddr_tb
                                  
                                  );
                                       


    process
        
        begin
        
        reset_tb <= '1';
        wait for 5 ns;
        reset_tb <= '0';
        wait for 5 ns;
        --load
        load_tb <= '1';
        count_tb <= '0';
        
        wait for 5 ns;
        
        clk_tb <= '1';
        wait for 5 ns;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        --incrememnt
        load_tb <= '0';
        count_tb <= '1';
        clk_tb <= '1';
        wait for 5 ns;
        
        for i in 0 to 60 loop
            
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        --decrememnt
        count_tb <= '0';
        wait for 5 ns;
        
        clk_tb <= '1';
        wait for 5 ns;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        for i in 0 to 200 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        --nothing
        
        load_tb <= '1';
        count_tb <= '1';
        wait for 5 ns;
        
        for i in 0 to 20 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        --reset
        reset_tb <= '1';
        wait for 5 ns;
        
        --try to incrememnt
        count_tb <= '1';
        load_tb <= '0';
        
        for i in 0 to 100 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        --try to decrememnt
        count_tb <= '0';
        
        for i in 0 to 100 loop
            clk_tb <= not(clk_tb);
            wait for 100 ps;
        end loop;
        
        clk_tb <= '0';
        wait for 5 ns;
        
        --load 
        count_tb <= '0';
        load_tb <= '1';
        jaddr_tb <= "11001010";

        wait for 5 ns;
        
        clk_tb <= '1';
        wait for 5 ns;
        
        reset_tb <= '1';
        wait for 5 ns;
        
        
        
    end process;

end Behavioral;
