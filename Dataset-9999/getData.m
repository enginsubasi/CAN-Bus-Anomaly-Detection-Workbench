%=======================================================================
% Script/Function Name: getData
% Author             : Engin Subasi
% Email              : enginsubasi@gmail.com
% Date Created       : 07-Jan-2025
% Last Modified      : 07-Jan-2025
% Description        : 
% This script gets data from the source file
%=======================================================================


close all;
clear;
clc;

% Load normal_run_data-9999.csv into MATLAB workspace
filename = 'normal_run_data-9999.csv';

% Read the data into a table
opts = detectImportOptions(filename);

% Set the second column as a string
opts.VariableTypes{2} = 'char';

% Set columns 4 to 11 as strings
for i = 4:11
    opts.VariableTypes{i} = 'char';
end

% Set all columns after the 26th as strings
numVars = numel(opts.VariableNames);
for i = 27:numVars
    opts.VariableTypes{i} = 'char';
end

% Read the data with the updated import options
dataTable = readtable(filename, opts);

% Initialize an empty structure array
numRows = height(dataTable);
dataStruct = struct();

% Populate the structure with data row by row
for i = 1:numRows
    for col = 1:width(dataTable)
        % Get the variable name from the table
        varName = dataTable.Properties.VariableNames{col};
        
        % Assign the data to the structure field
        dataStruct(i).(varName) = dataTable{i, col};
    end

    if ( dataStruct(i).Var3 ~= 8 )
        dataStruct(i).Var12 = dataStruct(i).(dataTable.Properties.VariableNames{4+dataStruct(i).Var3});
        dataStruct(i).(dataTable.Properties.VariableNames{4+dataStruct(i).Var3}) = "";
    end

end

% Display the structure fields for verification
disp('Loaded structure fields:');
disp(fieldnames(dataStruct));

% Save the structure to the workspace
assignin('base', 'dataStruct', dataStruct);

% Confirm successful operation
disp('Data successfully loaded into MATLAB workspace as a structured array.');












% List of fields to be converted to numeric values
fieldsToConvert = {'Var2', 'Var4', 'Var5', 'Var6', 'Var7', 'Var8', 'Var9', 'Var10', 'Var11'};

% Number of elements in the structure
numRows = numel(dataStruct);

% Initialize a new structure
dataStructDec = dataStruct; % Copy the original structure

% Loop through each element in the structure
for i = 1:numRows
    for j = 1:numel(fieldsToConvert)
        fieldName = fieldsToConvert{j};
        
        % Convert the hexadecimal string to numeric value and assign to new structure
        if ischar(dataStruct(i).(fieldName){1}) % Ensure it is a string
            dataStructDec(i).(fieldName) = hex2dec(dataStruct(i).(fieldName));
        end
    end
end

% Display confirmation
disp('Fields converted to numeric values and stored in the new structure "dataStructDec".');

% Save the new structure to the workspace
assignin('base', 'dataStructDec', dataStructDec);
