
<cfquery name="Delete" 
	     datasource="#alias#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM JournalBatch
		 WHERE Journal = '#URL.Journal#'
		 AND JournalBatchNo = '#URL.id2#'
</cfquery>

<cfset url.id2 = "">
<cfinclude template="BatchPeriodList.cfm">


<cfoutput>
<script>
 parent.batchrefresh('#URL.Journal#')
</script>
</cfoutput>

