
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Operational" default="0">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AssignmentClass
	WHERE AssignmentClass  = '#Form.AssignmentClass#' 
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
INSERT INTO Ref_AssignmentClass
         (AssignmentClass,
		  Description,
		  Operational,
		  ListingOrder,
		  Incumbency,
		  OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.AssignmentClass#',
          '#Form.Description#',
		  '#Form.Operational#',
		  '#Form.ListingOrder#',
		  '#form.Incumbency#',
          '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_AssignmentClass
	SET    AssignmentClass  = '#Form.AssignmentClass#',
	       Description      = '#Form.Description#',
		   ListingOrder     = '#Form.Listingorder#',
		   Incumbency       = '#Form.Incumbency#',
		   Operational      = '#Form.Operational#' 
	WHERE  AssignmentClass  = '#Form.AssignmentClassOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT AssignmentClass
      FROM   PersonAssignment
      WHERE  AssignmentClass  = '#Form.AssignmentClassOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Assignment Class is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_AssignmentClass
		WHERE AssignmentClass = '#FORM.AssignmentClassOld#'
	</cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
