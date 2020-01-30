
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
FROM   Ref_AccountParent
WHERE AccountParent  = '#Form.AccountParent#' 
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
INSERT INTO Ref_AccountParent
         (AccountParent,
		 Description,
		 AccountClass,
		 AccountType,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
  VALUES ('#Form.AccountParent#', 
          '#Form.Description#',
		  '#Form.AccountClass#',
		  '#Form.AccountType#',
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
	UPDATE Ref_AccountParent
	SET    Description     = '#Form.Description#',
		   AccountType     = '#Form.AccountType#',
		   AccountClass    = '#FORM.AccountClass#'
	WHERE  AccountParent   = '#Form.AccountParent#'
</cfquery>

 <cf_LanguageInput
		TableCode       = "AccountParent" 
		Mode            = "Save"
		Key1Value       = "#Form.AccountParent#"
		Name1           = "Description">
	

</cfif>	

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT AccountParent
      FROM Ref_AccountGroup
      WHERE Ref_AccountParent  = '#Form.AccountParent#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Parent is in use. Operation aborted.")
     
     </script>  
	 
	 
    <cfelse>
			
	<cfquery name="Delete" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_AccountParent WHERE AccountParent   = '#Form.AccountParent#'
    </cfquery>
	
    </cfif>	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
