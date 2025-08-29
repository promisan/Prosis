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
<cfparam name="url.mode" default="collapsed">

<cfset path = "#SESSION.root#/Tools/Activesheet/Images">
<cfoutput>

<table cellpadding="0" cellspacing="0" border="0" width="100%">
	
	<tr ondblclick="highlight('#url.box#','#url.module#','#url.elementid#')">
		
		<td id="content" name="content" style="padding:0px;border-radius:7px;border:1px solid gray">
		
			<table align="center" width="100%" height="20" border="0" cellspacing="0" cellpadding="0">			
				
			<cfquery name="Element" 
			    datasource="appsCaseFile" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT * 
				FROM   Element
				WHERE  ElementId = '#url.elementid#'
			</cfquery>
				
			<tr height="5%">
				<td style="padding:5px">
				
				  <img onclick="cellzoom('#url.box#','#url.module#')" id="header_#url.box#" src="#SESSION.root#/images/expand5.gif" alt="" border="0" align="left"> <img src="#SESSION.root#/images/logos/casefile/vis_#element.elementclass#.png" align="right" width="20px">
			
			<input type="hidden" name="id_#url.box#" id="id_#url.box#" value="#url.elementid#" height="1px" width="1px"></td> </tr>
			
		    <cfif url.module eq "CaseFile">
			
				<cfparam name="url.level" default="1">
										
				<tr height="95%">
				<cfif url.level eq 0>
					<td align="center" bgcolor="##92d2ff" id="content_#url.elementid#">
				<cfelseif url.level eq 1>
					<td align="center" bgcolor="##ffffc3" id="content_#url.elementid#">				
				<cfelse>
					<td align="center" bgcolor="##f3f3f3" id="content_#url.elementid#">
				</cfif>
				<div style="overflow: hidden; width:70; height:45">
					<cfinclude template="ActiveSheetCellContent.cfm">
				</div>
					</td>
				</tr>
				
			<cfelse>
			
				
			
			</cfif>
			
			</table>
		</td>
		
	</tr>
	
	
</table>
	
</cfoutput>
