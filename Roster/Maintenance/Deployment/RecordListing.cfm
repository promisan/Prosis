<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD><TITLE>Deployment Maintenance</TITLE></HEAD>

<body>

<cf_divscroll>

<cfset Header = "Deployment Level">
<cfinclude template="../HeaderRoster.cfm"> 
 
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

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<thead>
	<tr class="labelmedium">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Parent</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>


<tbody>
   
	
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
	
	 <tr><td colspan="6" class="labellarge" style="padding-left:10px;padding:5px">
	 The following staff budget grades were not been covered in a recruitment grade listed below: <cfoutput query="Check">#PostGradeBudget#,</cfoutput>
	 </td>
	 </tr>
	
	</cfif>
	
	</td></tr>
	<cfoutput query="SearchResult" group="PostGradeBudget">
		<tr><td colspan="5" style="height:40px" class="labellarge"><b>#Exist#</td></tr>
	
		<cfoutput>
	    <tr class="labelmedium navigation_row"> 
			<td width="6%" align="center">
				  <cf_img icon="open" onclick="recordedit('#Gradedeployment#')" navigation="Yes">
			</td>	
			<td>&nbsp;<a href="javascript:recordedit('#Gradedeployment#')">#Gradedeployment#</a></td>
			<td>#Description#</td>
			<td>#PostGradeParent#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		</cfoutput>
	</cfoutput>
</tbody>

</table>

</cf_divscroll>

</BODY></HTML>

