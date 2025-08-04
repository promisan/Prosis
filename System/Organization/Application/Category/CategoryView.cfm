<!--
    Copyright © 2025 Promisan

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

<script language="JavaScript">

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight";
	 }else{
		
     itm.className = "regular";		
	 }
  }

</script>

<script language="JavaScript">
	javascript:window.history.forward(1);
</script>


<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission IN (SELECT Mission FROM Organization WHERE OrgUnit = '#url.id#')
</cfquery>

<cfquery name="CategoryAll" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT F.Area, F.Code, F.Description, S.*
FROM   OrganizationCategory S, 
       Ref_OrganizationCategory F 
WHERE  S.OrgUnit = '#URL.ID#'
  AND  S.OrganizationCategory = F.Code
  AND  F.Owner = '#Mission.MissionOwner#'
</cfquery>

<cf_screentop html="No" scroll="Yes">

<cfinclude template="../UnitView/UnitViewHeader.cfm">

<cfif CategoryAll.recordcount eq "0">

<cflocation url="GroupEntry.cfm?ID=#URL.ID#" addtoken="No">

</cfif>

<table width="100%" border="0">

<tr><td>

<cfoutput>
	<form action="GroupEntry.cfm?ID=#URL.ID#" method="POST" name="categoryentry">
	</cfoutput> 
	
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	 
	<tr>
	
	<td style="height:40px;padding:4px" class="labellarge"><cf_tl id="Workforce Classification"></b></td>	
	
	
	<td align="right" style="padding-right:5px">
		<cf_tl id="Edit" var="vEdit">
		<cfoutput>
			<input type="submit" name="Submit" id="Submit" value="#vEdit#" class="button10g" style="height:25;width:130px;">
		</cfoutput>
	</td>
	</tr> 
	
	<tr>
	    <td width="100%" colspan="2">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		
	    <TR bgcolor="f8f8f8" class="linedotted labelit">
	    <td height="20">&nbsp;<cf_tl id="Category"></td>
	    <TD><cf_tl id="Officer"></TD>
		<TD><cf_tl id="Entered"></TD>
		<TD></TD>
	    </TR>
		
	
	    <cfoutput query="CategoryAll" group="AREA">
	    <TR><td height="15" colspan="4" class="labelmedium" style="padding-left:8px" bgcolor="D5EC9D"><b>#Area#</b></td><TR>
	    <cfoutput>
	    <TR class="linedotted labelit">
	    <TD>&nbsp;&nbsp;</TD>
	    <TD>#Description#</TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#DateFormat(Created,CLIENT.DateFormatShow)#</TD>
		<TD></TD>
	    </TR>	
		</CFOUTPUT>
		</CFOUTPUT>
	
		</table>
	
		
	</td>
	
	</tr>
	
	</table>
	
	</form>

</td>
</tr>
</table>
