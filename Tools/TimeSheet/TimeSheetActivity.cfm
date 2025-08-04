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
<!--- summary content activity --->

<cfparam name="url.orgunit"      default="0">
<cfparam name="url.activityid"   default="9">
<cfparam name="url.personlist"   default="">

<cfparam name="session.timesheet.DateStart"   default="">

<cfif session.timesheet["DateStart"] neq "">	
	
	<cfif session.timesheet["presentation"] eq "month">
	
		<cfset str   = "1">
		<cfset end   = "#daysinmonth(session.timesheet['DateStart'])#">
		<cfset cwd   = "28">
	
	<cfelse>
	
		<cfset str   = "0">
		<cfset end   = "41">
		<cfset cwd   = "28">
	
	</cfif>
	
	<cftransaction isolation="READ_UNCOMMITTED">	
										
	<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr style="height:100%" class="labelmedium">
		
		 <cfquery name="TimeActivity" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">									   
			   SELECT      CalendarDate,
			     		   SUM(CONVERT(float, WD.HourSlotMinutes)) / (60 * (
						   
						   SELECT     CASE WHEN (COUNT(CalendarDateHour) = 0 OR COUNT(CalendarDateHour) IS NULL) THEN 1 ELSE COUNT(CalendarDateHour) END
						   FROM       Program.dbo.ProgramActivitySchemaSchedule A INNER JOIN Program.dbo.ProgramActivitySchema B ON A.ActivitySchemaId = B.ActivitySchemaId
					       WHERE      ActivityId    = '#ActivityId#'
					       AND        Operational   = 1 
					       AND        WeekDay       = DATEPART(weekday,WD.CalendarDate) ) 				   
						   
						   ) AS FTESlot,
						   
		                      (SELECT     Target
		                       FROM       Program.dbo.ProgramActivitySchema
		                       WHERE      ActivityId    = '#ActivityId#'
					           AND        Operational   = 1 
					           AND        WeekDay       = DATEPART(weekday,WD.CalendarDate)) AS FTETarget
							
							
			   FROM        PersonWorkDetail AS WD 
			   WHERE       1=1
			   AND	       CalendarDate >= #session.timesheet["DateStart"]#
		   	   AND         CalendarDate <= #session.timesheet["DateEnd"]#  	
			  		  
			   <cfif url.personlist neq "">			   
			   AND         PersonNo IN (<cfloop index="pers" list="#url.personlist#">'#pers#',</cfloop>'')			   
			   </cfif>
			   AND         ActionCode = '#url.ActivityId#'
			   AND         TransactionType = '1'
			   GROUP BY    CalendarDate
		 </cfquery>  
		 	 
		 <cfquery name="Action" 
		 	 datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	
		 	  SELECT * 
		      FROM   Employee.dbo.Ref_WorkActivity 
		      WHERE  ActionCode = '#url.ActivityId#'										  
		</cfquery>		
		
			
		<cfloop index="day" from="#str#" to="#end#">
		
		    <cfif session.timesheet["presentation"] eq "month">
				<cfset datecur = Createdate(year(session.timesheet["DateStart"]),month(session.timesheet["DateStart"]),day)>
			<cfelse>
			    <cfset datecur = dateAdd("d",day,session.timesheet["DateStart"])>
			</cfif>	
		 	
			<cfset dow = DayOfWeek(datecur)>
			
		    <cfoutput>
			  
			  <cfquery name="Target" datasource="AppsEmployee" 
		  		username="#SESSION.login#" 
		  		password="#SESSION.dbpw#">		  
			       SELECT   Target AS FTETarget
		           FROM     Program.dbo.ProgramActivitySchema
		           WHERE    ActivityId  = '#ActivityId#'
				   AND      Operational = 1 
				   AND      WeekDay     = '#dow#'			 
			  </cfquery>	
			  		  
			  <cfquery name="Actual" dbtype="query">
				   SELECT *
				   FROM   TimeActivity
				   WHERE  CalendarDate  = #datecur#	
			  </cfquery>		  
			 		  		  		  													  										  										  
			  <cfif Target.FTETarget gt Actual.FTESlot and Target.FTETarget gt "0">										  										  
			  	   <td style="font-size:12px;background-color:###Action.actionColor#;color:white;min-width:#cwd#;border-left:1px solid silver;border-top:1px solid silver;" align="center">			   	   
				   <cfif Actual.FTESlot neq "">#numberformat(Actual.FTESlot,'_._')#</cfif>
				   
				   </td>												  
			  <cfelse>										   						  
		          <td style="font-size:12px;background-color:###Action.actionColor#4D;color:black;min-width:#cwd#;border-left:1px solid silver;border-top:1px solid silver" align="center">			  
				  <cfif Actual.FTESlot neq "">#numberformat(Actual.FTESlot,'_._')#</cfif></td>																		 
		      </cfif>		  
			  		
		    </cfoutput>
			
																	
		</cfloop>	
			
		<cfquery name="Param" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Parameter	
		</cfquery>	
		
		<cfquery name="Summary" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	
						  
				  SELECT    Leaveid,BillingMode, BillingPayment,
				    	    ActivityPayment,
				            SUM(CONVERT(float, HourSlotMinutes)) / (60 * #Param.HoursWorkDefault#) AS Days,
							SUM(CONVERT(float, HourSlotMinutes)) / (60) AS Hours
				  FROM      PersonWorkDetail
				  WHERE     1=1
				  <cfif url.personlist neq "">				     
				  AND       PersonNo IN (<cfloop index="pers" list="#url.personlist#">'#pers#',</cfloop>'')			   
				  </cfif>		  
				  AND       (
				  			 ActionClass IN (SELECT   ActionClass
				                             FROM     Ref_WorkAction
		        		                     WHERE    ActionParent = 'worked')
											 
							 OR 
							 LeaveId is not NULL
							)
				  
				  AND	    CalendarDate >= #session.timesheet["DateStart"]#
			   	  AND       CalendarDate <= #session.timesheet["DateEnd"]#  			
			    			  
				  AND       TransactionType     = '1'
				  AND       ActionCode = '#url.ActivityId#'
				  GROUP BY  BillingMode, BillingPayment, ActivityPayment, LeaveId
		 </cfquery>  
		 		
		 <cfquery name="work" dbtype="query">
		        SELECT sum(Hours) as Hours  FROM   summary WHERE LeaveId is NULL
		 </cfquery>  
		 
		  <cfquery name="leave" dbtype="query">
		        SELECT sum(Hours) as Hours  FROM   summary WHERE LeaveId is NOT NULL
		 </cfquery> 
		  
		 <cfquery name="overtime" dbtype="query">	
				SELECT sum(Hours) as Hours  FROM summary WHERE BillingMode != 'Contract' AND BillingPayment = '1'		
		 </cfquery> 
		 	 
		 <cfquery name="time" dbtype="query">	
				SELECT sum(Hours) as Hours  FROM summary WHERE BillingMode != 'Contract' AND BillingPayment = '0'		
		 </cfquery> 
		 
		 <cfquery name="activity" dbtype="query">
				SELECT sum(Hours) as Hours  FROM   summary WHERE ActivityPayment != '0'		
		 </cfquery>  
		 
		 <cfquery name="day" dbtype="query">
		        SELECT sum(Days) as Days    FROM   summary
		 </cfquery> 		
			 
		 <cfoutput>		 
		 		 	
			 <td align="right" bgcolor="#Action.actionColor#" style="padding-top:2px;font-size:12px;padding-right:2px;background-color:###Action.actionColor#4D;border-left:1px solid silver;border-right:1px solid silver;min-width:36px">#numberformat(work.hours,'._')#</td>		
			 <td bgcolor="FFFF00" align="right" style="padding-top:2px;font-size:12px;padding-right:2px;background-color:##FFFF004D;border-right:1px solid silver;min-width:36px" align="center">#numberformat(leave.hours,'._')#</td>				
			 <td bgcolor="#Action.actionColor#" align="right" style="padding-top:2px;font-size:12px;padding-right:2px;background-color:###Action.actionColor#4D;border-right:1px solid silver;min-width:36px" align="center">#numberformat(day.days,'._')#</td>	
			 <td bgcolor="FFFFFF" align="right" style="padding-top:2px;font-size:12px;padding-right:2px;background-color:##FFFFFF4D;border-right:1px solid silver;min-width:36px" align="center">#numberformat(overtime.hours,'._')#</td>			 
			 <td bgcolor="FFFFFF" align="right" style="padding-top:2px;font-size:12px;padding-right:2px;background-color:##FFFFFF4D;border-right:1px solid silver;min-width:36px" align="center">#numberformat(time.hours,'._')#</td>	
			 <td bgcolor="400040" align="right" style="padding-top:2px;font-size:12px;padding-right:2px;background-color:##40004080;color:white;min-width:36px" align="center">#numberformat(activity.hours,'._')#</td>	
			 
		 </cfoutput>
				
		</tr>
		</table>	
	
	 </cftransaction>	
	 
</cfif>	 