
<html>

<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Program select</title>
</head>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Define" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM #CLIENT.LanPrefix#Organization
	WHERE OrgUnit = '#URL.OrgUnitParent#' 
</cfquery>

<cfquery name="Root" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM #CLIENT.LanPrefix#Organization
   WHERE OrgUnitCode = '#Define.HierarchyRootUnit#'
     AND MandateNo = '#Define.MandateNo#'
     AND Mission = '#Define.Mission#'
   </cfquery>

<cfquery name="Parent" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM #CLIENT.LanPrefix#Organization
	WHERE (ParentOrgUnit = '' or ParentOrgUnit is NULL)
	AND Mission = '#Define.Mission#'
	AND MandateNo = '#Define.MandateNo#'
</cfquery>

<cfset FileNo = "">

<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#ProgramPeriod#FileNo#">	

<cfinclude template="../Tools/GenerateProgramPeriod.cfm">

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT O.OrgUnitCode, 
		   O.OrgUnit, 
		   O.OrgUnitName, 
		   O.HierarchyCode,
		   Pe.Reference, 
	       P.* 		  
    FROM   #CLIENT.LanPrefix#Program P, 
	       #per# Pe, 
		   Organization.dbo.#CLIENT.LanPrefix#Organization O,
		   Organization.dbo.Organization Root
	WHERE  P.ProgramCode = Pe.ProgramCode
	AND    Pe.Period = '#URL.Period#'
	AND    Pe.OrgUnit = O.OrgUnit
	AND    O.HierarchyRootUnit = Root.OrgUnitCode
	AND    O.Mission   = Root.Mission
	AND    O.MandateNo = Root.MandateNo
	AND    Root.OrgUnit = '#URL.OrgUnitParent#'
	AND    P.ProgramClass IN ('Program','Component')
	AND    Pe.Status != '9'
	<!--- AND O.OrgUnit != '#URL.OrgUnit#'  --->
	ORDER BY O.HierarchyCode, Pe.ProgramHierarchy
</cfquery>

<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#ProgramPeriod#FileNo#">	

<CFOUTPUT>	

<script>

function reloadForm(parent) {
     window.location="ProgramSelect.cfm?form=#URL.form#&frmorgunit=#URL.frmorgunit#&frmorgunitname=#URL.frmorgunitname#&frmparentcode=#URL.frmparentcode#&frmparentcodename=#URL.frmparentcodename#&period=#URL.Period#&orgunit=#URL.OrgUnit#&orgunitparent=" + parent;
}

function selected(unit, unitname, parent, parentname) {
	
        var form = "#URL.Form#";
		var frmorgunit  = "#URL.frmorgunit#";
		var frmorgunitname  = "#URL.frmorgunitname#";
		var frmparentcode  = "#URL.frmparentcode#";
		var frmparentcodename  = "#URL.frmparentcodename#";
		eval("self.opener.document." + form + "." + frmorgunit + ".value = unit");
		eval("self.opener.document." + form + "." + frmorgunitname + ".value = unitname");
		eval("self.opener.document." + form + "." + frmparentcode + ".value = parent");
		eval("self.opener.document." + form + "." + frmparentcodename + ".value = parentname");
     	window.close();
	
}
</script>

</CFOUTPUT>

<body leftmargin="2" topmargin="2" rightmargin="2" onLoad="window.focus()">

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" rules="cols">

  <tr height="30">
  <td class="top3nd">&nbsp;
    <select name="parent" class="regularxl"
	accesskey="P" title="Parent Selection" onChange="javascript:reloadForm(this.value)">
    
    <cfoutput query="Parent">
	<option value="#OrgUnit#" <cfif OrgUnit is URL.OrgUnitParent>selected</cfif>>#OrgUnitName#</option>
	</cfoutput>
    </select>
  </tr>
  </td>
   
  <tr>
  <td>
  
     <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
     <TR> 
	   <td width="5%" class="top3n" ></td>
       <td width="5%" class="top3n" ></td>
	   <TD width="10%" align="left" class="top3n">Code</TD>
       <TD width="60%" align="left" class="top3n">Program name</TD>
	   <TD width="10%" align="left" class="top3n">Urgency</TD>
	   <TD width="10%" align="left" class="top3n">Importancy</TD>
	 </TR>
	 
	 <cfoutput query="Program" group="HierarchyCode">		 
	 <tr>
	 	<td colspan="2" bgcolor="E8E8E8">&nbsp;<b>#OrgUnitCode#</td>
		<td colspan="4" bgcolor="E8E8E8"><b>#OrgUnitName#</td>
	 </tr>
	 
		 <cfoutput>
			
			 <TR class="labelit line">
				 <td></td>
				 <td align="center" style="padding-top:1px">
				   <cf_img icon="select"
				       onClick="javascript:selected('#OrgUnit#','#OrgUnitName#','#ProgramCode#','#ProgramName#');">	 
				 <TD>#Reference#</TD>
				 <TD>#ProgramName#</TD>
			     <TD>#StatusUrgency#</TD>
				 <TD>#StatusImportancy#</TD>
			 </tr>
		 	 
		 </cfoutput>
	 
	 </cfoutput>
	 	 
	 </table>
  
  </td>
  
  </tr>
  
</table>

</form>

</body>

</html>
