
<!--- this is general wrapper for the EDI processes --->

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "EDI routing cfc">
	
	<!--- custom validation, 
	      sale issue, 
		  sale void --->
		
	<cffunction name="CustomerValidate"
             access="remote"
             returntype="any"
             returnformat="plain"
             displayname="ValidateCustomer">
			 
			 
			 <cfargument name="Mission"        type="string"  required="true"   default="">
			 <cfargument name="CustomerName"   type="string"  required="false"  default="1">			 
			 <cfargument name="Reference"      type="string"  required="true"   default="">
			 <cfargument name="Datasource"     type="string"  required="true"   default="appsOrganization">	

							
			 <cfquery name="qmission" 
			  datasource="#ARGUMENTS.Datasource#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT  *
					FROM   Organization.dbo.Ref_Mission
					WHERE  Mission = '#ARGUMENTS.Mission#'	    							   
			</cfquery>

			
			
			<cfif qmission.EDIMethod neq "">			
				
				<cfinvoke component = "Service.Process.EDI.#qmission.EDIMethod#"  
			      method           = "CustomerValidate" 
				  datasource       = "#ARGUMENTS.Datasource#"
   				  mission          = "#ARGUMENTS.Mission#" 
			      customername     = "#ARGUMENTS.CustomerName#" 
			      reference        = "#ARGUMENTS.Reference#"
			      returnvariable   = "EDIResult">	 
			
			<cfelse>
			
				<cfset EDIResult.Status = "OK">
			
			</cfif>	
			
			<cfreturn EDIResult>
			 
	</cffunction>	
	
	<cffunction name="SaleIssue"
             access="public"
             returntype="any"
             returnformat="plain"
             displayname="SubmitSale">
			 
			 <cfargument name="Datasource"     type="string"  required="true"   default="appsOrganization">
			 <cfargument name="Mission"        type="string"  required="true"   default="">
			 <cfargument name="Terminal"       type="string"  required="true"   default="1">			 
			 <cfargument name="BatchId"        type="string"  required="true"   default="">
			 <cfargument name="RetryNo"        type="string"  required="false"   default="0">
			 
			 <cfquery name="qmission" 
			  datasource="#ARGUMENTS.Datasource#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT *
					FROM   Organization.dbo.Ref_Mission
					WHERE  Mission = '#Mission#'	    							   
			</cfquery>

			<cfif qmission.EDIMethod neq "">

					<cfquery name="GetInvoice"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT *
						FROM Materials.dbo.WarehouseBatch WB
						WHERE WB.BatchId='#Batchid#'
					</cfquery>
					<!--- Get Warehouse device information --->
					<cfquery name="GetWarehouseDevice"
							datasource="#datasource#"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
						SELECT *
						FROM   Materials.dbo.WarehouseTerminal
						WHERE  Warehouse = '#GetInvoice.Warehouse#'
						AND    TerminalName = '#terminal#'
						AND    Operational=1
					</cfquery>

					<!--- Get Warehouse and Series Information --->
					<cfquery name="GetWarehouseSeries"
							datasource="#datasource#"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT *
							FROM   Organization.dbo.OrganizationTaxSeries
							WHERE  OrgUnit = '#GetWarehouseDevice.TaxOrgUnitEDI#'
							AND    SeriesType = 'Invoice'
							AND    Operational=1
					</cfquery>

					<cfif GetWarehouseSeries.UserKey eq "">
							<cfinvoke component = "Service.Process.EDI.#qmission.EDIMethod#"
			      				method           = "SaleIssue"
				  				datasource       = "#ARGUMENTS.Datasource#"
   				  				mission          = "#Mission#"
			      				Terminal         = "#Terminal#"
			      				Batchid          = "#BatchId#"
				  				RetryNo		   = "#RetryNo#"
			      				returnvariable   = "EDIResult">
					<cfelse>

							<cfinvoke component = "Service.Process.EDI.#qmission.EDIMethod#"
									method           = "SaleIssueV2"
									datasource       = "#ARGUMENTS.Datasource#"
									mission          = "#Mission#"
									Terminal         = "#Terminal#"
									Batchid          = "#BatchId#"
									RetryNo		     = "#RetryNo#"
									returnvariable   = "EDIResult">
					</cfif>
			
			<cfelse>
			
				<cfset EDIResult.Status = "OK">
			
			</cfif>
			
			<cfreturn EDIResult>
		 
	</cffunction>			  		
	
	<cffunction name="SaleVoid"
             access="public"
             returntype="any"
             returnformat="plain"
             displayname="VoidSale">
			 
			 <cfargument name="Datasource"     type="string"  required="true"   default="appsOrganization">
			 <cfargument name="Mission"        type="string"  required="true"   default="">
			 <cfargument name="Terminal"       type="string"  required="true"   default="1">			 
			 <cfargument name="BatchId"        type="string"  required="true"   default="">
			 
			  <cfquery name="qmission" 
			  datasource="#ARGUMENTS.Datasource#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT  *
					FROM   Organization.dbo.Ref_Mission
					WHERE  Mission = '#Mission#'	    							   
			</cfquery>
			
			<cfif qmission.EDIMethod neq "">	
			
				<cfinvoke component = "Service.Process.EDI.#qmission.EDIMethod#"  
			      method           = "SaleVoid" 
				  datasource       = "#ARGUMENTS.Datasource#"
   				  mission          = "#Mission#" 
			      Terminal         = "#Terminal#" 
			      Batchid          = "#BatchId#"
			      returnvariable   = "EDIResult">	 
			
			<cfelse>
			
				<cfset EDIResult.Status = "OK">
			
			</cfif>
			
			<cfreturn EDIResult>
			 
	</cffunction>		    
	
</cfcomponent>	
	