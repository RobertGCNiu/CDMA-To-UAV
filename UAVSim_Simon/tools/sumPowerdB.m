function totPowerdB=sumPowerdB(vecPowerdB)

if isempty(vecPowerdB)
    totPowerdB=-Inf;
else
    totPowerdB=10*log10(sum(10.^(vecPowerdB/10),1))';
end