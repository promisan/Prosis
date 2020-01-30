<cfparam name="Form.CustomDialog" default="">
<cfparam name="Form.unitParent" default="">

<cf_screentop jquery="Yes" html="No">
<cfajaximport>

<cfif ParameterExists(Form.Save)>

	<cfquery name="Verify" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT *
		FROM   ServiceItemUnit
		where serviceItem = '#Form.serviceItem#'
		and unit = '#Form.unit#'
	</cfquery>
	
	<cfif Verify.recordcount gt 0>
	
		<script language="JavaScript">alert("A record with this serviceItem and unit has been registered already!")</script>  
		<cfabort>
	
	<cfelse>

	<cfquery name="Insert" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	INSERT INTO ServiceItemUnit
           (ServiceItem,
           Unit,
           <cfif trim(Form.unitCode) neq "">UnitCode,</cfif>
           <cfif trim(Form.UnitDescription) neq "">UnitDescription,</cfif>
           <cfif trim(Form.unitSpecification) neq "">UnitSpecification,</cfif>
           UnitClass,
           <cfif trim(Form.unitParent) neq "">UnitParent,</cfif>
           <cfif trim(Form.glAccount) neq "">GLAccount,</cfif>
		   ServiceDomain,
		   ServiceDomainClass,
           Frequency,
		   BaseLineMode,
           BillingMode,
           LabelQuantity,
           LabelCurrency,
           LabelRate,
           PresentationMode,
           <cfif trim(Form.payrollItem) neq "">PayrollItem,</cfif>
           ListingOrder,
           Operational,
           OfficerUserId,
           OfficerLastName,
           OfficerFirstName)
     VALUES
           ('#Form.serviceItem#',
           '#Form.unit#',
           <cfif trim(Form.unitCode) neq "">'#Form.unitCode#',</cfif>
           <cfif trim(Form.UnitDescription) neq "">'#Form.UnitDescription#',</cfif>
           <cfif trim(Form.unitSpecification) neq "">'#Form.unitSpecification#',</cfif>
		   <cfif form.billingmode eq "Supply">'Regular',<cfelse>'#Form.unitClass#',</cfif>
           <cfif trim(Form.unitParent) neq "">'#Form.unitParent#',</cfif>
           <cfif trim(Form.glAccount) neq "">'#Form.glAccount#',</cfif>
		   <cfif Form.ServiceDomainClass neq "">
		   '#Form.ServiceDomain#', '#Form.ServiceDomainClass#',
		   <cfelse>
		   NULL,NULL,
		   </cfif>
           '#Form.frequency#',
		   #Form.baselineMode#,
           '#Form.billingMode#',
           '#Form.labelQuantity#',
           '#Form.labelCurrency#',
           '#Form.labelRate#',
           '#Form.presentationMode#',
           <cfif trim(Form.payrollItem) neq "">'#Form.payrollItem#',</cfif>
           #Form.listingOrder#,
           #Form.operational#,
           '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#')
	</cfquery>
	
		<cf_LanguageInput
					TableCode       = "ServiceItemUnit" 
					Mode            = "Save"
					DataSource      = "AppsWorkorder"
					Key1Value       = "#Form.ServiceItem#"
					Key2Value       = "#Form.Unit#"
					Name1           = "UnitDescription">
					
		<cf_LanguageInput
					TableCode       = "ServiceItemUnit" 
					Mode            = "Save"
					DataSource      = "AppsWorkorder"
					Key1Value       = "#Form.ServiceItem#"
					Key2Value       = "#Form.Unit#"
					Name1           = "UnitSpecification">
	
	</cfif>
	
	<cfoutput>
	<script language="JavaScript">
	     try {
		 parent.opener.showunitrefresh('#Form.serviceItem#') } catch(e) {}
		 parent.ColdFusion.navigate('itemUnitEditContent.cfm?id1=#Form.serviceItem#&id2=#Form.unit#','divServiceItemUnit')
	</script> 
	</cfoutput>
	
</cfif>

<cfif ParameterExists(Form.Update)>	

<cftransaction>

	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ServiceItemUnit
	SET   UnitCode          = <cfif trim(Form.unitCode) eq "">NULL<cfelse>'#Form.unitCode#'</cfif>,
          UnitDescription   = <cfif trim(Form.UnitDescription) eq "">NULL<cfelse>'#Form.UnitDescription#'</cfif>,
          UnitSpecification = <cfif trim(Form.unitSpecification) eq "">NULL<cfelse>'#Form.unitSpecification#'</cfif>,
          UnitClass         = <cfif form.billingmode eq "Supply">'Regular',<cfelse>'#Form.unitClass#',</cfif>
		  UnitParent        = <cfif trim(Form.unitParent) eq "">NULL<cfelse>'#Form.unitParent#'</cfif>,
          GLAccount         = <cfif trim(Form.glAccount) eq "">NULL<cfelse>'#Form.glAccount#'</cfif>,
		  
		  <cfif Form.ServiceDomainClass neq "">
			  ServiceDomain      = '#Form.ServiceDomain#',
			  ServiceDomainClass = '#Form.ServiceDomainClass#',
		  <cfelse>
			  ServiceDomain      = NULL,
			  ServiceDomainClass = NULL,
		  </cfif>
		  
          Frequency        = '#Form.frequency#',
		  BaselineMode     = #Form.baselineMode#,
          BillingMode      = '#Form.billingMode#',
          LabelQuantity    = '#Form.labelQuantity#',
          LabelCurrency    = '#Form.labelCurrency#',
          LabelRate        = '#Form.labelRate#',
          presentationMode = '#Form.presentationMode#',
          PayrollItem      = <cfif trim(Form.payrollItem) eq "">null<cfelse>'#Form.payrollItem#'</cfif>,
          ListingOrder     = #Form.listingOrder#,
          Operational      = #Form.operational#
		  
	WHERE ServiceItem = '#Form.serviceItem#'
	AND   Unit = '#Form.unit#'
	</cfquery>
	
	<cf_LanguageInput
			TableCode       = "ServiceItemUnit" 
			Mode            = "Save"
			DataSource      = "AppsWorkorder"
			Key1Value       = "#Form.ServiceItem#"
			Key2Value       = "#Form.Unit#"
			Name1           = "UnitDescription">
				
	<cf_LanguageInput
			TableCode       = "ServiceItemUnit" 
			Mode            = "Save"
			DataSource      = "AppsWorkorder"
			Key1Value       = "#Form.ServiceItem#"
			Key2Value       = "#Form.Unit#"
			Name1           = "UnitSpecification">
	
	<!--- sync the mission rates for this variable --->
	
	<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ServiceItemUnitMission
		SET    Frequency       = '#Form.frequency#',
		       GLAccount       = <cfif trim(Form.glAccount) eq "">NULL<cfelse>'#Form.glAccount#'</cfif>,
	           BillingMode     = <cfif trim(Form.billingMode) eq "">null<cfelse>'#Form.billingMode#'</cfif>,
	           Operational     = #Form.operational#
		WHERE  ServiceItem     = '#Form.serviceItem#'
		AND    ServiceItemUnit = '#Form.unit#'
	</cfquery>
	
</cftransaction>

<cfoutput>
<script language="JavaScript">   
     try {
		 parent.opener.showunitrefresh('#Form.serviceItem#') } catch(e) {}          
	 parent.ColdFusion.navigate('itemUnitEditContent.cfm?id1=#url.id1#&id2=#url.id2#','divServiceItemUnit')
</script>
</cfoutput>

</cfif>	

<cfif ParameterExists(Form.Delete)>

	<cfquery name="verifyDelete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		from   WorkOrderLineBillingDetail
		WHERE  serviceItem = '#Form.serviceItem#'
		AND    serviceItemUnit = '#Form.unit#'
	</cfquery>	
	
	<cfif verifyDelete.recordCount eq 0>			
		<cfquery name="Delete" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ServiceItemUnit
			WHERE  serviceItem = '#Form.serviceItem#'
			AND    unit = '#Form.unit#'
		</cfquery>
	</cfif>
	
	<script language="JavaScript">   
	     parent.parent.showunitrefresh('#Form.serviceItem#')	
	     parent.window.close()	 	          
	</script> 
	
</cfif>	 