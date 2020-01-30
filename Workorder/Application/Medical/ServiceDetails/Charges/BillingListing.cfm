<cf_screentop jquery="yes" html="no">
<cf_listingscript>	
<cfajaximport tags="cfform,cfinput-datefield">
<!--- listing of receipts will drill down to receipt dialog --->

 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.idmenu#"				
		Label           = "Yes">			
			
<cfparam name="lt_content" default="Medical Billing">

<table width="100%" height="100%">
	
	<!--- control list data content --->
	
	<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.Mission#'	
	</cfquery>

   <tr>

   <td colspan="1" height="100%" valign="top">
		<cfdiv id="divListingContainer" style="height:100%" bind="url:#session.root#/Workorder/Application/Medical/ServiceDetails/Charges/BillingListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#">        	
	</td>	
	
   </tr>

</table>		
		