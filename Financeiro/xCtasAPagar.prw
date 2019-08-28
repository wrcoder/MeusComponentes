#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"

User Function ContaAPagar()
Return Nil

/*
=====================================================================================
|Programa: cContaAPagar    |Autor: Wanderley R. Neto               |Data: 18/01/2019|
=====================================================================================
|Descri��o: Classe respos�vel pela gera��o de titulos de contas a pagar.            |
|                                                                                   |
=====================================================================================
*/
Class ContaAPagar From ExecAuto

	Data nOpcao
	Data cErro
	Data lPaMovBco
	
   Method New(nOpc) Constructor
	Method AddCampo(cCampo, xValor)
	Method Baixar()
	Method EstBaixa()
   Method Gravacao()
	Method InfoErro()

EndClass

/*
=====================================================================================
|Programa: ContaAPagar    |Autor: Wanderley R. Neto                |Data: 18/01/2019|
=====================================================================================
|Descri��o: Construtor, inicializa as propriedades                                  |
|                                                                                   |
=====================================================================================
*/
Method New(nOpc) Class ContaAPagar

_Super:New()
::nOpcao		:= nOpc
::lPaMovBco	:= .F.

Return Self


/*
=====================================================================================
|Programa: ContaAPagar    |Autor: Wanderley R. Neto                |Data: 18/01/2019|
=====================================================================================
|Descri��o: Adiciona informa��es ao array que ser� utilizado no execAuto para       |
| intera��o do t�tulo                                                               |
=====================================================================================
*/
Method AddCampo(cCampo, xValor) Class ContaAPagar

_Super:AddCabec(cCampo, xValor)

Return Nil          

/*
=====================================================================================
|Programa: cContaAPagar    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Realiza grava��o do pedido                                              |
|                                                                                   |
=====================================================================================
*/
Method Gravacao() Class ContaAPagar

Local lRetorno		:= .T.

Private	lMsErroAuto	:= .F.

::cErro := ''

/*
// CAMPOS OBRIGATORIOS PARA EXECAUTO
			{"E2_NUM"		,cNum		,Nil},;
			{"E2_PREFIXO"	,cPrefixo	,Nil},;
			{"E2_PARCELA"	,cParc		,Nil},;
			{"E2_TIPO"		,cTipo		,Nil},; 
			{"E2_NATUREZ"	,cNaturez	,Nil},;
			{"E2_FORNECE"	,cFornec	,Nil},; 
			{"E2_LOJA"		,cLoja		,Nil},; 
			{"E2_EMISSAO"	,dDataBase	,NIL},;
			{"E2_VENCTO"	,dDataBase	,NIL},;
			{"E2_VENCREA"	,dDataBase	,NIL},;
			{"E2_VALOR"		,1100		,Nil}}
*/

//Gravacao do Titulo de Contas a Pagar
MSExecAuto({|x,y,z| Fina050(x,y,z)},::aCabec,,::nOpcao,,,,,,,,::lPaMovBco)
	
If lMsErroAuto
	//TODO: Indicar caminho para log do MostraErro
	lRetorno := .F.
	::cErro := MostraErro()                                              

EndIf
	
	
Return lRetorno          

/*
=====================================================================================
|Programa: cContaAPagar    |Autor: Wanderley R. Neto               |Data: 18/01/2019|
=====================================================================================
|Descri��o: Realiza a baixa do t�tulo.                                              |
|                                                                                   |
=====================================================================================
*/
Method Baixar() Class ContaAPagar

/* Implementa��o da baixa a Pagar do t�tulo. */

Return ::Self

/*
=====================================================================================
|Programa: ContaAPagar    |Autor: Wanderley R. Neto                |Data: 18/01/2019|
=====================================================================================
|Descri��o: MEtodo para estornar a baixa do t�tulo.                                 |
|                                                                                   |
=====================================================================================
*/
Method EstBaixa() Class ContaAPagar

/* Implementa��o do estorno da baixa a Pagar do t�tulo. */

Return ::Self

/*
=====================================================================================
|Programa: xCtasAPagar    |Autor: Wanderley R. Neto                |Data: 26/01/2019|
=====================================================================================
|Descri��o: Retorna a mensagem de erro ap�s algum procedimento                      |
|                                                                                   |
=====================================================================================
*/
Method InfoErro() Class ContaAPagar
Return ::cErro