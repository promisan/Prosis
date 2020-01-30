
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfif Form.Source eq "Direct">
  <cfset sc = "Direct">
<cfelse>
  <cfset sc = "#Form.ReferenceNo#">
</cfif>    

<cfset dateValue = "">
<cfif Form.DateEffective neq ''>
    <CF_DateConvert Value="#Form.DateEffective#">
    <cfset STR = dateValue>
<cfelse>
    <cfset STR = 'NULL'>
</cfif>	

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfif ParameterExists(Form.Insert)> 

<cfset CLIENT.Filter = #Form.CurrentRow#>

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM  FunctionOrganization
  WHERE FunctionNo        = '#Form.FunctionNo#' 
  AND   GradeDeployment   = '#Form.GradeDeployment#'
  AND   SubmissionEdition = '#Form.SubmissionEdition#'
  AND   ReferenceNo       = '#sc#'
 
  <cfif Form.OrganizationCode neq "">
  AND OrganizationCode  = '#Form.OrganizationCode#'
  </cfif>
</cfquery>

   <cfif Verify.recordCount is 1>
   
     <cf_waitEnd Frm="result">	
  <cf_message message = "A roster bucket with these criteria has been registered already!"
  return = "back">
  <cfabort>
       
   <cfelse>
  		
		<!--- <cfset FunctionNo=Insert(LastNo.FunctionNumber, 0, 1)> --->
			
			<cfquery name="Insert" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO FunctionOrganization
			         (FunctionNo,
					 GradeDeployment,
					 <cfif #Form.OrganizationCode# neq "">
					 OrganizationCode,
					 </cfif>
					 SubmissionEdition,
					 ReferenceNo,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#Form.functionno#',
					  '#Form.GradeDeployment#',
					  <cfif #Form.OrganizationCode# neq "">
					  '#Form.OrganizationCode#',
					  </cfif>
					  '#Form.SubmissionEdition#',
					  '#sc#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
			</cfquery>
					
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE FunctionOrganization
	SET GradeDeployment     = '#Form.GradeDeployment#',
    	<cfif #Form.OrganizationCode# neq "">
		OrganizationCode    = '#Form.OrganizationCode#',
		<cfelse>
		OrganizationCode    = NULL,
		</cfif>
		SubmissionEdition   = '#Form.SubmissionEdition#',
		ReferenceNo         = '#sc#',
		DateEffective       = #STR#,
		DateExpiration      = #END#,
		PostSpecific        = '#Form.PostSpecific#'
	WHERE FunctionId  = '#Form.FunctionId#'
	</cfquery>

</cfif>
	
<!---To Delete entry from functionTitle - need to be work on--->
<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
	      datasource="AppsSelection" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT *
	      FROM ApplicantFunction
	      WHERE FunctionId  = '#Form.FunctionId#' 
	    </cfquery>
	
	    <cfif #CountRec.recordCount# gt 0>
			 
	     <script language="JavaScript">
	    
		   alert(" Bucket is in use. Operation aborted.")
	     
	     </script>  
		 
	    <cfelse>
				
		<cfquery name="Delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM FunctionOrganization
	WHERE FunctionId = '#FORM.FunctionId#'
	    </cfquery>
		
		</cfif>
		
</cfif>	

<!--- ajax needs to be reloaded --->

<cfoutput>
<script language="JavaScript">
      window.close()
	 opener.listing('#URL.ifrm#','show','#Form.FunctionNo#','#Form.GradeDeployment#')
        
</script> 
</cfoutput> 
