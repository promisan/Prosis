		
<cftree name="root"
   font="calibri"
   fontsize="12"		
   bold="No"   
   format="html"    
   required="No">
   
   		
	   	<cf_tl id="Personnel Action" var="vAction">	  
   
   		<cftreeitem value="PA"
	        display="<span class='labelmedium' style='color:0080C0;font-size:18px;padding-bottom:3px'>#vAction#</span>"
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
			
				<cftreeitem value="#ActionSource#"
			        display="<span class='labelmedium' style='font-size:12px;padding-bottom:3px'>#Description#</span>"
					parent="PA"	
					target="right"						
					href="EntitlementViewOpen.cfm?ID1=#ActionSource#&ID=ACT&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"		
			        expand="Yes">	
			
			</cfloop>	
						
		<cftreeitem value="dummy" display="<span class='labelit' style='height:10px;font-size:12px'>&nbsp;</span>" parent="root" expand="no">	
			  									
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
					
		<cfoutput query="TriggerList" group="TriggerGroup">
					
			<cfif TriggerGroup eq "Entitlement">
				<cfset exp = "No">				
			<cfelse>
			    <cfset exp = "Yes">
			</cfif>
						
			<cftreeitem value="group_#TriggerGroup#"
		        display="<span class='labelmedium' style='font-size:18px;color:0080C0;padding-bottom:3px'>#TriggerGroup#</span>"
				target="right"	
				href="EntitlementViewOpen.cfm?ID=GRP&ID1=#TriggerGroup#&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"		
				parent="root"													
		        expand="#exp#">								
		
			<cfoutput>
							   			   		       					   											   
			   	   <cftreeitem value="#SalaryTrigger#"
				        display="<span class='labelmedium'>#Description#</span>"
						parent="group_#TriggerGroup#"	
						target="right"	
						href="EntitlementViewOpen.cfm?ID=TRG&ID1=#SalaryTrigger#&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"												
				        expand="No">		
			   
			</cfoutput> 	
			
			<cftreeitem value="dummy" display="" parent="root" expand="Yes">	
		
	    </cfoutput>	
					
		
		
		 <cf_tl id="Cost recovery" var="vCost">	
		
		<cftreeitem value="Recovery"
        display="<span class='labelmedium' style='color:0080C0;font-size:18px;padding-bottom:3px'>#vCost#</span>"
		parent="root"	
		target="right"						
		href="EntitlementViewOpen.cfm?ID1=&ID=PCR&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"		
        expand="Yes">	
		
		
</cftree>   
	   
