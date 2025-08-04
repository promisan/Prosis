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

<cfparam name="URL.date" default="01/01/1900">
<cfparam name="URL.Id" default="7999">
<cfparam name="URL.cls" default="">
<cfparam name="URL.cde" default="">
<cfparam name="URL.hrs" default="">

<!--- 
1. save enties for each different hour
2. update personwork master record summary
3. refresh entry details
--->


<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<cftransaction>
	 
	<!---return to screen--->

	<cfloop index="tratpe" list="1,2">
		
		<cfquery name="check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	PersonWork
				WHERE	CalendarDate    = #dte#
				AND     PersonNo        = '#URL.ID#'
				AND     TransactionType = '#tratpe#'
		</cfquery>
	
		<cfif check.recordcount eq "0">
	
			<cfquery name="assign" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT P.*, O.OrgUnitName, O.Mission
			   	FROM   PersonAssignment P, 
				       Organization.dbo.Organization O
				WHERE  P.DateEffective   <= #dte# 
				AND    P.DateExpiration  >= #dte#
			    AND    P.Incumbency      > '0'
			    AND    P.AssignmentStatus IN ('0','1') <!--- planned and approved --->
		        AND    P.AssignmentClass = 'Regular'
		        AND    P.AssignmentType  = 'Actual'
		   	    AND    P.OrgUnit = O.OrgUnit
			    AND    P.PersonNo = '#URL.ID#'
			</cfquery>
					
			<cfquery name="insert" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						INSERT INTO	PersonWork
							(PersonNo, 
							OrgUnit,
							CalendarDate,
							TransactionType,
							OfficerUserId,
							OfficerLastName, 
					    	OfficerFirstName) 
						VALUES ('#URL.ID#',
						        '#assign.OrgUnit#',
								#dte#,
								'#tratpe#',
								'#SESSION.acc#',
				    		    '#SESSION.last#',
								'#SESSION.first#')
			</cfquery>
					
		</cfif>	
		
	</cfloop>
	
	<cfquery name="parameter" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
		  FROM   Parameter 
		  WHERE Identifier = 'A'				  
	</cfquery>
	
	<cfquery name="ActionClass" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT  *
			  FROM    Ref_WorkAction R
			  WHERE   ActionClass = '#url.cls#'
	</cfquery>

	<cfloop index="tratpe" list="1,2">
		
		<cfset parent = "0">
		<cfset prior  = "0">
		<cfset first  = "yes">
	
		<cfloop index="hr" from="#parameter.hourstart#" to="#parameter.hourend#" step="1">
		
		
		        <!--- we hand an issue adding on to a schedule hours with Waseem 
				
				<cfif first eq "yes" and (tratpe eq "1" or (tratpe eq "2" and ActionClass.ActionParent eq "Worked"))>
				
					<cfquery name="Delete" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      DELETE FROM PersonWorkDetail
						  WHERE  PersonNo        = '#URL.id#' 
						  AND    CalendarDate    = #dte#
						  AND    TransactionType = '#tratpe#'
						  AND    ParentHour IN (SELECT ParentHour 
								                FROM   PersonWorkDetail 
											    WHERE  PersonNo         = '#URL.id#'
												AND    CalendarDate     = #dte#
												AND    TransactionType  = '#tratpe#'
												AND    CalendarDateHour = '#url.parenthour#') 
					</cfquery>
					
					<cfset first = "no">
				
				</cfif>				
				
				--->
				
				<cfif hr lt "0">
					<cfset fld = "#24+hr#">  <!--- makes it 23 if the day starts at 23 o'clocck --->
				<cfelse>
				    <cfset fld = "#hr#">
				</cfif>	
			
				<cfparam name="FORM.slots_#fld#" default="">
								
				<cfset slots = evaluate("FORM.slots_#fld#")>
									
				<!--- means the hour is enabled --->
				
				<cfif slots neq "">
					
					<cfquery name="UpdateSlots" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						  UPDATE  PersonWorkDetail
						  SET     HourSlots        = '#slots#'
					      WHERE   PersonNo         = '#URL.id#'
						  AND     CalendarDate     = #dte#
						  AND     CalendarDateHour = '#hr#'	
						  AND     TransactionType = '#tratpe#'   
					</cfquery>
				
					<cfloop index="slot" from="1" to="#slots#">
					
						<cfparam name="FORM.slot_#fld#_#slot#" default="">
						<cfparam name="FORM.pay_#fld#_#slot#"  default="0">
						
						<cfset slotselect = evaluate("FORM.slot_#fld#_#slot#")>
						<cfset payment    = evaluate("FORM.pay_#fld#_#slot#")>
												
						<cfquery name="getCurrent" 
						  datasource="AppsEmployee" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						      SELECT  * 
							  FROM    PersonWorkDetail
							  WHERE   PersonNo         = '#URL.id#'
							  AND     CalendarDate     = #dte#
							  AND     TransactionType  = '#tratpe#'	
							  AND     CalendarDateHour = '#hr#'
							  AND     HourSlot         = '#slotselect#'							  
						</cfquery>
						
						<cfif payment eq "">
							<cfset payment = "0">
						</cfif>		
							
																
						<cfif slotselect neq "">
						
												
							<cfif tratpe eq "1" or (tratpe eq "2" and (ActionClass.ActionParent eq "Worked" or getCurrent.recordcount eq "0"))>
							
							       <!--- we only record entries in the personal schedule if these are work entry or if it is still empty on the spots --->
		
									<cfset applydetail = "1">
																
							<cfelse>
							
									<cfset applydetail = "0">					
							
							</cfif>
						
						<cfif applydetail eq "1">
						
								<cfquery name="ClearEntries" 
								  datasource="AppsEmployee" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								      DELETE  FROM PersonWorkDetail
									  WHERE   PersonNo        = '#URL.id#'
									  AND     CalendarDate     = #dte#
									  AND     TransactionType = '#tratpe#'	
									  AND     CalendarDateHour = '#hr#'
									  AND     HourSlot         = '#slotselect#'			
									  		  								 
								</cfquery>
							
							    <!--- disabled 
								
								<cfif ActionClass.ActionParent neq "worked" and (hr lt 3 or hr gte 23)>
								
									<!--- No need to record for out of bound hours --->
								
								<cfelse>	
								
								--->												
									
								<cfif Len(Form.memo) gt 200>
								  <cfset des = left(Form.memo,200)>
								<cfelse>
								  <cfset des = Form.memo>
								</cfif>  
								
								<cfparam name="form.billingmode" default="Contract">
								
								<cfset bil = form.billingmode>
									
								<cfif url.cde neq "">
								
									<cfquery name="Work" 
									  datasource="AppsEmployee" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
									  SELECT   *
									  FROM     Program.dbo.ProgramActivity A 
									  WHERE    A.ActivityId = '#url.cde#' 
									</cfquery>
									
									<cfset act = "#Work.ActivityDescription#">
									
									<cfquery name="workactivity" 
										datasource="AppsEmployee" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT 	*
											FROM 	Ref_WorkActivity
											WHERE	ActionCode = '#url.cde#'
									</cfquery>
									
									<cfif workactivity.recordcount eq "0">
												
										<cfquery name="check" 
											datasource="AppsEmployee" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT 	*
												FROM 	PersonWork
												WHERE	CalendarDate = #dte#
												AND     PersonNo = '#URL.ID#'
										</cfquery>
											
										<cfquery name="org" 
											datasource="AppsEmployee" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT 	*
												FROM 	Organization.dbo.Organization
												WHERE	OrgUnit = '#check.OrgUnit#'
										</cfquery>
											
											<!--- inherit the activity descriptive into employee database for reference purposes
											so we are always enable to retrieve its details at a later stage --->
										
										<cfquery name="Insert" 
										  datasource="AppsEmployee" 
										  username="#SESSION.login#" 
										  password="#SESSION.dbpw#">
										      INSERT INTO Ref_WorkActivity
												  (ActionCode, 
												   ActionDescription, 
												   Mission,
												   ActionColor,
												   OfficerUserId, 
												   OfficerLastName, 
												   OfficerFirstName)
											  VALUES ('#URL.cde#',
												      '#act#',
													  '#org.mission#',
													  'silver',  <!--- pending to inherit --->
													  '#SESSION.acc#',
													  '#SESSION.last#',
													  '#SESSION.first#')
										</cfquery>
								
									</cfif>
																			
								</cfif>
									
								<cfif prior+1 eq hr>
								   <!--- <cfset prior = prior+1> disalbed 30/9 --->
								<cfelseif prior eq "0">
								   <cfset parent = hr>
								   <cfset prior  = hr>
								 </cfif>
								
								<cfset hourSlotMinutes = 60/slots>
																		
								<cfquery name="Insert" 
								  datasource="AppsEmployee" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								      INSERT INTO PersonWorkDetail
											  (PersonNo, 
											   CalendarDate, 
											   TransactionType,
											   CalendarDateHour, 
											   HourSlot,
											   HourSlots,
											   HourSlotMinutes,
											   ActionClass, 
											   <cfif url.loc neq "">
											   LocationCode,
											   </cfif>
											   <cfif url.cde neq "">
											   ActionCode, 
											   </cfif>
											   BillingMode,
											   ActionMemo,
											   ParentHour,											   
											   ActivityPayment,
											   OfficerUserId, 
											   OfficerLastName, 
											   OfficerFirstName)
									  VALUES ('#URL.id#',
										       #dte#,
											   '#tratpe#',
											   '#hr#',
											   '#slotselect#',
											   '#slots#',
											   '#hourSlotMinutes#',
											   '#url.cls#', 
											   <cfif url.loc neq "">
											   '#url.loc#',
											   </cfif>
											   <cfif url.cde neq "">
											   '#url.cde#',
											   </cfif>
											   '#bil#',
											   '#des#',
											   #parent#,
											   '#Payment#',
											   '#SESSION.acc#',
											   '#SESSION.last#',
											   '#SESSION.first#')
												 												 
									</cfquery>
																	
								<!---																
								</cfif>
								--->												
							
						</cfif>	
										
					</cfif>
						
					</cfloop>
					
				</cfif>		
			
		</cfloop>
		
	</cfloop>	
	
</cftransaction>



<!--- calculate summary --->

<cf_summaryCalculation
 personNo = "#URL.ID#"
 date="#dte#">

<!--- refreshing --->
 
<cfoutput>

	<cfset dy = day(dte)>
	<cfset mt = month(dte)>
	<cfset yr = year(dte)>
	
	<script language="JavaScript1.1">
	
		<cfif url.context eq "month">
		     parent.gotomonth('#url.id#','#dy#','#mt#','#yr#','1')	
		<cfelseif url.context eq "week">
			 parent.gotoweek('#url.id#','#dy#','#mt#','#yr#','1')	
		<cfelse>				
			 parent.gotodate('#url.id#','#dy#','#mt#','#yr#','1')	
		</cfif>
	
	</script> 

</cfoutput>


<cfif url.act eq "exit">
   
	<script language="JavaScript">		
		parent.ProsisUI.closeWindow('tsentry')
	</script>	
		
<cfelse>

	<cfinclude template="HourEntryForm.cfm">
	
</cfif>
