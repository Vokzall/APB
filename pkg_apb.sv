package pkg_apb;
    typedef struct packed {
        byte 	byte0;
        byte 	byte1;
        byte 	byte2;
        byte	bit_map;

    } data_packet_t;


    typedef union{ 
        struct packed{
            data_packet_t in_data;
            data_packet_t result_data;
            data_packet_t sys_inf;
            struct packed {
                struct packed{ 
                logic start;
                logic reset;
                logic flag_finish;
                logic flag_status;
                } s_control_bits;
                logic [27:0] RFU;
            } s_control_int;
        } s_data_map;

        
        data_packet_t [3:0] data;

    } t_u_map;
endpackage