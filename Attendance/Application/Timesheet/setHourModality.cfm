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
<cfparam name="url.id" default="">

<cfif url.id neq "">

	<cfquery name="get" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">				
		SELECT  * 
		FROM    PersonWorkDetail				
		WHERE   HourSlotId = '#url.id#'				
	</cfquery>		
	
	<cfquery name="getParent" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM PersonWorkDetail
		WHERE   PersonNo         = '#get.PersonNo#'
		AND     CalendarDate     = '#get.CalendarDate#'
		AND     TransactionType  = '2'
		AND     CalendarDateHour = '#get.CalendarDateHour#'
		AND     HourSlot         = '#get.HourSlot#'		
	</cfquery>		
	
	<cfif get.Recordcount eq "1">
	
		<cfswitch expression="#url.field#">
		
			<cfcase value="BillingMode">
				
				<cfquery name="set" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
						UPDATE    PersonWorkDetail
						SET       BillingMode = '#url.value#',
							 	  OfficerUserId    = '#session.acc#',
								  OfficerLastName  = '#session.last#',
								  OfficerFirstName = '#session.first#',
								  Created          = getDate()
						WHERE     HourSlotId = '#url.id#'		
				</cfquery>	
				
				<cfinvoke component = "Service.Process.Employee.Attendance"  
				   method           = "SlotAudit" 
				   hourslotid       = "#url.id#">	 
				
				<cfif getParent.recordcount eq "1">
				
					<cfquery name="set" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
							UPDATE    PersonWorkDetail
							SET       BillingMode = '#url.value#',
							 		  OfficerUserId    = '#session.acc#',
								      OfficerLastName  = '#session.last#',
								      OfficerFirstName = '#session.first#',
								      Created          = getDate()
							WHERE     HourSlotId = '#getParent.HourSlotid#'		 	
					</cfquery>	
					
					<cfinvoke component = "Service.Process.Employee.Attendance"  
					   method           = "SlotAudit" 
					   hourslotid       = "#getParent.HourSlotid#">	 
				
				</cfif>
				
				<cfoutput>
				
				<cfif url.value eq "contract">
				
					<script>
						document.getElementById('BillingPayment#url.id#').className = "hide"
					</script>
				
				<cfelse>
				
					<script>
						document.getElementById('BillingPayment#url.id#').className = "regularxl"
					</script>
				
				
				</cfif>	
				
				</cfoutput>
				
				<!--- log the change --->
			
			</cfcase>
			
			<cfcase value="BillingPayment">
			
			    <cfquery name="set" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE    PersonWorkDetail
						SET       BillingPayment  = '#url.value#',
						 		  OfficerUserId    = '#session.acc#',
							      OfficerLastName  = '#session.last#',
							      OfficerFirstName = '#session.first#',
							      Created          = getDate()
						WHERE     HourSlotId      = '#url.id#'			
				</cfquery>		
				
				<cfinvoke component = "Service.Process.Employee.Attendance"  
				   method           = "SlotAudit" 
				   hourslotid       = "#url.id#">	 
				
				<cfif getParent.recordcount eq "1">
				
					<cfquery name="set" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
							UPDATE    PersonWorkDetail
							SET       BillingPayment  = '#url.value#',
							 		  OfficerUserId    = '#session.acc#',
								      OfficerLastName  = '#session.last#',
								      OfficerFirstName = '#session.first#',
								      Created          = getDate()
							WHERE     HourSlotId = '#getParent.HourSlotid#'				
					</cfquery>	
					
					<cfinvoke component = "Service.Process.Employee.Attendance"  
					   method           = "SlotAudit" 
					   hourslotid       = "#getParent.HourSlotid#">	 
				
				</cfif>
				
			</cfcase>
			
			<cfcase value="ActivityPayment">
			
			    <!--- archive the change --->
						
				<cfquery name="set" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE    PersonWorkDetail
						SET       ActivityPayment  = '#url.value#',
						          OfficerUserId    = '#session.acc#',
								  OfficerLastName  = '#session.last#',
								  OfficerFirstName = '#session.first#',
								  Created          = getDate()
						WHERE     HourSlotId      = '#url.id#'				
				</cfquery>	
				
				<cfinvoke component = "Service.Process.Employee.Attendance"  
				   method           = "SlotAudit" 
				   hourslotid       = "#url.id#">	 
								
				<cfif getParent.recordcount eq "1">
				
					<cfquery name="set" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
							UPDATE    PersonWorkDetail
							SET       ActivityPayment  = '#url.value#',
							 		  OfficerUserId    = '#session.acc#',
								      OfficerLastName  = '#session.last#',
								      OfficerFirstName = '#session.first#',
								      Created          = getDate()
							WHERE     HourSlotId = '#getParent.HourSlotid#'				
					</cfquery>	
					
					<cfinvoke component = "Service.Process.Employee.Attendance"  
					   method           = "SlotAudit" 
					   hourslotid       = "#getParent.HourSlotid#">	 
				
				</cfif>	
				
			</cfcase>
		
		</cfswitch>
		
	</cfif>	
	
	<cfoutput>	
	
	<script>
	
		<!--- refresh the cell of that person and date --->
	    
		 try {		        
			 opener.opendaterefresh('#get.PersonNo#','#day(get.CalendarDate)#','#month(get.CalendarDate)#','#year(get.CalendarDate)#')						
		  } catch(e) {}
					
	</script>	
	
	</cfoutput>

</cfif>