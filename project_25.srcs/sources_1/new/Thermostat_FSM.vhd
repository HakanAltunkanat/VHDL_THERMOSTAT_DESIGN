library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Thermostat is
    port (current_temp,desired_temp : in std_logic_vector(6 downto 0);
    display_select, cool, heat,furnace_hot,ac_ready , clk, reset: in std_logic;
    temp_display : out std_logic_vector(6 downto 0);
    a_c_on,furnace_on,fan_on : out std_logic );
end Thermostat;

architecture Behavioral of Thermostat is
type state_type is (idle, heaton, furnacenowhot, furnacecool, coolon, acnowready, acdone); --state declaration
signal current_state, next_state : state_type := idle; --initial state
signal ac_counter,furnace_counter : integer :=0; --ac and furnace counter for 20 clcok cycle

begin

    --temperature display
    process(current_temp,desired_temp,display_select,clk)
    begin
        if display_select='1' then
            temp_display<=current_temp;
        elsif display_select='0' then
            temp_display<=desired_temp;
        end if;
    end process;
    
    
    --next_state logic
    process(current_state,cool,heat,furnace_hot,ac_ready,current_temp, desired_temp)
    begin
        case current_state is
            when idle =>
                if heat='1' AND current_temp<desired_temp then
                    next_state<=heaton;
                elsif cool='1' AND current_temp>desired_temp then
                    next_state<=coolon;
                 else
                    next_state<=idle;
                end if;
             when heaton =>
                if furnace_hot='1' then
                    next_state<=furnacenowhot;
                else
                    next_state<=heaton;
                end if;
             when furnacenowhot =>
                if NOT (heat='1' AND current_temp<desired_temp) then
                    next_state<=furnacecool;
                else
                    next_state<=furnacenowhot;
                end if;
             when furnacecool =>
                if furnace_hot='0' AND furnace_counter=0 then
                    next_state<=idle;
                else
                    next_state<=furnacecool;
                 end if;
              when coolon =>
                if ac_ready='1' then
                    next_state<=acnowready;
                else
                    next_state<=coolon;
                end if;
              when acnowready =>
                if NOT (cool='1' AND current_temp>desired_temp) then
                    next_state<=acdone;
                else
                    next_state<=acnowready;
                end if;
              when acdone =>
                if ac_ready='0' AND ac_counter=0 then
                    next_state<=idle;
                else
                    next_state<=acdone;
                end if;
        end case;  
    end process;
    
    --state transition
    process(clk,reset)
    begin
        if reset='1' then
            current_state<=idle;
            ac_counter<=0;
            furnace_counter<=0;
        elsif rising_edge(clk) AND reset='0' then
            current_state<=next_state;
        end if;
        if next_state=acnowready  then
            ac_counter<=20;
        elsif next_state=furnacenowhot then
            furnace_counter<=10;
        elsif next_state=furnacecool OR next_state=acdone then
            ac_counter<=ac_counter-1;
            furnace_counter<=furnace_counter-1;
        end if;       
    end process;
    
    --state outputs
    process(current_state)
    begin
        case current_state is
            when idle =>
                furnace_on<='0';
                a_c_on<='0';
                fan_on<='0';
             when heaton =>
                furnace_on<='1';
                a_c_on<='0';
                fan_on<='0';
             when furnacenowhot =>
                furnace_on<='1';
                a_c_on<='0';
                fan_on<='1';
             when furnacecool =>
                furnace_on<='0';
                a_c_on<='0';
                fan_on<='1';
              when coolon =>
                furnace_on<='0';
                a_c_on<='1';
                fan_on<='0';
              when acnowready =>
                furnace_on<='0';
                a_c_on<='1';
                fan_on<='1';
              when acdone =>
                furnace_on<='0';
                a_c_on<='0';
                fan_on<='1';
        end case;
    end process;   
    
end Behavioral;
