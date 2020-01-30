
<cfoutput>

<cfquery name="get" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  *
  FROM   	SalarySchedulePeriod 
  WHERE  	CalculationId   = '#URL.ID2#'
</cfquery>

<cfset url.mission = get.mission>
<cfset url.schedule = get.SalarySchedule>

<cf_layoutScript>

<cf_tl id="Payroll entitlement review" var="1">

<cf_screenTop height="100%" title="#lt_text#" jquery="Yes" html="no" border="0" scroll="no" layout="webapp">

<cf_layout type="border" id="mainLayout" width="100%">	
			
	<cf_layoutArea 
			name       ="left" 
			position   ="left" 
			collapsible="true"
			size       ="200"
			overflow ="scroll">				

			<cfform>
			<table width="100%">
				  
			 <tr><td style="padding-left:20px;padding-top:10px">
			 			
				<cf_payrollEntitlementTreeData mission = "#URL.Mission#" schedule="#url.schedule#">	  
							
							
			 </td></tr>
				
			</table>
			</cfform>

				
	</cf_layoutArea>
			
	<cf_layoutArea 
			name="center" 
			position="center"
			overflow ="scroll">

			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
			        name="right"
			        id="right"
			        width="100%"
			        height="99%"
					scrolling="no"
			        frameborder="0"></iframe>
			
	</cf_layoutArea>
	
</cf_layout>
	
</cfoutput>

