%% AFINADOR DIGITAL - PROCESSAMENTO DIGITAL DE SINAIS
%                Código Principal
%  Gabriel Molina de Lima  Gustavo Rodrigues Bassaco
%  Pedro Mian Parra        Thomas Oliveira Rocha Sampaio Silva

%Carregando Audio
disp("[1] Abrir áudio do computador [2] Gravar com o microfone.");
selecao = input('Escolha uma opção: ');

%Switch caso usuario escolher se quer gravar ou importar audio
switch selecao

    case 1
        disp("Escolha um arquivo de áudio:")
        [arq,path] = uigetfile('*.wav','Escolha um arquivo de áudio:');
        if isequal(arq,0)
           disp('Operação Cancelada pelo usuário');
           exit
        else
           disp(['Arquivo selecionado: ', fullfile(path,arq)]);
        end

    case 2
        arq = audiorecorder(44100,16,1);
        recDuration = 5;
        disp("Começando a gravar (5s de Gravação).")
        recordblocking(arq,recDuration);
        disp("Fim da gravação.")
        oi = getaudiodata(arq);
        filename = 'oi.wav';
        audiowrite(filename,oi,44100)
        arq = filename;
        
end

%tempo e fft do áudio original
[audio,Fs] = audioread(arq);
TamAudio = length(audio);
TempoAudio = 0:1/Fs:(TamAudio-1)/Fs;
fftAudio = fft(audio);
P2 = abs(fftAudio/TamAudio);
P1 = P2(1:TamAudio/2+1);
P1(2:end-1) = 2*P1(2:end-1);
freqAudio = Fs*(0:(TamAudio/2))/TamAudio;


%pedindo a nota e a oitava requerida
disp("Escolha uma nota: [C]=1 [C#]=2 [D]=3 [D#]=4 [E]=5 [F]=6 [F#]=7 [G]=8 [G#]=9 [A]=10 [A#]=11 [B]=12");
nota = input('Digite a nota: ');

disp("Escolha a oitava: [1] Oitava [2] Oitava [3] Oitava [4] Oitava [5] Oitava");
oitava=input('Digite a oitava: ');

%frequencias das notas musicais reais
do = 31.70:33.70;
do_sustenido = 33.65:35.65;
re=35.71:37.71;
re_sustenido=37.89:39.89;
mi=40.20:42.20;
fa=42.65:44.65;
fa_sustenido=45.71:47.71;
sol=48:50;
sol_sustenido=50.91:54.91;
la=54:56;
la_sustenido=57.27:59.27;
si=60.74:62.74;
vetorNotas = [{do},{do_sustenido},{re},{re_sustenido},{mi},{fa},{fa_sustenido},{sol},{sol_sustenido},{la},{la_sustenido},{si}];

%% VERIFICANDO NOTA COM MAIOR ENERGIA E PLOTANDO GRÁFICO

notasvet = 1:12;
oitavasvet = 1:5;
energiavet = 1:60;
auxk = 0;

for j = oitavasvet
    for k = vetorNotas
        auxk = auxk+1;
       [valorInicial,valorFinal] = calculaOitavas(j,cell2mat(k));
       filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
       energiavet(auxk) = calculaEnergia(filtrado);
    end
end

energiavet2 = [(energiavet(1)+energiavet(13)+energiavet(25)+energiavet(37)+energiavet(49)),(energiavet(2)+energiavet(14)+energiavet(26)+energiavet(38)+energiavet(50)),(energiavet(3)+energiavet(15)+energiavet(27)+energiavet(39)+energiavet(51)),(energiavet(4)+energiavet(16)+energiavet(28)+energiavet(40)+energiavet(52)),(energiavet(5)+energiavet(17)+energiavet(29)+energiavet(41)+energiavet(53)),(energiavet(6)+energiavet(18)+energiavet(30)+energiavet(42)+energiavet(54)),(energiavet(7)+energiavet(19)+energiavet(31)+energiavet(43)+energiavet(55)),(energiavet(8)+energiavet(20)+energiavet(32)+energiavet(44)+energiavet(56)),(energiavet(9)+energiavet(21)+energiavet(33)+energiavet(45)+energiavet(57)),(energiavet(10)+energiavet(22)+energiavet(34)+energiavet(46)+energiavet(58)),(energiavet(11)+energiavet(23)+energiavet(35)+energiavet(47)+energiavet(59)),(energiavet(12)+energiavet(24)+energiavet(36)+energiavet(48)+energiavet(60))];
stem(notasvet,energiavet2,'filled','black');
[y,x] = max(energiavet2);
hold on;
stem(x,y,'filled','r');
legend('','Nota com maior energia');
xticks([1 2 3 4 5 6 7 8 9 10 11 12]);
xticklabels({'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'});
title('Nota com maior energia')
xlabel('Notas');
ylabel('Energia');
grid on


%% FILTRANDO BASEADO NA NOTA ESCOLHIDA PELO USUÁRIO
switch nota

    case 1
        
        nota_a = "C(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,do);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);

        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);
        

    case 2
        
        nota_a = "C#(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,do_sustenido);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);

        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);

    case 3
        
        nota_a = "D(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,re);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);

        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);


    case 4
        
        nota_a = "D#(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,re_sustenido);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);

        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);        
   
    
    case 5
        
        nota_a = "E(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,mi);

        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);

        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);

    case 6

        nota_a = "F(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,fa);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);
   
        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);


    case 7
     
        nota_a = "F#(" + oitava + ")";

        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,fa_sustenido);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);

        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);
   
    case 8
        
        nota_a = "G(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,sol);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);   
        
        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);

    case 9

        nota_a = "G#(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,sol_sustenido);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);

        %Calcula energia
        Energia = calculaEnergia(filtrado);       
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);

    case 10
        
        nota_a = "A(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,la);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);

        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);

    case 11

        nota_a = "A#(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,la_sustenido);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);
        
        %Calcula energia
        Energia = calculaEnergia(filtrado);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);

    case 12

        nota_a = "B(" + oitava + ")";
        %calcula oitava
        [valorInicial,valorFinal] = calculaOitavas(oitava,si);
        
        %Filtrar Audio
        filtrado = filtroNota(valorInicial,valorFinal,audio,Fs);
        
        %Plot;
        plotar(filtrado,Fs,freqAudio,P1,audio,TempoAudio,nota_a);  

        %Calcula energia
        calculaEnergia(filtrado,nota_a);
        str = "A Energia da nota " + nota_a + "é de: "+Energia+".";
        disp(str);

end


%%
function y = filtroNota(Lcut,Hcut,audio,Fs)

    [A,B,C,D] = butter(4,[Lcut Hcut]/(Fs/2));
    [x1,x2] = ss2sos(A,B,C,D);
    y = filtfilt(x1,x2,audio);
end

function plotar(filtrado,Fs,freqAudio,P1,audio,t,nota_a)
        
       
        tamFilt = length(filtrado);
        tempoFilt = 0:1/Fs:(tamFilt-1)/Fs;
        fftFiltrado = fft(filtrado);
        P2 = abs(fftFiltrado/tamFilt);
        freqs= P2(1:tamFilt/2+1);
        freqs(2:end-1) = 2*freqs(2:end-1);
        freq = Fs*(0:(tamFilt/2))/tamFilt;
        tempo1 = tamFilt/Fs;

        %Espectro de frequência Original x Filtrado
        figure
        hold all
        plot(freqAudio,P1,'color',[150 150 150]/255);
        plot(freq,freqs,'color',[255 200 0]/255);
        xlim([32 987]);
        ylabel('Magnitude (dB)');
        xlabel('Frequências (Hz)');
        xticks([32 65 130 261])
        xticklabels({'C1','C2','C3','C4'})
        title('Espectro de frequência (Original x Filtrado)');
        legend({'Audio Original',nota_a})
        grid on;
        hold off
        
        %Função do tempo
        figure
        hold all
        plot(t,audio,'color',[150 150 150]/255);
        plot(tempoFilt,filtrado,'color',[255 200 0]/255);
        xlim([0 tempo1]);
        title('Áudio original x Áudio Filtrado');
        xlabel('Tempo (s)');
        ylabel('Amplitude (dB)');
        legend({'Áudio Original','Áudio Filtrado'})
        grid on
        hold off
end


function [valorInicial,valorFinal] = calculaOitavas(oitava,nota)
        
        mult=oitava-1;
        x=nota*power(2,mult);
        valorInicial = x(1)-1.2*mult;
        valorFinal   = x(3)+1.2*mult;

end

function energia = calculaEnergia(filtrado)

        aux = filtrado.^2;
        energia = sum(aux(:));

end
