-- Project Name: 
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 04:24:24 AM
-- Design Name: 
-- Module Name: Demux - Behavioral
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


entity ControlUnit is 
	
		generic(
		
		
			CU_instructionWidth : integer; --input (convert to sum?)
			CU_opcodeBitWidth : integer;
		  
		      --control word length =
		      -- regfileaddressBits (reg A)            +
		      -- 1 (constant or register value B)      +
		      -- regfileAddressBits (reg B)            +
		      -- 1 (store alu output or load from RAM) + 
		      -- opcode bitlength                      +
		      -- regfileAddress Bits (store register D)+
		      -- 1 (read or write)
		      
		      
		      
		    --Control Word Bit Description
	   -- [15:13] Reg File Address A for operand A
	   -- [12] Operand B as constant (case 1) or operand B from reg file address B (case 0)
	   -- [11:9] Address of regfile register B (regardless of assertion of bit 12)
	   -- [8] Load data from memory flag (case 0: no store value from function unit) (case 1: load from ram into regfile address DA)
	   -- [7:4] OPCODE for function unit
	   -- [3:1] DA, the register to be written to on a write
	   -- [0] read or write to register file (read on 0) (write on 1
			CU_aluControlWordWidth : integer;
			
			--control word
			--constOpLength : integer; = databitwidth
			CU_dataBitWidth : integer; 
			CU_registerAddressBitWidth : integer;
			
			--branch logic	
			CU_pznWidth : integer;		
			CU_branchLogicPZNRegisterBitWidth : integer; --bits held by PZN register
			CU_branchLogicConditionWidth : integer;
			
			
			--program address ROM
			CU_ProgRomAddressBitWidth : integer;
		    --width of program addresses is equal to progMemoryAddressBitWidth
		    
		    --program memory ROM
		    CU_ProgMemoryAddressBitWidth : integer; --number of bits to access ROM memory
		    
		    --number of bits for each microinstruction encoding, from Top to bottom, MSB:LSB
		    --ProgMemoryMicroInstBitWidth =
		    -- 1 (isBranchInstr?)             +
		    -- 1 (isPhysicalMemoryStore?)     +
		    -- registerAddressBitLength (reg A Addr) +
		    -- 1 (isOperandBConst?)           +
		    -- registerAddressBitLength (reg B Addr) +
		    -- 1 (loadDataFromMem?)           +
		    -- opcodeBitWidth                 +
		    -- registerAddressBitLength (reg D Addr) +
		    -- 1 (writeToRegFile?)
		  
		    CU_ProgMemoryMicroInstBitWidth : integer
		    
		    
		);
		
				
		port(
			
			CU_instruction : in std_logic_vector((CU_instructionWidth - 1) downto 0);
			CU_start : in std_logic;
			CU_clk : in std_logic;
			CU_reset : in std_logic;
			CU_PZN : in std_logic_vector((CU_PZNwidth - 1) downto 0);
			
			
			CU_constant : out std_logic_vector((CU_dataBitWidth - 1) downto 0);
			
			CU_controlWord : out std_logic_vector(
			          ((5 + CU_opcodeBitWidth + (CU_registerAddressBitWidth * 3)) - 1) 
			                             downto 0);
		    
		    CU_MemoryWrite : out std_logic;
		    
		    CU_Ready : out std_logic
		
		);
	

end entity;


architecture ControlUnitArch of ControlUnit is


use work.vector_array.all;
component mux is 

    generic(datalength : integer;
            selectorlength : integer);
    
    port(
        
            data_in : in array_of_vect; --this is not defined(?)
            selector : in std_logic_vector((selectorlength - 1) downto 0);
            
            data_out : out std_logic_vector((datalength - 1) downto 0)
    
    );


end component mux;


use work.vector_array.all;
component demux is
    
    generic(datalength : integer;
            selectorlength : integer);
    
    port(
        data_in : in std_logic_vector((datalength - 1) downto 0);
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_out : out array_of_vect
        
    );
    
    
end component demux;


component Branch_Logic_Unit is

    generic(condition_bitlength : integer;
            pnz_bitlength : integer;
            compres_bitlength : integer);
    
    port(
    
        condition : in std_logic_vector((condition_bitlength - 1) downto 0);
        poszeroneg : in std_logic_vector((pnz_bitlength - 1 ) downto 0);
        
        branch : out std_logic
         
         );
    
end component Branch_Logic_Unit;



component Program_Counter_Unit is
    
    port(
    
        mode : in std_logic;
        J_Addr : in std_logic_vector(7 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        
        ready : out std_logic;
        next_addr : out std_logic_vector(7 downto 0)
    
    );
    
end component Program_Counter_Unit;



component reg is 
    
    generic (bitlength : integer);
    
    port(
        
        data_in : in std_logic_vector((bitlength - 1) downto 0);
        data_out : out std_logic_vector((bitlength - 1) downto 0);
        
        asyn_reset : in std_logic;
        clk : in std_logic;
        enable : in std_logic
        
    );
    
end component reg;



-----signals

signal instructionProgramAddress : std_logic_vector((CU_ProgRomAddressBitWidth - 1) downto 0); --instr bits 15:12
signal instructionConstA : std_logic_vector((CU_dataBitWidth - 1) downto 0); --instr bits 11:8
signal instructionConstB : std_logic_vector((CU_dataBitWidth - 1) downto 0); --instr bits 7:4
signal instructionConstC : std_logic_vector((CU_dataBitWidth - 1) downto 0); --instr bits 3:0

--carries the constant to send to alu
signal constantMuxToALU : std_logic_vector((CU_dataBitWidth - 1) downto 0);
signal constantMuxSelector : std_logic_vector(2 downto 0); --instruction only supports 3 constants

--program address to jump to
signal microProgramAddressOut : std_logic_vector((CU_ProgMemoryAddressBitWidth - 1) downto 0);

signal startSignal : std_logic; --begin next instruction?
signal clk_signal : std_logic; --clock
signal reset_signal : std_logic; --reset the microcontroller
signal ready_signal : std_logic; --program counter register

signal branchSignal : std_logic; --output of branch logic unit
signal branchMode : std_logic; --should the program address controller load a program address or incrememnt

--the next address to branch to when not incremmenting
signal nextAddressMuxOut : std_logic_vector((CU_ProgMemoryAddressBitWidth - 1) downto 0);

--the next microinstruction to execute (output of program counter unit)
signal nextMicroInstructionAddr : std_logic_vector((CU_ProgMemoryMicroInstBitWidth - 1) downto 0);

--instruction to execute next clock cycle
signal nextMicroInstruction : std_logic_vector((CU_instructionWidth - 1) downto 0);

signal controlWordOut : std_logic_vector((CU_aluControlWordWidth - 1) downto 0);

--the condition bits of a branching microinstruction
signal branchingMicroInstrCondition : std_logic_vector((CU_pznWidth - 1) downto 0);
--the address to branch to if the branch condition is true
signal branchingAddress : std_logic_vector((CU_ProgMemoryAddressBitWidth - 1) downto 0);

--input from ALU if last operation was pos, neg, or zero
signal pznEvaluationFromALUToPznReg : std_logic_vector((CU_pznWidth - 1) downto 0);

--input to branching logic unit from pzn_reg to determine if last operation was pos, neg, or zero
signal pznRegToBranchLogic : std_logic_vector((CU_pznWidth - 1) downto 0);



	begin
	
	
	

end architecture;
