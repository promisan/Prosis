
<cfset FileNo = "">

<cfparam name="URL.Mission" default="#URL.ID2#">
<cfparam name="URL.Mandate" default="#URL.ID3#">
<cfparam name="URL.Period"  default="#url.id4#">
<cfparam name="URL.ID1"     default="tree">

<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#ProgramPeriod#FileNo#">	

 <cfquery name="Org" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT OrgUnit, OrgUnitName, HierarchyRootUnit
	   FROM   Organization
	   WHERE  OrgUnitCode = '#URL.ID1#'
	   	AND   MandateNo   = '#URL.Mandate#'
		AND   Mission     = '#URL.Mission#'
</cfquery>

<cfif url.period eq "">

	 <cfquery name="Period" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_MissionPeriod
	   WHERE  MandateNo = '#URL.Mandate#'
		AND   Mission   = '#URL.Mission#'
		AND   DefaultPeriod = '1'
	</cfquery>
	
	<cfset url.period = period.Period>
	
</cfif>	

<cfquery name="Root" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM #CLIENT.LanPrefix#Organization
 WHERE OrgUnitCode = '#Org.HierarchyRootUnit#'
   AND MandateNo   = '#URL.Mandate#'
   AND Mission     = '#URL.Mission#'
</cfquery>

<cfif URL.ID1 neq "Tree">
	
	  <cf_OrganizationSelect
	     enforce = "1"
	     OrgUnit = "#URL.ID1#">
		 
	 <cfelse>
	
	 <cfset HStart = "00">
	 <cfset HEnd   = "99">
	 	 
</cfif> 

<cfinclude template="../../Tools/GenerateProgramPeriod.cfm">
	 
<cfquery name="SubProject"
    datasource="AppsProgram"
    username="#SESSION.login#"
    password="#SESSION.dbpw#">
   	  SELECT  *
      FROM    ProgramPeriod
	  WHERE   PeriodParentCode = '#URL.ID1#'
	  AND     Period = '#url.period#'
</cfquery>
	
<cfif SubProject.recordcount eq "0">
    <cfset hassub = "0">
<cfelse>
    <cfset hassub = "1">
</cfif>	 

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT Pe.ProgramId,
		       Pe.Reference,
		       Pe.ProgramHierarchy, 
			   P.ProgramCode, 
			   P.ProgramName, 
			   P.ProgramClass, 
			   O.OrgUnitCode, 
			   O.OrgUnit, 
			   O.OrgUnitName, 
			   O.HierarchyCode
	    FROM   #CLIENT.LanPrefix#Program P, 
		       #per# Pe,
			   Organization.dbo.Organization O
		WHERE P.ProgramCode   = Pe.ProgramCode
		AND   O.OrgUnit       = Pe.OrgUnit
		AND   O.HierarchyCode >= '#HStart#' 
		AND   O.HierarchyCode < '#HEnd#' 
		AND   O.Mission       = '#URL.Mission#' 
		<cfif hassub eq "1">
		<!--- do not allow to attach to a project --->
		AND   P.ProgramClass IN ('Program','Component')
		<cfelse>
		<!--- allow to attach to a project --->
		AND      P.ProgramClass IN ('Program','Component','Project') 		
		</cfif>	
		AND      P.ProgramCode != '#URL.ID1#'
		AND      Pe.Period = '#url.period#'
		AND      Pe.RecordStatus != '9'
		ORDER BY O.HierarchyCode, Pe.ProgramHierarchy
</cfquery>

<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#ProgramPeriod#FileNo#">	


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  
  <tr>
  <td style="padding:16px">
  
     <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
     
		 <tr class="labelit linedotted"> 
		   <td width="8%">&nbsp;</td>
		   <td width="15%" align="left"><cf_tl id="Code"></td>
	       <td width="60%" align="left"><cf_tl id="Program name"><cf_space spaces="30"></td>
		   <td width="15%" align="left"><cf_tl id="Class"></td>	  
		 </tr>
		
		 <cfoutput query="Program" group="HierarchyCode">
		 
		 <tr><td height="7"></td></tr>
			 
		 <tr bgcolor="e4e4e4" style="border:1px solid silver" class="labelmedium">
		 	<td colspan="4" style="padding-left:4px">#OrgUnitCode# #OrgUnitName#</td>	 
		 </tr>
		 
		 <tr><td height="7"></td></tr>
			 
			 <cfoutput>
			 
			 	<cfif programclass eq "Program">
					<cfset cl = "ffffaf">
				<cfelseif programclass eq "Component">
					<cfset cl = "fafafa">
				<cfelse>
					<cfset cl = "white">
				</cfif>
					 
				 <cfset orgname = replace(OrgUnitName,"'","","ALL")> 
				 <cfset prgname = replace(ProgramName,"'","","ALL")> 
				
				 <TR bgcolor="#cl#" class="labelit navigation_row">
					 <td align="center" style="padding-top:3px">				
					   <cf_img icon="select" navigation="Yes" onclick="programselected('#programid#','#orgunit#')">
					 </td>
					 <td><cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif></td>
					 <td>#ProgramName#</td>
					 <td style="padding-right:5px">#ProgramClass#</td>				  
				 </tr>
			 	 
			 </cfoutput>
		 
		 </cfoutput>
	 	 
	 </table>
  
  </td>
  
  </tr>  
  
</table>

<cfset ajaxonload("doHighlight")>


