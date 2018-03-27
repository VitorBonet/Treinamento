#INCLUDE "ESA005.CH"
#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA005
Programa de Cadastro de Alunos de Turmas

@author  Vitor Bonet
@since   08/03/2018
@source  Generico
/*/
//-------------------------------------------------------------------
Function ESA005()

	// Armazena variaveis p/ devolucao (NGRIGHTCLICK)
	Private aRotina := MenuDef()
	Private cCadastro := OemtoAnsi("Turmas") //"Especialidades"
	Private aCHKDEL   := {}

	// aCHKDEL array que verifica a INTEGRIDADE REFERENCIAL na exclusão do registro.
	// 1 - Chave de pesquisa
	// 2 - Alias de pesquisa
	// 3 - Ordem de pesquisa

	//aCHKDEL := { {'ZZ4->ZZ5_TURMA'    , "ZZ6", 3}}

	DbSelectArea("ZZ4")
	DbSetOrder(1)
	mBrowse( 6, 1,22,75,"ZZ4")

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
                {"Alunos", "ESA005ALU"   , 0 , 4}} 	//"Alunos"
Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA005ALU
Cadastro de alunos na turma
@author  Vitor de Sousa Bonet
@since   12/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function ESA005ALU()

	Local aOldRot  := aClone(aRotina)
	Local aOldArea := GetArea()

	aRotina := {{STR0001, "AxPesqui"  , 0 , 1},;    //"Pesquisar"
                {STR0002, "NGCAD01"   , 0 , 2},;    //"Visualizar"
                {STR0003, "NGCAD01"   , 0 , 3},;    //"Incluir"
                {STR0004, "NGCAD01"   , 0 , 4},;    //"Alterar"
                {STR0005, "NGCAD01"   , 0 , 5, 3} } //"Excluir"

	//Define o cabecalho da tela de atualizacoes
	Private cCadastro  := OemtoAnsi("Alunos da Turma") //"Alunos da Turma"
	Private aIndZZ5    := {}
	Private bFiltraBrw := {|| Nil}

	dbSelectArea("ZZ5")
	dbSetOrder(2)

	cCondZZ5   := 'ZZ5_FILIAL == "'+xFILIAL("ZZ4")+'" .And. ZZ5_TURMA == ZZ4->ZZ4_TURMA'
	bFiltraBrw := {|| FilBrowse("ZZ5",@aIndZZ5,@cCondZZ5)}
	Eval(bFiltraBrw)

	mBrowse( 6, 1,22,75,"ZZ5")

	aEval(aIndZZ5,{|x| Ferase(x[1]+OrdBagExt())})
	ENDFILBRW("ZZ5",aIndZZ5)

	aRotina := aClone(aOldRot)
	RestArea(aOldArea)

Return .T.

//------------------------------------------------------------------------------
/*/{Protheus.doc} ESA001VLD
Validação de campos

@author Vitor Bonet.
@since 12/03/2018
@version P12
@return lValid
/*/
//------------------------------------------------------------------------------
Function ESA005VLD()

	//variaveis de retorno
	Local lValid := .T.

	// Campo a ser validado
	Local cField := ReadVar()

	// ZZ5_MATAL - Matricula
	If 'ZZ5_MATAL' $ cField

		If !Existcpo("ZZ2", M->ZZ5_MATAL)
			lValid := .F.
			MsgAlert("Esta matricula não existe!")
		Else
			M->ZZ5_NOMEAL := posicione("ZZ2",1,xFilial("ZZ2")+M->ZZ5_MATAL,"ZZ2_NOME")
		EndIf
	EndIf

Return lValid

