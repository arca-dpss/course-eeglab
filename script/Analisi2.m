% Definiamo i nomi di cartelle e file che ci serviranno per l'analisi.
% In questo modo quando dovremo definire in una funzione il percorso di una
% cartella o il nome di un file, sarà sufficiente scrivere il nome della variabile. 
% Questo ci offre due benefici: 
% - Il nome della variabile (e.g., artfolder) è molto più breve dell'intero
% percorso (G:\Il mio Drive\ARCA2022\Lezione2\SummaryArtefatti).
% - Se in futuro volessimo riutilizzare lo script delle analisi (copiando
% tutto e incollando in un nuovo file) sarà più pratico cambiare il nome
% dei file e dei percorsi a inizio script, senza dover cercare riga per
% riga dove è necessario cambiare nome di file o percorsi (considerando
% anche che se da qualche parte rimane il vecchio percorso, rischiamo di
% salvare un file in una cartella di un vecchio progetto).
artfolder = 'G:\Il mio Drive\ARCA2022\Lezione2\SummaryArtefatti';
erpfolder = 'G:\Il mio Drive\ARCA2022\Lezione2\ERP';
analisifolder = 'G:\Il mio Drive\ARCA2022\Lezione2\Analisi';
uselessfolder = 'G:\Il mio Drive\ARCA2022\Lezione2\Uselessfiles';
rawfolder = 'G:\Il mio Drive\ARCA2022\Lezione2\P3Raw';
binfile = 'bins.txt';

soggetti = [1:34, 36:40];
% Il ciclo for permette di far fare a Matlab più volte la stessa cosa, ad
% ogni iterazione del ciclo il valore della variabile i cambia (sulla base
% del contenuto della variabile 'soggetti'.
% In questo % caso, nel primo ciclo avrà il valore 1, nel secondo 2, e così
% via.
for i = soggetti
    % Carichiamo i dati. Il nome del file viene definito concatenando
    % (usando le parentesi quadre) il valore di i, che è il numero del
    % partecipante, utilizzando però la funzione num2str, che trasforma il
    % numero in una stringa, alla stringa '_P3.set', che è la parte
    % "costante" del nome dei vari file.
    EEG = pop_loadset('filename', [num2str(i),'_P3.set'], 'filepath', rawfolder);

    EEG = pop_reref(EEG, []);
    EEG = pop_basicfilter(EEG, 1:33, 'Filter', 'bandpass', 'design', 'butter', ...
    'Cutoff', [.1 30]);

    EEG = pop_saveset(EEG, 'filename', [num2str(i), '_filtrato'], 'filepath', analisifolder);
    
    % Anche per creare il file di testo esterno creiamo il percorso e il
    % nome del file utilizzando la variabile i.
    EEG = pop_creaeventlist(EEG, [uselessfolder '\Eventlist_' num2str(i) '.txt']);

    EEG = pop_binlister(EEG, 'BDF', binfile);

    EEG = pop_epochbin(EEG, [-200 800], 'pre');

    % Salviamo di tanto in tanto gli step intermedi di analisi.
    EEG = pop_saveset(EEG, 'filename', [num2str(i), '_epocato'], 'filepath', analisifolder);

    EEG = pop_eegchanoperator(EEG, {'ch34=ch31-ch32 label HEOG', 'ch35=ch1-ch33 label VEOG'});

    EEG = pop_artstep( EEG , 'Channel',  34, 'Flag',  2, 'Threshold', 45, 'Twindow', [-200 800], 'Windowsize',  250, 'Windowstep',  5 );
    EEG = pop_artstep( EEG , 'Channel',  35, 'Flag',  3, 'Threshold', 80, 'Twindow', [-200 800], 'Windowsize',  150, 'Windowstep',  5 );
    EEG = pop_artstep( EEG , 'Channel',  1:30, 'Flag',  4, 'Threshold', 100, 'Twindow', [-200 800], 'Windowsize',  150, 'Windowstep',  5 );

    pop_saveset(EEG,'filename',[num2str(i), '_art'] , 'filepath', analisifolder)

    ERP = pop_averager(EEG, 'criterion', 'good');

    pop_savemyerp(ERP, 'filename', [num2str(i), '_P3.erp'], 'erpname', [num2str(i), 'P3_'], 'filepath', erpfolder);
 
    pop_summary_AR_erp_detection(ERP, [artfolder,'\SummaryArtifact_', num2str(i) '.txt']);
end

%% 
% Ora che abbiamo un ERP per ciascun partecipante, possiamo decidere quali
% vogliamo considerare relativamente basandoci su quante epoche abbiamo
% rigettato a causa di artefatti di vario genere.
% con clear all eliminiamo tutte le variabili del workspace, così da evitare
% confusione
clear all 
erpfolder = 'G:\Il mio Drive\ARCA2022\Lezione2\ERP';
% 'inizializziamo tre variabili, che poi si aggiorneranno, contenendo i
% numeri dei partecipanti appartenenti a una delle tre categorie.
% La logica è che i soggetti con un buon numero di epoche saranno nella
% variabile 'buoni', quelli male ma non malissimo in quella 'buonini',
% mentre quelli che lasciamo stare proprio andranno nella variabile 'bad'.
buoni = [];
buonini = [];
bad = [];
soggetti = [1:34, 36:40];

% Anche in questo caso, utilizzeremo un ciclo for per caricare l'ERP di
% ciascun soggetto, uno per volta.
for i = soggetti
    ERP = pop_loaderp('filename',[num2str(i), '_P3.erp'], 'filepath', erpfolder);
    % All'interno di ERP.ntrials.accepted è presente il numero di trial
    % accettati nella prima e nella seconda condizione (bin). Utilizzando
    % 'if' chiediamo a Matlab di verificare se nella prima condizione ci
    % sono minimo 20 epoche e nella seconda minimo 45. Se l'ERP di un
    % determinato soggetto risponde a questi requisiti, il numero del
    % partecipante verrà inserito nella variabile 'buoni'.
    if ERP.ntrials.accepted(1) > 20 && ERP.ntrials.accepted(2) > 45
        buoni = [buoni, i];   
    % Se il dato del partecipante non soddisfava i requisiti definiti dopo
    % 'if', Matlab proverà a verificare se soddisfa questi altri requisiti
    % con 'elseif'.
    elseif ERP.ntrials.accepted(1) > 15 && ERP.ntrials.accepted(2) > 30
        buonini = [buonini, i];
    % Se nemmeno i requisiti definiti in elseif vengono soddisfatti, il
    % numero del partecipante viene inserito in 'bad'. 'Else', infatti,
    % vuol dire "se nessuno dei requisiti precedenti viene soddisfatto,
    % allora fai quest'altra cosa".
    else
        bad = [bad, i];
    end
end

%% 
% Ora vogliamo mediare i dati di tutti i partecipanti, solo quelli buoni,
% facendo quella che viene chiamata "Grand average"
% Con l'utilizzo di un ciclo for carichiamo tutti i partecipanti buoni.
% Ora è necessario utilizzare due diverse variabili come output, che sono
% ERP e ALLERP (EEGLAB saprà come gestire la cosa).
% In ALLERP ci saranno tutti gli ERP dei singoli soggetti che abbiamo
% caricato.
for i = buoni
   [ERP ALLERP] = pop_loaderp('filename',[num2str(i), '_P3.erp'], 'filepath', erpfolder);

end

% Con il comando pop_gaverager facciamo la grand average. L'argomento
% 'Erpsets' indica il numero che i partecipanti hanno nella variabile
% ALLERP. Non è quindi il numero del partecipante, perché con la funzione
% che abbiamo usato per caricare gli ERP questi vengono inseriti in ALLERP
% uno alla volta, quindi di fatto il loro numero di erpset è un semplice
% valore che aumenta con l'inserimento di ciascun ERP. In questo caso sono
% 15, perciò gli Erpsets da utilizzare saranno da 1 a 15.
% Con l'argomento 'Weighted' chiediamo di fare una media pesata
% (ponderata), che da un peso maggiore ai partecipanti con più epoche
% rispetto a quelli con meno epoche.
% L'argomento 'SEM' è l'errore standard della media, e permette di fare i
% grafici con delle aree semitrasparenti che indicano la variabilità della
% media del potenziale evento relato.
ERP = pop_gaverager(ALLERP, 'Erpsets', 1:15, 'Weighted', 'on', ...
    'SEM', 'on');

% Salviamo la grand average, successivamente sarà semplice caricarla da
% interfaccia grafica cliccando su ERPLAB -> Load existing erpset
pop_savemyerp(ERP,'erpname','GrandAverage','filename','GrandAverage15sjs.erp','filepath','G:\Il mio Drive\ARCA2022\Lezione2');

%%
clear all % puliamo il workspace 
% e carichiamo di nuovo gli ERP dei singoli soggetti.
for i = buoni
   [ERP ALLERP] = pop_loaderp('filename',[num2str(i), '_P3.erp'], 'filepath', erpfolder);

end

% Con la funzione pop_geterpvalues possiamo estrarre valori su cui potremo
% fare delle statistiche. 
ALLERP = pop_geterpvalues( ALLERP, [ 300 650], [ 1 2],  14 , 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets',  1:15, 'FileFormat', 'long',...
 'Filename', 'G:\Il mio Drive\ARCA2022\Lezione2\datiP3.txt', 'Fracreplace', 'NaN', 'InterpFactor',  1, 'Measure', 'meanbl', 'PeakOnset',  1,...
 'Resolution',  3, 'SendtoWorkspace', 'on' );
