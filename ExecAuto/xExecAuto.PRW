#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"

User Function ExecAuto()
Return Nil

/*
=====================================================================================
|Programa: ExecAuto    |Autor: Wanderley R. Neto                   |Data: 16/01/2019|
=====================================================================================
|Descri��o: Classe responsavel pela execu��o de um ExecAuto gen�rico                |
|                                                                                   |
=====================================================================================
|CONTROLE DE ALTERA��ES:                                                            |
=====================================================================================
|Programador          |Data       |Descri��o                                        |
=====================================================================================
|                     |           |                                                 |
=====================================================================================
*/

Class ExecAuto

	Data aCabec								//Dados do Cabecalho
	Data aItens								//Dados dos Itens
	Data aItemTemp								//Dados dos Itens
	Data Erro							//Mensagem de Erro

	Method New() Constructor			//Inializacao do Objeto
	Method AddCabec(cCampo, xValor)	//Adicona dados ao Cabecalho
	Method AddItem()						//Adiciona array temporario ao Item
	Method AddCampoItem(cCampo, xValor)	//Adiciona dados ao Item
	Method GetInfo()						//Retorno das Mensagens de Erro

EndClass

/*
=====================================================================================
|Programa: ExecAuto    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Construtor: inicia as propriedades                                      |
|                                                                                   |
=====================================================================================
*/
Method New() Class ExecAuto

	::aCabec		:= {}
	::aItens		:= {}
	::aItemTemp		:= {}
	::Erro		:= ""

Return Self

/*
=====================================================================================
|Programa: ExecAuto    |Autor: Wanderley R. Neto                   |Data: 16/01/2019|
=====================================================================================
|Descri��o: Insere informa��es do cabe�alho                                         |
|                                                                                   |
=====================================================================================
*/
Method AddCabec(cCampo, xValor) Class ExecAuto
Local nPosCpo := Ascan(::aCabec, {|x| x[01] == cCampo})	

If !Empty(xValor)

	If nPosCpo == 0
		Aadd(::aCabec, {cCampo, xValor, NIL})
	Else
		::aCabec[nPosCpo][02] := xValor
	EndIf

EndIf

Return ::Self

/*
=====================================================================================
|Programa: ExecAuto    |Autor: Wanderley R. Neto                   |Data: 16/01/2019|
=====================================================================================
|Descri��o: Insere informa��es no array de itens                                    |
|                                                                                   |
=====================================================================================
*/
Method AddCampoItem(cCampo, xValor) Class ExecAuto

Local nPosCpo := Ascan(::aItemTemp, {|x| x[01] == cCampo})

If !Empty(xValor)

	If nPosCpo == 0
		Aadd(::aItemTemp, {cCampo, xValor, NIL})
	Else
		::aItemTemp[nPosCpo][02] := xValor
	EndIf

EndIf

Return ::Self

/*
=====================================================================================
|Programa: ExecAuto    |Autor: Wanderley R. Neto                   |Data: 16/01/2019|
=====================================================================================
|Descri��o: Insere informa��es no array de itens                                    |
|                                                                                   |
=====================================================================================
*/
Method AddItem() Class ExecAuto


	Aadd(::aItens,::aItemTemp)
	::aItemTemp := {}

Return ::Self

/*
=====================================================================================
|Programa: cExecAuto    |Autor: Wanderley R. Neto                  |Data: 18/01/2019|
=====================================================================================
|Descri��o: Exibe mensagem retornada pela rotina de ExecAuto executada              |
|                                                                                   |
=====================================================================================
*/
Method GetInfo() Class ExecAuto

Return ::cMensagem
