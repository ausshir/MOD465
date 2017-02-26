fileID = fopen('dummy_coefs.txt','w');

fprintf(fileID,'//P2 Coefficients\n');
for i = 0:304
    fprintf(fileID,'assign PRECOMP_P2[%3d] = 18''sd%6d;\n', i,5);
end

fprintf(fileID,'\n\n');

fprintf(fileID,'//P1 Coefficients\n');
for i = 0:304
    fprintf(fileID,'assign PRECOMP_P1[%3d] = 18''sd%6d;\n', i,5);
end

fprintf(fileID,'\n\n');

fprintf(fileID,'//N1 Coefficients\n');
for i = 0:304
    fprintf(fileID,'assign PRECOMP_N1[%3d] = 18''sd%6d;\n', i,5);
end

fprintf(fileID,'\n\n');

fprintf(fileID,'//N2 Coefficients\n');
for i = 0:304
    fprintf(fileID,'assign PRECOMP_N2[%3d] = 18''sd%6d;\n', i,5);
end

fprintf(fileID,'\n\n');

fclose(fileID);
