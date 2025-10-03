library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_File is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           load : in STD_LOGIC;
           reg_sel : in STD_LOGIC_VECTOR (1 downto 0);
           data_in : in STD_LOGIC_VECTOR (15 downto 0);
           sel_a : in STD_LOGIC_VECTOR (1 downto 0);
           sel_b : in STD_LOGIC_VECTOR (1 downto 0);
           out_a : out STD_LOGIC_VECTOR (15 downto 0);
           out_b : out STD_LOGIC_VECTOR (15 downto 0);
           reg_a : out STD_LOGIC_VECTOR (15 downto 0);
           reg_b : out STD_LOGIC_VECTOR (15 downto 0);
           reg_c : out STD_LOGIC_VECTOR (15 downto 0);
           reg_d : out STD_LOGIC_VECTOR (15 downto 0));
end Register_File;

architecture Behavioral of Register_File is
    component Register_16bit
        Port ( clock : in STD_LOGIC;
               clear : in STD_LOGIC;
               load : in STD_LOGIC;
               d : in STD_LOGIC_VECTOR (15 downto 0);
               q : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    signal load_a, load_b, load_c, load_d : std_logic;
    signal reg_a_int, reg_b_int, reg_c_int, reg_d_int : std_logic_vector(15 downto 0);
begin
    load_a <= '1' when (load = '1' and reg_sel = "00") else '0';
    load_b <= '1' when (load = '1' and reg_sel = "01") else '0';
    load_c <= '1' when (load = '1' and reg_sel = "10") else '0';
    load_d <= '1' when (load = '1' and reg_sel = "11") else '0';
    
    reg_a_inst: Register_16bit port map (clock => clock, clear => clear, load => load_a, d => data_in, q => reg_a_int);
    reg_b_inst: Register_16bit port map (clock => clock, clear => clear, load => load_b, d => data_in, q => reg_b_int);
    reg_c_inst: Register_16bit port map (clock => clock, clear => clear, load => load_c, d => data_in, q => reg_c_int);
    reg_d_inst: Register_16bit port map (clock => clock, clear => clear, load => load_d, d => data_in, q => reg_d_int);
    
    out_a <= reg_a_int when sel_a = "00" else
             reg_b_int when sel_a = "01" else
             reg_c_int when sel_a = "10" else
             reg_d_int;
             
    out_b <= reg_a_int when sel_b = "00" else
             reg_b_int when sel_b = "01" else
             reg_c_int when sel_b = "10" else
             reg_d_int;
             
    reg_a <= reg_a_int;
    reg_b <= reg_b_int;
    reg_c <= reg_c_int;
    reg_d <= reg_d_int;
end Behavioral;