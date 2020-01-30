
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
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT * 
	FROM   vwCustomerAddress         
	WHERE  CustomerId = '#Form.CustomerId#'
	AND    AddressType   = '#Form.AddressType#' 
	<cfif form.addressPostalcode neq "">
	AND    AddressPostalCode = '#Form.AddressPostalCode#'
	<cfelse>
	AND    Address           = '#Form.Address#'
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
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     INSERT INTO CustomerAddress
			         (CustomerId,
					 AddressId,
					 AddressType,		
					 DateEffective,
					 DateExpiration,		
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		      VALUES ('#Form.CustomerId#',
				  	  '#AddressId#',
	 				  '#Form.AddressType#',			
			          #STR#,
					  #END#,				 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		
		<cfquery name="ContactType" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Contact 
		</cfquery>
		
		<cfoutput query="ContactType">
			
			<cfparam name="Form.contact_#Code#" default="">
			
			<cfif Evaluate("Form.contact_#code#") neq "">
			
				<cfset c = Evaluate("Form.contact_#code#")>
			
				<cfquery name="InsertContact" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 
				 	INSERT INTO CustomerAddressContact
					VALUES(
						'#Form.CustomerId#',
						'#AddressId#',
						'#code#',
						'#c#',
						'#SESSION.acc#',
						'#SESSION.Last#',
						'#SESSION.First#',
						getdate()
					)
				 	
				 </cfquery>
					
			</cfif>
			
		</cfoutput>
		
	    <!--- address object --->	
		<cf_address datasource="appsMaterials" 
		            addressid="#addressid#" mode="save" 
					addressscope="Customer">
	
	</cftransaction> 		  
	
	<cfoutput>
				    
	<script language = "JavaScript">			
	    ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/Address/CustomerAddress.cfm?customerid=#Form.CustomerId#','addressdetail')		
    </script>	
	 
	</cfoutput>	   
	
</cfif>	

