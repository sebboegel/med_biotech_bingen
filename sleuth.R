####Beim erstmaligen Ausführen dieses Skripts, müssen folgende Zeilen einmalig ausgeführt werden. Bei jedem weiteren AUsführen des Skripts
#####können die Punkte 1-5 auskommentiert (mit #) werden
##### Erstmal alle packages installieren, die wir brauchen:
#1.) BiocManager v.3.16
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install()
#update all and Yes
#2.) devtools
install.packages("devtools")
#3.) rhdf5
BiocManager::install("rhdf5",force=TRUE)
#update all
#4.) das eigentlich package für die differentielle Genexpression: sleuth
###Da es einen Bug im Installtionsprogramm von sleuth gibt, habe ich folgendedn workaround befolgt: https://stackoverflow.com/questions/69975645/unable-to-install-package-sleuth-in-r
devtools::install('./sleuth/')

# "1" eintippen und Enter drücken

#5.) biomart um die verschiedenen Gennamen-System zu verbinden (https://en.wikipedia.org/wiki/BioMart)
BiocManager::install("biomaRt")
#Yes
#######Installation Ende

########Packete laden
library(sleuth)
library("biomaRt")

####### los geht es:
#suche die Genexpressionsdateien für jedes sample (Patientin)
sample_id <- dir(file.path("TNBC"))
kal_dirs <- file.path("TNBC", sample_id)
#lade die metadaten (welches sample ist TNBC und welches nicht?)
s2c <- read.table(file.path("metadata","hiseq_info.txt"), header = TRUE, stringsAsFactors=FALSE)
#verbinde sample_id mit Erkrankung und Speicherort der entsprechenden Genexpressiondatein
s2c <- dplyr::select(s2c, sample = run_accession, condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)

##################################
#Der folgende Befehl kommuniziert mit dem Webserver von ENSEMBL um für alle menschlcihen gene u.a. die Transkript-ID
#mit dem dazugehörenden Gensymbol herunterzuladen. Dieser Schritt braucht etwas Zeit, deshalb habe ich dies schon
#getan und in der Datei "biomart.RDS" gespeichert. Dieses Objekt können wir ganz einfach in Zeile 50 laden und benutzen.
#lade die biomart Datenbank 
#mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL",
#                         dataset = "hsapiens_gene_ensembl",
#                         host = 'ensembl.org')
#saveRDS(mart,file="biomart.rds")
###############
#um den Transkript-Ids das dazugehörige Gensymbol zuzuordnen

ttg=readRDS("biomart.rds")
t2g <- biomaRt::getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id",
                                     "external_gene_name"), mart = mart)
t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id,
                     ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
###################################
#füge alle Informationen zusammen
so <- sleuth_prep(s2c, target_mapping = t2g,extra_bootstrap_summary = TRUE,read_bootstrap_tpm=TRUE)
#erstelle verschiedene Modelle zur Berechnung u.a. der differentiellen Genexpression
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')
so <- sleuth_wt(so, "conditionTNBC")
#starte einen interaktiven Browser zur Analyse der Daten
sleuth_live(so)
