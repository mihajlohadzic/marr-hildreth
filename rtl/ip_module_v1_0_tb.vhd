library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.utils_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ip_module_v1_0_tb is
--  Port ( );
end ip_module_v1_0_tb;

architecture Behavioral of ip_module_v1_0_tb is
    constant WIDTH : integer := 8;
    constant SIZE : integer := 10;
    constant WIDTH_KERNEL : integer := 5;
     constant WIDTH_PIC : integer := 5;
    constant SIZE_KERNEL : integer := 5;
    constant W_c : integer := 10;
    constant H_c : integer := 10;
    constant P_c : integer := 5;
    constant B1 : integer := 3;
    constant L1 : integer := 5;
   
   
    type mem_kernel is array(0 to 5*5-1) of integer;
    type mem_picture is array(0 to 10*10-1) of integer;
   
     constant MEM_LOG_CONTENT : mem_kernel :=
                              (0,0,-1,0,0,0,-1,-2,-1,0,-1,-2,16,-2,-1,0,-1,-2,-1,0,0,0,-1,0,0);
   
    constant MEM_MATRIX_CONTENT : mem_picture :=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,1,2,3,4,5,6,7,8,9,10,11,12,13,14,1,2,3,4,5,6,7,8,9,10,11,12,13,14,1,2,3,4,5,6,7,8,9,10,11,12,13,14,
    100,21,32,43,5,66,7,98,9,110,110,12,123,14,16,2,3,4,5,62,7,8,98,110,11,12,13,14,1,2,3,4,5,6,7,8,9,10,11,11,11,11,11,11);

signal clk_s: std_logic;
signal reset_s: std_logic;

-- Matrix multiplier core's address map
 constant W_REG_ADDR_C : integer := 0;
 constant H_REG_ADDR_C : integer := 4;
 constant B1_REG_ADDR_C : integer := 8;
 constant L1_REG_ADDR_C : integer := 12;
 constant CMD1_REG_ADDR_C : integer := 16;
 constant CMD2_REG_ADDR_C : integer := 20;
 constant STATUS_REG_ADDR_C : integer := 24;
   
 -- Matrix multiplier internal memory map
 constant MEMORY_MATRIX_OFFSET_C : integer := 0;
 constant MEMORY_LOG_OFFSET_C : integer := 256*4;
 constant MEMORY_IM_OFFSET_C : integer := 512*4;
 
 ------------------- AXI Interfaces signals -------------------
 -- Parameters of Axi-Lite Slave Bus Interface S00_AXI
 constant C_S00_AXI_DATA_WIDTH_c    : integer := 32;
 constant C_S00_AXI_ADDR_WIDTH_c    : integer := 5;
 -- Parameters of Axi-Full Slave Bus Interface S01_AXI
 constant C_S01_AXI_ID_WIDTH_c      : integer := 1;
 constant C_S01_AXI_DATA_WIDTH_c    : integer := 32;
 constant C_S01_AXI_ADDR_WIDTH_c    : integer := 12;
 constant C_S01_AXI_AWUSER_WIDTH_c  : integer := 1;
 constant C_S01_AXI_ARUSER_WIDTH_c  : integer := 1;
 constant C_S01_AXI_WUSER_WIDTH_c   : integer := 1;
 constant C_S01_AXI_RUSER_WIDTH_c   : integer := 1;
 constant C_S01_AXI_BUSER_WIDTH_c   : integer := 1;
 
 -- Ports of Axi-Lite Slave Bus Interface S01_AXI
 signal s00_axi_aclk_s      :std_logic := '0';
 signal s00_axi_aresetn_s   :std_logic := '1';
 signal s00_axi_awaddr_s    :std_logic_vector(C_S00_AXI_ADDR_WIDTH_c-1 downto 0) := (others => '0');
 signal s00_axi_awprot_s    :std_logic_vector(2 downto 0) := (others => '0');
 signal s00_axi_awvalid_s   :std_logic := '0';
 signal s00_axi_awready_s   :std_logic := '0';
 signal s00_axi_wdata_s     :std_logic_vector(C_S00_AXI_DATA_WIDTH_c-1 downto 0):= (others => '0');
 signal s00_axi_wstrb_s     :std_logic_vector((C_S00_AXI_DATA_WIDTH_c/8)-1 downto 0):= (others => '0');
 signal s00_axi_wvalid_s    :std_logic := '0';
 signal s00_axi_wready_s    :std_logic := '0';
 signal s00_axi_bresp_s     :std_logic_vector(1 downto 0) := (others => '0');
 signal s00_axi_bvalid_s    :std_logic := '0';
 signal s00_axi_bready_s    :std_logic := '0';
 signal s00_axi_araddr_s    :std_logic_vector(C_S00_AXI_ADDR_WIDTH_c-1 downto 0):= (others => '0');
 signal s00_axi_arprot_s    :std_logic_vector(2 downto 0) := (others => '0');
 signal s00_axi_arvalid_s   :std_logic := '0';
 signal s00_axi_arready_s   :std_logic := '0';
 signal s00_axi_rdata_s     :std_logic_vector(C_S00_AXI_DATA_WIDTH_c-1 downto 0) := (others => '0');
 signal s00_axi_rresp_s     :std_logic_vector(1 downto 0) := (others => '0');
 signal s00_axi_rvalid_s    :std_logic := '0';
 signal s00_axi_rready_s    :std_logic := '0';
 
 -- Ports of Axi-Full Slave Bus Interface S01_AXI
 signal s01_axi_aclk_s      : std_logic := '0';
 signal s01_axi_aresetn_s   : std_logic := '1';
 signal s01_axi_awid_s      : std_logic_vector(C_S01_AXI_ID_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_awaddr_s    : std_logic_vector(C_S01_AXI_ADDR_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_awlen_s     : std_logic_vector(7 downto 0) := (others => '0');
 signal s01_axi_awsize_s    : std_logic_vector(2 downto 0) := (others => '0');
 signal s01_axi_awburst_s   : std_logic_vector(1 downto 0) := (others => '0');
 signal s01_axi_awlock_s    : std_logic := '0';
 signal s01_axi_awcache_s   : std_logic_vector(3 downto 0) := (others => '0');
 signal s01_axi_awprot_s    : std_logic_vector(2 downto 0) := (others => '0');
 signal s01_axi_awqos_s     : std_logic_vector(3 downto 0) := (others => '0');
 signal s01_axi_awregion_s  : std_logic_vector(3 downto 0) := (others => '0');
 signal s01_axi_awuser_s    : std_logic_vector(C_S01_AXI_AWUSER_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_awvalid_s   : std_logic := '0';
 signal s01_axi_awready_s   : std_logic := '0';
 signal s01_axi_wdata_s     : std_logic_vector(C_S01_AXI_DATA_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_wstrb_s     : std_logic_vector((C_S01_AXI_DATA_WIDTH_c/8)-1 downto 0):= (others => '0');
 signal s01_axi_wlast_s     : std_logic := '0';
 signal s01_axi_wuser_s     : std_logic_vector(C_S01_AXI_WUSER_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_wvalid_s    : std_logic := '0';
 signal s01_axi_wready_s    : std_logic := '0';
 signal s01_axi_bid_s       : std_logic_vector(C_S01_AXI_ID_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_bresp_s     : std_logic_vector(1 downto 0) := (others => '0');
 signal s01_axi_buser_s     : std_logic_vector(C_S01_AXI_BUSER_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_bvalid_s    : std_logic := '0';
 signal s01_axi_bready_s    : std_logic := '0';
 signal s01_axi_arid_s      : std_logic_vector(C_S01_AXI_ID_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_araddr_s    : std_logic_vector(C_S01_AXI_ADDR_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_arlen_s     : std_logic_vector(7 downto 0) := (others => '0');
 signal s01_axi_arsize_s    : std_logic_vector(2 downto 0) := (others => '0');
 signal s01_axi_arburst_s   : std_logic_vector(1 downto 0) := (others => '0');
 signal s01_axi_arlock_s    : std_logic := '0';
 signal s01_axi_arcache_s   : std_logic_vector(3 downto 0) := (others => '0');
 signal s01_axi_arprot_s    : std_logic_vector(2 downto 0) := (others => '0');
 signal s01_axi_arqos_s     : std_logic_vector(3 downto 0) := (others => '0');
 signal s01_axi_arregion_s  : std_logic_vector(3 downto 0) := (others => '0');
 signal s01_axi_aruser_s    : std_logic_vector(C_S01_AXI_ARUSER_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_arvalid_s   : std_logic := '0';
 signal s01_axi_arready_s   : std_logic := '0';
 signal s01_axi_rid_s       : std_logic_vector(C_S01_AXI_ID_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_rdata_s     : std_logic_vector(C_S01_AXI_DATA_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_rresp_s     : std_logic_vector(1 downto 0) := (others => '0');
 signal s01_axi_rlast_s     : std_logic := '0';
 signal s01_axi_ruser_s     : std_logic_vector(C_S01_AXI_RUSER_WIDTH_c-1 downto 0):= (others => '0');
 signal s01_axi_rvalid_s    : std_logic := '0';
 signal s01_axi_rready_s    : std_logic := '0';
 
begin

clk_gen: process
begin
    clk_s <= '0', '1' after 100 ns , '0' after 200 ns, '1' after 300 ns,'0' after 400 ns, '1' after 500 ns,'0' after 600 ns, '1' after 700 ns, '0' after 800 ns;
    wait for 200ns;
end process;
--
stimulus_generator: process
    variable axi_read_data_v : std_logic_vector(31 downto 0);
    variable transfer_size_v : integer;
begin
    -- reset AXI-lite interface. Reset will be 10 clock cycles wide
    s00_axi_aresetn_s <= '0';
    -- wait for 5 falling edges of AXI-lite clock signal
    for i in 1 to 5 loop
        wait until falling_edge(clk_s);
    end loop;
    -- release reset
    s00_axi_aresetn_s <= '1';
    wait until falling_edge(clk_s);
   
   
    ----------------------------------------------------------------------
 -- Initialize the Matrix Multiplier core --
 ----------------------------------------------------------------------
 report "Loading the matrix dimensions information into the Matrix Multiplier core!";
 -- Set the value for the first dimension (parameter N) of matrix A and C
 wait until falling_edge(clk_s);
 
 s00_axi_awaddr_s <= conv_std_logic_vector(W_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '1';
 s00_axi_wdata_s <= conv_std_logic_vector(W_c, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '1';
 s00_axi_wstrb_s <= "1111";
 s00_axi_bready_s <= '1';
 
 wait until s00_axi_awready_s = '1';
 wait until s00_axi_awready_s = '0';
 wait until falling_edge(clk_s);
 
 s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '0';
 s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '0';
 s00_axi_wstrb_s <= "0000";
 
 wait until s00_axi_bvalid_s = '0';
 wait until falling_edge(clk_s);
 s00_axi_bready_s <= '0';
 wait until falling_edge(clk_s);
 
 -- wait for 5 falling edges of AXI-lite clock signal
 for i in 1 to 5 loop
    wait until falling_edge(clk_s);
 end loop;
 
  -- Set the value for the second dimension of matrix A and the first dimenzion of matrix B (parameter M)
 wait until falling_edge(clk_s);
 
 s00_axi_awaddr_s <= conv_std_logic_vector(H_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '1';
 s00_axi_wdata_s <= conv_std_logic_vector(H_c, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '1';
 s00_axi_wstrb_s <= "1111";
 s00_axi_bready_s <= '1';
 
 wait until s00_axi_awready_s = '1';
 wait until s00_axi_awready_s = '0';
 wait until falling_edge(clk_s);
 
 s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '0';
 s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '0';
 s00_axi_wstrb_s <= "0000";
 
 wait until s00_axi_bvalid_s = '0';
 wait until falling_edge(clk_s);
 s00_axi_bready_s <= '0';
 wait until falling_edge(clk_s);
 
 -- wait for 5 falling edges of AXI-lite clock signal
 for i in 1 to 5 loop
    wait until falling_edge(clk_s);
 end loop;
 
 -- Set the value for the second dimension of matrix B and the first dimenzion of matrix C (parameter P)
 wait until falling_edge(clk_s);
 s00_axi_awaddr_s <= conv_std_logic_vector(B1_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '1';
 s00_axi_wdata_s <= conv_std_logic_vector(B1, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '1';
 s00_axi_wstrb_s <= "1111";
 s00_axi_bready_s <= '1';
 wait until s00_axi_awready_s = '1';
 wait until s00_axi_awready_s = '0';
 wait until falling_edge(clk_s);
 s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '0';
 s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '0';
 s00_axi_wstrb_s <= "0000";
 wait until s00_axi_bvalid_s = '0';
 wait until falling_edge(clk_s);
 s00_axi_bready_s <= '0';
 wait until falling_edge(clk_s);
 -- wait for 5 falling edges of AXI-lite clock signal
 for i in 1 to 5 loop
 wait until falling_edge(clk_s);
 end loop;
 
  wait until falling_edge(clk_s);
 s00_axi_awaddr_s <= conv_std_logic_vector(L1_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '1';
 s00_axi_wdata_s <= conv_std_logic_vector(L1, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '1';
 s00_axi_wstrb_s <= "1111";
 s00_axi_bready_s <= '1';
 wait until s00_axi_awready_s = '1';
 wait until s00_axi_awready_s = '0';
 wait until falling_edge(clk_s);
 s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '0';
 s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '0';
 s00_axi_wstrb_s <= "0000";
 wait until s00_axi_bvalid_s = '0';
 wait until falling_edge(clk_s);
 s00_axi_bready_s <= '0';
 wait until falling_edge(clk_s);
 -- wait for 5 falling edges of AXI-lite clock signal
 for i in 1 to 5 loop
 wait until falling_edge(clk_s);
 end loop;
 
 report "Loading matrix A element values into the core!";
 -- reset AXI4 interface. Reset will be 10 clock cycles wide
 s01_axi_aresetn_s <= '0';
 -- wait for 5 falling edges of AXI-lite clock signal
 for i in 1 to 5 loop
 wait until falling_edge(clk_s);
 end loop;
 -- release reset
 s01_axi_aresetn_s <= '1';
 wait until falling_edge(clk_s);

 -- Write some data using AXI4 interface and burst mode
 transfer_size_v := H_c*W_c;
 wait until falling_edge(clk_s);
 s01_axi_awaddr_s <= conv_std_logic_vector(MEMORY_MATRIX_OFFSET_C, s01_axi_awaddr_s'length);
 -- Set the number of data that will be transfered in one burst
 s01_axi_awlen_s <= conv_std_logic_vector(transfer_size_v-1, 8);
 s01_axi_awsize_s <= "010"; -- Size of each transfer will be 4 bytes
 s01_axi_awburst_s <= "01"; -- Burst type will be "INCR"
 s01_axi_awvalid_s <= '1';
 
 wait until s01_axi_awready_s = '1';
 wait until s01_axi_awready_s = '0';
 wait until falling_edge(clk_s);
 
 s01_axi_wdata_s <= conv_std_logic_vector(MEM_MATRIX_CONTENT(0), s01_axi_wdata_s'length);
 s01_axi_wvalid_s <= '1';
 s01_axi_wstrb_s <= "1111";
 s01_axi_wlast_s <= '0';
 s01_axi_bready_s <= '1';
 
 wait until s01_axi_wready_s = '1';
 wait until falling_edge(clk_s);
 wait until falling_edge(clk_s);

 for data_counter in 1 to transfer_size_v-2 loop
    s01_axi_wdata_s <= conv_std_logic_vector(MEM_MATRIX_CONTENT(data_counter),
    s01_axi_wdata_s'length);
    s01_axi_wvalid_s <= '1';
    s01_axi_wstrb_s <= "1111";
    s01_axi_wlast_s <= '0';
    s01_axi_bready_s <= '1';
 wait until falling_edge(clk_s);
 end loop;
 
 s01_axi_wdata_s <= conv_std_logic_vector(MEM_MATRIX_CONTENT(transfer_size_v-1), S01_axi_wdata_s'length);
 s01_axi_wvalid_s <= '1';
 s01_axi_wstrb_s <= "1111";
 s01_axi_wlast_s <= '1';
 s01_axi_bready_s <= '1';
  wait until falling_edge(clk_s);
     s01_axi_wdata_s <= conv_std_logic_vector(0, s01_axi_wdata_s'length);
     s01_axi_wvalid_s <= '0';
     s01_axi_wstrb_s <= "0000";
     s01_axi_wlast_s <= '0';
     s01_axi_awaddr_s <= conv_std_logic_vector(0, s01_axi_awaddr_s'length);
     s01_axi_awlen_s <= (others => '0');
     s01_axi_awburst_s <= "00";
     s01_axi_awvalid_s <= '0';
 if (s01_axi_bvalid_s = '1') then
    wait until s01_axi_bvalid_s = '0';
 else
     wait until s01_axi_bvalid_s = '1';
     wait until s01_axi_bvalid_s = '0';
 end if;
 wait until falling_edge(clk_s);
 s01_axi_bready_s <= '0';
 
 -------------------------------------------------------------------------------------------
 -- Load the element values for matrix B into the Matrix Multiplier core --
 -------------------------------------------------------------------------------------------
  report "Loading matrix B element values into the core!";
 -- reset AXI4 interface. Reset will be 10 clock cycles wide
 s01_axi_aresetn_s <= '0';
 -- wait for 5 falling edges of AXI-lite clock signal
 for i in 1 to 5 loop
 wait until falling_edge(clk_s);
 end loop;
 -- release reset
 s01_axi_aresetn_s <= '1';
 wait until falling_edge(clk_s);

 -- Write some data using AXI4 interface and burst mode
 transfer_size_v := L1*L1;
 wait until falling_edge(clk_s);
 s01_axi_awaddr_s <= conv_std_logic_vector(MEMORY_LOG_OFFSET_C, s01_axi_awaddr_s'length);
 -- Set the number of data that will be transfered in one burst
 s01_axi_awlen_s <= conv_std_logic_vector(transfer_size_v-1, 8);
 s01_axi_awsize_s <= "010"; -- Size of each transfer will be 4 bytes
 s01_axi_awburst_s <= "01"; -- Burst type will be "INCR"
 s01_axi_awvalid_s <= '1';
 
 wait until s01_axi_awready_s = '1';
 wait until s01_axi_awready_s = '0';
 wait until falling_edge(clk_s);
 
 s01_axi_wdata_s <= conv_std_logic_vector(MEM_LOG_CONTENT(0), s01_axi_wdata_s'length);
 s01_axi_wvalid_s <= '1';
 s01_axi_wstrb_s <= "1111";
 s01_axi_wlast_s <= '0';
 s01_axi_bready_s <= '1';
 
 wait until s01_axi_wready_s = '1';
 wait until falling_edge(clk_s);
 wait until falling_edge(clk_s);

 for data_counter in 1 to transfer_size_v-2 loop
    s01_axi_wdata_s <= conv_std_logic_vector(MEM_LOG_CONTENT(data_counter),
    s01_axi_wdata_s'length);
    s01_axi_wvalid_s <= '1';
    s01_axi_wstrb_s <= "1111";
    s01_axi_wlast_s <= '0';
    s01_axi_bready_s <= '1';
 wait until falling_edge(clk_s);
 end loop;
 
 s01_axi_wdata_s <= conv_std_logic_vector(MEM_LOG_CONTENT(transfer_size_v-1), S01_axi_wdata_s'length);
 s01_axi_wvalid_s <= '1';
 s01_axi_wstrb_s <= "1111";
 s01_axi_wlast_s <= '1';
 s01_axi_bready_s <= '1';
  wait until falling_edge(clk_s);
     s01_axi_wdata_s <= conv_std_logic_vector(0, s01_axi_wdata_s'length);
     s01_axi_wvalid_s <= '0';
     s01_axi_wstrb_s <= "0000";
     s01_axi_wlast_s <= '0';
     s01_axi_awaddr_s <= conv_std_logic_vector(0, s01_axi_awaddr_s'length);
     s01_axi_awlen_s <= (others => '0');
     s01_axi_awburst_s <= "00";
     s01_axi_awvalid_s <= '0';
 if (s01_axi_bvalid_s = '1') then
    wait until s01_axi_bvalid_s = '0';
 else
     wait until s01_axi_bvalid_s = '1';
     wait until s01_axi_bvalid_s = '0';
 end if;
 wait until falling_edge(clk_s);
 s01_axi_bready_s <= '0';
 
 ---start THE LAPLACIAN -----
  report "Starting the laplacian  process!";
 -- Set the value start bit (bit 0 in the CMD register) to 1
  wait until falling_edge(clk_s);
  s00_axi_awaddr_s <= conv_std_logic_vector(CMD1_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
  s00_axi_awvalid_s <= '1';
  s00_axi_wdata_s <= conv_std_logic_vector(1, C_S00_AXI_DATA_WIDTH_c);
  s00_axi_wvalid_s <= '1';
  s00_axi_wstrb_s <= "1111";
  s00_axi_bready_s <= '1';
  wait until s00_axi_awready_s = '1';
  wait until s00_axi_awready_s = '0';
  wait until falling_edge(clk_s);
 
  s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
  s00_axi_awvalid_s <= '0';
  s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
  s00_axi_wvalid_s <= '0';
  s00_axi_wstrb_s <= "0000";
  wait until s00_axi_bvalid_s = '0';
  wait until falling_edge(clk_s);
  s00_axi_bready_s <= '0';
  wait until falling_edge(clk_s);
 -- wait for 5 falling edges of AXI-lite clock signal
  for i in 1 to 5 loop
    wait until falling_edge(clk_s);
  end loop;
 
  report "Clearing the start bit!";
 -- Set the value start bit (bit 0 in the CMD register) to 1
 wait until falling_edge(clk_s);
 s00_axi_awaddr_s <= conv_std_logic_vector(CMD1_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '1';
 s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '1';
 s00_axi_wstrb_s <= "1111";
 s00_axi_bready_s <= '1';
 
 wait until s00_axi_awready_s = '1';
 wait until s00_axi_awready_s = '0';
 wait until falling_edge(clk_s);
 
 s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '0';
 s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '0';
 s00_axi_wstrb_s <= "0000";
 
 wait until s00_axi_bvalid_s = '0';
 wait until falling_edge(clk_s);
 s00_axi_bready_s <= '0';
 wait until falling_edge(clk_s);
 
 
   
   
   
  -------------------------------------------------------------------------------------------
 -- Wait until LAPLACIAN AND ZERO CROSSING core finishes fingind egdes --
 -------------------------------------------------------------------------------------------
 report "Waiting for the matric multiplication process to complete!";
 loop
     -- Read the content of the Status register
     wait until falling_edge(clk_s);
     s00_axi_araddr_s <= conv_std_logic_vector(STATUS_REG_ADDR_C, 5);
     s00_axi_arvalid_s <= '1';
     s00_axi_rready_s <= '1';
     wait until s00_axi_arready_s = '1';
     axi_read_data_v := s00_axi_rdata_s;
     wait until s00_axi_arready_s = '0';
     wait until falling_edge(clk_s);
     s00_axi_araddr_s <= conv_std_logic_vector(0, 5);
     s00_axi_arvalid_s <= '0';
     s00_axi_rready_s <= '0';
     
     -- Check is the 1st bit of the Status register set to one
     if (axi_read_data_v(0) = '1') then
     -- Matrix multiplication process completed
        exit;
     else
        wait for 1000 ns;
     end if;
 end loop;
 
 
 ---start THE ZERO CROSSING -----
  report "Starting the laplacian  process!";
 -- Set the value start bit (bit 0 in the CMD register) to 1
  wait until falling_edge(clk_s);
  s00_axi_awaddr_s <= conv_std_logic_vector(CMD2_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
  s00_axi_awvalid_s <= '1';
  s00_axi_wdata_s <= conv_std_logic_vector(1, C_S00_AXI_DATA_WIDTH_c);
  s00_axi_wvalid_s <= '1';
  s00_axi_wstrb_s <= "1111";
  s00_axi_bready_s <= '1';
  wait until s00_axi_awready_s = '1';
  wait until s00_axi_awready_s = '0';
  wait until falling_edge(clk_s);
 
  s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
  s00_axi_awvalid_s <= '0';
  s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
  s00_axi_wvalid_s <= '0';
  s00_axi_wstrb_s <= "0000";
  wait until s00_axi_bvalid_s = '0';
  wait until falling_edge(clk_s);
  s00_axi_bready_s <= '0';
  wait until falling_edge(clk_s);
 -- wait for 5 falling edges of AXI-lite clock signal
  for i in 1 to 5 loop
    wait until falling_edge(clk_s);
  end loop;
 
  report "Clearing the start bit!";
 -- Set the value start bit (bit 0 in the CMD register) to 1
 wait until falling_edge(clk_s);
 s00_axi_awaddr_s <= conv_std_logic_vector(CMD2_REG_ADDR_C, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '1';
 s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '1';
 s00_axi_wstrb_s <= "1111";
 s00_axi_bready_s <= '1';
 
 wait until s00_axi_awready_s = '1';
 wait until s00_axi_awready_s = '0';
 wait until falling_edge(clk_s);
 
 s00_axi_awaddr_s <= conv_std_logic_vector(0, C_S00_AXI_ADDR_WIDTH_c);
 s00_axi_awvalid_s <= '0';
 s00_axi_wdata_s <= conv_std_logic_vector(0, C_S00_AXI_DATA_WIDTH_c);
 s00_axi_wvalid_s <= '0';
 s00_axi_wstrb_s <= "0000";
 
 wait until s00_axi_bvalid_s = '0';
 wait until falling_edge(clk_s);
 s00_axi_bready_s <= '0';
 wait until falling_edge(clk_s);
 
  report "Waiting for the matric multiplication process to complete!";
 loop
     -- Read the content of the Status register
     wait until falling_edge(clk_s);
     s00_axi_araddr_s <= conv_std_logic_vector(STATUS_REG_ADDR_C, 5);
     s00_axi_arvalid_s <= '1';
     s00_axi_rready_s <= '1';
     wait until s00_axi_arready_s = '1';
     axi_read_data_v := s00_axi_rdata_s;
     wait until s00_axi_arready_s = '0';
     wait until falling_edge(clk_s);
     s00_axi_araddr_s <= conv_std_logic_vector(0, 5);
     s00_axi_arvalid_s <= '0';
     s00_axi_rready_s <= '0';
     
     -- Check is the 1st bit of the Status register set to one
     if (axi_read_data_v(0) = '1') then
     -- Matrix multiplication process completed
        exit;
     else
        wait for 1000 ns;
     end if;
 end loop;
 
 
 -------------------------------------------------------------------------------------------
 -- Read the elements of matrix C from the Matrix Multiplier core --
 -------------------------------------------------------------------------------------------
 report "Reading the results of the matrix multiplication process!";
 -- Read some data using AXI4 interface
 transfer_size_v := L1*L1;
 wait until falling_edge(clk_s);
 s01_axi_araddr_s <= conv_std_logic_vector(MEMORY_IM_OFFSET_C, s01_axi_araddr_s'length);
 -- Set the number of data that will be transfered in one burst
 s01_axi_arlen_s <= conv_std_logic_vector(transfer_size_v-1, 8);
 s01_axi_arsize_s <= "010"; -- Size of each transfer will be 4 bytes
 s01_axi_arburst_s <= "01"; -- Burst type will be "INCR"
 s01_axi_arvalid_s <= '1';
 s01_axi_rready_s <= '1';
 wait until s01_axi_arready_s = '1';
 wait until s01_axi_arready_s = '0';
 wait until falling_edge(clk_s);
 s01_axi_araddr_s <= conv_std_logic_vector(0, s01_axi_araddr_s'length);
 s01_axi_arlen_s <= (others => '0');
 s01_axi_arburst_s <= "00";
 s01_axi_arvalid_s <= '0';
 for data_counter in 1 to transfer_size_v loop
 wait until s01_axi_rvalid_s = '1';
 wait until s01_axi_rvalid_s = '0';
 wait until falling_edge(clk_s);
 end loop;
 wait until falling_edge(clk_s);
 s01_axi_rready_s <= '0';
 -- End of the test
 wait;
end process;


top: entity work.ip_module_v1_0(arch_imp)
generic map(
    WIDTH => WIDTH,
    SIZE => SIZE,
    WIDTH_KERNEL => WIDTH_KERNEL,
    SIZE_KERNEL => SIZE_KERNEL
)
port map(
-- Ports of Axi Slave Bus Interface S00_AXI
 s00_axi_aclk =>  clk_s,
 s00_axi_aresetn => s00_axi_aresetn_s,
 s00_axi_awaddr => s00_axi_awaddr_s,
 s00_axi_awprot => s00_axi_awprot_s,
 s00_axi_awvalid => s00_axi_awvalid_s,
 s00_axi_awready => s00_axi_awready_s,
 s00_axi_wdata => s00_axi_wdata_s,
 s00_axi_wstrb => s00_axi_wstrb_s,
 s00_axi_wvalid => s00_axi_wvalid_s,
 s00_axi_wready => s00_axi_wready_s,
 s00_axi_bresp => s00_axi_bresp_s,
 s00_axi_bvalid => s00_axi_bvalid_s,
 s00_axi_bready => s00_axi_bready_s,
 s00_axi_araddr => s00_axi_araddr_s,
 s00_axi_arprot => s00_axi_arprot_s,
 s00_axi_arvalid => s00_axi_arvalid_s,
 s00_axi_arready => s00_axi_arready_s,
 s00_axi_rdata => s00_axi_rdata_s,
 s00_axi_rresp => s00_axi_rresp_s,
 s00_axi_rvalid => s00_axi_rvalid_s,
 s00_axi_rready => s00_axi_rready_s,
 -- Ports of Axi Slave Bus Interface S01_AXI
 s01_axi_aclk => clk_s,
 s01_axi_aresetn => s01_axi_aresetn_s,
 s01_axi_awid => s01_axi_awid_s,
 s01_axi_awaddr => s01_axi_awaddr_s,
 s01_axi_awlen => s01_axi_awlen_s,
 s01_axi_awsize => s01_axi_awsize_s,
 s01_axi_awburst => s01_axi_awburst_s,
 s01_axi_awlock => s01_axi_awlock_s,
 s01_axi_awcache => s01_axi_awcache_s,
 s01_axi_awprot => s01_axi_awprot_s,
 s01_axi_awqos => s01_axi_awqos_s,
 s01_axi_awregion => s01_axi_awregion_s,
 s01_axi_awuser => s01_axi_awuser_s,
 s01_axi_awvalid => s01_axi_awvalid_s,
 s01_axi_awready => s01_axi_awready_s,
 s01_axi_wdata => s01_axi_wdata_s,
 s01_axi_wstrb => s01_axi_wstrb_s,
 s01_axi_wlast => s01_axi_wlast_s,
 s01_axi_wuser => s01_axi_wuser_s,
 s01_axi_wvalid => s01_axi_wvalid_s,
 s01_axi_wready => s01_axi_wready_s,
 s01_axi_bid => s01_axi_bid_s,
 s01_axi_bresp => s01_axi_bresp_s,
 s01_axi_buser => s01_axi_buser_s,
 s01_axi_bvalid => s01_axi_bvalid_s,
 s01_axi_bready => s01_axi_bready_s,
 s01_axi_arid => s01_axi_arid_s,
 s01_axi_araddr => s01_axi_araddr_s,
 s01_axi_arlen => s01_axi_arlen_s,
 s01_axi_arsize => s01_axi_arsize_s,
 s01_axi_arburst => s01_axi_arburst_s,
 s01_axi_arlock => s01_axi_arlock_s,
 s01_axi_arcache => s01_axi_arcache_s,
 s01_axi_arprot => s01_axi_arprot_s,
 s01_axi_arqos => s01_axi_arqos_s,
 s01_axi_arregion => s01_axi_arregion_s,
 s01_axi_aruser => s01_axi_aruser_s,
 s01_axi_arvalid => s01_axi_arvalid_s,
 s01_axi_arready => s01_axi_arready_s,
 s01_axi_rid => s01_axi_rid_s,
 s01_axi_rdata => s01_axi_rdata_s,
 s01_axi_rresp => s01_axi_rresp_s,
 s01_axi_rlast => s01_axi_rlast_s,
 s01_axi_ruser => s01_axi_ruser_s,
 s01_axi_rvalid => s01_axi_rvalid_s,
 s01_axi_rready => s01_axi_rready_s);
end Behavioral;