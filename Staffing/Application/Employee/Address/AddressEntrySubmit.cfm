
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<!--- verify if record exist --->

<cfquery name="Address" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  vwPersonAddress
	WHERE PersonNo          = '#Form.PersonNo#' 
	AND   AddressType       = '#Form.AddressType#' 
	<cfif form.addressPostalcode neq "">
	AND   AddressPostalCode = '#Form.AddressPostalCode#'
	<cfelse>
	AND   Address           = '#Form.Address#'
	</cfif>
</cfquery>

<cfparam name="Address.RecordCount" default="0">

<cfif Address.recordCount gte 1> 
	<cf_tl id="You entered an existing address record. Operation not allowed." var="1">
   <cf_alert message = "#lt_text#">

<CFELSE>

	<cf_AssignId>
	
	<cfset AddressId = rowguid>
	
	<cftransaction>

    <cfquery name="InsertAddress" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO PersonAddress
		         (PersonNo,
				 AddressId,
				 DateEffective,
				 DateExpiration,
				 AddressType,				
				 <cfif FORM.AddressZone neq "">
				 AddressZone,
				 </cfif>					
				 Contact,
				 ContactRelationship,				
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	      VALUES ('#Form.PersonNo#',
			  	  '#AddressId#',
		          #STR#,
				  #END#,
				  '#Form.AddressType#',				
				  <cfif FORM.AddressZone neq "">
				  '#Form.AddressZone#',		  
				  </cfif> 				  	
				  '#Form.Contact#',
				  '#Form.ContactRelationship#',				 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	</cfquery>
	
    <!--- address object --->	
	<cf_address datasource="appsEmployee" 
	            addressid="#addressid#" mode="save" 
				addressscope="Employee">
	
	<cfquery name="Contact" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Contact	
	</cfquery>
	
	<cfloop query="Contact">
	
		<cfparam name="Form.Contact_#currentrow#" default="">
		<cfset val = evaluate("Form.Contact_#currentrow#")>
		
		<cfif val neq "">
		
			 <cfquery name="InsertAddress" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO PersonAddressContact
					        (PersonNo,
							 AddressId,
							 ContactCode,
							 ContactCallSign,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				 VALUES    ('#Form.PersonNo#',
						  	'#AddressId#',
							'#Code#',
							'#val#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')	 
			 </cfquery>
				
		</cfif>	
	
	</cfloop>	 
	
	</cftransaction> 		  
		  
    <!--- create a workflow 
	1. check if the workflow is enabled for the address type
	2. determine mission and check if workflow is enabled for that mission
	3. check if workflow has a class published	
	only then create workflow	
	--->
				
	<cfquery name="AddressType" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_AddressType
		WHERE  AddressType  = '#Form.AddressType#'
		<!--- has a published workflow --->
		AND    EntityClass IN (SELECT EntityClass 
		                       FROM   Organization.dbo.Ref_EntityClassPublish 
							   WHERE  EntityCode = 'PersonAddress')
	</cfquery>
	
	<cfif addresstype.recordcount eq "1">
	
		<cf_verifyOnBoard PersonNo = "#form.PersonNo#">
		
		<!--- mission only if it is enabled in the workflow for that mission --->
		
		<cfif mission neq "">		
						
			<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Person
				WHERE  PersonNo = '#form.PersonNo#' 
			</cfquery>
							
			<cfset link = "Staffing/Application/Employee/Address/AddressEdit.cfm?id=#Form.PersonNo#&id1=#AddressId#">
				
			<cf_ActionListing 
			    EntityCode       = "PersonAddress"
				EntityClass      = "#addresstype.entityclass#"
				EntityGroup      = ""
				EntityStatus     = ""	
				PersonNo         = "#form.Personno#"
				ObjectReference  = "#form.addresstype#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#" 	
			    ObjectKey1       = "#Form.PersonNo#"
				ObjectKey4       = "#AddressId#"
				AjaxId           = "#AddressId#"	
				ObjectURL        = "#link#"
				Show             = "No">
				
		</cfif>
	
	</cfif>
	
	<cfoutput>
				    
	<script language = "JavaScript">			
	    var vContainer = 'requestdetail';
		if ($('##addressdetail').length > 0 || $("input[name='addressdetail']").length > 0) {
			vContainer = 'addressdetail';
		}
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Address/EmployeeAddressDetail.cfm?mode=edit&webapp=#url.webapp#&ID=#Form.PersonNo#',vContainer);
     </script>	
	 
	 </cfoutput>	   
	
</cfif>	

