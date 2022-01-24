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
			CU_PZN : in std_logic_vector((CU_PZNwidth - 1) downto 0);
			
			
			CU_constant : out std_logic_vector((CU_dataBitWidth - 1) downto 0);
			
			CU_controlWord : out std_logic_vector(CU_aluControlWordWidth - 1 downto 0);
		    
		    CU_MemoryWrite : out std_logic;
		    
		    CU_Ready : out std_logic;
		    
		    CU_alu_Addr_A : out std_logic_vector(CU_regFileAddressWidth - 1 downto 0);
		    CU_alu_Addr_D : out std_logic_vector(CU_regFileAddressWidth - 1 downto 0)
		
		);
	

end entity;


architecture ControlUnitArch of ControlUnit is


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


end component mux;


use work.mux_array_pkg.all;
component demux is
    
    generic(datalength : integer;
            selectorlength : integer);
    
    port(
        data_in : in std_logic_vector((datalength - 1) downto 0);
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_out : out mux_array(2** selectorlength - 1 downto 0)(datalength - 1 downto 0)--this line is required or mux outputs opposite value
                                                                                          --if you want data_in(0), it will give data_in(7)
                                                                                          --if there are 8 data in vectors and you try to access
                                                                                          --data_in(0) (and vice versa)
        
    );
    
    
end component demux;


component Branch_Logic_Unit is

    generic(condition_bitlength : integer;
            pzn_bitlength : integer);
    
    port(
    
        condition : in std_logic_vector((condition_bitlength - 1) downto 0);
        poszeroneg : in std_logic_vector((pzn_bitlength - 1 ) downto 0);
        
        branch : out std_logic
         
         );
    
end component Branch_Logic_Unit;



component Program_Counter_Unit is
    
    generic(
    
            addressWidth : integer
            
            );
    
    port(
    
        mode : in std_logic;
        J_Addr : in std_logic_vector((addressWidth - 1) downto 0);
        reset : in std_logic;
        clk : in std_logic;
        
        ready : out std_logic;
        next_addr : out std_logic_vector((addressWidth - 1) downto 0)
    
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

signal instructionProgramAddress : std_logic_vector((CU_ProgRomAddressBitWidth - 1) downto 0); --instr bits 15:12
signal instructionRegA : std_logic_vector((CU_regfileAddressWidth - 1) downto 0); --instr bits 9:7
signal instructionConstC : std_logic_vector((CU_dataBitWidth - 1) downto 0); --instr bits 6:3
signal instructionRegD : std_logic_vector((CU_regfileAddressWidth - 1) downto 0); --instr bits 2:0

--carries the constant to send to alu
--signal constantMuxToALU : std_logic_vector((CU_dataBitWidth - 1) downto 0);
--signal constantMuxSelector : std_logic_vector(2 downto 0); --instruction only supports 3 constants

--program address to jump to
signal microProgramAddressOut : std_logic_vector((CU_ProgMemoryAddressBitWidth - 1) downto 0);

signal startSignal : std_logic; --begin next instruction?
signal clk_signal : std_logic; --clock
signal reset_signal : std_logic; --reset the microcontroller
signal ready_signal : std_logic; --program counter register

signal branchSignal : std_logic; --output of branch logic unit
signal programCounterMode : std_logic; --should the program address controller load a program address or incrememnt

--the next address to branch to when not incremmenting
signal nextAddressMuxOut : std_logic_vector((CU_ProgMemoryAddressBitWidth - 1) downto 0);

--the next microinstruction to execute (output of program counter unit)
signal nextMicroInstructionAddr : std_logic_vector((CU_ProgMemoryMicroInstBitWidth - 1) downto 0);

--instruction to execute next clock cycle
signal nextMicroInstruction : std_logic_vector((CU_instructionWidth - 1) downto 0);

signal controlWordOut : std_logic_vector(CU_aluControlWordWidth - 1 downto 0);

--the condition bits of a branching microinstruction
signal branchingMicroInstrCondition : std_logic_vector((CU_pznWidth - 1) downto 0);
--the address to branch to if the branch condition is true
signal branchingAddress : std_logic_vector((CU_ProgMemoryAddressBitWidth - 1) downto 0);

--the output of a branch instruction from the branch demux
signal branchDemuxOut : std_logic_vector((CU_ProgMemoryMicroInstBitWidth - 1) downto 0);

--input from ALU if last operation was pos, neg, or zero
signal pznEvaluationFromALUToPznReg : std_logic_vector((CU_pznWidth - 1) downto 0);

--input to branching logic unit from pzn_reg to determine if last operation was pos, neg, or zero
signal pznRegToBranchLogic : std_logic_vector((CU_pznWidth - 1) downto 0);

--signal alu_reg_A : std_logic_vector(CU_regFileAddressWidth - 1 downto 0);
--signal alu_reg_D : std_logic_vector(CU_regFileAddressWidth - 1 downto 0);

signal zero_wire : std_logic := '0';
signal one_wire : std_logic := '1';

--output of micro instruction out demux to be split and sent to the alu on a non-branch instruction
signal microInstDemuxControlOut : std_logic_vector(CU_ProgMemoryMicroInstBitWidth - 2 downto 0);

	begin
	   
	   instructionProgramAddress <= 
	                           CU_instruction((CU_instructionWidth - 1) downto
	                           (CU_instructionWidth - CU_ProgRomAddressBitWidth));

	   instructionRegD <= CU_instruction(CU_regFileAddressWidth - 1 downto 0);
	   instructionConstC <= CU_instruction(CU_regFileAddressWidth + CU_opcodeBitWidth - 1 downto 0);
	   instructionRegA <= CU_instruction(2*CU_regFileAddressWidth + CU_opcodeBitWidth - 1 downto 0);

	                           
	   controlWordOut <= microInstDemuxControlOut;
	   
	   controlWordOut(CU_aluControlWordWidth - 1 downto 0) <= CU_controlWord;                       
	   controlWordOut(CU_aluControlWordWidth) <= CU_MemoryWrite;
	  	   
	   
--	   constantMuxToALU <= CU_constant;
	   
	   
--	   constantMuxSelector <=   controlWordOut(
--	                                        (2 + CU_opcodeBitWidth +
--	                                         2 * CU_registerAddressBitWidth) - 1
	                                                    
--	                                                  downto 
	                                                   
--	                                        (2 + CU_opcodeBitWidth +
--	                                         1 * CU_registerAddressBitWidth));
	   
--	   ConstMux : mux generic map(
	                       
--	                       dataLength => CU_dataBitWidth,
--	                       selectorLength => CU_registerAddressBitWidth
	                               
--	                   )
	                   
--	                   port map(
	                   
--	                       data_in(1) => CU_instruction((CU_dataBitWidth * 3 - 1) downto
--	                           (CU_dataBitWidth * 2)),
--	                       data_in(2) => CU_instruction((CU_dataBitWidth * 2 - 1) downto
--	                           (CU_dataBitWidth * 1)),
--	                       data_in(3) => CU_instruction((CU_dataBitWidth * 1 - 1) downto
--	                           0),
	                       
	                           
--	                       selector => constantMuxSelector,
	                                  
	                       
--	                       data_out => constantMuxToAlu
	                      
--	                   );
        
        
        
        
        A_ADDRESS_REG : reg generic map(bitlength => CU_regfileAddressWidth)
                            port map(
                            
                                data_in => instructionRegA,
                                data_out => CU_alu_Addr_A,
                                
                                asyn_reset => CU_reset,
                                clk => CU_clk,
                                enable => one_wire
                            
                            
                            
                            );
                            
                            
        D_ADDRESS_REG : reg generic map(bitlength => CU_regfileAddressWidth)
                            port map(
                            
                                data_in => instructionRegA,
                                data_out => CU_alu_Addr_D,
                                
                                asyn_reset => CU_reset,
                                clk => CU_clk,
                                enable => one_wire
                            
                            
                            
                            );	   
                            
        CONSTOP_REG : reg generic map(bitlength => CU_dataBitWidth)
                            port map(
                            
                                data_in => instructionConstC,
                                data_out => CU_constant,
                                
                                asyn_reset => CU_reset,
                                clk => CU_clk,
                                enable => one_wire
                            
                            
                            
                            );	                            
                            
	    PROGRAM_ADDR_ROM : DATA_STORAGE generic map(addressWidth => CU_ProgRomAddressBitWidth,
	                                  dataWidth => CU_ProgMemoryAddressBitWidth,
	                                  data_init_file => "testbench_ProgramRomInit")
	                          
	                          port map(
	                                address => instructionProgramAddress,
	                                write_enable => zero_wire,
	                                clk => CU_clk,
	                                dataIn => (others => zero_wire),
	                                dataOut =>microProgramAddressOut
	                          );
	                          
	                          
	   
	    PROGRAM_INSTRUCTION_ROM : DATA_STORAGE generic map(addressWidth => CU_ProgMemoryAddressBitWidth,
	                                             dataWidth => CU_ProgMemoryMicroInstBitWidth,
	                                             data_init_file => "testbench_MicroInstROM_INIT")
                                       port map(
                                             address => nextMicroInstructionAddr,
                                             write_enable => zero_wire,
                                             clk => CU_clk,
                                             dataIn => (others => zero_wire),
                                             dataOut => nextMicroInstruction
                                       );
            
	   
	   --branchingAddress <= nextMicroInstruction(11 downto 4);
	   --branchingMicroInstrCondition <= nextMicroInstruction(14 downto 12);
	   AddressMux : mux generic map(datalength => CU_ProgMemoryMicroInstBitWidth,
	                                selectorLength => 1)
	                                
	                                port map(
	                                       data_in(0) => branchingAddress,
	                                       data_in(1) => microProgramAddressOut,
	                                       
	                                       selector(0) => CU_start,
	                                                   
	                                       
	                                       data_out => nextAddressMuxOut
	                                       
	                                       
	                                );
	   
	   programCounterMode <= CU_start or branchSignal;
	   CU_ready <= ready_signal;
	   ProgramCounter : Program_Counter_Unit generic map(
	                                   addressWidth => CU_ProgMemoryAddressBitWidth
	                               )
	                               
	                               port map(
	                                   
	                                   J_Addr => nextAddressMuxOut,
	                                   mode => programCounterMode,
	                                   reset => CU_reset,
	                                   clk => CU_clk,
	                                   ready => ready_signal,
	                                   next_Addr => nextMicroInstructionAddr
	                               
	                               );
	   
	   
	   --insert branching logic register here
	   
	   pznEvaluationFromALUToPznReg <= CU_PZN;
	   BranchConditionRegister : reg generic map(
	                               
	                               bitlength => CU_pznWidth
	                               
	                        )
	                        
	                        port map(
	                           
	                           data_in => pznEvaluationFromALUToPZNReg,
	                           data_out => pznRegToBranchLogic,
	                           
	                           asyn_reset => CU_reset,
	                           clk => CU_clk,
	                           enable => '1'
	                        
	                        );
	   
	   BranchLogic : Branch_Logic_Unit generic map(
	                                   
	                                   condition_bitlength => CU_branchLogicConditionWidth,
	                                   pzn_bitlength => CU_pznWidth
	                                   
	                                   )
	                                   
	                              port map(
	                              
	                                   condition => branchingMicroInstrCondition,
	                                   poszeroneg => pznRegToBranchLogic,
	                               
	                                   branch => branchSignal
	                              );



	   branchingMicroInstrCondition <= branchDemuxOut(CU_pznWidth - 1 downto 0);
	                                      	                              
	                              
	   branchingAddress <= branchDemuxOut(CU_ProgMemoryMicroInstBitWidth - 2 downto CU_pznWidth);
	   
                    
	                                      
	   MicroInstDemux : demux generic map(
                                       dataLength => CU_ProgMemoryMicroInstBitWidth - 1,
                                       selectorLength => 1
                                       )
	                               
	                               
	                               port map(
	                               
	                                   data_in => nextMicroInstruction(CU_progMemoryMicroInstBitWidth - 2 downto 0),
	                                   selector => (0 =>
	                                       nextMicroInstruction(CU_ProgMemoryMicroInstBitWidth - 1),
	                                       others => zero_wire),
	                                       
	                                   data_out(0) => microInstDemuxControlOut,
	                                   data_out(1) => branchDemuxOut
	                               
	                               
	                               );
	   
	   

end architecture;
