
<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Frequency
	WHERE  Code  = '#Form.code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
	 history.back()
     
   </script>  
  
   <cfelse>
	   
	<cfquery name="Insert" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_Frequency
	    	     (Code,Description)
		VALUES ('#Form.Code#','#Form.Description#')
	</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>	

	<cfparam name="Form.Code" default="#Form.CodeOld#">

	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Frequency
	SET    Code        = '#Form.Code#', 
		   Description = '#Form.Description#'    
	WHERE  Code        = '#Form.CodeOld#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
			
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_Frequency
		WHERE Code = '#FORM.Code#'
	</cfquery>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
