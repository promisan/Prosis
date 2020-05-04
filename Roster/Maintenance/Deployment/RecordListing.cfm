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


<table style="height:100%;width:100%">

<tr><td style="height:10">

<cfset Header = "Deployment Level">
<cfinclude template="../HeaderRoster.cfm"> 

</td>
</tr>

<cfoutput>
	
	<script language = "JavaScript">	
		function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=460, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
		function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=460, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
	</script>	

</cfoutput>


<tr><td style="height:100%">

<cf_divscroll>

<table width="97%" align="center" class="navigation_table formpadding">

	<tr class="labelmedium line fixrow">
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
	    <tr class="labelmedium navigation_row line"> 
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


