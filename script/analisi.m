eeglab

% caricare i dati (nota: la cartella è quella dove sono contenuti i dati)
EEG = pop_loadset('1_P3.set', 'G:\Il mio Drive\ARCA2022\Lezione1\MaterialeLez1\');

% ri-referenziare i dati: la media del segnale di tutti gli elettrodi viene
% sottratta a ciascun elettrodo
EEG = pop_reref(EEG, []);

% filtrare i dati facendo passare i dati nella banda di frequenza tra 0.1 e
% 30 Hertz
EEG = pop_basicfilter(EEG, 1:33, 'Filter', 'bandpass', 'design', 'butter', ...
    'Cutoff', [.1 30]);

% creare eventlist: crea un file di testo (.txt) con la lista degli eventi
% (e.g., i marker che indicano cosa ha visto/sentito/risposto il
% partecipante)
EEG = pop_creaeventlist(EEG, 'Eventlist_1.txt');

% versione 'slim' della creazione dei bin (i "contenitori")
EEG = pop_binlister(EEG, 'BDF', 'bins.txt');
% oppure versione alternativa della creazione dei bin, dove viene generato un
% file, in questo caso chiamato "eventbin1.txt".
EEG = pop_binlister(EEG, 'BDF', 'bins.txt', 'ExportEL', 'eventbin1.txt');

% epochiamo il segnale, ovvero tagliamo le singole epoche temporali
EEG = pop_epochbin(EEG, [-200 800], 'pre');

% Creiamo due nuovi canali: il primo è la sottrazione dei due elettrodi
% posizionati sugli angoli palpebrali esterni, il secondo è la sottrazione
% dell'elettrodo Fp1 (che è posizionato sopra l'occhio sinistro) e
% l'elettrodo posizionato sotto l'occhio destro.
EEG = pop_eegchanoperator(EEG, {'ch34=ch31-ch32 label HEOG', 'ch35=ch1-ch33 label VEOG'});

% Con la funzione pop_artstep cerchiamo gli artefatti nel tracciato,
% rispettivamente quelli legati a movimenti oculari, poi a battiti di
% palpebre, e infine artefatti "generici" su tutto lo scalpo.
EEG = pop_artstep( EEG , 'Channel',  34, 'Flag',  2, 'Threshold', 45, 'Twindow', [-200 800], 'Windowsize',  250, 'Windowstep',  5 );
EEG = pop_artstep( EEG , 'Channel',  35, 'Flag',  3, 'Threshold', 80, 'Twindow', [-200 800], 'Windowsize',  150, 'Windowstep',  5 );
EEG = pop_artstep( EEG , 'Channel',  1:30, 'Flag',  4, 'Threshold', 100, 'Twindow', [-200 800], 'Windowsize',  150, 'Windowstep',  5 );

% Salviamo la variabile EEG.
pop_saveset(EEG,'filename','P31', 'filepath','G:\Il mio Drive\ARCA2022\Lezione1\MaterialeLez1')

% Average, ovvero media di tutte le epoche, per ciascuna condizione.
ERP = pop_averager(EEG, 'criterion', 'good');

% Salvataggio dell'ERP. 
pop_savemyerp(ERP, 'filename', 'P3_1.erp', 'erpname', 'P3_1');

% La funzione pop_summary_AR_erp_detection genera una tabella che riassume
% quanti artefatti sono stati rilevati nell'ERP. La tabella viene inoltre
% salvata.
pop_summary_AR_erp_detection(ERP, 'SummaryArtifact_1.txt');