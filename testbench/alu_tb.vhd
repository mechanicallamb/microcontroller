----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/08/2022 07:20:31 AM
-- Design Name: 
-- Module Name: alu_tb - Behavioral
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
use std.env.stop;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu_tb is
--  Port ( );
end alu_tb;

architecture Behavioral of alu_tb is


    component ALU_DATAPATH is
      generic(
      
        controlWordWidth_alu : integer;
        regAddressWidth_alu : integer;
        dataWidth_alu : integer;
        opcodeWidth_alu : integer;
        pznWidth_alu : integer
      );
      
      port(
      
            --modify the port map to accept generic lengths
          
           ControlWord : in std_logic_vector(controlWordWidth_alu - 1 downto 0);
    
           --ControlWord : in std_logic_vector(15 downto 0);
           --Control Word Bit Description
           -- [15:13] Reg File Address A for operand A
           -- [12] Operand B as constant (case 1) or operand B from reg file address B (case 0)
           -- [11:9] Address of regfile register B (regardless of assertion of bit 12)
           -- [8] Load data from memory flag (case 0: no store value from function unit) (case 1: load from ram into regfile address DA)
           -- [7:4] OPCODE for function unit
           -- [3:1] DA, the register to be written to on a write
           -- [0] read or write to register file (read on 0) (write on 1)
          
    
           constOp : in std_logic_vector(opcodeWidth_alu - 1 downto 0); 
           clk : in std_logic;
           reset : in std_logic;
           dataFromRam : in std_logic_vector(dataWidth_alu - 1 downto 0);
           
           addrOut : out std_logic_vector(dataWidth_alu - 1 downto 0);
           dataOut : out std_logic_vector(dataWidth_alu  - 1 downto 0);
           PZN : out std_logic_vector(pznWidth_alu - 1 downto 0) --output is Positive, Zero, or Negative
       
       
       
      );
    
    
    
    end component;

    signal controlWord_tb : std_logic_vector(15 downto 0) := (others => '0');
    signal constop_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal dataFromRam_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal addrOut_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal dataOut_tb : std_logic_vector(3 downto 0) := (others => '0');
    signal PZN_tb : std_logic_vector(2 downto 0) := (others => '0');
    
begin

    ALU_DATAPATH_TB : alu_datapath generic map(
                                        controlWordWidth_alu => 16,
                                        regAddressWidth_alu => 3,
                                        dataWidth_alu => 4,
                                        opcodeWidth_alu => 4,
                                        pznWidth_alu => 3
    
                                )
                                
                                port map(
                                    
                                    ControlWord => ControlWord_tb,
                                    constOp => constop_tb,
                                    clk => clk_tb,
                                    reset => reset_tb,
                                    dataFromRam => dataFromRam_tb,
                                    addrOut => addrOut_tb,
                                    dataOut => dataOut_tb,
                                    pzn => PZN_TB
                                
                                
                                );
                                                       
                                
     process
        begin
    
        constop_tb <= "0000";
        clk_tb <= '0';
        reset_tb <= '0';
        
        
        
        controlWord_tb <= (others => '0');
        
        wait for 10 ns;
        
        --store a value in each register
        
        --store 1100 in register 0
        constop_tb <= "1100";
        controlWord_tb <= "0001000000010001";
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        clk_tb <= '1';
        
        wait for 10 ns;
        
        stop;
        
    end process;
    
end Behavioral;
