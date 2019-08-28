#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"

User Function PedVenda()
Return Nil

/*
=====================================================================================
|Programa: cPedVenda    |Autor: Wanderley R. Neto                  |Data: 18/01/2019|
=====================================================================================
|Descri��o: Classe respos�vel pela gera��o e libera��o do pedido de vendas.         |
|                                                                                   |
=====================================================================================
*/
Class PedVenda From ExecAuto

	Data cNumPed 
	Data cFilOri
	Data nOpcao
	Data cErro
	
   Method New(cPedido,cFilOri,nOpc) Constructor
	Method GetNumPedido()
	Method AddCabec(cCampo, xValor)
	Method AddCampoItem(cCampo, xValor)
	Method AddItem()
	Method Liberar()
	Method EstLib()
   Method Gravacao(nOpcao)
	Method InfoErro()

EndClass

/*
=====================================================================================
|Programa: PedVenda    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Construtor, inicializa as propriedades                                  |
|                                                                                   |
=====================================================================================
*/
Method New(cPedido,cFilOri,nOpc) Class PedVenda
	
Default cPedido	:= ''
Default cFilial	:= ''

_Super:New()
	
::cNumPed	:= cPedido
::cFilOri	:= cFilial
::nOpcao		:= nOpc

Return Self

/*
=====================================================================================
|Programa: PedVenda    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Retorna numero do pedido gerado                                         |
|                                                                                   |
=====================================================================================
|CONTROLE DE ALTERA��ES:                                                            |
=====================================================================================
|Programador          |Data       |Descri��o                                        |
=====================================================================================
|                     |           |                                                 |
=====================================================================================
*/
MEthod GetNumPedido() Class PedVenda

Return ::cNumPed

/*
=====================================================================================
|Programa: PedVenda    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Adiciona informa��es ao cabe�alho do pedido de venda                    |
|                                                                                   |
=====================================================================================
*/
Method AddCabec(cCampo, xValor) Class PedVenda

_Super:AddCabec(cCampo, xValor)

Do Case

	Case AllTrim(cCampo) == 'C5_NUM' 
		::cNumPed := xValor

	Case AllTrim(cCampo) == 'C5_FILIAL'
		::cFilOri := xValor

EndCase

Return Nil         

/*
=====================================================================================
|Programa: PedVenda    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Adiciona informa��es ao item do pedido de venda                         |
|                                                                                   |
=====================================================================================
*/
Method AddItem() Class PedVenda

_Super:AddItem()

Return Nil      

/*
=====================================================================================
|Programa: PedVenda    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Adiciona informa��es ao item do pedido de venda                         |
|                                                                                   |
=====================================================================================
*/
Method AddCampoItem(cCampo, xValor) Class PedVenda

_Super:AddCampoItem(cCampo, xValor)


Return Nil      

/*
=====================================================================================
|Programa: cPedVenda    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Realiza grava��o do pedido                                              |
|                                                                                   |
=====================================================================================
*/
Method Gravacao() Class PedVenda

Local lRetorno		:= .T.

Private	lMsErroAuto	:= .F.

::cErro := ''

//TODO: Obter Numero do pedido e gravar na propriedade ::cNumPed
If Empty(::cNumPed)
	::cNumPed := GetSXENum("SC5","C5_NUM")
	::AddCabec('C5_NUM', ::cNumPed)
EndIf

//Gravacao do Pedido de vendas
MsExecAuto({|a, b, c| MATA410(a, b, c)}, ::aCabec, ::aItens, ::nOpcao)
	
If lMsErroAuto

	lRetorno := .F.
	::cErro := MostraErro()                                              

EndIf
	
	
Return lRetorno          

/*
=====================================================================================
|Programa: cPedVenda    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: Realiza libera��o do pedido de acordo com rotia padr�o                  |
|                                                                                   |
=====================================================================================
*/
Method Liberar() Class PedVenda

Private nQtdLib := 0

DbSelectArea("SC5")
SC5->(DbSetOrder(1))

DbSelectArea("SC6")
SC6->(DbSetOrder(1))

If SC5->(DbSeek(::cFilOri + ::cNumPed))

	If SC6->(DbSeek(SC5->C5_FILIAL + SC5->C5_NUM))

		While SC6->(! Eof());
				.And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

			If RecLock("SC5")
				nQtdLib  := SC6->C6_QTDVEN
				//������������������������������������������������������������������������Ŀ
				//�Recalcula a Quantidade Liberada                                         �
				//��������������������������������������������������������������������������
				RecLock("SC6") //Forca a atualizacao do Buffer no Top
				//������������������������������������������������������������������������Ŀ
				//�Libera por Item de Pedido                                               �
				//��������������������������������������������������������������������������
				Begin Transaction
					/*
					�������������������������������������������������������������������������Ŀ��
					���Funcao    �MaLibDoFat� Autor �Eduardo Riera          � Data �09.03.99  ���
					�������������������������������������������������������������������������Ĵ��
					���Descri��o �Liberacao dos Itens de Pedido de Venda                      ���
					�������������������������������������������������������������������������Ĵ��
					���Retorno   �ExpN1: Quantidade Liberada                                  ���
					�������������������������������������������������������������������������Ĵ��
					���Transacao �Nao possui controle de Transacao a rotina chamadora deve    ���
					���          �controlar a Transacao e os Locks                            ���
					�������������������������������������������������������������������������Ĵ��
					���Parametros�ExpN1: Registro do SC6                                      ���
					���          �ExpN2: Quantidade a Liberar                                 ���
					���          �ExpL3: Bloqueio de Credito                                  ���
					���          �ExpL4: Bloqueio de Estoque                                  ���
					���          �ExpL5: Avaliacao de Credito                                 ���
					���          �ExpL6: Avaliacao de Estoque                                 ���
					���          �ExpL7: Permite Liberacao Parcial                            ���
					���          �ExpL8: Tranfere Locais automaticamente                      ���
					���          �ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ���
					���          �       apenas avalia ).                                     ���
					���          �ExpbA: CodBlock a ser avaliado na gravacao do SC9           ���
					���          �ExpAB: Array com Empenhos previamente escolhidos            ���
					���          �       (impede selecao dos empenhos pelas rotinas)          ���
					���          �ExpLC: Indica se apenas esta trocando lotes do SC9          ���
					���          �ExpND: Valor a ser adicionado ao limite de credito          ���
					���          �ExpNE: Quantidade a Liberar - segunda UM                    ���
					*/
					MaLibDoFat(SC6->(RecNo()), @nQtdLib, .F., .F., .F., .F., .F., .F.)
				End Transaction
			EndIf

			SC6->(MsUnLock())

			//������������������������������������������������������������������������Ŀ
			//�Atualiza o Flag do Pedido de Venda                                      �
			//��������������������������������������������������������������������������
			Begin Transaction
				SC6->(MaLiberOk({::cNumPed}, .F.))
			End Transaction
			
			
			SC6->(DbSkip())
		End
	EndIf
EndIf

Return ::Self

/*
=====================================================================================
|Programa: PedVenda    |Autor: Wanderley R. Neto                   |Data: 18/01/2019|
=====================================================================================
|Descri��o: MEtodo para estornar a libera��o do pedido                              |
|                                                                                   |
=====================================================================================
*/
Method EstLib(cNumPed) Class PedVenda

Local cFilSC6			:= xFilial('SC6')
Local cFilSC9			:= xFilial('SC9')

DbSelectArea("SC6")
SC6->(DbSetOrder(1))

DbSelectArea("SC9")
SC9->(DbSetOrder(1))

If SC6->(DbSeek(xFilial("SC6") + ::cNumPed))

	While SC6->(!Eof());
			.And. SC6->C6_FILIAL == cFilSC6;
			.And. SC6->C6_NUM == ::cNumPed;

		If SC9->(DbSeek(cFilSC9 + SC6->C6_NUM + SC6->C6_ITEM))
			A460Estorna()
		Endif

		SC6->(DbSkip())
	End

Endif

Return ::Self

Method InfoErro() Class PedVenda
Return ::cErro