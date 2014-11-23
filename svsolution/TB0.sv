module TB0 ();

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import TB0_pkg::*;  
    
    logic clk = 0;

    dut_if #(covuniq_pkg::t_a) dut_if_t_a(clk);
    dut_if #(covuniq_pkg::a_b) dut_if_a_b(clk);
    dut_if #(covuniq_pkg::b_c) dut_if_b_c(clk);
    dut_if #(covuniq_pkg::c) dut_if_c(clk);

    dut duta(
             .slave(dut_if_t_a), // input
             .master(dut_if_a_b) // output
             );
    dut dutb(
             .slave(dut_if_a_b),
             .master(dut_if_b_c)
             );
    dut dutc(
             .slave(dut_if_b_c),
             .master(dut_if_c)
             );

    always begin
        #10 clk = 1;
        #10 clk = 0;
    end

    always @(posedge clk) begin
        // if not a UVM test send in the input
        if (!$test$plusargs("UVM_TESTNAME")) begin
            dut_if_t_a.cmd <= 'h1;
            dut_if_t_a.adr <= $urandom_range(2,1);
            dut_if_t_a.data <= $urandom_range(7,0);        
        end
    end

    initial begin
        uvm_config_db#(dut_if_t_a_t)::set(null,"uvm_test_top","dut_if_t_a", dut_if_t_a);       

        dut_if_t_a.cmd <= 'h0;
        dut_if_t_a.adr <= 'h0;
        dut_if_t_a.data <= 'h0;
        
        if ($test$plusargs("UVM_TESTNAME")) begin
            run_test();
        end else begin
            `uvm_info("TB0", "Not a UVM_TEST", UVM_DEBUG)
            #2000;
        end

    end
   
endmodule
