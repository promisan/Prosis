<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfoutput>
<cf_dialogLedger>	
<cf_dialogPosition>
<cf_dialogOrganization>

<script language="JavaScript">

function reloadForm(filter,group,page) {
		 
     url =  "#SESSION.root#/Gledger/Application/Inquiry/TransactionListing.cfm?description=listing&ID=" + group + "&Page=" + page + "&ID2=" + filter;	 		 
	 ColdFusion.navigate(url,'details')		
	
}

</script>

</cfoutput>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Gledger">

<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 SELECT H.Mission,
        P.*, 
		(CAST(
					FLOOR(
						CAST(
							h.created
							AS FLOAT
							)
						)
						AS DATETIME
						)
						) AS Posted,
		G.Description as GLAccountName, 
		G.AccountGroup, 
		S.Description as AccountGroupName, 
		J.Description as JournalName
 	INTO UserQuery.dbo.#SESSION.acc#Gledger
	FROM TransactionHeader H, 
	     TransactionLine P, 
		 Ref_Account G, 
		 Ref_AccountGroup S, 
		 Journal J
	WHERE J.Journal = P.Journal
	AND  H.Journal = P.Journal
	AND  H.JournalSerialNo = P.JournalSerialNo
	AND  P.GLAccount = G.GLAccount
	AND  S.AccountGroup = G.AccountGroup
	AND  H.ReferenceOrgUnit  = '#url.orgunit#'     	
</cfquery>

<cfdiv id="details">
	<cfinclude template="../../../../Gledger/Application/Inquiry/TransactionListing.cfm">
</cfdiv>
