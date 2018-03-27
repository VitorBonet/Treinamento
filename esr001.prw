#Include "MNTR010.ch"
#Include "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESR001
Relatório para notas
@author  Vitor Bonet
@since   13/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function ESR001()

    Local aNGBEGINPRM := NGBEGINPRM()

    Local cString    := "ZZ7"
    Local cDesc1     := "Relatório de listagem das notas do Aluno."
    Local cDesc2     := ""
    Local cDesc3     := ""
    Local wnrel      := "ESR001"

    Private aReturn  := {"Zebrado", 1,"Administração", 1, 2, 1, "",1 }
    Private nLastKey := 0
    Private cPerg    := "ESR001"
    Private Titulo   := "Relatório de listagem das notas do Aluno."
    Private Tamanho  := "G"
    Private nomeprog := "ESR001"

    /*---------------------------------------------------------------
    Vetor utilizado para armazenar retorno da função MNT045TRB,
    criada de acordo com o item 18 (RoadMap 2013/14)
    ---------------------------------------------------------------*/
    //Private vFilTRB := MNT045TRB()

	//SetKey(VK_F4, {|| MNT045FIL( vFilTRB[2] )})

	/*/
	Variaveis utilizadas para qarametros!
	mv_par01     De Matrícula
	mv_par02     Até Matrícula
	mv_par03     De Matéria
	mv_par04     Até Matéria
	mv_par05     De Turma
	mv_par06     Até Turma
	/*/
	//Pergunte(cPerg,.T.)

    wnrel := SetPrint( cString, wnrel, cPerg, titulo, cDesc1, cDesc2, cDesc3, .F., "" )

    SetDefault(aReturn,cString)
    RptStatus({|lEnd| RFR001Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

    dbSelectArea("ZZ7")

    // Devolve a condicao original do arquivo principal
    RetIndex("ZZ7")
    Set Filter To
    Set device to Screen

    If aReturn[5] == 1
        Set Printer To
        dbCommitAll()
        OurSpool(wnrel)
    EndIf

    MS_FLUSH()

    NGRETURNPRM(aNGBEGINPRM)

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} RFR001Imp
Chamada do Relat¢rio
@author  Elisangela Costa
@since   26/09/07
@version p10
/*/
//-------------------------------------------------------------------
Function RFR001Imp(lEND,WNREL,TITULO,TAMANHO)

    Local xx
    Local cRodaTxt  := ""
    Local nCntImpr  := 0
    Local nMult     := 1
    Local lImpRel   := .F.
	Local aLinha    := {} 	// array da linha do relatorio
	Local aTodLinh  := {}	// array de todas as linhas do relatorio
	Local aAlunos   := {}	// array de alunos
	Local aMater   	:= {}	// array de materias
	Local aTurmas   := {}	// array de turmas
	Local aNotas   	:= {}	// array de notas
	Local nNotAlta	:= 1	// nota mais alta
	Local nNotBaix	:= 1	// nota mais baixa
	Local nValor    := 1	// utilizado no for

    Private li := 80 ,m_pag := 1

    nTIPO  := IIf( aReturn[4] == 1, 15, 18 )
    CABEC1 := "Matricula     Nome do Aluno                   Turma        Descrição Turma                  Cód Matéria   Descrição Matéria                 Nota      Data       Cód. Prof.   Nome "
    CABEC2 := " "

    /*/
    1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
    *****************************************************************************************************************************************************************************************************
    Matricula     Nome do Aluno                   Turma        Descrição Turma                  Cód Matéria   Descrição Matéria                 Nota      Data       Cód. Prof.   Nome
    *****************************************************************************************************************************************************************************************************

    XXXXXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXX        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXX        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XX,XXX    99/99/99   XXXXXX       XXXXXXXXXXXXXXXXXXXXXXX

    */
    dbSelectArea("ZZ7")
    dbSetOrder(01)
    dbSeek(xFilial("ZZ7") + MV_PAR01, .T.)

    SetRegua(LastRec())

	// Varre dados do banco e faz a consulta utilizando os parametros como filtro
    While !Eof() .And. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .And.;
            ZZ7->ZZ7_MATAL >= MV_PAR01 .And. ZZ7->ZZ7_MATAL <= MV_PAR02

			// Pula linha
			NGSOMALI(58)

			dbSelectArea("ZZ6")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZ6") + ZZ7->ZZ7_DISC)

				While !Eof() .And. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .And.;
            			ZZ6->ZZ6_CODMAT >= MV_PAR03 .And. ZZ6->ZZ6_CODMAT <= MV_PAR04 .And.;
						ZZ6->ZZ6_TURMA >= MV_PAR05 .And. ZZ6->ZZ6_TURMA <= MV_PAR06

					lImpRel := .T.

					@LI,000 Psay ZZ7->ZZ7_MATAL  Picture "999999999" //exibe dado no relatorio
					aAdd(aLinha, ZZ7->ZZ7_MATAL) // adiciona dado no aLinha

					dbSelectArea("ZZ2")
					dbSetOrder(1)
					If dbSeek(xFilial("ZZ2") + ZZ7->ZZ7_MATAL)
						@LI,014 Psay ZZ2->ZZ2_NOME  Picture "@!"
						aAdd(aLinha, ZZ2->ZZ2_NOME )
					EndIf

					//lPRIIMPB := .F.
					@LI,046 Psay ZZ6->ZZ6_TURMA  Picture "@!"
					aAdd(aLinha, ZZ6->ZZ6_TURMA )
					dbSelectArea("ZZ4")
					dbSetOrder(1)
					If dbSeek(xFilial("ZZ4") + ZZ6->ZZ6_TURMA)
						@LI,060 Psay ZZ4->ZZ4_DESCT  Picture "@!"
						aAdd(aLinha, ZZ4->ZZ4_DESCT )
					EndIf

					@LI,96 Psay ZZ6->ZZ6_CODMAT Picture "@!"
					aAdd(aLinha, ZZ6->ZZ6_CODMAT)
					dbSetOrder(1)
					dbSelectArea("ZZ3")
					If dbSeek(xFilial("ZZ3") + ZZ6->ZZ6_CODMAT)
						@LI,108 Psay ZZ3->ZZ3_DESCRI Picture "@!"
						aAdd(aLinha, ZZ3->ZZ3_DESCRI)
					EndIf

					@LI,141 Psay ZZ7->ZZ7_NOTA Picture "99.99"
					aAdd(aLinha, ZZ7->ZZ7_NOTA)
					@LI,150 Psay ZZ7->ZZ7_DATA Picture "99/99/99"
					aAdd(aLinha, ZZ7->ZZ7_DATA)
					@LI,164 Psay ZZ6->ZZ6_MAT Picture "999999"
					aAdd(aLinha, ZZ6->ZZ6_MAT)
					dbSelectArea("ZZ1")
					dbSetOrder(1)
					If dbSeek(xFilial("ZZ1") + ZZ6->ZZ6_MAT)
						@LI,175 Psay ZZ1->ZZ1_NOME Picture "@!"
						aAdd(aLinha, ZZ1->ZZ1_NOME)
					EndIf

					aAdd(aTodLinh, aLinha) // adiciona o array aLinha no aResumo

					//verifica para não repetir cada termo no array
					If aScan(aAlunos, ZZ7->ZZ7_MATAL) == 0
						aAdd(aAlunos,ZZ7->ZZ7_MATAL)
					EndIf

					If aScan(aMater, ZZ6->ZZ6_MAT ) == 0
						aAdd(aMater,ZZ6->ZZ6_MAT)
					EndIf

					If aScan(aTurmas, ZZ6->ZZ6_TURMA ) == 0
						aAdd(aTurmas,ZZ6->ZZ6_TURMA)
					EndIf

					If aScan(aNotas, ZZ7->ZZ7_NOTA ) == 0
						aAdd(aNotas,ZZ7->ZZ7_NOTA)
					EndIf

					dbSelectArea("ZZ6")
					dbSkip()

				 EndDo

			EndIf

			For nValor := 1 To Len(aNotas)
				// descobre o maior índice
				If aNotas[nValor] > aNotas[nNotAlta]
					nNotAlta = nValor
				EndIf

				// descobre o menor índice
				If aNotas[nValor] < aNotas[nNotBaix]
					nNotBaix = nValor
				EndIf
			Next nValor

            dbSelectArea("ZZ7")
            dbSkip()
    EndDo

	NGSOMALI(58)
	NGSOMALI(58)
	@LI,000 Psay "Total Alunos....:" + cValToChar(Len(aAlunos)) Picture "@!"
	NGSOMALI(58)
	@LI,000 Psay "Total Matérias..:" + cValToChar(Len(aMater)) Picture "@!"
	NGSOMALI(58)
	@LI,000 Psay "Total Turmas....:" + cValToChar(Len(aTurmas)) Picture "@!"
	NGSOMALI(58)
	@LI,000 Psay "Nota Mais Alta..:" + cValToChar(aNotas[nNotAlta]) Picture "@!"
	NGSOMALI(58)
	@LI,000 Psay "Nota Mais Baixa.:" + cValToChar(aNotas[nNotBaix]) Picture "@!"

    If lImpRel
        Roda(nCntImpr,cRodaTxt,Tamanho)
    Else
        MsgInfo(STR0019, STR0018)
        Return .F.
    EndIf

Return .T.