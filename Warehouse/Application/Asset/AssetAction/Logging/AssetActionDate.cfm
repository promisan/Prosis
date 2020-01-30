<cfquery name="actions" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	AssetItemAction
		WHERE	ActionDate = '#dateformat(url.calendardate,client.dateSQL)#'
</cfquery>

<!---- 
	AND     ActionCategory = '#url.mission#'
--->		

<cfif actions.recordcount EQ 0>										  						   
	
<cfelse>	
   													
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
																			
		<cfoutput query="actions">		
		<tr>								
		  <td align="center" >
				<span style="line-height:10px; font-size:10px;">xx</span>
		  </td>
		</tr>
		</cfoutput>

	</table>
																
</cfif>
							