library(data.table)
library(plyr)

dir <- "fontes/"

arquivos <- list.files(dir)
arquivos <- head(arquivos[arquivos %ilike% "colsucup"],9)

ate_2012 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  dt <- fread(paste0(dir,arquivo), encoding = 'Latin-1')
  if(nrow(dt)>0){
    dt <- subset(dt,select=c(AN_BASE,SG_UF_ENTIDADE_ENSINO,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_NIVEL_TITULACAO_DISCENTE,CD_AREA_AVALIACAO,NM_AREA_AVALIACAO,NM_SITUACAO_DISCENTE))
    ate_2012 <- rbind.fill(ate_2012,dt)
  }

}

arquivos <- list.files(dir)
arquivos <- tail(arquivos[arquivos %ilike% "colsucup"],10)

desde_2013 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  dt <- fread(paste0(dir,arquivo), encoding = 'Latin-1',fill=TRUE)
  if(nrow(dt)>0){
    dt <- subset(dt,select=c(AN_BASE,SG_UF_PROGRAMA,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,DS_GRAU_ACADEMICO_DISCENTE,CD_AREA_AVALIACAO,NM_AREA_AVALIACAO,NM_SITUACAO_DISCENTE))
    desde_2013 <- rbind.fill(desde_2013,dt)
  }

}

base <- rbind.fill(
    setNames(
        subset(ate_2012,select=c(AN_BASE,SG_UF_ENTIDADE_ENSINO,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_NIVEL_TITULACAO_DISCENTE,CD_AREA_AVALIACAO,NM_AREA_AVALIACAO,NM_SITUACAO_DISCENTE)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","area_cd","area","situacao")
    ),
    setNames(
        subset(desde_2013,select=c(AN_BASE,SG_UF_PROGRAMA,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,DS_GRAU_ACADEMICO_DISCENTE,CD_AREA_AVALIACAO,NM_AREA_AVALIACAO,NM_SITUACAO_DISCENTE)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","area_cd","area","situacao")
    )
)

base$programa <- toupper(base$programa)

base$area <- ifelse(base$area %like% "FILOSOFIA","FILOSOFIA",base$area)
base$grande_area <- ifelse(base$area %in% c("EDUCAÇÃO","DIREITO", "LETRAS / LINGUÍSTICA", "PSICOLOGIA", "ANTROPOLOGIA / ARQUEOLOGIA", "ENSINO", "SOCIOLOGIA", "SERVIÇO SOCIAL","GEOGRAFIA", "HISTÓRIA", "ECONOMIA", "FILOSOFIA / TEOLOGIA:SUBCOMISSÃO FILOSOFIA", "ARTES / MÚSICA","CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS", "CIÊNCIAS SOCIAIS APLICADAS I", "FILOSOFIA/TEOLOGIA:SUBCOMISSÃO TEOLOGIA", "COMUNICAÇÃO E INFORMAÇÃO", "FILOSOFIA","TEOLOGIA", "LINGUÍSTICA E LITERATURA", "ARTES", "CIÊNCIAS DA RELIGIÃO E TEOLOGIA"),"CIÊNCIAS HUMANAS","Outras")
base$area <- ifelse(base$grande_area=="CIÊNCIAS HUMANAS",base$area,"Outras")
base$programa <- ifelse(base$grande_area=="CIÊNCIAS HUMANAS",base$programa,"Outros")
base <- subset(base,situacao %in% c("MATRICULADO"))
base <- subset(base,!grau %in% c("GRADUAÇÃO"))

view <- setNames(dcast(data.table(base),ano+grau+uf_sg+ies_sg+grande_area+area+programa~""),c("ano","grau","uf_sg","ies_sg","grande_area","area","programa","medida"))

write.csv2(view,"tabelas/discentes.csv",row.names=F,na="")
