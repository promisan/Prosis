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
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfform action="ParameterSubmitProcess.cfm?mission=#URL.mission#"
        method="POST"
        name="flow">			

<cfoutput query="Get">		
		
<table width="93%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
		<cfquery name="MissionPeriod" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization.dbo.Ref_MissionPeriod
			WHERE  Mission = '#URL.Mission#'
			AND Period IN (SELECT Period 
			               FROM   Program.dbo.Ref_Period 
						   WHERE  Procurement = 1)
		</cfquery>	
		
		<cfset url.period = missionPeriod.Period>	
		
		<tr><td height="6"></td></tr>
		<TR>
	    <td class="labelmedium" style="padding-left:3px;cursor: pointer;" width="35%"><cf_UIToolTip tooltip="Allow the requisitioners to collaborate their requisition prior to submission. <b>Attention:</b> Only if enabled, the parameter collaboration in the below box is valid!">Enable Request Preparation workflow:</b></cf_UIToolTip></td>
								 
	    <TD width="65%">
		
		    <cfdiv bind="url:#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#url.mission#&entitycode=procreq" 
			  id="wfprocreq">
		
			</td>
	    </tr>
		
		<TR>
		
	    <TD colspan="2">
		 <table cellspacing="0" cellpadding="0">
		 			
			<input type="hidden" name="enablereview" id="enablereview" value="1">
						
			<cfif EnableReview eq "1">
				<cfset cl = "regular">
			<cfelse>
			    <cfset cl = "regular">			
			</cfif>
			
			<tr id="reqreview" class="<cfoutput>#cl#</cfoutput>">		
			<td>
				<table cellspacing="0" cellpadding="0">
				
					<tr><td width="150" class="labelmedium">&nbsp;Flow&nbsp;settings&nbsp;for:&nbsp;</td>
					
					<td width="70%">
					
					<cfoutput>
					
					<select name="periodselect" id="periodselect" class="regularxl"
					        onchange="ColdFusion.navigate('ParameterEditReqEntryClass.cfm?mission=#url.mission#&period='+this.value,'entryclass')">
					
					<cfloop query="MissionPeriod">
						<cfif defaultPeriod eq "1">
							<cfset url.period = Period>
							<option value="#Period#" selected>#Period#</option>
						<cfelse>
							<option value="#Period#">#Period#</option>	
						</cfif>				
					</cfloop>
					
					</select>
					
					</cfoutput>
							
					</td>
					</tr>				
					
									
			    </table>
			</td> 
	       </tr>
		   </table>
		  </td>
		</tr>   	
		
		<tr>
			<td colspan="2">
				<cfdiv bind="url:ParameterEditReqEntryClass.cfm?mission=#url.mission#&period=#url.period#" id="entryclass">				
			</td>				
		</tr>		
		
		<TR>
		    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Treat requisition header as the lowest atomic entity">Process Mode:</cf_UIToolTip></b></td>
		    <TD>	
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<input type="radio" class="radiol" name="RequisitionProcessMode" id="RequisitionProcessMode" <cfif RequisitionProcessMode eq "1">checked</cfif> value="1">
				</td><td style="padding-left:3px" class="labelmedium">Reference/Header</td>
				<td style="padding-left:3px"><input class="radiol" type="radio" name="RequisitionProcessMode" id="RequisitionProcessMode" <cfif RequisitionProcessMode eq "0">checked</cfif> value="0">
				</td><td style="padding-left:3px" class="labelmedium">Line</td>
			</tr>
						
			</table>
		    </td>
		</tr>
		
		<TR>
		    <td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Send eMail to Substantive reviewer/certifier/funder when actions becomes due">Enable Due Mail:</cf_UIToolTip></b></td>
		    <TD>	
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<input type="radio" class="radiol" name="EnableActorMail" id="EnableActorMail" <cfif EnableActorMail eq "1">checked</cfif> value="1" onclick="document.getElementById('duemailbox').className='regular'">
				</td><td style="padding-left:3px" class="labelmedium">Yes</td>
				<td style="padding-left:5px"><input class="radiol" type="radio" name="EnableActorMail" id="EnableActorMail" <cfif EnableActorMail eq "0">checked</cfif> value="0" onclick="document.getElementById('duemailbox').className='hide'">
				</td><td class="labelmedium" style="padding-left:3px">No</td>
			</tr>
						
			</table>
		    </td>
		</tr>
		
		<tr id="duemailbox" class="<cfif EnableActorMail eq "1">regular<cfelse>hide</cfif>">
			<td colspan="2" align="left" style="padding-left:80px">
				<cfdiv bind="url:ParameterEditReqEntryClassMail.cfm?mission=#url.mission#&period=#url.period#" id="entryclassmail">				
			</td>				
		</tr>	
						
		<TR>
	    	<td class="labelmedium" style="cursor: pointer;"><cf_UIToolTip tooltip="Maximum number of lines to be shown in listing for batch processing.">Lines in Batch Processing view:</cf_UIToolTip></b></td>
		    <TD>
		
			<cfinput type="Text"
	    	   name="LinesInView"
		       value="#LinesInView#"
		       validate="integer"
	    	   required="Yes"
			   size="1"
			   style="text-align:center"
			   class="regularxl"
		       visible="Yes"
		       enabled="Yes">
		
			</td>
	    </tr>	
		
		<tr><td class="line" colspan="2"></td></tr>
		<tr><td colspan="2" align="center" height="34">
		
			<input type="submit" name="Save" id="Save" value="Apply" class="button10g">	
		
		</td></tr>
	
		</table>
		
</cfoutput>				
		
</cfform>		