<!--
    Copyright © 2025 Promisan B.V.

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

 <cfif url.action eq "delete"> 
  
   <cfquery name="DeleteRecord" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	DELETE FROM        CustomerAddress 
    WHERE  CustomerId  = '#Form.CustomerId#' 
	AND    AddressId   = '#Form.AddressId#' 
   </cfquery>
 
   	<cfoutput>
				    
		<script language = "JavaScript">			
	   		ColdFusion.navigate('#SESSION.root#/Warehouse/Application/Customer/Address/CustomerAddress.cfm?customerid=#Form.customerid#','addressdetail')		
     	</script>	
	
	</cfoutput>	 
 
 <cfelse>
 
	 <cftransaction>
	
		 <cfquery name="UpdateAddress" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE CustomerAddress 
			   SET    DateEffective    = #STR#,
					  DateExpiration   = #END#,
				   	  AddressType      = '#Form.Addresstype#'
			   WHERE  CustomerId       = '#Form.CustomerId#' 
			   AND    AddressId  = '#Form.AddressId#' 
	    </cfquery>
		
		<cfquery name="ContactType" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Contact 
		</cfquery>
		
		<!--- clean records --->
		<cfquery name="Clean" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM   CustomerAddressContact
		    WHERE  CustomerId = '#Form.CustomerId#' 
		    AND    AddressId  = '#Form.AddressId#' 
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
	            addressid="#Form.AddressId#" mode="save" 
				addressscope="Customer">   		   
	   
	 </cftransaction>
   
	<cfoutput>
				    
		<script language = "JavaScript">			
	   		ptoken.navigate('#SESSION.root#/Warehouse/Application/Customer/Address/AddressEdit.cfm?mode=edit&customerid=#Form.customerid#&addressid=#Form.Addressid#','addressdetail')		
     	</script>	
	
	</cfoutput>	 
   
</cfif>
   
  


