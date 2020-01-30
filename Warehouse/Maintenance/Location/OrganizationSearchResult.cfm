<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD>
    <TITLE>Organization units</TITLE>
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

</HEAD><body onLoad="window.focus()">

<cfoutput>

<script>

     function Selected(orgunit,orgunitcode, mission, orgunitname, orgunitclass)
    {
	
        var form = "#Form.FormName#";
		var id   = "#Form.fldOrgUnit#";
		var cde  = "#Form.fldOrgUnitCode#";
		var mis  = "#Form.fldMission#";
		var nme  = "#Form.fldOrgUnitName#";
		var cls  = "#Form.fldOrgUnitClass#";
		
		eval("parent.opener.document." + form + "." + id + ".value = orgunit");
		eval("parent.opener.document." + form + "." + cde + ".value = orgunitcode");
		eval("parent.opener.document." + form + "." + mis + ".value = mission");
		eval("parent.opener.document." + form + "." + nme + ".value = orgunitname");
		eval("parent.opener.document." + form + "." + cls + ".value = orgunitclass");
		parent.window.close()
		   }
    </script>
	
</cfoutput>	

<CFSET Criteria = ''>

<cfoutput>

<cfif ParameterExists(Form.MissionSelect)> 
<cfelse>
    <cfparam name="Form.MissionSelect"   default="#URL.Mission#">	
</cfif>

<cfif Form.MissionSelect neq 'all'> 	
     <cfif #Criteria# is ''>
	 <CFSET #Criteria# = "O.Mission = '#Form.MissionSelect#'">
	 <cfelse>
	 <CFSET #Criteria# = #Criteria#&" AND O.Mission = '#Form.MissionSelect#'">
     </cfif>
</cfif> 

<cfparam name="URL.Mandate" default="">
<cfparam name="Form.Mandate" default="#URL.Mandate#">

<cfif #URL.Mandate# eq "">

    <cfquery name="SearchResult" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT MAX(MandateNo) as MandateNo 
     FROM Ref_Mandate
     WHERE Mission = '#Form.MissionSelect#'
    </cfquery>
	<cfset Form.Mandate = #SearchResult.MandateNo#>

</cfif>

<cfif Form.Mandate neq 'all'> 	
     <cfif #Criteria# is ''>
	 <CFSET #Criteria# = "O.MandateNo = '#Form.Mandate#'">
	 <cfelse>
	 <CFSET #Criteria# = #Criteria#&" AND O.MandateNo = '#Form.Mandate#'" >
     </cfif>
</cfif> 

<cfparam name="Form.OrgUnitClass" default="all">

<cfif Form.OrgUnitClass neq 'all'> 	
     <cfif #Criteria# is ''>
	 <CFSET #Criteria# = "O.OrgUnitClass IN (#PreserveSingleQuotes(Form.OrgUnitClass)# )">
	 <cfelse>
	 <CFSET #Criteria# = #Criteria#&" AND O.OrgUnitClass IN ( #PreserveSingleQuotes(Form.OrgUnitClass)# )" >
     </cfif>
</cfif> 

<cfif Form.OrgUnitName neq ''> 	
     <cfif #Criteria# is ''>
	 <CFSET #Criteria# = "O.OrgUnitName LIKE '%#PreserveSingleQuotes(Form.OrgUnitName)#%'">
	 <cfelse>
	 <CFSET #Criteria# = #Criteria#&" AND O.OrgUnitName LIKE '%#PreserveSingleQuotes(Form.OrgUnitName)#%'">
     </cfif>
</cfif> 

</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" frame="all">

<!---
  <tr>
  
   <td class="bannerXLN"><b>&nbsp;&nbsp;<cfoutput>#Form.MissionSelect# #Form.Mandate#</cfoutput></font></td>
   
   --->
   
   
<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="cols" style="border-collapse: collapse">

<tr><td>

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#8EA4BB" width="100%">

<TR>
    <td height="20" class="top3N"></td>
    <TD class="top3N">&nbsp;<cf_tl id="Code"></TD>
	<TD class="top3N"><cf_tl id="Description"></TD>
	<!--- <TD class="top4N">Class</TD> --->
	<!--- <TD class="top4N">Expiration&nbsp;</TD> --->
   
</TR>

<cfif Form.OrgUnitName eq ''> 

		<!--- Query returning search results --->
				
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *, '1' as Enabled 
		    FROM #CLIENT.LanPrefix#Organization O
		    WHERE #PreserveSingleQuotes(Criteria)#
			ORDER BY O.HierarchyCode
		</cfquery>
		
							
		<cfoutput query="SearchResult">
			
		   <cfif ParentOrgUnit eq "">
		    <tr><td height="1" colspan="3" bgcolor="D2D2D2"></td></tr>
			<TR bgcolor="FFFFCF">
			<td width="10%" class="regular">&nbsp;
		     <cfif #enabled# eq "1">
		     <a href="javascript:Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')" onMouseOver="document.img0_#orgunit#.src='<cfoutput>#SESSION.root#</cfoutput>/images/button.jpg'" onMouseOut="document.img0_#orgunit#.src='<cfoutput>#SESSION.root#</cfoutput>/images/view.jpg'">
    		   <img src="<cfoutput>#SESSION.root#</cfoutput>/images/view.jpg" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="middle" onClick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		     </a>
		     </cfif> 
		   </td>
		    <td width="20%" class="regular"><b><cfif #enabled# eq "0"><font color="gray"></cfif>#HierarchyCode#</b>&nbsp;</td>
		       <TD width="70%" class="regular"><b><cfif #enabled# eq "0"><font color="gray"></cfif>#OrgUnitName#</b></TD>
		       <!--- <TD width="20%" class="regular"><b>#OrgUnitClass#</b></TD> --->
			   <!--- <TD width="10%" class="regular"><b>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b>&nbsp;&nbsp;</TD>  --->
		   </TR>
		   <cfelse>
			<TR bgcolor="FFFFFF">
			<td width="10%" class="regular">&nbsp;
		     <cfif #enabled# eq "1">
		     <a href="javascript:Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')" onMouseOver="document.img0_#orgunit#.src='<cfoutput>#SESSION.root#</cfoutput>/images/button.jpg'" onMouseOut="document.img0_#orgunit#.src='<cfoutput>#SESSION.root#</cfoutput>/images/view.jpg'">
    		   <img src="<cfoutput>#SESSION.root#</cfoutput>/images/view.jpg" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="middle" onClick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		      </a>
			 </cfif> 
		   
		   </td>
		    <td width="20%" class="regular"><cfif #enabled# eq "0"><font color="gray"></cfif>#HierarchyCode#&nbsp;</td>
		       <TD width="70%" class="regular"><cfif #enabled# eq "0"><font color="gray"></cfif>#OrgUnitName#</TD>
		       <!--- <TD width="20%" class="regular"><b>#OrgUnitClass#</b></TD> --->
			   <!--- <TD width="10%" class="regular"><b>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b>&nbsp;&nbsp;</TD> --->
		   </TR>
		   </cfif>
		    
				
		</CFOUTPUT>
		
<cfelse>

		<!--- Query returning search results --->
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		    FROM #CLIENT.LanPrefix#Organization O
		    WHERE #PreserveSingleQuotes(Criteria)#
			ORDER BY Mission, MandateNo, TreeOrder
		</cfquery>
		
		<cfoutput query="SearchResult" group="Mission">
		
		<cfoutput group="MandateNo">
		
		<tr><td colspan="4" class="regular"><b>&nbsp;#Mission# #MandateNo#</b></td></tr>
		<tr><td height="1" colspan="5" bgcolor="808080"></td></tr>
		
		<cfoutput group="TreeOrder">
		
		<cfoutput>
		
		<TR bgcolor="FFFFFF">
		   <td width="10%" class="regular">&nbsp;
		     
		   <a href="javascript:Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')" onMouseOver="document.img0_#orgunit#.src='<cfoutput>#SESSION.root#</cfoutput>/images/button.jpg'" onMouseOut="document.img0_#orgunit#.src='<cfoutput>#SESSION.root#</cfoutput>/images/view.jpg'">
		   <img src="<cfoutput>#SESSION.root#</cfoutput>/images/view.jpg" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="middle" onClick="Selected('#OrgUnit#','#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		      </a>
		   
		   </td>
		   <td width="10%" class="regular"><b>#OrgUnitCode#</b>&nbsp;</td>
		       <TD width="60%" class="regular"><b>#OrgUnitName#</b></TD>
		       <TD width="20%" class="regular"><b>#OrgUnitClass#</b></TD>
			   <!---
			   <TD width="10%" class="regular"><b>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b>&nbsp;&nbsp;</TD>	 
			   --->
			
		</TR>
				
		</CFOUTPUT>
		
		<tr><td></td><td height="1" colspan="4" bgcolor="808080"></td></tr>
		
		</CFOUTPUT>
		</CFOUTPUT>
		</CFOUTPUT>

</cfif>		
		
</TABLE>

</tr></td>
</table>

</td>

</table>

</BODY></HTML>