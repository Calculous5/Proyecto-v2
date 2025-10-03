library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Super_Register_File is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           load_rf : in STD_LOGIC;
           reg_sel : in STD_LOGIC_VECTOR (1 downto 0);
           data_in_rf : in STD_LOGIC_VECTOR (15 downto 0);
           sel_a : in STD_LOGIC_VECTOR (1 downto 0);
           sel_b : in STD_LOGIC_VECTOR (1 downto 0);
           out_a : out STD_LOGIC_VECTOR (15 downto 0);
           out_b : out STD_LOGIC_VECTOR (15 downto 0);
           reg_a : out STD_LOGIC_VECTOR (15 downto 0);
           reg_b : out STD_LOGIC_VECTOR (15 downto 0);
           reg_c : out STD_LOGIC_VECTOR (15 downto 0);
           reg_d : out STD_LOGIC_VECTOR (15 downto 0);
           pc_load : in STD_LOGIC;
           pc_d : in STD_LOGIC_VECTOR (11 downto 0);
           pc_q : out STD_LOGIC_VECTOR (11 downto 0));
end Super_Register_File;

architecture Behavioral of Super_Register_File is
    component Register_File
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
    end component;
    
    component PC
        Port ( clock : in STD_LOGIC;
               clear : in STD_LOGIC;
               load : in STD_LOGIC;
               d : in STD_LOGIC_VECTOR (11 downto 0);
               q : out STD_LOGIC_VECTOR (11 downto 0));
    end component;
begin
    RF: Register_File port map (
        clock => clock,
        clear => clear,
        load => load_rf,
        reg_sel => reg_sel,
        data_in => data_in_rf,
        sel_a => sel_a,
        sel_b => sel_b,
        out_a => out_a,
        out_b => out_b,
        reg_a => reg_a,
        reg_b => reg_b,
        reg_c => reg_c,
        reg_d => reg_d
    );
    
    PC_inst: PC port map (
        clock => clock,
        clear => clear,
        load => pc_load,
        d => pc_d,
        q => pc_q
    );
end Behavioral;