

<cfinvoke component="Service.AccessGlobal"
	Method="global"
	Role="PayrollOfficer"
	ReturnVariable="Manager">	

<cfif Manager is "Edit"  or Manager is "ALL">
	
	<cfoutput>
				
	<table border="0" width="89%" height="100%" align="center" class="formpadding">
	
		<tr class="labelmedium line" style="height:35px">
		<td style="min-width:300px;width:300px"><cf_tl id="Action">:</td><td style="font-size:16px"><cf_tl id="Recalculation of entitlements and settlements"></td></tr>
		<tr class="labelmedium line" style="height:35px">
		   <td style="font-size:16px"><cf_tl id="Requester">:</td>
		   <td>#SESSION.first# #SESSION.last# on #timeformat(now(),"HH:MM:SS")#</td></tr>	
											
		<tr class="labelmedium line" style="height:35px">
		      <td style="font-size:16px"><cf_tl id="Entity">:</td>
			  <td>		
			  
			  <cfquery name="MissionList" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   DISTINCT Mission 
				FROM     PersonContract
				WHERE    PersonNo = '#url.id#'				
				AND      RecordStatus = '1'		
			   </cfquery>	
			 								
				<select name="mission" id="mission" class="regularxl" onchange="ptoken.navigate('#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGo.cfm?id=#url.id#','progressbox')">
				 	<cfloop query="missionList">
				 		<OPTION value="#mission#" <cfif currentrow eq "1">selected</cfif>>#Mission#</OPTION>
				 	</cfloop>
     			</select>
				
			   </td>
	    </tr>	
		
		<tr class="labelmedium line" style="height:35px">
		    <td style="font-size:16px">Calculated Entitlements as of (EOD):</td>
			<td id="startdate">					  
			  <cfdiv bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=eod&id=#url.id#&mission={mission}">			 	
			</td>
	    </tr>	
		
		<tr class="labelmedium line" style="height:35px">
		    <td style="font-size:16px">Applicable Schedules:</td>
			<td>				  
			  <cfdiv bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=schedule&id=#url.id#&mission={mission}">			 				
		    </td>
	    </tr>	
		
		<tr class="labelmedium line" style="height:35px">
		    <td style="font-size:16px">Recalculate the entitlements starting month:</td>
			<td>					  
			   <cfdiv bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=period&id=#url.id#&mission={mission}">		 	
		    </td>
	    </tr>	
		
		<!--- if the person is not under contract for the current month --->
		
		<tr class="labelmedium" id="enforce" style="height:35px">
	      <td style="font-size:16px" height="10">Settle if not under contract :</td>
		  <td>
		     <cfdiv bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGet.cfm?action=enforce&id=#url.id#&mission={mission}">		 	
			 
			 <input type="hidden" id="forcesettlement" value="0">		 
		  </td>
	    </tr>

		<tr><td colspan="2" class="line"></td></tr>
		<tr><td colspan="2" class="hide" id="runbox" class="labelit"></td></tr>
		<tr><td colspan="2" height="100%" id="progressbox" valign="top">
		
			<cf_securediv bind="url:#session.root#/payroll/application/calculation/CalculationProcessExecutePersonGo.cfm?id=#url.id#">
			
		</td></tr>
			
	</table>
	
	
	</cfoutput>

</cfif>