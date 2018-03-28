#INCLUDE 'MNTA016.ch'
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

//---------------------------------------------------------------------
/*/{Protheus.doc} EXERC04
Cadastro de várias Rotinas
@author Vitor de Sousa Bonet
@since 22/03/2018
@version p12
@return Nil, Nulo
/*/
//---------------------------------------------------------------------
Function EXERC04()
	Local aCoors  := FWGetDialogSize( oMainWnd )
	Local oPanelUp
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
	oFWLayer:AddLine( 'UP', 50, .F. )                       // Cria uma "linha" com 50% da tela
	oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )            // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )         // Pego o objeto desse pedaço do container

	// Painel Inferior
	oFWLayer:AddLine( 'DOWN', 50, .F. )                     // Cria uma "linha" com 50% da tela
	oFWLayer:AddCollumn( 'ALL', 100, .T., 'DOWN' )          // Na "linha" criada eu crio uma coluna com 100% da tamanho dela
	oPanelDown := oFWLayer:GetColPanel( 'ALL', 'DOWN' )     // Pego o objeto desse pedaço do container

	oFold := TFolder():New(0,0,{},,oPanelDown,,,,.T.,.F.,0,1000)
	oFold:Align := CONTROL_ALIGN_ALLCLIENT
	oFold:Hide()
	oFold:Show()
	oFold:AddItem("Alunos Turma x Aluno")
	oFold:AddItem("Notas Turma x Aluno")

	oAba01 := oFold:aDialogs[1]
	oAba02 := oFold:aDialogs[2]

	// FWmBrowse Superior Cabeçalho
	oBrowseUp:= FWmBrowse():New()
	oBrowseUp:SetOwner( oPanelUp )                        // Aqui se associa o browse ao componente de tela
	oBrowseUp:SetDescription( "Cabeçalho" )
	oBrowseUp:SetAlias( 'ZB5' )
	oBrowseUp:SetMenuDef( 'EXERC04' )                  	 // Define de onde virao os botoes deste browse
	oBrowseUp:SetProfileID( '1' )
	oBrowseUp:ForceQuitButton()
	oBrowseUp:Activate()

	// Lado Esquerdo Alunos
	oBrowseLeft:= FWMBrowse():New()
	oBrowseLeft:SetOwner( oAba01 )
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
	oBrowseRight:SetOwner( oAba02 )
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

	aAdd( aRotina, { 'Visualizar', 'VIEWDEF.EXERC04', 0, 2, 0, NIL } )
	aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.EXERC04', 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.EXERC04', 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.EXERC04', 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.EXERC04', 0, 8, 0, NIL } )
	aAdd( aRotina, { 'Copiar'    , 'VIEWDEF.EXERC04', 0, 9, 0, NIL } )
	aAdd( aRotina, { 'Processar' , 'AlertCon'		, 0, 9, 0, NIL } )

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
	Local oStructZB5 := FWFormStruct( 1, 'ZB5', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStructZB6 := FWFormStruct( 1, 'ZB6', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStructZB7 := FWFormStruct( 1, 'ZB7', /*bAvalCampo*/,/*lViewUsado*/ )

	Local bSetActiv := {|oModel| fSetActv(oModel) } // Gravação do formulario

    // Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('EXERC04', /* bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	//Função de ativação
	oModel:SetActivate(bSetActiv)

    // Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'EXERC04_ZB5', /*cOwner*/, oStructZB5, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

    // Adiciona ao modelo uma estrutura de formulário de edição por grid
	oModel:AddGrid( 'EXERC04_ZB6', 'EXERC04_ZB5', oStructZB6, {|| E04PreVl('Grid_ZB6') },/*bLinePost*/ , /*bPreValida*/, /*bPosVal*/, /*{|oModel| LoadGrid(oModel)}*/ )
	oModel:AddGrid( 'EXERC04_ZB7', 'EXERC04_ZB6', oStructZB7, {|| E04PreVl('Grid_ZB7') }, /*bLinePost*/, /*bPreValida*/, /*bPosVal*/, /*{|oModel| LoadGrid(oModel)}*/ )

	//Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZB5_FILIAL','ZB5_CODTUR'})

    // Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'EXERC04_ZB6', { { 'ZB6_FILIAL', 'xFilial( "ZB5" )' }, { 'ZB6_CODTUR', 'ZB5_CODTUR' } }, ZB6->(IndexKey(1)) )
	oModel:SetRelation( 'EXERC04_ZB7', { { 'ZB7_FILIAL', 'xFilial( "ZB6" )' }, { 'ZB7_CODTUR', 'ZB6_CODTUR' },{ 'ZB7_RA', 'ZB6_RA' } }, ZB7->(IndexKey(2)) )

    // Indica que é opcional ter dados informados na Grid
	oModel:GetModel( 'EXERC04_ZB6' ):SetOptional(.T.)
	oModel:GetModel( 'EXERC04_ZB7' ):SetOptional(.T.)

    // Adiciona a descrição do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Cabeçalho de Turma/Alunos/Notas' ) // "Etapas Genéricas"

    // Adiciona a descrição do Componente do Modelo de Dados
	oModel:GetModel('EXERC04_ZB5' ):SetDescription( "Cabeçalhos Turmas x Alunos" ) // "Dados da Etapa"
	oModel:GetModel('EXERC04_ZB6' ):SetDescription( "Alunos Turmas x Alunos" ) // "Dados das Opções"
	oModel:GetModel('EXERC04_ZB7' ):SetDescription( "Notas Turmas x Alunos" ) // "Dados das Opções"

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
	Local oModel := FWLoadModel( 'EXERC04' )

    // Cria a estrutura a ser usada na View
	Local oStructZB5 := FWFormStruct( 2, 'ZB5' )
	Local oStructZB6 := FWFormStruct( 2, 'ZB6' )
	Local oStructZB7 := FWFormStruct( 2, 'ZB7' )

    // Cria o objeto de View
	oView := FWFormView():New()

    // Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZB5', oStructZB5, 'EXERC04_ZB5' )

    //Adiciona um titulo para o formulário
	oView:EnableTitleView( 'VIEW_ZB5' ,"Cabeçalho" )

    //Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid( 'VIEW_ZB6', oStructZB6, 'EXERC04_ZB6' )
	oView:AddGrid( 'VIEW_ZB7', oStructZB7, 'EXERC04_ZB7' )

	oView:EnableTitleView( 'VIEW_ZB6' ,"Alunos" )
	oView:EnableTitleView( 'VIEW_ZB7' ,"Notas" )

	oView:CreateHorizontalBox( 'CORPO'  	, 20 )
	oView:CreateHorizontalBox( 'RODAPE1'  	, 40 )
	oView:CreateHorizontalBox( 'RODAPE2'  	, 40 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZB5' , 'CORPO'  )
	oView:SetOwnerView( 'VIEW_ZB6' , 'RODAPE1'  )
	oView:SetOwnerView( 'VIEW_ZB7' , 'RODAPE2'  )

	// Remove o que é repetidido
	oStructZB6:RemoveField("ZB6_CODTUR")
	oStructZB7:RemoveField("ZB7_CODTUR")
	oStructZB7:RemoveField("ZB7_RA")

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} EXERC04INI
Da Valor para os campos que devem ser iguais
@author  Vitor Bonet
@since   22/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function EXERC04INI()

	Local oModel	:= FWModelActive() //Ativa o ultimo modelo aberto.
	Local nReturn 	:= ""
	// Campo a ser validado
	Local cCampo := ReadVar()

	If 'ZB6_CODTUR' $ cCampo

		IF !Empty(M->ZB5_CODTUR)
			nReturn := oModel:GetValue("EXERC04_ZB5", "ZB5_CODTUR")
		EndIf

	EndIf

Return nReturn

//-------------------------------------------------------------------
/*/{Protheus.doc} EXERC04VLD
Valida os campos
@author  Vitor Bonet
@since   22/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function EXERC04VLD()

	Local lValid	:= .T.
	Local oModel	:= FWModelActive() 		//Ativa o ultimo modelo aberto.
	Local oGridZB6 	:= oModel:GetModel( 'EXERC04_ZB6' )
	Local oGridZB7 	:= oModel:GetModel( 'EXERC04_ZB7' )
	Local cZB5CodT	:= oModel:GetValue("EXERC04_ZB5", "ZB5_CODTUR")
	Local cZB6CodT	:= oGridZB6:GetValue( "ZB6_CODTUR" )
	Local cZB6RA	:= oGridZB6:GetValue( "ZB6_RA" )
	Local nLenGri6 	:= oGridZB6:Length() 	//Total de linhas zb6
	Local nLinAtu6 	:= oGridZB6:GetLine() 	//Linha posicionada zb6
	Local nLenGri7 	:= oGridZB7:Length() 	//Total de linhas zb7
	Local nLinAtu7 	:= oGridZB7:GetLine() 	//Linha posicionada zb7
	Local cCampo 	:= ReadVar() 			//Campo a ser validado
	Local cValCamp	:= "" 					//Valor do campo RA
	Local cSomCam	:= "" 					//Soma dos campos como indice
	Local cNomeB6	:= Posicione("ZB2", 1, xFilial("ZB2") + oGridZB6:GetValue( "ZB6_RA" ), "ZB2_NOME") //pega valor do nome na ZB2
	Local nX		:= 1

	If 'ZB6_RA' $ cCampo

		If Empty(cZB6CodT)
			oGridZB6:LoadValue("ZB6_CODTUR", cZB5CodT)
		EndIf

		cValCamp := oGridZB6:GetValue("ZB6_RA")

		For nX := 1 To nLenGri6
			oGridZB6:GoLine(nX)
			If !(oGridZB6:IsDeleted()) .And. oGridZB6:GetValue("ZB6_RA") == cValCamp .And. nX != nLinAtu6
				lValid := .F.
				Help(Nil, Nil, 'Atenção', Nil, 'Já existe registro com esta informação' + CRLF + 'Troque a chave principal deste registro', 1, 0)
				Exit
			EndIf
		Next nX

		oGridZB6:GoLine(nLinAtu6)
		oGridZB6:LoadValue("ZB6_NOME", cNomeB6) // Carrega o nome do aluno para o campo

	ElseIf 'ZB6_CODTUR' $ cCampo

		IF !Empty(cZB5CodT)
			oGridZB6:LoadValue("ZB6_CODTUR", cZB5CodT)
		EndIf

	ElseIf 'ZB7_CODDIS' $ cCampo

		IF !Empty(cZB5CodT) .And. !Empty(cZB6CodT)
			oGridZB7:LoadValue("ZB7_CODTUR"	, cZB6CodT)
			oGridZB7:LoadValue("ZB7_RA"		, cZB6RA)
			oGridZB7:LoadValue("ZB7_DESDIS"	, ZB3->ZB3_DESCRI)
		EndIf

	ElseIf 'ZB7_BIM' $ cCampo

		cSomCam := oGridZB7:GetValue("ZB7_CODTUR") + oGridZB7:GetValue("ZB7_RA") + oGridZB7:GetValue("ZB7_CODDIS") + oGridZB7:GetValue("ZB7_BIM")

		For nX := 1 To nLenGri7
			oGridZB7:GoLine(nX)
			If !(oGridZB7:IsDeleted()) .And. !Empty(cSomCam) .And.;
			 	oGridZB7:GetValue("ZB7_CODTUR") + oGridZB7:GetValue("ZB7_RA") + oGridZB7:GetValue("ZB7_CODDIS") + oGridZB7:GetValue("ZB7_BIM") == cSomCam .And.;
				nX != nLinAtu7

				lValid := .F.
				Help(Nil, Nil, 'Atenção', Nil, 'Já existe registro com esta informação' + CRLF + 'Troque a chave principal deste registro', 1, 0)
				Exit

			EndIf
		Next nX

		oGridZB7:GoLine(nLinAtu7)

	EndIf

Return lValid

//-------------------------------------------------------------------
/*/{Protheus.doc} EXERC04EDT
Verifica a operação para se não for inclusão retornar .F. e fechar edição do campo
@author  Vitor Bonet
@since   23/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function EXERC04EDT()

	Local lValue 		:= .T.
	Local oModel		:= FWModelActive() //Ativa o ultimo modelo aberto.
	Local oGridZB7 		:= oModel:GetModel( 'EXERC04_ZB7' )
	Local nLinAtu 		:= oGridZB7:GetLine() //Linha posicionada

	If nLenGrid >= nLinAtu .And. nLenGrid != 1
		lValue := .F.
	EndIf

Return lValue

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

//-------------------------------------------------------------------
/*/{Protheus.doc} AlertCon
Monta Mensagem para exibir a contagem de linhas ZB6 e Zb7
@author  Vitor Bonet
@since   27/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function AlertCon(cOper, nCodTur, nRA)

	Local cQuery 	:= ""
	Local cAliasQry := ""

	If cOper == 'ZB5'
		cAliasQry 	:= GetNextAlias("ZB6")
		cQuery 		+= "SELECT COUNT(*) as Total "
		cQuery 		+= "FROM " + RetSqlName( "ZB6" )
		cQuery 		+= " WHERE ZB6_FILIAL = " + ValToSQL(xFilial("ZB6"))
		cQuery 		+= " AND ZB6_CODTUR = " + ValToSQL(cValToChar(nCodTur))
		cQuery 		+= " AND D_E_L_E_T_ = ' '"

		cQuery := ChangeQuery( cQuery )
		DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

		MsgAlert("Possui " + cValToChar((cAliasQry)->Total) + " Alunos.")

	ElseIf cOper == 'ZB6'
		cAliasQry 	:= GetNextAlias("ZB7")
		cQuery 		+= "SELECT COUNT(*) as Total "
		cQuery 		+= "FROM " + RetSqlName( "ZB7" )
		cQuery 		+= " WHERE ZB7_FILIAL = " + ValToSQL(xFilial("ZB7"))
		cQuery 		+= " AND ZB7_CODTUR = " + ValToSQL(nCodTur)
		cQuery 		+= " AND ZB7_RA = " + ValToSQL(nRA)
		cQuery 		+= " AND D_E_L_E_T_ = ' '"

		cQuery := ChangeQuery( cQuery )
		DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

		MsgAlert("Possui " + cValToChar((cAliasQry)->Total) + " Notas.")

	EndIf
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} E04PreVl
Valida o adicionar de linha do Grid
@author  Vitor Bonet
@since   27/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function E04PreVl( cGrid )

	Local lValid 		:= .T.
	Local oModel		:= FWModelActive() //Ativa o ultimo modelo aberto.
	Local cZB6CodTur 	:= oModel:GetValue('EXERC04_ZB6',"ZB6_CODTUR")
	Local cZB6Ra 		:= oModel:GetValue('EXERC04_ZB6',"ZB6_RA")

	If cGrid == 'Grid_ZB6'

		If	Empty(M->ZB5_CODTUR)
			lValid := .F.
			MsgAlert('Faltam informações importantes, cadastre um Cabeçalho')

		EndIf

	ElseIf cGrid == 'Grid_ZB7'

		If	Empty(cZB6CodTur) .Or. Empty(cZB6Ra)
			lValid := .F.
			MsgAlert('Faltam informações importantes, cadastre um Cabeçalho e pelo menos um Aluno')
		EndIf

	EndIf

Return lValid