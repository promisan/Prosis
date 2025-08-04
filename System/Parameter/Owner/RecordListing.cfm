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
<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop 
   	   height="100%"
	   scroll="Yes" 
	   html="No" 
	   menuaccess="yes" 
	   jQuery="Yes"
	   systemfunctionid="#url.idmenu#">
   

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset menu         = "1">
	   
<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderParameter.cfm"></td></tr>	   
   
<cfquery name="SearchResult"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AuthorizationRoleOwner
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height= 230, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height= 230, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>
	
<tr><td colspan="2">

<cf_divscroll>

<table width="94%" align="center" class="navigation_table">

<tr class="line labelmedium2">
    <td></td>
    <TD>Code</TD>
	<TD>Description</TD>
	<TD>eMail</TD>
	<TD>Officer</TD>
    <TD>Entered</TD>
  
</TR>

<cfoutput query="SearchResult">
    	
    <TR class="navigation_row labelmedium2 line"> 
	<td width="30" height="20" style="padding-left:7px;padding-top:1px">
		  <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
	</td>
	<TD height="18">#Code#</TD>
	<TD>#Description#</TD>
	<TD>#eMailAddress#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
</CFOUTPUT>

</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>
