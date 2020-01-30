
<cfif ParameterExists(Form.Save)> 

	<cfquery name="Verify" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_Request
			WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
		 history.back()
	     
	   </script>  
  
   <cfelse>
   
   		<cfset errorMessage = "">
	
		<cfif trim(Form.TemplateApply) neq "" and form.validateTemplate eq "0">
			<cfset errorMessage = errorMessage & "Template path does not exist.\n">
		</cfif>
		
		<cfif errorMessage neq "">
			
			<cfoutput>
				<script language="JavaScript">alert('#errorMessage#'); history.back();</script>
			</cfoutput>
		
		<cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Request
		         (Code,
				 Description,
				 TemplateApply,
				 ListingOrder,
				 StockOrderMode,
				 ForceProgram,
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#',
		  		  '#Form.Description#',
				  '#Form.TemplateApply#',
				  #Form.ListingOrder#,
				  #Form.StockOrderMode#,
				  #Form.ForceProgram#,
				  #Form.Operational#,
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		 action="Insert"
		 content="#form#">			
		
		<cfoutput>
			<script language="JavaScript">

				 window.location = "RecordEdit.cfm?id1=#form.code#&idmenu=#url.idmenu#";
				 opener.location.reload();
		        
			</script>
		</cfoutput>
		
		</cfif>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT TOP 1 RequestType
     	FROM  	RequestHeader
      	WHERE 	RequestType = '#FORM.CodeOld#'		
    </cfquery>
	
	<cfset errorMessage = "">
	
	<cfif trim(Form.TemplateApply) neq "" and Form.validateTemplate eq "0">
		<cfset errorMessage = errorMessage & "Template path does not exist.\n">
	</cfif>
	
	<cfif errorMessage neq "">
		
		<cfoutput>
			<script language="JavaScript">alert('#errorMessage#');  history.back();</script>
		</cfoutput>
	
	<cfelse>

		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_Request
			SET    <cfif CountRec.recordCount eq 0>Code = '#Form.Code#',</cfif>
				   Description     = '#Form.Description#',
				   TemplateApply   = '#Form.TemplateApply#',
				   StockOrderMode  = #Form.StockOrderMode#,
				   ListingOrder    = #Form.ListingOrder#,
				   ForceProgram    = #Form.ForceProgram#,
				   Operational     = #Form.Operational#
			WHERE  Code            = '#Form.CodeOld#'
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		 action="Update"
		 content="#form#">			
		
		<script language="JavaScript">
   
		     parent.window.close()
			 opener.location.reload()
		        
		</script> 
	
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT TOP 1 RequestType
     	FROM  	RequestHeader
      	WHERE 	RequestType = '#FORM.CodeOld#' 		
    </cfquery>
	
    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Request type is in use. Operation aborted.")     
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Request
			WHERE Code = '#FORM.CodeOld#'
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		 action="Delete"
		 content="#form#">			
		
		<script language="JavaScript">
   
		     parent.window.close()
			 opener.location.reload()
		        
		</script> 
	
	</cfif>	
	
</cfif> 
