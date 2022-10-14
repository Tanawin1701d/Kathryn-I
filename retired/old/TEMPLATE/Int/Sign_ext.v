module Sign_ext
    #(
        parameter W_PD_out = 32,
        parameter W_PD_in  = 12
    )
    (
        output wire[W_PD_out-1 : 0] DFO_PD_out,
        input  wire[W_PD_in -1 : 0] DFI_PD_in
    );

    assign DFO_PD_out =  {
                            { (W_PD_out - W_PD_in){ DFI_PD_in[W_PD_in-1] } },
                            DFI_PD_in
                         };

endmodule
