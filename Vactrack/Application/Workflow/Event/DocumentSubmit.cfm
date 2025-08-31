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
<cfparam name="Form.ObjectId"    default="">
<cfparam name="Form.EventCode"   default="">
<cfparam name="Form.Reason"      default="">
<cfparam name="Form.ReasonCode"  default="">

<cfif Form.ObjectId neq "">

	<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * FROM Organization.dbo.OrganizationObject
		 WHERE   ObjectId = '#Form.Objectid#'		 
	</cfquery>
	
	<cfquery name="Document" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  * 
		 FROM    Vacancy.dbo.Document
		 WHERE   DocumentNo= '#Form.Key1#'		 
	</cfquery>
	
	<cfquery name="Position" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  * 
		 FROM    Employee.dbo.Position
		 WHERE   PositionNo = '#Document.PositionNo#'		 
	</cfquery>
	
	<cfquery name="Candidate" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  * 
		 FROM    Vacancy.dbo.DocumentCandidate
		 WHERE   DocumentNo = '#Form.Key1#'		 
		 AND     PersonNo   = '#Form.Key2#'
	</cfquery>
	
	<cfquery name="Person" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  * 
		 FROM    Applicant
		 WHERE   PersonNo   = '#Form.Key2#'
	</cfquery>
	
	<cfif Person.EmployeeNo eq "" and Person.recordcount eq 1>
		<cfquery name="qCheck" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT  * 
			 FROM    Employee.dbo.Person
			 WHERE   IndexNo = '#Person.Indexno#'		 
		</cfquery>
		
		<cfif qCheck.recordcount eq 1>
			
			<cfquery name="UpdatePerson" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE Applicant
				 SET EmployeeNo = '#qCheck.PersonNo#'
				 WHERE   PersonNo   = '#Form.Key2#'
			</cfquery>
			
			<cfquery name="Person" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT  * 
				 FROM    Applicant
				 WHERE   PersonNo   = '#Form.Key2#'
			</cfquery>						
			
		</cfif>	
		
	</cfif>	
	
	<cfif Person.EmployeeNo neq "">
	
		<cfquery name="GetEvent" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT  * 
			 FROM    Employee.dbo.PersonEvent
			 WHERE   EventId = '#Form.Objectid#'		 
		</cfquery>
		
			
		<cfif isDefined("Form.DateEventDue")>
		    <CF_DateConvert Value="#Form.DateEventDue#">
			<cfset DUE = dateValue>
		<cfelse>
		    <cfset DUE = 'NULL'>
		</cfif>
		
		<cfif isDefined("Form.ActionDateEffective")>
		    <CF_DateConvert Value="#Form.ActionDateEffective#">
			<cfset STR = dateValue>
		<cfelse>
		    <cfset STR = 'NULL'>
		</cfif>
		
		<cfif isDefined("Form.ActionDateExpiration")>
		    <CF_DateConvert Value="#Form.ActionDateExpiration#">
			<cfset END = dateValue>
		<cfelse>
		    <cfset END = 'NULL'>
		</cfif>
			
		<cfif getEvent.Recordcount eq "1">
		
			<!--- update event --->
			
			<cfquery name="UpdateEvent" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE  Employee.dbo.PersonEvent
				 SET     EventCode       = '#Form.EventCode#',
				     	 <cfif Form.Reason neq "">
				         	ReasonCode      = '#Form.Reason#',
					 		ReasonListCode  = '#Form.ReasonCode#',
						 </cfif>
						 DateEvent             =  '#Document.DueDate#', 
						 DateEventDue          =  #DUE#, 
						 ActionDateEffective   =  #STR#, 
						 ActionDateExpiration  =  #END#, 
						 Remarks         = '#Form.Remarks#'
				 WHERE   EventId = '#Form.Objectid#'		 
			</cfquery>
		
		<cfelse>
		
			<cfquery name="Insert" 
				 datasource="AppsSelection" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO Employee.dbo.PersonEvent
					 (			 
					 EventId, 
					 EventTrigger, 
					 EventCode, 
					 PersonNo, 
					 Mission, 
					 OrgUnit, 
					 <cfif Form.Reason neq "">
					 ReasonCode, 
					 ReasonListcode, 
					 </cfif>
					 PositionNo, 
					 DocumentNo, 			
		             DateEvent, 
					 DateEventDue, 
					 ActionDateEffective, 
					 ActionDateExpiration, 
					 ActionStatus, 
					 Remarks, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName
					 )

				 VALUES
				 
				 (	 '#Form.Objectid#',   <!--- same as the object --->
					 '#Form.EventTrigger#',
					 '#Form.EventCode#',
					 '#Person.EmployeeNo#',
					 '#Document.Mission#',
					 '#Position.OrgUnitOperational#',
					 <cfif Form.Reason neq "">
					 '#Form.Reason#',
					 '#Form.ReasonCode#',				
					 </cfif>
					 '#Document.PositionNo#',
					 '#Document.DocumentNo#',
					 '#Document.DueDate#',
					 #DUE#,
					 #STR#,
					 #END#,
					 '0',
					 '#Form.Remarks#',
					 '#Session.acc#',
					 '#Session.last#',
					 '#Session.first#'
				 )
				 
				</cfquery>	
		
		</cfif>

	</cfif>

</cfif>



