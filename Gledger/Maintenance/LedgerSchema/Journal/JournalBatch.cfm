
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Journal
	WHERE  Journal = '#URL.journal#'	
</cfquery>

<cfquery name="Batch"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   JournalBatch
	WHERE  Journal = '#URL.Journal#'
</cfquery>
						
<select name="journalbatchno" class="regularxl">
 
        <cfoutput query="Batch">
      	   <option value="#JournalBatchNo#" <cfif get.JournalBatchNo eq JournalBatchNo>selected</cfif>>
      	   #JournalBatchNo# #Description#
	   </option>
     	</cfoutput>
	
</select>
		