# Relatório-REQ-PED-CMP-SAP-ABAP

**Objetivo / Solicitação**
Relatório para análises de requisições e pedidos de compras. 

**Detalhamento** 

**Processos**

* Criar tabela: Nome: ZTB<inicial>_SBREVPED (Revisão Pedido Requisição) 

| Campo | Elemento |
| :--- | :--- |
| MANDT | MANDT |
| EBELN | EBELN |
| EBELP | EBELP |
| BANFN | BANFN |
| BNFPO | BNFPO |
| USUARIO | SYST_UNAME |
| DATA | SYST_DATUM |
| HORA | SYST_UZEIT |

* Criar um relatório ALV (report) – Nome: ZR<iniciais>_SBREQ_PED
    * Opções de seleção:
        * **Data Pedido (EKKO-AEDAT) – Obrigatório**
            * Preencher automaticamente com o período do mês anterior ao atual. Ex. Estamos em maio, preencher com: 01/04/2021 até 30/04/2021.
        * Requisição (EKPO-BANFN)
        * Pedido (EKKO-EBELN)
        * Material (EKPO-MATNR)
    * Regra:
        * Tabelas EBAN (Requisição Compra), EKPO (Itens – Pedido compra), EKKO (Cabeçalho – Pedido compra), MARA (material), MAKT (descrições materiais), LFA1 (fornecedores), T001W (centros/filiais)
        * Buscas:
            * EKKO (com os filtros de data e pedido)
            * EKPO (a partir da tabela EKKO, utilizando o campo EBELN, junto com os demais filtros, de requisição e material)
            * EBAN (a partir da tabela EKPO, utilizando os campos BANFN e BNFPO)
            * MARA (a partir da tabela EKPO, utilizando o campo MATNR)
            * MAKT (a partir da tabela MARA, utilizando o campo MATNR como chave principal e campo SPRAS = sy-langu)
            * LFA1 (a partir da tabela EKKO, utilizando o campo LIFNR Cuidado pode haver valores repetidos ou vazio).
            * T001W (a partir da tabela EKKO, utilizando o campo WERKS = EKKO-RESWK. Cuidado pode haver valores repetidos ou vazio). 

    * Funcionalidade
        * Checkbox para seleção de linhas
        * Adicionar botão na barra de tarefas do ALV com o label: “Registros Revisados”.
            * Quando clicado neste botão, irá verificar as linhas com o ckeckbox marcado (linhas selecionadas), gravando o registro na tabela ZTB<inicial>_SBREVPED.
            * Após a gravação, refazer a montagem do ALV para atualizar a exibição. 

    * Cálculo:
        * Fornecedor: pode ser um fornecedor ou mesmo outra loja. Se EKKO-LIFNR estiver vazio, utilizar o campo EKKO-RESWK
        * Descrição fornecedor: se o fornecedor está em EKKO-LIFNR, então buscar LFA1-NAME1. Caso contrário, buscar T001W-name1.
        * Revisado: Busca informação na tabela ZTB<inicial>_SBREVPED pela chave: EKPO-EBELN, EKPO-EBELP, EKPO-BANFN, EKPO-BNFPO.
            * Se encontrar este campo = ‘X’, caso contrário ficará em branco.  

    * Exibição
        * EKPO-EBELN (pedido)
        * EKPO-EBELP (item pedido)
        * EKKO-AEDAT (data pedido)
        * EKPO-BANFN (requisição)
        * EKPO-BNFPO (item requisição)
        * EKKO-LOEKZ (pedido eliminado)
        * Revisado (verificar tópico de cálculo)
        * EKPO-MATNR (material)
        * MAKT-MAKTX (desc. Material)
        * EBAN-BADAT (data requisição)
        * EBAN-AFNAM (requisitante)
        * EKPO-WERKS (centro)
        * EKPO-LGORT (deposito)
        * Fornecedor (verificar tópico de cálculo)
        * Descrição fornecedor (verificar tópico de cálculo)
        * EKPO-MENGE (quantidade)
        * EKPO-MEINS (unidade medida)
        * EKPO-NETPR (preço líquido)
