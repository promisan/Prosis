

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM FlowClass
WHERE ActionClass   = '#Form.ActionClass#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
   
<CF_RegisterAction 
SystemFunctionId="0399" 
ActionClass="Competence" 
ActionType="Enter" 
ActionReference="#Form.ActionClass#" 
ActionScript="">      
   
<cfquery name="Insert" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO FlowClass
         (ActionClass,
		 Description, 
		 ListingOrder,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.ActionClass#', 
          '#Form.Description#',
		  '#Form.ListingOrder#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

<CF_RegisterAction 
SystemFunctionId="0399" 
ActionClass="Competence" 
ActionType="Update" 
ActionReference="#Form.ActionClass#" 
ActionScript="">       

<cfquery name="Update" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE FlowClass
SET Description      = '#Form.Description#', 
    ListingOrder     = '#Form.ListingOrder#' 
WHERE ActionClass   = '#Form.ActionClass#'
</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    ActionClass
     FROM      ApplicantCompetence
     WHERE     CompetenceId  = '#Form.CompetenceId#'
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Id is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>

 <CF_RegisterAction 
SystemFunctionId="0399" 
ActionClass="Competence" 
ActionType="Remove" 
ActionReference="#Form.CompetenceId#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_Competence WHERE CompetenceId   = '#Form.CompetenceId#'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
	
