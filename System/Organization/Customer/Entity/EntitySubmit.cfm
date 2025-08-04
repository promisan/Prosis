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


<!--- create --->


<cfquery name="get"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  *
    FROM    Applicant
	WHERE   PersonNo = '#url.personNo#'	
</cfquery>
	
<cfif get.recordcount eq "1"> 
			  
   <cfquery name="InsertSubmission" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  	   INSERT INTO WorkOrder.dbo.Customer
	       	(PersonNo,
		 	Mission,
			Reference,
	  	 	CustomerName, 					 		 	
		 	eMailAddress,					 	
		 	OfficerUserId,
		 	OfficerLastName,
		 	OfficerFirstName,	
		 	Created)
      	VALUES ('#get.PersonNo#',
	       	'#url.Mission#', 
			'#get.IndexNo#',
           	'#get.firstname# #get.middlename# #get.lastname# #get.lastname2#',				  		  	
		  	'#get.eMailAddress#',						
		  	'#SESSION.acc#',
    	  	'#SESSION.last#',		  
	  	  	'#SESSION.first#',
		  	getDate())
  </cfquery>
  
  <cfoutput>
   <img src="#session.root#/images/checkmark.png" alt="" border="0">
  </cfoutput>
  
</cfif>	   
		