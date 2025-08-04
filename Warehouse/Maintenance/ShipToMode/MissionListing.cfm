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

<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  DISTINCT Mission
    FROM  	Warehouse 
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" >
<tr>

<td colspan="2">

<table id="missionListing" width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table formpadding" >

<tr><td height="1" colspan="4" class="line"></td></tr>

<tr>
    <TD height="23" align="center" width="10%">
	    <!---
		<cfoutput>
		<A href="javascript:editMission('#url.id1#','')">
		<font color="0080FF">[add]</font></a>
		</cfoutput>
		--->
	</TD>
    <TD>Entity</TD>
</TR>

<tr><td colspan="4" align="right" class="line" valign="middle"></td></tr>

<cfif list.recordCount eq 0>

	<tr><td height="25" colspan="4" class="labelit" align="center"><font color="808080"><b>No entities recorded</b></font></td></tr>

<cfelse>

<cfoutput query="List">
	
	<TR class="navigation_row">	
			
		<TD height="22" align="center" style="padding-top:3px">			
		    <cf_img icon="edit" navigation="Yes" onclick="editMission('#url.id1#','#mission#');">
		</TD>
		
		<TD class="labelit">#Mission#</TD>
	</TR>

</cfoutput>

</cfif>

<tr><td colspan="4" align="right" class="line" valign="middle"></td></tr>

</TABLE>

</td>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>	
