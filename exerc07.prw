#INCLUDE 'MNTA016.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

//---------------------------------------------------------------------
/*/{Protheus.doc} EXERC06
Cadastro de várias Rotinas
@author Vitor de Sousa Bonet
@since 22/03/2018
@version p12
@return Nil, Nulo
/*/
//---------------------------------------------------------------------
Function EXERC07()
	Local aCoors  := FWGetDialogSize( oMainWnd )
	Local oPanelUp
	Local oPanelD1
	Local oPanelD2
	Local oFWLayer
	Local oBrowseUp
	Local oBrowseLeft
	Local oBrowseRight
	Local oRelacZA4
	Local oRelacZA5

	Private oDlgPrinc
	Private nLenGrid 	:= 0

	Define MsDialog oDlgPrinc Title 'Multiplos FWmBrowse' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

	// Cria o conteiner onde serão colocados os browses
	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlgPrinc, .F., .T. )

	// Define Painel Superior
	oFWLayer:AddLine( 'UP', 30, .F. )                       // Cria uma "linha" com 30% da tela
	oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )            // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )         // Pego o objeto desse pedaço do container

	// Painel Inferior 1
	oFWLayer:AddLine( 'DOWN1', 35, .F. )                    // Cria uma "linha" com 35% da tela
	oFWLayer:AddCollumn( 'ALL', 100, .T., 'DOWN1' )         // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	oPanelD1 := oFWLayer:GetColPanel( 'ALL', 'DOWN1' )     	// Pego o objeto desse pedaço do container


	// Painel Inferior 2
	oFWLayer:AddLine( 'DOWN2', 35, .F. )                    // Cria uma "linha" com 35% da tela
	oFWLayer:AddCollumn( 'ALL', 100, .T., 'DOWN2' )         // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	oPanelD2 := oFWLayer:GetColPanel( 'ALL', 'DOWN2' )     	// Pego o objeto desse pedaço do container

	// FWmBrowse Superior Cabeçalho
	oBrowseUp:= FWmBrowse():New()
	oBrowseUp:SetOwner( oPanelUp )                        // Aqui se associa o browse ao componente de tela
	oBrowseUp:SetDescription( "Cabeçalho" )
	oBrowseUp:SetAlias( 'ZB5' )
	oBrowseUp:SetMenuDef( 'EXERC07' )                  	 // Define de onde virao os botoes deste browse
	oBrowseUp:SetProfileID( '1' )
	oBrowseUp:ForceQuitButton()
	oBrowseUp:Activate()

	// Lado Esquerdo Alunos
	oBrowseLeft:= FWMBrowse():New()
	oBrowseLeft:SetOwner( oPanelD1 )
	oBrowseLeft:SetDescription( 'Alunos' )
	oBrowseLeft:SetMenuDef( '' )                       	// Referencia uma funcao que nao tem menu para que nao exiba nenhum botao
	oBrowseLeft:DisableDetails()
	oBrowseLeft:SetAlias( 'ZB6' )
	oBrowseLeft:SetProfileID( '2' )

	// Relacionamento entre os Browses
	oRelacZA4:= FWBrwRelation():New()
	oRelacZA4:AddRelation( oBrowseUp  , oBrowseLeft , { { 'ZB6_FILIAL', 'xFilial( "ZB5" )' }, { 'ZB6_CODTUR' , 'ZB5_CODTUR'  } } )
	oRelacZA4:Activate()

	// Ativa o Browse Filho
	oBrowseLeft:Activate()

	// Lado Direito Notas
	oBrowseRight:= FWMBrowse():New()
	oBrowseRight:SetOwner( oPanelD2 )
	oBrowseRight:SetDescription( 'Notas Turma x Aluno' )
	oBrowseRight:SetMenuDef( '' )                      // Referencia uma funcao que nao tem menu para que nao exiba nenhum botao
	oBrowseRight:DisableDetails()
	oBrowseRight:SetAlias( 'ZB7' )
	oBrowseRight:SetProfileID( '3' )

	// Relacionamento entre os Browses
	oRelacZA5:= FWBrwRelation():New()
	oRelacZA5:AddRelation( oBrowseLeft, oBrowseRight, { { 'ZB7_FILIAL', 'xFilial( "ZB6" )' }, { 'ZB7_CODTUR' , 'ZB6_CODTUR'  }, { 'ZB7_RA', 'ZB6_RA' } } )
	oRelacZA5:Activate()

	// Ativa o Browse Neto
	oBrowseRight:Activate()

	// Duplo click no browse Pai
	oBrowseUp:bldblclick := {|| AlertCon( 'ZB5', ZB5->ZB5_CODTUR)}

	// Duplo click no browse Filho
	oBrowseLeft:bldblclick := {|| AlertCon('ZB6', ZB6->ZB6_CODTUR, ZB6->ZB6_RA)}

	Activate MsDialog oDlgPrinc Center

Return NIL

Static Function MenuDef()

	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.EXERC07', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.EXERC07', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.EXERC07', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.EXERC07', 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.EXERC07', 0, 8, 0, NIL } )
	aAdd( aRotina, { 'Copiar'    , 'VIEWDEF.EXERC07', 0, 9, 0, NIL } )
	aAdd( aRotina, { 'Processar' , 'AlertCon'		, 0, 9, 0, NIL } )

Return aRotina

// Chama ModelDef da exerc04
Static Function ModelDef()
Return FWLoadModel('EXERC04')

// Chama ViewDef da exerc04
Static Function ViewDef()
Return FWLoadView('EXERC04')


//-------------------------------------------------------------------
/*/{Protheus.doc} fSetActv
Busca a quantidade inicial de linhas do Grid
@author  Vitor Bonet
@since   26/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Static Function fSetActv(oModel)

	nLenGrid := oModel:GetModel('EXERC04_ZB7'):Length() //Busca a quantidade de linhas na grid

Return