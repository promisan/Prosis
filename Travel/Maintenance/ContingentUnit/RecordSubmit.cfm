
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 

<cf_preventCache>

<!--- Submit form called for INSERT (ADD) action --->
<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsTravel" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM ContingentUnit
	WHERE Id  = '#Form.UnitId#' 
	</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
		 alert("A record for this unit exists!  Duplicate entry not allowed.")
		 
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsTravel" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ContingentUnit
				 (Id,
				  Name,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName,	
				  Created)
		  VALUES ('#Form.UnitId#',
				  '#Form.UnitName#',
				  '#SESSION.acc#',
				  '#SESSION.last#',		  
				  '#SESSION.first#',
				  getDate())
		</cfquery>
		  
    </cfif>		  
           
</cfif>

<!--- Submit form called for UPDATE (EDIT) action --->
<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsTravel" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ContingentUnit
	SET Name = '#Form.UnitName#'
	WHERE Id = '#Form.UnitId#'
	</cfquery>

</cfif>	

<!--- Submit form called for DELETE action --->
<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
     datasource="AppsTravel" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      SELECT *
      FROM Contingent
      WHERE ContingentUnit_Id  = '#Form.UnitId#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
	     <script language="JavaScript">    
		   alert("This unit is in use in the Contingents table. This unit code cannot be deleted.")     
	     </script>  
	 
    <cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsTravel" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ContingentUnit
		WHERE Id = '#FORM.UnitId#'
		</cfquery>
	
	</cfif>	
	
</cfif>	

<!--- refresh contents of the unit codes list --->
<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>