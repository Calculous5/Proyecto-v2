library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Mux_4x16 is
    Port ( sel      : in std_logic_vector(1 downto 0);
           A        : in std_logic_vector(15 downto 0);
           B        : in std_logic_vector(15 downto 0);
           C        : in std_logic_vector(15 downto 0);
           D        : in std_logic_vector(15 downto 0);
           dataOut  : out std_logic_vector(15 downto 0)
    );
end Mux_4x16;

architecture Behavioral of Mux_4x16 is

begin


with sel select
    dataOut <= A when "00",
               B when "01",
               C when "10",
               D when "11",
               A when others;
               
end Behavioral;
