<cfparam name="url.entryScope"  default="Backoffice">
<cfparam name="url.mission" 	default="">
	
<cfif Len(Form.Remarks) gt 300>
  <cfset remarks = left(Form.Remarks,300)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<!--- verify if record exist --->

<cfquery name="Address" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*
FROM   ApplicantAddress A
WHERE  PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#'
</cfquery>

<cfif Address.recordCount eq 1> 

 <cfquery name="InsertContract" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   UPDATE ApplicantAddress 
	   SET 	 AddressType         = '#Form.Addresstype#',
			 Address1            = '#Form.Address#',
			 Address2            = '#Form.Address2#',
			 City                = '#Form.AddressCity#',
			 <!---
			 AddressZone         = '#Form.AddressZone#',		
			 --->
			 AddressPostalCode   = '#Form.AddressPostalCode#',
			 Coordinates         = '#Form.cLatitude#,#Form.cLongitude#',
			 Country             = '#Form.Country#',
			 TelephoneNo         = '#Form.TelephoneNo#',
			 State               = '#Form.State#',
			 FaxNo               = '#Form.FaxNo#',
			 Cellular            = '#Form.Cellular#',
			 eMailAddress        = '#Form.eMailAddress#',
			 Contact             = '#Form.Contact#',
			 ContactRelationship = '#Form.ContactRelationship#',		 
			 Remarks             = '#Remarks#'
	   WHERE PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#' 
   </cfquery>
	  
   <cfoutput>
   
	 <script>
				
		<cfif url.entryScope eq "Backoffice">
			
			 ptoken.navigate('#SESSION.root#/Roster/Candidate/Details/Address/Address.cfm?ID=#url.id#&mission=#url.mission#&entryscope=#url.entryscope#','addressbox');
		 
		<cfelseif url.entryScope eq "Portal">
		 
		 	<cfparam name="url.applicantno" default="0">
			<cfparam name="url.section"     default="">
		 
		 	ptoken.location('#SESSION.root#/Roster/PHP/PHPEntry/Address/Address.cfm?Owner=#url.owner#&mission=#url.mission#&ID=#url.id#&entryscope=#url.entryScope#&object=applicant&applicantno=#url.applicantno#&section=#url.section#');
			
	 	</cfif>
		 
     </script>	
	 
   </cfoutput>	   
		
</cfif>	

