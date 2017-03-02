
mapper_power_size = 10;
error_power_size = 8;
lut_size = error_power_size + mapper_power_size;

mer_lut = zeros(1,2^(lut_size));

fileID = fopen('LUT/mer_lut.vh','w');

counter = 0;

for mapper_power = 1000:4:5090
    for error_power = 1:1:254
        
        counter = counter + 1
        
        lut_index1 = dec2base(mapper_power-1000, 2, 12);
        lut_index1 = lut_index1(1:end-2);
        lut_index2 = dec2base(error_power, 2, 8);
        lut_str = strcat(lut_index1, lut_index2);
        
        lut_value = round(10*log10(mapper_power/error_power));
        if((lut_value > 7) || (lut_value < 128))
            fprintf(fileID,'18''b%s : approx_mer = 7''sd%d;\n', lut_str, lut_value);
        else
            fprintf(fileID,'18''b%s : approx_mer = -7''sd1;\n', lut_str);
        end
    end
end

fclose(fileID);
