library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Reg is
   Port ( clock : in std_logic;
          load  : in std_logic;
          reset : in std_logic;
          d     : in std_logic_vector(15 downto 0);
          q     : out std_logic_vector(15 downto 0)          
          );
end Reg;

architecture Behavioral of Reg is  
  

component FFD
    Port ( clk : in std_logic;
           d   : in std_logic;
           q   : out std_logic);
end component;


signal data_in  : std_logic_vector(15 downto 0);
signal q_ffd    : std_logic_vector(15 downto 0);



begin       


with load select
    data_in <= d when '1',
               q_ffd when others;


with reset select
    data_in <= (others => '0') when '1',
               data_in         when others;

    
gen_FFD: for i in 0 to 15 generate
    ffd_i : FFD port map (
        clk => clock,
        d => data_in(i),
        q => q_ffd(i)
    );
end generate;

q <= q_ffd;


end Behavioral;
