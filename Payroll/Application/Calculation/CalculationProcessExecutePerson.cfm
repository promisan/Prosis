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


<cfinvoke component="Service.AccessGlobal"
	Method="global"
	Role="PayrollOfficer"
	ReturnVariable="Manager">	

<cfif Manager is "Edit"  or Manager is "ALL">
	
	<cfoutput>
				
	<table border="0" width="89%" height="100%" align="center" class="formpadding">
	
		<tr class="labelmedium line" style="height:35px">
		<td style="min-width:300px;width:300px;"><cf_tl id="Action">:</td><td style="padding-left:5px;font-size:16px; border-left:1px solid silver;border-right:1px solid silver"><cf_tl id="Recalculation of entitlements and settlements"></td></tr>
		<tr class="labelmedium line" style="height:35px">
		   <td style="font-size:16px"><cf_tl id="Requester">:</td>
		   <td style="font-size:16px;border-left:1px solid silver;border-right:1px solid silver;padding-left:5px">#SESSION.first# #SESSION.last# on #timeformat(now(),"HH:MM:SS")#</td></tr>	
											
		<tr class="labelmedium line" style="height:35px">
		      <td style="font-size:16px"><cf_tl id="Entity">:</td>
			  <td colspan="1" style="border-left:1px solid silver;border-right:1px solid silver">		
			  
			  <cfquery name="MissionList" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   DISTINCT Mission 
				FROM     PersonContract
				WHERE    PersonNo = '#url.id#'				
				AND      RecordStatus = '1'		
			   </cfquery>	
			 								
				<select name="mission" id="mission" style="border:0px;width:100%" class="regularxxl" 
				     onchange="ptoken.navigate('#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGo.cfm?id=#url.id#','progressbox')">
				 	<cfloop query="missionList">
				 		<OPTION value="#mission#" <cfif currentrow eq "1">selected</cfif>>#Mission#</OPTION>
				 	</cfloop>
     			</select>
				
			   </td>
	    </tr>	
		
		<tr class="labelmedium2 line" style="height:35px">
		    <td style="font-size:16px">Calculated Entitlements as of (EOD):</td>
			<td id="startdate" colspan="1" style="border-left:1px solid silver;border-right:1px solid silver">					  
			  <cf_securediv id="start" bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=eod&id=#url.id#&mission={mission}">			 	
			</td>
	    </tr>	
		
		<tr class="labelmedium2 line" style="height:35px">
		    <td style="font-size:16px">Applicable Schedules:</td>
			<td colspan="1"  style="padding-left:5px;border-left:1px solid silver;border-right:1px solid silver">				  
			  <cf_securediv id="schedule" bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=schedule&id=#url.id#&mission={mission}">			 				
		    </td>
	    </tr>	
		
		<tr class="labelmedium2 line" style="height:35px">
		    <td style="font-size:16px">Recalculate the entitlements starting month:</td>
			<td  style="border-left:1px solid silver;border-right:1px solid silver">							  
			<table style="height:100%">
			<tr><td style="border-right:1px solid silver">
			   <cf_securediv id="recalc" bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=period&id=#url.id#&mission={mission}">		 	
		    </td>
			<td style="font-size:16px;padding-left:5px;padding-right:5px">until:</td>
			<td style="border-left:1px solid silver;border-right:1px solid silver">							  
			   <cf_securediv id="until" bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=periodend&id=#url.id#&mission={mission}">		 	
		    </td>
			</tr>
			</table>
			</td>
			
	    </tr>	
		
		<!--- if the person is not under contract for the current month --->
		
		<tr class="labelmedium2" id="enforce" style="height:35px">
	      <td style="font-size:16px" height="10">Settle if not under contract :</td>
		  <td  style="border-left:1px solid silver;border-right:1px solid silver">
		     <cf_securediv id="settle" bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=enforce&id=#url.id#&mission={mission}">		 				 
			 <input type="hidden" id="forcesettlement" value="0">		 
		  </td>
	    </tr>

		<tr><td colspan="2" class="line"></td></tr>
		<tr><td colspan="2" class="hide" id="runbox" class="labelit"></td></tr>
		<tr><td colspan="2" height="100%" id="progressbox" valign="top">		
			<cf_securediv id="go" bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGo.cfm?id=#url.id#">			
		</td></tr>
			
	</table>
	
	
	</cfoutput>

</cfif>