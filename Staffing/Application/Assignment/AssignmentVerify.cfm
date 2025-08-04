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

<!--- ---------------------------------------- --->
<!--- verify if the assignments are consistent --->

<!---
<cftry>
--->

<cfparam name="URL.Mode"               default="Silent">
<cfparam name="attributes.Mission"     default="">
<cfparam name="attributes.MandateNo"   default="P001">
<cfparam name="attributes.PersonNo"    default="">

<!--- select indexNo with two or more record with the same DateEffective --->

<!--- verify assignments from an employee perspective with more than one active assignment, this will limit
the number of cases with an approx 90% --->

<cfquery name="ResultList" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT   A.*
	 FROM     PersonAssignment A 			 
     WHERE    A.AssignmentStatus IN ('0', '1') 
	 <cfif attributes.personNo neq "">
	 AND      Personno = '#attributes.personNo#'
	 </cfif>			
     AND      A.PositionNo IN
                    (SELECT  PositionNo
                     FROM    Position
                     WHERE   Mission   = '#attributes.Mission#' 
				     AND     MandateNo = '#attributes.MandateNo#')
    ORDER BY  A.AssignmentClass, 	          
	          A.PersonNo, 
			  A.Incumbency,
			  A.DateEffective, 
			  A.DateExpiration
</cfquery>

<cfoutput query="ResultList" group="AssignmentClass">

		<cfoutput group="PersonNo">
		
		    <cfoutput group="Incumbency">
	
	    	<cfset init = "0">
	
			<cfoutput>
					
				<!--- loop through the records startdate = date expiration + 1
					if date expiration = date effective delete record --->
				
				<cfif init eq "1">
							
					<cfset dateValue = "">
					<CF_DateConvert Value="#DateFormat(DateEffective,CLIENT.DateFormatShow)#">
					<cfset eff = dateValue>
					
					<cfset dateValue = "">
					<CF_DateConvert Value="#DateFormat(DateExpiration,CLIENT.DateFormatShow)#">
					<cfset exp = dateValue>
					
					<cfif def gt eff>
					
						<cfif def lt exp>
						
							<cfquery name="Update" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE  PersonAssignment
								SET     DateEffective = #def#,
								        Remarks       = 'Effective date correction by system check'
								WHERE   AssignmentNo  = '#AssignmentNo#'
							</cfquery>
							
							<!--- record the action --->
							
							<cfset action = "Effective #dateformat(Effective,client.dateformatshow)# to #dateformat(def,client.dateformatshow)#">
					
							<cfquery name="set" 
							   datasource="AppsEmployee">
							   INSERT INTO PersonAssignmentAction	
							   (PersonNo, PositionNo, AssignmentNo, ActionCode, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
							   VALUES
							   ('#PersonNo#','#PositionNo#','#AssignmentNo#',
							   'Verify',
							   '#action#',
							   '#session.acc#','#session.last#','#session.first#')	       
							</cfquery> 	
						
						<cfelse>
						
							<cfquery name="Delete" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								UPDATE  PersonAssignment
								SET     AssignmentStatus = '9',
        								Remarks       = 'Assignment deactivated by system check'
								WHERE   AssignmentNo = '#AssignmentNo#'
							</cfquery>
							
							<cfset action = "Overlap record disabled">
					
							<cfquery name="set" 
							   datasource="AppsEmployee">
							   INSERT INTO PersonAssignmentAction	
							   (PersonNo, PositionNo, AssignmentNo, ActionCode, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
							   VALUES
							   ('#PersonNo#','#PositionNo#','#AssignmentNo#',
							   'Verify',
							   '#action#',
							   '#session.acc#','#session.last#','#session.first#')	       
							</cfquery> 	
							
							<!--- record the action --->
								
						</cfif>
						
					</cfif>	
					
			</cfif>
						
			<cfset dateValue = "">
			<CF_DateConvert Value="#DateFormat(DateExpiration,CLIENT.DateFormatShow)#">
			<cfset def = DateAdd("d", "1", "#dateValue#")>
			<cfset init = "1">
			
			</cfoutput>
				
			</cfoutput>
				
		</cfoutput>

</cfoutput>

