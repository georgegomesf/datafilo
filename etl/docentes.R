library(data.table)
library(plyr)

dir <- "fontes/"

arquivos <- list.files(dir)
arquivos <- head(arquivos[arquivos %ilike% "docente"],1)

ate_2012 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  td <- fread(paste0(dir,arquivo), encoding = 'Latin-1')
  if(!is.na(td)){
    td <- subset(td,select=c(AN_BASE,SG_UF_ENTIDADE_ENSINO,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_NIVEL_PROGRAMA,ID_AREA_AVALIACAO,NM_AREA_AVALIACAO))
    ate_2012 <- rbind.fill(ate_2012,td)
  }

}

arquivos <- list.files(dir)
arquivos <- tail(arquivos[arquivos %ilike% "docente"],10)

desde_2013 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  td <- fread(paste0(dir,arquivo), encoding = 'Latin-1')
  if(!is.na(td)){
    td <- subset(td,select=c(AN_BASE,SG_UF_PROGRAMA,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_GRAU_PROGRAMA,CD_AREA_AVALIACAO,NM_AREA_AVALIACAO))
    desde_2013 <- rbind.fill(desde_2013,td)
  }

}

base <- rbind.fill(
    setNames(
        subset(ate_2012,select=c(AN_BASE,SG_UF_ENTIDADE_ENSINO,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_NIVEL_PROGRAMA,ID_AREA_AVALIACAO,NM_AREA_AVALIACAO)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","area_cd","area")
    ),
    setNames(
        subset(desde_2013,select=c(AN_BASE,SG_UF_PROGRAMA,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_GRAU_PROGRAMA,CD_AREA_AVALIACAO,NM_AREA_AVALIACAO)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","area_cd","area")
    )
)

base$programa <- toupper(base$programa)

base$area <- ifelse(base$area %like% "FILOSOFIA","FILOSOFIA",base$area)
base$grande_area <- ifelse(base$area %in% c("EDUCAÇÃO","DIREITO", "LETRAS / LINGUÍSTICA", "PSICOLOGIA", "ANTROPOLOGIA / ARQUEOLOGIA", "ENSINO", "SOCIOLOGIA", "SERVIÇO SOCIAL","GEOGRAFIA", "HISTÓRIA", "ECONOMIA", "FILOSOFIA / TEOLOGIA:SUBCOMISSÃO FILOSOFIA", "ARTES / MÚSICA","CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS", "CIÊNCIAS SOCIAIS APLICADAS I", "FILOSOFIA/TEOLOGIA:SUBCOMISSÃO TEOLOGIA", "COMUNICAÇÃO E INFORMAÇÃO", "FILOSOFIA","TEOLOGIA", "LINGUÍSTICA E LITERATURA", "ARTES", "CIÊNCIAS DA RELIGIÃO E TEOLOGIA"),"CIÊNCIAS HUMANAS","Outras")
base$area <- ifelse(base$grande_area=="CIÊNCIAS HUMANAS",base$area,"Outras")
base$programa <- ifelse(base$grande_area=="CIÊNCIAS HUMANAS",base$programa,"Outros")

view <- setNames(dcast(data.table(base),ano+grau+uf_sg+ies_sg+grande_area+area+programa~""),c("ano","grau","uf_sg","ies_sg","grande_area","area","programa","medida"))

write.csv2(view,"tabelas/do_view.csv",row.names=F,na="")
