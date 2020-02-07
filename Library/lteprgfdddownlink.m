function matrix=lteprgfdddownlink(BW,Ncp,CFI,Nant)
%% DEVERLOPER: NGUYEN HOANG MINH
% matrix=lteprbfdddownlink(BW,Ncp,CFI,Nant)
% matrix of LTE Physical Resource Grid FDD Downlink
% Ncp:    Number of Cyclic Prefix    Normal=7   Extended=6
% Nant    Number of Tx Antena ports  1 2 3 4
% CFI     Control Format Indicated   1   2   3

%% MAIN PROGRAM

Ncolum=20*Ncp;                          
    if BW==1.4 
        Nrow=12*6;
        IDcfi=[2 3 4];
    else
        Nrow=12*5*BW;
        IDcfi=[1 2 3];
    end
M=ones(Nrow,Ncolum);                % MA TRAN PDSCH

    if Ncp==6
        X1ant1=1; Y1ant1=6;         % ANTENA 1
        X2ant1=4; Y2ant1=3;
        X1ant2=1; Y1ant2=3;         % ANTENA 2
        X2ant2=4; Y2ant2=6;
        X1ant3=2; Y1ant3=6;         % ANTENA 3
        X2ant3=8; Y2ant3=3;
        X1ant4=2; Y1ant4=3;         % ANTENA 4
        X2ant4=8; Y2ant4=6;  
        
    elseif Ncp==7
        X1ant1=1; Y1ant1=6;         % ANTENA 1
        X2ant1=5; Y2ant1=3;
        X1ant2=1; Y1ant2=3;         % ANTENA 2
        X2ant2=5; Y2ant2=6;
        X1ant3=2; Y1ant3=6;         % ANTENA 3
        X2ant3=9; Y2ant3=3;
        X1ant4=2; Y1ant4=3;         % ANTENA 4
        X2ant4=9; Y2ant4=6;
    end


%% PHU KENH & TIN HIEU VAT LY

    Mcch=M;                         % PHU KENH CONTROL CHANNEL CCH
    k=IDcfi(CFI);
        for h=1:k
            for j=h:2*Ncp:Ncolum
                for i=1:Nrow,Mcch(i,j) = 6;end
            end
        end

    Mbch=Mcch;                      % PHU KENH BROARDCAST CHANNEL PBCH
        for j=Ncp+1:Ncp+4
            for i=(Nrow/2-36)+1:(Nrow/2-36)+72
                Mbch(i,j) = 5;
            end
        end

    Msss=Mbch;                      % PHU TIN HIEU SECONDARY SYNC SIGNAL S-SS
        for j=Ncp-1:10*Ncp:Ncolum
            for i=(Nrow/2-31)+1:(Nrow/2-31)+62
            Msss(i,j) = 2;
            end
        end

    Mpss=Msss;                      % PHU TIN HIEU PRIMARY SYNC SIGNAL P-SS
        for j=Ncp:10*Ncp:Ncolum
            for i=(Nrow/2-31)+1:(Nrow/2-31)+62
            Mpss(i,j) = 3;
            end
        end

    Munu=Mpss;                      % PHU TIN HIEU UNUSED CHO CELL-RS
    ID1unu=[Ncp-1 Ncp];             % 2 DAU CUA SYNCHRONIZATION SIGNAL
        for k=1:length(ID1unu)
           for j=ID1unu(k):10*Ncp:Ncolum    
                for i=(Nrow/2-31)-4:(Nrow/2-31), Munu(i,j) = 4;end
                for i=(Nrow/2-31)+63:(Nrow/2-31)+67, Munu(i,j) = 4;end
            end
        end
    ID2unu=[Ncp+1 Ncp+2];           % BEN TRONG KENH PBCH
        for k=1:length(ID2unu)
            for j=ID2unu(k)
                for i=(Nrow/2-31)-2:3:(Nrow/2-31)+67,Munu(i,j)=4;end
            end
        end
        for j=1:2*Ncp:Ncolum        %BEN TRONG PCFICH
            for i=3:3:Nrow,Munu(i,j) = 4;end
        end
        
    Mant1=Munu;                     % PHU TIN HIEU ANTENA 1 -RS/CELL Specific-RS REFERENCE SIGNAL
        for j=X1ant1:Ncp:Ncolum
            for i=Y1ant1:6:Nrow, Mant1(i,j) = 7;end
        end
        for j=X2ant1:Ncp:Ncolum
            for i=Y2ant1:6:Nrow, Mant1(i,j) = 7;end
        end
    
    Mant2=Mant1;                    % PHU TIN HIEU ANTENA 2 -RS/CELL Specific-RS REFERENCE SIGNAL
        for j=X1ant2:Ncp:Ncolum
            for i=Y1ant2:6:Nrow, Mant2(i,j) = 8;end
        end
        for j=X2ant2:Ncp:Ncolum
            for i=Y2ant2:6:Nrow, Mant2(i,j) = 8;end
        end
        
    Mant3=Mant2;                    % PHU TIN HIEU ANTENA 3 -RS/CELL Specific-RS REFERENCE SIGNAL
        for j=X1ant3:2*Ncp:Ncolum
            for i=Y1ant3:6:Nrow,Mant3(i,j) = 9;end
        end
        for j=X2ant3:2*Ncp:Ncolum
            for i=Y2ant3:6:Nrow, Mant3(i,j) = 9;end
        end
        
    Mant4=Mant3;                    % PHU TIN HIEU ANTENA 4 -RS/CELL Specific-RS REFERENCE SIGNAL
        for j=X1ant4:2*Ncp:Ncolum
            for i=Y1ant4:6:Nrow, Mant4(i,j) = 10;end
        end
        for j=X2ant4:3*Ncp:Ncolum
            for i=Y2ant4:6:Nrow, Mant4(i,j) = 10;end
        end
    
%% LUA CHON MA TRAN THEO ANTEN               
    switch Nant                      
        case 1, matrix = Mant1;
        case 2, matrix = Mant2;
        case 4, matrix = Mant4;
    end
    
end
