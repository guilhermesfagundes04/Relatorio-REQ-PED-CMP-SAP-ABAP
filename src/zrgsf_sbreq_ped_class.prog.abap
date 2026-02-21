CLASS lcl_event_handler DEFINITION.                             "CLASSE local (botões, comandos) DEFINIÇÃO.
  PUBLIC SECTION.                                               "SEÇÃO PÚBLICA.
    METHODS:                                                    "MÉTODOS

      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid           "on_toolbar PARA EVENTO toolbar DE cl_gui_alv_grid
        IMPORTING e_object e_interactive,                       "IMPORTANDO e_object, e_interactive (PARÂMETROS)

      on_user_command FOR EVENT user_command OF cl_gui_alv_grid "on_user_command PARA EVENTO user_command DE cl_gui_alv_grid
        IMPORTING e_ucomm.                                      "IMPORTANDO e_ucomm (PARÂMETROS).

ENDCLASS.                                                       "Fim da classe DEFINIÇÃO.

CLASS lcl_event_handler IMPLEMENTATION.                         "CLASSE local (botões, comandos) IMPLEMENTAÇÃO.

  METHOD on_toolbar.                                            "MÉTODO on_toolbar.

    DATA: ls_button TYPE stb_button.                            "DECLARAR ESTRUTURA ls_button TIPO stb_button.

    FREE ls_button.                                             "LIMPAR ESTRUTURA ls_button.
    ls_button-function = 'REVISAR'.                             "FUNÇÃO revisar.
    ls_button-icon      = icon_generate.                        "ÍCONE próprio da SAP.
    ls_button-quickinfo = 'Registros Revisados'.                "INFORMAÇÃO RÁPIDA DE UM ÍCONE.
    ls_button-text      = 'Registros Revisados'.                "TEXTO.
    APPEND ls_button TO e_object->mt_toolbar.                   "ACRESCENTAR na ESTRUTURA ls_button PARA PARÂMETRO e_object ACESSANDO (->) atributo mt_toolbar.

  ENDMETHOD.                                                    "Fim do método on_toolbar

  METHOD on_user_command.                                       "MÉTODO on_user_command.

    CASE e_ucomm.                                               "CASO PARÂMETRO e_ucomm.
      WHEN 'REVISAR'.                                           "QUANDO for REVISAR.
        PERFORM zf_revisados.                                   "EXECUTAR (form zf_revisados).
    ENDCASE.                                                    "Fim do caso.

  ENDMETHOD.                                                    "Fim do método on_user_command.

ENDCLASS.                                                       "Fim da classe IMPLEMENTAÇÃO.

DATA: go_event_handler TYPE REF TO lcl_event_handler.           "DECLARAR OBJETO go_event_handler TIPO REFERÊNCIA DE classe local lcl_event_handler.

* Faço meu formulário de registros revisados. *
FORM zf_revisados.

* Declaração de estruturas e tabelas globais e locais para utilizar no FORM. *
  DATA: gs_saida TYPE ty_saida,
        lt_rows  TYPE lvc_t_row,
        ls_row   TYPE lvc_s_row.

  CALL METHOD go_alv->get_selected_rows                         "MÉTODO DE CHAMADA go_alv ACESSANDO o método get_selected_rows.
    IMPORTING                                                   "IMPORTANDO
      et_index_rows = lt_rows.                                  "PARÂMETRO DE SAÍDA index de linhas IGUAL A tabela interna local lt_rows.

  IF lt_rows IS INITIAL.                                        "SE tabela interna local lt_rows FOR INICIAL.
    MESSAGE 'Nenhum registro foi selecionado.' TYPE 'I'.        "MENSAGEM do TIPO 'I' - Informação.
    RETURN.                                                     "RETURN (Sai do FORM).
  ENDIF.                                                        "Fim do IF (lt_rows).

  LOOP AT lt_rows INTO ls_row.                                  "LAÇO EM tabela interna local lt_rows JOGANDO DENTRO da estrutura local ls_row.
    READ TABLE gt_saida INTO gs_saida INDEX ls_row-index.       "LEITURA DA TABELA interna global gt_saida JOGANDO DENTRO da estrutula local gs_saida COM ÍNDICE ls_row-index.
    IF sy-subrc IS INITIAL.                                     "SE sy-subrc É INICIAL (valor padrão = 0).

      SELECT SINGLE *                                           "SELECIONE ÚNICO * (TUDO) (SELEÇÃO DE UMA ÚNICA LINHA)
        FROM ztbgsf_sbrevped                                    "DA TABELA ztbgsf_sbrevped
        WHERE ebeln = @gs_saida-ebeln                           "ONDE ebeln IGUAL A gs_saida-ebeln
          AND ebelp = @gs_saida-ebelp                           "E ebelp IGUAL A gs_saida-ebelp
          AND banfn = @gs_saida-banfn                           "E banfn IGUAL A gs_saida-banfn
          AND bnfpo = @gs_saida-bnfpo                           "E bnfpo IGUAL A gs_saida-bnfpo
        INTO @DATA(ls_existente).                               "JOGANDO DENTRO da DECLARAÇÃO de uma estrutura local ls_existente.

      IF sy-subrc IS INITIAL.                                   "SE sy-subrc É INICIAL (valor padrão = 0).

        MOVE-CORRESPONDING gs_saida TO ls_existente.            "COPIA TODOS OS CAMPOS QUE TÊM O MESMO NOME DE gs_saida PARA ls_existente.
        ls_existente-usuario = sy-uname.                        "Variável ls_existente-usuario IGUAL A sy-uname (VARIÁVEL DE SISTEMA).
        ls_existente-data    = sy-datum.                        "Variável ls_existente-data IGUAL A sy-datum (VARIÁVEL DE SISTEMA).
        ls_existente-hora    = sy-uzeit.                        "Variável ls_existente-hora IGUAL A sy-uzeit (VARIÁVEL DE SISTEMA).
        UPDATE ztbgsf_sbrevped FROM ls_existente.               "ATUALIZAR a tabela ztbgsf_sbrevped PARA a estrutura local ls_existente.
      ELSE.                                                     "SENÃO
        DATA(ls_ins) = VALUE ztbgsf_sbrevped(                   "DECLARAÇÃO de uma estrutua local ls_ins IGUAL A VALORES para a tabela ztbgsf_sbrevped
          mandt   = sy-mandt                                    "mandt IGUAL A sy-mandt (VARIÁVEL DE SISTEMA)
          ebeln   = gs_saida-ebeln                              "ebeln IGUAL A gs_saida-ebeln
          ebelp   = gs_saida-ebelp                              "ebelp IGUAL A gs_saida-ebelp
          banfn   = gs_saida-banfn                              "banfn IGUAL A gs_saida-banfn
          bnfpo   = gs_saida-bnfpo                              "bnfpo IGUAL A gs_saida-bnfpo
          usuario = sy-uname                                    "usuario IGUAL A sy-uname (VARIÁVEL DE SISTEMA)
          data    = sy-datum                                    "data IGUAL A sy-datum (VARIÁVEL DE SISTEMA)
          hora    = sy-uzeit ).                                 "hora IGUAL A sy-uzeit (VARIÁVEL DE SISTEMA).

        INSERT ztbgsf_sbrevped FROM ls_ins.                     "INSERIR ztbgsf_sbrevped PARA estrutura local ls_ins.
      ENDIF.                                                    "Fim do IF (sy-subrc).

      IF sy-subrc IS INITIAL.                                                                    "SE sy-subrc É INICIAL (valor padrão = 0).
        MESSAGE |Registro { gs_saida-ebeln }-{ gs_saida-ebelp } revisado com sucesso.| TYPE 'S'. "MENSAGEM do TIPO 'S' - Sucesso.
      ELSE.                                                                                      "SENÃO.
        MESSAGE |Erro ao salvar o registro { gs_saida-ebeln }-{ gs_saida-ebelp }.| TYPE 'E'.     "MENSAGEM do TIPO 'E' - Erro.
      ENDIF.                                                                                     "Fim do IF (sy-subrc).

    ENDIF. "Fim do IF principal (sy-subrc).

  ENDLOOP. "Fim do LOOP.

  COMMIT WORK. "CONFIRMA (salva de forma definitiva).

ENDFORM. "Fim do FORM zf_revisados.
