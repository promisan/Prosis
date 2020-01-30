<cfif trim(url.indexNo) neq "">
	<cfquery name="valIndex" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Person
	    WHERE 	indexNo='#trim(url.indexNo)#'
	</cfquery>

	<cfif valIndex.recordCount gt 0>
		<span style="color:red; font-weight:bold;"><cf_tl id="The specified ID is registered already">.</span>
	</cfif>
	
</cfif>