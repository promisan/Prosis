
<cfparam name="Form.DateEffective" default = "">
<cfparam name="Form.DateExpiration" default = "">
<cfparam name="Form.AddressType" default = "">

<cfif Len(Form.Remarks) gt 100>
  <cfset remarks = left(Form.Remarks,100)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cfif Form.DateEffective neq "">
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = #dateValue#>
</cfif>

<cfset dateValue = "">
<cfif Form.DateExpiration neq "">
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
	SELECT   *
	FROM     PersonAddress
	WHERE    PersonNo   = '#Form.PersonNo#' 
	AND      AddressId  = '#Form.AddressId#'
</cfquery>

<cfif Address.recordCount eq 1> 

 <cfif url.action eq "delete"> 
  
   <cfquery name="UpdateContract" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	DELETE FROM  PersonAddress 
    WHERE  PersonNo = '#Form.PersonNo#' 
	AND    AddressId  = '#Form.AddressId#' 
   </cfquery>
 
 <cfelse>
 
	 <cftransaction>
	
		 <cfquery name="UpdateContract" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE PersonAddress 
			   SET   <cfif Form.DateEffective neq ''>
						 DateEffective       = #STR#,
					 </cfif>
			   		 <cfif Form.DateExpiration neq ''>
						 DateExpiration      = #END#,
					 </cfif>	 
					 <cfif Form.AddressType neq "">
				    	 AddressType         = '#Form.Addresstype#',
					 </cfif> 					
					 <cfif Form.AddressZone	neq "">
					 	 AddressZone         = '#Form.AddressZone#',
					 </cfif>	
					 Contact             = '#Form.Contact#',
					 ContactRelationship = '#Form.ContactRelationship#'
			   WHERE PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#' 
	    </cfquery>
		
		<!--- address object --->	
		<cf_address datasource="appsEmployee" 
	            addressid="#Form.AddressId#" mode="save" 
				addressscope="Employee">
		
		<cfquery name="Clear" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM PersonAddressContact
			WHERE  PersonNo = '#Form.PersonNo#' 
			AND    AddressId  = '#Form.AddressId#' 
		</cfquery>	  	  
		   
		<cfquery name="Contact" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Contact	
		ORDER BY ListingOrder
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
							  	'#Form.AddressId#',
								'#Code#',
								'#val#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#')	 
				 </cfquery>
					
			</cfif>	
		
		</cfloop>	    		   
	   
	   </cftransaction>
   
   </cfif>
   
</cfif>   
	  
<cfoutput>
				    
	<script language = "JavaScript">		
	   Prosis.busy('no')	
	   ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Address/EmployeeAddressDetail.cfm?mode=edit&webapp=#url.webapp#&ID=#Form.PersonNo#','addressdetail')		
     </script>	
	 
    <!---
	<cfif FORM.Layout eq "direct">	
		 <script>
			 window.location = "EmployeeAddress.cfm?webapp=#url.webapp#&ID=#Form.PersonNo#";
		 </script>	
	<cfelse>
		 <script>
			 alert('Changes were saved');
	 		 window.location = "AddressEdit.cfm?webapp=#url.webapp#&layout=Wkf&id=#Form.PersonNo#&id1=#Form.AddressId#";
		 </script>	
	</cfif> 
	--->
	
</cfoutput>	   


