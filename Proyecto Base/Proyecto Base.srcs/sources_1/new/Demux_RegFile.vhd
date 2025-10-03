library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Demux_RegFile is
    Port ( LReg     : in std_logic;
           SReg     : in std_logic_vector(1 downto 0);
           loadA    : out std_logic;
           loadB    : out std_logic;
           loadC    : out std_logic;
           loadD    : out std_logic
           );
end Demux_RegFile;


architecture Behavioral of Demux_RegFile is


begin


with (LReg & SReg) select
    loadA <= '1' when "100",
             '0' when others;
             
with (LReg & SReg) select
    loadB <= '1' when "101",
             '0' when others;
             
with (LReg & SReg) select
    loadC <= '1' when "110",
             '0' when others;
             
with (LReg & SReg) select
    loadD <= '1' when "111",
             '0' when others;

        
end Behavioral;
