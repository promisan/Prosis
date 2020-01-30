
<cf_screentop height="100%" label="Function Title" 
  option="Maintain functional title" user="yes" html="no" banner="gray" bannerforce="Yes" layout="webapp" 
  close="parent.ColdFusion.Window.destroy('functionedit',true)"	
  band="no" 
  scroll="yes"> 

<cfajaximport tags="cfform,cfdiv,cfwindow">

<cf_dialogPosition>
<cf_filelibraryscript>

<cfquery name="Parameter"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM        Parameter
</cfquery>
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM FunctionTitle
	WHERE FunctionNo= '#URL.ID1#'
</cfquery>

<cfif Get.recordcount eq "0">

<table align="center"><tr><td height="40"><font color="FF0000">Title was removed.</font></td></tr></table>
<cfabort>

</cfif>

<cf_menuscript>

<cfoutput>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Functional Title?")) {
	   ptoken.navigate('RecordSubmit.cfm?action=delete','result','','','POST','formentry');
	}	
	return false	
}	

function maintain(id1){
    w = #CLIENT.width# - 80;
    h = #CLIENT.height# - 120;
    ptoken.open("FunctionGrade.cfm?idmenu=#url.idmenu#&ID=" + id1, "_blank", "left=30, top=30, width= " + w + ", height=" + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}

</script>

</cfoutput>

<table width="95%"
       border="0"
	   height="100%"
	   align="center"
	   cellspacing="0"
       cellpadding="0">
	
	<tr><td height="5"></td></tr>

	<tr>
		<td align="center" valign="top">
		
			<table width="100%" align="center">
				<tr>
				<cfset wd = "48">
				<cfset ht = "48">
				
				<cf_menutab item  = "1" 
			       iconsrc    = "Logos/Warehouse/ItemInfo.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   class      = "highlight1"
				   name       = "General Information"
				   source     = "RecordEditGeneral.cfm?id1=#url.id1#&idMenu=#url.idmenu#">
				   
				<cfif url.id1 neq "">
				   
				 <cf_menutab item  = "2" 
			       iconsrc    = "Logos/Attendance/LeaveBalances.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "Function Deployment Grades"
				   source     = "RecordEditGrades.cfm?id1=#url.id1#&idMenu=#url.idmenu#">
				
				</cfif>
				   
				   <td width="10%"></td>
				 </tr>
			 </table>
		
		<td>
	</tr>
	<tr><td class="linedotted"></td></tr>
	
	<tr>
	<td height="100%" valign="top">
	   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
		<cf_menucontainer item="1" class="regular">
			 <cfdiv bind="url:RecordEditGeneral.cfm?id1=#url.id1#&idMenu=#url.idmenu#"> 
	 	<cf_menucontainer>	
	   </table>	
	</td>
	</tr>
	<tr><td height="1"></td></tr>
</table>




