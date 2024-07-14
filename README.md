# dataFilo - _Projeto Base Filosófica_

Scripts para a análise dos dados da pesquisa acadêmica em Filosofia no Brasil, disponibilizados no âmbito do Projeto Base Filosófica.

## Sobre o dataFilo

A análise de dados é um dos eixos centrais do __Projeto Base Filosófica__, que oferece suporte à pesquisa acadêmica em filosofia no Brasil, através da indexação e disponibilização de produções como __Artigos__, __Teses__ e __Dissertações__, e da produção de conhecimento sobre técnicas, métodos e recursos úteis ao desenvolvimento dos estudos.

O __dataFilo__ objetiva a produção de análises com foco na realidade acadêmica, concentrando esforços na caracterização do cenário de pesquisa, desde as suas condições até a publicização de seus resultados.

## Fontes de dados

Atualmente, utilizamos como fontes principais as bases disponíveis no site de dados abertos da Capes (https://dadosabertos.capes.gov.br/), e na coleta direta de informações disponíveis nos sites de 62 revistas acadêmicas, monitoradas a partir dos metadados capturados na interface gerada pelo sistema Open Journal System (OJS). Os nomes dos arquivos foram conservados como no original, mas os arquivos foram compactados para GZ, cujo tamanho reduzido facilita o transporte, ao mesmo tempo, que não impede de ser carregado a partir da função _fread()_, da biblioteca __data.tables__.

## Produção

Utiliza-se a __Linguagem R__ como padrão para o processo de Extração, Tratamento e Carga (ETL) dos dados. A saída final é direcionada para __arquivos CSV__, contendo as visões necessárias às análises.

## Produtos

A partir dos arquivos CSV diversas técnicas e métodos estatísticos podem ser aplicados. Para ver o resultado de algumas análises acesse a página do __dataFilo__, disponível no site Base Filosófica (https://basefilosofica.com.br/datafilo).