#INCLUDE "ESA004.CH"
#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA004
Programa de Cadastro de Turmas

@author  Vitor Bonet
@since   08/03/2018
@source  Generico
/*/
//-------------------------------------------------------------------
Function ESA004()

	// Armazena variaveis p/ devolucao (NGRIGHTCLICK)
	Private aRotina := MenuDef()
	Private cCadastro := OemtoAnsi("Turmas") //"Especialidades"
	Private aCHKDEL   := {}

	// aCHKDEL array que verifica a INTEGRIDADE REFERENCIAL na exclusão do registro.
	// 1 - Chave de pesquisa
	// 2 - Alias de pesquisa
	// 3 - Ordem de pesquisa
	aCHKDEL := { {'ZZ4->ZZ4_TURMA', "ZZ5", 3}}

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
                {STR0003, "NGCAD01"   , 0 , 3},;    //"Incluir"
                {STR0004, "NGCAD01"   , 0 , 4},;    //"Alterar"
                {STR0005, "NGCAD01"   , 0 , 5, 3} } //"Excluir"
Return aRotina
