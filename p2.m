% Primero creamos el sistema de inferencia difusa tipo 1.
fis1=sugfis;

% Añadimos variables de entrada al FIS.
fis1=addInput(fis1,[-1 1],'Name','E');
fis1=addInput(fis1,[-1 1],'Name','delE');

% Creamos 3 funciones de membresía de tipo triangular
% nombrados como negative (N), zero (Z) y positivo (P).
fis1=addMF(fis1,'E','trimf',[-2 -1 0],'Name','N');
fis1=addMF(fis1,'E','trimf',[-1 0 1],'Name','Z');
fis1=addMF(fis1,'E','trimf',[0 1 2],'Name','P');
fis1=addMF(fis1,'delE','trimf',[-2 -1 0],'Name','N');
fis1=addMF(fis1,'delE','trimf',[-1 0 1],'Name','Z');
fis1=addMF(fis1,'delE','trimf',[0 1 2],'Name','P');

% Generamos las salidas.
fis1=addOutput(fis1,[-1 1],'Name','U');

% Añadimos las funciones de la salida: negative big (NB), negative medium 
% (NM), zero (Z), positive medium (PM), y positive big (PB).
fis1=addMF(fis1,'U','constant',-1,'Name','NB');
fis1=addMF(fis1,'U','constant',-0.5,'Name','NM');
fis1=addMF(fis1,'U','constant',0,'Name','Z');
fis1=addMF(fis1,'U','constant',0.5,'Name','PM');
fis1=addMF(fis1,'U','constant',1,'Name','PB');

% CONVERTIMOS A UN FIS 2
fis2=convertToType2(fis1);

% Generamos el FOU definido por el valor scale.
scale=[0.2 0.9 0.2;0.3 0.9 0.3];
for i=1:length(fis2.Inputs)
    for j=1:length(fis2.Inputs(i).MembershipFunctions)
        fis2.Inputs(i).MembershipFunctions(j).LowerLag=0;
        fis2.Inputs(i).MembershipFunctions(j).LowerScale=scale(i,j);
    end
end

% Proporcionamos las reglas.
rules = [...
    "E==N & delE==N => U=NB"; ...
    "E==Z & delE==N => U=NM"; ...
    "E==P & delE==N => U=Z"; ...
    "E==N & delE==Z => U=NM"; ...
    "E==Z & delE==Z => U=Z"; ...
    "E==P & delE==Z => U=PM"; ...
    "E==N & delE==P => U=Z"; ...
    "E==Z & delE==P => U=PM"; ...
    "E==P & delE==P => U=PB" ...
    ];
fis2=addRule(fis2,rules);

figure(1)
subplot(1,2,1)
plotmf(fis2,'input',1)
title('Input 1')
subplot(1,2,2)
plotmf(fis2,'input',2)
title('Input 2')

figure(2)
gensurf(fis2)
title('Control surface of type-2 FIS')