<cfquery name="SearchResult"
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	A.*,
				(SELECT Description FROM Ref_TimeClass WHERE TimeClass = A.ActionParent) as ActionParentDescription
		FROM 	Ref_WorkAction A
		ORDER BY A.ActionParent ASC, A.ListingOrder ASC
</cfquery>

<table class="navigation_table formpadding" width="97%" cellspacing="0" cellpadding="0" align="center" >

<tr class="labelheader line">
	<td width="25"></td>
	<td width="25"></td>
    <td align="left"><cf_tl id="Action"></td>
	<td align="left"><cf_tl id="Description"></td>
	<td align="center"><cf_tl id="Order"></td>
	<td align="center"><cf_tl id="Color"></td>
	<td align="center"><cf_tl id="Program Lookup"></td>
	<td align="center"><cf_tl id="Operational"></td>
    <td align="left"><cf_tl id="Entered"></td>
</tr>

<cfoutput query="SearchResult" group="ActionParent">

	<tr class="linedotted">
		<td colspan="9" style="height:40px" class="labellarge">#ActionParentDescription#</td>
	</tr>	
	
	<cfoutput>
    
	    <tr class="navigation_row linedotted labelmedium"> 
			<td align="right">
				<cfquery name="validate"
					datasource="appsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT 	'1'
						FROM 	PersonWorkDetail
						WHERE	ActionClass = '#ActionClass#'
						UNION ALL
						SELECT 	'1'
						FROM 	PersonWorkSchedule
						WHERE	ActionClass = '#ActionClass#'
				</cfquery>
				<cfif validate.recordcount eq 0>
					<cf_img icon="delete" onclick="recordpurge('#ActionClass#');">
				</cfif>
			</td>
			<td>
				<cf_img icon="open" onclick="recordedit('#ActionClass#')" navigation="Yes">
			</td>
			<td>#ActionClass#</td>
			<td>#ActionDescription#</td>
			<td align="center">#ListingOrder#</td>
			<td align="center">
				<table>
					<tr>
						<td height="15" width="15" title="#ViewColor#" style="background-color:#ViewColor#; border: 1px solid ##C0C0C0;"></td>
					</tr>
				</table>
			</td>
			<td align="center"><cfif ProgramLookup eq 1>Yes<cfelse><b>No</b></cfif></td>
			<td align="center"><cfif Operational eq 1>Yes<cfelse><b>No</b></cfif></td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			
	    </tr>
	
	</cfoutput>
	
</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>