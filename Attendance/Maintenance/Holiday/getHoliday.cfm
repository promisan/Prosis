<cfquery name="holiday" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Holiday
		WHERE	CalendarDate = '#dateformat(url.calendardate,client.dateSQL)#'
		AND     Mission     = '#url.mission#'
</cfquery>

<cfset maxk = holiday.recordcount>															

<cfif holiday.recordcount EQ 0>										  						   
	
<cfelse>	
   													
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
																			
		<cfoutput query="holiday">		
		<tr>								
		<cfif holiday.HoursHoliday gt "0" and Description neq "">
		  <td align="center">		  	
				<span style="line-height:10px; font-size:10px;">#Description#</span>			
		  </td>
		</cfif>											
		</tr>
		</cfoutput>

	</table>
																
</cfif>
							