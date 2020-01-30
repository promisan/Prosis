
<cf_screentop html="No" scroll="Yes">

<cf_dialoglookup>
<cf_dialogStaffing>

<cfoutput>
<script language="JavaScript">

w = #CLIENT.width# - 60;
h = #CLIENT.height# - 80;
		
function showdocument(vacno) {
	 window.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}

</script>
</cfoutput>

<cfparam name="URL.Lay" default="Officer">
<cfparam name="URL.page" default="1">

<cfparam name="CLIENT.Sort" default="HierarchyOrder">
<cfif #CLIENT.Sort# neq "HierarchyOrder" and
	  #CLIENT.Sort# neq "OccupationalGroup">
	  <cfset deleted = deleteClientVariable("Sort")>
</cfif>   
<cfparam name="CLIENT.Sort" default="HierarchyOrder">
<cfparam name="URL.Sort" default="#CLIENT.Sort#">
<cfset #CLIENT.sort# = #URL.Sort#>

<cfif URL.Sort eq "HierarchyOrder"> 
		<cfset orderby = "R.HierarchyOrder, GD.ListingOrder, F1.FunctionId, F.FunctionDescription">
<cfelse> 
        <cfset orderby = "F.OccupationalGroup, GD.ListingOrder">	
</cfif> 

<cfparam name="CLIENT.FunctionS" default=""> 

<cfquery name="FunctionAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     F.FunctionNo, F.FunctionDescription, F.FunctionRoster,
           R.OrganizationDescription, F1.FunctionId, R.HierarchyOrder, 
           GD.Description AS GradeDeploymentDescription, 
		   F1.SubmissionEdition, 
		   F1.OrganizationCode, G.Description, F.OccupationalGroup, F1.ReferenceNo, F1.DocumentNo, 
		   GD.GradeDeployment,  GD.ListingOrder
FROM       FunctionTitle F INNER JOIN
           FunctionOrganization F1 ON F.FunctionNo = F1.FunctionNo INNER JOIN
           Ref_Organization R ON F1.OrganizationCode = R.OrganizationCode INNER JOIN
           Ref_GradeDeployment GD ON F1.GradeDeployment = GD.GradeDeployment INNER JOIN
		   OccGroup G ON G.OccupationalGroup = F.OccupationalGroup
WHERE F1.SubmissionEdition = '#URL.ID#'	
ORDER BY #orderby#
</cfquery>

 <cfquery name="AccessLevels" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT 	*
	 FROM 		Ref_AuthorizationRole 		
	 WHERE 		Role = 'RosterClear' 
</cfquery>
	
<cfset accessLabel = ListToArray(AccessLevels.accesslevelLabelList)>	

<cfset label = accessLabel[url.id1+1]>

<cfquery name="Count" dbtype="query">
   SELECT     DISTINCT #URL.Sort#
   FROM       FunctionAll
</cfquery>
   
   <cfoutput>
   
<script>

function reloadForm(page,sort,layout,mandate,mission) {
  window.location="ControlListing.cfm?Mode=access&ID=#URL.ID#&ID1=#URL.ID1#&Page=" + page + "&Sort=" + sort + "&Lay=" + layout;
}

function Process(action) {
	if (confirm("Do you want to " + action + " selected records ?")) {return true; } {return false} }


function listing(id,act,row) {
  
	 icM  = document.getElementById(row+"Min")
	 icE  = document.getElementById(row+"Exp")
	 se   = document.getElementById(row);
	 frm  = document.getElementById("i"+row);
	 		 
	 if (act=="show") {
	   	 icM.className = "regular";
	     icE.className = "hide";
    	 se.className  = "regular";
 		 window.open("ControlListingDetail.cfm?mode=access&now=#now()#&ID="+id+"&Status=#URL.ID1#&FunctionId="+id+"&row="+row, "i"+row);
	
   	 } else {
	   	 icM.className = "hide";
	     icE.className = "regular";
     	 se.className  = "hide"
	 }
		 		
  }

</script>	
</cfoutput>

<input type="hidden" name="ID" value="<cfoutput>#URL.ID#</cfoutput>">
<input type="hidden" name="page1" value="<cfoutput>#URL.Page#</cfoutput>">
<input type="hidden" name="lay" value="<cfoutput>#URL.Lay#</cfoutput>">

<table width="95%" align="center" cellspacing="0" cellpadding="0">

  <tr><td height="10"></td></tr>	
  <tr>
    <td height="23" class="labellarge">
	
    	<cfoutput>
		#URL.ID#: #Label#
		</cfoutput>	
		
	</td>
	
	<td height="35" align="right">
		
	<select name="sort" class="regularxl" size="1" onChange="javascript:reloadForm(page.value,this.value,layout.value)">
	     
	     <OPTION value="HierarchyOrder" <cfif URL.Sort eq "HierarchyOrder">selected</cfif>><cf_tl id="Group by Organization">
		 <OPTION value="OccupationalGroup" <cfif URL.Sort eq "OccupationalGroup">selected</cfif>>
		 <cf_tl id="Group by Occupational group">
	     
	</SELECT>	
	
    <select name="layout" class="regularxl" size="1" onChange="javascript:reloadForm(page.value,sort.value,this.value)">
	     <OPTION value="Listing" <cfif URL.Lay eq "Listing">selected</cfif>>
		 <cf_tl id="Function Listing">	
	</select>	 

    <cf_PageCountH recordcount="#count.recordCount#" records="6">
	
    <select name="page" class="regularxl" size="1" onChange="javascript:reloadForm(this.value,sort.value,layout.value)">
      <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
      </cfloop>	 
    </SELECT>   	

    </TD>
</tr>
  
<tr>
 
<td width="100%" colspan="2">
  
<table cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">

<tr><td colspan="8" class="line"></td></tr>
<TR>
    <TD></TD>
    <TD width="30"></TD>
    <td width="50%"><cf_tl id="Function"></td>
	<TD class="labelit"><cf_tl id="Occ. group"></TD>
	<td class="labelit"><cf_tl id="Roster"></td>
    <TD class="labelit"><cf_tl id="Level"></TD>
	<td class="labelit"></td>
	<td class="labelit"><cf_tl id="Vac no."></td>
</TR>

<cfoutput query="FunctionAll" group="#URL.Sort#" 
startrow="#firstrow#" maxrows="#no#">

<cfswitch expression="#URL.Sort#">


<cfcase value="OccupationalGroup">
   <tr><td colspan="8" class="linedotted"></td></tr>
   <tr><td colspan="8" style="padding:3px" class="labelmediumcl"><b>&nbsp;&nbsp;#Description#</b></td></TR>
   <tr><td colspan="8" class="linedotted"></td></tr>
</cfcase>
<cfcase value="HierarchyOrder">
   <tr><td colspan="8" class="linedotted"></td></tr>
   <TR><td colspan="8" style="padding:3px" class="labelmediumcl"><b>&nbsp;&nbsp;#OrganizationDescription#</b></td></TR>
   <tr><td colspan="8" class="linedotted"></td></tr>
</cfcase>

</cfswitch>

<CFOUTPUT>

<tr>

    <td width="20" class="labelit">&nbsp;#CurrentRow#</td>
    <td width="20" height="20" class="regular" style="padding-right:9px">
		
		    <img src="#SESSION.root#/Images/ct_collapsed.gif" alt="" 
				name="#currentRow#Exp" id="#currentRow#Exp" 
				border="0" 
				align="right" class="regular" style="cursor: pointer;" 
				onClick="listing('#FunctionId#','show','#currentRow#')">
					   
			<img src="#SESSION.root#/Images/ct_expanded.gif" 
				name="#currentRow#Min" id="#currentRow#Min" alt="" border="0" 
				align="right" class="hide" style="cursor: pointer;" 
				onClick="listing('#FunctionId#','hide','#currentRow#')">
	    		
				
	</td>	
	<TD class="labelit">#FunctionDescription#</TD>
	<TD class="labelit">#Description#</TD>
	<TD class="labelit"><cfif #FunctionRoster# eq "0">No</cfif></TD>
    <TD class="labelit">#GradeDeploymentDescription#</TD>

	<cfif ReferenceNo neq "Direct">
	
	 <cfif DocumentNo eq "">
	 <td height="20"></td>
	 <td class="labelit"><a href="javascript:va('#FunctionId#');">#ReferenceNo#&nbsp;</a></td>
	 <cfelse>
	 <td class="labelit"><img src="#SESSION.root#/Images/alert.JPG" alt="Recruitment request" width="11" height="11" border="0" align="middle" style="cursor: pointer;" onClick="javascript:showdocument('#DocumentNo#');"></td>
 	 <td class="labelit"><a href="javascript:showdocument('#DocumentNo#');">#ReferenceNo#</a>&nbsp;</td>
	 </cfif>	
	
	</cfif>
		
</TR>

<tr>
	<td colspan="8">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td height="2"></td></tr>
	
	<tr class="hide" id="#currentrow#">
	   <td>
	    <table width="100%" border="0">
		     <iframe name="i#currentrow#" id="i#currentrow#" width="100%" height="40" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0"></iframe>
		</table> 
	   </td>
	</tr>
		   		  
    </table>
	
    </td>
</tr>

<tr><td colspan="8" style="border-top:1px dotted silver"></td></tr>

</CFOUTPUT>

</cfoutput>

</table>

</td></tr>

</Table>
