<!--
    Copyright © 2025 Promisan

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
<!--- Create Criteria string for query from data entered thru search form --->

 
<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *, 
	          B.PostGradeBudget AS Exist
	FROM      Ref_GradeDeployment R LEFT OUTER JOIN
              Employee.dbo.Ref_PostGradeBudget B ON R.PostGradeBudget = B.PostGradeBudget
	ORDER BY  B.PostGradeBudget, ListingOrder	   
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table style="height:100%;width:98%" align="center">

<tr><td style="height:10">

<cfset Header = "Deployment Level">
<cfinclude template="../HeaderRoster.cfm"> 

</td>
</tr>

<cfoutput>
	
	<script language = "JavaScript">	
		function recordadd(grp) {
	          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=460, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
		function recordedit(id1) {
	          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=460, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
	</script>	

</cfoutput>


<tr><td style="height:100%">

<cf_divscroll>

<table width="97%" align="center" class="navigation_table formpadding">

	<tr class="labelmedium2 line fixrow">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Parent</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
   	
		<cfquery name="check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Employee.dbo.Ref_PostGradeBudget
	WHERE     PostGradeBudget NOT IN
    	                      (SELECT     PostGradeBudget
        	                    FROM          Ref_GradeDeployment)
	</cfquery>
	
	<cfif check.recordcount gte "1">
	
	 <tr class="fixrow2"><td colspan="6" class="labellarge" style="padding-left:10px;padding:5px">
	 The following staff budget grades were not been covered in a recruitment grade listed below: <cfoutput query="Check">#PostGradeBudget#,</cfoutput>
	 </td>
	 </tr>
	
	</cfif>
	
	</td></tr>
	<cfoutput query="SearchResult" group="PostGradeBudget">
		<tr><td colspan="5" style="height:40px" class="labellarge"><b>#Exist#</td></tr>
	
		<cfoutput>
	    <tr class="labelmedium2 navigation_row line"> 
			<td width="6%" align="center">
				  <cf_img icon="open" onclick="recordedit('#Gradedeployment#')" navigation="Yes">
			</td>	
			<td style="padding-left:4px"><a href="javascript:recordedit('#Gradedeployment#')">#Gradedeployment#</a></td>
			<td>#Description#</td>
			<td>#PostGradeParent#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		</cfoutput>
	</cfoutput>

	</table>

	</cf_divscroll>
	
	
</td>
</tr>
</table>


