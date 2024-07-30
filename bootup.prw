#include "protheus.ch"

/*/{Protheus.doc} BOOTUPITEM
	Cadastros iniciais item contabil
	@author thiago.barros
	@since 24/07/2024
	@type user function
/*/
user function BOOTUPITEM()
	local aArea := GetArea()

	DbSelectarea("CTD")
	CTD->(DbSetOrder(1))
    
	// bootup fornecedores

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DBGoTop())

	while SA2->(!Eof())
		FornAdd(SA2->A2_COD, SA2->A2_LOJA)
		DbSkip()
	enddo

	// bootup clientes

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DBGoTop())

	while SA1->(!Eof())
		CltAdd(SA1->A1_COD, SA1->A1_LOJA)
		DbSkip()
	enddo

	RestArea(aArea)
	FWAlertSucess("Item criados!")
return nil

static function FornAdd(cCod,cLoja)
	local aArea := GetArea()
	If !CTD->(DbSeek(FWxFilial("CTD") + 'F' + cCod + cLoja))
		RecLock("CTD", .T.)
		CTD->CTD_FILIAL := XFILIAL("CTD")
		CTD->CTD_ITEM   := 'F' + cCod + cLoja
		CTD->CTD_DESC01 := SA2->A2_NOME
		CTD->CTD_CLASSE := "2" // Classe - Analitico
		CTD->CTD_NORMAL := "0"  // Cond normal - Nenhum
		CTD->CTD_BLOQ   := "2" // Item bloq? - Não
		CTD->CTD_DTEXIS := CTOD("01/01/2023") // Data ini exist
		CTD->CTD_ITLP   := 'F' + cCod + cLoja // Item LP
		CTD->CTD_CLOBRG := "2" // CI Vlr Obrig
		CTD->CTD_ACCLVL := "1" // AC CI Valor
		CTD->(MsUnLock())
	Endif
	RestArea(aArea)
return nil

static function CltAdd(cCod, cLoja)
    local aArea := GetArea()
	If !CTD->(DbSeek(FWxFilial("CTD") + 'C' + cCod + cLoja))
		RecLock("CTD", .T.)
		CTD->CTD_FILIAL := XFILIAL("CTD")
		CTD->CTD_ITEM   := 'C' + cCod + cLoja
		CTD->CTD_DESC01 := SA1->A1_NOME
		CTD->CTD_CLASSE := "2" // Classe - Analitico
		CTD->CTD_NORMAL := "0"  // Cond normal - Nenhum
		CTD->CTD_BLOQ   := "2" // Item bloq? - Não
		CTD->CTD_DTEXIS := Date() //CTOD("01/01/1980") // Data ini exist
		CTD->CTD_ITLP   := 'C' + cCod + cLoja // Item LP
		CTD->CTD_CLOBRG := "2" // CI Vlr Obrig
		CTD->CTD_ACCLVL := "1" // AC CI Valor
		CTD->(MsUnLock())
	Endif
    RestArea(aArea)
return nil
