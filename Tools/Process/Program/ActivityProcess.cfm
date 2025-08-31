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
<cfparam name="Attributes.ProgramCode" default="0">
<cfparam name="Attributes.ActivityId"  default="0">

<cfparam name="Attributes.DateStart"   default="">
<cfparam name="Attributes.DateEnd"     default="">

<cfparam name="Attributes.Duration"    default="1">


<cfif Attributes.ActivityId neq "">

	<cfquery name="Prior" 
		datasource="AppsProgram" 
	    username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   ProgramActivity			
		 WHERE  ActivityID = '#Attributes.ActivityID#'
    </cfquery>		

	<cfif attributes.DateEnd eq "">
		    
		<!--- start --->	
	    <cfset dateValue = "">
		<CF_DateConvert Value="#Attributes.DateStart#">			
		<cfset ActDateStart        = dateValue>		
		<!--- end --->		
		<cfset ActDate             = dateadd("d",Attributes.duration,ActDateStart)>		
		
	<cfelse>
	
	    <!--- used from the progress reporting --->
		
		<!--- start --->
		<cfset dateValue = "">
		<CF_DateConvert Value="#dateformat(Prior.ActivityDateStart,CLIENT.DateFormatShow)#">		
		<cfset ActDateStart        = dateValue>		
		<!--- end --->
		<cfset dateValue = "">
		<CF_DateConvert Value="#Attributes.DateEnd#">				
		<cfset ActDate             = dateValue>		
		<!--- duration --->
		<cfset Attributes.duration = datediff("d",ActDateStart,ActDate)>		
				
	</cfif>			
	
	<!--- PROCESS only if something has changed here --->
	
	<!---
	<cfif Prior.ActivityDateStart neq ActDateStart or Prior.ActivityDays neq Attributes.duration> 
	--->
	
	<!--- ------------------  METHOD  --------------------------- --->
	<!--- retrieve all tasks that are dependent on this activity- --->
	<!--- ------------------------------------------------------- --->
				
	<cf_ActivityRelation 
		    ProgramCode="#Prior.ProgramCode#" 
		    ActivityId="#URL.ActivityId#">
						
		<!--- determine the earliest start date of the activiy based on its parents --->
			
		<cfquery name="Date" 
			    datasource="AppsProgram" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    ProgramActivity A, 
				         userQuery.dbo.#SESSION.acc#ParentActivity B					    
				 WHERE   A.ActivityId = B.ActivityParent
				 AND     B.ActivityId = '#Attributes.ActivityId#' 
				  				 
		</cfquery>
				
		<cfif date.recordcount eq "0">
		
			<cfset dateValue = "">
			<CF_DateConvert Value="#attributes.datestart#">
			<cfset earliest = actdatestart>	 
			
		<cfelse>	
		
			<cfset earliest = "">
										
			<cfloop query="date">
			
				<cfif startafter eq "completion">
					
				    <cfset dte = DateAdd("d", StartAfterDays, ActivityDate)>
							
				<cfelse>
				
					<cfset dte = DateAdd("d", StartAfterDays, ActivityDateStart)>
				
				</cfif>
				
				<cfif earliest eq "">
				   <cfset earliest = dte>
				<cfelseif dte gt earliest>
				   <cfset earliest = dte> 
				</cfif>
					
			</cfloop>
			
		</cfif>	
		
						 	 
		<!--- A. adjust start date and end date, if start date lt Max(Date) --->
						
		<!--- revision of the start date based on dependency ---> 
				
		<cfset ActDateStart = earliest>
		<cfset ActDate      = DateAdd("d", attributes.duration, ActDateStart)>
					  			 
		<cfquery name="UpdateActivity" 
			datasource="AppsProgram" 
		    username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
		     UPDATE ProgramActivity
		     SET    ActivityDateStart   = #ActDateStart#, 
			 		<cfif Attributes.dateEnd eq "">
				    ActivityDateEnd     = #ActDate#,
					</cfif>
					ActivityDate        = #ActDate#,	
					ActivityDays        = '#Attributes.Duration#'			
			 WHERE  ActivityID          = '#Attributes.ActivityID#'
		</cfquery>		 
			 			 		 
		<!--- B. activity END has moved later --->
			 
		<cfif ActDate gte Prior.ActivityDate> 			 		 
				   
		   <!--- 27/07/2008 correction also needed if activity started later because
		   of children dependency, extending it should
		   not involved full extension for the difference --->
				   
				     	<cfset diff = ActDate - Prior.ActivityDate>
				   
				   		<cfquery name="SelectChildren" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 SELECT  ActivityId 
		                 FROM    userQuery.dbo.#SESSION.acc#ParentActivity
					     WHERE   ActivityParent = '#URL.ActivityId#'
						 ORDER BY DepOrder
						</cfquery>
						
						<cfset pointer = 0>
						
						<!--- adjust the children based on the revised enddate --->
						
						<cfloop query="SelectChildren">
					
							 <cfquery name="UpdateChild" 
						     datasource="AppsProgram" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">							 
						     UPDATE ProgramActivity
						        SET ActivityDateStart  = ActivityDateStart+#Diff#, 
								    ActivityDateEnd    = ActivityDate+#Diff#,
								    ActivityDate       = ActivityDate+#Diff#  
							 WHERE  ActivityId         = '#ActivityId#'					
							 </cfquery>
																
							<!--- check for each
							child if has another parent and review the start date --->
						
							<cfquery name="Date" 
						    datasource="AppsProgram" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							 SELECT  MAX(A.ActivityDate) AS LastDate
							 FROM    ProgramActivity A, 
								     ProgramActivityParent P
							 WHERE   A.ActivityId = P.ActivityParent
							 AND     P.ActivityId = '#ActivityId#'  	
							 <!---
							 <cfif pointer eq "0">
							 AND     P.ActivityParent NOT IN (SELECT ActivityId
							                              FROM userQuery.dbo.#SESSION.acc#ParentActivity)												
							 </cfif>							  
							 --->
							</cfquery>
							
							<cfif Date.lastDate neq "">
								
								 <cfquery name="Activity" 
								     datasource="AppsProgram" 
								     username="#SESSION.login#" 
								     password="#SESSION.dbpw#">
									 SELECT  * 
					                 FROM    ProgramActivity
								     WHERE   ActivityId = '#ActivityId#' 
								 </cfquery>
									
								 <!--- revision of the start date based on dependency ---> 
								 <cfif Date.LastDate+1 neq Activity.ActivityDateStart>
								 
								 		<!--- from now onwards consider all --->	
								 		<cfset pointer = 1>
										
										<!--- start --->
										<cfset dateValue = "">
										<CF_DateConvert Value="#dateformat(Date.LastDate,CLIENT.DateFormatShow)#">		
										<cfset str = dateAdd("d","1",dateValue)>
										
										<!--- end --->
										<cfset dateValue = "">
										<CF_DateConvert Value="#dateformat(Date.LastDate,CLIENT.DateFormatShow)#">		
										<cfset end = dateAdd("d","#Activity.ActivityDays+1#",dateValue)>
									 									 				 
										<cfquery name="UpdateActivity" 
											datasource="AppsProgram" 
										    username="#SESSION.login#" 
											password="#SESSION.dbpw#">
										     UPDATE ProgramActivity
										     SET    ActivityDateStart = #str#, 
											 		ActivityDateEnd   = #end#,
													ActivityDate      = #end#
											 WHERE  ActivityID        = #ActivityID#
										</cfquery>		
									 
									 </cfif> 
								
							</cfif>				
					   
					   	</cfloop>							
			 
			 <cfelseif ActDate lt Prior.ActivityDate>
			 
			 	<!--- C. if Activity end has moved earlier also adjust the children --->
			 
			    <cfset diff = Prior.ActivityDate - ActDate> 
			   
			    <cfquery name="SelectChildren" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT     ActivityId 
                 FROM       userQuery.dbo.#SESSION.acc#ParentActivity
			     WHERE      ActivityParent = '#URL.ActivityId#'
				 ORDER BY   DepOrder
				</cfquery>
				
				<cfset pointer = 0>
				
				<cfloop query="SelectChildren">
				
					 <cfquery name="UpdateChild" 
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">					 
				     UPDATE ProgramActivity
				        SET ActivityDateStart   = ActivityDateStart-#Diff#, 
						    ActivityDateEnd     = ActivityDate-#Diff#,
						    ActivityDate        = ActivityDate-#Diff#
					 WHERE  ActivityId          = '#ActivityId#'					
					 </cfquery>
																									
					<!--- check 
					if child has another parent with later end date --->
					
					<cfquery name="Date" 
				    datasource="AppsProgram" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					
						 SELECT  MAX(A.ActivityDate) AS LastDate 
						 FROM    ProgramActivity A, 
							     ProgramActivityParent P
						 WHERE   A.ActivityId = P.ActivityParent
						 AND     P.ActivityId = '#ActivityId#'  
						 
						 <!---
						 <cfif pointer eq "0">	
						 AND     P.ActivityParent NOT IN (SELECT ActivityId
								                          FROM userQuery.dbo.#SESSION.acc#ParentActivity)			 					
						 							  
						 </cfif>		
						 --->							  
					  
					</cfquery>
					
					<cfif Date.LastDate neq "">
					
						 <cfquery name="Activity" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
							 SELECT  * 
			                 FROM    ProgramActivity
						     WHERE   ActivityId = '#ActivityId#' 						 
						</cfquery>
						
						<!--- revision of the start date based on dependency ---> 
						 <cfif Date.LastDate+1 neq Activity.ActivityDateStart>
						 
						 	<cfset pointer = 1>
							
							<!--- start --->
							<cfset dateValue = "">
							<CF_DateConvert Value="#dateformat(Date.LastDate,CLIENT.DateFormatShow)#">		
							<cfset str = dateAdd("d","1",dateValue)>
							
							<!--- end --->
							<cfset dateValue = "">
							<CF_DateConvert Value="#dateformat(Date.LastDate,CLIENT.DateFormatShow)#">		
							<cfset end = dateAdd("d","#Activity.ActivityDays+1#",dateValue)>			 
						 							 				 
							 <cfquery name="UpdateActivity" 
								datasource="AppsProgram" 
							    username="#SESSION.login#" 
								password="#SESSION.dbpw#">								
								     UPDATE ProgramActivity
								     SET    ActivityDateStart  = #str#, 
									 		ActivityDateEnd    = #end#,
											ActivityDate       = #end#
									 WHERE  ActivityID         = '#ActivityID#'
							 </cfquery>		
						 
						 </cfif> 
					
					</cfif>				
				
				</cfloop> 						  
			 
			 </cfif>	
	<!---			 
	</cfif>	 			 
	--->

</cfif>

				 