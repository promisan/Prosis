
<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PriceSchedule
		WHERE  Code  = '#Form.Code#'
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!")     
	   </script>  
  
   <cfelse>
   
   		<cftransaction>
			<cfif isDefined("Form.fieldDefault")>
				<cfquery name="update" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Ref_PriceSchedule
						SET	 fieldDefault = 0
				</cfquery>
			</cfif>
			
			<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO Ref_PriceSchedule
			          (Code,
					   Description,
					   <cfif trim(Form.Acronym) neq "">Acronym,</cfif>
					   ListingOrder,
					   fieldDefault,
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName)
			  VALUES  ('#Form.Code#',
			           '#Form.Description#', 
					   <cfif trim(Form.Acronym) neq "">'#Form.Acronym#',</cfif>
					   #Form.ListingOrder#,
					   <cfif isDefined("Form.fieldDefault")>1<cfelse>0</cfif>,
					   '#SESSION.acc#',
			    	   '#SESSION.last#',		  
				  	   '#SESSION.first#')
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
			                     action="Insert" 
								 datasource="AppsMaterials"
								 content="#form#">
		
		</cftransaction>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cftransaction>

		<cfif isDefined("Form.fieldDefault")>
			<cfquery name="update" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Ref_PriceSchedule
					SET	 fieldDefault = 0
			</cfquery>
		</cfif>
		
		<cfquery name="Update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_PriceSchedule
			SET   	Description  = '#Form.Description#',
					Acronym = <cfif trim(Form.Acronym) neq "">'#Form.Acronym#'<cfelse>null</cfif>,
					ListingOrder = #Form.ListingOrder#,
					FieldDefault = <cfif isDefined("Form.fieldDefault")>1<cfelse>0</cfif>
			WHERE Code         = '#Form.CodeOld#'
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Update" 
							 datasource="AppsMaterials"
							 content="#form#">
						 
	</cftransaction>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT PriceSchedule
      FROM   CustomerSchedule
      WHERE  PriceSchedule  = '#Form.codeOld#'
	  UNION
	  SELECT PriceSchedule
      FROM   ItemUoMPrice
      WHERE  PriceSchedule  = '#Form.codeOld#'
	  UNION
	  SELECT PriceSchedule
      FROM   WarehouseCategoryPriceSchedule
      WHERE  PriceSchedule  = '#Form.codeOld#'
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Price Schedule is in use. Operation aborted.")	        
	     </script>  
	 
    <cfelse>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
             action="Delete" 
			 content="#form#">
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_PriceSchedule
			WHERE CODE = '#FORM.codeOld#'
	    </cfquery>
	
	</cfif>	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
