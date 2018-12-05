
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

library xil_defaultlib;
use xil_defaultlib.all;


entity delay_counter is
    Port ( sys_clk_p_i : in STD_LOGIC;
           sys_clk_n_i : in STD_LOGIC;
           led_send : out std_logic ;
           led_recieve : out std_logic ;
           --rst : in std_logic ;
           --push_buttons_i : in STD_LOGIC_VECTOR (0 downto 0);
           USER_SMA_GPIO_N : in STD_LOGIC;
           USER_SMA_GPIO_P : out STD_LOGIC );
end delay_counter;

architecture Behavioral of delay_counter is
  
    
    --internal signals
    signal sys_clk : std_logic := '0';
    signal delay : std_logic_vector (9 downto 0) := (others=>'1');
    signal send : std_logic := '0';
    signal signal_send : std_logic := '0';
    signal signal_recieve : std_logic := '0';
    signal rst : std_logic_vector (0 downto 0) ;
    
    
    COMPONENT vio_1
      PORT (
        clk : IN STD_LOGIC;
        probe_in0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_in1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_in2 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
    END COMPONENT;
    
begin

    vio_1_i : vio_1
        PORT MAP (
            clk => sys_clk,
            probe_in0(0) => signal_send,
            probe_in1(0) => signal_recieve,
            probe_in2 => delay,
            probe_out0(0) => rst(0),
            probe_out1(0) => send
            
        );
  
    clk_gen_1 : entity work.clk_gen
        port map (
            sys_clk_p_i => sys_clk_p_i,
            sys_clk_n_i => sys_clk_n_i,
            sys_clk_o   => sys_clk
        );

    --debouncer_1 : entity work.debouncer
    --    generic map (
    --        g_period => 1e6
    --    )
    --    port map (
    --        clk_i    =>  sys_clk,
    --        button_i =>  push_buttons_i(0),
    --        button_o =>  open
    --    ); 

        
    process (sys_clk) is
    begin
     
       if rst = "1" then 
       signal_send <= '0';
       delay <= "1111111111" ; 
       end if;
      if (sys_clk'event and sys_clk = '1') then    
         if (send = '1' ) then
             signal_send <= '1';
             if  (signal_recieve ='0' and delay /="1111111110") then
                  delay <= delay +1;
                
             end if;   
         end if;
       end if ;
         
    end process;
    
    signal_recieve <= USER_SMA_GPIO_N;
    USER_SMA_GPIO_P <= signal_send;
    led_send <= signal_send ;
    led_recieve <= signal_recieve;

                      
end Behavioral;