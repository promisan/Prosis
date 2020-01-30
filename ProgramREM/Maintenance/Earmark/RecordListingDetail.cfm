<cfquery name="SearchResult"
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
		FROM 	Ref_Earmark
</cfquery>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td width="20px"></td>
	    <td width="25px"></td>
	    <td><cf_tl id="Earmark"></td>
		<td><cf_tl id="Description"></td>
	    <td><cf_tl id="Entered"></td>
	</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">
    
    <tr class="navigation_row"> 
		
		<cfquery name="validate"
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	'1'
				FROM 	Contribution
				WHERE	Earmark = '#Earmark#'
		</cfquery>


		<td align="left">
			<cfif validate.recordCount eq 0>
				<cf_img icon="delete" onclick="recordpurge('#Earmark#');">
		    </cfif>
		</td>

	    <td align="left" class="navigation_action"  onclick="recordedit('#Earmark#');">
			<cf_img icon="open" onclick="recordedit('#Earmark#');">
		</td>
			
		</td>
		<td>#Earmark#</td>
		<td>#Description#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		
    </tr>

</cfoutput>
</tbody>

</table>

<cfset AjaxOnLoad("doHighlight")>
