
<cfif ParameterExists(Form.Insert)> 
   
<cfquery name="Insert" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Terms
         (
		 Description,
		 paymentDays,
		 discount,
		 discountDays,
		 operational,
		  OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
  VALUES (
  			'#Form.Description#', 
			#Form.paymentDays#, 
			#Form.discount#, 
			#Form.discountDays#, 
			#Form.operational#,
          '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')</cfquery>  
           
</cfif>

<cfif ParameterExists(Form.Update)>	

	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Terms
	SET 
		  Description = '#Form.Description#',
		  paymentDays = #Form.paymentDays#,
		  discount = #Form.discount#,
		  discountDays = #Form.discountDays#,
		  operational = #Form.operational#
	WHERE Code   = '#Form.CodeOld#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
			
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_Terms
		WHERE Code = '#FORM.CodeOld#'
	</cfquery>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
