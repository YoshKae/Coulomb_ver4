function [out] = maxpick(cmax,csample)
ind1 = cmax <= csample;
ind2 = cmax > csample;
out = cmax.*ind2 + csample.*ind1;