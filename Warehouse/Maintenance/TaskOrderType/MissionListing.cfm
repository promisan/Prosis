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
    SELECT 	*,
			(SELECT Description 
			 FROM Ref_TaskType 
			 WHERE Code = M.Code) AS TaskTypeDescription
			 
    FROM  	Ref_TaskTypeMission M 
	WHERE   Mission IN (SELECT Mission 
	                    FROM   Organization.dbo.Ref_MissionModule 
						WHERE  SystemModule = 'Warehouse')
	AND  	Code = '#URL.ID1#'
</cfquery>

<table width="100%">

<tr>

<td colspan="2" style="padding:5px">

<table width="100%" align="center" class="navigation_table">

<tr class="labelmedium2">
    <TD height="23" align="center" width="10%">
		<!--- <cfoutput>
		<A href="javascript:editMission('#url.id1#','')">
		<font color="0080FF">[add]</font></a>
		</cfoutput> --->
	</TD>
    <TD>Entity</TD>
    <TD>Template</TD>
</TR>

<tr><td colspan="3" align="right" class="line" valign="middle"></td></tr>

<cfif list.recordCount eq 0>

	<tr><td height="25" colspan="3" align="center"><font color="808080"><b>No entities recorded</b></font></td></tr>

<cfelse>

<CFOUTPUT query="List">

	<TR class="labelmedium2 navigation_row line">
					
		<TD align="center" style="padding-top:1px">
			<cf_img icon="open" navigation="yes" onclick="editMission('#url.id1#','#mission#');">   
		</TD>
		
		<TD>#Mission#</TD>
		<TD>#TaskOrderTemplate#</TD>	
	</TR>

</CFOUTPUT>

</cfif>

</TABLE>

</td>
</tr>

</TABLE>

<cfset ajaxonload("doHighlight")>
