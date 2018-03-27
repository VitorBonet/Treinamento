#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} EXERC05
MarkBrow em MVC da tabela de Alunos
@author  Vitor Bonet
@since   22/03/2018
@version p12
@obs Criar a coluna ZZ1_OK com o tamanho 2 no Configurador e deixar como não usado
/*/
//-------------------------------------------------------------------
Function EXERC05()
    Private oMark

    //Criando o MarkBrow
    oMark := FWMarkBrowse():New()
    oMark:SetAlias('ZB2')

    //Setando semáforo, descrição e campo de mark
    oMark:SetSemaphore(.T.)
    oMark:SetDescription('Seleção do Cadastro de Alunos')
    oMark:SetFieldMark( 'ZB2_OK' )

    //Ativando a janela
    oMark:Activate()
Return NIL

Static Function MenuDef()
    Local aRotina := {}

    //Criação das opções
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.EXERC02' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.EXERC02' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Processar'  ACTION 'u_zMarkProc'     OPERATION 2 ACCESS 0
Return aRotina

// Chama o MenuDef da EXERC02
Static Function ModelDef()
Return FWLoadModel('EXERC02')

// Chama o ViewDef da EXERC02
Static Function ViewDef()
Return FWLoadView('EXERC02')

//-------------------------------------------------------------------
/*/{Protheus.doc} zMarkProc
Rotina para processamento e verificação de quantos registros estão marcados
@author Vitor de Sousa Bonet
@since 22/03/2018
@version p12
/*/
//-------------------------------------------------------------------
User Function zMarkProc()
    Local aArea    := GetArea()
    Local cMarca   := oMark:Mark()
    Local lInverte := oMark:IsInvert()
    Local nCt      := 0

    //Percorrendo os registros da ZB2
    ZB2->(DbGoTop())
    While !ZB2->(EoF())
        //Caso esteja marcado, aumenta o contador
        If oMark:IsMark(cMarca)
            nCt++

            //Limpando a marca
            RecLock('ZB2', .F.)
                ZB2_OK := ''
            ZB2->(MsUnlock())
        EndIf

        //Pulando registro
        ZB2->(DbSkip())
    EndDo

    //Mostrando a mensagem de registros marcados
    MsgInfo('Foram marcados <b>' + cValToChar( nCt ) + ' artistas</b>.', "Atenção")

    //Restaurando área armazenada
    RestArea(aArea)
Return NIL