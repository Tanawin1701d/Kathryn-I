//select onehot free list
module selFl
#( 
    parameter SIZE = 1 
)
(
    input  logic[SIZE-1:0] onehot_input,
    output logic[SIZE-1:0] onehot_output                

);

    wire[SIZE+1-1:0] internal_input;
    wire[SIZE+1-1:0] is_prev_used;
    wire[SIZE+1-1:0] internal_output;

    assign internal_input     = { onehot_input , 1'b0 };
    assign is_prev_used[0]    = 1'b0;
    assign internal_output[0] = 1'b0;

    genvar i;
    for (i = 1; i <= SIZE; i = i + 1) begin
        assign is_prev_used   [i] = (  is_prev_used[i-1]  | internal_input[i] );
        assign internal_output[i] = ((~is_prev_used[i-1]) & internal_input[i] );
    end

    

    assign onehot_output = internal_output[SIZE+1-1:1];

endmodule