-- Digital Temperature sensor project
-- Design created by : Marc Salas Huetos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_Comunications_Structure is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        ow_line_in      : in std_logic;
        temperature     : out std_logic_vector(8 downto 0);
        count_rem       : out std_logic_vector(7 downto 0);
        --count_per_C     : out std_logic_vector(7 downto 0);
        en_conv         : out std_logic;
        out_line_BUFT_toggle : out std_logic
    );
end Top_Comunications_Structure;

architecture Structural of Top_Comunications_Structure is

component BRAIN is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        pg_out          : in std_logic;
        scratchpad      : in std_logic_vector(63 downto 0);
        init_success    : in std_logic;
        RSc_done        : in std_logic;
        WR_done         : in std_logic;
        init_done       : in std_logic;
        prescaler_B     : out std_logic_vector(29 downto 0);
        en_tim_B        : out std_logic;
        en_init         : out std_logic;
        en_WR           : out std_logic;
        en_RSc          : out std_logic;
        en_conv         : out std_logic;
        temperature     : out std_logic_vector(8 downto 0);
        count_rem       : out std_logic_vector(7 downto 0);
        --count_per_C     : out std_logic_vector(7 downto 0);
        routine         : out std_logic_vector(1 downto 0)
    );
end component;

component Initialization_FSM is
    port(
        clk                 : in std_logic;
        rst                 : in std_logic;
        en_init             : in std_logic;
        in_line             : in std_logic;
        pg_out              : in std_logic;
        prescaler_init      : out std_logic_vector(29 downto 0);
        en_tim_init         : out std_logic;
        init_done           : out std_logic;
        init_success        : out std_logic;
        out_line_init       : out std_logic
    );
end component;

component Read_Scratchpad_FSM is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        en_RSc          : in std_logic;
        pg_out          : in std_logic;
        in_line         : in std_logic;
        out_line_RSc    : out std_logic;
        en_tim_RSc      : out std_logic;
        RSc_done        : out std_logic;
        prescaler_RSc   : out std_logic_vector(29 downto 0);
        scratchpad_mem  : out std_logic_vector(63 downto 0)
    );
end component;

component Write_Routines_FSM is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        routine         : in std_logic_vector(1 downto 0);
        en_WR           : in std_logic;
        pg_out          : in std_logic;
        WR_done         : out std_logic;
        en_tim_WR       : out std_logic;
        prescaler_WR    : out std_logic_vector(29 downto 0);
        out_line_WR     : out std_logic
    );
end component;

component TIMER_FSM is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        en          : in std_logic;
        prescaler   : in std_logic_vector(29 downto 0);
        pg_out      : out std_logic
    ) ;
end component;

signal prescaler_sig : std_logic_vector(29 downto 0);
signal prescaler_init_sig : std_logic_vector(29 downto 0);
signal prescaler_WR_sig : std_logic_vector(29 downto 0);
signal prescaler_RSc_sig : std_logic_vector(29 downto 0);
signal prescaler_B_sig : std_logic_vector(29 downto 0);
signal en_tim_sig : std_logic;
signal en_tim_B_sig : std_logic;
signal en_tim_init_sig : std_logic;
signal en_tim_WR_sig : std_logic;
signal en_tim_RSc_sig : std_logic;
signal en_init_sig : std_logic;
signal en_WR_sig : std_logic;
signal en_RSc_sig : std_logic;
signal routine_sig : std_logic_vector(1 downto 0);
signal scratchpad_mem_sig : std_logic_vector(63 downto 0);
signal pg_out_sig : std_logic;
signal init_success_sig : std_logic;
signal RSc_done_sig : std_logic;
signal WR_done_sig : std_logic;
signal init_done_sig : std_logic;
signal in_line_sig : std_logic;
signal out_line_init_sig : std_logic;
signal out_line_WR_sig : std_logic;
signal out_line_RSc_sig : std_logic;



begin

prescaler_sig <= prescaler_B_sig or prescaler_init_sig or prescaler_WR_sig or prescaler_RSc_sig;
en_tim_sig <= en_tim_B_sig or en_tim_init_sig or en_tim_WR_sig or en_tim_RSc_sig;
out_line_BUFT_toggle <= out_line_init_sig and out_line_WR_sig and out_line_RSc_sig;
in_line_sig <= ow_line_in;
--BUFT_I_sig <= '0';

BR : BRAIN port map(
        clk             => clk,         
        rst             => rst,
        pg_out          => pg_out_sig,
        scratchpad      => scratchpad_mem_sig,
        init_success    => init_success_sig,
        RSc_done        => RSc_done_sig,
        WR_done         => WR_done_sig,
        init_done       => init_done_sig,
        prescaler_B     => prescaler_B_sig,
        en_tim_B        => en_tim_B_sig,
        en_init         => en_init_sig,
        en_WR           => en_WR_sig,
        en_RSc          => en_RSc_sig,
        en_conv         => en_conv,
        temperature     => temperature,
        count_rem       => count_rem,
        --count_per_C     => count_per_C,
        routine         => routine_sig  
);

Init_FSM : Initialization_FSM port map(
        clk                 => clk,
        rst                 => rst,
        en_init             => en_init_sig,    
        in_line             => in_line_sig,
        pg_out              => pg_out_sig,                 
        prescaler_init      => prescaler_init_sig,
        en_tim_init         => en_tim_init_sig,
        init_done           => init_done_sig,    
        init_success        => init_success_sig,    
        out_line_init       => out_line_init_sig
);


RSc_FSM : Read_Scratchpad_FSM port map(
        clk             => clk,
        rst             => rst,
        en_RSc          => en_RSc_sig,
        pg_out          => pg_out_sig,
        in_line         => in_line_sig,
        out_line_RSc    => out_line_RSc_sig,
        en_tim_RSc      => en_tim_RSc_sig,
        RSc_done        => RSc_done_sig,
        prescaler_RSc   => prescaler_RSc_sig,
        scratchpad_mem  => scratchpad_mem_sig
);


WR_FSM : Write_Routines_FSM port map(
        clk             => clk,
        rst             => rst,
        routine         => routine_sig,
        en_WR           => en_WR_sig,
        pg_out          => pg_out_sig,
        WR_done         => WR_done_sig,
        en_tim_WR       => en_tim_WR_sig,
        prescaler_WR    => prescaler_WR_sig,
        out_line_WR     => out_line_WR_sig
);


T_FSM : TIMER_FSM port map(
        clk             => clk,
        rst             => rst,
        en              => en_tim_sig,
        prescaler       => prescaler_sig,
        pg_out          => pg_out_sig
);


end Structural;
