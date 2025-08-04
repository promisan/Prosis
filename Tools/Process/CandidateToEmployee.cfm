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

<!--- ------------------------------------------------------------------- --->
<!--- option to generate an employee record for applicant who is arriving --->
<!--- ------------------------------------------------------------------- --->

<cfparam name="attributes.applicantno" default="">

<!--- verify is person record exist --->

<cfquery name="Applicant" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT   *
  FROM     Applicant
  WHERE    PersonNo = '#attributes.ApplicantNo#'
</cfquery>

<cfif Applicant.recordcount eq "0">
     <!--- Problem with passed applicant no --->
     <cfabort>
</cfif>

<!--- check if employeeNo exisits --->

<cfset personNo = "">

<cfif Applicant.EmployeeNo neq "">

	<cfquery name="Person" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT PersonNo
	  FROM   Person
	  WHERE  Person.PersonNo = '#Applicant.EmployeeNo#'  
	</cfquery>
	
	<cfif Person.Recordcount eq "1">
	   <cfset personNo = Person.PersonNo>	
	</cfif>

</cfif>

<cfif personNo eq "" and Applicant.IndexNo neq "">
	
	<cfquery name="Person" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT TOP 1 PersonNo
	  FROM   Person
	  WHERE  Person.IndexNo = '#Applicant.IndexNo#'	
	</cfquery>
	
	<cfif Person.Recordcount eq "1">
	   <cfset personNo = Person.PersonNo>	
	</cfif>
		
</cfif>	

<!--- try matching on the name and dob --->

<cfif personNo eq "">
	
	<cfquery name="Person" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT TOP 1 PersonNo
	  FROM   Person
	  WHERE  Person.LastName           = '#Applicant.LastName#' 
	    AND  LEFT(Person.FirstName,1)  = '#left(Applicant.FirstName,1)#' 
	    AND  Person.Nationality        = '#Applicant.Nationality#' 
	    AND  Person.BirthDate          = '#Applicant.DOB#'  
	</cfquery>
	
	<cfif Person.Recordcount eq "1">
	   <cfset personNo = Person.PersonNo>	
	</cfif>
		
</cfif>	

<cfif PersonNo neq ""> 

   <cfset PersonNo = Person.PersonNo>
   
<cfelse>

    <!--- ------------------------ --->
	<!--- generate employee record --->
	<!--- ------------------------ --->

	<cfquery name="AssignNo" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     	UPDATE Parameter SET PersonNo = PersonNo+1
     </cfquery>
	 
	 <!--- check --->
	 
	 <cfquery name="LastNo" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	SELECT *
		    FROM Parameter
	 </cfquery>
	 
	 <cfquery name="check" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	SELECT *
		    FROM Person
			WHERE PersonNo = '#LastNo.PersonNo#'
	 </cfquery>
	 
	 <cfloop condition="#check.recordcount# eq 1">
	 
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
		 
	    <cfquery name="check" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	SELECT *
		    FROM Person
			WHERE PersonNo = '#LastNo.PersonNo#'
		</cfquery>
	 
	 </cfloop>
	 	 
     <cfquery name="InsertPerson" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO Person 
	         (PersonNo,
			 IndexNo, 
			 LastName,
			 FirstName,
			 MiddleName,
			 BirthDate,
			 Gender,
			 Nationality,
			 BirthNationality,
			 BirthCity,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Source,
			 Created)
      VALUES ('#LastNo.PersonNo#',
	          '#Applicant.IndexNo#',
			  '#Applicant.LastName#',
			  '#Applicant.FirstName#',
			  '#Applicant.MiddleName#',
			  '#Applicant.DOB#',
			  '#Applicant.Gender#',
			  '#Applicant.Nationality#',
			  '#Applicant.BirthNationality#',
			  '#Applicant.BirthCity#',
		  	  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  'VACANCY',
			  '#DateFormat(Now(),CLIENT.DateSQL)#')
	</cfquery>
		
	<cfquery name="Applicant" 
	 datasource="AppsSelection" 
	 maxrows=1 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     UPDATE   Applicant
	     SET      EmployeeNo = '#LastNo.PersonNo#'
	     WHERE    PersonNo = '#attributes.ApplicantNo#'
	</cfquery>
	
	<cfset PersonNo = LastNo.PersonNo>
		  
</cfif>		

<cfset caller.PersonNo = PersonNo>  

