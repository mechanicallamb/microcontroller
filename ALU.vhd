library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU_DATAPATH is

  
  port(
  
	--modify the port map to accept generic lengths
  
   ControlWord : in std_logic_vector(15 downto 0);
   --Control Word Bit Description
   -- [15:13] Reg File Address A for operand A
   -- [12] Operand B as constant (case 1) or operand B from reg file address B (case 0)
   -- [11:9] Address of regfile register B (regardless of assertion of bit 12)
   -- [8] Load data from memory flag (case 0: no store value from function unit) (case 1: load from ram into regfile address DA)
   -- [7:4] OPCODE for function unit
   -- [3:1] DA, the register to be written to on a write
   -- [0] read or write to register file (read on 0) (write on 1)
  
   
   
   
   
   constOp : in std_logic_vector(3 downto 0); 
   clk : in std_logic;
   reset : in std_logic;
   dataFromRam : in std_logic_vector(3 downto 0);
   
   addrOut : out std_logic_vector(3 downto 0);
   dataOut : out std_logic_vector(3 downto 0);
   PZN : out std_logic_vector(2 downto 0) --output is Positive, Zero, or Negative
   
   
   
  );

end entity;


architecture ALUArch of ALU_DATAPATH is

component Register_File is 

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
	
	);


end component;


use work.vector_array_d4w2.all;
component Mux is 

	generic(datalength : integer;
			selectorlength : integer);
			
			
	port(
	
	data_in : in array_of_vect; --this is not defined(?)
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_out : out std_logic_vector((datalength - 1) downto 0)
	
	);

end component;



component Functional_Unit is

	 generic(operandLength : integer;
            opcodeLength : integer;
            numFunctions : integer);
    
    port(
    
        valA : in std_logic_vector((operandLength - 1) downto 0);
        const : in std_logic_vector((operandLength - 1) downto 0);
        opcode : in std_logic_vector((opcodeLength - 1) downto 0);
        
        outVal : out std_logic_vector((operandLength - 1) downto 0);
        poszeroneg : out std_logic_vector(2 downto 0)
    );


end component;


begin





end ALUArch;
