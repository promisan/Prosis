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

<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.Code"               default="0">
<cfparam name="Form.Description"        default="">


<cfquery name="VerifyReferencePrefix" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ElementClass
		WHERE	ReferencePrefix = '#Form.ReferencePrefix#'
</cfquery>

<cfif URL.code neq "new">	
	
	<cfif VerifyReferencePrefix.recordCount eq 0 or Form.ReferencePrefix eq Form.ReferencePrefixOld>
	
		<cfquery name="Update" 
		  datasource="AppsCaseFile" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
				UPDATE Ref_ElementClass
				SET 
					ClaimType = '#Form.ClaimType#',
					ListingOrder = '#Form.ListingOrder#',
					ReferencePrefix = '#Form.ReferencePrefix#',
					ReferenceSerialNo = '#Form.ReferenceSerialNo#',
					Description  = '#Form.Description#',
					EnableMatching = '#Form.EnableMatching#',
					EnableAssociation = '#Form.EnableAssociation#',
					AssociationSource = '#Form.AssociationSource#',
					EnablePicture	= '#Form.EnablePicture#'
				WHERE Code = '#Form.ElementCode#'
				AND ClaimType = '#Form.ClaimTypeOld#'
		</cfquery>		
		
	<cfelse>
	
		<script language="JavaScript">
	   
	     alert("The reference prefix must be unique!")
	     
		</script>
	
	</cfif>
				

<cfelse>
			
	<cfquery name="Verify" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ElementClass
		WHERE Code = '#Form.Code#' 
		AND ClaimType = '#Form.ClaimType#' 
	</cfquery>

    <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("An record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   
   		<cfif VerifyReferencePrefix.recordCount eq 0>
   
			<cfquery name="Insert" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ElementClass
				         (Code,
						 ClaimType,
						 Description,
						 ListingOrder, 
						 ReferencePrefix,
						 ReferenceSerialNo,
						 AssociationSource,
						 EnableMatching,
						 EnableAssociation,
						 EnablePicture,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,	
						 Created)
				  VALUES ('#Form.Code#', 
						  '#Form.ClaimType#',  
				          '#Form.Description#',
	  	  				  '#Form.ListingOrder#',
						  '#Form.ReferencePrefix#',
						  '#Form.ReferenceSerialNo#',
						  '#Form.AssociationSource#',
						  '#Form.EnableMatching#',
						  '#Form.EnableAssociation#',
						  '#Form.EnablePicture#',
				   	      '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					      '#SESSION.first#',
					       getDate())
			  </cfquery>			  
			
		<cfelse>
		
			<script language="JavaScript">
		   
		     alert("The reference prefix must be unique!")
		     
			</script>
		
		</cfif>
		  
	</cfif>		
		   	
</cfif>

<cfset url.code = "">
<cfinclude template="RecordListingDetail.cfm">