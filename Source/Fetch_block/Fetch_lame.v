module Fetch_lame 
#(
    parameter W_addr_pah = 5,
    parameter W_data_pah = 32,
    parameter W_addr_arh = 5,
    parameter W_data_arh = 32
)

(
    //////////// output data flow
    output wire[W_data_arh-1:0] instruct,
    output wire[W_data_arh-1:0] pc_out,
    output wire[W_data_arh-1:0] spec,
    output wire busy,
    ////////////// input data control unit
    input wire[W_data_arh-1:0] pc_in,
    ////////////// input control
    input  wire stall,
    input  wire clear,
    input  wire clock
);
    ///// variable declar
    reg[W_data_arh-1:0] pc;
    reg                 clear_status;
    reg                 stall_status;
    reg[W_data_arh-1:0] lame_storage[1<<10-1:0];
    ///// assign input

    ///////////////////////manage status////
    always @(posedge clock) begin
       
        if ( clear )begin
            
            clear_status <= 1;
            stall_status <= 0;

        end else begin
            
            clear_status <= 0;
            if ( stall )begin
                stall_status <= 1;
            end else begin
                stall_status <= 0;
                pc <= pc_in;
            end
        
        end
    
    end

    //////////////////////////////////////////////

        ///// assign output
    assign busy = 0;
    assign spec = 0;
    assign pc_out = pc;
    assign instruct = lame_storage[pc];




    
endmodule