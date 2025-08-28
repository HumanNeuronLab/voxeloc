function saveMGRID(outputData,fName,patientID)


nElectrodes.Depth = length(fieldnames(outputData));
nElectrodes.Strips = 0;
nElectrodes.Grids = 0;

fid = fopen(fName,'w');
fprintf(fid, '#vtkpxElectrodeMultiGridSource File\n');
fprintf(fid, ['#Description\n' patientID '\n']);
fprintf(fid, '#Comment\n');
fprintf(fid, 'no additional comment\n');
%fprintf(fid, '#Number of Depth Electrodes\n%d\n',nElectrodes.Depth);
%fprintf(fid, '#Number of Strips\n%d\n',nElectrodes.Strips);
fprintf(fid, '#Number of Grids\n %d\n',nElectrodes.Depth);
if nElectrodes.Depth
    for i = 1:nElectrodes.Depth
        field = ['Electrode' num2str(i)];
        fprintf(fid, '#- - - - - - - - - - - - - - - - - - -\n');
        fprintf(fid, '# Electrode Grid %d\n',i-1);
        fprintf(fid, '- - - - - - - - - - - - - - - - - - -\n');
        fprintf(fid, '#vtkpxElectrodeGridSource File v2\n');
        elecName = outputData.(field).Name;
        fprintf(fid, '#Description\n%s\n',elecName);
        numContacts = outputData.(field).numContacts;
        fprintf(fid, '#Dimensions\n 1 %d\n',numContacts);
        contactDist = outputData.(field).contactDist;
        fprintf(fid, '#Electrode Spacing\n %.2f %.2f\n',contactDist, contactDist);
        elecType = 0;
        fprintf(fid, '#Electrode Type\n%d\n',elecType);
        elecRadius = 2;
        fprintf(fid, '#Radius\n%.3f\n',elecRadius);
        elecThickness = 0.05;
        fprintf(fid, '#Thickness\n%.3f\n',elecThickness);
        elecColor = outputData.(field).Color;
        fprintf(fid, '#Color\n%.3f %.3f %.3f\n',elecColor(1),elecColor(2),elecColor(3));
        for j = 1:numContacts
            fprintf(fid, '#- - - - - - - - - - - - - - - - - - -\n');
            fprintf(fid, '# Electrode 0 %d\n',j-1);
            fprintf(fid, '- - - - - - - - - - - - - - - - - - -\n');
            fprintf(fid, '#vtkpxElectrodeSource2 File\n');
            fprintf(fid, '#Position\n');
            contactCoord = outputData.(field).contact(numContacts-j+1,:);
            fprintf(fid, ' %f %f %f\n',contactCoord(1),contactCoord(2),256-contactCoord(3));
            fprintf(fid, ['#Normal\n 1.0000 0.0000 0.0000\n#Motor Function\n' ...
                '0\n#Sensory Function\n0\n#Visual Function\n0'...
                '\n#Language Function\n0\n#Auditory Function\n0'...
                '\n#User1 Function\n0\n#User2 Function\n0'...
                '\n#Seizure Onset\n0\n#Spikes Present\n0\n#Electrode Present'...
                '\n1\n#Electrode Type\n0\n#Radius\n%.3f\n#Thickeness'...
                '\n%.3f\n#Values\n1\n0.000000\n'],...
                elecRadius,elecThickness);
        end
    end
end

fclose(fid);

end