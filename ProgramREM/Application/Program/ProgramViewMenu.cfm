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


<cfquery name="Parameter"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     Ref_ParameterMission
WHERE    Mission = '#URL.Mission#'
</cfquery>

<cfif Parameter.EnableIndicator eq "1">
  <cfset tg = "Indicator">
<cfelse>
  <cfset tg = "Target">
</cfif>

<cfquery name="ThisProgram"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Program
    WHERE  ProgramCode ='#URL.ProgramCode#'
</cfquery>

<cfif ThisProgram.ProgramClass eq "Project">
   <cfset act = "../Activity/ActivityMain.cfm?Mission=#URL.Mission#&ProgramCode=#URL.ProgramCode#&Size=Small&output=1"> 
<cfelse>
   <cfset act = "ActivityProgram/ActivityView.cfm?Mission=#URL.Mission#&ProgramCode=#URL.ProgramCode#"> 
</cfif>

<cfif URL.ProgramLayout eq "Component"> 
	<input type="hidden" name="urllocation" id="urllocation" value="ActivityProgram/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#">
<cfelseif URL.ProgramLayout eq "Project">
	<input type="hidden" name="urllocation" id="urllocation" value="../Activity/Progress/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#">
<cfelse>
	<input type="hidden" name="urllocation" id="urllocation" value="ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Layout=#URL.ProgramLayout#">
</cfif>

</cfoutput>

<cfset fcolor = "002350">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="left">

<cfquery name="Group" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT ProgramGroup 
      FROM   ProgramGroup 
	  WHERE  ProgramCode = '#URL.ProgramCode#'
</cfquery>	  

<cfquery name="getProcessCycle" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   Ref_ReviewCycle
	  WHERE  Mission     = '#url.mission#'
	  AND    Period      = '#url.period#'
	  AND    Operational = 1
	  AND    DateEffective < getDate()
	  <cfif group.recordcount gte "1">	  
	  AND    CycleId IN (SELECT CycleId 
	                     FROM   Ref_ReviewCycleGroup 
						 WHERE  ProgramGroup IN (SELECT ProgramGroup 
						                         FROM   ProgramGroup 
												 WHERE  ProgramCode = '#URL.ProgramCode#'))
	  </cfif>											 
	  ORDER BY DateEffective DESC		  
</cfquery>

<cfquery name="review" dbtype="query">
	  SELECT * 
	  FROM   getProcessCycle
	  WHERE CycleClass = 'Inception'
</cfquery>	  
		  
<cfif ThisProgram.ProgramClass neq "Program" and review.recordcount gte "1">
	    
		  <tr><td height="4"></td></tr> 
		  <tr><td style="padding-left:5px" class="labelmedium"><cf_tl id="Process Cycle"></td></tr>
		  <tr><td height="4"></td></tr>
		  <tr>
	  		<td height="8" id="cycleinception" style="padding-left:10px">
			<cfinclude template="ProgramViewCycle.cfm">
			</td>
		  </tr>
		  <tr><td height="4"></td></tr>
		
	  
</cfif>
			
	<cfquery name="Period" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
    	  SELECT * 
		  FROM   Ref_Period R, ProgramPeriod Pe
		  WHERE  IncludeListing = 1
		  AND    Pe.ProgramCode = '#URL.ProgramCode#' 
		  AND    Pe.Period = R.Period
		  
	  </cfquery>
	  	
	  <cfset PNo = 0>
	  
	  <tr><td height="3"></td></tr>	  
	  
      <cfoutput query = "Period"> 
	  
		<cfset PNo = PNo+1>
		
        <tr>
          <td class="labelit" style="padding-left:12px"	id="Period#PNo#"> 
		  
		      <table cellspacing="0" cellpadding="0">
			  <tr>
				  <td>
			  
				    <input type="radio" 
					    name="Period" 
						id="Period"						
						value="#Period#" 
					    onClick="ClearRow('Period',#Period.RecordCount#);Period#PNo#.style.fontWeight='bold';updatePeriod(this.value);" <cfif URL.Period eq Period>Checked</cfif>>
	
				   </td>
				   <td class="labelit" style="padding-left:5px">#Description#</td>
			   </tr>
			   </table>		

		  		<cfif URL.Period eq Period>
					
					<input type="hidden" name="periodselect" id="periodselect" value="#Period#">				
					
				</cfif>				

		  </td>
        </tr>		
		
      </cfoutput>  

<tr><td height="10"></td></tr>	 

<tr><td>

	<cfoutput>
		 
		<cfif URL.ProgramLayout eq "Project">
		
			<tr>
			<td height="20px">	
			
			<cf_tl id="Planning" var="1">
			<cfset tAspects = "#Lt_text#">	  
			
			<cfset heading = "#tAspects#">
			<cfset module = "'Program'">
			<cfset selection = "'Program'">
			<cfset menuclass = "'Activities'">
			<cfinclude template="../../../Tools/SubmenuLeft.cfm">
			
			</td>
			</tr> 
		
		</cfif>
		
	</cfoutput>
	
</td></tr>
    
<tr><td>
	
	<cf_tl id="Classification" var="1">
	<cfset tIdentification = "#Lt_text#">
	
	<cfif URL.ProgramLayout eq "Project"> 
	
		<cfoutput>
			<cfset heading   = "#tIdentification#">
			<cfset module    = "'Program'">
			<cfset selection = "'Program'">
			<!---
			<cfset menuclass = "'Details','Classification'">
			--->
			<cfset menuclass = "'Details'">
			<cfset open = "no">
			<cfinclude template="../../../Tools/SubmenuLeft.cfm">
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
			<cfset heading   = "#tIdentification#">
			<cfset module    = "'Program'">
			<cfset selection = "'Program'">
			<cfset menuclass = "'Classification'">
			<cfset open = "no">
			<cfinclude template="../../../Tools/SubmenuLeft.cfm">
		</cfoutput>
	
	</cfif>
	
</td>

</tr>

	<cfquery name="hasChildren" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
    FROM    Program P, ProgramPeriod Pe	
    WHERE   Mission          = '#thisProgram.Mission#'
	AND     P.ProgramCode    = Pe.ProgramCode
	AND     PeriodParentCode = '#ThisProgram.ProgramCode#'
	AND     Period           = '#url.period#'	
	</cfquery>

	<cf_tl id="Sub Components" var="1">
	
	<cfset tDetails = "#Lt_text#">
	
	<cfoutput>
	
		<cfif hasChildren.recordcount gte "1">
		
		<tr><td>
		
			<cfset heading = "#tDetails#">
			<cfset module = "'Program'">
			<cfset selection = "'Program'">
			<cfset menuclass = "'Components'">
			<cfset open = "yes">
			<cfinclude template="../../../Tools/SubmenuLeft.cfm">
			
			</td>
		</tr> 
			
		</cfif>
		
	</cfoutput>		
	
	<cfif URL.ProgramLayout eq "Component">
	
		<cf_tl id="Actions" var="1">
		<cfset tAspects = "#Lt_text#">	  
		<tr><td height="20px">
				<cfset heading = "#tAspects#">
				<cfset module = "'Program'">
				<cfset selection = "'Program'">
				<cfset open = "yes">
				<cfset menuclass = "'Activities','Targets'">
				<cfinclude template="../../../Tools/SubmenuLeft.cfm">
		 </td></tr>

	</cfif>		
		
	<tr>
	  
	  <td height="20px" style="padding-top:10px">
	  
	    <cf_tl id="Resources" var="1">
	    <cfset tResources = "#Lt_text#">
		
		<cfoutput>
		
			<cfset heading   = "#tResources#">
			<cfset module    = "'Program'">
			<cfset selection = "'Program'">
			<cfset open = "yes">
			<cfset menuclass = "'Resources'">
			<cfinclude template="../../../Tools/SubmenuLeft.cfm">
			
		</cfoutput>
		
	  </td>
	  
	</tr>	 	
	
	<tr>
	  
	  <td height="20px" style="padding-top:10px">
	  
	    <cf_tl id="Monitoring" var="1">
	    <cfset tMonitor = "#Lt_text#">
		
		<cfoutput>
		
			<cfset heading   = "#tMonitor#">
			<cfset module    = "'Program'">
			<cfset selection = "'Program'">
			<cfset open      = "yes">
			<cfset menuclass = "'Monitor'">
			<cfinclude template="../../../Tools/SubmenuLeft.cfm">
			
		</cfoutput>
		
	  </td>
	  
	</tr>	
				
	<cfquery name="review" dbtype="query">
		  SELECT * 
		  FROM   getProcessCycle
		  WHERE CycleClass = 'Review'
	</cfquery>	  
			  
	<cfif ThisProgram.ProgramClass neq "Program" and review.recordcount gte "1">
		    	
		  <tr><td height="6"></td></tr>			  
		  <tr>			  
	  		<td height="8" id="cyclereview" style="padding-left:10px">
			<cfset url.cycleclass = "Review">
			<cfinclude template="ProgramViewCycle.cfm">
			</td>
		  </tr>
		  <tr><td height="4"></td></tr>
			 		  
	</cfif> 	
	
	<tr>
		<td>		
			
			<cfoutput>	
					
					<cf_tl id="Management" var="1">
					<cfset tAspects = "#Lt_text#">	  
					
					<cfset heading = "#tAspects#">
					<cfset module = "'Program'">
					<cfset selection = "'Program'">
					<cfset menuclass = "'System'">
					<cfinclude template="../../../Tools/SubmenuLeft.cfm">	
				
			</cfoutput>
			
		</td>
	</tr> 	
					
	<cfquery name="review" dbtype="query">
		  SELECT * 
		  FROM   getProcessCycle
		  WHERE CycleClass = 'Closing'
	</cfquery>	  
			  
	<cfif ThisProgram.ProgramClass neq "Program" and review.recordcount gte "1">
			    
		  <tr><td height="4"></td></tr> 			 
		  <tr>
	  		<td height="8" id="cycleclosing" style="padding-left:10px">
			<cfset url.cycleclass = "Closing">
			<cfinclude template="ProgramViewCycle.cfm">
			</td>
		  </tr>
		  <tr><td height="4"></td></tr>
		  <tr style="padding-top:5px" class="line"><td></td></tr>
		  
	</cfif> 		
	
</table>