module Mux
// binary tree structure
#(
    parameter level   = 4,
    parameter data_sz = 4,
    parameter sel_sz  = 3
)
(
    output wire[data_sz                - 1:0] result,
    input  wire[(1<<(level-1))*data_sz - 1:0] raw, // number of data set must have 2^(level-1)
    input  wire[sel_sz                 - 1:0] sel
    
);
    localparam amt_lg_node = (1<<(level-1)) -1;
    localparam amt_lv_node = 1 <<(level-1);

    wire[amt_lv_node+amt_lg_node          :0] lg_tree; // logic   tree 
    wire[(amt_lv_node+amt_lg_node)*data_sz:0] tf_tree; // tranfer tree
    
    genvar i;

    for(i = 0; i < amt_lg_node; i = i + 1)begin
        assign lg_tree[i]         = lg_tree[2*i+2];
        assign tf_tree[i*data_sz] = lg_tree[i] ?   tf_tree[ (2*i+2)*data_sz + data_sz - 1 : (2*i+2)*data_sz] :
                                                   tf_tree[ (2*i+1)*data_sz + data_sz - 1 : (2*i+1)*data_sz] ;
    end

    for(i = amt_lg_node; i < amt_lg_node + amt_lv_node; i = i + 1)begin
        assign lg_tree[i]         = ((i-amt_lg_node) == sel);
    end

    assign tf_tree[(amt_lg_node + amt_lv_node)*data_sz-1 : amt_lg_node*data_sz] = raw;
    assign result = tf_tree[data_sz:0];

endmodule