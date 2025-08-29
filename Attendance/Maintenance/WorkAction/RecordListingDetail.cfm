<!--
    Copyright © 2025 Promisan B.V.

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

<tr class="labelmedium2 line">
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

	<tr class="line labelmedium2">
		<td colspan="9" style="height:40px" class="labellarge">#ActionParentDescription#</td>
	</tr>	
	
	<cfoutput>
    
	    <tr class="navigation_row line labelmedium2"> 
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
						<td height="15" width="15" title="#ViewColor#" style="background-color:#ViewColor#; border: 1px solid C0C0C0;"></td>
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