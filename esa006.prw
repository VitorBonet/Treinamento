#INCLUDE "ESA006.CH"
#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA005
Programa de Cadastro de Alunos de Turmas

@author  Vitor Bonet
@since   08/03/2018
@source  Generico
/*/
//-------------------------------------------------------------------
Function ESA006()

	// Armazena variaveis p/ devolucao (NGRIGHTCLICK)
	Private aRotina := MenuDef()
	Private cCadastro := OemtoAnsi("Disciplinas") //"Especialidades"
	Private aCHKDEL   := {}

	// aCHKDEL array que verifica a INTEGRIDADE REFERENCIAL na exclusão do registro.
	// 1 - Chave de pesquisa
	// 2 - Alias de pesquisa
	// 3 - Ordem de pesquisa

	//aCHKDEL := { {'ZZ4->ZZ5_TURMA'    , "ZZ6", 3}}

	DbSelectArea("ZZ6")
	DbSetOrder(1)
	mBrowse( 6, 1,22,75,"ZZ6")

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
/*/{Protheus.doc} ESA001VLD
Validação de campos

@author Vitor Bonet.
@since 12/03/2018
@version P12
@return lValid
/*/
//------------------------------------------------------------------------------
Function ESA006VLD()

	//variaveis de retorno
	Local lValid := .T.

	// Campo a ser validado
	Local cField := ReadVar()

	// ZZ6_TURMA - Turma
	If 'ZZ6_TURMA' $ cField

		If !Existcpo("ZZ4",M->ZZ6_TURMA)
			lValid := .F.
			MsgAlert("Essa turma não existe!")
		Else
			M->ZZ6_DESCT := Posicione("ZZ4",1,xFilial("ZZ4")+M->ZZ6_TURMA,"ZZ4_DESCT")
			M->ZZ6_ANO   := Posicione("ZZ4",1,xFilial("ZZ4")+M->ZZ6_TURMA,"ZZ4_ANO")
		EndIf

	// ZZ6_CODMAT - Código da Matéria
	ElseIf 'ZZ6_CODMAT' $ cField

		If !Existcpo("ZZ3",M->ZZ6_CODMAT)
			lValid := .F.
			MsgAlert("Essa matéria não existe!")
		Else
				M->ZZ6_DESCM := POSICIONE("ZZ3",1,XFILIAL("ZZ3")+M->ZZ6_CODMAT,"ZZ3_DESCRI")
		EndIf

	// ZZ6_MAT - matricula do professor
	ElseIf 'ZZ6_MAT' $ cField

		If !Existcpo("ZZ1",M->ZZ6_MAT)
			lValid := .F.
			MsgAlert("Essa matricula não existe!")
		Else
				M->ZZ6_NOMEP := POSICIONE("ZZ1",1,XFILIAL("ZZ1")+M->ZZ6_MAT,"ZZ1_NOME")
		EndIf

	EndIf

Return lValid

