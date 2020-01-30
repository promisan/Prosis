<cfparam name="Form.CustomDialog" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#form.DateEffective#">
<cfset STR = dateValue>
					
<cfset dateValue = "">
<CF_DateConvert Value="#form.DateExpiration#">
<cfset END = dateValue>

<cfquery name="verifyOverlap" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	TOP 1 costId
	FROM    ServiceItemUnitMission
	WHERE	ServiceItem     = '#Form.serviceItem#'
	AND		ServiceItemUnit = '#Form.serviceItemUnit#'
	AND		Mission         = '#Form.mission#'
	AND		(
				#STR# between DateEffective and DateExpiration 
				or 
				#END# between DateEffective and DateExpiration 
			)
	<cfif ParameterExists(Form.Update)>
	AND		CostId != '#Form.costId#'
	</cfif>
</cfquery>

<cfif ParameterExists(Form.Save) or ParameterExists(Form.SaveAsNew)>	
	
	<!---
	<cfif verifyOverlap.recordCount gt 0>
	
		<script language="JavaScript">alert("The period overlaps with the same service unit in the same mission.")</script>  
	
	<cfelse>
	--->
	
		<cf_assignid>
		<cfset costid = rowguid>

		<cftransaction>
			
			<cfquery name="Insert" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ServiceItemUnitMission
			           (CostId,
			           ServiceItem,
			           ServiceItemUnit,
			           Mission,
			           ServiceCode,
			           <cfif trim(Form.dateEffective) neq "">DateEffective,</cfif>
			           <cfif trim(Form.dateExpiration) neq "">DateExpiration,</cfif>
			           Frequency,
			           BillingMode,
			           EnableUsageEntry,
			           Currency,
			           StandardCost,
			           <cfif trim(Form.price) neq "">Price,</cfif>
					   TaxCode,
			           GLAccount,
					   <cfif Form.warehouse neq "">
						   Warehouse,
						   ItemNo,
						   ItemUoM,
					   </cfif>
					   EnableSetDefault,
			           EnableEditCharged,
			           EnableEditQuantity,
			           EnableEditRate,
			           Operational,
			           OfficerUserId,
			           OfficerLastName,
			           OfficerFirstName)
			     VALUES
			           ('#costid#',
			           '#Form.serviceItem#',
			           '#Form.serviceItemUnit#',
			           '#Form.mission#',
			           null,
			           <cfif trim(Form.dateEffective) neq "">#STR#,</cfif>
			           <cfif trim(Form.dateExpiration) neq "">#END#,</cfif>
			           '#Form.Frequency#',
			           '#Form.BillingMode#',
			           #Form.EnableUsageEntry#,
			           '#Form.Currency#',
			           '#Form.StandardCost#',
			           <cfif trim(Form.price) neq "">#Form.price#,</cfif>
					   '#Form.TaxCode#',
			           null,
					   <cfif Form.warehouse neq "">
						   '#form.warehouse#',
						   '#Form.ItemNo#',
						   '#Form.ItemUoM#',
					   </cfif>
					   
					   #Form.EnableSetDefault#,
			           #Form.enableEditCharged#,
			           #Form.enableEditQuantity#,
			           #Form.enableEditRate#,
			           1,
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')		
			</cfquery>
			
			<cfif trim(form.orgUnit) neq "">
			
				<cfquery name="InsertOwner" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO ServiceItemUnitMissionOrgUnit (
								CostId,
								OrgUnitOwner,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName)
						VALUES ('#costId#',
								'#form.orgUnit#',
								'#session.acc#',
								'#session.last#',
								'#session.first#')
				</cfquery>
			</cfif>

			<!--- save remuneration --->
			<cfset vThisCostId = costId>
			<cfinclude template="ItemUnitMissionSubmitRemuneration.cfm">

		</cftransaction>
		
		<cfoutput>
		
		<script language="JavaScript">   
		    try {
			parent.parent.showunitMissionrefresh('#Form.serviceItem#','#Form.serviceItemUnit#')
			} catch(e) {}
		    parent.parent.ColdFusion.Window.destroy('myrate',true)		            
		</script> 
		
		</cfoutput>
		
	<!---	
		
	</cfif>
	
	--->
		  
</cfif>

<cfif ParameterExists(Form.Update)>	

     <!---

	<cfif verifyOverlap.recordCount gt 0>
	
		<script language="JavaScript">alert("The period dates entered overlaps with another unit in the same mission.")</script>  
	
	<cfelse>
	
	--->

		<cftransaction>
	
			<cfquery name="Update" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ServiceItemUnitMission
			SET    Mission             = '#Form.mission#',
				   DateEffective       = <cfif trim(Form.dateEffective) eq "">null<cfelse>#STR#</cfif>,
				   DateExpiration      = <cfif trim(Form.dateExpiration) eq "">null<cfelse>#END#</cfif>,
				   StandardCost        = #Form.standardCost#,
				   Price               = <cfif trim(Form.price) eq "">null<cfelse>#Form.price#</cfif>,
				   TaxCode             = '#Form.TaxCode#',
				   Currency            = '#Form.currency#',
				   Frequency           = '#Form.Frequency#', 
				   
				   <cfif Form.warehouse neq "">
						   Warehouse   = '#Form.Warehouse#',
						   ItemNo      = '#Form.ItemNo#', 
						   ItemUoM     = '#Form.ItemUoM#',
				   <cfelse>
				   	       Warehouse   = NULL,
						   ItemNo      = NULL, 
						   ItemUoM     = NULL,
					
				   </cfif>	   
					 			   
			       BillingMode         = '#Form.BillingMode#',
				   EnableSetDefault    = #Form.EnableSetDefault#,
				   EnableUsageEntry    = #Form.enableUsageEntry#,
				   EnableEditCharged   = #Form.enableEditCharged#,
				   EnableEditQuantity  = #Form.enableEditQuantity#,
				   EnableEditRate      = #Form.enableEditRate#,
				   Operational         = #Form.operational#
			WHERE  CostId              = '#Form.costId#'
			</cfquery>
			
			<!--- update the billing mode on the billing detail lines for frequency and billing mode --->
			
			<cfquery name="SyncBillingLines" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE   WorkOrderLineBillingDetail
				SET      BillingMode = M.BillingMode, Frequency = M.Frequency
				FROM     WorkOrder AS W INNER JOIN
		                 WorkOrderLineBillingDetail AS WB ON W.WorkOrderId = WB.WorkOrderId INNER JOIN
		                 ServiceItemUnitMission AS M ON W.Mission = M.Mission AND WB.ServiceItem = M.ServiceItem AND WB.ServiceItemUnit = M.ServiceItemUnit AND 
		                 WB.BillingMode <> M.BillingMode
				WHERE    WB.BillingMode <> 'Supply'
			</cfquery>	

			<!--- save remuneration --->
			<cfset vThisCostId = Form.costId>
			<cfinclude template="ItemUnitMissionSubmitRemuneration.cfm">

		</cftransaction>
		
		<cfoutput>
		<script language="JavaScript">   
		    try {
			parent.parent.showunitMissionrefresh('#Form.serviceItem#','#Form.serviceItemUnit#')
			} catch(e) {}
		    parent.parent.ColdFusion.Window.destroy('myrate',true)		            
		</script>
		</cfoutput> 	
			
	<!---
	</cfif>
	--->

</cfif>	

<cfif ParameterExists(Form.Delete)> 	

	<cftransaction>
		
		<cfquery name="clearLines" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM   	ServiceItemUnitMissionRemuneration
				WHERE	CostId = '#FORM.costId#'
		</cfquery>
				
		<cfquery name="Delete" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ServiceItemUnitMission
			WHERE  CostId = '#FORM.costId#'
		</cfquery>	

	</cftransaction>
	
	<cfoutput>
	<script language="JavaScript">   
		    try {			
			parent.parent.showunitMissionrefresh('#Form.serviceItem#','#Form.serviceItemUnit#')
			} catch(e) {}
		    parent.parent.ColdFusion.Window.destroy('myrate',true)		            
		</script> 
	</cfoutput>	
		
</cfif>	 