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


	use work.mux_array_pkg.all;
	component Mux is 

		generic(datalength : integer;
				selectorlength : integer);


		port(

			data_in : in mux_array; --this is not defined(?)
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
			valB : in std_logic_vector((operandLength - 1) downto 0);
			opcode : in std_logic_vector((opcodeLength - 1) downto 0);

			outVal : out std_logic_vector((operandLength - 1) downto 0);
			poszeroneg : out std_logic_vector(2 downto 0)
	    );


	end component;



	signal regToFU_OpA : std_logic_vector(3 downto 0); --operand A from regfile
	signal regToMux_OpB : std_logic_vector(3 downto 0); --operand B from regfile
	--signal constToMux : std_logic_vector(3 downto 0); --redundant but added anyways
	signal operandMuxToFU : std_logic_vector(3 downto 0); --carries Op B or const to FU
	--signal dataFromMemory : std_logic_vector(3 downto 0); --data to be loaded from RAM
	
	--signal PZN_Out : std_logic_vector(2 downto 0); --pos, zero, neg from FU operation
	signal FUResultToMux : std_logic_vector(3 downto 0); --from FU to result or data in selection
	signal muxToRegisterFileDest : std_logic_vector(3 downto 0); --carries either result or data in to the register file data in port
	
	
	--CONTROL WORD SIGNALS
	signal A_Addr : std_logic_vector(2 downto 0); --bits [15:13]
	signal B_Addr : std_logic_vector(2 downto 0); --bits [11:9]
	signal constOrBSelector : std_logic; --wire to const or operand B mux, bit 12
	signal FUResultOrRAM : std_logic; --wire to selector data from FU or RAM, bit 8
    signal opcodeSelect : std_logic_vector(3 downto 0); --bits [7:4]
    signal regfileDestinationAddr : std_logic_vector(2 downto 0); --bits [3:1]
    signal readOrWrite : std_logic; --read regfile or write to regfile, bit 0
    
begin

    --CONTROL WORD MAPPING
    A_Addr                  <= ControlWord(15 downto 13);
    constOrBSelector        <= ControlWord(12);
    B_Addr                  <= ControlWord(11 downto 9);
    FUResultOrRam           <= ControlWord(8);
    opcodeSelect            <= ControlWord(7 downto 4);
    regFileDestinationAddr  <= ControlWord(3 downto 1);
    readOrWrite             <= ControlWord(0);
    
    dataOut <= operandMuxToFU; --from ALU to ram
    addrOut <= regToFU_OpA; --from ALU to ram
    
    ALU_REGFILE: Register_File port map(
    
            Destination_Data => muxToRegisterFileDest,
            Destination_Address => regFileDestinationAddr,
            
            register_a_Address => A_Addr,
            register_B_Address => B_Addr,
            
            clk_regfile => clk,
            reset_regfile => reset,
            read_write => readOrWrite,
            
            Out_Data_A => regToFU_OpA,
            Out_data_B => regToMux_OpB
            
    
        );
        
        
        --used to seleect if a constant or value from register addr B should be an operand
        OPERAND_MUX: mux generic map( datalength => 4,
                                      selectorlength => 1)
                        
                        port map(
                        
                            data_in(1) => regToMux_OpB,
                            data_in(0) => constOp,
                            
                            selector => (0 => constOrBSelector,
                                         others => '0'),
                                         
                            data_out => operandMuxToFU
                            
                        
                        
                        );

        
        
        FUorRAM_MUX: mux generic map(datalength => 4,
                                     selectorlength =>1)
                         port map(
                         
                            data_in(1) => FUResultToMux,
                            data_in(0) => dataFromRam,
                            
                            selector => (0 => FUResultOrRAM,
                                         others => '0'),
                                         
                            data_out => muxToRegisterFileDest
                         
                         
                         );
        
        
        ALU_FUNCTION_UNIT: Functional_Unit generic map(operandLength => 4,
                                                    opcodeLength => 4,
                                                    numFunctions => 16)
                                      port map(
                                      
                                        valA => regToFU_OpA,
                                        valB => operandMuxToFU,
                                        
                                        opcode => opcodeSelect,
                                        
                                        outVal => FUResultToMux,
                                        poszeroneg => PZN
                                      

                                      );
        

end ALUArch;
