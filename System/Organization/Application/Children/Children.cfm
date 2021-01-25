<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No">

<cf_dialogOrganization>
  
<table width="100%" align="center">

	<tr><td>
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</td></tr>
	
</table>  

<cfquery name="Org" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Organization O
	WHERE O.OrgUnit = '#URL.ID#'
</cfquery>

<cfquery name="Level01" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT distinct O.*
    FROM Organization O
	WHERE O.ParentOrgUnit = '#Org.OrgUnitCode#'
	AND O.Mission   = '#Org.Mission#'
	AND O.MandateNo = '#Org.MandateNo#'
ORDER BY O.Mission, TreeOrder
</cfquery>

<table width="96%" align="center" class="navigation_table">

<TR class="labelmedium2 line fixrow">
    <td height="20"></td>
    <TD><cf_tl id="Code"></TD>
	<TD><cf_tl id="Description"></TD>
	<TD><cf_tl id="Short"></TD>
    <TD><cf_tl id="Class"></TD>
	<TD><cf_tl id="Expiration">&nbsp;</TD>

</TR>

<cfoutput query="Level01" group="Mission">
<cfoutput group="TreeOrder">
<cfoutput>

<tr bgcolor="FFFF9B" class="navigation_row line labelmedium2">
       <td width="6%" style="padding-left:4px;padding-top:1px">
          <cf_img icon="open" onclick="javascript:editOrgUnit('#Level01.OrgUnit#')">  
       </td>
       <td width="10%">#OrgUnitCode#</td>
       <TD width="40%">#OrgUnitName#</TD>
	   <TD width="10%">#OrgUnitNameShort#</TD>
       <TD width="20%">#OrgUnitClass#</TD>
	   <TD style="padding-right:3px" width="10%">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>	 
	   
    </TR>
			
   <cfquery name="Level02" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT O.*
    FROM Organization O
	WHERE (O.ParentOrgUnit = '#Level01.OrgUnitCode#')
	AND O.Mission   = '#Org.Mission#'
	AND O.MandateNo = '#Org.MandateNo#'
	ORDER BY O.Mission, TreeOrder
   </cfquery>
   
    <cfloop query="Level02">
   
     <tr bgcolor="FDFEE0" class="navigation_row line labelmedium2">
		
	   <td width="6%" bgcolor="FFFFFF" style="padding-left:30px">
	   <a href="javascript:editOrgUnit('#Level02.OrgUnit#')">
       <img src="../../../../Images/view.jpg" alt="" width="14" height="15" border="0" align="middle" onClick="Selected('#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		  </a>
       </td>
     <td>#Level02.OrgUnitCode#</td>
     <TD>#Level02.OrgUnitName#</TD>
	 <TD>#OrgUnitNameShort#</b></TD>
     <TD>#Level02.OrgUnitClass#</TD>
     <TD style="padding-right:3px">#DateFormat(Level02.DateExpiration, CLIENT.DateFormatShow)#</TD>
	
     </TR> 
	  		
     <cfquery name="Level03" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT O.*
       FROM Organization O
	   WHERE (ParentOrgUnit = '#Level02.OrgUnitCode#')
	   AND O.Mission   = '#Org.Mission#'
	   AND O.MandateNo = '#Org.MandateNo#'
   	  ORDER BY O.Mission, TreeOrder
    </cfquery>

    <cfloop query="Level03">
   
     <tr bgcolor="White" class="navigation_row line labelmedium2">
		
	   <td width="10%" style="padding-left:60px">;
    	   <a href="javascript:editOrgUnit('#Level03.OrgUnit#')">
       		 <img src="../../../../Images/view.jpg" alt="" width="14" height="15" border="0" align="middle" onClick="Selected('#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		  </a>
       </td>
       <td>#Level03.OrgUnitCode#</td>
       <TD>#Level03.OrgUnitName#</TD>
	   <TD>#OrgUnitNameShort#</TD>
       <TD>#Level03.OrgUnitClass#</TD>
	   <TD>#DateFormat(Level03.DateExpiration, CLIENT.DateFormatShow)#</TD>
	  
     </TR> 
	     
    </cfloop> 
         
   </cfloop> 

</CFOUTPUT>

</CFOUTPUT>
</CFOUTPUT>

</TABLE>

<cfset ajaxonload("doHighlight")>