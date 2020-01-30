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