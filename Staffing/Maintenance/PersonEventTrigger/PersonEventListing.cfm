<cfquery name="SearchResult"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	T.*,
				(
					SELECT 	Description
					FROM 	Ref_PersonEvent
					WHERE	Code = T.EventCode
				) as EventDescription,
				(
					SELECT 	Description
					FROM 	Ref_PersonGroup
					WHERE	Code = T.ReasonCode
				) as ReasonDescription
		FROM 	Ref_PersonEventTrigger T INNER JOIN Ref_PersonEvent PE ON T.EventCode = PE.Code
		WHERE	T.EventTrigger = '#url.id1#'
		ORDER BY PE.ListingOrder
</cfquery>

<table width="100%" align="center" class="navigation_table">

	<tr class="labelmedium line fixlengthlist">
	    <td>
			<cfoutput>
				<a href="javascript:editPE('#url.id1#','')">[Add]</a>
			</cfoutput>
		</td> 
	    <td>Code</td>
		<td>Impact</td>
		<td>Reason</td>
	</tr>
	
	<cfoutput query="SearchResult">
	   
	    <tr height="20" class="labelmedium linedotted navigation_row fixlengthlist">
			<td style="padding-top:1px" id="processDeletePE"> 
				<table>
					<tr>
						<td>
							<cf_img navigation="Yes" icon="open" onclick="editPE('#url.id1#','#EventCode#')"> 
						</td>
						<td style="padding-left:5px; padding-right:5px;" width="30px">
							<cfquery name="CountRec" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT 	EventTrigger
									FROM 	PersonEvent
									WHERE 	EventTrigger  = '#id1#' 
									AND		EventCode = '#EventCode#'
							</cfquery>
							
							<cfif CountRec.recordCount eq 0>
								<cf_img icon="delete" onclick="deletePE('#url.id1#','#EventCode#')"> 
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
				</table>
				
			</td>		
			<td>#EventDescription#</td>
			<td>#ActionImpact#</td>
			<td>#ReasonDescription#</td>
	    </tr>
		
	</cfoutput>
	
</table>

<cfset AjaxOnLoad("doHighlight")>