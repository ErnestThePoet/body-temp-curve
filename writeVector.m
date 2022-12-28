function writeVector(fileName,vector)
fid=fopen(fileName,"wt");
fprintf(fid,"%f ",vector(1:end-1));
fprintf(fid,"%f",vector(end));
fclose(fid);