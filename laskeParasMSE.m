function [parasMSE, xSiirtyma, ySiirtyma] = laskeParasMSE(lohko, etsintaAlue)
lohkonKoko = size(lohko);
etsintaAlueenKoko = size(etsintaAlue);
xtraRivit = etsintaAlueenKoko(1) - lohkonKoko(1);
xtraSarakkeet = etsintaAlueenKoko(2) - lohkonKoko(2);

parasMSE = Inf(1);
xSiirtyma = Inf(1);
ySiirtyma = Inf(1);

for i = 1: xtraRivit
    for j = 1: xtraSarakkeet
        etsintaAlueenLohko = etsintaAlue(i:i+lohkonKoko(1)-1, j:j+lohkonKoko(2)-1, :);
        tempMSE = immse(double(etsintaAlueenLohko), double(lohko));
        
        if tempMSE < parasMSE
            parasMSE = tempMSE;
            xSiirtyma = j - xtraSarakkeet/2 - 1;
            ySiirtyma = i - xtraRivit/2 - 1;
        end
    end
end


end