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
<cfif URL.Source eq "vac">

	<!--- check if person is associated in the staffing table
	
	coded 15/12/2006 Hanno van Pelt
	
	1. Check if EmployeeNo is filled and exists
		if not 
	
		2. Check if IndexNo is filled and exists, update EmployeeNo
	
		if not return error unless Mission pointer = 1
		
			3. Check if LastName, FirstName, DOB and Nationality exists, update EmployeeNo + IndexNo
			4. Create record and update Employeeno and Indexno
	--->
	
	<cfquery name="Applicant" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Applicant A
		WHERE  PersonNo = '#URL.ApplicantNo#' 
	</cfquery>
	
	<cfquery name="Check1" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Applicant A
		WHERE  PersonNo  = '#URL.ApplicantNo#'
		AND    A.EmployeeNo IN (SELECT PersonNo
		                        FROM   Employee.dbo.Person 
								WHERE  PersonNo = A.EmployeeNo) 
	</cfquery>
	
	<cfif Check1.recordcount eq "0">
	
		<cfquery name="Check2" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Applicant A
			WHERE PersonNo = '#URL.Applicantno#'
			AND A.IndexNo IN (SELECT IndexNo FROM Employee.dbo.Person)
			AND A.IndexNo != ''
		</cfquery>
	
		<cfif Check2.recordcount eq "1">
		
			<cfquery name="Update" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Applicant 
				SET EmployeeNo = (SELECT  TOP 1 PersonNo 
				                  FROM    Employee.dbo.Person 
								  WHERE   IndexNo = '#Check2.Indexno#')
				WHERE PersonNo = '#URL.ApplicantNo#'
			</cfquery>
			
		<cfelse>
		
			<cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM Ref_Mission 
				WHERE Mission = '#URL.Mission#' 
			</cfquery>
			
			<cfif Mission.StaffingCreatePerson eq "0">
			
				<cf_message message="Candidate has not been recorded or associated to an employee record (IndexNo)" return="close">
				<cfabort>
			
			<cfelse>
			
				<!--- verify is person record exist --->
		
				<cfquery name="Check3" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT PersonNo
					FROM   Person
					WHERE  LastName     = '#Applicant.LastName#' 
					AND    FirstName    = '#Applicant.FirstName#'
					AND    BirthDate    = '#dateFormat(Applicant.DOB,client.dateSQL)#' 
					AND    Nationality  = '#Applicant.Nationality#'
				</cfquery>
						
				<cfif Check3.recordcount eq "1">
			
					<cfquery name="Update" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	UPDATE Applicant 
						SET EmployeeNo = '#Check3.PersonNo#',
						 IndexNo = (SELECT  TOP 1 IndexNo 
						                  FROM    Employee.dbo.Person 
										  WHERE   PersonNo = '#Check3.PersonNo#')				  
						WHERE PersonNo = '#URL.ApplicantNo#'
					</cfquery>
					
				<cfelse>	
					
					<cfquery name="AssignNo" 
		     		datasource="AppsEmployee" 
					username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					     UPDATE Parameter SET PersonNo = PersonNo+1
				    </cfquery>
		
				    <cfquery name="LastNo" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT *
					     FROM Parameter
		    	    </cfquery>
		 
				     <cfquery name="InsertPerson" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO Person 
				         (PersonNo,
						 IndexNo, 
						 LastName,
						 MaidenName,
						 FirstName,
						 MiddleName,
						 BirthDate,
						 Gender,
						 eMailAddress,
						 Nationality,
						 BirthNationality,
						 BirthCity,
						 OrganizationStart,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,	
						 Source)
				      VALUES ('#LastNo.PersonNo#',
				          '#Applicant.IndexNo#',
						  '#Applicant.LastName#',
						  '#Applicant.MaidenName#',
						  '#Applicant.FirstName#',
						  '#Applicant.MiddleName#',
						  '#dateFormat(Applicant.DOB,client.dateSQL)#',
						  '#Applicant.Gender#',
						  '#Applicant.emailAddress#',
						  '#Applicant.Nationality#',
						  '#Applicant.BirthNationality#',
						  '#Applicant.BirthCity#',
					      '#dateFormat(now(),client.dateSQL)#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#',
						  'VACTRACK')
					   </cfquery>
					  
					   <cfquery name="Update" 
						 datasource="AppsSelection" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
					    	UPDATE Applicant 
							SET EmployeeNo = '#LastNo.PersonNo#'
							WHERE PersonNo = '#URL.ApplicantNo#'
						</cfquery>
				  
				  </cfif>
								
				</cfif>
						
			</cfif>
			
		</cfif>

</cfif>
	
<cfoutput>


<table width="100%" height="100%">
<tr><td width="100%" height="100%"> 

	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>        

	<iframe src="#session.root#/Staffing/Application/Position/Lookup/PositionView.cfm?Source=#URL.Source#&Mission=#URL.Mission#&MandateNo=#URL.MandateNo#&ApplicantNo=#URL.ApplicantNo#&PersonNo=#URL.PersonNo#&RecordId=#URL.RecordId#&DocumentNo=#URL.DocumentNo#&mid=#mid#"
        name="main" id="main" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
			
</td></tr>
</table>

</cfoutput>
