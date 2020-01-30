
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_PostType
WHERE 
PostType  = '#Form.PostType#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
  
<cfquery name="Insert" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_PostType
         (PostType,
		 Description,
		 EnablePAS, 
		 Procurement,
		 EnableAssignmentReview,
		 EnableWorkflow,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.PostType#',
          '#Form.Description#', 
		  '#Form.EnablePAS#',
		  '#Form.EnableProcurement#',
		  '#Form.EnableAssignmentReview#',
		  '#Form.EnableWorkflow#',
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
	UPDATE Ref_PostType
	SET    PostType               = '#Form.PostType#',
	       Description            = '#Form.Description#',
		   Procurement            = '#form.EnableProcurement#',
		   EnableAssignmentReview = '#Form.EnableAssignmentReview#',
		   EnableWorkflow         = '#Form.EnableWorkflow#',
		   EnablePAS              = '#Form.EnablePAS#'
	WHERE  PostType               = '#Form.PostTypeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT Posttype
      FROM   Position
      WHERE  PostType  = '#Form.PostTypeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Post type is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
	
	<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="PostType" 
ActionType="Remove" 
ActionReference="#Form.PostTypeOld#" 
ActionScript="">   
		
	<cfquery name="Delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_PostType
	WHERE PostType = '#FORM.PostTypeOld#'
	    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
