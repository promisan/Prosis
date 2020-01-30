
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cfif Len(#Form.Description#) gt 80>

 <cf_message message = "You entered a description that exceeded the allowed size of 80 characters."
  return = "back">
  <cfabort>

</cfif>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Ref_AccountGroup
WHERE AccountGroup  = '#Form.AccountGroup#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("An account with this code has been registered already!")
     
   </script>  
  
   <cfelse>

<cfquery name="Insert" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_AccountGroup
         (AccountGroup,
		 Description,
		 AccountClass,
		 AccountType,
		 AccountParent,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
  VALUES ('#Form.AccountGroup#', 
          '#Form.Description#',
		  '#Form.AccountClass#',
		  '#Form.AccountType#',
		  '#Form.AccountParent#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_AccountGroup
	SET    Description     = '#Form.Description#',
		   ListingOrder    = '#Form.ListingOrder#',
		   AccountType     = '#Form.AccountType#',
		   AccountClass    = '#FORM.AccountClass#'
	WHERE  AccountGroup   = '#Form.AccountGroup#'
</cfquery>

 <cf_LanguageInput
		TableCode       = "AccountGroup" 
		Mode            = "Save"
		Key1Value       = "#Form.AccountGroup#"
		Name1           = "Description">
	

</cfif>	

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT AccountGroup
      FROM Ref_Account
      WHERE AccountGroup  = '#Form.AccountGroup#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Group is in use. Operation aborted.")
     
     </script>  
	 
	 
    <cfelse>
			
	<cfquery name="Delete" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_AccountGroup WHERE AccountGroup   = '#Form.AccountGroup#'
    </cfquery>
	
    </cfif>	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
