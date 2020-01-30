

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Status
WHERE Status = '#Form.Status#' 
AND StatusClass = '#Form.StatusClass#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   <cfoutput>
   <cf_tl id = "An record with this code has been registered already!" var = "1">
   <script language="JavaScript">
   
     alert("#lt_text#")
     
   </script> 
   </cfoutput> 
  
   <CFELSE>
   
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Ref_Status" 
ActionType="Enter" 
ActionReference="#Form.Status#" 
ActionScript="">      
   
<cfquery name="Insert" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Status
         (StatusClass,
		 Status,
		 Description, 
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.StatusClass#', 
		  '#Form.Status#', 
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
ActionClass="Ref_Status" 
ActionType="Update" 
ActionReference="#Form.Status#" 
ActionScript="">       

<cfquery name="Update" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_Status
SET 
StatusClass  = '#Form.StatusClass#',
Description  = '#Form.Description#',
Status       = '#Form.Status#'
WHERE Status = '#Form.StatusOld#'
AND StatusClass = '#Form.StatusClassOld#'
</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
    datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
	 FROM 
	 <cfif Form.StatusClassOld eq "clm">
	     Claim 
	 <cfelseif Form.StatusClassOld eq "lne">
	 	 ClaimLine
	 </cfif>
     WHERE    ActionStatus = '#Form.Status#' 
	 </cfquery>
	
    <cfif #CountRec.recordCount# gt 0 >

   <cfoutput>
	<cf_tl id = "Status is in use. Operation aborted." var = "1">		 
     <script language="JavaScript">
    
	   alert(" #lt_text#")
     
     </script>  
	</cfoutput> 
	 	 
    <cfelse>
	
	

		 <CF_RegisterAction 
		SystemFunctionId="0999" 
		ActionClass="Ref_Status" 
		ActionType="Remove" 
		ActionReference="#Form.Status#" 
		ActionScript="">   
		
		<cfquery name="Delete" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Status
			WHERE StatusClass = '#Form.StatusClassOld#'
			AND Status = '#Form.StatusOld#'
	    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  