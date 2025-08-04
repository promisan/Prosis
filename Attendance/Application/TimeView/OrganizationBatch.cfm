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

<cfparam name="URL.startyear"   default="#Year(client.timesheetdate)#">
<cfparam name="URL.startmonth"  default="#Month(client.timesheetdate)#">
										   
<cfset dateob=CreateDate(URL.startyear,URL.startmonth,1)>
	 
<cfquery name="action" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	OrganizationAction
	WHERE   OrgUnit = #URL.ID0#
	AND     CalendarDateStart = #DateOb# 	
	ORDER BY Created
</cfquery>

<cfset FIRSTOFMONTH=CreateDate(Year(DateOb),Month(DateOb),1)>
<cfset ENDOFMONTH=CreateDate(Year(DateOb),Month(DateOb),DaysInMonth(DateOb))>
<cfset showtop = DayOfWeek(FIRSTOFMONTH) - 1>  

<!--- -------------------------------------------------- --->
<!--- -------- obtain people to be shown into memory --- --->
<!--- -------------------------------------------------- --->

<!--- we show the tree of a mission and from that tree unit we show
the people with an assignment to that unit in the month. 

Attention this could be a person
coming from a different mission which is assignment to this unit !!!! --->
						
<cfquery name="UnitList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	    SELECT 	
		        DISTINCT 
		        A.AssignmentNo,
		        P.PersonNo, 
				A.DateEffective, 
				A.DateExpiration, 
				O.Mission  <!--- this normally is the mission of the tree from where it was selected --->
								
		FROM 	Person P INNER JOIN PersonAssignment A ON P.PersonNo = A.PersonNo
				INNER JOIN Position Pos ON A.PositionNo = Pos.PositionNo 
				INNER JOIN Organization.dbo.Organization O ON A.OrgUnit = O.OrgUnit
				
		WHERE   A.OrgUnit          = #URL.ID0#
		-- AND     A.Incumbency       > '0'       <!--- has an incumbecny : ASG STL excluded --->
		AND     A.AssignmentStatus IN ('0','1')
		-- AND     A.AssignmentClass  = 'Regular' <!-- not needed loan staff can also have leave --->
		AND     A.AssignmentType   = 'Actual'
		AND     A.DateEffective   <= #EndOFMonth#
		AND     A.DateExpiration  >= #FirstOFMonth#		
				
</cfquery>


<cfif UnitList.recordcount gt 0>
	
	<!--- ---------------------------------------------------------------- --->
	<!--- read relevant personal work schedules for this month into memory --->
	<!--- ---------------------------------------------------------------- --->
		
	<cfparam name="url.mode" default="">
	
	 <cfloop query="UnitList">				
		  
		  <cfif DateEffective lte FIRSTOFMONTH>
		  	<cfset start = FIRSTOFMONTH>
		  <cfelse>	
		  	<cfset start = dateEffective>			
		  </cfif>
		  
		  <cfif DateExpiration lt ENDOFMONTH>
		      <cfset end = DateExpiration>		
		  <cfelse>
		      <cfset end = ENDOFMONTH>	
		  </cfif> 	
				  		  				
		  <cfinvoke component = "Service.Process.Employee.Attendance"  
			   method       = "LeaveAttendance" 
			   PersonNo     = "#PersonNo#" 		
			   Mission      = "#Mission#"	   					  
			   StartDate    = "#dateformat(start,client.dateformatshow)#"
			   EndDate      = "#dateformat(end,client.dateformatshow)#"					   					  
			   Mode         = "#url.mode#">						   
		 
    </cfloop>
	
	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	      SELECT *
		  FROM   OrganizationAction
	      WHERE  OrgUnit           = #URL.ID0#
	      AND    CalendarDateStart = #FIRSTOFMONTH#		 
	</cfquery>
	
	<cfif get.actionstatus eq "0">
			
		<cfquery name="Delete" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		      DELETE  FROM    OrganizationAction
		      WHERE   OrgUnit           = #URL.ID0#
		      AND     CalendarDateStart = #FIRSTOFMONTH#		 
		</cfquery>
	
		<cfquery name="Insert" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">	
		     INSERT INTO OrganizationAction
				      (OrgUnit,
					   CalendarDateStart, 
					   CalendarDateEnd,
					   WorkAction,
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName) 
		 	   VALUES (#URL.ID0#,
			           #FIRSTOFMONTH#,
					   #ENDOFMONTH#,
					   'Attendance',
					   '#SESSION.acc#',
			    	   '#SESSION.last#',
				       '#SESSION.first#')
		</cfquery>
		
	</cfif>	
	
	<cfoutput>
		
	 <script>	 	     
		 timesheet('#dateformat(dateob,client.datesql)#','unit','#URL.ID0#','0','false', 'function(personNo, pType) { scheduleCopy(personNo, pType); }', 'function(personNo) { scheduleRemove(personNo); }')		 
	 </script>
	 
	 </cfoutput>	 	
 
 <cfelse>
 
 	<script>	 
		 Prosis.busy('no')
		 alert('There are no records to process under this unit.');
	 </script>
 
 </cfif>

 <cfinclude template="Propagate/ValidatePersonSelection.cfm">