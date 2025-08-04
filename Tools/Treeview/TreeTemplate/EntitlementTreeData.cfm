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

  <!--- obtain accesss --->
	  
   <cfinvoke component="Service.Access"
		Method         = "contract"
		Mission        = "#attributes.Mission#"			
		Role           = "'ContractManager'"
		ReturnVariable = "AccessContract">	
			  
  <cfinvoke component="Service.Access"
		Method         = "payrollofficer"
		Mission        = "#attributes.Mission#"			
		Role           = "'PayrollOfficer'"
		ReturnVariable = "AccessPayroll">	
			
	<cf_UItree
		id="root"
		root="no"
		title="<span style='font-size:16px;color:gray;padding-bottom:3px;padding-top:3px'>#attributes.mission#</span>"	
		expand="Yes">			
	  
	    <cfif AccessContract eq "NONE" and AccessPayroll eq "NONE">
		
		<cfelse>
  		
	   	<cf_tl id="Personnel Action" var="vAction">	  
		
		<cf_UItreeitem value="PA"
		        display="<span class='labelit' style='font-weight:bold;font-size:18px;padding-bottom:3px;padding-top:3px'>#vAction#</span>"
				parent="root"	
				target="right"						
				href="EntitlementViewOpen.cfm?ID1=&ID=ACT&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"									
		        expand="No">
      					
			<cfquery name="ActionSource" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT    ActionSource, Description
				FROM      Ref_ActionSource
				WHERE     ActionSource NOT IN ('Position', 'Person', 'Overtime', 'Assignment')
			</cfquery>
			
			<cfloop query="ActionSource">
			
				<cf_UItreeitem value="#ActionSource#"
		        display="<span class='labelit' style='font-size:14px'>#Description#</span>"
				parent="PA"					
				target="right"						
				href="EntitlementViewOpen.cfm?ID1=#ActionSource#&ID=ACT&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"	
		        expand="No">	
			
			</cfloop>	
			
		 <cf_tl id="Delayed settlements" var="vDelayed">	
		 
		 <cf_UItreeitem value="Delayed"
		        display="<span class='labelit' style='font-weight:bold;font-size:18px;padding-bottom:3px;padding-top:3px'>#vDelayed#</span>"
				parent="root"	
				target="right"						
				href="EntitlementViewOpen.cfm?ID1=&ID=DEL&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"									
		        expand="No">	
				
			<cfquery name="Item" 
			    datasource="AppsPayroll" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">	
				SELECT    *
				FROM      Ref_PayrollItem
				WHERE     SettlementMonth <> '0'	
			</cfquery>	
				
			<cfloop query="Item">
				
					<cf_UItreeitem value="Del_Delayed"
			        display="<span class='labelit' style='font-size:14px'>#PayrollItemName#</span>"
					parent="Delayed"					
					target="right"						
					href="EntitlementViewOpen.cfm?ID1=#PayrollItem#&ID=DEL&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"	
			        expand="No">	
				
			</cfloop>			
				
		</cfif> 
			  									
		<cfquery name="TriggerList" 
		    datasource="AppsPayroll" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			
			SELECT *
				FROM (
					SELECT    *
					FROM      Ref_PayrollTrigger
					WHERE     SalaryTrigger IN
		               	          (SELECT   SalaryTrigger
		                   	       FROM     Ref_PayrollComponent PC INNER JOIN
		                                       SalaryScheduleComponent S ON PC.Code = S.ComponentName INNER JOIN
		                                       SalaryScheduleMission M ON S.SalarySchedule = M.SalarySchedule
		                              WHERE    M.Mission = '#Attributes.Mission#')
					AND       Operational = 1 and TriggerGroup != 'Personal'
					
					UNION
					
					SELECT    *
					FROM      Ref_PayrollTrigger
					WHERE     Operational = 1	
					AND       TriggerGroup = 'Personal'			  
					) as B
			
			WHERE TriggerGroup != 'Contract'
			
			ORDER BY  TriggerGroup		
						
		</cfquery>
		
		<cfif AccessPayroll neq "NONE">
							
			<cfoutput query="TriggerList" group="TriggerGroup">
						
				<cfif TriggerGroup eq "Entitlement">
					<cfset exp = "No">				
				<cfelse>
				    <cfset exp = "Yes">
				</cfif>
				
				<cf_UItreeitem value="group_#TriggerGroup#"
			        display="<span class='labelit' style='font-weight:bold;font-size:18px;padding-bottom:3px;padding-top:3px'>#TriggerGroup#</span>"
					parent="root"	
					target="right"						
					href="EntitlementViewOpen.cfm?ID=GRP&ID1=#TriggerGroup#&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"									
			        expand="#exp#">								
			
				<cfoutput>
				
					<cf_UItreeitem value="#SalaryTrigger#"
			        display="<span class='labelit' style='font-size:13px'>#Description#</span>"
					parent="group_#TriggerGroup#"	
					target="right"						
					href="EntitlementViewOpen.cfm?ID=TRG&ID1=#SalaryTrigger#&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"									
			        expand="No">		
								   
				</cfoutput> 	
						
		    </cfoutput>	
			
		</cfif>	
				
		 <cf_tl id="Miscellaneous" var="vCost">	
		 
		 <cf_UItreeitem value="Recovery"
		        display="<span class='labelit' style='font-weight:bold;font-size:18px;padding-bottom:3px;padding-top:3px'>#vCost#</span>"
				parent="root"	
				target="right"						
				href="EntitlementViewOpen.cfm?ID1=&ID=PCR&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"									
		        expand="No">	
				
			<cf_UItreeitem value="Recovery_earning"
		        display="<span class='labelit' style='font-size:13px;'>Earning</span>"
				parent="Recovery"	
				target="right"						
				href="EntitlementViewOpen.cfm?ID1=Payment&ID=PCR&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"									
		        expand="#exp#">		
				
			<cf_UItreeitem value="Recovery_deduction"
		        display="<span class='labelit' style='font-size:13px'>Deduction</span>"
				parent="Recovery"	
				target="right"						
				href="EntitlementViewOpen.cfm?ID1=Deduction&ID=PCR&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"									
		        expand="#exp#">		
				
			<cf_UItreeitem value="Recovery_contribution"
		        display="<span class='labelit' style='font-size:13px'>Contribution</span>"
				parent="Recovery"	
				target="right"						
				href="EntitlementViewOpen.cfm?ID1=Contribution&ID=PCR&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"									
		        expand="#exp#">	
			
</cf_UItree>
		
	   
