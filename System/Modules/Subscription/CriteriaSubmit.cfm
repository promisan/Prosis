
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_preventCache>

<cfif ParameterExists(Form.Update)> 

<cfquery name="Verify" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_ReportControlCriteria 
WHERE   ControlId = '#Form.ControlId#'
  AND   CriteriaName = '#Form.CriteriaNameOld#'
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ReportControlCriteria 
	SET    CriteriaName      = '#Form.CriteriaName#',
	       CriteriaDescription = '#Form.CriteriaDescription#',
	       CriteriaType = '#Form.CriteriaType#',
		   CriteriaValues = '#Form.CriteriaValues#',
		   CriteriaDefault = '#Form.CriteriaDefault#',
		   LookupMultiple  = '#Form.LookupMultiple#',
		   LookupFieldValue  = '#Form.LookupFieldValue#',
		   LookupFieldDisplay = '#Form.LookupFieldDisplay#',
		   CriteriaWidth   = '#Form.CriteriaWidth#',
		   CriteriaOrder = '#Form.CriteriaOrder#'
	WHERE  ControlId = '#Form.ControlId#'
	  AND  CriteriaName = '#Form.CriteriaNameOld#'	    
   </cfquery>
  
   <cfelse>
   
	<cfquery name="Insert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ReportControlCriteria 
	         (ControlId,
			 CriteriaName,
			 CriteriaDescription,
			 CriteriaType,
			 CriteriaValues,
			 CriteriaDefault,
			 LookupMultiple,
			 LookupFieldValue,
			 LookupFieldValue,
			 CriteriaWidth,
			 CriteriaOrder,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	  VALUES ('#Form.ControlId#',
	          '#Form.CriteriaName#',
			  '#Form.CriteriaDescription#',
			  '#Form.CriteriaType#',
			  '#Form.CriteriaValues#',
			  '#Form.CriteriaDefault#', 
			  '#Form.LookupMultiple#',
			  '#Form.LookupFieldValue#',
			  '#Form.LookupFieldDisplay#',
			  '#Form.CriteriaWidth#',
			  '#Form.CriteriaOrder#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())</cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsSystem" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      DELETE 
      FROM Ref_ReportControlCriteria 
      WHERE  ControlId = '#Form.ControlId#'
	  AND  CriteriaName = '#Form.CriteriaNameOld#'	   
    </cfquery>
    	
	</cfif>
	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
