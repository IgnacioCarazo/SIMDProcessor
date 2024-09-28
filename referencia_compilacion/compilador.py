import argparse
import os

# Globals


register_dict = {
    # Uso general
    "V0": "0000",  # Vectorial
    "V1": "0001",  # Vectorial
    "V2": "0010",  # Vectorial
    "V3": "0011",  # Vectorial
    "R0": "0100",  # Escalar
    "R1": "0101",  # Escalar
    "R2": "0110",  # Escalar
    "R3": "0111",  # Escalar
    # Uso específico
    "R4": "1000",
    "R5": "1001",
    "R6": "1010",
    "R7": "1011",
    "R8": "1100",
    "R9": "1101",  # Ultimo byte
    "R10": "1110",  # Contador de pixeles
    "R11": "1111",  # PC
}

vectorial_regs = ["V0", "V1", "V2", "V3"]
escalar_regs = ["R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7" ,"R8", "R9", "R10", "R11"]

op_code_dict = {
    "SLT": "1010",
    "SLI": "1000",
    "SNI": "1001",
    "INC": "0111",
    "MVM": "1101",
    "ALM": "1100",
    "CRGS": "0000",
    "CRGM": "1111",
    "XOR": "0001",
    "SUM": "0010",
    "CMP": "0011",
    "MUL": "0100",
    "SHFD": "0101",
    "SHFI": "0110",
    "KEXP": "0001",
    "SUBB": "0001",
    "SROS": "0010",
    "MIXC": "0011",
    "ARKE": "0100",
    "SUBBINV": "0101",
    "MIXCINV": "0110",
}

# Branch que almacenará
branchs_dict = {}

# listas de instrucciones que esperan por cantidad de argumentos
one_operand_instructions = ["SLT", "SLI", "SNI", "INC","KEXP","SUBB","SROS","MIXC","ARKE","SUBBINV","MIXCINV"]

two_operand_instructions = [
    "CRGS",
    "CRGM",
    "MVM", 
    "ALM",
    "XOR",
    "SUM",
    "CMP",
    "MUL",
    "SHFD",
    "SHFI",
]


stall = "000010000000000000000000"
inc = "011111100000000000000000"

# Funciones


# Chequea sí ingresó la ruta en los argumentos a la hora de ejecutarlo
def checks_if_path_is_None(path):
    if path is None:
        raise Exception(
            "Debe ingresar el path del código a compilar. Se recomienda usar -f <path> al compilar"
        )


# Chequea si la ruta existe
def checks_if_path_exists(path):
    if not os.path.exists(path):
        raise Exception("Debe ingresar un path existente")


# Obtiene las lineas del archivo sin los saltos de linea
def get_file_lines(path):
    with open(path, "r") as file:
        lineas = [line.rstrip() for line in file.readlines()]
        return lineas


# Elimina los comentarios de una unica linea
def remove_comments_single_line(string):
    result = string.split("$")
    return result[0]


# Remueve todos los comentarios de todas las lineas
def remove_all_comments(lines):
    result = []
    for line in lines:
        result.append(remove_comments_single_line(line).upper())
    return result


# Convierte el string de una instrucción en una lista con los elementos de la instrucción
# SUM Ri Rj -> [SUM, ]
def make_lists_from_instructions(lines):
    result = []
    for line in lines:
        result.append(line.split(" "))
    return result


# Elimina los espacios vacios de una sola linea
def clean_empty_strings_single(line):
    return [result for result in line if bool(result)]


# Elimina los espacios vacios de todas las lineas
def clean_empty_strings(lines):
    result = []
    for line in lines:
        result.append(clean_empty_strings_single(line))
    return result


# Funciones agrupadoras


def checks_input_file(path_source_file):
    # Chequea si ingresó la ruta en los argumentos a la hora de ejecutarlo
    checks_if_path_is_None(path_source_file)

    # Chequea si la ruta existe
    checks_if_path_exists(path_source_file)


# Formatea el archivo a listas con los elementos de la instrucción
# Retorna la matriz de instrucciones.
def reformat_input_file(path_source_file):
    # Obtiene las lineas del archivo sin los saltos de linea
    lines_source_file = get_file_lines(path_source_file)

    # Elimina todos los comentarios definidos por el caracter $
    lines_source_file_no_comments = remove_all_comments(lines_source_file)
    del lines_source_file

    # Separar cada linea en una lista con cada elemento de la instrucción
    instruction_matrix = make_lists_from_instructions(lines_source_file_no_comments)
    del lines_source_file_no_comments

    instruction_matrix = clean_empty_strings(instruction_matrix)

    return instruction_matrix


def calc_binary_from_counter(compiled_instructions_counter):
    # Multiplicar el contador por 4
    result_decimal = compiled_instructions_counter * 4

    # Convertir el resultado a formato binario de 8 bits
    result_binario = bin(result_decimal & 0xFF)[2:].zfill(16)

    return result_binario


def process_branch_instruction(instruction, compiled_instructions_counter):
    global branchs_dict
    binary_address = calc_binary_from_counter(compiled_instructions_counter)
    if instruction not in branchs_dict:
        branchs_dict[instruction] = binary_address
    else:
        raise Exception(f"La branch {instruction} ya fue definida anteriormente.")


def remove_empty_lines(list):
    result = []
    for item in list:
        if len(item) != 0:
            result.append(item)
    return result


def add_stalls(list):
    result = []
    for item in list:
        stalls_counter = 0
        result.append(item)
        if ":" not in item[0]:
            while stalls_counter <= 4:
                result.append(["STALL"])
                stalls_counter += 1
    return result


def fill_branch_dict(instruction_matrix):
    instruction_counter = 0
    # devolverá la listas sin las instrucciones de branch
    result = []
    for instruction_list in instruction_matrix:
        if len(instruction_list) == 1:
            if instruction_list[0] in ["INC", "STALL"]:
                result.append(instruction_list)
                instruction_counter += 1
            elif ":" in instruction_list[0]:
                instruction = instruction_list[0].replace(":", "")
                process_branch_instruction(instruction, instruction_counter)
            else:
                raise Exception(
                    f"Branch definida de manera incorrecta en la branch {instruction_list[0]}. Posible : faltante."
                )
        else:
            result.append(instruction_list)
            instruction_counter += 1
    return result


def compile_jumps(instruction):
    global branchs_dict, op_code_dict
    command = instruction[0]
    command_opcode = op_code_dict[command]
    branch = instruction[1]

    try:
        branch_dir = branchs_dict[branch]
    except:
        raise Exception(f"La branch {branch} no existe")

    return f"{command_opcode}0000{branch_dir}"


# "MVM", "ALM","KEXP","SUBB","SROS","MIXC","ARKE","SUBBINV","MIXCINV"
def compile_one_op(instruction):
    global register_dict, op_code_dict, vectorial_regs
    command = instruction[0]
    
    command_opcode = op_code_dict[command]
    register = instruction[1]

    if register not in vectorial_regs:
        raise Exception(f"Registro {register} inválido en la instrucción {instruction}")
    else:
        register_code = register_dict[register]
        return f"{command_opcode}{register_code}1110000000000000"


def get_binary_from_hexa_dec(string):
    if string.startswith("0X"):
        valor_hex = string[2:]
        try:
            decimal = int(valor_hex, 16)
            if not 0 <= decimal <= 65535:
                raise Exception(
                    f"Error: Valor hexadecimal fuera de rango (0-FFFF): {string}"
                )
            binario = bin(decimal)[2:].zfill(16)
            return binario
        except ValueError:
            raise Exception(f"Error: Valor hexadecimal inválido: {string}")

    elif string.startswith("#"):
        valor_dec = string[1:]
        try:
            decimal = int(valor_dec)
            if 0 <= decimal <= 65535:
                binario = bin(decimal)[2:].zfill(16)
                return binario
            else:
                raise Exception(
                    f"Error: Valor decimal fuera de rango (0-65535): {string}"
                )
        except ValueError:
            raise Exception(f"Error: Valor decimal inválido: {string}")
    else:
        raise Exception(f"Error: Formato de string inválido: {string}")


# "CRGS", "CRGM"
def compile_mem_reg_inst(instruction):
    global register_dict, op_code_dict, escalar_regs
    command = instruction[0]
    command_opcode = op_code_dict[command]
    register = instruction[1]
    imm = instruction[2]
    imm_binary = get_binary_from_hexa_dec(imm)


    if register not in escalar_regs:
        raise Exception(
            f"Registro no escalar en la instrucción: {command} {register} {imm}"
        )
    else:
        register_code = register_dict[register]
        return f"{command_opcode}{register_code}{imm_binary}"


# "XOR", "SUM", "CMP", "MUL", "SHFD", "SHFI"
def compile_two_regs_inst(instruction):
    global register_dict, op_code_dict, escalar_regs, vectorial_regs
    command = instruction[0]
    command_opcode = op_code_dict[command]
    r1 = instruction[1]
    V2 = instruction[2]
    
    r1_code = register_dict[r1]
    V2_code = register_dict[V2]
    return f"{command_opcode}{r1_code}{V2_code}000000000000"


def save_results(results, file_name):

    try:
        with open(file_name, "w") as file:
            for item in results:
                file.write(str(item) + "\n")
        print(
            f"Los resultados se han guardado en el archivo '{file_name}' correctamente."
        )
    except IOError:
        print("Error al guardar la lista en el archivo.")


def binary_to_hex(binary):
    # Convertir el número binario a hexadecimal
    hexadecimal = format(int(binary, 2), "06X")

    return hexadecimal


def list_binary_to_hex(list):
    result = []
    for item in list:
        hexa = binary_to_hex(item)
        result.append(hexa)
    return result


def compile_instructions(instruction_matrix):
    # reformat list. elimina lineas vacias
    instruction_matrix = remove_empty_lines(instruction_matrix)

    # Añade los stalls necesarios
    instruction_matrix = add_stalls(instruction_matrix)
    # print(instruction_matrix)

    # Popula el diccionario de branches y elimina las instrucciones de branching
    instruction_matrix = fill_branch_dict(instruction_matrix)

    compiled_instructios_result = [stall]
    compiled_instructions_counter = 0
    line_counter = 1

    # calcula la direccion de las branches y las elimina de la lista de instrucciones

    for instruction_list in instruction_matrix:
        instruction_length = len(instruction_list)
        # Comprueba instrucciones de un operando. Solamente INC. Las branchs ya han sido procesadas
        if instruction_length == 1:
            if instruction_list[0] == "INC":
                compiled_instruction = inc
            elif instruction_list[0] == "STALL":
                compiled_instruction = stall
            else:
                raise Exception(f"Instrucción inválida en la linea {line_counter}")
        # Comprueba instrucciones de dos operandos
        elif instruction_length == 2:
            if instruction_list[0] in one_operand_instructions:
                # Si es una de las siguientes instrucciones: "SLT", "SLI", "SNI"
                if instruction_list[0] in one_operand_instructions[:3]:
                    compiled_instruction = compile_jumps(instruction_list)

                # Si es una de las siguientes instrucciones: "MVM", "ALM"
                else:
                    compiled_instruction = compile_one_op(instruction_list)

            else:
                raise Exception(f"Instrucción inválida en la linea {line_counter}")

        # Comprueba instrucciones de dos operandos
        # "CRGS", "CRGM", "XOR", "SUM", "CMP", "MUL", "SHFD", "SHFI"
        elif instruction_length == 3:
            if instruction_list[0] in two_operand_instructions:
                # "CRGS", "CRGM"
                if instruction_list[0] in two_operand_instructions[:2]:
                    compiled_instruction = compile_mem_reg_inst(instruction_list)
                # "XOR", "SUM", "CMP", "MUL", "SHFD", "SHFI"
                else:
                    compiled_instruction = compile_two_regs_inst(instruction_list)

            else:
                raise Exception(f"Instrucción inválida en la linea {line_counter} {instruction_list}")

        else:
            print(instruction_list)
            raise Exception(f"Instrucción inválida en la linea {line_counter} {instruction_list}")

        compiled_instructios_result.append(compiled_instruction)
        line_counter += 1
        compiled_instructions_counter += 1

    return compiled_instructios_result


# main --------------------------------------------------------------------------------------------------------------------------------------


def main():
    # Recibe el path del codigo fuente
    # Debe compilarse como py compiler.py -f <path>
    script_dir = os.path.dirname(os.path.abspath(__file__))  # Obtiene la ruta del directorio actual del script
    relative_path = 'prueba_comp.txt'  # Nombre del archivo
    path_source_file = os.path.join(script_dir, relative_path)
    
    #path_source_file = input('Ubicaccion del archivo (.txt)')
    # Chequea el archivo de entrada.

    checks_input_file(path_source_file)

    # Formate el archivo de entrada a una estructura de listas

    instruction_matrix = reformat_input_file(path_source_file)

    # Compila las instrucciones
    compiled_instructions = compile_instructions(instruction_matrix)

    # De binario a hexa
    compiled_instructions = list_binary_to_hex(compiled_instructions)
    relative_path = 'results.txt'  # Nombre del archivo
    path_out_file = os.path.join(script_dir, relative_path)
    save_results(compiled_instructions, "results.txt")
    print('fin de compilacion')


# Verifica si el archivo se está ejecutando como el programa principal
if __name__ == "__main__":
    main()
