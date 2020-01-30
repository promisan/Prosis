
<cfparam name="url.owner"         default="">
<cfparam name="url.functionclass" default="">
<cfparam name="url.module"        default="">

<cfquery name="SystemFunction" 
datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    SystemFunctionId = '#url.systemfunctionid#'	
</cfquery>

<cf_screentop height="100%" scroll="Yes" html="no">

<cfquery name="Parameter" 
datasource="AppsSystem">
	SELECT   *
	FROM     Parameter
</cfquery>

<style>

	table.rpthighLight {
		BACKGROUND-COLOR: #f9f9f9;		
		border-top : 1px solid silver;
		border-right : 1px solid silver;
		border-left : 1px solid silver;
		border-bottom : 1px solid silver;
	}
	table.rptnormal {
		BACKGROUND-COLOR: #ffffff;
		border-top : 1px solid white;
		border-right : 1px solid white;
		border-left : 1px solid white;
		border-bottom : 1px solid white;
	}
	
</style>

<cfajaximport>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr>

	<td >
	
	<cfquery name="report" 
	datasource="AppsSystem">
		SELECT   DISTINCT SystemModule, FunctionClass
		FROM     Ref_ReportControl C
		WHERE    Operational = 1
		<cfif url.owner neq "">
		AND      Owner = '#url.owner#'
		</cfif>
		<cfif url.module neq "">
		AND      SystemModule = '#url.module#'
		</cfif>
		<cfif url.functionclass neq "">
		AND      Functionclass = '#url.functionclass#' 
		</cfif> 	
		AND      EnablePortal = 1
		AND		 EXISTS (SELECT LayoutId FROM Ref_ReportControlLayout WHERE ControlId = C.ControlId AND Operational = 1 AND UserScoped = 1)
		AND      FunctionClass NOT IN ('Application','System')
		ORDER BY SystemModule,FunctionClass
	</cfquery>
	
		<table cellspacing="0" cellpadding="0">
			<tr>
						
				<cfoutput query="report">
				<td style="padding-left:15px">
					<input type="radio" style="width:18;height:18"
						name="functionclass" 
						id="functionclass" <cfif url.portal eq "1">checked</cfif>
						value="'#functionclass#'" 
						onclick="ColdFusion.navigate('#SESSION.root#/tools/cfreport/MenuReport/SubmenuReportList.cfm?systemfunctionid=#url.systemfunctionid#&portal=1&owner=|#url.owner#|&module=|#module#|&menuclass=|reports|&selection='+this.value,'myreport')">
				</td>
				<td class="labelit" style="padding-top:3px;padding-left:4px">Published #FunctionClass#</td>
				</cfoutput>		
				
				<td style="padding-left:20px; height:25px">
					<cfoutput>
					<input type="radio" style="width:18;height:18"
						name="functionclass" 
						id="functionclass"
						value="my" <cfif url.portal eq "0">checked</cfif>
						onclick="ColdFusion.navigate('#SESSION.root#/tools/cfreport/MenuReport/SubmenuReportList.cfm?systemfunctionid=#url.systemfunctionid#&portal=1&owner=#url.owner#&module=#module#&menuclass=reports&selection=my','myreport')">
					</cfoutput>		  
				</td>
				<td class="labelit" style="padding-top:3px;padding-left:4px">Subscribed reports</td>
				
			</tr>		
		</table>
	</td>
	

<cfset url.portal = 1>
<cfset url.selection = "all"> <!--- corrected in Haiti to ensure load of the regular reports first  --->
<cfset url.menuclass = "reports">

<cfinclude template="SubmenuReportScript.cfm">
<cfinclude template="../../../System/Modules/Subscription/RecordScript.cfm">

<tr><td colspan="2" height="1" class="linedotted"></td></tr>

<!--- removed as it might pass the wrong variable in Haiti
<cfset module  = replace(SystemFunction.FunctionCondition,"'","|","ALL")>
--->

<tr><td colspan="2" valign="top" id="myreport">

	<cfif url.portal eq "0">
	   
   		<cfinclude template="SubmenuReportList.cfm">
	
	<cfelse>  
	   
     	<cfdiv bind="url:#SESSION.root#/tools/cfreport/MenuReport/SubmenuReportList.cfm?systemfunctionid=#url.systemfunctionid#&portal=1&owner=|#url.owner#|&module=|#module#|&menuclass=|reports|&selection=|#report.functionclass#|">
	 
	</cfif> 
    
</td></tr>

</table>
