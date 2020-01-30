
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Operational" default="0">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_PostClass
WHERE 
PostClass  = '#Form.PostClass#' 
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
	INSERT INTO Ref_PostClass
	         (PostClass,
			 Description,
			 PostClassGroup,
			 PresentationColor,
			 ListingOrder,
			 AccessLevel,
			 Operational,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.PostClass#',
	          '#Form.Description#', 
	          '#Form.PostClassGroup#', 
	          '#Form.PresentationColor#', 
	          '#Form.ListingOrder#', 
			  '#Form.AccessLevel#',
			  '#Form.Operational#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_PostClass
SET 
    PostClass   = '#Form.PostClass#',
    Description = '#Form.Description#',
	PostClassGroup = '#Form.PostClassGroup#',
	PresentationColor = '#Form.PresentationColor#',
	ListingOrder = '#Form.ListingOrder#',
	AccessLevel  = '#Form.AccessLevel#',
	Operational  = '#Form.Operational#'
WHERE PostClass  = '#Form.PostClassOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT PostClass
      FROM Position
      WHERE PostClass  = '#Form.PostClassold#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Post Class is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_PostClass
		WHERE PostClass = '#FORM.PostClassOld#'
    </cfquery>
	
	</cfif>
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
