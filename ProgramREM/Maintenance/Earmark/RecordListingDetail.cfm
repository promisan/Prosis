<cfquery name="SearchResult"
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
		FROM 	Ref_Earmark
</cfquery>

<table width="97%" align="center" class="navigation_table">

	<tr class="line labelmedium2">
	    <td style="max-width:20px"></td>
	    <td style="max-width:25px"></td>
	    <td><cf_tl id="Earmark"></td>
		<td><cf_tl id="Description"></td>
	    <td><cf_tl id="Entered"></td>
	</tr>

	<cfoutput query="SearchResult">
	    
	    <tr class="labelmedium2 navigation_row line"> 
			
			<cfquery name="validate"
				datasource="appsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	'1'
					FROM 	Contribution
					WHERE	Earmark = '#Earmark#'
			</cfquery>
	
	
		    <td style="width:20px;padding-top:3px" class="navigation_action"  onclick="recordedit('#Earmark#');">
				<cf_img icon="open">
			</td>
			
			<td style="width:20px;padding-top:3px">
				<cfif validate.recordCount eq 0>
					<cf_img icon="delete" onclick="recordpurge('#Earmark#');">
			    </cfif>
			</td>
				
			</td>
			<td>#Earmark#</td>
			<td>#Description#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			
	    </tr>
	
	</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>
