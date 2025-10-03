library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (11 downto 0);
           ram_datain : out STD_LOGIC_VECTOR (15 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (15 downto 0);
           ram_write : out STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (11 downto 0);
           rom_dataout : in STD_LOGIC_VECTOR (61 downto 0);
           regA : out STD_LOGIC_VECTOR (15 downto 0);
           regB : out STD_LOGIC_VECTOR (15 downto 0);
           regC : out STD_LOGIC_VECTOR (15 downto 0);
           regD : out STD_LOGIC_VECTOR (15 downto 0));
end CPU;

architecture Behavioral of CPU is
    component Super_Register_File
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
    end component;
    
    component ALU
        Port ( a : in STD_LOGIC_VECTOR (15 downto 0);
               b : in STD_LOGIC_VECTOR (15 downto 0);
               op : in STD_LOGIC_VECTOR (7 downto 0);
               result : out STD_LOGIC_VECTOR (15 downto 0);
               c : out STD_LOGIC;
               z : out STD_LOGIC;
               n : out STD_LOGIC);
    end component;
    
    component Status_Register
        Port ( clock : in STD_LOGIC;
               clear : in STD_LOGIC;
               load : in STD_LOGIC;
               d : in STD_LOGIC_VECTOR (2 downto 0);
               q : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
    
    signal load_rf : std_logic;
    signal reg_sel : std_logic_vector(1 downto 0);
    signal data_in_rf : std_logic_vector(15 downto 0);
    signal sel_a : std_logic_vector(1 downto 0);
    signal sel_b : std_logic_vector(1 downto 0);
    signal out_a : std_logic_vector(15 downto 0);
    signal out_b : std_logic_vector(15 downto 0);
    signal pc_load : std_logic;
    signal pc_d : std_logic_vector(11 downto 0);
    signal pc_q : std_logic_vector(11 downto 0);
    
    signal alu_op : std_logic_vector(7 downto 0);
    signal alu_a : std_logic_vector(15 downto 0);
    signal alu_b : std_logic_vector(15 downto 0);
    signal alu_result : std_logic_vector(15 downto 0);
    signal alu_c : std_logic;
    signal alu_z : std_logic;
    signal alu_n : std_logic;
    
    signal status_load : std_logic;
    signal status_in : std_logic_vector(2 downto 0);
    signal status_out : std_logic_vector(2 downto 0);
    
    signal mux_one_sel : std_logic_vector(1 downto 0);
    signal mux_two_sel : std_logic_vector(1 downto 0);
    signal mux_s_sel : std_logic_vector(1 downto 0);
    
    signal mux_one_out : std_logic_vector(15 downto 0);
    signal mux_two_out : std_logic_vector(15 downto 0);
    signal mux_s_out : std_logic_vector(11 downto 0);
    
    signal use_alu : std_logic;
    signal literal_value : std_logic_vector(15 downto 0);
    signal jump_condition_met : std_logic;
begin
    literal_value <= rom_dataout(61 downto 46);
    load_rf <= rom_dataout(8);
    
    reg_sel <= "00" when rom_dataout(17) = '1' else
               "01" when rom_dataout(18) = '1' else
               "10" when rom_dataout(19) = '1' else
               "11";
               
    sel_a <= "00" when rom_dataout(9) = '1' else
             "01" when rom_dataout(10) = '1' else
             "10" when rom_dataout(11) = '1' else
             "11";
             
    sel_b <= "00" when rom_dataout(13) = '1' else
             "01" when rom_dataout(14) = '1' else
             "10" when rom_dataout(15) = '1' else
             "11";
             
    alu_op <= rom_dataout(7 downto 0);
    
    mux_one_sel <= "00" when rom_dataout(21) = '1' else
                   "01" when rom_dataout(22) = '1' else
                   "10" when rom_dataout(23) = '1' else
                   "00";
                   
    mux_two_sel <= "00" when rom_dataout(24) = '1' else
                   "01" when rom_dataout(25) = '1' else
                   "10" when rom_dataout(26) = '1' else
                   "11";
                   
    mux_s_sel <= "00" when rom_dataout(31) = '1' else
                 "01" when rom_dataout(32) = '1' else
                 "10" when rom_dataout(33) = '1' else
                 "00";
                 
    ram_write <= rom_dataout(30);
    
    jump_condition_met <= 
        '1' when rom_dataout(36) = '1' else
        '1' when (rom_dataout(37) = '1' and status_out(1) = '1') else
        '1' when (rom_dataout(38) = '1' and status_out(1) = '0') else
        '1' when (rom_dataout(39) = '1' and status_out(2) = '0' and status_out(1) = '0') else
        '1' when (rom_dataout(40) = '1' and status_out(2) = '0') else
        '1' when (rom_dataout(41) = '1' and status_out(2) = '1') else
        '1' when (rom_dataout(42) = '1' and (status_out(2) = '1' or status_out(1) = '1')) else
        '1' when (rom_dataout(43) = '1' and status_out(2) = '1') else
        '0';
        
    pc_load <= jump_condition_met;
    pc_d <= literal_value(11 downto 0);
    
    with mux_one_sel select
        mux_one_out <=
            out_a when "00",
            x"0001" when "01",
            x"0000" when others;
            
    with mux_two_sel select
        mux_two_out <=
            out_b when "00",
            x"0000" when "01",
            literal_value when "10",
            ram_dataout when others;
            
    with mux_s_sel select
        mux_s_out <=
            literal_value(11 downto 0) when "00",
            out_b(11 downto 0) when "01",
            out_a(11 downto 0) when "10",
            (others => '0') when others;
            
    use_alu <= '1' when alu_op /= "00000000" else '0';
    data_in_rf <= alu_result when use_alu = '1' else mux_two_out;
    alu_a <= mux_one_out;
    alu_b <= mux_two_out;
    
    status_load <= use_alu;
    status_in <= alu_c & alu_z & alu_n;
    
    rom_address <= pc_q;
    ram_address <= mux_s_out;
    ram_datain <= alu_result when use_alu = '1' else mux_two_out;
    
    SRF: Super_Register_File port map (
        clock => clock,
        clear => clear,
        load_rf => load_rf,
        reg_sel => reg_sel,
        data_in_rf => data_in_rf,
        sel_a => sel_a,
        sel_b => sel_b,
        out_a => out_a,
        out_b => out_b,
        reg_a => regA,
        reg_b => regB,
        reg_c => regC,
        reg_d => regD,
        pc_load => pc_load,
        pc_d => pc_d,
        pc_q => pc_q
    );
    
    ALU_inst: ALU port map (
        a => alu_a,
        b => alu_b,
        op => alu_op,
        result => alu_result,
        c => alu_c,
        z => alu_z,
        n => alu_n
    );
    
    Status_Reg: Status_Register port map (
        clock => clock,
        clear => clear,
        load => status_load,
        d => status_in,
        q => status_out
    );
end Behavioral;