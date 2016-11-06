% Vili Saura    240264
% Jonas Nikula  240497

%% Ladataan kuvat muistiin.
kuva1 = imread('rgbframe5206.png');
kuva2 = imread('rgbframe5207.png');
kuva3 = imread('rgbframe5208.png');

%% muuttuja setup
MSERivit = 12;
MSESarakkeet = 20;
MSEkartta = double(zeros(MSERivit, MSESarakkeet));

LVKRivit = 12;
LVKSarakkeet = 20;
LVKDimensiot = 3;
LVK = double(zeros(LVKRivit, LVKSarakkeet, LVKDimensiot));

MosaiikkiRivit = 360;
MosaiikkiSarakkeet = 640;
MosaiikkiDimensiot = 3;
Mosaiikki = zeros(MosaiikkiRivit, MosaiikkiSarakkeet, MosaiikkiDimensiot);

%% lohkotus
lohkoKorkeus = 30;
lohkoLeveys  = 32;
lohkoRivit = 12;
lohkoSarakkeet = 20;
lohkoArray = cell(lohkoRivit, lohkoSarakkeet);

seuraavaRivi = 1;
% Jaetaan kuva2 lohkoihin, jotka tallennetaan MSEKarttaan
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

%% Parhaan vastinlohkon etsint�

riviBufferi = lohkoKorkeus/2;
prevLohkoRivi = riviBufferi;
sarakeBufferi = lohkoLeveys/2;
prevLohkoSarake = sarakeBufferi;

for i = 1: MSERivit
    etsintaRivit = (prevLohkoRivi - riviBufferi + 1):(prevLohkoRivi + lohkoKorkeus + riviBufferi);
    prevLohkoRivi = prevLohkoRivi + lohkoKorkeus;
    prevLohkoSarake = sarakeBufferi;
    
    for j= 1: MSESarakkeet
        etsintaSarakkeet = (prevLohkoSarake - sarakeBufferi + 1):(prevLohkoSarake + lohkoLeveys + sarakeBufferi);
        
        prevLohkoSarake = prevLohkoSarake + lohkoLeveys;
        
        keskikuvaLohko = lohkoArray{i, j};
        kuva1EtsintaAlue = kuva1pad(etsintaRivit, etsintaSarakkeet, :);
        kuva3EtsintaAlue = kuva3pad(etsintaRivit, etsintaSarakkeet, :);
        
        if i == 6 && j == 8
            figure(1);
            subplot(1,3,1); imshow(kuva1EtsintaAlue);
            subplot(1,3,2); imshow(keskikuvaLohko);
            subplot(1,3,3); imshow(kuva3EtsintaAlue);
        end
        
        [MSE1, xSiirtyma1, ySiirtyma1] = laskeParasMSE(keskikuvaLohko, kuva1EtsintaAlue);
        [MSE3, xSiirtyma3, ySiirtyma3] = laskeParasMSE(keskikuvaLohko, kuva3EtsintaAlue);
        
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
            qx1(laskuri) = (i)*lohkoKorkeus - lohkoKorkeus/2;
            qy1(laskuri) = (j)*lohkoLeveys - lohkoLeveys/2;
            qu1(laskuri) = LVK(i, j, 1);
            qv1(laskuri) = LVK(i, j, 2);
        else
            qx2(laskuri) = (i)*lohkoKorkeus - lohkoKorkeus/2;
            qy2(laskuri) = (j)*lohkoLeveys - lohkoLeveys/2;
            qu2(laskuri) = LVK(i, j, 1);
            qv2(laskuri) = LVK(i, j, 2);
        end
        laskuri = laskuri + 1;
    end
end

quiver(qx1, qy1, qu1, qv1, 'b');
quiver(qx2, qy2, qu2, qv2, 'r');

hold off;

%%
mseColorFig = figure(2);
clf;
kuvaKoko = size(kuva2);
colormap parula;
imagesc(MSEkartta);
colorbar;
axis off;
truesize(mseColorFig, [kuvaKoko(1) kuvaKoko(2)]);













