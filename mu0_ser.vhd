library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


 entity decoder is
port ( 	addr_in : in std_logic_vector(11 downto 0);
	addr_out : out std_logic_vector(1 downto 0));
end decoder;

architecture decoder_arch of decoder is 
begin 
	addr_out <= 	"00" when addr_in = "111100000000" else 
		    	"01" when addr_in = "111100000001" else 
			"10" when addr_in = "111100000010" else
			"11";
end decoder_arch; 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity mu_w_serial is
  port( reset,clk	: in std_logic;
	tx 		: out std_logic;
        data_bus  	: inout std_logic_vector( 15 downto 0));
end mu_w_serial;


architecture mu_w_serial_arch of mu_w_serial is 
signal addr_bus : std_logic_vector(11 downto 0);
signal addr	: std_logic_vector(1  downto 0);
signal MEMRQ,RNW	: std_logic;
begin 
	MEMRQ	<=	'1' when (addr_bus and "111100000000") = "000000000000" else
			'0' when (addr_bus and "111100000000") = "111100000000";
	mu5 : entity mu0 port map ( 		clk => clk,
						reset=> reset,
						data_bus=>data_bus,
						addr_bus=> addr_bus,
						MEM_RQ => MEMRQ,
						RNW	=> RNW);
	dec5	: entity decoder port map (	addr_in => addr_bus,
						addr_out=>addr);
	ser5	: entity serial	port map (	clk => clk,
						reset => reset,
						data => data_bus (7 downto 0),
						address=> addr,
						tx => tx);
	mem: entity ram0 port map (		clk => clk,
						MEMRQ => MEMRQ,
						RNW => RNW,
						addr_bus => addr_bus,
						data_bus => data_bus);
end mu_w_serial_arch;

						 