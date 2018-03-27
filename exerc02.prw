#Include 'MNTA016.ch'
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//---------------------------------------------------------------------
/*/{Protheus.doc} EXERC02
Cadastro de Alunos
@author Vitor de Sousa Bonet
@since 22/03/2018
@version p12
@return Nil, Nulo
/*/
//---------------------------------------------------------------------
Function EXERC02()

	Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
	Local oBrowse
	Local aNGBEGINPRM := NGBEGINPRM()

    SetFunName("EXERC02")

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZB2")         // Alias da tabela utilizada
	oBrowse:SetMenuDef("EXERC02")   // Nome do fonte onde est� a fun��o MenuDef
	oBrowse:SetDescription("Alunos") // Descri��o do browse ## "Etapas Gen�ricas"
	oBrowse:Activate()

	NGRETURNPRM(aNGBEGINPRM)

	SetFunName(cFunBkp)
    RestArea(aArea)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Op��es de menu

@author Pedro Henrique Soares de Souza
@since 13/05/2014
@version P11/P12
@return aRotina - Estrutura
	[n,1] Nome a aparecer no cabecalho
	[n,2] Nome da Rotina associada
	[n,3] Reservado
	[n,4] Tipo de Transa��o a ser efetuada:
		1 - Pesquisa e Posiciona em um Banco de Dados
		2 - Simplesmente Mostra os Campos
		3 - Inclui registros no Bancos de Dados
		4 - Altera o registro corrente
		5 - Remove o registro corrente do Banco de Dados
		6 - Altera��o sem inclus�o de registros
		7 - C�pia
		8 - Imprimir
	[n,5] Nivel de acesso
	[n,6] Habilita Menu Funcional
/*/
//---------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE STR0004 ACTION 'PesqBrw'           OPERATION 1  ACCESS 0 // 'Pesquisar'
	ADD OPTION aRotina TITLE STR0005 ACTION 'VIEWDEF.EXERC02'   OPERATION 2  ACCESS 0 // 'Visualizar'
	ADD OPTION aRotina TITLE STR0006 ACTION 'VIEWDEF.EXERC02'   OPERATION 3  ACCESS 0 // 'Incluir'
	ADD OPTION aRotina TITLE STR0007 ACTION 'VIEWDEF.EXERC02'   OPERATION 4  ACCESS 0 // 'Alterar'
	ADD OPTION aRotina TITLE STR0008 ACTION 'VIEWDEF.EXERC02'   OPERATION 5  ACCESS 0 // 'Excluir'
	ADD OPTION aRotina TITLE STR0009 ACTION 'VIEWDEF.EXERC02'   OPERATION 8  ACCESS 0 // 'Imprimir'
	ADD OPTION aRotina TITLE STR0010 ACTION 'VIEWDEF.EXERC02'   OPERATION 9  ACCESS 0 // 'Copiar'

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini��o do modelo de Dados

@author Pedro Henrique Soares de Souza
@since 13/05/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStructST1 := FWFormStruct( 1, 'ZB2', /*bAvalCampo*/,/*lViewUsado*/ )

	Local bLinePost := {|oModelGrid, nLine, cAction, cIDField, xValue, xCurrentValue|;
		LinePost(oModelGrid, nLine, cAction, cIDField, xValue, xCurrentValue)}

    // Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EXERC02', /*bPreValidacao*/,/*{|oModel| ValidInfo(oModel)}*/, /*{|oModel| CommitInfo(oModel) }*/, /*bCancel*/ )

    // Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
	oModel:AddFields( 'EXERC02_ZB2', /*cOwner*/, oStructST1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	 //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'ZB2_FILIAL','ZB2_CODIGO'})

    // Adiciona a descri��o do Modelo de Dados
	oModel:SetDescription( STR0001 ) // "Etapas Gen�ricas"

    // Adiciona a descri��o do Componente do Modelo de Dados
	oModel:GetModel('EXERC02_ZB2' ):SetDescription( STR0002 ) // "Dados da Etapa"

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini��o do interface

@author Pedro Henrique Soares de Souza
@since 13/05/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

    // Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel := FWLoadModel( 'EXERC02' )

    // Cria a estrutura a ser usada na View
	Local oStructST1 := FWFormStruct( 2, 'ZB2' )

    // Cria o objeto de View
	oView := FWFormView():New()

    // Define qual o Modelo de dados ser� utilizado
	oView:SetModel( oModel )

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZB2', oStructST1, 'EXERC02_ZB2' )//oView:AddField('FORM2' , oStr3 )/

    //Adiciona um titulo para o formul�rio
	oView:EnableTitleView( 'VIEW_ZB2' ,"Dados do Aluno" ) // "Dados da Etapa"

    // Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 100 )

	NGMVCUserBtn( oView, { { STR0011, 'MNT016QDO()' } } )

Return oView