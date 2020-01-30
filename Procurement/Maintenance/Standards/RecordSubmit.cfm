
<cfif Len(Form.Memo) gt 200>
     <cfset Form.Memo = left(Form.Memo,200)>	
</cfif>

<cfif ParameterExists(Form.Insert)> 
	
		<cfquery name="Verify" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_Standard
			WHERE Code  = '#Form.Code#' 
		</cfquery>
	
	    <cfif Verify.recordCount is 1>
	   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
	   <cfelse>
   
	<CF_DateConvert Value="#DateFormat(Form.DateExpiration, '#CLIENT.DateFormatShow#')#">
    <cfset DExpiration= dateValue>   

	    
	<cfquery name="Insert" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Standard
	         (Code,
			 Description, 
			 Memo,
			 Reference,
			 DateExpiration,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	  VALUES ('#Form.Code#', 
	          '#Form.Description#',
			  '#Form.Memo#',
			  '#Form.Reference#',
			   #DExpiration#,
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	  </cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

	<CF_DateConvert Value="#DateFormat(Form.DateExpiration, '#CLIENT.DateFormatShow#')#">
    <cfset DExpiration= dateValue>   

	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Standard
	SET 	Code              = '#Form.Code#',
			Description       = '#Form.Description#',
			Memo			  = '#Form.Memo#',
			Reference		  = '#Form.Reference#',	   
			Operational       = '#Form.Operational#',   
			DateExpiration	  = #DExpiration#	      		  
	WHERE Code = '#Form.CodeOld#' 
	</cfquery>
	
</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     ItemMasterStandard
     WHERE    StandardCode = '#Form.Code#' 
	 </cfquery>
	 

    <cfquery name="CountRec2" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     RequisitionLine
     WHERE    StandardCode = '#Form.Code#' 
	 </cfquery>	 
	 
	
    <cfif CountRec.recordCount gt 0 or CountRec2.recordCount gt 0 >
		 
     <script language="JavaScript">
    
	   alert("Standard Code is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_Standard
			WHERE Code   = '#Form.code#'
	    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  