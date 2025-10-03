library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           load : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (11 downto 0);
           q : out STD_LOGIC_VECTOR (11 downto 0));
end PC;

architecture Behavioral of PC is
    component FFD
        Port ( clk : in std_logic;
               d   : in std_logic;
               q   : out std_logic);
    end component;
    
    signal q_internal : std_logic_vector(11 downto 0);
    signal d_internal : std_logic_vector(11 downto 0);
begin
    d_internal <= (others => '0') when clear = '1' else
                  d when load = '1' else
                  q_internal + 1;
                  
    gen_ffd: for i in 0 to 11 generate
        FFD_inst: FFD port map (clk => clock, d => d_internal(i), q => q_internal(i));
    end generate;
    q <= q_internal;
end Behavioral;