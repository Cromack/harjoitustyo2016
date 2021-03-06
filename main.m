% Vili Saura    240264
% Jonas Nikula  240497

%% Ladataan kuvat muistiin.
kuva1 = imread('rgbframe5206.png');
kuva2 = imread('rgbframe5207.png');
kuva3 = imread('rgbframe5208.png');

%% Alustetaan tarvittavat muuttujat
MSERivit = 12;
MSESarakkeet = 20;
MSEkartta = double(zeros(MSERivit, MSESarakkeet));

LVKRivit = 12;
LVKSarakkeet = 20;
LVKDimensiot = 3;
LVK = double(zeros(LVKRivit, LVKSarakkeet, LVKDimensiot));

% MosaiikkiRivit = 360;
% MosaiikkiSarakkeet = 640;
% MosaiikkiDimensiot = 3;
% Mosaiikki = zeros(MosaiikkiRivit, MosaiikkiSarakkeet, MosaiikkiDimensiot);

%% lohkotus
lohkoKorkeus = 30;
lohkoLeveys  = 32;
lohkoRivit = 12;
lohkoSarakkeet = 20;
lohkoArray = cell(lohkoRivit, lohkoSarakkeet);

seuraavaRivi = 1;
% Jaetaan kuva2 lohkoihin, jotka tallennetaan lohkoArrayhin
for i = 1: lohkoRivit;
    seuraavaSarake = 1;
    for j = 1: lohkoSarakkeet;
       lohko  = kuva2(seuraavaRivi:(seuraavaRivi+lohkoKorkeus-1),seuraavaSarake:(seuraavaSarake+lohkoLeveys-1),:);
       seuraavaSarake = lohkoLeveys + seuraavaSarake;
       lohkoArray{i,j} = lohko;
    end
    seuraavaRivi = lohkoKorkeus + seuraavaRivi;
end

%% Laajennetaan kuvia 1 ja 2 nollilla.

kuva1pad = padarray(kuva1, [lohkoKorkeus/2, lohkoLeveys/2]);
kuva3pad = padarray(kuva3, [lohkoKorkeus/2, lohkoLeveys/2]);

%% Parhaan vastinlohkon etsintä

riviBufferi = lohkoKorkeus/2;
prevLohkoRivi = riviBufferi;
sarakeBufferi = lohkoLeveys/2;
prevLohkoSarake = sarakeBufferi;

% Käydään kaikki lohkot läpi
for i = 1: MSERivit
    etsintaRivit = (prevLohkoRivi - riviBufferi + 1):(prevLohkoRivi + lohkoKorkeus + riviBufferi);
    prevLohkoRivi = prevLohkoRivi + lohkoKorkeus;
    prevLohkoSarake = sarakeBufferi;
    
    for j= 1: MSESarakkeet
        etsintaSarakkeet = (prevLohkoSarake - sarakeBufferi + 1):(prevLohkoSarake + lohkoLeveys + sarakeBufferi);
        
        prevLohkoSarake = prevLohkoSarake + lohkoLeveys;
        
        % Etsintä alue on siis 4x lohkon kokoinen alue joka ympäröi lohkoa
        keskikuvaLohko = lohkoArray{i, j};
        kuva1EtsintaAlue = kuva1pad(etsintaRivit, etsintaSarakkeet, :);
        kuva3EtsintaAlue = kuva3pad(etsintaRivit, etsintaSarakkeet, :);
        
        % Parhaiten vastaavan lohkon etsintä on siirretty omaan funktioonsa
        % jotta tämä kohta olisi hieman selkeämpi
        [MSE1, xSiirtyma1, ySiirtyma1] = laskeParasMSE(keskikuvaLohko, kuva1EtsintaAlue);
        [MSE3, xSiirtyma3, ySiirtyma3] = laskeParasMSE(keskikuvaLohko, kuva3EtsintaAlue);
        
        % Vertaillaan keskivirheitä ja otetaan pienemmän virheen omaava
        % lohko
        if MSE1 < MSE3
            MSEkartta(i, j) = MSE1;
            LVK(i, j, :) = [ySiirtyma1, xSiirtyma1, 1];
        else
            MSEkartta(i, j) = MSE3;
            LVK(i, j, :) = [ySiirtyma3, xSiirtyma3, 2];
        end
        
        
    end
end

%% Visualisointeja
figure(1);
clf;
% taustakuva = ones(size(kuva2));
taustakuva = kuva2;
imshow(taustakuva);
hold on;

% Käytetään kahta eri vektorijoukkoa, 1 on edeltävälle kuvalle ja 2
% seuraavalle
qx1 = zeros(1, LVKRivit*LVKSarakkeet);
qy1 = zeros(1, LVKRivit*LVKSarakkeet);
qu1 = zeros(1, LVKRivit*LVKSarakkeet);
qv1 = zeros(1, LVKRivit*LVKSarakkeet);

qx2 = zeros(1, LVKRivit*LVKSarakkeet);
qy2 = zeros(1, LVKRivit*LVKSarakkeet);
qu2 = zeros(1, LVKRivit*LVKSarakkeet);
qv2 = zeros(1, LVKRivit*LVKSarakkeet);

laskuri = 1;
for i = 1: LVKRivit
    for j = 1: LVKSarakkeet
        kuvaNro = LVK(i, j, 3);
        
        if kuvaNro == 1
            qx1(laskuri) = (j)*lohkoLeveys - lohkoLeveys/2;
            qy1(laskuri) = (i)*lohkoKorkeus - lohkoKorkeus/2;
            qu1(laskuri) = LVK(i, j, 2);
            qv1(laskuri) = LVK(i, j, 1);
        else
            qx2(laskuri) = (j)*lohkoLeveys - lohkoLeveys/2;
            qy2(laskuri) = (i)*lohkoKorkeus - lohkoKorkeus/2;
            qu2(laskuri) = LVK(i, j, 2);
            qv2(laskuri) = LVK(i, j, 1);
        end
        laskuri = laskuri + 1;
    end
end

quiverPlot1 = quiver(qx1, qy1, qu1, qv1, 'b');
quiverPlot2 = quiver(qx2, qy2, qu2, qv2, 'r');

hold off;


mseColorFig = figure(2);
clf;
kuvaKoko = size(kuva2);
colormap parula;
imagesc(MSEkartta);
colorbar;
axis off;
truesize(mseColorFig, [kuvaKoko(1) kuvaKoko(2)]);













