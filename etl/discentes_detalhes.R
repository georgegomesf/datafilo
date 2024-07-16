library(data.table)
library(plyr)

dir <- "fontes/"

arquivos <- list.files(dir)
arquivos <- head(arquivos[arquivos %ilike% "discente"],9)

ate_2012 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  dt <- fread(paste0(dir,arquivo), encoding = 'Latin-1')
  if(nrow(dt)>0){
    dt <- subset(dt,NM_AREA_AVALIACAO %like% "FILOSOFIA",select=c(AN_BASE,SG_UF_ENTIDADE_ENSINO,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_NIVEL_TITULACAO_DISCENTE,NM_SITUACAO_DISCENTE,NR_SEQUENCIAL_DISCENTE,NR_IDADE_DISCENTE,AN_MATRICULA_DISCENTE,NM_PAIS_ORIGEM_DISCENTE))
    ate_2012 <- rbind.fill(ate_2012,dt)
  }

}

arquivos <- list.files(dir)
arquivos <- tail(arquivos[arquivos %ilike% "discente"],10)

desde_2013 <- data.frame()

for(arquivo in arquivos){

  print(arquivo)
  dt <- fread(paste0(dir,arquivo), encoding = 'Latin-1',fill=TRUE)
  if(nrow(dt)>0){
    dt <- subset(dt,NM_AREA_AVALIACAO %like% "FILOSOFIA",select=c(AN_BASE,SG_UF_PROGRAMA,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,DS_GRAU_ACADEMICO_DISCENTE,NM_SITUACAO_DISCENTE,ID_PESSOA,AN_NASCIMENTO_DISCENTE,DT_MATRICULA_DISCENTE,NM_PAIS_NACIONALIDADE_DISCENTE))
    desde_2013 <- rbind.fill(desde_2013,dt)
  }

}

desde_2013$AN_MATRICULA_DISCENTE <- paste0("20",substring(desde_2013$DT_MATRICULA_DISCENTE,6,7))
desde_2013$NR_IDADE_DISCENTE <- desde_2013$AN_BASE-desde_2013$AN_NASCIMENTO_DISCENTE

base <- rbind.fill(
    setNames(
        subset(ate_2012,select=c(AN_BASE,SG_UF_ENTIDADE_ENSINO,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,NM_NIVEL_TITULACAO_DISCENTE,NM_SITUACAO_DISCENTE,NR_SEQUENCIAL_DISCENTE,NR_IDADE_DISCENTE,AN_MATRICULA_DISCENTE,NM_PAIS_ORIGEM_DISCENTE)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","situacao","pessoa_id","idade","ano_matricula","pais_origem")
    ),
    setNames(
        subset(desde_2013,select=c(AN_BASE,SG_UF_PROGRAMA,SG_ENTIDADE_ENSINO,CD_PROGRAMA_IES,NM_PROGRAMA_IES,DS_GRAU_ACADEMICO_DISCENTE,NM_SITUACAO_DISCENTE,ID_PESSOA,NR_IDADE_DISCENTE,AN_MATRICULA_DISCENTE,NM_PAIS_NACIONALIDADE_DISCENTE)),
        c("ano","uf_sg","ies_sg","programa_cd","programa","grau","situacao","pessoa_id","idade","ano_matricula","pais_origem")
    )
)

base$programa <- toupper(base$programa)
base <- subset(base,!grau %in% c("GRADUAÇÃO") & !situacao %like% "DEFESA")
base$situacao <- ifelse(base$situacao=='ABANDONOU','ABANDONO',base$situacao)

write.csv2(base,"tabelas/discentes_detalhes.csv",row.names=F,na="")
