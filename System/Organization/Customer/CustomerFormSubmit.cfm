
<!--- saving customer record --->

<cfparam name="Form.CreateProfile" default="0">
  
<cfquery name="Check" 
datasource="#url.dsn#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		SELECT * 
		FROM   Customer
		<cfif form.customerid neq "">
		WHERE  CustomerId = '#form.CustomerId#'
		<cfelse>
		WHERE 1=0
		</cfif>		
</cfquery>	 

<cfif Form.CreateProfile eq "1">

		<cfquery name="CustomerTree" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_ParameterMission
			WHERE  Mission = '#Form.Mission#'			
		</cfquery>	 
		
		<cfif CustomerTree.TreeCustomer neq "">

	       <!--- create a unit profile --->
				
			<cfquery name="Mandate" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_Mandate
				WHERE  Mission = '#CustomerTree.TreeCustomer#'
				ORDER BY MandateDefault DESC
			</cfquery>	 
			
			<cfquery name="Last" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT Max(OrgUnitCode) as OrgUnitCode
				 FROM   Organization
				 WHERE  Mission = '#CustomerTree.TreeCustomer#'	
				 AND    Source = 'Customer'	    
			</cfquery>
			
			<cfif Last.OrgUnitCode eq "">
			  <cfset c = "10001">
			<cfelse>
			  <cfset c = "#Last.OrgUnitCode+1#"> 
			</cfif>
			
			<cfquery name="InsertOrganization" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Organization
			         (Mission,
					  MandateNo, 
					  OrgUnitCode,
					  TreeOrder,
					  OrgUnitName,
					  OrgUnitNameShort,
					  OrgUnitClass,		
					  Source,		  			 					  				 		 
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			      VALUES ('#CustomerTree.TreeCustomer#',
			          '#Mandate.MandateNo#',
					  '#c#',
					  '0',
					  '#Form.CustomerName#',
					  '',
					  'Administrative',	
					  'Customer',			  			 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			
			<cfquery name="Select" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT Max(OrgUnit) as OrgUnit
				 FROM   Organization
				 WHERE  Mission   = '#CustomerTree.TreeCustomer#'
				 AND    MandateNo = '#Mandate.MandateNo#'
			</cfquery>
			
			<cf_LanguageInput
				TableCode       = "Organization" 
				Key1Value       = "#Select.OrgUnit#"
				Mode            = "Save"
				Lines           = "1"
				Name1           = "OrgUnitName"
				Value1          = "#Form.CustomerName#">						
					
			<cfset org = Select.OrgUnit>
			
		<cfelse>
		
			<cfparam name="Form.OrgUnit0" default="">
			<cfset org = form.OrgUnit0>		
		
		</cfif>
		
<cfelse>

		<cfparam name="Form.OrgUnit0" default="">
		<cfset org = form.OrgUnit0>		

</cfif> 

<cfif Check.recordcount eq "0">
	  
	<cf_assignId>
	
	<cfparam name="Form.PhoneNumber"  default="">
	<cfparam name="Form.eMailADDRESS" default="">
	<cfparam name="Form.MobileNumber" default="">
	<cfparam name="Form.Address"      default="">
	<cfparam name="Form.PostalCode"   default="">
	<cfparam name="Form.City"         default="">
	<cfparam name="Form.TaxExemption" default="0">
	  
	<cfquery name="Insert" 
	datasource="#url.dsn#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Customer
	         (CustomerId,
			 Mission, 
			 <cfif org neq "">
			 OrgUnit, 
			 </cfif>
			 CustomerName,
			 TaxExemption, 
			 Reference, 			
			 PhoneNumber, 
			 MobileNumber,
			 eMailAddress, 
			 Address,
			 PostalCode,
			 City,
			 Country,
			 Memo,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	  VALUES ('#rowguid#',
	          '#Form.Mission#', 
			   <cfif org neq "">
			  '#org#', 
			  </cfif>
			  '#Form.CustomerName#', 
			  '#Form.TaxExemption#',
			  '#Form.Reference#', 			 
			  '#Form.PhoneNumber#', 
			  '#Form.MobileNumber#',
			  '#Form.eMailAddress#', 
			  '#Form.Address#',
			  '#Form.PostalCode#',
			  '#Form.City#',	
			  '#Form.Country#',		
			  '#Form.Memo#', 
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	</cfquery>
	
	<cfset id = rowguid>
	
	<!--- posting the pricing schedule of the person --->
				
<cfelse>

	<cfparam name="Form.PhoneNumber" default="">
	<cfparam name="Form.MobileNumber" default="">
	<cfparam name="Form.eMailADDRESS" default="">
	<cfparam name="Form.Address" default="">
	<cfparam name="Form.Operational" default="">
	<cfparam name="Form.PostalCode" default="">
	<cfparam name="Form.City" default="">
	<cfparam name="Form.Country" default="">		

	<cfquery name="Update" 
	datasource="#url.dsn#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Customer
			SET Mission        = '#Form.Mission#',
		
			    OrgUnit        = '#org#',

			    CustomerName   = '#Form.CustomerName#',
		
				Reference      = '#form.Reference#', 				
				Address        = '#Form.Address#', 
				PostalCode     = '#Form.PostalCode#', 
		
				City           = '#Form.City#', 
		
				Country        = '#Form.Country#',
         
				PhoneNumber    = '#Form.PhoneNumber#', 
				MobileNumber   = '#Form.MobileNumber#',
				TaxExemption   = '#Form.TaxExemption#',

				Terms          = '#Form.Terms#',
				eMailAddress   = '#Form.EMailAddress#', 
				Operational    = '#Form.Operational#',	

				Memo           = '#Form.Memo#'			
		WHERE CustomerId   = '#Form.CustomerId#' 
	</cfquery>
		
	<!--- ------------------------------------------------------------ --->
	<!--- there is just one customer for this unit, the name is synced --->
	<!--- ------------------------------------------------------------ --->
	
	<cfquery name="Check" 
	datasource="#url.dsn#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Customer
		WHERE  OrgUnit        = '#org#'		
	</cfquery>
	
	<cfif check.recordcount eq "1">   
		
		<cfquery name="Update" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Organization
			SET    OrgUnitName  = '#Form.CustomerName#'
			WHERE  OrgUnit      = '#org#'
		</cfquery>	
	
	</cfif>
	
	<cfset id = Form.CustomerId>

</cfif>	 


<!--- postings --->

<cfquery name="Ledger" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AreaGledger
		ORDER BY ListingOrder
</cfquery>

<cfloop query="Ledger">

	<cfset acc = evaluate("Form.#area#glaccount")>
	
	<cfquery name="cur" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   CustomerGLedger
			WHERE  CustomerId    = '#id#' 
			AND    Area          = '#Area#'	 																
		</cfquery>
		
		<cfif cur.recordcount eq "0">
		
			<cfquery name="Add" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO CustomerGLedger
						(CustomerId,
						 Area,
						 GLAccount,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
					VALUES
						('#id#',
						 '#area#',
						 '#acc#',
						 '#session.acc#',
						 '#session.last#',
						 '#session.first#')										   
			</cfquery>
		
		<cfelse>
		
			<cfquery name="update" 
			datasource="#url.dsn#"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE CustomerGledger 
				SET    GLAccount = '#acc#'			
				WHERE  CustomerId    = '#id#' 
				AND    Area          = '#area#'																					
			</cfquery>
						
		</cfif>
	
</cfloop>	

<!--- pricing --->
	
<cfquery name="CategoryList" 
	datasource="#url.dsn#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		
		  	SELECT   *
			FROM     Materials.dbo.Ref_Category
			WHERE    FinishedProduct = 1 
			<!---
			  AND      Category IN   (SELECT     Category
					                  FROM       WarehouseCategory
					                  WHERE      Warehouse IN (SELECT    Warehouse
					                                           FROM      Warehouse
					                                           WHERE     Mission = '#url.mission#')
									)
			--->						   
																
</cfquery>
	
<cfloop query="CategoryList">
	
		<cfparam name="Form.f#currentrow#_schedule" default="">
		
		<cfset sch = evaluate("Form.f#currentrow#_Schedule")>
		<cfset mde = evaluate("Form.f#currentrow#_PriceMode")>
		<cfset eff = evaluate("Form.f#currentrow#_DateEffective")>
		
		<CF_DateConvert Value="#eff#">
	    <cfset DTE = dateValue>
	
		<cfquery name="cur" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   CustomerSchedule
			WHERE  CustomerId    = '#id#' 
			AND    Category      = '#Category#'	 
			AND    DateEffective = #DTE#																			
		</cfquery>
		
		<cfif cur.recordcount eq "0">
		
			<cfquery name="Insert" 
				datasource="#url.dsn#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO CustomerSchedule
				         (CustomerId,  
						 Category,
						 DateEffective,
						 PriceMode,						
						 PriceSchedule, 
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				    VALUES ('#id#',
				          '#category#', 
						   #dte#,
						  '#mde#',						 
						  '#sch#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
			</cfquery>	
	
		<cfelseif cur.priceschedule neq sch or cur.PriceMode neq mde>
		
			<cfquery name="update" 
			datasource="#url.dsn#"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE CustomerSchedule 
				SET    PriceSchedule = '#sch#', 
				       PriceMode = '#mde#'				
				WHERE  CustomerId    = '#id#' 
				AND    Category      = '#Category#'	
				AND    DateEffective = #dte#																		
			</cfquery>
			
		<cfelse>
		
			<!--- do nothing --->	
				
		</cfif>
	
	</cfloop>
	
	<!--- launch saving template of the workorder --->	
	
	<cfoutput>
	
		  <script language="JavaScript">
		  	
		  		   			  
		   <cfif form.customerid neq "">
		   		   		     
				opener.customeredit('#form.customerid#')
					   
		   <cfelse>
		   
		   		opener.customeradd('#id#')		   
		   
				<!--- refresh left menu for the new customer --->
				
			</cfif>	
						
			window.close()
			       
	   </script>	  
						
	</cfoutput>
	