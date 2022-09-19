
<cfparam name="url.portal" default="0">
<cfparam name="url.dsn"    default="appsworkorder">

<cfquery name="Customer" 
	datasource="#url.dsn#"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 10 *, (SELECT OrgUnitCode 
		                   FROM  Organization.dbo.Organization 
						   WHERE OrgUnit = Customer.OrgUnit) as orgUnitCode
		FROM     Customer		
		WHERE    OrgUnit = '#url.org#' 	
		ORDER BY CustomerName
</cfquery>

<cfoutput>
	
	<cfif Customer.recordcount gt "1">
	
		<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
		
		<cfloop query="Customer">
		
			<tr class="navigation_row linedotted">
			<td height="18"  width="100%" id="box#customerid#">
			
				<table  width="100%" onclick="showcustomer('#CustomerId#','view','#url.dsn#')">
				
					<tr class="fixlengthlist">
					<td rowspan="2" height="18" width="20"><img src="#SESSION.root#/images/pointer.gif" height="9" alt="" border="0"></td>
					<td class="labelit" oncontextmenu="viewOrgUnit('#orgunit#')"><font color="0080FF">
					#CustomerName# <cfif OrgUnit neq "">[#OrgUnitCode#]</cfif></font></td>
					</td>
					</tr>			
				</table>
				
			</tr>
			
		
		</cfloop>
			
		</table>
	
	</cfif>
	
	<cfif customer.recordcount eq "0">
		
		<cfquery name="WorkOrderLine" 
			datasource="appsWorkOrder"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  TOP 1 *
				FROM    WorkorderLine		
				WHERE   OrgUnit = '#url.org#'		
		</cfquery>
		
		<cfif WorkOrderLine.recordcount gte "1">
		
		    <script>
				ptoken.navigate('#SESSION.root#/Workorder/Application/WorkOrder/ServiceDetails/ServiceLineListingContent.cfm?systemfunctionid=#url.systemfunctionid#&portal=#url.portal#&orgunit=#url.org#','detail',mycallBack,myerrorhandler)	
			</script>
			
		<cfelse>	
		
			<script>						
				ptoken.navigate('#SESSION.root#/system/organization/customer/CustomerEdit.cfm?systemfunctionid=#url.systemfunctionid#&dsn=#url.dsn#&portal=1&customerid=','detail',mycallBack,myerrorhandler)	
			</script>		
					
		 </cfif>	
	
	<cfelse>	
	
		<cfif Customer.recordcount gte "1">
				
			<script>
				ptoken.navigate('#SESSION.root#/system/organization/customer/CustomerEdit.cfm?systemfunctionid=#url.systemfunctionid#&dsn=#url.dsn#&portal=#url.portal#&customerid=#Customer.CustomerId#','detail',mycallBack,myerrorhandler)	
			</script>
			
		<cfelse>
		
		    <!--- nothing found --->
			
			<script>						
				ptoken.navigate('#SESSION.root#/system/organization/customer/CustomerEdit.cfm?systemfunctionid=#url.systemfunctionid#&dsn=#url.dsn#&portal=1&customerid=','detail',mycallBack,myerrorhandler)	
			</script>
			
		</cfif>
	
	</cfif>

</cfoutput>

<cfset AjaxOnLoad("doHighlight")>	

