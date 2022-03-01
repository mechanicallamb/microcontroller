library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU_DATAPATH is
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
	   -- [6:3] OPCODE for function unit
	   -- [2] C is const or reg[C]
	   -- [1] Pass data from FU or RAM
	   -- [0] read or write to register file (read on 0) (write on 1)
	   
	   destinationReg : in std_logic_vector(regAddressWidth_alu - 1 downto 0);
	   sourceRegA : in std_logic_vector(regAddressWidth_alu - 1 downto 0);
	   constOp : in std_logic_vector(opcodeWidth_alu - 1 downto 0); 
	   
	   clk : in std_logic;
	   reset : in std_logic;
	   dataFromRam : in std_logic_vector(dataWidth_alu - 1 downto 0);
	   
	   addrOut : out std_logic_vector(dataWidth_alu - 1 downto 0);
	   dataOut : out std_logic_vector(dataWidth_alu  - 1 downto 0);
	   PZN : out std_logic_vector(pznWidth_alu - 1 downto 0) --output is Positive, Zero, or Negative
   
   
   
  );

end entity;


architecture ALUArch of ALU_DATAPATH is

	component Register_File is 

		generic(
            addrLength : integer;
            datalength : integer
            
         );
    
       port(
        
        Destination_Data : in std_logic_vector(dataLength - 1 downto 0);
        Destination_Address : in std_logic_vector(addrLength - 1 downto 0);
        
        Register_A_Address : in std_logic_vector(addrLength - 1 downto 0);
        Register_B_Address : in std_logic_vector(addrLength - 1 downto 0);
        
        clk_regfile : in std_logic;
        reset_regfile : in std_logic;
        read_write : in std_logic; --write on 1
        
        Out_Data_A : out std_logic_vector(dataLength - 1 downto 0);
        Out_Data_B : out std_logic_vector(dataLength - 1 downto 0)
        
        --test_demux : out std_logic_vector(3 downto 0)
    );

	end component;


	use work.mux_array_pkg.all;
	component Mux is 

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



	component Functional_Unit is

		 generic(operandLength : integer;
		    opcodeLength : integer;
		    numFunctions : integer;
		    comparatorLength : integer);

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
	signal A_Addr : std_logic_vector(regAddressWidth_alu - 1 downto 0);
	signal D_Addr : std_logic_vector(regAddressWidth_alu - 1 downto 0); 
	signal B_Addr : std_logic_vector(regAddressWidth_alu - 1 downto 0);
	signal constOperand : std_logic_vector(dataWidth_alu - 1 downto 0);
	signal constOrBSelector : std_logic;
	signal FUResultOrRAM : std_logic; 
    signal opcodeSelect : std_logic_vector(opcodeWidth_alu - 1 downto 0);
    signal readOrWrite : std_logic;
    
begin

    --CONTROL WORD MAPPING
    opcodeSelect            <= ControlWord(6 downto 3);
    constOrBSelector        <= ControlWord(2);
    FUResultOrRam           <= ControlWord(1);
    readOrWrite             <= ControlWord(0);
    
    ConstOperand <= constOp;
    A_Addr <= sourceRegA;
    D_Addr <= destinationReg;
    B_Addr <= constOp(regAddressWidth_alu - 1 downto 0);
    
    dataOut <= regToFU_OpA; --data from register file to RAM
    addrOut <= operandMuxToFU; --address from const or regfile to RAM
    
    ALU_REGFILE: Register_File generic map(
                                        
                                        addrLength => regAddressWidth_alu,
                                        dataLength => dataWidth_alu
    
                                    )
    
                    port map(
                    
                            Destination_Data => muxToRegisterFileDest,
                            Destination_Address => D_Addr,
                            
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
                            
                            selector => (0 => not(constOrBSelector),
                                         others => '0'),
                                         
                            data_out => operandMuxToFU
                            
                        
                        
                        );

        
        
        FUorRAM_MUX: mux generic map(datalength => 4,
                                     selectorlength =>1)
                         port map(
                         
                            data_in(1) => dataFromRAM,
                            data_in(0) => FUResultToMux,
                            
                            selector => (0 => FUResultOrRAM,
                                         others => '0'),
                                         
                            data_out => muxToRegisterFileDest
                         
                         
                         );
        
        
        ALU_FUNCTION_UNIT: Functional_Unit generic map(operandLength => 4,
                                                    opcodeLength => 4,
                                                    numFunctions => 16,
                                                    comparatorLength => 3)
                                      port map(
                                      
                                        valA => regToFU_OpA,
                                        valB => operandMuxToFU,
                                        
                                        opcode => opcodeSelect,
                                        
                                        outVal => FUResultToMux,
                                        poszeroneg => PZN
                                      

                                      );
        

end ALUArch;
