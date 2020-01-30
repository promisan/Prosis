
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