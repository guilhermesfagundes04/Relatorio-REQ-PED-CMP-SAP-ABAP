* Faço meu formulário de busca (SELECTS) começar sempre do macro pro micro. *
FORM zf_busca.

  SELECT ebeln, aedat, loekz, lifnr, reswk                                      "SELECIONO esses atributos
    FROM ekko                                                                   "DA TABELA ekko
    INTO CORRESPONDING FIELDS OF TABLE @gt_ekko                                 "EM CAMPOS CORRESPONDENTES DA TABELA gt_ekko
    WHERE aedat IN @s_aedat                                                     "ONDE aedat está EM seleção s_aedat
      AND ebeln IN @s_ebeln.                                                    "E ebeln está EM seleção s_ebeln.

  IF sy-subrc IS INITIAL.                                                       "SE sy-subrc É INICIAL (valor padrão = 0).

    SELECT ebeln, ebelp, banfn, bnfpo, werks, lgort, menge, meins, netpr, matnr "SELECIONO esses atributos
      FROM ekpo                                                                 "DA TABELA ekpo
      INTO CORRESPONDING FIELDS OF TABLE @gt_ekpo                               "EM CAMPOS CORRESPONDENTES DA TABELA gt_ekpo
      FOR ALL ENTRIES IN @gt_ekko                                               "PARA TODAS AS ENTRADAS EM gt_ekko
      WHERE banfn IN @s_banfn                                                   "ONDE banfn está EM seleção s_banfn
        AND matnr IN @s_matnr                                                   "E matnr está EM seleção s_matnr
        AND ebeln EQ @gt_ekko-ebeln.                                            "E ebeln IGUAL A gt_ekko-ebeln.

    SELECT banfn, bnfpo, badat, afnam                                           "SELECIONO esses atributos
      FROM eban                                                                 "DA TABELA eban
      INTO CORRESPONDING FIELDS OF TABLE @gt_eban                               "EM CAMPOS CORRESPONDENTES DA TABELA gt_eban
      FOR ALL ENTRIES IN @gt_ekpo                                               "PARA TODAS AS ENTRADAS EM gt_ekpo
      WHERE banfn EQ @gt_ekpo-banfn                                             "ONDE banfn IGUAL A gt_ekpo-banfn
        AND bnfpo EQ @gt_ekpo-bnfpo.                                            "E bnfpo IGUAL A gt_ekpo-bnfpo.

    SELECT matnr                                                                "SELECIONO esse atributo
      FROM mara                                                                 "DA TABELA mara
      INTO CORRESPONDING FIELDS OF TABLE @gt_mara                               "EM CAMPOS CORRESPONDENTES DA TABELA gt_mara
      FOR ALL ENTRIES IN @gt_ekpo                                               "PARA TODAS AS ENTRADAS EM gt_ekpo
      WHERE matnr EQ @gt_ekpo-matnr.                                            "ONDE matnr IGUAL A gt_ekpo-matnr.

    SELECT matnr, spras, maktx                                                  "SELECIONO esses atributos
      FROM makt                                                                 "DA TABELA makt
      INTO CORRESPONDING FIELDS OF TABLE @gt_makt                               "EM CAMPOS CORRESPONDENTES DA TABELA gt_makt
      FOR ALL ENTRIES IN @gt_mara                                               "PARA TODAS AS ENTRADAS EM gt_mara
      WHERE matnr EQ @gt_mara-matnr                                             "ONDE matnr IGUAL A gt_mara-matnr
        AND spras EQ @sy-langu.                                                 "E spras IGUAL A sy-langu.

    SELECT lifnr, name1                                                         "SELECIONO esses atributos
      FROM lfa1                                                                 "DA TABELA lfa1
      INTO CORRESPONDING FIELDS OF TABLE @gt_lfa1                               "EM CAMPOS CORRESPONDENTES DA TABELA gt_lfa1
      FOR ALL ENTRIES IN @gt_ekko                                               "PARA TODAS AS ENTRADAS EM gt_ekko
      WHERE lifnr EQ @gt_ekko-lifnr.                                            "ONDE lifnr IGUAL A gt_ekko-lifnr.

    SELECT werks, name1                                                         "SELECIONO esses atributos
      FROM t001w                                                                "DA TABELA t001w
      INTO CORRESPONDING FIELDS OF TABLE @gt_t001w                              "EM CAMPOS CORRESPONDENTES DA TABELA gt_t001w
      FOR ALL ENTRIES IN @gt_ekko                                               "PARA TODAS AS ENTRADAS EM gt_ekko
      WHERE werks EQ @gt_ekko-reswk.                                            "ONDE werks IGUAL A gt_ekko-reswk.

  ENDIF.                                                                        "Fim do IF (sy-subrc).

  PERFORM zf_ordenacao.                                                         "EXECUTAR FORM zf_ordenacao.

ENDFORM.                                                                        "Fim do FORM zf_busca.

* Faço meu formulário de ordenação (SORT). *
FORM zf_ordenacao.

  SORT: gt_ekko  BY ebeln, "ORDENAR tabela gt_ekko POR esse campo em ordem CRESCENTE.
        gt_ekpo  BY ebeln, "ORDENAR tabela gt_ekpo POR esse campo em ordem CRESCENTE.
        gt_eban  BY banfn, "ORDENAR tabela gt_eban POR esse campo em ordem CRESCENTE.
        gt_mara  BY matnr, "ORDENAR tabela gt_mara POR esse campo em ordem CRESCENTE.
        gt_makt  BY matnr, "ORDENAR tabela gt_makt POR esse campo em ordem CRESCENTE.
        gt_lfa1  BY lifnr, "ORDENAR tabela gt_lfa1 POR esse campo em ordem CRESCENTE.
        gt_t001w BY werks. "ORDENAR tabela gt_t001w POR esse campo em ordem CRESCENTE.

ENDFORM.

* Faço meu formulário de tratamento (LÓGICA). *
FORM zf_tratamento.

  FREE gt_saida.                                           "LIMPAR tabela interna global gt_saida.

* Criação dos meus FIELD-SYMBOLS (SÍMBOLOS DE CAMPO). *
  FIELD-SYMBOLS: <fs_saida> TYPE ty_saida,
                 <fs_eban>  TYPE ty_eban,
                 <fs_ekpo>  TYPE ty_ekpo,
                 <fs_ekko>  TYPE ty_ekko,
                 <fs_makt>  TYPE ty_makt,
                 <fs_lfa1>  TYPE ty_lfa1,
                 <fs_t001w> TYPE ty_t001w.

  LOOP AT gt_ekpo ASSIGNING <fs_ekpo>.                     "LAÇO EM gt_ekpo ATRIBUINDO fs_ekpo (do macro pro micro).

    APPEND INITIAL LINE TO gt_saida ASSIGNING <fs_saida>.  "ANEXAR NA LINHA INICIAL A gt_saida ATRIBUINDO fs_saida.
    <fs_saida>-ebeln = <fs_ekpo>-ebeln.                    "fs_saida-ebeln IGUAL fs_ekpo-ebeln (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-ebelp = <fs_ekpo>-ebelp.                    "fs_saida-ebelp IGUAL fs_ekpo-ebelp (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-banfn = <fs_ekpo>-banfn.                    "fs_saida-banfn IGUAL fs_ekpo-banfn (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-bnfpo = <fs_ekpo>-bnfpo.                    "fs_saida-bnfpo IGUAL fs_ekpo-bnfpo (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-matnr = <fs_ekpo>-matnr.                    "fs_saida-matnr IGUAL fs_ekpo-matnr (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-werks = <fs_ekpo>-werks.                    "fs_saida-werks IGUAL fs_ekpo-werks (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-lgort = <fs_ekpo>-lgort.                    "fs_saida-lgort IGUAL fs_ekpo-lgort (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-menge = <fs_ekpo>-menge.                    "fs_saida-menge IGUAL fs_ekpo-menge (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-meins = <fs_ekpo>-meins.                    "fs_saida-meins IGUAL fs_ekpo-meins (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    <fs_saida>-netpr = <fs_ekpo>-netpr.                    "fs_saida-netpr IGUAL fs_ekpo-netpr (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).

* Leitura da tabela gt_ekko ATRIBUINDO field-symbol fs_ekko COM CHAVE ebeln IGUAL a fs_ekpo-ebeln em PESQUISA BINÁRIA. *
    READ TABLE gt_ekko ASSIGNING <fs_ekko>
                       WITH KEY ebeln = <fs_ekpo>-ebeln
                       BINARY SEARCH.
    IF sy-subrc IS INITIAL.                                "SE sy-subrc É INICIAL (valor padrão = 0).
      <fs_saida>-aedat = <fs_ekko>-aedat.                  "fs_saida-aedat IGUAL fs_ekko-aedat (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
      <fs_saida>-loekz = <fs_ekko>-loekz.                  "fs_saida-loekz IGUAL fs_ekko-loekz (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    ENDIF.                                                 "Fim do IF (sy-subrc).

* Cálculo de fornecedor. *
    IF <fs_ekko>-lifnr =  ''.                              "SE fs_ekko-lifnr FOR '' - Vazio
      <fs_saida>-forne = <fs_ekko>-reswk.                  "fs_saida-forne IGUAL fs_ekko-reswk (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    ELSE.                                                  "SENÃO.
      <fs_saida>-forne = <fs_ekko>-lifnr.                  "fs_saida-forne IGUAL fs_ekko-lifnr (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    ENDIF.                                                 "Fim do IF (fs_ekko-lifnr).

* Cálculo de descrição do fornecedor. *
    IF <fs_saida>-forne = <fs_ekko>-lifnr.                 "SE fs_saida-forne FOR IGUAL A fs_ekko-lifnr
* Leitura da tabela gt_lfa1 ATRIBUINDO field-symbol fs_lfa1 COM CHAVE lifnr IGUAL a fs_ekko-lifnr em PESQUISA BINÁRIA. *
      READ TABLE gt_lfa1 ASSIGNING <fs_lfa1>
                         WITH KEY lifnr = <fs_ekko>-lifnr
                         BINARY SEARCH.
      <fs_saida>-desc_forne = <fs_lfa1>-name1.             "fs_saida-desc_forne IGUAL fs_lfa1-name1 (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    ELSE.                                                  "SENÃO.
* Leitura da tabela gt_t001w ATRIBUINDO field-symbol fs_t001w COM CHAVE werks IGUAL a fs_ekko-werks em PESQUISA BINÁRIA. *
      READ TABLE gt_t001w ASSIGNING <fs_t001w>
                          WITH KEY werks = <fs_ekko>-reswk
                          BINARY SEARCH.
      <fs_saida>-desc_forne = <fs_t001w>-name1.            "fs_saida-desc_forne IGUAL fs_t001w-name1 (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    ENDIF.                                                 "Fim do IF (fs_saida-forne = fs_ekko-lifnr).

* Leitura da tabela gt_makt ATRIBUINDO field-symbol fs_makt COM CHAVE matnr IGUAL a fs_ekpo-matnr em PESQUISA BINÁRIA. *
    READ TABLE gt_makt ASSIGNING <fs_makt>
                     WITH KEY matnr = <fs_ekpo>-matnr
                     BINARY SEARCH.
    IF sy-subrc IS INITIAL.                                "SE sy-subrc É INICIAL (valor padrão = 0).
      <fs_saida>-maktx = <fs_makt>-maktx.                  "fs_saida-maktx IGUAL fs_makt-maktx (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    ENDIF.                                                 "Fim do IF (sy-subrc).

* Leitura da tabela gt_eban ATRIBUINDO field-symbol fs_eban COM CHAVE banfn/bnfpo IGUAL a fs_ekpo-banfn/bnfpo em PESQUISA BINÁRIA. *
    READ TABLE gt_eban ASSIGNING <fs_eban>
                     WITH KEY banfn = <fs_ekpo>-banfn
                              bnfpo = <fs_ekpo>-bnfpo
                     BINARY SEARCH.
    IF sy-subrc IS INITIAL.                                "SE sy-subrc É INICIAL (valor padrão = 0).
      <fs_saida>-badat = <fs_eban>-badat.                  "fs_saida-badat IGUAL fs_eban-badat (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
      <fs_saida>-afnam = <fs_eban>-afnam.                  "fs_saida-afnam IGUAL fs_eban-afnam (ATRIBUINDO AO MEU FIELD-SYMBOL DE SAÍDA O QUE QUERO EXIBIR NA TELA).
    ENDIF.                                                 "Fim do IF (sy-subrc).

* Cálculo de revisados. *
    SELECT SINGLE ebeln                                    "SELECIONE ÚNICO ebeln (SELEÇÃO DE UMA ÚNICA LINHA)
     FROM ztbgsf_sbrevped                                  "DA TABELA ztbgsf_sbrevped
     WHERE ebeln EQ @<fs_ekpo>-ebeln                       "ONDE ebeln IGUAL A fs_ekpo-ebeln
       AND ebelp EQ @<fs_ekpo>-ebelp                       "E ebelp IGUAL A fs_ekpo-ebelp
       AND banfn EQ @<fs_ekpo>-banfn                       "E banfn IGUAL A fs_ekpo-banfn
       AND bnfpo EQ @<fs_ekpo>-bnfpo                       "E bnfpo IGUAL A fs_bnfpo
     INTO @DATA(lv_check).                                 "JOGANDO DENTRO da DECLARAÇÃO DE variável local lv_check.
    IF sy-subrc IS INITIAL.                                "SE sy-subrc É INICIAL (valor padrão = 0).
      <fs_saida>-revis = 'X'.                              "fs_saida-revis IGUAL A 'X'(marcação de revisado COM X).
    ELSE.                                                  "SENÃO
      <fs_saida>-revis = ''.                               "fs_saida-revis IGUAL A ''(marcação de revisado VAZIO).
    ENDIF.                                                 "Fim do IF (sy-subrc).

  ENDLOOP.                                                 "Fim do LOOP.

ENDFORM.                                                   "Fim do FORM zf_tratamento.
