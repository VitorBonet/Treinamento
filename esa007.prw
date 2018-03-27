#INCLUDE "ESA007.CH"
#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA005
Programa de Cadastro de Alunos de Turmas

@author  Vitor Bonet
@since   08/03/2018
@source  Generico
/*/
//-------------------------------------------------------------------
Function ESA007()

	// Armazena variaveis p/ devolucao (NGRIGHTCLICK)
	Private aRotina := MenuDef()
	Private cCadastro := OemtoAnsi("Disciplinas") //"Especialidades"
	Private aCHKDEL   := {}

	// aCHKDEL array que verifica a INTEGRIDADE REFERENCIAL na exclusão do registro.
	// 1 - Chave de pesquisa
	// 2 - Alias de pesquisa
	// 3 - Ordem de pesquisa

	//aCHKDEL := { {'ZZ4->ZZ5_TURMA'    , "ZZ6", 3}}

	DbSelectArea("ZZ7")
	DbSetOrder(1)
	mBrowse( 6, 1,22,75,"ZZ7")

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} ³MenuDef
Utilizacao de menu Funcional
@author  Ricardo Dal Ponte
@since   29/11/2006
@source  Generico
Parametros do array aRotina:
	1. Nome a aparecer no cabeçalho
	2. Nome da Rotina associada
	3. Reservado
	4. Tipo de Transação a ser efetuada:
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
/*/{Protheus.doc} ESA007VLD
Validação de campos

@author Vitor Bonet.
@since 12/03/2018
@version P12
@return lValid
/*/
//------------------------------------------------------------------------------
Function ESA007VLD()

	//variaveis de retorno
	Local lValid := .T.

	// Campo a ser validado
	Local cField := ReadVar()

	// ZZ7_NOTA - Nota Ou ZB7_NOTA - Nota
	If 'ZZ7_NOTA' $ cField .Or. 'ZB7_NOTA' $ cField

		If !Empty(&(cField)) .And. &(cField) < 0 .Or. &(cField) > 10
			lValid := .F.
			MsgAlert("A nota deve ser entre 0 e 10!")
		Else

		EndIf

	EndIf


Return lValid

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA007INI
Pega os dados para iniciação padrao dos campos
@author  Vitor Bonet
@since   19/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function ESA007INI(cCampo)

	//retorno
	Local cDescricao := ""

	// ZZ7_DESCT - Descrição da Turma
	If 'ZZ7_DESCT' $ cCampo

		dbSelectArea("ZZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZ6") + ZZ7->ZZ7_DISC)

			dbSelectArea("ZZ4")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZ4") + ZZ6->ZZ6_TURMA)
				cDescricao := ZZ4->ZZ4_DESCT
			EndIf

		EndIf

	// ZZ7_DESCM - Descrção da Matéria
	ElseIf 'ZZ7_DESCM' $ cCampo

		dbSelectArea("ZZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZ6") + ZZ7->ZZ7_DISC)

			dbSelectArea("ZZ3")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZ3") + ZZ6->ZZ6_CODMAT)
				cDescricao := ZZ3->ZZ3_DESCRI
			EndIf
		EndIf

	// ZZ7_NOMEP - Nome do Professor
	ElseIf 'ZZ7_NOMEP' $ cCampo

		dbSelectArea("ZZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZ6") + ZZ7->ZZ7_DISC)

			dbSelectArea("ZZ1")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZ1") + ZZ6->ZZ6_MAT)
				cDescricao := ZZ1->ZZ1_NOME
			EndIf

		EndIf

	EndIf

Return cDescricao

