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
<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes">
<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Mission
	WHERE Mission = '#URL.Mission#'
</cfquery>  

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

  <tr><td height="6"></td></tr>
  <tr class="noprint">
    <td style="padding-left:8px;font-size:30px;height:40px;font-weight:200" class="labellarge">
	<cfoutput>#URL.Mission# staffing period listing</b></font></cfoutput>
    </td>
	<td align="right" height="30">	
	 <cfif Mission.MissionStatus eq "0">	
	 <button class="button10g" onClick="javascript:recordadd()"><cf_tl id="New Period"></button>&nbsp;	 
	 <cfelse>	 
	 <font face="Verdana" size="2"><b><cf_tl id="Static"></b></font>&nbsp;&nbsp;	 
	 </cfif>		
	</td>
  </tr> 	
  
  <tr><td colspan="3" class="line"></td></tr>
  
<cfquery name="Searchresult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Mandate
	WHERE Mission = '#URL.Mission#'
	ORDER BY DateEffective DESC
</cfquery>  
 
<cfoutput>

<script>

	function reloadForm(page) {
	     ptoken.location('RecordListing.cfm?Page=' + page); 
	}

	function recordadd() {
	     ptoken.location('MandateEntry.cfm?Mission=#URL.Mission#');
	}

	function recordedit(mis,id) {
	     ptoken.location('MandateEdit.cfm?ID=' + mis + '&ID1=' + id);
	}

</script>	

</cfoutput>
	
<tr><td colspan="2" style="padding-top:7px">

<table width="96%" align="center" bgcolor="" class="navigation_table">

<tr class="labelmedium2 line">
    <TD width="40"></TD>
    <TD><cf_tl id="Code"></TD>
	<TD><cf_tl id="Name"></TD>
	<TD><cf_tl id="Effective"></TD>
	<TD><cf_tl id="Expiration"></TD>
	<TD><cf_tl id="Default"></TD>
	<TD><cf_tl id="St"></TD>
	<TD><cf_tl id="Officer"></TD>
    <TD><cf_tl id="Entered"></TD>  
</TR>

<cfoutput query="SearchResult">
    	
    <!--- <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffcf'))#"> --->
	<TR height="20" bgcolor="white" class="line navigation_row labelmedium2">
		<td align="center" style="padding-top:1px">	
		  <cf_img icon="select" navigation="Yes" onclick="recordedit('#Mission#','#MandateNo#')">
		</td>
		<TD><a href="javascript:recordedit('#Mission#','#MandateNo#')">#MandateNo#</a></TD>
		<TD>#Description#</TD>
		<TD>#Dateformat(DateEffective, "#CLIENT.DateFormatShow#")#</TD>
		<TD>#Dateformat(DateExpiration, "#CLIENT.DateFormatShow#")#</TD>
		<TD><cfif MandateDefault eq "1">Yes</cfif></TD>
		<TD><cfif MandateStatus eq "1">Locked<cfelse>Draft</cfif></TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
</cfoutput>

</TABLE>

</td>
</tr>

</TABLE>