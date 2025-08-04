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

<cfparam name="URL.Mode" default="">


<cfquery name="UserReport" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *
  FROM    Ref_ReportControl
  WHERE   ControlId = '#URL.ID#'
</cfquery>

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM     Ref_ReportControlOutput
	WHERE    ControlId = '#URL.ID#'
	ORDER BY ListingOrder, VariableName
</cfquery>

<cfset Header = "Registered extraction data sets">

<cfif SearchResult.recordcount neq "0">

	<table width="100%" align="center">
		
	<tr><td colspan="2">
	<table width="100%">
		
	<tr class="labelmedium2 line">
	    <TD width="5%"></TD>
		<TD width="5%"></TD>
		<TD width="20%">Mode</TD> 
	    <td width="15%">Table name</td>
	    <TD width="30%">Description</TD>
	    <TD width="4%">Order</TD>
	    <TD width="7%" align="center">Enabled</TD>			
		<TD width="10%" align="right">Updated</TD>
		<TD width="1%"></TD>
	</TR>
			
	<cfif UserReport.ReportRoot eq "Application" or UserReport.ReportRoot eq "">
	   <cfset rootpath  = "#SESSION.rootpath#">
	<cfelse>
	   <cfset rootpath  = "#SESSION.rootReportPath#">
    </cfif>
	
	<cftry>	
	<cffile action = "read"
	 	  file = "#rootpath#\#UserReport.ReportPath#\#UserReport.TemplateSQL#"
	      variable = "sql">  
		  
		  <cfcatch>
		      <cfset sql = "">
		  </cfcatch>
		  
	</cftry>		  
	
	<CFOUTPUT query="SearchResult">
			
		<TR class="labelmedium2 line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFAF'), DE('FFFFfF'))#">
			<td align="center" style="padding-left:2px">#CurrentRow#</td>
			
			<TD align="center" style="padding-top:1px">			
			  <cf_img icon="select" tooltip="Open" onClick="javascript:extractedit('#OutputId#')">
			</td>
			
			<TD>#OutputClass#</TD> 
			
			<td>
			
				<cfif sql neq "">
					<cfif outputclass eq "variable">
						<cfif not FindNoCase("#VariableName#", "#sql#")><font color="red"><b>Not detected:</cfif>
					</cfif>
				</cfif>
				<a href="javascript:extractedit('#OutputId#')">#VariableName#</a>
				
			</TD>
			<TD><a href="javascript:extractedit('#OutputId#')">#OutputName#</a></TD>
			<TD align="center">#ListingOrder#</TD>
			<td align="center"><cfif Operational eq "1">Yes</cfif></td>			
			<td align="right">#DateFormat(Created, CLIENT.DateFormatShow)#</td>
			<td></td>
		</TR>	
				
	</CFOUTPUT>
	</TABLE>
	
	</td>
	</tr>
	</table>
	
<cfelse>

	<table><tr class="labelmedium line"><td>		
		<font color="FF0000"><b>Attention</b> : No export/analysis variables have been declared.</font>
	</td></tr></table>
	
</cfif>
