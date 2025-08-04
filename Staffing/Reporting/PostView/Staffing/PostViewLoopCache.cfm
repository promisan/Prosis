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
