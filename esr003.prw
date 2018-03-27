#Include "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESR003
Relátorio de Notas de Alunos
@author  Vitor Bonet
@since   19/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function ESR003()

	//Define Variaveis
	Local wnrel   := "ESR003"
	Local cDesc1  := "Relatório de listagem das notas do Aluno." //"Programa de impressão da parte diária."
	Local cDesc2  := ""
	Local cDesc3  := ""
	Local cSTRING := "ZZ7"

	Private nomeprog := "ESR003"
	Private tamanho  := "M"
	Private aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
	Private titulo   := "Relatório de listagem das notas do Aluno."
	Private cPerg    := "ESR001    "
	Private cCabec1  := " "
	Private cCabec2  := " "

	Pergunte(cPERG,.F.)

	//Devolve variaveis armazenadas (NGRIGHTCLICK)
	WNREL:=SetPrint(cSTRING,WNREL,cPerg,TITULO,cDesc1,cDesc2,cDesc3,.F.,"")
	SetDefault(aReturn,cSTRING)
	RptStatus({|lEnd| RImp003(@lEnd,WNREL,TITULO,TAMANHO)},TITULO)
	dbSelectArea("ZZ7")

Return .T.

Function RImp003( lEnd,wnRel,titulo,tamanho )

	Local aLinha    := {} 	// array da linha do relatorio
	Local aTodLinh  := {}	// array de todas as linhas do relatorio
	Local aAlunos   := {}	// array de alunos
	Local aMater   	:= {}	// array de materias
	Local aTurmas   := {}	// array de turmas
	Local aNotas   	:= {}	// array de notas
	Local nNotAlta	:= 1	// nota mais alta
	Local nNotBaix	:= 1	// nota mais baixa
	Local nValor    := 1	// utilizado no for

	Private oFont07, oFont11
	Private oPrint := TMSPrinter():New( OemToAnsi("Relatório de listagem das notas do Aluno.") )
	Private lin := 100

	cCabec1 := "Matricula       Nome do Aluno                                         Turma            Descrição Turma                                    Cód Matéria        Descrição Matéria                                 Nota          Data                 Cód. Prof.                               Nome "
	cCabec2 := "________________________________________________________________________________________________________________________________________________________________________________________________________________"
	oPrint:Setup()
	oPrint:SetLandscape()  //Default Paisagem

	oFont07 := TFont():New("COURIER",07,07,,.T.,,,,.T.,.F.)
	oFont11 := TFont():New("COURIER",11,11,,.T.,,,,.T.,.F.)

    dbSelectArea("ZZ7")
    dbSetOrder(01)
    dbSeek(xFilial("ZZ7") + MV_PAR01, .T.)

	oPrint:StartPage()

	oPrint:Say(100,200,cCabec1)
	lin := fSomaLinha(lin)
	oPrint:Say(lin,200,cCabec2)

	// Varre dados do banco e faz a consulta utilizando os parametros como filtro
    While !Eof() .And. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .And.;
            ZZ7->ZZ7_MATAL >= MV_PAR01 .And. ZZ7->ZZ7_MATAL <= MV_PAR02

			dbSelectArea("ZZ6")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZ6") + ZZ7->ZZ7_DISC)

				While !Eof() .And. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .And.;
            			ZZ6->ZZ6_CODMAT >= MV_PAR03 .And. ZZ6->ZZ6_CODMAT <= MV_PAR04 .And.;
						ZZ6->ZZ6_TURMA >= MV_PAR05 .And. ZZ6->ZZ6_TURMA <= MV_PAR06

					//alimenta o Relatório e os arrays
					lin := fSomaLinha(lin)
					oPrint:Say(lin,200,ZZ7->ZZ7_MATAL)
					aAdd(aLinha, ZZ7->ZZ7_MATAL) // adiciona dado no aLinha

					cNomAL	:= ZZ2->(VDISP(ZZ7->ZZ7_MATAL,"ZZ2_NOME"))
					oPrint:Say(lin,400,cNomAL)
					aAdd(aLinha, cNomAL )

					cTurma	:= ZZ6->(VDISP(ZZ7->ZZ7_DISC,"ZZ6_TURMA"))
					oPrint:Say(lin,950,cTurma)
					aAdd(aLinha, cTurma )

					cDescT	:= ESA007INI("ZZ7_DESCT")
					oPrint:Say(lin,1150,cDescT)
					aAdd(aLinha, cDescT )

					cMate	:= ZZ6->(VDISP(ZZ7->ZZ7_DISC,"ZZ6_CODMAT"))
					oPrint:Say(lin,1700,cMate)
					aAdd(aLinha, cMate)

					cDescM	:= ESA007INI("ZZ7_DESCM")
					oPrint:Say(lin,1950,cDescM)
					aAdd(aLinha, cDescM)

					oPrint:Say(lin,2500,cValToChar(ZZ7->ZZ7_NOTA))
					aAdd(aLinha, ZZ7->ZZ7_NOTA)

					oPrint:Say(lin,2600,cValToChar(ZZ7->ZZ7_DATA))
					aAdd(aLinha, ZZ7->ZZ7_DATA)

					cMatP	:= ZZ6->(VDISP(ZZ7->ZZ7_DISC,"ZZ6_MAT"))
					oPrint:Say(lin,2850,cMatP)
					aAdd(aLinha, cMatP)

					cNomeP 	:= ESA007INI("ZZ7_NOMEP")
					oPrint:Say(lin,3250,cNomeP)

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

	//pega os valores dos arrays e alimenta o Relatório
	cAlunos		:= "Número de Alunos....: " + cValToChar(Len(aAlunos))
	cMater		:= "Número de Matérias: " + cValToChar(Len(aMater))
	cTurmas		:= "Número de Turmas..: " + cValToChar(Len(aTurmas))
	cNotMai		:= "Maior Nota...............: " + cValToChar(aNotas[nNotAlta])
	cNotMen		:= "Menor Nota..............: " + cValToChar(aNotas[nNotBaix])

	lin := fSomaLinha(lin)
	lin := fSomaLinha(lin)
	oPrint:Say(lin,200,cAlunos)

	lin := fSomaLinha(lin)
	oPrint:Say(lin,200,cMater)

	lin := fSomaLinha(lin)
	oPrint:Say(lin,200,cTurmas)

	lin := fSomaLinha(lin)
	oPrint:Say(lin,200,cNotMai)

	lin := fSomaLinha(lin)
	oPrint:Say(lin,200,cNotMen)

	oPrint:EndPage()
	lin := 100

	If aReturn[5] = 1
		oPrint:Preview()
	Else
		oPrint:Print()
	EndIf

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} fSomaLinha
Pula linha do relatório
@author  Vitor Bonet
@since   20/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Static Function fSomaLinha(lin)

	Local nValue := lin + 50

Return nValue