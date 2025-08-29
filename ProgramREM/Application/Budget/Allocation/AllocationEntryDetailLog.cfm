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
<cfset fdlist = replaceNoCase(url.fdlist,":","","ALL")> 

<table width="99%" cellspacing="0" cellpadding="0" style="border:0px dashed silver" class="formpadding">

	<cfoutput>		
							
		<tr>	
		
		    <cfset detail = "0">
																												
			<cfloop index="fund" list="#fdlist#" delimiters=",">
												
				<cfquery name="getLog" 
				    datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     ProgramAllotmentAllocationDetail
						WHERE    ProgramCode  = '#url.programcode#'								
						AND      EditionId    = '#url.editionid#'
						AND      Period       = '#url.period#'
						AND      ObjectCode   = '#url.ObjectCode#'
						AND      Fund         = '#fund#'
						ORDER BY Created DESC
				</cfquery>							
											
				<td align="right" style="padding-right:1px" colspan="3" valign="top" style="border:1px solid silver">			
					
					<cf_space spaces="#url.spc*3#">		
					
					<table width="100%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
					
					<cfloop query="getLog">
					
						<tr class="labelit navigation_row line"><td style="padding-left:2px">#OfficerLastName#</td>
						    <td style="padding-top:1px;padding-left:3px;padding-right:3px">
							 <cf_img icon="edit" onclick="ColdFusion.navigate('AllocationEntryDetailLogMemo.cfm?mode=edit&id=#allocationid#','edit_#allocationid#')" width="10" alt="" border="0">
							</td>
						    <td style="padding-left:2px">#Dateformat(created,CLIENT.DateFormatShow)# #Timeformat(created,"HH:MM")#</td>							
						    <td style="padding-right:2px" align="right">#numberformat(amount,"__,__")#</td>
						</tr>
						
						<tr class="labelit navigation_row_child line">
							<td style="padding:3px" colspan="4" class="labelsmall" id="edit_#allocationid#">#Remarks#</td>						
						</tr>
												
						<cfset detail = 1>
					
					</cfloop>
					
					</table>										
				</td>	
																		
			</cfloop>			
			<td align="right" style="padding-left:2px"><cf_space spaces="#url.spc#">
			
		</tr>					
			
		<cfif detail eq "0">
		    <tr><td style="padding-left:4px;padding-bottom:7px" class="label"><font color="808080">No details found</td></tr>			
		</cfif>			
				
	</cfoutput>
	
</table>

<cfset ajaxonload("doHighlight")>