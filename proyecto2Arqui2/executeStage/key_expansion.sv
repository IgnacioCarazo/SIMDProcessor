module key_expansion (
    input logic [127:0] key_in,         // Clave de entrada (128 bits)
    input logic clk,
    input logic rst_n,
    output logic [127:0] round_keys [10:0], // Array para las 11 claves de ronda
    input logic [11:0] addr,              // Dirección para acceder a la memoria unificada
    output logic [127:0] data_out         // Datos leídos de la memoria unificada
);

    // Señales internas
    logic [127:0] temp_key;
    logic [31:0] temp_word;
    logic [7:0] sbox_value;
    logic [31:0] rcon_value;
    integer i;

    // Instancia de memoria unificada
    unified_memory mem_unificada (
        .addr(addr),
        .data_out(data_out)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: inicializar claves de ronda
            round_keys[0] <= key_in;
            for (i = 1; i < 11; i = i + 1) begin
                round_keys[i] <= 128'b0;
            end
        end else begin
            // Key Expansion
            for (i = 0; i < 11; i = i + 1) begin
                if (i == 0) begin
                    round_keys[i] <= key_in;
                end else begin
                    // Aplicar RotWord, SubWord y XOR con R-Con

                    // Obtener el último word de la clave de ronda anterior
                    temp_word = round_keys[i-1][127:96];
                    
                    // RotWord
                    temp_word = {temp_word[7:0], temp_word[31:8]};
                    
                    // Acceso a la S-Box desde la memoria unificada
                    addr = temp_word[7:0];   // Dirección de la S-Box en el rango 0-255
                    sbox_value = data_out[7:0];  // Obtener valor de la S-Box
                    
                    // SubWord usando el valor de S-Box
                    temp_word = {sbox_value, sbox_value[7:0], sbox_value[7:0], sbox_value[7:0]};
                    
                    // Acceso a R-Con desde la memoria unificada
                    addr = 256 + (i-1);  // Dirección de R-Con a partir de 256
                    rcon_value = data_out[31:0];  // Obtener valor de R-Con
                    
                    // XOR con la clave anterior, el valor de R-Con y la salida de S-Box
                    round_keys[i] = round_keys[i-1] ^ {temp_word, 96'b0} ^ rcon_value;
                end
            end
        end
    end
endmodule
