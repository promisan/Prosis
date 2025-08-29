<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cf_dialogOrganization>
  
<!--- Query returning search results --->

<cfquery name="Level01" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT distinct O.*
    FROM Organization O
	WHERE O.ParentOrgUnit = '#Organization.OrgUnitCode#'
	AND O.Mission   = '#Organization.Mission#'
	AND O.MandateNo = '#Organization.MandateNo#'
ORDER BY O.Mission, TreeOrder
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td colspan="6">
<cfoutput>
<input type="button" name="add" id="add" value="Add Unit" class="button7" onClick="javascript:addOrgUnit('#CLIENT.Mission#','#Organization.MandateNo#','#Organization.OrgUnitCode#','','base')">
</cfoutput>
</td></tr>

<tr><td height="2" colspan="6"></td></tr>

<TR>
    <td height="20" class="top3N"></td>
    <TD class="top3N">&nbsp;Code</TD>
	<TD class="top3N">Description</TD>
    <TD class="top3N">Class</TD>
	<TD class="top3N">Expiration&nbsp;</TD>
	<TD class="top3N"></TD>
</TR>


<cfoutput query="Level01" group="Mission">

<cfoutput group="TreeOrder">

<cfoutput>

<tr bgcolor="FFFF9B">
   <td width="10%" class="regular">&nbsp;
   <a href="javascript:editOrgUnit('#Level01.OrgUnit#','','base')">
   <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/view.jpg" alt="" width="14" height="15" border="0" align="middle" onClick="Selected('#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
   </a>
     </td>
       <td width="10%"><b>&nbsp;#OrgUnitCode#</b></td>
       <TD width="40%"><b>&nbsp;#OrgUnitName#</b></TD>
       <TD width="30%"><b>&nbsp;#OrgUnitClass#</b></TD>
	   <TD width="10%"><b>&nbsp;#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b>&nbsp;&nbsp;</TD>	 
	   <TD width="5">
	        <A HREF ="javascript:addOrgUnit('#CLIENT.Mission#','#Organization.MandateNo#','#OrgUnitCode#','','base')"><img src="#SESSION.root#/Images/zoomin.jpg" alt="" width="10" height="9" border="0" align="middle"></a>&nbsp;
	   </TD>
    </TR>
	
		
   <cfquery name="Level02" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT O.*
    FROM Organization O
	WHERE (O.ParentOrgUnit = '#Level01.OrgUnitCode#')
	AND O.Mission   = '#Organization.Mission#'
	AND O.MandateNo = '#Organization.MandateNo#'
	ORDER BY O.Mission, TreeOrder
   </cfquery>
   
    <cfloop query="Level02">
   
     <tr bgcolor="FDFEE0">
		
	   <td width="10%" bgcolor="FFFFFF" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;
	   <a href="javascript:editOrgUnit('#Level02.OrgUnit#','','base')">
       <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/view.jpg" alt="" width="14" height="15" border="0" align="middle" onClick="Selected('#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		  </a>
       </td>
     <td width="10%">#Level02.OrgUnit# #Level02.OrgUnitCode#</td>
     <TD width="40%">#Level02.OrgUnitName#</TD>
     <TD width="30%">#Level02.OrgUnitClass#</TD>
     <TD width="10%">#DateFormat(Level02.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</TD>
	 <TD width="5">
	        <A HREF ="javascript:addOrgUnit('#CLIENT.Mission#','#Organization.MandateNo#','#Level02.OrgUnitCode#','','base')"><img src="#SESSION.root#/Images/zoomin.jpg" alt="" width="10" height="9" border="0" align="middle"></a>&nbsp;
	   </TD>
     </TR> 
	  		
     <cfquery name="Level03" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT O.*
       FROM Organization O
	   WHERE (ParentOrgUnit = '#Level02.OrgUnitCode#')
	   AND O.Mission   = '#Organization.Mission#'
	   AND O.MandateNo = '#Organization.MandateNo#'
   	  ORDER BY O.Mission, TreeOrder
    </cfquery>

    <cfloop query="Level03">
   
     <tr bgcolor="White">
		
	   <td width="10%" bgcolor="FFFFFF" class="regular">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	   <a href="javascript:editOrgUnit('#Level03.OrgUnit#','','base')">
        <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/view.jpg" alt="" width="14" height="15" border="0" align="middle" onClick="Selected('#OrgUnitCode#','#Mission#','#OrgUnitName#','#OrgUnitClass#')">
		  </a>
       </td>
       <td width="10%">#Level03.OrgUnitCode#</td>
       <TD width="40%">#Level03.OrgUnitName#</font></TD>
       <TD width="30%">#Level03.OrgUnitClass#</font></TD>
	   <TD width="10%">#DateFormat(Level03.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</font></TD>
	    <TD width="5">
	        <A HREF ="javascript:addOrgUnit('#CLIENT.Mission#','#Organization.MandateNo#','#Level03.OrgUnitCode#','','base')"><img src="#SESSION.root#/Images/zoomin.jpg" alt="" width="10" height="9" border="0" align="middle"></a>&nbsp;
	   </TD>
     </TR> 
	     
    </cfloop> 
         
   </cfloop> 

</CFOUTPUT>

<!--- <tr><td></td><td height="1" colspan="4" bgcolor="808080"></td></tr> --->

<tr><td height="2" colspan="5" ></td></tr>

</CFOUTPUT>
</CFOUTPUT>

</TABLE>
