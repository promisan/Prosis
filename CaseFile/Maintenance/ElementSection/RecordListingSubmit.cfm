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

<cfif URL.code neq "new">

	 <cfquery name="Update" 
		  datasource="AppsCaseFile" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			UPDATE Ref_ElementSection
			SET Description  = '#Form.Description#',
			ListingLabel = '#Form.ListingLabel#',
			ListingOrder = '#Form.ListingOrder#',
			ListingIcon  = '#Form.ListingIcon#'
			WHERE Code = '#URL.Code#'
	</cfquery>
				

<cfelse>
			
	<cfquery name="Verify" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ElementSection
		WHERE Code = '#Form.Code#' 
	</cfquery>

    <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
		     alert("A record with this code has been registered already!")
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ElementSection
			         (Code,
					 Description,
					 ListingLabel,
					 ListingOrder,
					 ListingIcon, 
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#Form.Code#', 
			          '#Form.Description#',
  	  				  '#Form.ListingLabel#',
  	  				  '#Form.ListingOrder#',
					  '#Form.ListingIcon#',
			   	      '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				      '#SESSION.first#',
				       getDate())
		  </cfquery>
		  
	</cfif>	  
		   	
</cfif>

<cfset url.code = "">
<cfinclude template="RecordListingDetail.cfm">
