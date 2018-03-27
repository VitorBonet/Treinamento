#INCLUDE "ESA001.CH"
#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA001
Programa de Cadastro de professores

@author  Vitor Bonet
@since   07/03/2018
@source  Generico
/*/
//-------------------------------------------------------------------
Function ESA001()

	// Armazena variaveis p/ devolucao (NGRIGHTCLICK)
	Private aRotina := MenuDef()
	Private cCadastro := OemtoAnsi("Professores") //"Especialidades"
	Private aCHKDEL   := {}
	Private bNGGRAVA  := {|| fValidFim()}

	// aCHKDEL array que verifica a INTEGRIDADE REFERENCIAL na exclus�o do registro.
	// 1 - Chave de pesquisa
	// 2 - Alias de pesquisa
	// 3 - Ordem de pesquisa

	aCHKDEL := { {'ZZ1->ZZ1_MAT', "ZZ6", 5}}

	DbSelectArea("ZZ1")
	DbSetOrder(1)
	mBrowse( 6, 1,22,75,"ZZ1")

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} �MenuDef
Utilizacao de menu Funcional
@author  Ricardo Dal Ponte
@since   29/11/2006
@source  Generico
Parametros do array aRotina:
	1. Nome a aparecer no cabe�alho
	2. Nome da Rotina associada
	3. Reservado
	4. Tipo de Transa��o a ser efetuada:
		1 - Pesquisa e Posiciona em um Banco de Dados
		2 - Simplesmente Mostra os Campos
		3 - Inclui registros no Bancos de Dados
		4 - Altera o registro corrente
		5 - Remove o registro corrente do Banco de Dados
	5. Nivel de acesso
	6. Habilita Menu Funcional
/*/
//-------------------------------------------------------------------
Static Function MenuDef()

 	aRotina := {{STR0001, "AxPesqui"  , 0 , 1},;    //"Pesquisar"
                {STR0002, "NGCAD01"   , 0 , 2},;    //"Visualizar"
                {STR0003, "NGCAD01"   , 0 , 3},;    //"Incluir"
                {STR0004, "NGCAD01"   , 0 , 4},;    //"Alterar"
                {STR0005, "NGCAD01"   , 0 , 5, 3} } //"Excluir"
Return aRotina


//------------------------------------------------------------------------------
/*/{Protheus.doc} ESA001VLD
Valida��o de campos

@author Vitor Bonet.
@since 07/03/2018
@version P12
@return lValid
/*/
//------------------------------------------------------------------------------
Function ESA001VLD(cField, dDtAdmi, dDtNasc, dDtDemi,nSituac)

	//variaveis de retorno
	Local lValid := .T.
	Local lMod2  := IsInCallStack("ESA008")

	//se vier vazio usa variaveis de memoria
	Default cField	:= ReadVar()
	Default dDtAdmi := M->ZZ1_DTADMI
	Default dDtNasc := M->ZZ1_DTNASC
	Default dDtDemi := M->ZZ1_DTDEMI
	Default nSituac := M->ZZ1_SITUAC

	// ZZ1_DTNASC - Data de Nascimento
	If 'ZZ1_DTNASC' $ cField

		//verifica se a Data de Nascimento � menor que a Data de Admiss�o
		IF !Empty(dDtAdmi) .And. !Empty(dDtNasc) .And. dDtNasc > dDtAdmi
			lValid := .F.
			MsgAlert("Data de Nascimento deve ser menor que a Data de Admiss�o")

		//verifica se a idade � permitida
		ElseIf !Empty(dDtNasc) .And. !Empty(dDtAdmi) .And. !VaIdaAdm(dDtNasc,dDtAdmi)
			lValid := .F.
			MsgAlert("Idade n�o permitida para contrata��o.")

		EndIf

	// ZZ1_DTADMI - Data de Admiss�o
	ElseIf 'ZZ1_DTADMI' $ cField

		//verifica se a Data de Nascimento � menor que a Data de Admiss�o
		If !Empty(dDtNasc) .And. !Empty(dDtAdmi) .And. dDtNasc > dDtAdmi
			lValid := .F.
			MsgAlert("Data de Admiss�o deve ser maior que a Data de Nascimento")

		//verifica se a Data de Demiss�o � menor que a Data de Admiss�o
		ElseIf !Empty(dDtDemi) .And. !Empty(dDtAdmi) .And. dDtAdmi > dDtDemi
			lValid := .F.
			MsgAlert("Data de Admiss�o deve ser menor que a Data de Demiss�o")

		//verifica se a idade � permitida
		ElseIf !Empty(dDtNasc) .And. !Empty(dDtAdmi) .And. !VaIdaAdm(dDtNasc,dDtAdmi)
			lValid := .F.
			MsgAlert("Idade n�o permitida para contrata��o.")

		EndIf

	// ZZ1_DTDEMI - Data de Demiss�o
	ElseIf 'ZZ1_DTDEMI' $ cField

		//verifica se a Data de Demiss�o � maior que a Data de Admiss�o
		If !Empty(dDtDemi) .And. !Empty(dDtAdmi) .And. dDtAdmi > dDtDemi
			lValid := .F.
			MsgAlert("Data de Demiss�o deve ser maior que a Data de Admiss�o")

		Else

			// se existe data de demiss�o, fecha o campo situa��o e o declara como 2=Demitido
			If !Empty(dDtDemi)

				If lMod2
					cCombo := "2"
				Else
					M->ZZ1_SITUAC := "2"
				EndIf

			// se nao existe data de demiss�o, libera o campo situa��o
			ElseIf cValToChar(nSituac) == "2"

				If lMod2
					cCombo := " "
				Else
					M->ZZ1_SITUAC := " "
				EndIf

			EndIf
		EndIf
	EndIf

Return lValid

//-------------------------------------------------------------------
/*/{Protheus.doc} fValidFim
Valida os campos para liberar o cadastro
@author  Vitor Bonet
@since   08/03/2018
@return lRet = L - Retorna se todas as condi��es est�o corretas para o cadastro
/*/
//-------------------------------------------------------------------
Function fValidFim()

	Local lRet := .T.

	If Empty(M->ZZ1_DTDEMI) .And. M->ZZ1_SITUAC == "2"

		MsgStop("Campo Data de Demiss�o � obrigat�rio se situa��o � declarada como Demitido","Aten��o")

		lRet := .F.

	EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} VaIdaAdm
Valida a idade em que foi contr�tado. (deve ter mais que 13 anos de idadde)
@author  Vitor Bonet
@since   16/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function VaIdaAdm(dDtNasc, dDtAdmi)

	Local lValid := .T.
	Local nIdade := Year(dDtAdmi) - Year(dDtNasc)

	If nIdade <= 13
		lValid := .F.
	EndIf

Return lValid