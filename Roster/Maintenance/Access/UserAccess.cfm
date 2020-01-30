
<cf_screentop height="100%" scroll="yes" layout="webdialog" label="Roster Access">

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#"> 

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE UserNames
SET   Disabled = '0', 
      DisabledModified = getDate()
WHERE   Account = '#URL.ACC#' 
</cfquery>

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    UserNames
WHERE   Account = '#URL.ACC#' 
</cfquery>

<cfquery name="Officer" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT FunctionId AS Selected
INTO userQuery.dbo.tmp#SESSION.acc#
FROM    RosterAccessAuthorization
WHERE   UserAccount = '#URL.ACC#' 
AND     AccessLevel = '#URL.ID1#' 
</cfquery>

<cfquery name="OccGroup" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT OccupationalGroup, F1.SubmissionEdition
FROM    FunctionOrganization F1, FunctionTitle F
WHERE   FunctionId = '#URL.ID#' 
AND     F.FunctionNo = F1.FunctionNo 
</cfquery>

<cfquery name="FunctionAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT 
        F.FunctionNo, F.FunctionDescription, R.OrganizationDescription, F1.FunctionId, R.HierarchyOrder, Ref_GradeDeployment.Description AS GradeDeployment, 
        F1.SubmissionEdition, F1.OrganizationCode, A.Selected, F.OccupationalGroup, OccGroup.Description as OccGroupDescription,
		Ref_GradeDeployment.ListingOrder, F1.ReferenceNo, F1.DocumentNo
FROM    FunctionTitle F INNER JOIN
        FunctionOrganization F1 ON F.FunctionNo = F1.FunctionNo INNER JOIN
        Ref_Organization R ON F1.OrganizationCode = R.OrganizationCode INNER JOIN
        Ref_GradeDeployment ON F1.GradeDeployment = Ref_GradeDeployment.GradeDeployment INNER JOIN
        OccGroup ON F.OccupationalGroup = OccGroup.OccupationalGroup LEFT OUTER JOIN
        userQuery.dbo.tmp#SESSION.acc# A ON F1.FunctionId = A.Selected 
WHERE    F.OccupationalGroup = '#OccGroup.OccupationalGroup#' 
AND      F1.SubmissionEdition = '#OccGroup.SubmissionEdition#' 
ORDER BY F.OccupationalGroup, R.HierarchyOrder, Ref_GradeDeployment.ListingOrder, F.FunctionNo
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#"> 

<cfoutput>

<script language="JavaScript">

function va(fun)

{
		window.open(root + "/Vactrack/Application/Announcement/Announcement.cfm?ID="+fun, "_blank", "width=800, height=600, status=yes,toolbar=yes, scrollbars=yes, resizable=yes");
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld,rw){

	 
     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	
	 se2  = 'Sel_'+rw
	 var se  = document.getElementsByName(se2)
				 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	
	 se[0].value = "1";
	 
	 }else{
		
     itm.className = "regular";		
	 se[0].value = "0";
	 }
  }
  
  
function selectall(chk,val,pr)
{

var count=1;

var itm = new Array();
var fld = new Array();

while (count <= "#FunctionAll.recordcount#")
     
   {    
 	
			 
	 itm2  = 'Selected_'+count
	 se2  = 'Sel_'+count
	 var se  = document.getElementsByName(se2)
 	 var fld = document.getElementsByName(itm2)
	 var itm = document.getElementsByName(itm2)
		 	 
	 if (pr == "0")
	 {
	 
	 se[val].value = "1";
	 fld[val].checked = true;
		 			
     if (ie){
	      itm1=itm[val].parentElement; 
		  itm1=itm1.parentElement; 
		  }
     else{
          itm1=itm[val].parentElement; 
		  itm1=itm1.parentElement; }		
		
	 	
	 itm1.className = "highLight1";
	 window.roster.prior.value = "1";
    	 
	 }
	 
	 else
		 
	 {
	 
	 fld[val].checked = false;
	 se[val].value = "0";
		 			
     if (ie){
	      itm1=itm[val].parentElement; 
		  itm1=itm1.parentElement; 
		  }
     else{
          itm1=itm[val].parentElement; 
		  itm1=itm1.parentElement; }		
	 	
	 itm1.className = "regular";
	 window.roster.prior.value = "0";
	 	 
	 }
		
    count++;
   }	

}
 
</script> 

</cfoutput>

<cf_wait text="Retrieving buckets">

<!--- Entry form --->
<cfform action="UserAccessSubmit.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ACC=#URL.ACC#" method="POST" enablecab="No" name="roster">

<table width="100%"  cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">

<cfoutput>
  <td height="25"><b><font face="Verdana" size="2">&nbsp;Assign access to roster buckets for #Get.FirstName# #Get.LastName#</b>
</td></cfoutput>

<td align="right"></td>


<tr><td colspan="2">

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<TR>
    <td></td>
	<td><b>Area</td>
	<td><b>Function</td>
	<td><b>Grade</td>
	<td><b>VacNo</td>
	<TD align="center">
	<input type="hidden" name="prior" value="0"> 
	<input type="checkbox" name="ShowSelect" value="0" onClick="javascript:selectall(this.value,'0',prior.value)"> 
	</TD>
</TR>

<cfset Occ = "occw">
<cfset Fun = "">

<cfset CLIENT.recordNo = 0>

<cfoutput query="FunctionAll" group="OccupationalGroup">

<tr>
   <td bgcolor="DBEAEA"></td>
   <td height="15" colspan="6" bgcolor="DBEAEA">
        <b>&nbsp;#OccGroupDescription#</b>
   </td>
</tr>

<cfoutput group="HierarchyOrder">

<tr>
   <td bgcolor="f4f4f4"></td>
   <td height="20" colspan="6" bgcolor="f4f4f4">
        <b>&nbsp;#OrganizationDescription#</b>
   </td>
</tr>
 
<CFOUTPUT>

<cfset CLIENT.recordNo = #Client.recordNo# + 1>
<input type="hidden" name="actionid_#CLIENT.recordNo#" value="#FunctionId#">

<cfif #Fun# is not #FunctionNo#>
<tr><td colspan="6" class="line"></td></tr>
</cfif>

<cfif #Selected# eq "">
<TR bgcolor="FFFFFF">
<cfelse>
<TR class="highlight2">
</cfif>

	<td bgcolor="white"></td>
	<td bgcolor="white"></td>
	  
   	<TD bgcolor="white"><cfif #Fun# is not #FunctionNo#>#FunctionNo# #FunctionDescription#</cfif></TD>
	<TD bgcolor="white"><cfif #Fun# is not #FunctionNo#>#GradeDeployment#</cfif></TD>
	
	<td>&nbsp;<A href="javascript:va('#FunctionId#');">#ReferenceNo#</a>&nbsp;	</td>
	
	<td align="center">
	<cfif #Selected# eq "">
	<input type="hidden" name="Sel_#CLIENT.recordNo#" value="0">
	<input type="checkbox" name="Selected_#CLIENT.recordNo#" value="0" onClick="hl(this,this.checked,'#CLIENT.recordNo#')">
	<cfelse>
	<input type="hidden" name="Sel_#CLIENT.recordNo#" value="1">
	<input type="checkbox" name="Selected_#CLIENT.recordNo#" value="0" checked onClick="hl(this,this.checked,'#CLIENT.recordNo#')">
	</cfif>
	</td>
	
</TR>

<cfset Fun = #FunctionNo#>

</CFOUTPUT>
</CFOUTPUT>
<tr><td height="5" colspan="6"></td></tr>
</CFOUTPUT>

<tr>

<td colspan="6">
<table width="100%" cellspacing="0" cellpadding="0">
	<td align="center" valign="middle">
	<input type="button" class="button10g" value="Cancel" onClick="window.close()">
	<INPUT type="submit" class="button10g" value="Save">
	</td>
</table>
</td>
</tr>
</table>	

</tr>

</table>

</CFFORM>

<cf_screenbottom layout="webdialog">