% Vili Saura 240264
% Jonas Nikula

% Ladataan kuvat muistiin.
kuva1 = imread('rgbframe5206.png');
kuva2 = imread('rgbframe5207.png');
kuva3 = imread('rgbframe5208.png');

%% Prosessoidaan kuva2
rivit = 12;
sarakkeet = 20;

lohkoRivit = 30;
lohkoSarakkeet  = 32;

seuraavaRivi = 1;
MSEkartta = cell(size(rivit, sarakkeet));

% Jaetaan kuva2 lohkoihin, jotka tallennetaan MSEKarttaan
for i = 1:rivit;
    seuraavaSarake = 1;
    for j = 1:sarakkeet;
       lohko  = kuva2(seuraavaRivi:(seuraavaRivi+lohkoRivit-1),seuraavaSarake:(seuraavaSarake+lohkoSarakkeet-1));
       seuraavaSarake = lohkoSarakkeet + seuraavaSarake;
       MSEkartta(i,j) = {lohko};
    end
    seuraavaRivi = lohkoRivit + seuraavaRivi;
end

%% Laajennetaan kuvia 1 ja kaksi nollilla.

kuva1pad = padarray(kuva1,[15,16]);
kuva3pad = padarray(kuva3,[15,16]);
