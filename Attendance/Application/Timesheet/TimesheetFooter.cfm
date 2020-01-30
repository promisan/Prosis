
<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<table width="100%" align="center">

		<cfquery name="last" 
	         datasource="AppsEmployee" 
			 username="#SESSION.login#" 
             password="#SESSION.dbpw#">
				SELECT 	TOP 1 *
				FROM 	PersonWork
				WHERE	CalendarDate = #dte#
				AND     PersonNo = '#URL.ID#' 
				ORDER BY Created
		</cfquery>
				
		<cfif Last.recordcount neq "0">
			<cfoutput>			    
				<tr><td class="labelit" align="center">#last.officerlastname# on: #DateFormat(last.created,CLIENT.DateFormatShow)# #timeformat(last.created,"HH:MM:SS")#</td></tr>
			</cfoutput>
		</cfif>
				
		
</table>