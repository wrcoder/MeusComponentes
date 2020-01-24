#Include 'Protheus.ch'
#Include 'Ap5Mail.ch'

User Function emailNotif();Return

/*
=====================================================================================
|Programa: uEmailNotif    |Autor: Wanderley R. Neto                |Data: 26/09/2019|
=====================================================================================
|Descri��o: Componente para disparar notifica��es por email                         |
|                                                                                   |
=====================================================================================
|CONTROLE DE ALTERA��ES:                                                            |
=====================================================================================
|Programador          |Data       |Descri��o                                        |
=====================================================================================
|                     |           |                                                 |
=====================================================================================
*/
Class EmailNotif 
	Data cTo
	Data cAss
	Data cBody
	Data cErrorMsg
	Data cAttach

	Method New(cTo, cAss, cBody) Constructor
	Method Anexar()
	Method Enviar()
EndClass

/*
=====================================================================================
|Programa: uEmailNotif  |Autor: Wanderley R. Neto                  |Data: 26/09/2019|
=====================================================================================
|Descri��o: Instancia compoente e define valores iniciais                           |
|                                                                                   |
=====================================================================================
*/
Method New( cTo, cAss, cBody ) Class EmailNotif

	::cTo		:= cTo
	::cAss		:= cAss
	::cBody		:= cBody
	::cAttach	:= ''
	::cErrorMsg	:= ''

Return Self

/*
=====================================================================================
|Programa: uEmailNotif  |Autor: Wanderley R. Neto                  |Data: 26/09/2019|
=====================================================================================
|Descri��o: Guarda os arquivos que ser�o anexados no email                          |
|                                                                                   |
=====================================================================================
*/
Method Anexar( cAnexo ) Class EmailNotif

	::cAttach := cAnexo

Return Self

/*
=====================================================================================
|Programa: uEmailNotif  |Autor: Wanderley R. Neto                  |Data: 26/09/2019|
=====================================================================================
|Descri��o: Metodo que busca informa��es de servidor SMTP e dispara o email de notif|
| de acordo com os dados informados.                                                |
=====================================================================================
*/
Method Enviar() Class EMailNotif

Local lCont 			:= .T.
Local lConect			:= .F.
Local lAuth				:= .F.
Local lRelauth			:= SuperGetMv('MV_RELAUTH',,.F.)
Local cServer			:= AllTrim(SuperGetMv('MV_RELSERV',,''))
Local cFrom				:= AllTrim(SuperGetMV('MV_RELACNT',,''))
Local cPswd				:= AllTrim(SuperGetMv('MV_RELPSW',,''))
Local cBody				:= ''
Local cError			:= ''
Local lSucesso			:= .T.

	If Empty(cServer);
			.Or. Empty(cFrom);
			.Or. Empty(cPswd)

		::cErrorMsg := 'MAILNOTIF'+' - '+DToC(dDataBase)+' '+Time()+'| Parametros para o envio de email inv�lidos. Verifique os parametros: '+CRLF;
				+'"MV_RELSERV";'+CRLF;
				+'"MV_RELACNT";'+CRLF;
				+'"MV_RELAUTH";'+CRLF;
				+'"MV_RELPSW"'

		Conout(::cErrorMsg)
		lSucesso	:= .F.
		lCont := .F.

	EndIf


	If lCont	

		Conout('MAILNOTIF'+' - '+DToC(dDataBase)+' '+Time()+'| Iniciando conex�o: '+cServer)

		// Conecta o server SMTP
		CONNECT SMTP SERVER cServer ACCOUNT cFrom PASSWORD cPswd RESULT lConect
		
		// Se conectou corretamente
		If lConect

			Conout('MAILNOTIF'+' - '+DToC(dDataBase)+' '+Time()+'| Conectado no servidor SMTP: ' + cServer)

			// Se existe autenticacao para envio valida pela funcao MAILAUTH
			If lRelauth
				lAuth := Mailauth( cFrom, cPswd )
			Else
				lAuth := .T.
			Endif

			If lAuth
				
				// Autenticado
				Conout('MAILNOTIF'+' - '+DToC(dDataBase)+' '+Time()+'| Autenticado com o usuario: ' + cFrom)

				SEND MAIL; 
				FROM 		cFrom;
				TO      	::cTo;
				SUBJECT 	::cAss;
				BODY    	::cBody;
				ATTACHMENT	::cAttach;
				RESULT 	lResult

				If lResult

					// Enviado com Sucesso
					Conout('MAILNOTIF'+' - '+DToC(dDataBase)+' '+Time()+'| Email enviado com sucesso')

				Else

					//Erro no envio do email
					GET MAIL ERROR cError

					::cErrorMsg := 'MAILNOTIF'+' - '+DToC(dDataBase)+' '+Time()+'| ATEN��O - Erro no envio do email'+CRLF;
							+cError
					
					Conout(::cErrorMsg)
					lSucesso	:= .F.

				EndIf

			Else

				// Nao Autenticado
				GET MAIL ERROR cError

				::cErrorMsg := 'MAILNOTIF'+' - '+DToC(dDataBase)+' '+Time()+'| ATEN��O - Erro de autentica��o.';
						+'Verifique usuario e senha.'+CRLF;
						+cError

				Conout(::cErrorMsg)
				lSucesso	:= .F.

			Endif

			// Desconecta do server SMTP
			DISCONNECT SMTP SERVER

		Else

			//Erro na conexao com o SMTP Server
			GET MAIL ERROR cError

			::cErrorMsg := 'MAILNOTIF'+' - '+DToC(dDataBase)+' '+Time()+'| ATEN��O - Erro durante conex�o com SMTP Server'+CRLF;
					+cError

			Conout(::cErrorMsg)
			lSucesso	:= .F.

		EndIf

	EndIf

Return lSucesso
