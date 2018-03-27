#Include "MNTR010.ch"
#Include "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} ESR002
Relátorio de Notas de Alunos
@author  Vitor Bonet
@since   19/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Function ESR002()

	Local oReport

	oReport := ReportDef()
	oReport:SetPortrait() //Default Retrato
	oReport:PrintDialog()

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportDef
Estrutura visual do Relatório (Layout)
@author  Vitor Bonet
@since   20/03/2018
@version p12
/*/
//-------------------------------------------------------------------
Static Function ReportDef()

	Local oSection1
	Local oSection2
	Local oCell

	/*/LAYOUT
		1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
		01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
		Matricula     Nome do Aluno                   Turma        Descrição Turma                  Matéria   Descrição Matéria                 Nota      Data       Cód. Prof.   Nome
		_____________________________________________________________________________________________________________________________________________________________________________________________________
		XXXXXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXX        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XXXXXX        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XX,XXX    99/99/99   XXXXXX       XXXXXXXXXXXXXXXXXXXXXXX

		Número de alunos    Número de Matérias    Número de Turmas    Nota mais alta    Nota mais Baixa
		_______________________________________________________________________________________________________________________________________________
		9999		        9999	              9999                9999              9999
	/*/

	oReport := TReport():New("ESR002",OemToAnsi("Relatório de listagem das notas do Aluno."),"ESR001",{|oReport| ReportPrint(oReport)},"Relatório de listagem das notas do Aluno.")  //"Transferência de Bens entre Filiais"###"Destina-se a imprimir as inconsistencias encontradas durante o processo de checagem dos registros relacionados a filial origem/destino"

	Pergunte(oReport:uParam,.F.)

	//seção superior
	oSection1 := TRSection():New( oReport,, "ZZ7" )

	oCell := TRCell():New(oSection1, "ZZ7_MATAL"		,"ZZ7"		,"Matricula"		,"999999999",15, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "cNomAL"			,""			,"Nome do Aluno"	,"@!" 		,30,/*lPixel*/,{|| cNomAL })
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "cTurma"			,""			,"Turma"			,"@!" 		,10, /*lPixel*/,{|| cTurma })
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "cDescT"			,""			,"Descrição Turma"	,"@!" 		,30, /*lPixel*/,{|| cDescT })
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "cMate"			,""			,"Matéria"			,"999999" 	,10, /*lPixel*/,{|| cMate })
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "cDescM"			,""			,"Descrição Matéria","@!" 		,30, /*lPixel*/,{|| cDescM })
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "ZZ7_NOTA"			,"ZZ7"		,"Nota"				,"@!" 		,5, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "ZZ7_DATA"			,"ZZ7"		,"Data"				,"" 		,8, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "cMatP"			,""			,"Matrícula Prof."	,"@!" 		,10, /*lPixel*/,{|| cMatP })
	oCell := TRCell():New(oSection1, ""					,""			,""					,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection1, "cNomeP"			,""			,"Nome Prof."		,"@!" 		,30, /*lPixel*/,{|| cNomeP })

	//seção inferior
	oSection2 := TRSection():New( oReport,, "ZZ7" )

	oCell := TRCell():New(oSection2, "nAlunos"			,""			,"Número de alunos"		,"@!"		,15, /*lPixel*/,{|| nAlunos })
	oCell := TRCell():New(oSection2, ""					,""			,""						,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection2, "nMater"			,""			,"Número de Matérias"	,"@!" 		,15,/*lPixel*/,{|| nMater })
	oCell := TRCell():New(oSection2, ""					,""			,""						,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection2, "nTurmas"			,""			,"Número de Turmas"		,"@!" 		,15, /*lPixel*/,{|| nTurmas })
	oCell := TRCell():New(oSection2, ""					,""			,""						,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection2, "nNotMai"			,""			,"Nota mais alta"		,"@!" 		,15, /*lPixel*/,{|| nNotMai })
	oCell := TRCell():New(oSection2, ""					,""			,""						,"@!" 		,2, /*lPixel*/,/*{|| code-block de impressao }*/)
	oCell := TRCell():New(oSection2, "nNotMen"			,""			,"Nota mais Baixa"		,"@!" 		,15, /*lPixel*/,{|| nNotMen })

Return oReport

//-------------------------------------------------------------------
/*/{Protheus.doc} ReportPrint
Alimenta o oReport com os dados e os arrays extras para exibição do Relatório
@author  Vitor Bonet
@since   20/03/2018
@version p12
/*/
//-------------------------------------------------------------------
static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local aLinha    := {} 	// array da linha do relatorio
	Local aTodLinh  := {}	// array de todas as linhas do relatorio
	Local aAlunos   := {}	// array de alunos
	Local aMater   	:= {}	// array de materias
	Local aTurmas   := {}	// array de turmas
	Local aNotas   	:= {}	// array de notas
	Local nNotAlta	:= 1	// nota mais alta
	Local nNotBaix	:= 1	// nota mais baixa
	Local nValor    := 1	// utilizado no for

	Processa({|lEND|},"Processando Arquivo...")  //"Processando Arquivo"

	lPVEZ := .T.

    dbSelectArea("ZZ7")
    dbSetOrder(01)
    dbSeek(xFilial("ZZ7") + MV_PAR01, .T.)

	// Varre dados do banco e faz a consulta utilizando os parametros como filtro
    While !Eof() .And. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .And.;
            ZZ7->ZZ7_MATAL >= MV_PAR01 .And. ZZ7->ZZ7_MATAL <= MV_PAR02

			dbSelectArea("ZZ6")
			dbSetOrder(1)
			If dbSeek(xFilial("ZZ6") + ZZ7->ZZ7_DISC)

				While !Eof() .And. ZZ7->ZZ7_FILIAL == xFilial("ZZ7") .And.;
            			ZZ6->ZZ6_CODMAT >= MV_PAR03 .And. ZZ6->ZZ6_CODMAT <= MV_PAR04 .And.;
						ZZ6->ZZ6_TURMA >= MV_PAR05 .And. ZZ6->ZZ6_TURMA <= MV_PAR06

					oReport:IncMeter()
					If lPVEZ = .T.
						oSection1:Init()
						lPVEZ := .F.
					EndIf
					aAdd(aLinha, ZZ7->ZZ7_MATAL) // adiciona dado no aLinha

					cNomAL	:= ZZ2->(VDISP(ZZ7->ZZ7_MATAL,"ZZ2_NOME"))
					aAdd(aLinha, cNomAL )

					cTurma	:= ZZ6->(VDISP(ZZ7->ZZ7_DISC,"ZZ6_TURMA"))
					aAdd(aLinha, cTurma )

					cDescT	:= ESA007INI("ZZ7_DESCT")
					aAdd(aLinha, cDescT )

					cMate	:= ZZ6->(VDISP(ZZ7->ZZ7_DISC,"ZZ6_CODMAT"))
					aAdd(aLinha, cMate)

					cDescM	:= ESA007INI("ZZ7_DESCM")
					aAdd(aLinha, cDescM)

					cMatP	:= ZZ6->(VDISP(ZZ7->ZZ7_DISC,"ZZ6_MAT"))
					aAdd(aLinha, cMatP)

					cNomeP 	:= ESA007INI("ZZ7_NOMEP")

					aAdd(aLinha, ZZ7->ZZ7_NOTA)
					aAdd(aLinha, ZZ7->ZZ7_DATA)

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

		oSection1:PrintLine()

		dbSelectArea("ZZ7")
		dbSkip()
    EndDo

	oSection2:Init()

	nAlunos		:= cValToChar(Len(aAlunos))
	nMater		:= cValToChar(Len(aMater))
	nTurmas		:= cValToChar(Len(aTurmas))
	nNotMai		:= cValToChar(aNotas[nNotAlta])
	nNotMen		:= cValToChar(aNotas[nNotBaix])

	oSection2:PrintLine()
	oSection2:Finish()

	oSection1:Finish()

Return .T.