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
        
        --store 1011 in register 1
        constop_tb <= "1011";
        controlWord_tb <= "0001000000010011";
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --store 1010 in register 2
        constop_tb <= "1010";
        controlWord_tb <= "0001000000010101";
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --store 1001 in register 3
        constop_tb <= "1001";
        controlWord_tb <= "0001000000010111";
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --store 1000 in register 4
        constop_tb <= "1000";
        controlWord_tb <= "0001000000011001";
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --store 0111 in register 5
        constop_tb <= "0111";
        controlWord_tb <= "0001000000011011";
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --store 0110 in register 6
        constop_tb <= "0110";
        controlWord_tb <= "0001000000011101";
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --store 0101 in register 7
        constop_tb <= "0101";
        controlWord_tb <= "0001000000011111";
        clk_tb <= '1';
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        
        --format
        --regfile values registers [0:7]
        --[c, b, a, 9, 8, 7, 6, 5]
        
        
        --pass register 4 and store into register 6
        --result is reg6 = 8
        --[c b a 9 8 7 8 5]
        controlWord_tb <= "1000000000001101";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
         
        --add registers 2 and 5, store in 4
        --result = reg4 = 1
        --[c b a 9 1 7 8 5]
        
        controlWord_tb <= "0100101000101001";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --subtract register 7 from register 0, store reg 0
        --result = reg0 = 7
        --[7 b a 9 1 7 8 5]
        
        controlWord_tb <= "0000111000110001";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        
        --right shift register 1 and store in register 4
        --result = reg4 = 5
        --[7 b a 9 5 7 8 5]
        
        controlWord_tb <= "0010000001001001";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        
        
        --invert register 1 and store in register 1
        --result = reg1 = 0100
        --[7 4 a 9 5 7 8 5]
        
        controlWord_tb <= "0010000001010011";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        -- and reg 4 and register 3, store reg 7
        -- result = reg7 = 1
        --[7 4 a 9 5 7 8 1]
        
        controlWord_tb <= "1000011001101111";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        
        --total
        --[7 4 a 9 5 7 8 1]
        
        stop;
        
        
        
        
        --if B = 0, pass A, else pass 0
        
        --B != 0, pass 0
        --compare reg 4 with 0, store 0 into reg 6
        --result = [7 4 a 9 5 7 0 1]
        
        controlWord_tb <= "0110100001111101";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        
        --B = 0, pass and store a into reg 2
        --compare reg 6 with 0, store reg 3 in reg2
        --result = [7 4 9 9 5 7 0 1]
        
        controlWord_tb <= "0110110001110101";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        --if A = B, pass 1, else pass 0
        --compare reg 0 and 5, store 1 into reg 3
        --result [7 4 9 0 5 7 0 1]
        
        controlWord_tb <= "0000101010000111";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        
        -- A != B, store 0 in reg 0
        --compare register 1 and register 0
        --store 0 in reg 0
        --result [1 4 9 0 5 7 0 1]
        
        controlWord_tb <= "0010000010000001";
        clk_tb <= '1';
        
        wait for 10 ns;
        
        clk_tb <= '0';
        
        wait for 10 ns;
        
        
        stop;
        
        
        
        stop;
        
    end process;
    
end Behavioral;
