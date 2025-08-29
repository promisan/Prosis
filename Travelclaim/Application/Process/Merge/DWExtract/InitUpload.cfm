<!--
    Copyright © 2025 Promisan B.V.

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
<cfsilent>
	 <proOwn>MKM</proOwn>
	 <proCom> added person, Staffmember, e-mail address (warehouse travelclaims) </proCom>
</cfsilent>

<CF_DropTable dbName="#DSNDW#"  full="1" tblName="tmp_scope1">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimReq">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimReqEO">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimAdvance">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimReqLine">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimReqLineDetail">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimReqLineFund">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimReqTicket">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimReqDSA">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_DSALocation">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="tmp_claim">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="tmp_claim2">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_Claim">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimLine">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_ClaimOffset">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_Exchange">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="tmp_dsa">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_DSARate">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="tmp_bank">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_PersonBank">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_CLAIMREQ_TRAVELLER_ORG">
<!--- disabled not relevant anymore : Karl
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="tmp_address">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_PersonAddress">
--->
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_City">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_Paygroup">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_stfund">

<!--- MKM -June 27, 2008 - Added additional tables for the new stPerson table  --->
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_StaffMember">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_Person">
<CF_DropTable dbName="#DSNDW#"  full="1" tblName="IMP_email_address">