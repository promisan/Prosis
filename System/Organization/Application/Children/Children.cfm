<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" scroll="Yes" html="No">

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

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">

<TR>
    <td height="20"></td>
    <TD class="labelit"><cf_tl id="Code"></TD>
	<TD class="labelit"><cf_tl id="Description"></TD>
	<TD class="labelit"><cf_tl id="Short"></TD>
    <TD class="labelit"><cf_tl id="Class"></TD>
	<TD class="labelit"><cf_tl id="Expiration">&nbsp;</TD>

</TR>

<cfoutput query="Level01" group="Mission">
<cfoutput group="TreeOrder">
<cfoutput>

<tr bgcolor="FFFF9B">
       <td width="6%" style="padding-left:4px;padding-top:2px">
          <cf_img icon="edit" onclick="javascript:editOrgUnit('#Level01.OrgUnit#')">  
       </td>
       <td class="labelit" width="10%"><b>#OrgUnitCode#</b></td>
       <TD class="labelit" width="40%"><b>#OrgUnitName#</b></TD>
	   <TD class="labelit" width="10%"><b>#OrgUnitNameShort#</b></TD>
       <TD class="labelit" width="20%"><b>#OrgUnitClass#</b></TD>
	   <TD class="labelit" width="10%"><b>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b>&nbsp;&nbsp;</TD>	 
	   
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
   
     <tr bgcolor="FDFEE0">
		
	   <td width="6%" bgcolor="FFFFFF">&nbsp;&nbsp;&nbsp;&nbsp;
	   <a href="javascript:editOrgUnit('#Level02.OrgUnit#')">
       <img src="../../../../Images/view.jpg" alt="" width="14" height="15" border="0" align="middle" onClick="Selected('#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		  </a>
       </td>
     <td class="labelit" width="10%">#Level02.OrgUnitCode#</td>
     <TD class="labelit" width="40%">#Level02.OrgUnitName#</TD>
	 <TD class="labelit" width="10%"><b>&nbsp;#OrgUnitNameShort#</b></TD>
     <TD class="labelit" width="20%">#Level02.OrgUnitClass#</TD>
     <TD class="labelit" width="10%">#DateFormat(Level02.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</TD>
	
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
   
     <tr bgcolor="White">
		
	   <td width="10%" bgcolor="FFFFFF" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	   <a href="javascript:editOrgUnit('#Level03.OrgUnit#')">
       		 <img src="../../../../Images/view.jpg" alt="" width="14" height="15" border="0" align="middle" onClick="Selected('#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		  </a>
       </td>
       <td class="labelit" width="10%">#Level03.OrgUnitCode#</td>
       <TD class="labelit" width="40%">#Level03.OrgUnitName#</TD>
	   <TD class="labelit" width="10%"><b>&nbsp;#OrgUnitNameShort#</TD>
       <TD class="labelit" width="30%">#Level03.OrgUnitClass#</TD>
	   <TD class="labelit" width="10%">#DateFormat(Level03.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</font></TD>
	  
     </TR> 
	     
    </cfloop> 
         
   </cfloop> 

</CFOUTPUT>

</CFOUTPUT>
</CFOUTPUT>

</TABLE>

</BODY></HTML>