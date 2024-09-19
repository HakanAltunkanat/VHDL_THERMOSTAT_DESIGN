library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Thermostat_UUT is
end Thermostat_UUT;

architecture Behavioral of Thermostat_UUT is
    component Thermostat
         port (
            current_temp, desired_temp : in std_logic_vector(6 downto 0);
            display_select, cool, heat, furnace_hot, ac_ready,clk,reset : in std_logic;
            temp_display : out std_logic_vector(6 downto 0);
            a_c_on, furnace_on, fan_on : out std_logic 
         );
    end component;

    
    signal current_temp, desired_temp, temp_display : std_logic_vector(6 downto 0);
    signal display_select, cool, heat, furnace_hot, ac_ready, a_c_on, furnace_on, fan_on,clk,reset : std_logic;
    
begin
    -- DUT (Device Under Test) baðlantýlarý
    uut: Thermostat port map (
        current_temp => current_temp,
        desired_temp => desired_temp, 
        display_select => display_select,
        cool => cool, 
        heat => heat,
        a_c_on => a_c_on, 
        furnace_on => furnace_on,
        temp_display => temp_display,
        furnace_hot => furnace_hot,
        ac_ready => ac_ready,
        fan_on => fan_on,
        clk => clk, reset=>reset 
    );

    clock : process
    begin
        clk<='0';
        wait for 10ns;
        clk<='1';
        wait for 10ns;
    end process;
    
    process
    begin
        
        current_temp <= "0000111";  
        desired_temp <= "1110000";  
        display_select <= '0';
        heat <= '0';  
        cool <= '0';  
        furnace_hot <= '0';
        ac_ready <= '0';
        reset<='0';
        wait for 20 ns; 
        heat <= '1';  
        
        wait for 20 ns; 
        furnace_hot <= '1';  
        
        wait for 20ns;
        heat<='0';
        
        wait for 20ns;
        furnace_hot<='0';  
        
        wait for 20ns;
        current_temp <= "1110000";  
        desired_temp <= "0000111";
        cool<='1';
        
        wait for 20ns;
        ac_ready<='1';
        
        wait for 20ns;
        cool<='0';
        
        wait for 20ns;
        ac_ready<='0';        
        

        wait;
    end process;

end Behavioral;
