
<cfif  ParameterExists(Form.Save)>
	
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
	
	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Customer(
			CustomerId,
			Mission,			
			PersonNo,
			<cfif form.OrgUnit neq "">
			OrgUnit,
			</cfif>
			CustomerName,
			CustomerDOB,
			<cfif Form.Reference neq "">
			Reference,
			</cfif>
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
			Operational,
			OfficerUserId,
			OfficerLastName,
			OfficerFirstName,
			Created
		)
		VALUES(
			'#Form.CustomerId#',
			'#Form.Mission#',			
			'#Form.PersonNo#',
			<cfif form.OrgUnit neq "">
			'#Form.OrgUnit#',
			</cfif>
			'#Form.CustomerName#',
			#DOB#,
			<cfif Form.Reference neq "">
			'#Form.Reference#',
			</cfif>
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
			#Form.Operational#,
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#',
			getdate()
		)
	</cfquery>
	
<!---
	<cfinvoke component = "Service.Process.Materials.Customer"  
	   method           = "AddCustomerAddress" 
	   mission			= "#Form.Mission#"
	   warehouse        = "#Form.Warehouse#"
  	   customerId	    = "#Form.CustomerId#">	--->
	
	<cfoutput>
	
		<script>	
		    Prosis.busy('no')	  
		    try {				
				parent.opener.applyfilter('','','content');
				parent.window.location = 'CustomerEditTab.cfm?drillid=#Form.CustomerId#'
				parent.window.resizeTo(920,720);
			} catch(e) {}    	
    	</script>	
	
	</cfoutput>
	
<cfelseif  ParameterExists(Form.Update)>

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
	
	<cfquery name="Update" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Customer
		SET    CustomerName    = '#Form.CustomerName#',
			   CustomerDOB     =  #DOB#,
			   PersonNo        = '#Form.PersonNo#',
			   Reference       = '#Form.Reference#',
			   <cfif form.OrgUnit neq "">
			   OrgUnit		   = '#Form.OrgUnit#',
			   </cfif>
			   PhoneNumber     = '#Form.PhoneNumber#',
			   MobileNumber    = '#Form.MobileNumber#',
			   PostalCode      = '#Form.PostalCode#',
			   eMailAddress    = '#Form.eMailAddress#',
			   ThresholdCredit = '#crd#', 
			   Memo		       = '#Form.Memo#',
			   TaxExemption    =  #Form.TaxExemption#,
			   Operational     =  #Form.Operational#
		WHERE CustomerId       = '#Form.CustomerId#'
		AND   Mission          = '#Form.Mission#'
	</cfquery>

	<cfoutput>
	
		<script>
		    Prosis.busy('no')  			
	
    	</script>	
		
		<cfset url.drillid = "#Form.CustomerId#">
		<cfinclude template="CustomerEdit.cfm">
	
	</cfoutput>
	
</cfif>
