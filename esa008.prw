#INCLUDE "MNTA098.CH"
#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA008
Programa de Cadastro de professores

@author  Vitor Bonet
@since   15/03/2018
@source  Generico
/*/
//-------------------------------------------------------------------
Function ESA008()

	// Armazena variaveis p/ devolucao (NGRIGHTCLICK)
	Private aRotina := MenuDef()
	Private cCadastro := OemtoAnsi("Professores") //"Especialidades"
	Private aCHKDEL   := {}
	Private bNGGRAVA  := {|| fValidFim()}

	DbSelectArea("ZZ1")
	DbSetOrder(1)
	mBrowse( 6, 1,22,75,"ZZ1")

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

 	aRotina := {{"Pesquisar", "AxPesqui"  , 0 , 1},;    	//"Pesquisar"
                {"Visualizar", "ESA008CAD"   , 0 , 2},;    	//"Visualizar"
                {"Incluir", "ESA008CAD"   , 0 , 3},;    	//"Incluir"
                {"Alterar", "ESA008CAD"   , 0 , 4},;    	//"Alterar"
                {"Excluir", "ESA008CAD"   , 0 , 5, 3} } 	//"Excluir"
Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ESA001CAD
Programa de Cadastro de professores

@author  Vitor Bonet
@since   15/03/2018
@source  Generico
/*/
//-------------------------------------------------------------------
Function ESA008CAD()

	Local aSize 	:= MsAdvSize(.F.)
	Local aItens    := {"1=Ativo","2=Demitido","3=Afastado","4=Ferias",""}
	Local lVisiv	:= IIf(!Inclui .And. !Altera,.F.,.T.)

	Private cMat    := IIf(Inclui,GETSXENUM("ZZ1","ZZ1_MAT"),ZZ1->ZZ1_MAT)
	Private cNome   := IIf(Inclui,Space(TAMSX3("ZZ1_NOME")[1]),ZZ1->ZZ1_NOME)
	Private cEnd    := IIf(Inclui,Space(TAMSX3("ZZ1_END")[1]),ZZ1->ZZ1_END)
	Private cCidad  := IIf(Inclui,Space(TAMSX3("ZZ1_CIDADE")[1]),ZZ1->ZZ1_CIDADE)
	Private cUf     := IIf(Inclui,Space(TAMSX3("ZZ1_UF")[1]),ZZ1->ZZ1_UF)
	Private cTel    := IIf(Inclui,Space(TAMSX3("ZZ1_TEL")[1]),ZZ1->ZZ1_TEL)
	Private cCel    := IIf(Inclui,Space(TAMSX3("ZZ1_CEL")[1]),ZZ1->ZZ1_CEL)
	Private dNasc   := IIf(Inclui,cTod(" / / ") ,ZZ1->ZZ1_DTNASC)
	Private dAdmi   := IIf(Inclui,cTod(" / / ") ,ZZ1->ZZ1_DTADMI)
	Private dDemi   := IIf(Inclui,cTod(" / / ") ,ZZ1->ZZ1_DTDEMI)
	Private cRg     := IIf(Inclui,Space(TAMSX3("ZZ1_RG")[1]),ZZ1->ZZ1_RG)
	Private cCpf    := IIf(Inclui,Space(TAMSX3("ZZ1_CPF")[1]),ZZ1->ZZ1_CPF)
	Private cCombo 	:= IIf(Inclui,aItens[5],ZZ1->ZZ1_SITUAC)

	Private lConfirm	:= .F.
	Private lCancel  	:= .F.

	//Layout da tela de cadastro, sua largura e altura é definida pela função na variavel aSize que pega as dimensões
	DEFINE MSDIALOG oDLG008 FROM aSize[7],0 To aSize[6],aSize[5] TITLE "Cadastro de Professores" PIXEL

		// "Matrícula: "
		@ 040,010 Say OemToAnsi("Matrícula: ") Size 400,10 Of oDLG008 PIXEL color CLR_HBLUE
		@ 050,010 MsGet cMat Picture "999999" Valid EXISTCHAV("ZZ1",M->ZZ1_MAT) Size 030,15 HASBUTTON Of oDLG008 PIXEL WHEN .F.

		// "Nome: "
		@ 040,100 Say OemToAnsi("Nome: ") Size 400,10 Of oDLG008 PIXEL color CLR_HBLUE
		@ 050,100 MsGet cNome Picture "@!"  Size 200,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "Endereço: "
		@ 040,350 Say OemToAnsi("Endereço: ") Size 400,10 Of oDLG008 PIXEL
		@ 050,350 MsGet cEnd Picture "@!"  Size 200,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "Cidade: "
		@ 080,010 Say OemToAnsi("Cidade: ") Size 400,10 Of oDLG008 PIXEL
		@ 090,010 MsGet cCidad Picture "@!"  Size 200,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "Estado: "
		@ 080,250 Say OemToAnsi("Estado: ") Size 400,10 Of oDLG008 PIXEL
		@ 090,250 MsGet cUf Picture "@!"  Size 050,15 HASBUTTON Of oDLG008 PIXEL F3 "SX512" WHEN lVisiv

		// "Telefone: "
		@ 080,350 Say OemToAnsi("Telefone: ") Size 400,10 Of oDLG008 PIXEL color CLR_HBLUE
		@ 090,350 MsGet cTel  Picture ""  Size 100,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "Celular: "
		@ 080,500 Say OemToAnsi("Celular: ") Size 400,10 Of oDLG008 PIXEL
		@ 090,500 MsGet cCel Picture ""  Size 100,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "Data de Nascimento: "
		@ 120,010 Say OemToAnsi("Data de Nascimento: ") Size 400,10 Of oDLG008 PIXEL color CLR_HBLUE
		@ 130,010 MsGet dNasc Picture "99/99/99"  Valid ESA001VLD("ZZ1_DTNASC",dAdmi,dNasc,dDemi) Size 080,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "Data de admissão: "
		@ 120,150 Say OemToAnsi("Data de admissão: ") Size 400,10 Of oDLG008 PIXEL color CLR_HBLUE
		@ 130,150 MsGet dAdmi Picture "99/99/99" Valid ESA001VLD("ZZ1_DTADMI",dAdmi,dNasc,dDemi) Size 080,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "Data de Demissão: "
		@ 120,280 Say OemToAnsi("Data de Demissão: ") Size 400,10 Of oDLG008 PIXEL
		@ 130,280 MsGet dDemi Picture "99/99/99" Valid ESA001VLD("ZZ1_DTDEMI",dAdmi,dNasc,dDemi,cCombo) Size 080,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "Situação: "
		@ 120,390 Say OemToAnsi("Situação: ") Size 400,10 Of oDLG008 PIXEL color CLR_HBLUE
		oCbx := tComboBox():New(130,390,{|u|If(PCount() > 0, cCombo := u,cCombo)},aItens,100,20,oDLG008,,,,,,(.T.),,,,{|| Empty(dDemi) .And. lVisiv} ,,,,,'cCombo')

		// "RG: "
		@ 120,500 Say OemToAnsi("RG: ") Size 400,10 Of oDLG008 PIXEL
		@ 130,500 MsGet cRg Picture "@R 999999999999999"  Size 080,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

		// "CPF: "
		@ 160,010 Say OemToAnsi("CPF: ") Size 400,10 Of oDLG008 PIXEL color CLR_HBLUE
		@ 170,010 MsGet cCpf Picture "@R 999.999.999-99"  Size 080,15 HASBUTTON Of oDLG008 PIXEL WHEN lVisiv

	ACTIVATE MSDIALOG oDLG008 ON INIT (EnchoiceBar(oDLG008,;
	                                                       {||lConfirm := .T.,if(f008Ok(),fConfZZ1() .And. oDLG008:End(),Nil)},; //Confirmação
					                                       {||lCancel  := .T.,oDLG008:End()})) //Cancelamento
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} f008Ok
Valida o Cadastro para a Confirmação
@author  Vitor Bonet
@since   15/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Static Function f008Ok()

	Local lValid := .T.

	//  Matricula
	If Empty(cMat)
		lValid := .F.
		MsgAlert("Campo Matrícula é obrigatório.")

	// Nome
	ElseIf Empty(cNome)
		lValid := .F.
		MsgAlert("Campo Nome é obrigatório.")

	// Telefone
	ElseIf Empty(cTel)
		lValid := .F.
		MsgAlert("Campo Telefone é obrigatório.")

	// Data de nascimento
	ElseIf Empty(dNasc)
		lValid := .F.
		MsgAlert("Campo Data de nascimento é obrigatório.")

	// Data de admissão
	ElseIf Empty(dAdmi)
		lValid := .F.
		MsgAlert("Campo Data de admissão é obrigatório.")

	// Situação
	ElseIf Empty(cCombo)
		lValid := .F.
		MsgAlert("Campo Situação é obrigatório.")

	// cpf
	ElseIf Empty(cCpf)
		lValid := .F.
		MsgAlert("Campo CPF é obrigatório.")

	EndIf

Return lValid

//-------------------------------------------------------------------
/*/{Protheus.doc} fConfZZ1
Inclui ou altera na Tabela ZZ1 os dados do Cadastro
@author  Vitor Bonet
@since   16/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Static Function fConfZZ1()

	If Inclui

		Reclock("ZZ1",.T.)
		ZZ1->ZZ1_FILIAL	:= xFilial("ZZ1")
		ZZ1->ZZ1_MAT	:= cMat
		ZZ1->ZZ1_NOME 	:= cNome
		ZZ1->ZZ1_END 	:= cEnd
		ZZ1->ZZ1_CIDADE := cCidad
		ZZ1->ZZ1_UF 	:= cUf
		ZZ1->ZZ1_TEL 	:= cTel
		ZZ1->ZZ1_CEL 	:= cCel
		ZZ1->ZZ1_DTNASC := dNasc
		ZZ1->ZZ1_DTADMI := dAdmi
		ZZ1->ZZ1_DTDEMI := dDemi
		ZZ1_SITUAC		:= cCombo
		ZZ1->ZZ1_RG 	:= cRg
		ZZ1->ZZ1_CPF 	:= cCpf
		MsUnLock("ZZ1")

	ElseIf Altera

		dbSelectArea("ZZ1")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZ1") + cMat)

			Reclock("ZZ1",.F.)
			ZZ1->ZZ1_NOME 	:= cNome
			ZZ1->ZZ1_END 	:= cEnd
			ZZ1->ZZ1_CIDADE := cCidad
			ZZ1->ZZ1_UF 	:= cUf
			ZZ1->ZZ1_TEL 	:= cTel
			ZZ1->ZZ1_CEL 	:= cCel
			ZZ1->ZZ1_DTNASC := dNasc
			ZZ1->ZZ1_DTADMI := dAdmi
			ZZ1->ZZ1_DTDEMI := dDemi
			ZZ1_SITUAC		:= cCombo
			ZZ1->ZZ1_RG 	:= cRg
			ZZ1->ZZ1_CPF 	:= cCpf
			MsUnLock("ZZ1")

		EndIf

	Else // Exclui

		//verifica se professor esta vinculado à uma disciplina
		dbSelectArea("ZZ6")
		dbSetOrder(5)
		If dbSeek(xFilial("ZZ1") + ZZ1->ZZ1_MAT)

			MsgAlert("Não é possível Excluir este professor, ele está vinculado à uma Disciplina")

		Else

			//Se não está vinculado exclui o professor
			dbSelectArea("ZZ1")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZ1") + cMat)

				Reclock("ZZ1",.F.)
				dbDelete()
				MsUnLock("ZZ1")

			EndIf

		EndIf

	EndIf

Return .T.