library verilog;
use verilog.vl_types.all;
entity MAC_8bit is
    port(
        a               : in     vl_logic_vector(7 downto 0);
        b               : in     vl_logic_vector(7 downto 0);
        c               : in     vl_logic_vector(23 downto 0);
        result          : out    vl_logic_vector(23 downto 0);
        cout            : out    vl_logic
    );
end MAC_8bit;
