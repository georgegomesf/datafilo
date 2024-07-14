# dataFilo - _Projeto Base Filosófica_

Scripts para a análise dos dados da pesquisa acadêmica em Filosofia no Brasil, disponibilizados no âmbito do Projeto Base Filosófica.

## Sobre o dataFilo

A análise de dados é um dos eixos centrais do __Projeto Base Filosófica__, que oferece suporte à pesquisa acadêmica em filosofia no Brasil, através da indexação e disponibilização de produções como __Artigos__, __Teses__ e __Dissertações__, e da produção de conhecimento sobre técnicas, métodos e recursos úteis ao desenvolvimento dos estudos.

O __dataFilo__ objetiva a produção de análises com foco na realidade acadêmica, concentrando esforços na caracterização do cenário de pesquisa, desde as suas condições até a publicização de seus resultados.

## Fontes de dados

Atualmente, utilizamos como fontes principais as bases disponíveis no site de dados abertos da Capes (https://dadosabertos.capes.gov.br/), e na coleta direta de informações disponíveis nos sites de 62 revistas acadêmicas, monitoradas a partir dos metadados capturados na interface gerada pelo sistema Open Journal System (OJS).

## Linguagem de produção

Utiliza-se a __Linguagem R__ como padrão para o processo de Extração, Tratamento e Carga (ETL) dos dados. A saída final ocorre para __arquivos CSV__, contendo as visões necessárias à análise.

## Produtos

Os principsi produtos são carregados para um banco __PostgresQl__ que fornece os dados usados na página do dataFilo, disponível no site Base Filosófica (https://basefilosofica.com.br/datafilo).