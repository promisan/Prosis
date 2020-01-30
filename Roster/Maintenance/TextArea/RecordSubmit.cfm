
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_TextArea
WHERE Code  = '#Form.Code#' 
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
			INSERT INTO Ref_TextArea
		         (Code,
				 TextAreaDomain,
				 Description,
				 Explanation,
				 ListingOrder,
				 NoRows,
				 EntryMode,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
			  VALUES ('#Form.Code#',
		          '#Form.TextAreaDomain#',
		          '#Form.Description#',
				  '#Form.Explanation#',
				  '#Form.ListingOrder#',
				  '#Form.NoRows#',
				  '#Form.EntryMode#',
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
	UPDATE Ref_TextArea
	SET  Code            =  '#Form.Code#',
	     Description     =  '#Form.Description#',
		 TextAreaDomain  =  '#Form.TextAreaDomain#',
		 EntryMode       =  '#Form.EntryMode#',
		 Explanation     =  '#Form.Explanation#',
		 ListingOrder    =  '#Form.ListingOrder#',
		 NoRows          =  '#Form.NoRows#'
	WHERE Code     = '#Form.CodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT TextAreaCode
      FROM  ApplicantInterviewNotes
      WHERE TextAreaCode  = '#Form.CodeOld#' 
	  UNION
	  SELECT TextAreaCode
	  FROM FunctionOrganizationNotes
	  WHERE TextAreaCode = '#Form.CodeOld#'
	   </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Text area topic is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_TextArea
	WHERE Code = '#FORM.CodeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
