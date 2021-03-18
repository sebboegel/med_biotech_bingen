# med_biotech_bingen
Tutorial zur praktischen bioinformatischen Übung im Rahmen der Vorlesung "Medizinische Informatik" im Studiengang "Medizinische Biotechnologie" an der TH Bingen

# Lernziele
1.) Suche nach RNA-Seq Daten in der Sequenzdatenbank "SRA"

2.) Anwenden eines typischen Workflows (von vielen) zur Analyse von RNA-Seq Daten

3.) Mit R eine differentielle Genexpression durchführen

4.) Die Ergebnisse der differentiellen Genexpression anhand der biologischen Bedeutung interpretieren 

# Aufgabe

Um das Prinzip der bioinformatischen Auswertung von Hochdurchsatzsequenzierdateien verdeutlichen, soll exemplarisch das Ergebnis aus dieser Publikation (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3278922/) reproduziert werden.
In dieser Studie geht es um einen Vergleich der Expression von Genen in verschiedenen Untergruppen von Brustkrebs: triple negative cancer (TNBC) vs non - TNBC. 

# Anleitung
1.) Download und Installation von Software:
i) Kallisto - Programm zum Abgleich der Sequenzfragmente (reads) mit dem Refenzgenom und Quantifizierung der Genexpression: http://pachterlab.github.io/kallisto/download

ii) Humanes Genom installieren
Auf https://github.com/pachterlab/kallisto-transcriptome-indices/releases die Datei „homo_sapiens.tar.gz“ herunterladen (Achtung: 1,8 GB Datei).
Hinweis zum entdecken von „tar.gz“ Dateien unter Windows: https://praxistipps.chip.de/tar-gz-dateien-entpacken-so-gehts_36834

iii) SRA-Toolkit - Programm zum Herunterladen von Sequenzierdaten aus der Sequenzdatenbank SRA
https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit
Anleitung für linux: http://www.metagenomics.wiki/tools/short-read/ncbi-sra-file-format/sra-tools-install

iv) R - Programmiersprache für statistische Berechnungen und Grafiken
https://ftp.fau.de/cran/

v) R - Studio: graphical user interfave für R
https://rstudio.com/products/rstudio/download/#download

2.) 
3.SRA Datei mit der ID SRR1027172 herunterladen. Dahinter verbergen sich die primären Sequenzierdaten einer „Triple Negative Breast Cancer“ (ZNBC) Patientin (https://www.ncbi.nlm.nih.gov/sra/SRX374851[accn]). Das sind 1.6 GB, kann also dauern, je nach Internetverbindung:

[Pfad zum sratoolkit]/bin/prefetch SRR1027172

sebastian@Sebastians-MBP ~ %  tools/sratoolkit.2.10.9-mac64/bin/prefetch SRR1027172    

2021-03-16T07:46:47 prefetch.2.10.9: 1) Downloading 'SRR1027172'...
2021-03-16T07:46:47 prefetch.2.10.9:  Downloading via HTTPS...
2021-03-16T08:22:39 prefetch.2.10.9:  HTTPS download succeed
2021-03-16T08:22:42 prefetch.2.10.9:  'SRR1027172' is valid
2021-03-16T08:22:42 prefetch.2.10.9: 1) 'SRR1027172' was downloaded successfully
2021-03-16T08:22:42 prefetch.2.10.9: 'SRR1027172' has 0 unresolved dependencies


[Pfad zum sratoolkit]/bin/fastq-dump --split-files /Users/sebastian/SRR1027172/SRR1027172.sra

sebastian@Sebastians-MBP ~ % tools/sratoolkit.2.10.9-mac64/bin/fastq-dump --split-files /Users/sebastian/SRR1027172/SRR1027172.sra
Rejected 22084318 READS because READLEN < 1
Read 40493220 spots for /Users/sebastian/SRR1027172/SRR1027172.sra
Written 40493220 spots for /Users/sebastian/SRR1027172/SRR1027172.sra

3.) Berechnung der Genexpression mit kallisto

[Pfad zu kallisto]/kallisto quant -i [Pfad zum humanen Genom]/homo_sapiens/transcriptome.idx -o [Pfad zum gewünschten Speicherort]/SRR1027172 [Pfad zur fastq]/SRR1027172_1.fastq [Pfad zur fastq]/SRR1027172_2.fastq 

sebastian@Sebastians-MBP ~ % tools/kallisto/kallisto quant -i tools/kallisto/homo_sapiens/transcriptome.idx -o SRR1027172 SRR1027172_1.fastq SRR1027172_2.fastq 

[quant] fragment length distribution will be estimated from the data
[index] k-mer length: 31
[index] number of targets: 188,753
[index] number of k-mers: 109,544,288
[index] number of equivalence classes: 760,757
[quant] running in paired-end mode
[quant] will process pair 1: SRR1027172_1.fastq
                             SRR1027172_2.fastq
[quant] finding pseudoalignments for the reads ... done
[quant] processed 18,408,902 reads, 3,618,103 reads pseudoaligned
[quant] estimated average fragment length: 170.209
[   em] quantifying the abundances ... done
[   em] the Expectation-Maximization algorithm ran for 1,165 rounds

4.) Differentielle Genexpression in R:
Datei -> Neues Projekt
New Directory -> New Project -> Create

In das enstandene Verzeichnis die Ordner „TNBC“ und „metadata“ kopieren.

In der Console:

Skript ausführen: Zeile für Zeile mit "Run"
