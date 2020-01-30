
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ApplicantClass
	WHERE ApplicantClassId  = '#Form.ApplicantClassId#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("a record with this code has been registered already!")
	     
	   </script>  
	  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ApplicantClass (ApplicantClassId,Scope, Description)
			VALUES ('#Form.ApplicantClassId#','#Form.Scope#','#Form.Description#')
			
		</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ApplicantClass
	SET    ApplicantClassId = '#Form.ApplicantClassId#',
    	   Description      = '#Form.Description#',
		   Scope            = '#Form.Scope#'
	WHERE  ApplicantClassId = '#Form.ApplicantClassIdOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
     	 SELECT TOP 1 ApplicantClass
     	 FROM   Applicant
    	 WHERE  ApplicantClass  = '#Form.ApplicantClassIdOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert(" Class is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ApplicantClass
			WHERE  ApplicantClassId    = '#Form.ApplicantClassIdOld#'
	    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
