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
<cfoutput>
<tr id="#drillbox#" class="hide">
 	<td colspan="#cols+2#">
	
		<table bgcolor="white" width="100%" align="left" border="0" cellspacing="0" cellpadding="0">
		   
			<tr id="header_#drillbox#" class="hide">	
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
				 <tr>
				 
					<td class="top4n" height="24">
					
					<!---
					<input onclick="exportexcel('#SESSION.acc#_#fileNo#_#node#_summary_detail','drill')" style="width:110px" type="button" class="buttonNav" name="drill" value="Analyse subset">
					<input onclick="" type="button" class="buttonNav" name="drill" style="width:110px" value="Export Excel">
					--->
					
					</td>
					<td class="top4n" align="right">
					<img src="#SESSION.root#/Images/close1.gif" align="absmiddle" style="cursor: pointer;" onClick="javascript:hide('#drillbox#')">&nbsp;
					&nbsp;
					</td>
				 </tr>
				 <cfloop index="itm" list="graph,detail" delimiters=",">
				 
				 <tr><td colspan="2">
					<table width="100%" border="0" class="regular">
						<cfif #itm# eq "Graph">
							<tr><td colspan="3" class="hide" id="#itm#_#drillbox#_content">
							
							<iframe name="#itm#_#drillbox#_data"
								        id="#itm#_#drillbox#_data"
								        width="100%"
								        height="300"
								        valign="middle"
								        scrolling="no"
								        frameborder="0"
								        border="0"></iframe>
										
							</td></tr>
						<cfelse>
							<tr><td colspan="3" bgcolor="ffffff" class="hide" id="#itm#_#drillbox#_content">
							
								<iframe name="#itm#_#drillbox#_data"
								        id="#itm#_#drillbox#_data"
								        width="100%"
								        height="280"
								        valign="middle"
								        scrolling="no"
								        frameborder="0"
								        border="0"></iframe>
										
							</td></tr>
						</cfif>		
					</table>
			    </td></tr>	
				</cfloop>
				</table>
				</td>
			</tr>
		</table>
	
	</td>
</tr>
</cfoutput>