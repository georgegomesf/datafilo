library(data.table)
library(plyr)

dir <- "fontes/"

anos <- c(1987:2012)

ate_2012 <- data.frame()

for(ano in anos){

  td <- fread(paste0(dir,"dados_",as.character(ano),'.gz'), encoding = 'Latin-1')
  if(!is.na(td)){
    td <- subset(td,select=c(AnoBase,Uf,SiglaIes,CodigoPrograma,NomePrograma,AreaConhecimentoCodigo,AreaConhecimento,GrandeAreaCodigo,GrandeAreaDescricao,Nivel))
    ate_2012 <- rbind.fill(ate_2012,td)
  }

}

arquivos <- c("br-capes-btd-2013a2016-2017-12-01_2013.gz",
"br-capes-btd-2013a2016-2017-12-01_2014.gz",
"br-capes-btd-2013a2016-2017-12-01_2015.gz",
"br-capes-btd-2013a2016-2017-12-01_2016.gz",
"br-capes-btd-2017a2020-2021-12-03_2017.gz",
"br-capes-btd-2017a2020-2021-12-03_2018.gz",
"br-capes-btd-2017a2020-2021-12-03_2019.gz",
"br-capes-btd-2017a2020-2021-12-03_2020.gz",
"br-capes-btd-2021-2023-10-31.gz",
"br-capes-btd-2022-2023-10-31.gz")

desde_2013 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  td <- fread(paste0(dir,arquivo), encoding = 'Latin-1')
  if(!is.na(td)){
    td <- subset(td,select=c(AN_BASE,SG_UF_IES,SG_ENTIDADE_ENSINO,CD_PROGRAMA,NM_PROGRAMA,CD_AREA_CONHECIMENTO,NM_AREA_CONHECIMENTO,CD_GRANDE_AREA_CONHECIMENTO,NM_GRANDE_AREA_CONHECIMENTO,NM_GRAU_ACADEMICO))
    desde_2013 <- rbind.fill(desde_2013,td)
  }

}

td_base <- rbind.fill(
    setNames(
        subset(ate_2012,select=c(AnoBase,Uf,SiglaIes,CodigoPrograma,NomePrograma,AreaConhecimentoCodigo,AreaConhecimento,GrandeAreaCodigo,GrandeAreaDescricao,Nivel)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","area_cd","area","grande_area_cd","grande_area","grau")
    ),
    setNames(
        subset(desde_2013,select=c(AN_BASE,SG_UF_IES,SG_ENTIDADE_ENSINO,CD_PROGRAMA,NM_PROGRAMA,CD_AREA_CONHECIMENTO,NM_AREA_CONHECIMENTO,CD_GRANDE_AREA_CONHECIMENTO,NM_GRANDE_AREA_CONHECIMENTO,NM_GRAU_ACADEMICO)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","area_cd","area","grande_area_cd","grande_area","grau")
    )
)

td_base$programa <- toupper(td_base$programa)
td_base$grau <- toupper(td_base$grau)
td_base$programa <- ifelse(td_base$grande_area=="CIÊNCIAS HUMANAS",td_base$programa,"Outros")
td_base$area <- ifelse(td_base$grande_area=="CIÊNCIAS HUMANAS",td_base$area,"Outras")
td_base$grande_area <- ifelse(td_base$grande_area=="CIÊNCIAS HUMANAS",td_base$grande_area,"Outras")

td_view <- setNames(dcast(data.table(td_base),ano+grau+uf_sg+ies_sg+grande_area+area+programa~""),c("ano","grau","uf_sg","ies_sg","grande_area","area","programa","n_producoes"))

write.csv2(td_view,"tabelas/td_view.csv",row.names=F,na="")
