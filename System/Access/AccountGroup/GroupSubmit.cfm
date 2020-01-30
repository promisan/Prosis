
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AccountGroup
WHERE 
AccountGroup   = '#Form.AccountGroup#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("An account group with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
   <cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   INSERT INTO Ref_AccountGroup
         (AccountGroup,
		 Description, 
		 Category, 
		 UserInterface,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.AccountGroup#', 
          '#Form.Description#',
		  'Manual',
		  '#Form.UserInterface#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
		  </cfif>
		  
		  
	<script language="JavaScript">
	   
	     opener.history.go()
		 window.close()
	        
	</script>  
          
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_AccountGroup
SET Description    = '#Form.Description#',
    UserInterface      = '#Form.UserInterface#',
	Created = #now()#
WHERE AccountGroup = '#Form.AccountGroup#'
</cfquery>

<script language="JavaScript">
	   
	     opener.history.go()
		 window.close()
	        
	</script>  

</cfif>	


