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
<cfparam name="url.category" 		default="">
<cfparam name="url.programaccess" 	default="">

<cfquery name="Target" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
   	  SELECT	*
	  FROM  	ProgramTarget
	  WHERE 	ProgramCode  = '#url.ProgramCode#'
	  AND   	Period = '#url.period#'
	  <cfif url.category neq "">
	  AND       ProgramCategory = '#url.category#'
	  </cfif>
	  AND 		ActionStatus != '9' 
	  AND 		RecordStatus = '1'
	  ORDER BY ListingOrder
</cfquery>

<cf_calendarscript>

<table width="100%" align="center">
	
	<tr>
		<td align="center">
		
		<cfif url.ProgramAccess eq "EDIT" or url.ProgramAccess eq "ALL">
		
			<cf_tl id="Add Target" var="1">
			<cfoutput>
				<input type="button" style="width:200px;height:25px" class="button10g" onclick="editTarget('#url.ProgramCode#','#url.period#','','#url.category#','#url.programaccess#')" value="#lt_text#">
			</cfoutput>
			
		</cfif>	
		
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td class="linedotted" colspan="2"></td></tr>
	<tr><td height="10"></td></tr>

</table>

<table width="96%" class="navigation_table" align="center">

	<cfif Target.recordCount eq 0>
		<tr><td height="10"></td></tr>
		<tr>
			<td class="labelmedium" style="color:#808080;" align="center">[ <cf_tl id="No targets defined"> ]</td>
		</tr>
		<tr><td height="10"></td></tr>
	</cfif>

	<cfoutput query="Target" group="TargetClass">
	
		<tr><td colspan="4" class="labellarge">#TargetClass#</td></tr>
	
		<cfoutput>
			<tr class="labelmedium navigation_row">
				
				<td valign="top" style="height:35px;padding-top:7px;width:20px;padding-left:5px" class="labelit"><b>#TargetReference#</b>.</td>
				<td style="font-size:18px">#ParagraphFormat(TargetDescription)#</td>
				<td valign="top" align="right" style="padding-top:3px;padding-right:4px">#dateformat(targetDueDate,client.dateformatshow)#</td>							
				
				<td valign="top" width="1%" style="padding-top:3px;padding-left:3px;">
				
				<cfinvoke component="Service.Access"
					Method="program"
					ProgramCode="#URL.ProgramCode#"
					Period="#URL.Period#"	
					ReturnVariable="ProgramAccess">	
					
					<cfif ProgramAccess eq "EDIT" or ProgramAccess eq "ALL"> 
		
					<table style="padding;3px;border:1px dotted silver;">
						<tr>
							<td style="padding:3px;">
								<cf_img icon="edit" onclick="editTarget('#url.ProgramCode#','#url.period#','#targetId#','#url.category#','#url.programaccess#');">
							</td>
							<td style="padding:3px;">							
								<cf_img icon="delete" onclick="removeTarget('#url.ProgramCode#','#url.period#','#targetId#','#url.category#','#url.programaccess#');">
							</td>
						</tr>
					</table>
					
					</cfif>
				</td>
				
			</tr>
						
			<tr class="labelit navigation_row_child linedotted">			  
				<td valign="top" style="padding-top:2px;padding-left:10px"><cf_tl id="Indicator"></td>
				<td colspan="3" style="padding-left:0px" class="labelit">#ParagraphFormat(TargetIndicator)#</td>
			</tr>
			<tr class="labelit navigation_row_child linedotted">			  
				<td valign="top" style="padding-top:2px;padding-left:10px"><cf_tl id="Target"><cf_space spaces="35"></td>
				<td colspan="3" style="padding-left:0px" class="labelit">#ParagraphFormat(Outcome)#</td>
			</tr>			
			<tr class="labelit navigation_row_child linedotted">			  
				<td valign="top" style="padding-top:2px;padding-left:10px"><cf_tl id="Verification"></td>
				<td colspan="3" style="padding-left:0px" class="labelit">#ParagraphFormat(OutcomeVerification)#</td>
			</tr>
			<tr class="labelit navigation_row_child linedotted">			  
				<td valign="top" style="padding-top:2px;padding-left:10px"><cf_tl id="External Factor"></td>
				<td colspan="3" style="padding-left:0px" class="labelit">#ParagraphFormat(ExternalFactor)#</td>
			</tr>
			
			<!--- show associated activities --->
			
			<cfquery name="Activity" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		   	  SELECT	*
			  FROM  	ProgramActivity A, ProgramActivityOutput O
			  WHERE     A.ProgramCode    = O.ProgramCode
			  AND       A.ActivityPeriod = O.ActivityPeriod
			  AND       A.ActivityId     = O.ActivityId
			  AND    	A.ProgramCode    = '#url.ProgramCode#'
			  AND   	A.ActivityPeriod = '#url.period#'
			  AND       O.TargetId       = '#targetid#' 			 
			  AND 		A.RecordStatus  != '9'
			  AND       O.RecordStatus  != '9'
			  ORDER BY ActivityDateStart
			</cfquery>
			
			<cfloop query="Activity">			
			
			<tr bgcolor="f4f4f4" class="labelit line">			  
				<td style="padding-left:10px"><cfif currentrow eq "1"><cf_tl id="Activities"></cfif></td>
				<td colspan="3" style="padding-left:0px" class="labelit"><a href="javascript:edit('#activityid#')"><font color="0080C0">#ActivityDescription#</font></a></td>
			</tr>
			
			</cfloop>
			
			<tr><td style="height:10px"></td></tr>
			
		</cfoutput>
		
		<tr><td height="10" id="targetsubmit"></td></tr>
	
	</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>
<script>
	Prosis.busy('no');
</script>