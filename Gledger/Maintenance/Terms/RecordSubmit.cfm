
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Insert" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Terms
         (Description,
		 PaymentDays,
		 DiscountDays,
		 Discount,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Description#',
          '#Form.PaymentDays#',
		  '#Form.DiscountDays#',
		  '#Form.Discount#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_Terms
SET 
Description       = '#Form.Description#',
Discount          = #FORM.Discount/100#,
Discountdays      = #FORM.DiscountDays#,
PaymentDays       = #Form.PaymentDays#
WHERE Code        = #FORM.Code#
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 
			
	<cfquery name="Delete" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_Terms WHERE Code  = #Form.Code# 
    </cfquery>
	
</cfif>	

<script language="JavaScript">
     window.close()
	 opener.history.go()
</script>  
