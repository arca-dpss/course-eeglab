---
course_title: EEGLAB
author_name: Mattia Doro
---

# Introduzione 
Le toolbox **EEGLAB** e **ERPLAB**, utilizzabili in ambiente **MATLAB**, permettono di analizzare dati elettroencefalografici (EEG). Il corso si propone di fornire le competenze necessarie per l’analisi dati di base, offrendo inoltre la possibilità di comprendere aspetti teorici attraverso esempi pratici. I contenuti trattati saranno principalmente il pre-processamento dei dati (filtri del segnale, ri-referenziamento, rimozione/interpolazione di segnale rumoroso, segmentazione, rimozione artefatti, correzione artefatti con analisi delle componenti indipendenti) e al computo di potenziali evento-relati (ERPs).

# Orari

|    **Giorno**   | **Orario**    |    **Aula**    |
|-----------------|---------------|----------------|
| Lunedì 20/03    | 13:00 - 17:00 |  LAB 2A (CLA)  |
| Martedì 21/03   | 13:00 - 17:00 |  LAB 2A (CLA)  |
| Mercoledì 22/03 | 13:00 - 17:00 |   4M (Psico2)  |
| Giovedì 23/03   | 13:00 - 17:00 |  LAB 2A (CLA)  |
| Venerdì 24/03   | 13:00 - 17:00 |  LAB 2A (CLA)  |

# Requisiti
Si raccomanda di installare nel proprio computer il software MATLAB prima dell’inizio del corso (nel caso l’abbiate fatto in precedenza, consiglio di assicurarsi di avere una versione non troppo datata (indicativamente dalla 2019 in poi è ok), così da non rischiare alcuna incompatibilità). C’è la possibilità di scaricarlo gratuitamente con l’account istituzionale (@studenti.unipd.it). A [questo link](https://asit.unipd.it/servizi/servizi-utenti-istituzionali/contratti-software-licenze/matlab) sono presenti tutte le istruzioni (sezione "Download del software"). In fase di installazione di MATLAB vi verrà chiesto se desiderate installare qualche pacchetto aggiuntivo; per un utilizzo corretto delle toolbox EEGLAB e ERPLAB sono necessari i seguenti pacchetti aggiuntivi di MATLAB:
- Image Processing Toolbox
- Optimization Toolbox
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
Se riscontrate qualche difficoltà con l'installazione contattatemi. 

Le toolbox EEGLAB e ERPLAB sono scaricabili gratuitamente. EEGLAB (e ERPLAB, in questo caso già contenuto all'interno del primo) può essere scaricato [qui](https://drive.google.com/drive/folders/1_N4_UB2yvqnrQwvGe-9KiUPbGu6UdLAr?usp=sharing) come un unico pacchetto compresso (da decomprimere). Le toolbox non necessitano di alcuna installazione, vedremo in aula come "spiegare" a MATLAB che vogliamo usarle.

# Programma

[A questo link](https://docs.google.com/document/d/155pbHJi7dJGHlmlPRQF6ykLUjVZBJHu7QyGmnvybjMs/edit?usp=sharing) potete trovare l'aggiornamento passo per passo di quanto stiamo facendo in aula.

## Lezione 1 -- [Materiale](https://drive.google.com/open?id=1EE42XpruJH8BrDDmANa-eUQS5Cv9CiR6&authuser=mattia.doro%40unipd.it&usp=drive_fs)
- [L'ambiente MATLAB](MatlabBase1_1.html) -- [Versione PDF](pdf_eeglab_course/L'ambiente MATLAB.pdf)
- [Le toolbox EEGLAB/ERPLAB](ToolboxEEGLABERPLAB_1_2.html) -- [Versione PDF](pdf_eeglab_course/Le toolbox EEGLAB_ERPLAB.pdf)
- Caricare i dati in EEGLAB/ERPLAB
- [Script della prima lezione](script/analisi.m)

## Lezione 2 -- [Materiale](https://drive.google.com/drive/folders/17Jx6XQ3zUQF6wNpKoDlvc7mcL-y_2_vh?usp=share_link)
- Re-reference offline
- Filtraggio del segnale
- Segmentazione e creazione epoche con EEGLAB e ERPLAB, interpolazione elettrodi
- [Script della seconda lezione](script/Analisi2.m)

## Lezione 3 -- [Materiale](https://drive.google.com/drive/folders/1RfzOjKwqCWIMrPhJ3rnnU7BrjQVEeqoY?usp=share_link)
- Detezione di artefatti oculari e soluzioni per la loro correzione in EEGLAB e ERPLAB
- Automizzazione delle routine di analisi e grand average di potenziali evento-relati in EEGLAB e
ERPLAB

## Lezione 4 -- [Materiale](https://drive.google.com/drive/folders/1makHCFjtndNCXo7GiIJJ8q7daLLoir82?usp=sharing)
- Tecniche avanzate di correzione artefatti
- Prove pratiche

## Lezione 5 -- [Materiale](https://drive.google.com/drive/folders/1lHyumu9Ujmf4oaR00VWP8YGcEqP17411?usp=sharing)
- Prove pratiche

# Link utili
- [EEGLAB webpage](https://sccn.ucsd.edu/eeglab/index.php)
- [ERPLAB webpage](https://erpinfo.org/erplab)
<<<<<<< HEAD
- [ERPcore](https://erpinfo.org/erp-core)
=======
- [ERPCORE](https://erpinfo.org/erp-core)

