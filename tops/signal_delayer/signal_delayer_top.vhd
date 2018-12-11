library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;
use xil_defaultlib.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity delayer is
    Port ( sys_clk_p_i : in STD_LOGIC;
           sys_clk_n_i : in STD_LOGIC;
           USER_SMA_GPIO_N : in STD_LOGIC;
           USER_SMA_GPIO_P : out STD_LOGIC;
           leds_o : out STD_LOGIC);
end delayer;

architecture Behavioral of delayer is


    constant c_delay_num : natural := 128;  
    --internal signals
    signal sys_clk : std_logic := '0' ;
    signal signal_out : std_logic_vector (0 downto 0) := "0" ;
    signal vector  :std_logic_vector ( c_delay_num-1 downto 0) := (others =>'0');
    begin

    clk_gen_1 : entity work.clk_gen
        port map (
            sys_clk_p_i => sys_clk_p_i,
            sys_clk_n_i => sys_clk_n_i,
            sys_clk_o   => sys_clk
        );

    
    vector(0) <= USER_SMA_GPIO_N;
        
    process (sys_clk) is
    begin
         
         
         
        if rising_edge(sys_clk) then
            vector(c_delay_num-1 downto 1) <= vector (c_delay_num-2 downto 0);
            signal_out (0) <= vector (c_delay_num-1);
           
        end if;
        
    end process;       
           leds_o <= signal_out (0);
           USER_SMA_GPIO_P <= signal_out (0);
    
end Behavioral;

