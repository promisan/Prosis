
<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_GradeDeployment
	WHERE GradeDeployment  = '#Form.GradeDeployment#' 
</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
      
<cfquery name="Insert" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_GradeDeployment
         (GradeDeployment,
		 Description, 
		 PostGradeBudget,
		 PostGradeParent,
		 ListingOrder,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.GradeDeployment#', 
          '#Form.Description#',
		  '#Form.PostGradeBudget#',
		  '#Form.PostGradeParent#',
		  '#Form.ListingOrder#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_GradeDeployment
	SET    Description      = '#Form.Description#', 
	       PostGradeBudget = '#form.PostGradeBudget#', 
		   ListingOrder    = '#Form.ListingOrder#',
		   PostGradeParent = '#Form.PostGradeParent#'
	WHERE GradeDeployment   = '#Form.GradeDeployment#'
	</cfquery>

</cfif>

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    GradeDeployment
     FROM      ApplicantDeploymentLevel
     WHERE     GradeDeployment  = '#Form.GradeDeployment#'
	 UNION
	 SELECT   GradeDeployment
	 FROM     FunctionOrganization
	 WHERE     GradeDeployment  = '#Form.GradeDeployment#'
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("GradeDeployment is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
		
	<cfquery name="Delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_GradeDeployment
	WHERE GradeDeployment  = '#Form.GradeDeployment#'
	    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
	
