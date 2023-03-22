% Definiamo quali partecipanti vogiamo analizzare
subjects = [1, 3, 5];

% Creiamo delle variabili che abbiano come contenuto il percorso delle cartelle
% che sono per noi rilevanti per caricare o salvare dati o altre informazioni
raw = 'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione2';
cartellaanalisi = 'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione2\Analisi';
cartellaerp = 'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione2\ERP';
cartellauseless = 'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione2\uselessfiles';
cartellaartefatti = 'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione2\artifacts';

% attraverso l'utilizzo del ciclo for possiamo ripetere più volte gli stessi 
% comandi, applicandoli a ciascuno dei soggetti presenti nella variabile "subjects".
for i = subjects

    % in ciascun ciclo del ciclo for, il valore di i cambierà in base alla variabile subjects
    % in questo esempio, i avrà il valore di 1, poi di 3, poi di 5
    % Con le parentesi quadre uniamo il valore di i trasformato in stringa alla stringa
    % '_P3.set', ovvero creiamo il nome del file che vogliamo caricare
    filename = [num2str(i), '_P3.set'];
    
    EEG = pop_loadset(filename, raw);

    EEG = pop_reref(EEG, []);

    EEG = pop_basicfilter(EEG, 1:33, 'Filter', 'bandpass', 'Design', 'butter', ...
    'Cutoff', [.1 20]);
    
    % Anche per creare il file di testo esterno creiamo il percorso e il
    % nome del file utilizzando la variabile i.
    EEG = pop_creabasiceventlist(EEG, 'Eventlist', ...
    [cartellauseless, '\Eventlist', num2str(i)], ...
    'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' });
    
    EEG = pop_binlister(EEG, 'BDF', ... 
    'G:\Il mio Drive\ARCA2023marzo\ARCA_EEGLAB\Dati_Lezione1\bins.txt');
    EEG = pop_epochbin(EEG, [-200 800], 'pre');
    
    EEG = pop_eegchanoperator(EEG, ...
        {'ch34 = ch31 - ch32 label HEOG', ...
        'ch35 = ch1 - ch33 label VEOG'});
    
    EEG = pop_artstep(EEG, 'Twindow', [-200 800], 'Threshold', 25, ...
        'Windowsize', 300, 'Windowstep', 20, 'Channel', 34, 'Flag', 2);
    
    EEG = pop_artstep(EEG, 'Twindow', [-200 800], 'Threshold', 40, ...
        'Windowsize', 150, 'Windowstep', 20, 'Channel', 35, 'Flag', 3);
    
    EEG = pop_artstep(EEG, 'Twindow', [-200 800], 'Threshold', 100, ...
        'Windowsize', 100, 'Windowstep', 20, 'Channel', 1:30, 'Flag', 4);
    
    EEG = pop_saveset(EEG, 'filename', [num2str(i), 'P3_analizzato'], ...
        'filepath', cartellaanalisi);
    
    ERP = pop_averager(EEG, 'criterion', 'good');
    
    pop_summary_AR_erp_detection(ERP, ...
        [cartellaartefatti, '\SummaryArtifacts', num2str(i), '.txt']);
    
    pop_savemyerp(ERP, 'erpname', ['P3_', num2str(i)], ...
        'filename', ['P3_', num2str(i), '.erp'], ...
        'filepath', cartellaerp);
            
end

