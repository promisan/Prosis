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
<cfparam name="Form.Country" default="">
<cfparam name="Form.FirstName" default="">
<cfparam name="Form.LastName" default="">
<cfparam name="Form.AddressLine1" default="">
<cfparam name="Form.AddressLine2" default="">
<cfparam name="Form.AreaCode" default="">
<cfparam name="Form.Phone" default="">
<cfparam name="Form.Relationship" default="">
<cfparam name="Form.Memo" default="">


	<cfquery 
		name="Check" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  ClaimNextOfKin
			WHERE ClaimId = '#url.Claimid#'	
	</cfquery>

	<cfif Check.recordcount eq "0">
	
	   <cfquery name="InsertClaim" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ClaimNextOfKin
         (ClaimId,
		 Country,
		 FirstName,
		 LastName,
		 AddressLine1,
		 AddressLine2,
		 AreaCode,
		 Phone,
		 Relationship,
		 Memo,
		 ActionStatus,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#URL.ClaimId#',
          '#Form.Country#',
          '#Form.FirstName#',
          '#Form.LastName#',
          '#Form.AddressLine1#',
          '#Form.AddressLine2#',
          '#Form.AreaCode#',
          '#Form.Phone#',
          '#Form.Relationship#',
		  '#Form.Memo#',
		  '1',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
	  </cfquery>	
  
<cfelse>

	<!--- create new record --->
	
	<cftransaction>
	
	 <cfquery name="UpdateClaim" 
	     datasource="AppsCaseFile" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 UPDATE ClaimNextOfKin
		 SET    ActionStatus = '9'           
	     WHERE  ClaimId = '#URL.ClaimID#' 		
	 </cfquery>	

	 <cfquery name="InsertClaim" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ClaimNextOfKin
	         (ClaimId,
			 Country,
			 FirstName,
			 LastName,
			 AddressLine1,
			 AddressLine2,
			 AreaCode,
			 Phone,
			 Relationship,
			 Memo,
			 ActionStatus,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
      VALUES ('#URL.ClaimId#',
          '#Form.Country#',
          '#Form.FirstName#',
          '#Form.LastName#',
          '#Form.AddressLine1#',
          '#Form.AddressLine2#',
          '#Form.AreaCode#',
          '#Form.Phone#',
          '#Form.Relationship#',
		  '#Form.Memo#',
		  '1',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
	  </cfquery>	
	  
	 </cftransaction>
	
</cfif>	
	
<cfinclude template="NextOfKin.cfm">
