
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ContractType
WHERE 
ContractType  = '#Form.ContractType#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
		 
		<cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ContractType
		         (ContractType,
				 Description,
				 EntityClass,
				 AppointmentType,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.ContractType#',
		          '#Form.Description#', 
				  '#Form.Workflow#',
				  '#Form.AppointmentType#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>
		
		<cfinclude template="RecordSubmitMission.cfm">
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_ContractType
		SET    ContractType    = '#Form.ContractType#',
		       Description    = '#Form.Description#',
			   AppointmentType = '#Form.AppointmentType#',
			   <cfif form.Workflow neq "">
				EntityClass    = '#Form.Workflow#'
			   <cfelse>
			    EntityClass    = NULL  
			   </cfif>	
		WHERE  ContractType = '#Form.ContractTypeOld#'
	</cfquery>

	<cfinclude template="RecordSubmitMission.cfm">

</cfif>	

<cfif ParameterExists(Form.Delete)> 
	
	 <cfquery name="CountRec" 
	      datasource="AppsEmployee" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT ContractType
	      FROM   PersonContract
	      WHERE  ContractType  = '#Form.ContractTypeOld#' 
	 </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Contract Type is in use. Operation aborted.")     
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ContractType
			WHERE ContractType = '#FORM.ContractTypeOld#'
		</cfquery>
	
	</cfif>	
	
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  
