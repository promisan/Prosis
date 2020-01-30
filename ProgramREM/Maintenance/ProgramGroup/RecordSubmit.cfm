
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM   Ref_ProgramGroup
	WHERE Code  = '#Form.Code#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
		   
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ProgramGroup
		         (code,
				 Description,
				 Mission,
				 Period,
				 ListingOrder,
				 ViewColor,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		    VALUES ('#Form.Code#',
		          '#Form.Description#', 
				  <cfif Form.Mission eq "0">null,<cfelse>'#Form.Mission#',</cfif>
				  <cfif Form.Period eq "0">null,<cfelse>'#Form.Period#',</cfif>
				  '#Form.ListingOrder#',
				  '#Form.ViewColor#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ProgramGroup
	SET Code           = '#Form.code#',
	    Description    = '#Form.Description#',
		ListingOrder   = '#Form.ListingOrder#', 
		Mission        = <cfif Form.Mission eq "0">null,<cfelse>'#Form.Mission#',</cfif>
		Period         = <cfif Form.Period eq "0">null,<cfelse>'#Form.Period#',</cfif>
		ViewColor      = '#Form.ViewColor#'
WHERE code         = '#Form.CodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT ProgramGroup
      FROM   ProgramGroup
      WHERE  ProgramGroup  = '#Form.codeOld#' 
    </cfquery>

    <cfif  CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    	   alert("Code is in use. Operation aborted.")	        
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_ProgramGroup
		WHERE Code = '#FORM.codeOld#'
	    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
