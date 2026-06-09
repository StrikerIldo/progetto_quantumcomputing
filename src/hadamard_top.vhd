----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2026 18:54:35
-- Design Name: 
-- Module Name: hadamard_top - Behavioral
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

entity hadamard_top is
    Port ( 
        clk      : in  STD_LOGIC;
        res      : in  STD_LOGIC;
        alpha_in : in  STD_LOGIC_VECTOR(11 downto 0); -- Q4.8
        beta_in  : in  STD_LOGIC_VECTOR(11 downto 0); -- Q4.8
        alpha_out: out STD_LOGIC_VECTOR(11 downto 0);
        beta_out : out STD_LOGIC_VECTOR(11 downto 0)
    );
end hadamard_top;

architecture Behavioral of hadamard_top is
    -- Costante 1/sqrt(2) in formato Q4.8 (181 in decimale)
    constant H_COEFF : signed(11 downto 0) := to_signed(181, 12);
    
    -- Registri di input
    signal r_alpha, r_beta : signed(11 downto 0);
    -- Segnali intermedi (attenzione: la moltiplicazione raddoppia i bit!)
    signal mult_a, mult_b, mult_c, mult_d : signed(23 downto 0);
    signal sum_alpha, sum_beta : signed(23 downto 0);
begin

    process(clk, res)
    begin
        if res = '1' then
            r_alpha   <= (others => '0');
            r_beta    <= (others => '0');
            alpha_out <= (others => '0');
            beta_out  <= (others => '0');
        elsif rising_edge(clk) then
            -- 1. Registri di ingresso (Sincronizzazione richiesta)
            r_alpha <= signed(alpha_in);
            r_beta  <= signed(beta_in);
            
            -- 2. Calcolo Combinatorio (Hadamard: out = 1/sqrt2 * [1 1; 1 -1] * in)
            -- alpha_out = H_COEFF * (r_alpha + r_beta)
            -- beta_out  = H_COEFF * (r_alpha - r_beta)
            
            -- Moltiplicazioni
            mult_a <= H_COEFF * r_alpha;
            mult_b <= H_COEFF * r_beta;
            
            -- 3. Registri di uscita con shift per tornare a Q4.8 (dividiamo per 2^8)
            -- Prendiamo i bit corretti per mantenere il formato 12 bit con 8 frazionari
            alpha_out <= std_logic_vector(resize(shift_right(mult_a + mult_b, 8), 12));
            beta_out  <= std_logic_vector(resize(shift_right(mult_a - mult_b, 8), 12));
        end if;
    end process;

end Behavioral;
