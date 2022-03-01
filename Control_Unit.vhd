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
	
		      -- opcode bitlength                      +
		      -- 1  B reg or constant                  +
		      -- 1  data from FU or RAM                +
		      -- 1 (read or write to D_ADDR)
		      
		      
		      
		    --Control Word Bit Description
			CU_aluControlWordWidth : integer;
			
			--controls stored in control word ROM which controls the entire processor, not just the ALU
			CU_procControlWordWidth : integer;
			
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
		    CU_ProgMemoryAddressBitWidth : integer; --number of bits to access micro instruction ROM memory
		    
		    --number of bits for each microinstruction encoding, from Top to bottom, MSB:LSB
		    --ProgMemoryMicroInstBitWidth =
                
                
                --If is not branch istruction
                    --[11]      is branch?
                    --[10:8]    reserved
                    --[7]       is write to ram?
                    --[6:0]     control word
                    
		        --If IS branch instruction
		           --[11]        is branch?
		           --[10:3]      next address
		           --[2:0]       branch condition
		        
		        
		    CU_ProgMemoryMicroInstBitWidth : integer;
		    
		    CU_regFileAddressWidth : integer
		    
		    
		    
		);
		
				
		port(
			
			CU_instruction : in std_logic_vector((CU_instructionWidth - 1) downto 0);
			CU_start : in std_logic;
			CU_clk : in std_logic;
			CU_reset : in std_logic;
			
			
			CU_constant : out std_logic_vector((CU_dataBitWidth - 1) downto 0);
			
			CU_aluControlWordOut : out std_logic_vector(CU_aluControlWordWidth - 1 downto 0);
		    
		    CU_MemoryWrite : out std_logic;
		    
		    CU_Ready : out std_logic;
		    
		    CU_branchConditionOut : out std_logic_vector(CU_branchLogicConditionWidth - 1 downto 0);
		    
		    CU_branchAddressOut : out std_logic_vector(CU_dataBitWidth - 1 downto 0);
		    
		    CU_alu_Addr_A : out std_logic_vector(CU_regFileAddressWidth - 1 downto 0);
		    CU_alu_Addr_D : out std_logic_vector(CU_regFileAddressWidth - 1 downto 0)
		
		);
	

end entity;


architecture ControlUnitArch of ControlUnit is

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

component DATA_STORAGE is

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
     
end component;



-----signals



    signal instruction : std_logic_vector(CU_instructionWidth - 1 downto 0) := (others => '0');
    signal instructionOpcode : std_logic_vector(CU_opcodeBitWidth - 1 downto 0) := (others => '0');
    signal instructionOpA : std_logic_vector(CU_registerAddressBitWidth - 1 downto 0) := (others => '0');
    signal instructionOpConst : std_logic_vector(CU_dataBitWidth - 1 downto 0) := (others => '0');
    signal instructionOPD : std_logic_vector(CU_registerAddressBitWidth - 1 downto 0) := (others => '0');
    
    signal operandARegister : std_logic_Vector(CU_registerAddressBitWidth - 1 downto 0) := (others => '0');
    signal operandConstRegister : std_logic_vector(CU_dataBitWidth - 1 downto 0) := (others => '0');
    signal operandDRegister : std_logic_vector(CU_registerAddressBitWidth - 1 downto 0) := (others => '0');
    
    signal reset : std_logic := '0';
    signal clk : std_logic := '0';
    signal memoryReadWrite : std_logic := '0';
    
    signal controlWordRomToRegister : std_logic_vector(CU_procControlWordWidth - 1 downto 0) := (others => '0');
    signal controlWordRegisterOut : std_logic_vector(CU_procControlWordWidth - 1 downto 0) := (others => '0');
    
    signal aluControlWord : std_logic_vector(CU_aluControlWordWidth - 1 downto 0) := (others => '0');
    signal branchConditionOut : std_logic_vector(CU_branchLogicConditionWidth - 1 downto 0) := (others => '0');
    signal branchAddressOut : std_logic_vector(CU_dataBitWidth - 1 downto 0) := (others => '0');
    
    signal romZeroWire : std_logic_vector(CU_opcodeBitWidth - 1 downto 0) := (others => '0');

	begin
	
	   --signal assignments
	   instruction <= CU_instruction;
	   instructionOpcode <= instruction(CU_instructionWidth - 1 downto CU_opcodeBitWidth);
	   instructionOpA <= instruction(CU_dataBitWidth + 2*CU_registerAddressBitWidth - 1 downto 
	                                                                       CU_dataBitWidth + CU_registerAddressBitWidth);
	                                                                       
	   instructionOpConst <= instruction(CU_dataBitWidth + CU_registerAddressBitWidth - 1 downto CU_registerAddressBitWidth);
	   instructionOpD <= instruction(CU_registerAddressBitWidth - 1 downto 0);
	   
	   reset <= CU_reset;
	   clk <= CU_clk;
	   memoryReadWrite <= controlWordRegisterOut(CU_aluControlWordWidth);
	   
	   aluControlWord <= controlWordRegisterOut(CU_aluControlWordWidth - 1 downto 0);
	   branchConditionOut <= controlWordRegisterOut(CU_branchLogicConditionWidth - 1 downto 0);
	   branchAddressOut <= controlWordRegisterOut(CU_branchLogicConditionWidth + CU_dataBitWidth - 1 
	                                                                           downto CU_branchLogicConditionWidth);
    `   
       CU_alu_Addr_A <= operandARegister;
	   CU_alu_addr_D <= operandDRegister;
	   CU_constant <= operandconstRegister;
	   
	   
	   CU_aluControlWordOut <= aluControlWord; 
	   CU_branchConditionOut <= branchConditionOut;
	   CU_branchAddressOut <= branchAddressOut;
	   
	   CU_MemoryWrite <= memoryReadWrite;
	   
	   
	   
	   REGA : reg generic map(bitLength => CU_registerAddressBitWidth)
	                   port map(
	                   
	                       data_in => instructionOPA,
	                       data_out => operandARegister,
                           clk => clk,
                           asyn_reset => reset,
                           enable => '1'
	                   ); 
	                   
	   REGConst : reg generic map(bitLength => CU_dataBitWidth)
	                   port map(
	                   
	                       data_in => instructionOPConst,
	                       data_out => operandConstRegister,
                           clk => clk,
                           asyn_reset => reset,
                           enable => '1'
	                   ); 
	                   
	                   
	   REGD : reg generic map(bitLength => CU_registerAddressBitWidth)
	                   port map(
	                   
	                       data_in => instructionOPD,
	                       data_out => operandDRegister,
                           clk => clk,
                           asyn_reset => reset,
                           enable => '1'
	                   ); 
        
        
--        REGControl : reg generic map(bitLength => CU_procControlWordWidth)
--	                   port map(
	                   
--	                       data_in => controlWordRomToRegister,
--	                       data_out => controlWordRegisterOut,
--                           clk => clk,
--                           asyn_reset => reset,
--                           enable => '1'
--	                   ); 


            ControlWordROM : DATA_STORAGE generic map(addressWidth => CU_opcodeBitWidth,
                                                        dataWidth => CU_procControlWordWidth,
                                                        data_init_file => "blank blank blank")
                                          port map(
                                                    address => instructionOpcode,
                                                    write_enable => '0',
                                                    clk => CU_clk,
                                                    dataIn => romZeroWire,
                                                    dataOut => controlWordRomToRegister
                                                   );
                                                    
end architecture;
