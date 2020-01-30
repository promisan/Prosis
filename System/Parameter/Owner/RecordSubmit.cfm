
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AuthorizationRoleOwner
WHERE 
Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
 
<cfquery name="Insert" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_AuthorizationRoleOwner
         (Code,
		 Description,
		 eMailAddress,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#',
          '#Form.Description#', 
		  '#Form.eMailAddress#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE 	Ref_AuthorizationRoleOwner
	SET 	eMailAddress  = '#Form.eMailAddress#',
	    	Description   = '#Form.Description#'
	WHERE 	Code          = '#Form.Code#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
    	  SELECT RoleOwner
	      FROM Ref_AuthorizationRole
	      WHERE RoleOwner  = '#Form.Code#' 
	  UNION
		  SELECT RoleOwner
	      FROM System.dbo.Ref_SystemModule
    	  WHERE RoleOwner  = '#Form.Code#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Owner is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
		
	<cfquery name="Delete" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM Ref_AuthorizationRoleOwner
	WHERE Code = '#FORM.Code#'
    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
