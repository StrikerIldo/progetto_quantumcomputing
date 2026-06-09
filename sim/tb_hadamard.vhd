----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2026 22:52:27
-- Design Name: 
-- Module Name: tb_hadamard - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_hadamard is
end tb_hadamard;

architecture Behavioral of tb_hadamard is
    -- Component Declaration
    component hadamard_top
        Port ( 
            clk      : in  STD_LOGIC;
            res      : in  STD_LOGIC;
            alpha_in : in  STD_LOGIC_VECTOR(11 downto 0);
            beta_in  : in  STD_LOGIC_VECTOR(11 downto 0);
            alpha_out: out STD_LOGIC_VECTOR(11 downto 0);
            beta_out : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;

    -- Segnali del Test-bench
    signal clk       : std_logic := '0';
    signal res       : std_logic := '0';
    signal alpha_in  : std_logic_vector(11 downto 0) := (others => '0');
    signal beta_in   : std_logic_vector(11 downto 0) := (others => '0');
    signal alpha_out : std_logic_vector(11 downto 0);
    signal beta_out  : std_logic_vector(11 downto 0);

    constant clk_period : time := 10 ns;

begin
    -- Istanza del Gate di Hadamard
    uut: hadamard_top port map (
        clk => clk, res => res,
        alpha_in => alpha_in, beta_in => beta_in,
        alpha_out => alpha_out, beta_out => beta_out
    );

    -- Generatore di Clock
    clk_process : process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- Processo degli Stimoli
    stim_proc: process
    begin		
        res <= '1'; wait for 20 ns;
        res <= '0'; wait for 20 ns;

        -- TEST 1: Stato |0> (alpha=1, beta=0) -> In Fixed Point 8.4 = 256
        alpha_in <= std_logic_vector(to_signed(256, 12));
        beta_in  <= (others => '0');
        wait for 40 ns;

        -- TEST 2: Stato |1> (alpha=0, beta=1)
        alpha_in <= (others => '0');
        beta_in  <= std_logic_vector(to_signed(256, 12));
        wait for 40 ns;

        -- TEST 3: Stato |+> (Ingresso già trasformato)
        -- alpha=0.707 (181), beta=0.707 (181)
        alpha_in <= std_logic_vector(to_signed(181, 12));
        beta_in  <= std_logic_vector(to_signed(181, 12));
        wait for 40 ns;

        -- TEST 4: Stato complesso/negativo
        alpha_in <= std_logic_vector(to_signed(181, 12));
        beta_in  <= std_logic_vector(to_signed(-181, 12));
        wait;
    end process;

end Behavioral;
