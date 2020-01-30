
<cf_screentop height="100%" jquery="Yes" html="No">

<!--- clear the view which was generate for this user already --->

<CF_DropTable dbName="AppsQuery"  tblName="lsLedger_#SESSION.acc#">	

<cf_listingscript>

<table height="100%" width="100%">
<tr><td height="100%" style="padding-left:4px;padding-right:4px">
<cfinclude template="JournalTransactionListingContent.cfm">
</td></tr></table>
