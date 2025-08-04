% ET_TURC calculates actual evaporation 
% Input Temperatur T in °C
% Global Radiation R in J/qcm 
% relative humidity in %

function ETP=ET_TURC_new_save(a,b,f,T,R)

if T < 0
    ETP=0.;
else
    if f > 50 
        C_turc =1;
    elseif f <= 50
        C_turc=1+(50-f)/70;
    end
    ETP=C_turc*a*T/(T+15)*(R+b);
end

end


    
