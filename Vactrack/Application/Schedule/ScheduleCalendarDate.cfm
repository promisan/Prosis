	
<!--- shows the information for the date as to how many are pending for that date --->
	
<cftry>
		
		<table width="98%" align="center">
		
			<cfquery name="get"
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Document
				WHERE     Mission = '#url.mission#'
				AND       CAST(Created AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'										
			</cfquery>
			
			<cfoutput query="get">
				<tr class="labelit fixlengthlist" style="height:20px">	
				<td style="min-width:5px;max-width:5px;background-color:yellow"></td>			
				<td style="height:10px;padding-left:2px"><a href="javascript:showdocument('#DocumentNo#')">#DocumentNo#:</a></td>			
				<td align="right" style="height:10px;padding-left:2px;padding-right:4px;">#officerUserLastName#</td>
				</tr>			
			</cfoutput>			
			
			<cfquery name="get"
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      Document
				WHERE     Mission = '#url.mission#'
				AND       CAST(StatusDate AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'							
			</cfquery>
			
			<cfoutput query="get">
				<tr class="labelit fixlengthlist" style="height:20px">	
				    <cfif status eq "9">	
				    <td style="min-width:5px;max-width:5px;background-color:red"></td>	
					<cfelse>
					<td style="min-width:5px;max-width:5px;background-color:green"></td>	
					</cfif>
					<td style="height:10px;padding-left:2px">					
					<a href="javascript:showdocument('#DocumentNo#')">#DocumentNo#:</a>
					</td>			
					<td align="right" style="height:10px;padding-left:2px;padding-right:4px;">#StatusofficerLastName#</td>
				</tr>			
			</cfoutput>
		
		</table>			
	
	<cfcatch>
	
	      <table><tr><td><font color="FF0000">problem</font></td></tr></table>
	
	</cfcatch>
	
</cftry>
