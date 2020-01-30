		
<cfquery name="Parameter" 
	datasource="AppsSystem">
	SELECT * 
	FROM   Parameter 
</cfquery>

<cftry>
	
	<cfquery name="Check" 
		datasource="AppsEmployee">			
			SELECT 	*
			FROM   	userQuery.dbo.#SESSION.acc#Grade2_#FileNo# 		 
	</cfquery>
	
	<cftry>
		
		<cfquery name="CacheData" 
			datasource="AppsTransaction">
			DELETE FROM stCacheStaffingView
			WHERE       DocumentId = '#id#'  
		</cfquery>		
		
		<cftry>
		
			<cfquery name="CacheData" 
				datasource="AppsTransaction">
				INSERT INTO stCacheStaffingView 
							(DocumentId, #list#) 
				SELECT  	'#id#', #list#  
				FROM     	[#Parameter.DatabaseServer#].userQuery.dbo.#SESSION.acc#Grade2_#FileNo# 		 
			</cfquery>
		
			<cfcatch>
			
				<cfquery name="CacheData" 
					datasource="AppsTransaction">
					INSERT INTO stCacheStaffingView 
								(DocumentId, #list#) 
					SELECT  	'#id#', #list#  
					FROM     	userQuery.dbo.#SESSION.acc#Grade2_#FileNo# 		 
				</cfquery>
			
			</cfcatch>
				
		</cftry>
		
		<script>
			try {document.getElementById("errorbox").className = "hide"} catch(e) {}
		</script>
			
		<cfcatch>	
		
		<cfoutput>
			<table width="100%" cellspacing="0" cellpadding="0" align="center">
			<tr><td align="center">														
				 An error has occurred preserving the staffing data on the server <cfif getAdministrator("*") eq "1"><br>#CFCatch.Message# - #CFCATCH.Detail#</cfif>
			</td></tr>
			</table>				
		</cfoutput>		
				
		<script>
			try {document.getElementById("errorbox").className = "regular"} catch(e) {}
		</script>
			
		</cfcatch>
		
	</cftry>
	
	<cfcatch></cfcatch>

</cftry>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Position#FileNo#">		  	
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionViewT#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#PositionViewC#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_WhsStaffingPosition#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_WhsStaffingAssignment#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Grade1_#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Grade2_#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#TreeOrder#FileNo#">	

<cf_compression>
