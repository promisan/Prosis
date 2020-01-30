
<!---

<cf_screentop label="Locate a service line" option="Lookup" height="100%" scroll="Yes" layout="webdialog" banner="yellow" close="ColdFusion.Window.hide('dialog#url.box#')">

--->

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">

<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">

<tr><td>

<form name="selectservice" id="selectservice" method="post" onsubmit="return false">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">
<cfoutput>

    <tr><td height="4"></td></tr>
  		
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="P.Reference">	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR>
	<TD class="labelit">Id:</TD>
	<TD>
	
		<SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">		
			#SelectOptions#		
		</SELECT>
		
		<input type="input" 
	     name="Crit2_Value" 
		 id="Crit2_Value"
	     class="regularxl"  
	     onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }"> 
	
	</TD>
	
	<TD style="padding-left:5px">
			
	   <cfquery name="Class" 
		datasource="appsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ServiceItemDomainClass
			WHERE  ServiceDomain IN (SELECT ServiceDomain 
			                         FROM   ServiceItem 
									 WHERE  Code = '#url.filter2value#')			
	   </cfquery>
	
	   <SELECT name="ServiceDomain" id="ServiceDomain" class="regularxl">
	
	     <option value="">Any</option>
	     <cfloop query="class">
		    <OPTION value="Code">#description#
		 </cfloop>		
	    </SELECT>
		 	
	</TD>
	</TR>
			
</TABLE>

</FORM>

</tr>

</cfoutput>	 
  
<tr><td colspan="2" class="linedotted" height="1"></td></tr>
		
<tr><td colspan="2" align="center">
  
	<cf_tl id="Search" var="1">
	
	<cfoutput>
		<input type="button"
	       name="search" id="search"
	       value="#lt_text#"
	       class="button10g"
	       onClick="javascript:ColdFusion.navigate('#SESSION.root#/tools/selectlookup/WorkorderLine/Result.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#&filter3=#filter3#&filter3value=#filter3value#','resultworkorder#box#','','','POST','selectservice')">
	 </cfoutput>  
	   
</td></tr>

<tr><td height="1" class="linedotted"></td></tr>

<tr>
	<td colspan="2" align="center">
		<cfdiv id="resultworkorder#box#">
	</td>
</tr>

</table>

</td></tr>

</table>