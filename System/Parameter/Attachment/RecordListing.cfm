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

<cfparam name="url.code" default="">	

<cf_screentop html="no" jQuery="Yes">

<table width="98%" align="center" height="100%">

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 
<cfset back         = "0"> 
<tr style="height:10px"><td><cfinclude template="../HeaderParameter.cfm"> 	</td></tr>


<cfoutput>

<script>
 
function recordadd(grp) {
    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 690, height= 530, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function edit(id1) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 690, height= 530, toolbar=no, status=yes, scrollbars=no, resizable=no");
}
 
</script>

</cfoutput>


<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Attachment
	WHERE    DocumentPathName not like '%travel/%' AND DocumentPathName not like '%vacancy/%'
	ORDER BY DocumentPathName
</cfquery>

<cf_PresentationScript>

<tr><td style="height:40;padding-left:30px">

<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font:15px;height:25;width:120"
			   rowclass         = "filter_row"
			   rowfields        = "filter_content">

</td></tr>

<tr><td>

<cf_divscroll>

	<table width="97%" align="center" class="navigation_table">
	
	<tr class="line labelmedium2 fixrow fixlengthlist">
	    <TD></TD>
		<td>Key</td>
	    <TD>Document path</TD>	
		<TD>System Module</TD>    
	    <TD>Doc. server login</TD>
		<TD>Att. multiple</TD>
		<TD>Att. logging</TD>
		<TD>Created</TD>
	</TR>
	
	<cfoutput query="List">
			
		<tr bgcolor="white" class="line labelmedium2 navigation_row filter_row fixlengthlist">	
			<td align="center" style="padding-top:1px">
			  <cf_img icon="open" navigation="Yes" onclick="edit('#DocumentPathName#')">
			</td>
			
			<td title="#DocumentPathName#" class="filter_content">#DocumentPathName#</td>
			<td title="#DocumentFileServerRoot##DocumentPathName#" class="filter_content">#DocumentFileServerRoot##DocumentPathName#</td>	
			<td>#SystemModule#</td>
			<td>#DocumentServerLogin#</td>
			<td><cfif AttachMultiple eq 1>yes<cfelse>no</cfif></td>
			<td><cfif AttachLogging eq 1>yes<cfelse>no</cfif></td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	
			
	</CFOUTPUT>	
	
	</TABLE>

</cf_divscroll>

</td></tr>

</table>