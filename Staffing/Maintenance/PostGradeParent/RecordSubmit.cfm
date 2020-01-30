
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_PostGradeParent
WHERE 
Code  = '#Form.Code#' 
or 
ViewOrder = '#Form.ViewOrder#'
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A parent postgrade with this code or order has been registered already!")
     
   </script>  
  
   <cfelse>
   
<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Post grade parent" 
ActionType="Enter" 
ActionReference="#Form.Code#" 
ActionScript="">   

<cfquery name="Insert" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_PostGradeParent
         (Code,
		 Description,
		 Posttype,
		 ViewOrder,
		 ViewTotal,
		 Category,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.Code#',
		  '#Form.Description#',
		  '#Form.PostType#',
		  '#Form.ViewOrder#',
		  '#Form.ViewTotal#',
		  '#Form.Category#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="Postgrade Parent" 
ActionType="Update" 
ActionReference="#Form.Code#" 
ActionScript="">   

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_PostgradeParent
SET 
   Code		   		  = '#Form.Code#',
   Description		  = '#Form.Description#',
   PostType           = '#Form.PostType#',
   Category           = '#Form.Category#',
   ViewOrder          = '#Form.ViewOrder#',
   ViewTotal          = '#Form.ViewTotal#'
WHERE Code = '#Form.CodeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT PostGradeParent
      FROM  Ref_PostGrade
      WHERE PostGradeParent  = '#Form.CodeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Post grade is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
	
	<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="PostGrade Parent" 
ActionType="Remove" 
ActionReference="#Form.CodeOld#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_PostGradeParent
WHERE Code = '#FORM.CodeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
