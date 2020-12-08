% data = importdata('C:\Users\19095\Documents\ECE251C\AsphaltPavementType\AsphaltPavementType_TRAIN.arff');
% 
% a = data(2439);
% 
% Str = sprintf('%s,', a{:});
% Num = sscanf(Str, '%g,', [1, inf]).';
% 
% a = data(2450);
% 
% Str = sprintf('%s,', a{:});
% Num2 = sscanf(Str, '%g,', [1, inf]).';
% 
% 
% a = data(2600);
% 
% Str = sprintf('%s,', a{:});
% Num3 = sscanf(Str, '%g,', [1, inf]).';

data = importdata('C:\Users\19095\Documents\ECE251C\AsphaltPavementType\AsphaltPavementType_TRAIN.ts');

% data{76}