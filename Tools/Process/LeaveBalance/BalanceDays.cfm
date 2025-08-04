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
<cfparam name="attributes.calculationmode" default="default">

<cfset days = 0>
<cfset num  = attributes.end - attributes.start + 1>	

<CFSET mind = "0">
<CFSET minw = "1">
<CFSET maxd = "0">
<CFSET minw = "1">

<cfquery name="getAccrual" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
   	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Ref_LeaveTypeCredit
	 WHERE    LeaveType = '#attributes.leavetype#'    
 </cfquery>

<cfquery name="getClass" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
   	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Ref_LeaveTypeClass
	 WHERE    LeaveType = '#attributes.leavetype#'
     AND      Code      = '#attributes.LeaveTypeClass#' 
 </cfquery>
				 
<CFSET mind = "#getClass.LeaveMinimum#">
<CFSET minw = "#getClass.LeaveMinimumDeduct#">
<CFSET maxd = "#getClass.LeaveMaximum#">
<CFSET maxw = "#getClass.LeaveMaximumDeduct#">

<cfset date = DateAdd("d", "0", "#attributes.start#")> 
	
<cfquery name="orgunit" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT     O.OrgUnit, 
		           O.OrgUnitName, 
				   O.Mission,
				   A.LocationCode as LocationAssignment,
				   P.LocationCode as LocationPosition
	   	FROM 	   PersonAssignment A 
			       INNER JOIN Organization.dbo.Organization O ON A.OrgUnit = O.OrgUnit
				   INNER JOIN Position P ON P.PositionNo = A.PositionNo
		WHERE	   A.DateEffective <= #attributes.end# 
		  AND      A.DateExpiration >= #attributes.end#
		  AND      A.Incumbency       > '0'
		  AND      A.AssignmentStatus < '8' <!--- planned and approved --->
	      AND      A.AssignmentClass = 'Regular'
	      AND      A.AssignmentType  = 'Actual'	   
		  AND      A.PersonNo        = '#attributes.PersonNo#'
</cfquery>

<cfif orgunit.recordcount eq "0">
	
	<cfquery name="orgunit" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	 O.OrgUnit, 
			         O.OrgUnitName, 
					 O.Mission,
					 A.LocationCode as LocationAssignment,
					 P.LocationCode as LocationPosition
		   	FROM 	 PersonAssignment A 
			         INNER JOIN Organization.dbo.Organization O ON A.OrgUnit = O.OrgUnit
					 INNER JOIN Position P ON P.PositionNo = A.PositionNo
			WHERE	 A.Incumbency > '0'
			  AND    A.AssignmentStatus < '8' <!--- planned and approved --->
		      AND    A.AssignmentClass = 'Regular'
		      AND    A.AssignmentType  = 'Actual'		   	
			  AND    A.PersonNo        = '#attributes.PersonNo#'
			ORDER BY A.DateEffective DESC 
	</cfquery>

</cfif>
	
<cfquery name="Parameter" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Parameter 
</cfquery>
	
<cfset HoursInDay = Parameter.HoursInDay>
	
<cfset deduction = QueryNew("Date, Deduct", "date, decimal")> 

<!--- loop through the dates --->
		
<cfloop index="X" from="1" to="#num#">

    <!--- check if date is a holiday --->
	
    <cfquery name="Holiday" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT  Clusterid,
		        HolidayId, 
				(SELECT  count(*) 
		         FROM    Ref_HolidayLocation 
		         WHERE   CalendarDate = #Date#
				 AND     Mission      = '#OrgUnit.Mission#') as hasEnabledLocations			
		FROM 	Ref_Holiday
		WHERE   CalendarDate = #Date#
		AND     Mission      = '#OrgUnit.Mission#' 		
    </cfquery>
		
	<!-- the holiday is narroewed down to locations --->
			
	<cfif Holiday.hasEnabledLocations gte "1">
		
		<cfif OrgUnit.LocationAssignment neq "">
		
			 <cfquery name="getHolidayLocation" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT  *
				FROM 	Ref_HolidayLocation
				WHERE   CalendarDate = #Date#
				AND     Mission      = '#OrgUnit.Mission#' 		
				AND     LocationCode = '#OrgUnit.LocationAssignment#' 
		    </cfquery>
					
		<cfelse>
		
			 <cfquery name="getHolidayLocation" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT  *
				FROM 	Ref_HolidayLocation
				WHERE   CalendarDate = #Date#
				AND     Mission      = '#OrgUnit.Mission#' 		
				AND     LocationCode = '#OrgUnit.PositionPosition#' 
		    </cfquery>		
					
		</cfif>
		
		<cfif getHolidayLocation.recordcount eq "1">
				<cfset isHoliday = "1">	
		<cfelse>
				<cfset isHoliday = "0">		
		</cfif>
		
	<cfelseif Holiday.recordcount eq "1">
	
		<cfset isHoliday = "1">	
		
	<cfelse>
	
		<cfset isHoliday = "0">
	
	</cfif>
	
	<cfset used = "0">
	
	<cfif isHoliday eq "1">
				
		<cfif Holiday.ClusterId neq "">
				
			 <!--- if this is a holiday then we check if the holiday is clustered with another holiday and ife person already has a leave
			 that uses the clustered holiday so we will deduct this --->
			 	 
			 <cfquery name="OtherHolidays" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT  CalendarDate
					FROM 	Ref_Holiday
					WHERE   ClusterId    = '#Holiday.ClusterId#'
					AND     CalendarDate != #Date#
					AND     Mission       = '#OrgUnit.Mission#'
			    </cfquery>
				
			  <cfloop query="otherholidays">
				
					<cfquery name="UseRelatedHoliday" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    SELECT  *
						FROM 	PersonLeave
						WHERE   PersonNo       = '#Attributes.PersonNo#'
						AND     LeaveType      = '#Attributes.LeaveType#'
						AND     DateEffective  <= '#CalendarDate#'
						AND     DateExpiration >= '#CalendarDate#'
						AND     Status IN ('1','2','3')				
				    </cfquery>
					
					<cfif UseRelatedHoliday.recordcount gte "1">
					     <cfset used = "1">
					</cfif>
				
			  </cfloop>
				
		</cfif>
		
	</cfif>	
		  
	<!--- if not a holiday or a related holiday was already used --->  
	
	<cfset part = 0>
								   
	<cfif isholiday eq "0" or used eq "1">	
				
		<cfset daymode = "">
						
		<cfif X eq "1" and attributes.startfull eq "0">		
	         <cfset daymode = "PM">	      
	    </cfif>
						
		<cfif X eq num and attributes.endfull eq "0">					
	         <cfset daymode = "AM">
	    </cfif>		
			    
		<!--- check if day is to be counted for deduction --->		
       		
		<cfinvoke component = "Service.Process.Employee.Attendance"  
		   method           = "WorkDay" 
		   PersonNo         = "#Attributes.PersonNo#"
		   CalendarDate     = "#dateformat(Date,client.dateformatshow)#"  
		   DayMode          = "#daymode#" 		  
		   returnvariable   = "workday">	
		  
		 <cfif getAccrual.CreditUoM eq "Hour">
		 		 			   				 
			 <cfset part = workday.hours>
			 
		 <cfelse>
		 
		    <!--- hourly consumption which is the future --->
            <cfset part = workday.deduct>		 
		 	
			
		 </cfif>	 
		        		 
		 <!--- ------------------------------------------------------------ --->
		 <!--- now check if the leave class has a multiplier for correction --->
		 <!--- ------------------------------------------------------------ --->
		
		 <cfif attributes.leavetypeclass neq "">
		 				 		 		 			 			 
			 <cfif attributes.calculationmode neq "compensation">			 
			 			 
				 <cfquery name="getClass" 
			         datasource="AppsEmployee" 
	    		     username="#SESSION.login#" 
		        	 password="#SESSION.dbpw#">
					 SELECT   *
					 FROM     Ref_LeaveTypeClass
					 WHERE    LeaveType = '#attributes.leavetype#'
	        	     AND      Code      = '#attributes.LeaveTypeClass#' 
				 </cfquery>					
			 
				 <cfif getClass.PointerLeave eq "">
				 
				 	<cfset days = days + part>
				 			 
				 <cfelse>
				 
				 	<cfset days = days + (part * getClass.PointerLeave/100)>
					<cfset part = part * getClass.PointerLeave/100>
				 
				 </cfif>
				 
			 <cfelse>
			 						 			 
			 	<cfquery name="getClass" 
			         datasource="AppsEmployee" 
	    		     username="#SESSION.login#" 
		        	 password="#SESSION.dbpw#">
					 SELECT   *
					 FROM     Ref_LeaveTypeClass
					 WHERE    LeaveType = '#attributes.LeaveType#'
	        	     AND      Code      = '#attributes.LeaveTypeClass#' 
				 </cfquery>				 
							
				<cfif getClass.CompensationPointer eq "">
											 
				 	<cfset days = days + part>
				 			 
				 <cfelse>
				 				 				
				 	<cfset days = days + (part * getClass.CompensationPointer/100)>
					<cfset part = part * getClass.CompensationPointer/100>
									 
				 </cfif>				
			
			</cfif>	 
		 
		 <cfelse>
		 		   
			 <cfset days = days + part>
		 
		 </cfif>	
		 
	</cfif>	
			   
	<!--- fill the queryobject --->
		   
	<cfset temp = queryaddrow(deduction, 1)>							
	<!--- set values in cells --->
	<cfset temp = querysetcell(deduction, "Date",   "#Date#")>
	<cfset temp = querysetcell(deduction, "Deduct", "#part#")>
		          
	<!--- next date --->
		   
	<cfset date = DateAdd("d", "#x#", "#attributes.start#")> 	   

</cfloop>

<CFSET CALLER.numd     = num>	
<CFSET CALLER.days     = days>
<CFSET CALLER.dmin     = mind>
<CFSET CALLER.dminmode = minw>
<CFSET CALLER.dmax     = maxd>
<CFSET CALLER.dmaxmode = maxw>

<cfset CALLER.deduction = deduction>
