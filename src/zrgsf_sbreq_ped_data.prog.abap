* Declarando minhas tabelas que vão ser utilizadas no REPORT *
TABLES: eban, ekpo, ekko, mara, makt, lfa1, t001w, ztbgsf_sbrevped.

* Declarando meus tipos que vão ser utilizados no REPORT *
TYPES: BEGIN OF ty_saida,
         ebeln      TYPE ekpo-ebeln,
         ebelp      TYPE ekpo-ebelp,
         aedat      TYPE ekko-aedat,
         banfn      TYPE ekpo-banfn,
         bnfpo      TYPE ekpo-bnfpo,
         loekz      TYPE ekko-loekz,
         revis      TYPE c,
         matnr      TYPE ekpo-matnr,
         maktx      TYPE makt-maktx,
         badat      TYPE eban-badat,
         afnam      TYPE eban-afnam,
         werks      TYPE ekpo-werks,
         lgort      TYPE ekpo-lgort,
         forne      TYPE c LENGTH 10,
         desc_forne TYPE c LENGTH 35,
         menge      TYPE ekpo-menge,
         meins      TYPE ekpo-meins,
         netpr      TYPE ekpo-netpr,
       END OF ty_saida,

       BEGIN OF ty_eban,
         banfn TYPE eban-banfn,
         bnfpo TYPE eban-bnfpo,
         badat TYPE eban-badat,
         afnam TYPE eban-afnam,
       END OF ty_eban,

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         banfn TYPE ekpo-banfn,
         bnfpo TYPE ekpo-bnfpo,
         werks TYPE ekpo-werks,
         lgort TYPE ekpo-lgort,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         netpr TYPE ekpo-netpr,
         matnr TYPE ekpo-matnr,
       END OF ty_ekpo,

       BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         aedat TYPE ekko-aedat,
         loekz TYPE ekko-loekz,
         lifnr TYPE ekko-lifnr,
         reswk TYPE ekko-reswk,
       END OF ty_ekko,

       BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
       END OF ty_mara,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         spras TYPE makt-spras,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_lfa1,
         lifnr TYPE lfa1-lifnr,
         name1 TYPE lfa1-name1,
       END OF ty_lfa1,

       BEGIN OF ty_t001w,
         werks TYPE t001w-werks,
         name1 TYPE t001w-name1,
       END OF ty_t001w.

* Declarando minhas tabelas internas globais que vão ser utilizadas no REPORT *
DATA: gt_saida  TYPE STANDARD TABLE OF ty_saida,
      gt_eban   TYPE STANDARD TABLE OF ty_eban,
      gt_ekpo   TYPE STANDARD TABLE OF ty_ekpo,
      gt_ekko   TYPE STANDARD TABLE OF ty_ekko,
      gt_mara   TYPE STANDARD TABLE OF ty_mara,
      gt_makt   TYPE STANDARD TABLE OF ty_makt,
      gt_lfa1   TYPE STANDARD TABLE OF ty_lfa1,
      gt_t001w  TYPE STANDARD TABLE OF ty_t001w,
      gt_ztbgsf TYPE STANDARD TABLE OF ztbgsf_sbrevped.

* Declarando meus objetos globais que vão ser utilizados para a exibição do ALV *
DATA: go_cc  TYPE REF TO cl_gui_custom_container,
      go_alv TYPE REF TO cl_gui_alv_grid.
