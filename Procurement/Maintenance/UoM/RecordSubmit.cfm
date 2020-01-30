

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_UoM
			WHERE Code  = '#Form.Code#' 
	</cfquery>
	
	<cfif #Verify.recordCount# is 1>
	   
	   <script language="JavaScript">
	   
	     alert("An record with this code has been registered already!")
	     
	   </script>  
	  
	<cfelse>
	
		<cftransaction>
	
			<cfif isDefined("Form.fieldDefault")>
				<cfquery name="update" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Ref_UoM
						SET	 fieldDefault = 0
				</cfquery>
			</cfif>
		      
			<cfquery name="Insert" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_UoM
					         (Code,
							 Description, 
							 fieldDefault,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					  VALUES ('#Form.Code#', 
					          '#Form.Description#',
							  <cfif isDefined("Form.fieldDefault")>1<cfelse>0</cfif>,
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
			</cfquery>
		
		</cftransaction>

	</cfif>

</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfif isDefined("Form.fieldDefault")>
		<cfquery name="update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_UoM
				SET	 fieldDefault = 0
		</cfquery>
	</cfif>

	<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_UoM
			SET Description  = '#Form.Description#',
			Code='#Form.Code#',
			FieldDefault = <cfif isDefined("Form.fieldDefault")>1<cfelse>0</cfif>
			WHERE Code = '#Form.CodeOld#'
	</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT    *
		     FROM     RequisitionLineQuote
		     WHERE    QuotationUoM = '#Form.Code#' 
    </cfquery>
	
	<cfquery name="CountRec1" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	SELECT    *
	    	 FROM     RequisitionLineService
	    	 WHERE    UoM = '#Form.Code#' 
    </cfquery>
	
    <cfquery name="CountRec2" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT    *
		     FROM     RequisitionLine
		     WHERE    QuantityUoM = '#Form.Code#' 
    </cfquery>
	
    <cfquery name="CountRec3" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	SELECT    *
	     	FROM     PurchaseLine
	     	WHERE    OrderUoM = '#Form.Code#' 
    </cfquery>
	
	
    <cfif CountRec.recordCount gt 0 or 
	      CountRec1.recordCount gt 0 or 
	      CountRec2.recordCount gt 0 or 
		  CountRec3.recordCount gt 0 >
		 
	     <script language="JavaScript">
	    
		   alert(" Unit of Measure is in use. Operation aborted.")
	     
	     </script>  
	 	 
    <cfelse>
	
		<cfquery name="Delete" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Ref_UoM
				WHERE Code   = '#Form.code#'
	    </cfquery>
		
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  