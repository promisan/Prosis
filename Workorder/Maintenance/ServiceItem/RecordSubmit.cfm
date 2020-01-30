<cfparam name="Form.CustomDialog" default="">

<cfquery name="VerifyPreexistence" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ServiceItem
	WHERE Code  = '#Form.Code#' 
</cfquery>


<cf_ColorConvert RGB	 ="#Form.ServiceColor#"
				 variable="vServiceColor">


<cfif url.action is "save">	
	
	<cftransaction>
	
		    <cfif VerifyPreexistence.recordCount eq 0>	   
			
				<cfquery name="Insert" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ServiceItem
				         (Code,
						 Description, 
						 ListingOrder,			
						 CustomForm,
						 ServiceClass,
						 ServiceDomain,
						 EnablePerson,
						 EnableOrgUnit,
						 EnableOrgUnitWorkOrder,
						 ServiceColor,
						 FundingMode,
						 Operational,
						 Memo,
						 ServiceMode,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				  VALUES ('#Form.Code#', 
				          '#Form.Description#',
				          '#Form.ListingOrder#',				  
						  '#Form.CustomForm#',
						  '#Form.ServiceClass#',
				  		  '#Form.ServiceDomain#',
						  '#Form.EnablePerson#',
						  '#Form.EnableOrgUnit#',
						  '#Form.EnableOrgUnitWorkOrder#',
						  '#vServiceColor#',
						  '#Form.FundingMode#',
						  '#Form.Operational#',
						  '#Form.Memo#',
						  '#Form.ServiceMode#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
				  </cfquery>
				  
				  	<cf_LanguageInput
					TableCode       = "ServiceItem" 
					Mode            = "Save"
					DataSource      = "AppsWorkOrder"
					Key1Value       = "#Form.Code#"
					Name1           = "Description">	
				  
				  <cfquery name="getMissionTabs" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_ParameterMission
				</cfquery>
								
				
				<cfloop query="getMissionTabs">
				  <!---  Default tabs for every new service item --->
				  
				  <cfquery name="InsertTabs" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ServiceItemTab
				           (Mission,
				           Code,
				           TabName,
				           TabOrder,
				           TabIcon,
				           TabTemplate,
				           AccessLevelRead,
				           AccessLevelEdit,
				           ModeOpen,
				           Operational)			  
				     VALUES
				           ('#mission#',
				           '#Form.Code#',
				           'Financials',
				           1,
				           'Logos/WorkOrder/Charge.png',
				           '../ServiceDetails/Charges/Financials.cfm',
				           '0',
				           '0',
				           'Embed',
				           1)
					</cfquery>
					
					 <cfquery name="InsertTabs" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ServiceItemTab
				           (Mission,
				           Code,
				           TabName,
				           TabOrder,
				           TabIcon,
				           TabTemplate,
				           AccessLevelRead,
				           AccessLevelEdit,
				           ModeOpen,
				           Operational)			  
				     VALUES
				           ('#mission#',
				           '#Form.Code#',
				           'Workorder Status',
				           1,
				           'Logos/User/WorkFlow.png',
				           '../Workflow/Workflow.cfm',
				           '0',
				           '0',
				           'Embed',
				           1)
					</cfquery>
					
					<cfquery name="InsertTabs" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ServiceItemTab
				           (Mission,
				           Code,
				           TabName,
				           TabOrder,
				           TabIcon,
				           TabTemplate,
				           AccessLevelRead,
				           AccessLevelEdit,
				           ModeOpen,
				           Operational)			  
				     VALUES
				           ('#mission#',
				           '#Form.Code#',
				           'Comments and Notes',
				           2,
				           'Logos/WorkOrder/Notes.png',
				           '../Memo/WorkOrderMemo.cfm',
				           '0',
				           '0',
				           'Embed',
				           1)
					</cfquery>
					
					<cfquery name="InsertTabs" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ServiceItemTab
				           (Mission,
				           Code,
				           TabName,
				           TabOrder,
				           TabIcon,
				           TabTemplate,
				           AccessLevelRead,
				           AccessLevelEdit,
				           ModeOpen,
				           Operational)			  
				     VALUES
				           ('#mission#',
				           '#Form.Code#',
				           'Service Inventory',
				           3,
				           'Logos/WorkOrder/Desktop.png',
				           '../ServiceDetails/ServiceLineSelect.cfm',
				           '0',
				           '0',
				           'Embed',
				           1)
					</cfquery>	
					
					<!--- following was changed by Armin on Sept 20 2013 from
									           'Financials', to 'Position',
						---->					   
					  <cfquery name="InsertTabs" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ServiceItemTab
				           (Mission,
				           Code,
				           TabName,
				           TabOrder,
				           TabIcon,
				           TabTemplate,
				           AccessLevelRead,
				           AccessLevelEdit,
				           ModeOpen,
				           Operational)			  
				     VALUES
				           ('#mission#',
				           '#Form.Code#',
						   'Position',	
				           1,
				           'Logos/Staffing/WorkForce1.png',
				           '../WorkForce/PositionListing.cfm',
				           '0',
				           '0',
				           'Embed',
				           1)
					</cfquery>					
					
				</cfloop>
				  
			<cfelse>
		
				<cfif VerifyPreexistence.recordCount neq 0 and Form.CodeOld neq Form.Code>
				
					<script language="JavaScript">   
					     alert('A record with this code has already been entered!')
					</script>			
					
				<cfelse>
				
					<cfquery name="Update" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE ServiceItem
					SET    Description        		= '#Form.Description#',
						   ListingOrder        		= '#Form.ListingOrder#',
						   CustomForm          		= '#Form.CustomForm#',
						   ServiceMode              = '#Form.ServiceMode#',
						   ServiceClass        		= '#Form.ServiceClass#', 
						   ServiceDomain       		= '#Form.ServiceDomain#',
						   EnablePerson        		= '#Form.EnablePerson#',
						   EnableOrgUnit       		= '#Form.EnableOrgUnit#',
						   EnableOrgUnitWorkOrder 	= '#Form.EnableOrgUnitWorkOrder#',
						   ServiceColor        		= '#vServiceColor#',
						   FundingMode         		= '#Form.FundingMode#',
						   Operational         		= '#Form.Operational#',
						   Memo                		= '#Form.Memo#'
					WHERE  Code = '#Form.CodeOld#' 
					</cfquery>
					
					<cf_LanguageInput
						TableCode       = "ServiceItem" 
						Mode            = "Save"
						DataSource      = "AppsWorkOrder"
						Key1Value       = "#Form.Code#"
						Name1           = "Description">
					
				</cfif>
				
			</cfif>	
			
			<cfquery name="Cls" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM Materials.dbo.Ref_ItemClass		
			</cfquery>
			
			<cfloop query="Cls">
				
				 <cfquery name="getClass" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   ServiceItemMaterials
					WHERE  ServiceItem = '#form.Code#'		
					AND    MaterialsClass = '#code#'
				</cfquery>
				
				<cfparam name="Form.#Code#_Category" default="">
				
				<cfset cat = evaluate("Form.#Code#_Category")>
					
				<cfif getClass.recordcount eq "0">
					
					   <cfquery name="insertClass" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO ServiceItemMaterials
							(ServiceItem,MaterialsClass, MaterialsCategory, officerUserId,OfficerLastName,OfficerFirstName)
							VALUES
							('#form.Code#','#code#','#cat#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
						</cfquery>
					
				</cfif>
				
				 <cfquery name="setClass" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE ServiceItemMaterials
					SET    MaterialsCategory = '#cat#'
					WHERE  ServiceItem       = '#form.Code#'		
					AND    MaterialsClass    = '#code#'
				</cfquery>
			
			</cfloop>
	
	</cftransaction>
	
	<cfif VerifyPreexistence.recordCount eq 0>
		<script>
			window.close();
			opener.location.reload();
		</script>
	<cfelse>
		<cfset url.id1 = form.codeOld>
		<cfset url.loadcolor = 1>
		<cfinclude template="ServiceItemEdit.cfm">	
	</cfif>	
		
</cfif>

<cfif url.action is "delete"> 

    <cfquery name="CountRec" 
     datasource="AppsWorkOrder" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     WorkOrder
     WHERE    ServiceItem = '#Form.Code#' 
	 </cfquery>
	
    <cfif CountRec.recordCount gt 0 >
		 
     <script language="JavaScript">
    
	   alert("Service item is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM ServiceItem
			WHERE Code   = '#Form.code#'
	    </cfquery>
	
    </cfif>	
		
	<script language="JavaScript">   
	     window.close()
		 opener.location.reload()        
	</script>  
	
</cfif>	
	