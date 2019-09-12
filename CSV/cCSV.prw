#Include 'Protheus.ch'

/*
=====================================================================================
|Programa: cCSV        |Autor: Wanderley R. Neto                   |Data: 30/01/2019|
=====================================================================================
|Descri��o: Classe para importa��o de dados via arquivo CSV                         |
|                                                                                   |
=====================================================================================
*/
User Function cCsv()
Return Nil

Class ImpCSV 

	Data cArquivo
	Data nColunas
	Data nMaxColunas
	Data aColunas
	Data aDados
	Data cErro

	Method New( cPathArq ) Constructor
	Method SelArquivo()
	Method Importar()
	Method InfoErro()

EndClass

/*
=====================================================================================
|Programa: cCSV    |Autor: Wanderley R. Neto                   |Data: 30/01/2019|
=====================================================================================
|Descri��o: Instancia objeto para importa��o de dados via CSV                       |
|                                                                                   |
=====================================================================================
*/
Method New( cPathArq, nMaxColunas )  Class ImpCSV

Default cPathArq 		:= ''	
Default nMaxColunas	:= 999

	::cArquivo		:= cPathArq
	::nColunas		:= 0
	::nMaxColunas	:= nMaxColunas
	::aColunas		:= {}
	::aDados			:= {}
	::cErro			:= ''

Return Self


/*
=====================================================================================
|Programa: cCSV        |Autor: Wanderley R. Neto                   |Data: 30/01/2019|
=====================================================================================
|Descri��o: MEtodo que auxilia na sele��o de um arquivo para importa��o             |
|                                                                                   |
=====================================================================================
*/
Method SelArquivo() Class impCSV

Local cExtens			:= 'Arquivo Texto ( *.CSV ) |*.CSV|'
Local cTitle			:= 'Selecione arquivo' 
Local cFile				:= ''
Local lSucesso			:= .F.

	cFile := Alltrim(cGetFile(cExtens,cTitle,0,"", .T. ,, .F.))

	// ----------------------------------------------------------------------------
	// Verifica existencia do arquivo
	// ----------------------------------------------------------------------------
	lSucesso := File(cFile)


	If lSucesso

		::cArquivo := cFile
	
	Else

		::cErro := "Arquivo inexistente."+CRLF+"Verifique o diret�rio informado e tente novamente."

	EndIf  

Return lSucesso

/*
=====================================================================================
|Programa: cCSV        |Autor: Wanderley R. Neto                   |Data: 30/01/2019|
=====================================================================================
|Descri��o: MEtodo que realiza a leitura do arquivo CSV e monta os arrays para      |
| devolu��o ao usu�rio.                                                             |
=====================================================================================
*/
Method Importar() Class ImpCSV

Local cLinha			:= ''
Local nLinha			:= 0
Local lREt				:= .T.

	If !Empty(::cArquivo)
		FT_FUse(::cArquivo)  

		ProcRegua( FT_FLastRec() )
		FT_FGoTop()
		

		// ----------------------------------------------------------------------------
		// Varrendo arquivo e guardando informa��es
		// ----------------------------------------------------------------------------
		While !FT_FEOF()

			nLinha++
			
			// Lendo linhas do CSV
			cLinha := FT_FReadLn()

			aLinha := StrToKArr2(cLinha,';',.T.)
			cLinha := ''
			
			If Len(aLinha) > ::nMaxColunas

				::cErro := "Registro do arquivo '"+::cArquivo+"' inv�lido."+CRLF;
								+" Favor verificar a linha '"+cValToChar(nLinha)+"' do arquivo e tentar novamente."

				Return .F.

			EndIf
			
			If nLinha == 1

				// Adicionando informa��es do cabe�alho
				::aColunas := aLinha
				aLinha := {}
			
			Else

				// Adicionando no array de dados
				AAdd(::aDados,aLinha)
				aLinha := {}

			EndIf

			FT_FSKIP()
		End
	Else	
		::cErro := "Arquivo n�o informado"
		lRet := .F.
	EndIf
	
Return lREt

/*
=====================================================================================
|Programa: cCSV    |Autor: Wanderley R. Neto                   |Data: 30/01/2019|
=====================================================================================
|Descri��o: Retorna erro ao usu�rio                                                 |
|                                                                                   |
=====================================================================================
*/
Method InfoErro() Class ImpCSV
Return ::cErro