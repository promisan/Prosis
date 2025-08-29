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
	 <proCom> 21/11/2008: added person, Staffmember, e-mail address, traveller org (in update of TravelClaim DB)</proCom>
</cfsilent>

<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimReq">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimReqEO">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimAdvance">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimReqLine">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimReqLineDetail">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimReqLineFund">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimReqTicket">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimReqDSA">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_DSALocation">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_Claim">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimLine">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_ClaimOffset">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_Exchange">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_DSARate">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_PersonBank">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_City">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_stfund">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_Paygroup">
<!--- MKM -June 27, 2008 - Added additional tables for the new stPerson table  --->
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_Person">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_StaffMember">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_CLAIMREQ_TRAVELLER_ORG">
<CF_DropTable dbName="appsTravelClaim"  full="1" tblName="IMP_email_address">

<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMREQ">	
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMREQEO">	
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMADVANCE">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMREQLINE">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMREQLINEDETAIL">	
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMREQLINEFUND">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMREQTICKET">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMREQDSA">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_DSALocation">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_DSARate">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_PERSONBANK">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIM">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMLINE">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMOFFSET">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CITY">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_EXCHANGE">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_stFund">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_Paygroup">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_Person">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_StaffMember">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_CLAIMREQ_TRAVELLER_ORG">
<CF_CopyTable from="#srvdw#.#dbdw#" DS_TO="appsTravelClaim"  tblName="IMP_email_address">