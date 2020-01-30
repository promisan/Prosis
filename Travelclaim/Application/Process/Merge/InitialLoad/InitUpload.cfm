<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_claim1">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_claim2">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_claim2o">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_claim2f">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_claim2p">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_Person">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="temp_IMP_DSARATE">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_tvlm">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_tvli">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_ref1">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_ref2">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_ref3">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="tmp_ref4">

<cfloop index="itm" list="IMP_ClaimReq,IMP_ClaimReqLine,IMP_Claim,IMP_ClaimLine,IMP_PersonBank,IMP_PayGroup" delimiters=",">
	
	<cfquery name="step1" 
	datasource="appsTravelClaim" >
	UPDATE #itm# SET f_prsn_index_num = ('0' + f_prsn_index_num)
	WHERE (UPPER(f_prsn_index_num)  LIKE '_____') 
	</cfquery>
	
	<cfquery name="step2" 
	datasource="appsTravelClaim" >
	UPDATE #itm# SET f_prsn_index_num = ('00' + f_prsn_index_num)
	WHERE (UPPER(f_prsn_index_num)  LIKE '____') 
	</cfquery>
	
	<cfquery name="step3" 
	datasource="appsTravelClaim" >
	UPDATE #itm# SET f_prsn_index_num = ('000' + f_prsn_index_num)
	WHERE (UPPER(f_prsn_index_num)  LIKE '___') 
	</cfquery>
	
	<cfquery name="step4" 
	datasource="appsTravelClaim" >
	UPDATE #itm# SET f_prsn_index_num = ('0000' + f_prsn_index_num)
	WHERE (UPPER(f_prsn_index_num)  LIKE '__') 
	</cfquery>
	
	<cfquery name="step5" 
	datasource="appsTravelClaim" >
	UPDATE #itm# SET f_prsn_index_num = ('00000' + f_prsn_index_num)
	WHERE (UPPER(f_prsn_index_num)  LIKE '_') 
	</cfquery>

</cfloop>


















