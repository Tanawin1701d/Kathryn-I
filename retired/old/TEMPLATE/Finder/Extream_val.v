module Extream_val
// binary tree structure
#(
    parameter level   = 4,
    parameter data_sz = 4,
    parameter comparator = 0//0 -> min , 1 -> max
)
(
    output wire[data_sz                - 1:0] result,
    input  wire[(1<<(level-1))*data_sz - 1:0] raw // number of data set must have 2^(level-1)
    
);
    localparam amt_lg_node = (1<<(level-1)) -1;

    input  wire[((1<<level) - 1)*data_sz - 1:0] tree;
    
    genvar node;
    
    for (node = 0; node < amt_lg_node; node = node + 1)begin
         
                if (comparator)begin
                    assign  tree[node*data_sz + data_sz -1 :node*data_sz] =
                       tree[(node*2+1)*data_sz + data_sz -1 :(node*2+1)*data_sz] 
                    >= tree[(node*2+2)*data_sz + data_sz -1 :(node*2+2)*data_sz]
                    ?  tree[(node*2+1)*data_sz + data_sz -1 :(node*2+1)*data_sz] 
                    :  tree[(node*2+2)*data_sz + data_sz -1 :(node*2+2)*data_sz];
                end else begin
                    assign  tree[node*data_sz + data_sz -1 :node*data_sz] =
                       tree[(node*2+1)*data_sz + data_sz -1 :(node*2+1)*data_sz] 
                    <= tree[(node*2+2)*data_sz + data_sz -1 :(node*2+2)*data_sz]
                    ?  tree[(node*2+1)*data_sz + data_sz -1 :(node*2+1)*data_sz] 
                    :  tree[(node*2+2)*data_sz + data_sz -1 :(node*2+2)*data_sz];
                end
    end

    assign result = tree[data_sz-1:0];
    assign tree[(amt_lg_node)*data_sz + (1<<(level-1))*data_sz -1 :(amt_lg_node)*data_sz] = raw;

endmodule