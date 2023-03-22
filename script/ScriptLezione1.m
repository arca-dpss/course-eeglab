eeglab

% caricare i dati (nota: la cartella è quella dove sono contenuti i dati)
EEG = pop_loadset('1_P3.set', 'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione1'); % è necessario cambiare il secondo argomento dato in pasta alla funzione con l’effettivo percorso (cartella) che contiene il vostro file!

% ri-referenziare i dati: la media del segnale di tutti gli elettrodi viene
% sottratta a ciascun elettrodo
EEG = pop_reref(EEG, []);

% filtrare i dati facendo passare i dati nella banda di frequenza tra 0.1 e
% 20 Hertz
EEG = pop_basicfilter(EEG, 1:33, 'Filter', 'bandpass', 'Design', 'butter', ...
   'Cutoff', [.1 20]);

% creare eventlist: crea un file di testo (.txt) con la lista degli eventi
% (e.g., i markers che indicano cosa ha visto/sentito/risposto il
% partecipante)
EEG = pop_creabasiceventlist(EEG, 'Eventlist', ...
   'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione1\Eventlist1', ...
   'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' });


% Creiamo i "bin" (cioè indichiamo a EEGLAB che serie di markers appartengono
% a una determinata condizione sperimentale) attraverso il file che abbiamo
% che abbiamo chiamato "bins.txt"
EEG = pop_binlister(EEG, 'BDF', ...
   'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione1\bins.txt');

% epochiamo il segnale, ovvero tagliamo le singole epoche temporali
EEG = pop_epochbin(EEG, [-200 800], 'pre');

% Creiamo due nuovi canali: il primo è la sottrazione dei due elettrodi
% posizionati sugli angoli palpebrali esterni, il secondo è la sottrazione
% dell'elettrodo Fp1 (che è posizionato sopra l'occhio sinistro) e
% l'elettrodo posizionato sotto l'occhio destro. I numeri degli elettrodi
% interessati sono presenti nella variabile EEG, all'interno del campo "chanlocs"
EEG = pop_eegchanoperator(EEG, ...
   {'ch34 = ch31 - ch32 label HEOG', ...
   'ch35 = ch1 - ch33 label VEOG'});

% Con la funzione pop_artstep cerchiamo gli artefatti nel tracciato,
% rispettivamente quelli legati a movimenti oculari, poi a battiti di
% palpebre, e infine artefatti "generici" su tutto lo scalpo.
EEG = pop_artstep(EEG, 'Twindow', [-200 800], 'Threshold', 25, ...
   'Windowsize', 300, 'Windowstep', 20, 'Channel', 34, 'Flag', 2);

EEG = pop_artstep(EEG, 'Twindow', [-200 800], 'Threshold', 40, ...
   'Windowsize', 150, 'Windowstep', 20, 'Channel', 35, 'Flag', 3);

EEG = pop_artstep(EEG, 'Twindow', [-200 800], 'Threshold', 100, ...
   'Windowsize', 100, 'Windowstep', 20, 'Channel', 1:30, 'Flag', 4);

% Salviamo la variabile EEG.
EEG = pop_saveset(EEG, 'filename', 'P3_1', 'filepath', 'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione1');

% Average, ovvero media di tutte le epoche, per ciascuna condizione.
ERP = pop_averager(EEG, 'criterion', 'good');

% Salvataggio dell'ERP. 
pop_savemyerp(ERP, 'filename', 'P3_1.erp', 'erpname', 'P3_1');

% La funzione pop_summary_AR_erp_detection genera una tabella che riassume
% quanti artefatti sono stati rilevati nelle epoche che compongono l'ERP. 
% La tabella viene inoltre salvata.
pop_summary_AR_erp_detection(ERP, ...
   'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione1\SummaryArtifacts1.txt')


