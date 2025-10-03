library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_16bit is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           load : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (15 downto 0);
           q : out STD_LOGIC_VECTOR (15 downto 0));
end Register_16bit;

architecture Behavioral of Register_16bit is
    component FFD
        Port ( clk : in std_logic;
               d   : in std_logic;
               q   : out std_logic);
    end component;
    
    signal q_internal : std_logic_vector(15 downto 0);
    signal d_internal : std_logic_vector(15 downto 0);
begin
    gen_ffd: for i in 0 to 15 generate
        d_internal(i) <= '0' when clear = '1' else
                         d(i) when load = '1' else
                         q_internal(i);
        FFD_inst: FFD port map (clk => clock, d => d_internal(i), q => q_internal(i));
    end generate;
    q <= q_internal;
end Behavioral;