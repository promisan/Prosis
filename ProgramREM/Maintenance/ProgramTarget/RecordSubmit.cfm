
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_TargetClass
WHERE 
Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Code" 
ActionType="Enter" 
ActionReference="#Form.code#" 
ActionScript="">   

<cfquery name="Insert" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_TargetClass
         (code,
		 Description,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#',
          '#Form.Description#', 
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Code" 
ActionType="Update" 
ActionReference="#Form.Code#" 
ActionScript="">   

<cfquery name="Update" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_TargetClass
SET 
    Code           = '#Form.code#',
    Description    = '#Form.Description#'
WHERE code         = '#Form.CodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT TargetClass
      FROM ProgramTarget
      WHERE TargetClass  = '#Form.codeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Target Class is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
	
	<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="code" 
ActionType="Remove" 
ActionReference="#Form.codeOld#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_TargetClass
WHERE code = '#FORM.codeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
