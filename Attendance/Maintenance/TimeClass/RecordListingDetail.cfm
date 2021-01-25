<cfquery name="SearchResult"
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_TimeClass
		ORDER BY ListingOrder ASC
</cfquery>

<table width="97%" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding" align="center" >

<tr class="labelmedium2 line">
    <td width="20"></td>
	<td width="20"></td>
    <td><cf_tl id="Class"></td>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Short"></td>
	<td><cf_tl id="Sort"></td>
	<td><cf_tl id="Color"></td>
	<td><cf_tl id="Show in Attendance"></td>
    <td><cf_tl id="Entered"></td>
</tr>

<cfoutput query="SearchResult">
    
    <tr class="labelmedium2 navigation_row line"> 
		<td align="center">
			<cfquery name="validate"
				datasource="appsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	'1'
					FROM 	Ref_LeaveType
					WHERE	LeaveParent = '#TimeClass#'
					UNION ALL
					SELECT 	'1'
					FROM 	Ref_WorkAction
					WHERE	ActionParent = '#TimeClass#'
			</cfquery>
			<cfif validate.recordCount eq 0>
				<cf_img icon="delete" onclick="recordpurge('#TimeClass#');">
			</cfif>
		</td>
		<td align="center">
			<cf_img icon="open"  onclick="recordedit('#TimeClass#');" navigation="yes">
		</td>
		<td>#TimeClass#</td>
		<td>#Description#</td>
		<td>#DescriptionShort#</td>
		<td align="center">#ListingOrder#</td>
		<td align="center">
			<table>
				<tr>
					<td height="15" width="15" title="#ViewColor#" style="background-color:#ViewColor#; border: 1px solid ##C0C0C0;"></td>
				</tr>
			</table>
		</td>
		<td align="center"><cfif ShowInAttendance eq 1>Yes<cfelse><b>No</b></cfif></td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		
    </tr>

</CFOUTPUT>

</table>

<cfset AjaxOnLoad("doHighlight")> 