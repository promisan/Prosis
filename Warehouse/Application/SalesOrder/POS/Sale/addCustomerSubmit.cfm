<cfparam name="Form.Reference" default="">

<cfif Len(Form.Name) lt 2>
	 <cf_tl id="You have not entered a valid Name" var="1" class="message">
	 
	 <cf_alert message = "#lt_text#">
	 <cfabort>
</cfif>

<cfif Len(Form.Memo) gt 200>
	 <cf_tl id="You entered remarks that exceeded the allowed size of 200 characters." var="1" class="message">
	 
	 <cf_alert message = "#lt_text#">
	 <cfabort>
</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DOB#">
<cfset DOB = dateValue>

<cf_assignid>

<!--- verify is person record exist --->

<cfquery name="Parameter" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT CustomerDefaultReference
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.mission#'
</cfquery>

<cfset val = evaluate("Form.TaxCodeTax")>
 
<cfif val neq "">
	
	<cfquery name="check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer C
		WHERE  Mission = '#url.mission#'			
		AND CustomerId IN (SELECT CustomerId FROM CustomerTaxCode WHERE CustomerId = C.CustomerId 
		                                                          AND   source = 'Tax' 
																  AND   TaxCode = '#val#')
	</cfquery>

<cfelse>
	
	<cfquery name="check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer C
		WHERE  Mission = '#url.mission#'			
		AND    CustomerName = '#Form.Name#'
		AND    Reference = '#Parameter.CustomerDefaultReference#'
	</cfquery>

</cfif>

<!--- superseded 

<cfquery name="check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Customer
	WHERE   1=0
	<cfif Form.Reference neq Parameter.CustomerDefaultReference>
	OR 
	(
		(Reference = '#Form.Reference#' 
			AND Reference is NOT NULL 
			AND Reference != '' 
			AND Reference != '#Parameter.CustomerDefaultReference#')
			AND Mission = '#url.mission#'			
	)		
	<cfelseif Form.Reference eq Parameter.CustomerDefaultReference>
	OR 
	(
		(Reference = '#Form.Reference#' AND CustomerName = '#Form.Name#') AND Mission = '#url.mission#'			
	)		
	</cfif>
</cfquery>

--->

<cfparam name="check.RecordCount" default="0">
<cfparam name="url.force" default="0">

<cfif Check.recordCount gt 0 and url.force eq "0">  

	<cfoutput>
		<cf_tl id ="Already exists" var ="1" class="message">	
		<script>
			alert("#lt_text#")
		</script>
	</cfoutput>
	<cfabort>

<CFELSE>
	 
	   <cftransaction> 
	   
	   <cfset val = evaluate("Form.TaxCodeTax")>
	  	    
	   <cfquery name="InsertCustomer" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     INSERT INTO Customer
		        (CustomerId,
				 Mission,
				 CustomerName,
				 Reference,
				 CustomerDOB,
				 PhoneNumber,
				 MobileNumber,
				 PostalCode,
				 eMailAddress, 
				 TaxExemption,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Memo)
		      VALUES ('#rowguid#',
		            '#url.mission#',
				    '#Form.Name#',
				    <cfif val eq "">
					  '#Parameter.CustomerDefaultReference#',
				    <cfelse>
					  '#val#',
				    </cfif>				     
				     #DOB#,
				    '#Form.PhoneNumber#',
				    '#Form.MobileNumber#',
				    '#Form.PostalCode#',
				    '#Form.eMailAddress#',		
				    '#Form.TaxExemption#',				  	 			 
				    '#SESSION.acc#',
		    	    '#SESSION.last#',		  
			  	    '#SESSION.first#',
				    '#Form.Memo#')				  
	       </cfquery>	
			
			<!--- add Taxcode --->
			
			<cfloop index="itm" list="Tax,Civilian">
			
			    <cfset val = evaluate("Form.TaxCode#itm#")>
												
				<cfif val neq "">
				
				     <cfif itm eq "Tax">
					 
						<cfinvoke component  = "Service.Process.EDI.Manager"  
							method           = "CustomerValidate" 
							Mission          = "#url.Mission#"
							Reference		 = "#val#"	
							CustomerName 	 = "#Form.Name#"
							returnvariable	 = "stResponse">		
						   
						 <cfif stResponse.status neq "OK">
						 
						    <cfoutput>
							 	<script>
									alert("#stResponse.status#")
								</script>
							</cfoutput>
							<cfabort>
							
						 </cfif>
	 
	                 </cfif>	
					 			
					<cfquery name="InsertCustomer" 
				     datasource="AppsMaterials" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">		
					  
					 INSERT INTO CustomerTaxCode
				        (CustomerId,
						 Country,
						 Source,
						 TaxCode,					 
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				      VALUES ('#rowguid#',
				          'GT', <!--- hardcoded --->
						  '#itm#',
						  '#val#',					 	  	 			 
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')				  
			        </cfquery>	
				
				</cfif>
			 
			 </cfloop>		
			 
			 </cftransaction>			
		
	<cfoutput>
	
	<cfinvoke component = "Service.Process.Materials.Customer"  
	   method           = "AddCustomerAddress" 
	   mission			= "#url.mission#"
	   warehouse        = "#url.warehouse#"
  	   customerId	    = "#rowguid#">	
	
		<script language="JavaScript">
		
			<cfif url.mode eq "customer">
						  
			 parent.document.getElementById('customeridselect').value = '#rowguid#'		 
	         parent.ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applyCustomer.cfm?mission=#url.mission#&warehouse=#url.warehouse#&customerid=#rowguid#','customerbox')					   	 
			 try { parent.ProsisUI.closeWindow('customeradd',true)} catch(e){};	
			 parent.document.getElementById('customerselect').focus()				
			 
			<cfelse>
			
			 parent.document.getElementById('customerinvoiceidselect').value = '#rowguid#'		 
			 cId = parent.document.getElementById('customeridselect');
			 
			 if (cId){
			 
				     parent.ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=billing&warehouse=#url.warehouse#&customerid='+cId.value+'&customeridinvoice=#rowguid#','salelines')					   	 
					 try { parent.ProsisUI.closeWindow('customeradd',true)} catch(e){};
					 parent.document.getElementById('customerinvoiceselect').focus()			
			 }
			
			</cfif>
		 	 
		</script>
	
	</cfoutput>
		
</cfif>	

