library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port ( a : in STD_LOGIC_VECTOR (15 downto 0);
           b : in STD_LOGIC_VECTOR (15 downto 0);
           op : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (15 downto 0);
           c : out STD_LOGIC;
           z : out STD_LOGIC;
           n : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    signal res_temp : std_logic_vector(15 downto 0);
    signal add_res : std_logic_vector(16 downto 0);
    signal sub_res : std_logic_vector(16 downto 0);
begin
    add_res <= ('0' & a) + ('0' & b);
    sub_res <= ('0' & a) - ('0' & b);
    
    with op select
        res_temp <=
            add_res(15 downto 0) when "00000001",
            sub_res(15 downto 0) when "00000010",
            a and b when "00000100",
            a or b when "00001000",
            a xor b when "00010000",
            not a when "00100000",
            '0' & a(15 downto 1) when "01000000",
            a(14 downto 0) & '0' when "10000000",
            (others => '0') when others;
            
    c <= add_res(16) when op = "00000001" else
          sub_res(16) when op = "00000010" else
          '0';
          
    z <= '1' when res_temp = x"0000" else '0';
    n <= res_temp(15);
    
    result <= res_temp;
end Behavioral;