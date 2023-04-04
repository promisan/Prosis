
<cfparam name="url.selecteddate"   default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="url.orgunit" default="0">

<cfif url.selecteddate eq "">
	<cfset url.selecteddate = "#dateformat(now(),client.dateformatshow)#">
</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#url.selecteddate#">
<cfset DTS = dateValue>

<cfif url.orgUnit eq 0 or Url.orgUnit eq "">
	<cfif client.personNo neq "">
		<cfquery name="qCurrentUnit"
				datasource="AppsWorkOrder"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT *
			FROM Employee.dbo.PersonAssignment PA
			WHERE PersonNo = '#client.personNo#'
			AND DateEffective  <= #dts#
			AND DateExpiration >= #dts#
			AND Incumbency = 100
			AND AssignmentStatus IN ('0','1')
			AND EXISTS
			(
			SELECT 'x'
			FROM Employee.dbo.WorkSchedulePosition WP
			WHERE WP.PositionNo = PA.PositionNo
			)
		</cfquery>

		<cfset url.orgUnit = qCurrentUnit.OrgUnit>

	</cfif>
</cfif>



<cfquery name="Unit" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	 
     SELECT  O.Mission, 
	         O.OrgUnit, 
			 O.OrgUnitName
	 FROM    Organization.dbo.Organization O 
	 WHERE   O.Mission = '#url.mission#' 
	 <!--- ALERT filter this for the selected month : refresh this upon month selection --->	
 	 AND     O.DateEffective <= #dts+30#
	 AND     O.DateExpiration >= #dts#			
	 
	 <!--- this orgunit is enabled in one of the schedules --->
	 	
	 AND     O.OrgUnit IN (	  SELECT   WSO.OrgUnit
							  FROM     Employee.dbo.WorkScheduleOrganization AS WSO INNER JOIN
					                   Employee.dbo.WorkSchedule AS WS ON WSO.WorkSchedule = WS.Code
							  WHERE    Mission = '#url.mission#'			 
  						  )					  	 
</cfquery>	


<cfif Unit.recordcount eq "0">
	
	<cfquery name="Unit" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	 
	     SELECT  O.Mission, 
		         O.OrgUnit, 
				 O.OrgUnitName
		 FROM    Organization.dbo.Organization O 
		 WHERE   O.Mission = '#url.mission#' 
		 <!--- ALERT filter this for the selected month : refresh this upon month selection --->	
	 	 AND     O.DateEffective <= #dts+30#
		 AND     O.DateExpiration >= #dts#		
		 		
	</cfquery>	
	
</cfif>

<!--- pre check if this user has any access at all --->

<cfset hasRecords = "0">
	
<cfloop query="Unit">
		   			   			   
 	 <cfinvoke component = "Service.Access"  
		method           = "workorderprocessor" 
		mission          = "#url.mission#" 	
		orgunit          = "#orgunit#"					  
		returnvariable   = "access">  

	   <cfif access neq "NONE">
	        <cfset hasRecords = "1">		     		     
	   </cfif>	  
		   
</cfloop>

<cfif hasRecords eq "0">

	<table width="100%" border="0">
	<tr><td style="padding-top:60px" class="labellarge" align="center"><font color="FF0000"><cf_tl id="No access"></td></tr>
	</table>
	
	<input type="hidden" name="orgunitimplementer" id="orgunitimplementer" value="">
	
	<tr class="hide"><td id="unitcontent"></td></tr>
	
	<cfset url.positionno = "">

<cfelse>
	
	<table border="0">
	
		<tr><td style="padding-top:7px;padding-right:20px">	  
		
		<cfoutput>		
					  
			 <select name="orgunitimplementer" id="orgunitimplementer" 
				 onchange="try{schedule()}catch(e){};calendarmonth(document.getElementById('currentdate').value,'none','standard','seldate','orgunit='+this.value);ptoken.navigate('#session.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/ActivitySelectPerson.cfm?mission=#url.mission#&orgunit='+this.value+'&selecteddate=#url.selecteddate#','unitcontent')"
				 style="width:200px;font-size:17px;height:30px" 
				 class="regularxl">  
			 
			 	   <cfset match      = "0"> 
				   <cfset hasRecords = "0">
				   				  
				   <cfloop query="Unit">
				   			   			   
				  		 <cfinvoke component = "Service.Access"  
							method           = "workorderprocessor" 
							mission          = "#url.mission#" 	
							orgunit          = "#orgunit#"					  
							returnvariable   = "access">  
					   				   
						   <cfif access neq "NONE">		
						      <cfset hasRecords = "1">		     
						      <option value="#OrgUnit#" <cfif url.orgunit eq Orgunit>selected</cfif>>#OrgUnitName#</option>
							  <cfif (url.orgunit eq Orgunit or url.orgunit eq "0") and match eq "0">
							  	<cfset match = "1">
								<cfset url.orgunit = orgunit>
							  </cfif>
						   </cfif>	  
						   
				   </cfloop>
				   
			 </select>		
			 		
		</cfoutput>

		</td></tr>	
		
		<tr><td id="unitcontent">
			
		<cfif match eq "0">	
		    <cfset url.orgunit = unit.orgunit>			
		</cfif>
												
		<cfinclude template="ActivitySelectPerson.cfm">			
			
		</td></tr>
			
	</table>
	
</cfif>	

