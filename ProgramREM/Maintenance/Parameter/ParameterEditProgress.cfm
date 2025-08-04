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
<cfajaximport tags="cfform">

<cfquery name="Get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfoutput query="get">

<cfform method="POST" name="parameterprogress" action="ParameterSubmitProgress.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">	
	
		<tr><td height="12"></td></tr>
				
	    <TR class="labelmedium">
	    <td width="150">Progress mode:</b></td>
	    <TD colspan="3">
			<input type="radio" class="radiol" name="ProgressTransactional" value="1" <cfif ProgressTransactional eq "1">checked</cfif>>Full
			<input type="radio" class="radiol" name="ProgressTransactional" value="0" <cfif ProgressTransactional eq "0">checked</cfif>>Limited
	    </TD>
		</TR>	
		<tr class="labelit" style="color:gray;"><td></td></td><td colspan="3">Defines if progress reporting should be treated <b>FULLY</b> transactional (=each progress entry will be recorded separately) or <b>LIMITED</b> (=only change of status will invoke a new progress record).</td></tr>
		
		<tr><td colspan="4" height="10"></td></tr>
		
	    <TR class="labelmedium">
	    <td>Progress Completed:</b></td>
	    <TD colspan="3">
			<cfinput type="Text" name="ProgressCompleted" value="#ProgressCompleted#" message="Please enter a numberic value" style="text-align: center;" validate="integer" required="Yes" size="1" maxlength="1" class="regularxl">
	    </TD>
		</TR>	
		<tr class="labelit" style="color:gray;"><td></td><td colspan="3">The status code used to indicate that Project/Program activity output has been <b>completed.</b></td></tr>
		
		<tr><td colspan="4" height="10"></td></tr>
		
	    <TR class="labelmedium">
	    <td width="190">Apply Progress to GANTT:</b></td>
	    <TD colspan="3">
			<input type="radio" class="radiol" name="ProgressApply" value="1" <cfif ProgressApply eq "1">checked</cfif>>Enabled
			<input type="radio" class="radiol" name="ProgressApply" value="0" <cfif ProgressApply eq "0">checked</cfif>>Disabled
	    </TD>
		</TR>	
		<tr class="labelit" style="color:gray;"><td></td></td><td colspan="3">Apply early progress or delayed completion to the GANTT chart by adjusting the activity enddates based on the recorded completion date.</td></tr>
		<tr><td colspan="4" height="10"></td></tr>
		
		 <TR class="labelmedium">
	    <td width="230">Summary Content:</b></td>
	    <TD colspan="3">
			<input type="text" style="width:90%" class="regularxl" name="ProgressTemplate" value="#ProgressTemplate#">			
	    </TD>
		</TR>	
		
		<tr><td height="4" colspan="2"></td></tr>
		<tr class="line"><td height="1" colspan="4"></td></tr>
		<tr><td height="4" colspan="2"></td></tr>
		
		 <!--- Field: Period --->
	 
		<cfquery name="Period" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_Period
			WHERE Period IN (SELECT Period FROM Organization.dbo.Ref_MissionPeriod WHERE Mission = '#URL.Mission#')
			ORDER BY Period 
		</cfquery>	 
		 
	    <TR class="labelmedium">
	    <td>Default Progress period:</b></td>
	    <TD>
		
			<select name="DefaultProgressPeriod" message="Please select a program period" style="text-align: right;" class="regularxl">
					<option value="">System default</option>			
					<cfloop query="Period">
						<option value="#Period#" <cfif Get.DefaultProgressPeriod eq Period> SELECTED</cfif>>
						#Period#
						</option>
					</cfloop>
		   	</select>
	    </TD>
		</TR>		
			
		<cfquery name="Period" 
		  datasource="AppsProgram" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	      SELECT *
	      FROM Ref_SubPeriod
	  	</cfquery>
	    		
	    <TR class="labelmedium">
	    <td>Default Subperiod:</b></td>
	    <TD>
		
	  <cfloop query = "Period">
	 	 <input type="radio" class="radiol" name="DefaultPeriodSub" value="#SubPeriod#" <cfif Get.DefaultPeriodSub eq SubPeriod>checked</cfif>>&nbsp;#Description#
	  </cfloop>  
		  	 
	    </TD>
	</TR>		
	<tr class="labelit" style="color:gray;"><td></td><td colspan="3" class="header">Legacy parameter : The default period that the system will display for Program activity progress reporting.</td></tr>
	<tr><td colspan="4" height="10"></td></tr>
	
	<tr><td height="10"></td></tr>	
	<tr><td height="1" colspan="4" class="line"></td></tr>	
						
	<tr><td height="40" colspan="4" align="center">	
		<input type="Submit" name="Save" value="Update" class="button10g">
	</td></tr>
	</table>	
	
</cfform>
	
	
</cfoutput>	