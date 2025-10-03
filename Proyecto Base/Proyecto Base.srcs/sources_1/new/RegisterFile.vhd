library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RegisterFile is
    Port ( clock            : in std_logic;
           result           : in std_logic_vector(15 downto 0);
           LReg             : in std_logic;
           SReg             : in std_logic_vector(1 downto 0);
           clear            : in std_logic;
           selectFirst      : in std_logic_vector(1 downto 0);
           selectSecond     : in std_logic_vector(1 downto 0);
           dataA            : in std_logic_vector(15 downto 0);
           dataB            : in std_logic_vector(15 downto 0);
           dataC            : in std_logic_vector(15 downto 0);
           dataD            : in std_logic_vector(15 downto 0);
           czn              : in std_logic_vector(2 downto 0);
           firstOperator    : out std_logic_vector(15 downto 0);
           secondOperator   : out std_logic_vector(15 downto 0);
           statusOut        : out std_logic_vector(2 downto 0)
            );
end RegisterFile;


architecture Behavioral of RegisterFile is


signal q_A      : std_logic_vector(15 downto 0);
signal q_B      : std_logic_vector(15 downto 0);
signal q_C      : std_logic_vector(15 downto 0);
signal q_D      : std_logic_vector(15 downto 0);
signal loadA    : std_logic;
signal loadB    : std_logic;
signal loadC    : std_logic;
signal loadD    : std_logic;


component Reg is
   Port ( clock : in std_logic;
          reset : in std_logic;
          load  : in std_logic;
          d     : in std_logic_vector(15 downto 0);
          q     : out std_logic_vector(15 downto 0)          
          );
end component;


component Mux_4x16 is
    Port ( sel  : in std_logic_vector(1 downto 0);
           A    : in std_logic_vector(15 downto 0);
           B    : in std_logic_vector(15 downto 0);
           C    : in std_logic_vector(15 downto 0);
           D    : in std_logic_vector(15 downto 0);
           dataOut : out std_logic_vector(15 downto 0)
           );
end component;


component Demux_RegFile is
    Port ( LReg     : in std_logic;
           SReg     : in std_logic_vector(1 downto 0);
           loadA    : out std_logic;
           loadB    : out std_logic;
           loadC    : out std_logic;
           loadD    : out std_logic
           );
end component;

begin


loadDemux : Demux_RegFile port map (
    LReg => LReg,
    SReg => SReg,
    loadA => loadA,
    loadB => loadB,
    loadC => loadC,
    loadD => loadD    
    );


RegA : Reg port map (
    clock => clock,
    reset => clear,
    load => loadA,
    d => dataA,
    q => q_A
    );
    
    
RegB : Reg port map (
    clock => clock,
    reset => clear,
    load => loadB,
    d => dataB,
    q => q_B
    );


RegC : Reg port map (
    clock => clock,
    reset => clear,
    load => loadC,
    d => dataC,
    q => q_C
    );
    
    
RegD : Reg port map (
    clock => clock,
    reset => clear,
    load => loadD,
    d => dataD,
    q => q_D
    );    


firstMux : Mux_4x16 port map (
    sel => selectFirst,
    A => q_A,
    B => q_B,
    C => q_C,
    D => q_D,
    dataOut => firstOperator
    );

secondMux : Mux_4x16 port map (
    sel => selectSecond,
    A => q_A,
    B => q_B,
    C => q_C,
    D => q_D,
    dataOut => secondOperator
    );
    



end Behavioral;
