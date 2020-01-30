
<cfset dateValue = "">
<cf_DateConvert Value="#Form.TransactionLotDate#">
<cfset vDateEffective = dateValue>


<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	ProductionLot
		WHERE  	Mission = '#Form.Mission#'
		AND		TransactionLot  = '#Form.TransactionLot#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this lot has been registered already in this mission!")     
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  INSERT INTO ProductionLot
		          (
				  	Mission,
					TransactionLot,
					TransactionLotDate,
					OrgUnitVendor,
					<cfif trim(Form.Reference) neq "">Reference,</cfif>
				   	<cfif trim(Form.Memo) neq "">Memo,</cfif>
				   	OfficerUserId,
				   	OfficerLastName,
				   	OfficerFirstName
				   )
		  VALUES  (
		  			'#Form.Mission#',
		           	'#Form.TransactionLot#', 
					#vDateEffective#,
				 	'#Form.referenceorgunit#', 	
					<cfif trim(Form.Reference) neq "">'#Form.Reference#',</cfif>
					<cfif trim(Form.Memo) neq "">'#Form.Memo#',</cfif>	
				   	'#SESSION.acc#',
		    	   	'#SESSION.last#',		  
			  	   	'#SESSION.first#'
				   )
		</cfquery>
		 
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#form#">
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ProductionLot
		SET   	TransactionLotDate       = #vDateEffective#,
		      	OrgUnitVendor  			= '#Form.referenceorgunit#',
				Reference				= <cfif trim(Form.Reference) neq "">'#Form.Reference#'<cfelse>null</cfif>,
				Memo					= <cfif trim(Form.Memo) neq "">'#Form.Memo#'<cfelse>null</cfif>
		WHERE  	Mission 		= '#Form.Mission#'
		AND		TransactionLot  = '#Form.TransactionLot#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT 	*
      FROM   	ItemTransaction
      WHERE  	Mission 		= '#Form.Mission#'
	  AND		TransactionLot  = '#Form.TransactionLot#'
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Lot is in use. Operation aborted.")	        
	     </script>  
	 
    <cfelse>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
             action="Delete" 
			 content="#form#">
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM 	ProductionLot
			WHERE  	Mission 		= '#Form.Mission#'
			AND		TransactionLot  = '#Form.TransactionLot#'
	    </cfquery>
	
	</cfif>	
	
</cfif>	

<script language="JavaScript">
   
     parent.window.close()
	 opener.location.reload()
        
</script>  
