

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Incident
WHERE Code  = '#Form.Code#'
and class='Circumstance' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   <cfoutput>
   <cf_tl id = "An record with this code has been registered already!" class = "Message" var = "1">
   
   <script language="JavaScript">
   
     alert("#lt_text#")
     
   </script>  
  </cfoutput>
  
   <CFELSE>
   
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Ref_Incident" 
ActionType="Enter" 
ActionReference="#Form.code#" 
ActionScript="">      
   
<cfquery name="Insert" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Incident
         (Class,
		 Code,
		 Description, 
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('Circumstance',
  		  '#Form.Code#', 
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
ActionClass="Ref_Incident" 
ActionType="Update" 
ActionReference="#Form.code#" 
ActionScript="">       

<cfquery name="Update" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_Incident
SET Description  = '#Form.Description#',
Code='#Form.Code#'
WHERE Code = '#Form.CodeOld#'
and class='Circumstance'
</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     ClaimIncident
     WHERE    Circumstance = '#Form.Code#' 
	 </cfquery>
	
    <cfif #CountRec.recordCount# gt 0 >

   <cfoutput>
   <cf_tl id = "Circumstance is in use. Operation aborted." class = "Message" var = "1">		 
     <script language="JavaScript">
    
	   alert(" #lt_text#")
     
     </script>  
	</cfoutput> 
	 	 
    <cfelse>
	
	

 <CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Ref_Incident" 
ActionType="Remove" 
ActionReference="#Form.code#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_Incident
WHERE Code   = '#Form.code#'
and class='Circumstance'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  