
<cfparam name="form.scope" default="listing">

<!---

<cfparam name="form.ReferenceDefault" default="">

<cfif form.referenceDefault neq "">
    <cfset ref = form.ReferenceDefault>
<cfelse>
	<cfset ref = form.Reference>	
</cfif>
--->

 <cfset ref = evaluate("Form.TaxCodeTax")>

<cfquery name="Parameter" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT CustomerDefaultReference
	FROM   Ref_ParameterMission
	WHERE  Mission = '#form.mission#'
</cfquery>

<cfif form.action eq "add">
	
	<cfif Form.CustomerDOB neq ''>
	    <CF_DateConvert Value="#Form.CustomerDOB#">
		<cfset DOB = dateValue>
	<cfelse>
	    <cfset DOB = 'NULL'>
	</cfif>	
	
	<cfset crd = replace("#Form.thresholdcredit#",",","","ALL")>
		
	<cfif not LSIsNumeric(crd)>
	
		<cfoutput>
			<script>
				Prosis.busy('no')
			    alert('Incorrect quantity: #crd#');
			</script>	
		</cfoutput> 		
		<cfabort>
	
	</cfif>	
	
	<cfset val = evaluate("Form.TaxCodeTax")>
	
	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Customer(
			CustomerId,
			Mission,			
			PersonNo,
			Reference,
			<cfif form.OrgUnit neq "">
			OrgUnit,
			</cfif>
			CustomerName,
			CustomerDOB,		
						
			<cfif Form.PhoneNumber neq "">
			PhoneNumber,
			</cfif>
			<cfif Form.MobileNumber neq "">
			MobileNumber,
			</cfif>
			<cfif Form.PostalCode neq "">
			PostalCode,
			</cfif>
			<cfif Form.eMailAddress neq "">
			eMailAddress,
			</cfif>
			<cfif Form.Memo neq "">
			Memo,
			</cfif>
			TaxExemption,
			ThresholdCredit,
			SettleCode,
			Operational,
			OfficerUserId,
			OfficerLastName,
			OfficerFirstName )
		VALUES(
			'#Form.CustomerId#',
			'#Form.Mission#',			
			'#Form.PersonNo#',
			<cfif val eq "">
			  '#Parameter.CustomerDefaultReference#',
			 <cfelse>
			  '#val#',
			</cfif>
			<cfif form.OrgUnit neq "">
			'#Form.OrgUnit#',
			</cfif>
			'#Form.CustomerName#',
			#DOB#,						
			<cfif Form.PhoneNumber neq "">
			'#Form.PhoneNumber#',
			</cfif>
			<cfif Form.MobileNumber neq "">
			'#Form.MobileNumber#',
			</cfif>
			<cfif Form.PostalCode neq "">
			'#Form.PostalCode#',
			</cfif>
			<cfif Form.eMailAddress neq "">
			'#Form.eMailAddress#',
			</cfif>
			<cfif Form.Memo neq "">
			'#Form.Memo#',
			</cfif>
			#Form.TaxExemption#,
			'#crd#',
			'#Form.SettleCode#',
			#Form.Operational#,
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#'
		)
	</cfquery>
	
	<cfloop index="itm" list="Tax,Civilian">
			
	    <cfset val = evaluate("Form.TaxCode#itm#")>
						
		<cfif val neq "">
	
			<cfquery name="InsertCustomer" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		
			  
			 INSERT INTO CustomerTaxCode
		        (CustomerId,
				 Country,
				 Source,
				 TaxCode,					 
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		      VALUES ('#Form.CustomerId#',
		          'GT', <!--- hardcoded --->
				  '#itm#',
				  '#val#',					 	  	 			 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')				  
	        </cfquery>	
		
		</cfif>
			 
	</cfloop>		 
	
	<!--- save details --->
	
	<cfset customerid = form.customerid>	
	<cfinclude template="CustomerSubmitTopic.cfm">
	
	<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Customer WHERE CustomerId = '#Form.CustomerId#'
	</cfquery>
	
	<!---
	<cfinvoke component = "Service.Process.Materials.Customer"  
	   method           = "AddCustomerAddress" 
	   mission			= "#Form.Mission#"
	   warehouse        = "#Form.Warehouse#"
  	   customerId	    = "#Form.CustomerId#">	
    --->
	
	<cfoutput>
		
	<cfif form.scope eq "listing">
				
		<script>	
			    Prosis.busy('no')	  
			    try {	
				   									
					// window.open('CustomerEditTab.cfm?drillid=#Form.CustomerId#&mid=#mid#')
					parent.applyfilter('5','','content')	
					parent.ProsisUI.closeWindow('addcustomer')					
					}
					// parent.window.resizeTo(920,720);
				 catch(e) {}    	
	    </script>	
		
	<cfelse>
	
		<script>	
			    Prosis.busy('no')	  
			    try {	
				   					
					parent.document.getElementById('CustomerSerialNo').value = '#get.CustomerSerialNo#'
					parent.document.getElementById('search').click()
					parent.ProsisUI.closeWindow('addcustomer')					
					}
					
				 catch(e) {}    	
	    </script>	
	
	</cfif>	
			
	</cfoutput>
			
<cfelseif form.action eq "edit">

	<cfif Form.CustomerDOB neq ''>
	    <CF_DateConvert Value="#Form.CustomerDOB#">
		<cfset DOB = dateValue>
	<cfelse>
	    <cfset DOB = 'NULL'>
	</cfif>	
	
	<cfset crd = replace("#Form.thresholdcredit#",",","","ALL")>
	
	<cfif not LSIsNumeric(crd)>
	
		<script>
		    alert('Incorrect quantity: '+crd)
		</script>	 		
		<cfabort>
	
	</cfif>
	
	<cfset val = evaluate("Form.TaxCodeTax")>
	
	<cfquery name="Update" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Customer
		SET    CustomerName    = '#Form.CustomerName#',
			   CustomerDOB     =  #DOB#,
			   PersonNo        = '#Form.PersonNo#',			  
			   <cfif form.OrgUnit neq "">
			   OrgUnit		   = '#Form.OrgUnit#',
			   </cfif>
			   <cfif val eq "">
			   Reference       = '#Parameter.CustomerDefaultReference#',
			   <cfelse>
			   Reference       = '#val#',
			   </cfif>
			   PhoneNumber     = '#Form.PhoneNumber#',
			   MobileNumber    = '#Form.MobileNumber#',
			   PostalCode      = '#Form.PostalCode#',
			   eMailAddress    = '#Form.eMailAddress#',
			   ThresholdCredit = '#crd#', 
			   Memo		       = '#Form.Memo#',
			   SettleCode      = '#Form.SettleCode#',
			   TaxExemption    =  #Form.TaxExemption#,
			   Operational     =  #Form.Operational#
		WHERE CustomerId       = '#Form.CustomerId#'
		AND   Mission          = '#Form.Mission#'
	</cfquery>
	
	<cfloop index="itm" list="Tax,Civilian">
			
	    <cfset val = evaluate("Form.TaxCode#itm#")>
		
		   <cfquery name="ResetTaxCode" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 				  
				 DELETE FROM CustomerTaxCode
				 WHERE  CustomerId = '#Form.customerid#'
				        AND Country    = 'GT' 
					    AND Source     = '#itm#'			  
						
	        </cfquery>	
						
		<cfif val neq "">	    
	
			<cfquery name="InsertCustomer" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		
			  
				 INSERT INTO CustomerTaxCode
			        (CustomerId,
					 Country,
					 Source,
					 TaxCode,					 
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#Form.CustomerId#',
			          'GT', <!--- hardcoded --->
					  '#itm#',
					  '#val#',					 	  	 			 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')	
					  			  
	        </cfquery>	
		
		</cfif>
	 
	 </cfloop>		 
	
	<cfset customerid = form.customerid>	
	<cfinclude template="CustomerSubmitTopic.cfm">
	
	<!--- save details --->

	<cfoutput>
	
		<cfif form.scope eq "listing">
				
			<script>	
				    Prosis.busy('no')										
				    try {						
						parent.opener.applyfilter('0','','#Form.Customerid#')																
					} catch(e) {}    	
		    </script>	
		
	    <cfelse>
	
			<script>	
				    Prosis.busy('no')	
					 
				    try {						   									
						// alert('refresh the search with the new customer')							
						parent.ProsisUI.closeWindow('addcustomer')					
						}
						
					 catch(e) {}    	
		    </script>	
	
		</cfif>	
		
		<cfset url.scope = form.scope>
			
		<cfset url.drillid = Form.CustomerId>		
		<cfinclude template="CustomerEdit.cfm">
	
	</cfoutput>
	
</cfif>
