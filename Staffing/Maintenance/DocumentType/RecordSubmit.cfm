
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_DocumentType
WHERE 
DocumentType  = '#Form.DocumentType#' 
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
INSERT INTO Ref_DocumentType
         (DocumentType,
		 Description,
		 EnableRemove,
		 EnableEdit,
		 VerifyDocumentNo,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.DocumentType#',
          '#Form.Description#', 
		  '#Form.EnableRemove#',
		  '#Form.EnableEdit#',
		  '#Form.VerifyDocumentNo#',
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
UPDATE Ref_DocumentType
SET   DocumentType     = '#Form.DocumentType#',
      Description      = '#Form.Description#',
	  VerifyDocumentNo = '#form.VerifyDocumentNo#',
	  EnableRemove     = '#Form.EnableRemove#',
	  EnableEdit       = '#Form.EnableEdit#'
WHERE DocumentType     = '#Form.DocumentTypeOld#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DocumentType
      FROM  PersonDocument
      WHERE DocumentType  = '#Form.DocumentTypeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Document Type is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_DocumentType
WHERE DocumentType = '#FORM.DocumentTypeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
