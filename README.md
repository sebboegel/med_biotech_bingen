# med_biotech_bingen
Tutorial zur praktischen bioinformatischen Übung im Rahmen der Vorlesung "Medizinische Informatik" im Studiengang "Medizinische Biotechnologie" an der TH Bingen

# Lernziele
1.) Suche nach RNA-Seq Daten in der Sequenzdatenbank "SRA"

2.) Anwenden eines typischen Workflows (von vielen) zur Analyse von RNA-Seq Daten

3.) Mit R eine differentielle Genexpression durchführen

4.) Die Ergebnisse der differentiellen Genexpression anhand der biologischen/medizinischen Bedeutung interpretieren

5.) Take home message: die Analyse von Hochdurchsatz-Transkriptom Sequenzierung kann schnell und einfach auf dem Heim-Computer gemacht werden! Große Herausforderung ist die Interpretation der Daten!

# Aufgabe

Um das Prinzip der bioinformatischen Auswertung von Hochdurchsatzsequenzierdateien verdeutlichen, soll exemplarisch das Ergebnis aus dieser Publikation (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3278922/) reproduziert werden.
In dieser Studie geht es um einen Vergleich der Expression von Genen in verschiedenen Untergruppen von Brustkrebs: triple negative cancer (TNBC) vs non - TNBC. 

# Vorraussetzung
Genug Speicherplatz für die Schritte 1 - 3, ca. 15 GB!


# Anleitung
1.) Download und Installation von Software:

i) Kallisto - Programm zum Abgleich der Sequenzfragmente (reads) mit dem Refenzgenom und Quantifizierung der Genexpression: http://pachterlab.github.io/kallisto/download


ii) Humanes Genom installieren

Auf https://github.com/pachterlab/kallisto-transcriptome-indices/releases die Datei „homo_sapiens.tar.gz“ herunterladen (Achtung: 1,8 GB Datei).
Hinweis zum entdecken von „tar.gz“ Dateien unter Windows: https://praxistipps.chip.de/tar-gz-dateien-entpacken-so-gehts_36834


iii) SRA-Toolkit - Programm zum Herunterladen von Sequenzierdaten aus der Sequenzdatenbank SRA

https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit
Anleitung für linux: http://www.metagenomics.wiki/tools/short-read/ncbi-sra-file-format/sra-tools-install

iv) R - Programmiersprache für statistische Berechnungen und Grafiken (aktuelle R Version Stand 17. April 2023: R 4.2.3)
https://ftp.fau.de/cran/

v) R - Studio: graphical user interfave für R
https://rstudio.com/products/rstudio/download/#download

2.) Das "Sequence Read Archive" ist eines der größten Repositories für Sequenzierdatein. Diese kann man sich frei herunterladen und re-analysieren um evtl. neue Erkentnisse aus bereits vorhandenen Daten zu generieren. Auch die Brustkrebs-Sample der hier betrachteten Publikation sind hier zu finden (https://www.ncbi.nlm.nih.gov/sra?term=SRP032789).  Exemplatisch werden uns die Sequenzierdatei einer Patientin herunterladen und analysieren: die SRA Datei mit der ID SRR1027172. Dahinter verbergen sich die primären Sequenzierdaten einer „Triple Negative Breast Cancer“ (ZNBC) Patientin (https://www.ncbi.nlm.nih.gov/sra/SRX374851[accn]). Das sind 1.6 GB, kann also dauern, je nach Internetverbindung:

Im Terminal/ Eingabeaufforderung eingeben:
```
[Pfad zum sratoolkit]/bin/prefetch SRR1027172
```
In meinem Terminal sieht das so aus:
```
sebastian@Sebastians-MBP ~ %  tools/sratoolkit.2.10.9-mac64/bin/prefetch SRR1027172    

2021-03-16T07:46:47 prefetch.2.10.9: 1) Downloading 'SRR1027172'...
2021-03-16T07:46:47 prefetch.2.10.9:  Downloading via HTTPS...
2021-03-16T08:22:39 prefetch.2.10.9:  HTTPS download succeed
2021-03-16T08:22:42 prefetch.2.10.9:  'SRR1027172' is valid
2021-03-16T08:22:42 prefetch.2.10.9: 1) 'SRR1027172' was downloaded successfully
2021-03-16T08:22:42 prefetch.2.10.9: 'SRR1027172' has 0 unresolved dependencies
```
Nun haben wir die Sequenzierdatei im sra-Format heruntergeladen. Da die nächsten Schritte aber eine fastq-Datei benötigen, müssen wir diese noch umwandeln. Das macht "fastq-dump". Da es sich hier um ein paired-end Experiment handelt, müssen wir dem Programm dies mitteilen (mit "--split-files"). Dann entstehen 2 fastq Dateien.

Im Terminal/ Eingabeaufforderung eingeben:
```
[Pfad zum sratoolkit]/bin/fastq-dump --split-files /Users/sebastian/SRR1027172/SRR1027172.sra
```
In meinem Terminal sieht das so aus:
```
sebastian@Sebastians-MBP ~ % tools/sratoolkit.2.10.9-mac64/bin/fastq-dump --split-files /Users/sebastian/SRR1027172/SRR1027172.sra
Rejected 22084318 READS because READLEN < 1
Read 40493220 spots for /Users/sebastian/SRR1027172/SRR1027172.sra
Written 40493220 spots for /Users/sebastian/SRR1027172/SRR1027172.sra
```
Die sra Datei kann nun gelöscht werden.

3.) Berechnung der Genexpression mit kallisto
```
[Pfad zu kallisto]/kallisto quant -i [Pfad zum humanen Genom]/homo_sapiens/transcriptome.idx -o [Pfad zum gewünschten Speicherort]/SRR1027172 [Pfad zur fastq]/SRR1027172_1.fastq [Pfad zur fastq]/SRR1027172_2.fastq 
```

```
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
```

4.) Differentielle Genexpression in R:

Verzeichnis mit bereits berechneten Genexpressionen (Schritte 1 -3 für alle Patientenproben) herunterladen: [https://1drv.ms/u/s!Ag871jY-2AMShwOXf-rmJ2l7Mlmf?e=SAR0Uw](https://1drv.ms/u/s!Ag871jY-2AMShwOXf-rmJ2l7Mlmf?e=SAR0Uw) (ca. 1,4 GB)

Rstudio öffnen. 

Datei -> Neues Projekt

New Directory -> New Project -> Create

In das enstandene Verzeichnis die Ordner „TNBC“ und „metadata“ kopieren.

Im Dateibrowser-Fenster von R-Studio In der Konsole von R Studio (unten rechts): Doppelklick auf "sleuth.R". Im "Source" Fenster (oben links) erscheint das Skript: Zeile für Zeile ausführen mit "Run". Wenn man dies zum ersten Mal macht, will R ganz viele Pakete installieren und/oder updaten, die gebraucht werden für das Funktionieren der Pakete, die wir unmittelbar brauchen.

Update 17. April: Bitte vor dem Auführen in Zeile 7 die Version von bioconductor ändern: von "3.14" zu "3.16".

Wenn alles funktioniert hat, öffnet der letzte Befehl "sleuth_live(so)" ein interaktives Fenster, mit dem man verschiedene Analysen macht.

# Links zu weiteren Infos

1.) Informationen zu den Brustkrebs-Proben: 
https://www.nature.com/articles/srep00264

https://www.ncbi.nlm.nih.gov/sra?term=SRP032789

https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE52194


2.) kallisto tutorial: 
http://pachterlab.github.io/kallisto/starting

3.) R 
i) Installation: https://shiny.york.ac.uk/bioltf/gene_expression_course/day2/day2.Rmd

ii) kurze Einfühurng in R: https://shiny.york.ac.uk/bioltf/gene_expression_course/day2/day2.Rmd#section-just-enough-r-to-be-dangerous

4.) Differentielle Genexpression mit R-Paket "sleuth"

i) Installation von sleuth: https://shiny.york.ac.uk/bioltf/gene_expression_course/day2/day2.Rmd#section-installing-and-loading-sleuth
ii) sleuth ausführen: https://shiny.york.ac.uk/bioltf/gene_expression_course/day2/day2.Rmd#section-running-sleuth
iii) Ausführliche Erklärung der interaktiven Analysemöglichkeiten von "sleuth" (siehe Punkt 4 in Anleitung): https://www.youtube.com/watch?v=KEn0CMYk6Wo

5.) Das Konzept "liquid biopsy" erklärt von Bioinformatik-Studierenden der TH Bingen: https://www.youtube.com/watch?v=z-GnFq-8AdI

6.) Was ein Bioinformatiker in der Medizin verloren hat: ScienceSlam-Vortrag von mir https://www.youtube.com/watch?v=bdysuKkAbCs

7.) Wundervolle Video Tutorials zu allen Aspeketen der Bioinformatik (Einführung in R, Genomics Analysis ....) des Canadian Bioinformatics Workshop. Videos: https://www.youtube.com/channel/UCKbkfKk65PZyRCzUwXOJung/featured, Material dazu: https://bioinformaticsdotca.github.io/


