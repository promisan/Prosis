
<!--- steps

	1. Remove old System lines loop through lines 1 -14
	2. Insert Reqlines
	3. Insert Quotation lines
	
--->

<cfif form.ItemMaster eq "">
	 <cf_alert message = "You must select an request class">
	 <cfabort>
</cfif>

<cfquery name="funding" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT *
		FROM   RequisitionLineFunding 
		WHERE  RequisitionNo = '#URL.ID#'	
</cfquery>

<cfif funding.recordcount eq "0">
	 <cf_alert message = "You must enter a funding. Operation not allowed." return = "back">
	 <cfabort>
</cfif>

<cfoutput>

	<cfset cnt   = 0>
	<cfset rw    = "#Form.row#">
		
	<cfloop index="Rec" from="1" to="#rw#" step="1">
	
	  <cfparam name="FORM.requestdescription_#Rec#" default="">
	  <cfparam name="FORM.requestamountbase_#Rec#"  default="">
		
	  <cfset des      = Evaluate("FORM.requestdescription_" & #Rec#)>
	  <cfset amt      = Evaluate("FORM.requestamountbase_" & #Rec#)>
	  
	  <cfif amt neq "" and des neq "">
	  
	  	<cfif LsIsNumeric(amt)>	    
			
			  <cfset cnt = cnt +1>
			 
		<cfelse>
				
			  <cf_tl id="REQ055" var="1">
		      <cfset vReq055=#lt_text#>
			  
			  <cf_tl id="Operation not allowed." var="1">
		      <cfset vONA=#lt_text#>
			  
		      <cf_alert message = "#vReq055# #vONA#"
			  return = "back">
			 <cfabort>
		</cfif>
		
	  </cfif>
	
	</cfloop>

</cfoutput>

<cfquery name="Job" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT *
	  FROM Job
	  WHERE JobNo = '#URL.Job#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#Job.Mission#' 
</cfquery>

<cfparam name="URL.Mission" default="#Job.Mission#">
		
<cftransaction> 
			
<!--- loop through lines --->

<cfquery name="Delete" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    UPDATE RequisitionLine 
		SET    ActionStatus = '9'
		WHERE  JobNo = '#URL.ID#'
		AND    RequestType = 'Purchase'
</cfquery>

<cfloop index="Rec" from="1" to="#rw#">

  <cfparam name="FORM.requestdescription_#Rec#" default="">
  <cfparam name="FORM.requestamountbase_#Rec#"  default="">

  <cfset des      = Evaluate("FORM.requestdescription_" & #Rec#)>
  <cfset amt      = Evaluate("FORM.requestamountbase_" & #Rec#)>  
    
  <cfif amt neq "" and des neq "">
  
  	<cfset uom      = Evaluate("FORM.requestuom_" & #Rec#)>
	<cfset qty      = Evaluate("FORM.requestquantity_" & #Rec#)>
	<cfset prc      = Evaluate("FORM.requestcostprice_" & #Rec#)>
    <cfset reqno    = Evaluate("FORM.requisitionNo_" & #Rec#)>
  
    <cfset amt = replace(amt,",","")>
	<cfset prc = replace(prc,",","")>
	<cfset qty = replace(qty,",","")>
      
  	<cfif LsIsNumeric(amt)>
		
		<!--- insert line --->
		
		<cfquery name="Mission" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT TOP 1 *
			FROM Organization.dbo.Organization
			WHERE Mission = '#Job.Mission#' 
			ORDER BY HierarchyCode
		</cfquery>
		
		<cfif reqno eq "">
			
			<cfinclude template="../../Requisition/Requisition/AssignRequisitionNo.cfm">
					
			<cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    INSERT INTO RequisitionLine 
			    (RequisitionNo, 
				 Mission,
			     Period, 
				 ItemMaster,
				 OrgUnit,
				 OrgUnitImplement,
				 RequestDate,
				 RequestDescription,
				 RequestQuantity,
				 QuantityUoM, 
				 RequestCurrency,
				 RequestCurrencyPrice,
				 RequestCostPrice,
				 RequestAmountBase,
				 ActionStatus, 
				 JobNo,
				 RequestType,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
			VALUES ('#Parameter.MissionPrefix#-#no#',
			        '#Job.Mission#',
			        '#Job.Period#',
					'#Form.ItemMaster#',
					'#Mission.OrgUnit#',
					'#Mission.OrgUnit#',
					'#dateFormat(now(),CLIENT.dateSQL)#',
					'#Des#',
					'#qty#',
					'#uom#',
					'#APPLICATION.BaseCurrency#',
					'#prc#',
					'#prc#',
					'#amt#',
					'2k',
					'#URL.Job#',
					'Purchase',
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#')
			</cfquery>
			
			<cfset No = "#Parameter.MissionPrefix#-#no#">
		
		<cfelse>
		
		    <cfset No = reqno> 
		
				<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    UPDATE RequisitionLine 
			SET    RequestDescription     = '#Des#',
			       OrgUnit                = '#Mission.OrgUnit#',
			       RequestQuantity        = '#qty#',
				   ActionStatus           = '2k',
			       QuantityUoM            = '#uom#', 
			       RequestCostPrice       = '#prc#',
			       RequestAmountBase      = '#amt#'
			 WHERE RequisitionNo = '#No#'
			</cfquery>
			
			<cfquery name="CleanFunding" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    DELETE FROM RequisitionLineFunding 
			WHERE  RequisitionNo = '#No#'
			AND    RequisitionNo <> '#URL.ID#'
			</cfquery>
					
		</cfif>
		
		<!--- insert funding --->
		
		<cfif No neq url.id>
			
			<cfquery name="Insert" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    INSERT INTO RequisitionLineFunding 
				    (RequisitionNo, 
				     Fund, 
					 ProgramPeriod,
					 ProgramCode,
					 ObjectCode,
					 Percentage,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName, 
					 Created)
				SELECT  '#No#',
						Fund, 
						ProgramPeriod,
					    ProgramCode,
					    ObjectCode,
					    Percentage,
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#', 
						getDate()
				FROM   RequisitionLineFunding 
				WHERE  RequisitionNo = '#URL.ID#'	
			</cfquery>
		
		</cfif>
			
		<cfquery name="Delete" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    DELETE RequisitionLine 
			WHERE JobNo = '#URL.ID#'
			AND   RequestType = 'Purchase'
			AND   ActionStatus = '9' 
		</cfquery>
		
		<!--- 1. define entries in JobVendor --->
			
		<cfquery name="Vendor" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
			 FROM JobVendor
			 WHERE JobNo = '#URL.Job#'
		</cfquery>
				
		<!--- 2. loop insert requisitionline in linequote for each vendor --->
				
		<cfloop query="Vendor">
				
			<!--- <cftry> --->
			
				<cfquery name="Check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT *
				 FROM   RequisitionLineQuote
				 WHERE  RequisitionNo = '#No#'
				 AND    OrgUnitVendor = '#OrgUnitVendor#'
				</cfquery>
				
				<cfif Check.recordcount eq "0">
			
					<cfquery name="Insert" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 INSERT INTO RequisitionLineQuote
							   (RequisitionNo, 
							    JobNo, 
							    OrgUnitVendor, 
							    VendorItemDescription, 
								QuoteZero,
							    QuoteTax, 
							    QuotationQuantity, 
							    QuotationUoM, 
							    Currency)
						 SELECT RequisitionNo, 
						        '#URL.Job#', 
								'#OrgUnitVendor#', 
								RequestDescription, 
								'1',
								'#Parameter.TaxDefault#', 
								RequestQuantity, 
								QuantityUoM, 
								'#APPLICATION.BaseCurrency#'
						 FROM   RequisitionLine 
						 WHERE  RequisitionNo = '#No#' 
					</cfquery>
				
				</cfif>
				
				<!---
				
				 <cfcatch></cfcatch>
		
			</cftry>	
			
			--->
							
		</cfloop>
	
		</cfif>
		
	</cfif>
		
</cfloop>

</cftransaction> 

<script>

    try {
	 parent.parent.document.getElementById('mybut').click()
	 } catch(e) {}
    parent.parent.ColdFusion.Window.destroy('myshipping',true)	
	
</script>



