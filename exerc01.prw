#Include 'MNTA016.ch'
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//---------------------------------------------------------------------
/*/{Protheus.doc} EXERC01
Cadastro de Turmas
@author Vitor de Sousa Bonet
@since 22/03/2018
@version p12
@return Nil, Nulo
/*/
//---------------------------------------------------------------------
Function EXERC01()

	Local aArea   := GetArea()
    Local oBrowse
    Local cFunBkp := FunName()
	Local oBrowse
	Local aNGBEGINPRM := NGBEGINPRM()

    SetFunName("EXERC01")

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZB1")         // Alias da tabela utilizada
	oBrowse:SetMenuDef("EXERC01")   // Nome do fonte onde está a função MenuDef
	oBrowse:SetDescription("Turmas") // Descrição do browse ## "Etapas Genéricas"
	oBrowse:Activate()

	NGRETURNPRM(aNGBEGINPRM)

	SetFunName(cFunBkp)
    RestArea(aArea)

Return

//---------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Opções de menu

@author Pedro Henrique Soares de Souza
@since 13/05/2014
@version P11/P12
@return aRotina - Estrutura
	[n,1] Nome a aparecer no cabecalho
	[n,2] Nome da Rotina associada
	[n,3] Reservado
	[n,4] Tipo de Transação a ser efetuada:
		1 - Pesquisa e Posiciona em um Banco de Dados
		2 - Simplesmente Mostra os Campos
		3 - Inclui registros no Bancos de Dados
		4 - Altera o registro corrente
		5 - Remove o registro corrente do Banco de Dados
		6 - Alteração sem inclusão de registros
		7 - Cópia
		8 - Imprimir
	[n,5] Nivel de acesso
	[n,6] Habilita Menu Funcional
/*/
//---------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE STR0004 ACTION 'PesqBrw'           OPERATION 1  ACCESS 0 // 'Pesquisar'
	ADD OPTION aRotina TITLE STR0005 ACTION 'VIEWDEF.EXERC01'   OPERATION 2  ACCESS 0 // 'Visualizar'
	ADD OPTION aRotina TITLE STR0006 ACTION 'VIEWDEF.EXERC01'   OPERATION 3  ACCESS 0 // 'Incluir'
	ADD OPTION aRotina TITLE STR0007 ACTION 'VIEWDEF.EXERC01'   OPERATION 4  ACCESS 0 // 'Alterar'
	ADD OPTION aRotina TITLE STR0008 ACTION 'VIEWDEF.EXERC01'   OPERATION 5  ACCESS 0 // 'Excluir'
	ADD OPTION aRotina TITLE STR0009 ACTION 'VIEWDEF.EXERC01'   OPERATION 8  ACCESS 0 // 'Imprimir'
	ADD OPTION aRotina TITLE STR0010 ACTION 'VIEWDEF.EXERC01'   OPERATION 9  ACCESS 0 // 'Copiar'

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Pedro Henrique Soares de Souza
@since 13/05/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStructST1 := FWFormStruct( 1, 'ZB1', /*bAvalCampo*/,/*lViewUsado*/ )

	Local bLinePost := {|oModelGrid, nLine, cAction, cIDField, xValue, xCurrentValue|;
		LinePost(oModelGrid, nLine, cAction, cIDField, xValue, xCurrentValue)}

    // Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EXERC01', /*bPreValidacao*/,/*{|oModel| ValidInfo(oModel)}*/, /*{|oModel| CommitInfo(oModel) }*/, /*bCancel*/ )

    // Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'EXERC01_ZB1', /*cOwner*/, oStructST1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	 //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZB1_FILIAL','ZB1_CODIGO'})

    // Adiciona a descrição do Modelo de Dados
	oModel:SetDescription( STR0001 ) // "Etapas Genéricas"

    // Adiciona a descrição do Componente do Modelo de Dados
	oModel:GetModel('EXERC01_ZB1' ):SetDescription( STR0002 ) // "Dados da Etapa"

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Pedro Henrique Soares de Souza
@since 13/05/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

    // Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel := FWLoadModel( 'EXERC01' )

    // Cria a estrutura a ser usada na View
	Local oStructST1 := FWFormStruct( 2, 'ZB1' )

    // Cria o objeto de View
	oView := FWFormView():New()

    // Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZB1', oStructST1, 'EXERC01_ZB1' )//oView:AddField('FORM2' , oStr3 )/

    //Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZB1' ,"Dados da Turma" ) // "Dados da Etapa"

    // Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 100 )

	NGMVCUserBtn( oView, { { STR0011, 'MNT016QDO()' } } )

Return oView