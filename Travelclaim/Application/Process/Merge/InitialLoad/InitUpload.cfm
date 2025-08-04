<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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


















