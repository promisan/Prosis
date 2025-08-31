<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- transfer steps 
0. Check if person and/or customer was changed
1. check effective date is valid and does not lie before the existing
2. terminate line and billing and create a new line, with a link to the parent.
3. inherit billing but only if expiration is null or larger than effective date
--->

<cfquery name="Current" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  L.*,W.CustomerId, W.ServiceItem
	FROM    Workorder W, WorkOrderLine L
	WHERE   W.Workorderid = L.WorkOrderId
	AND     L.WorkorderId = '#url.workorderid#'			
	AND     L.Workorderline = '#url.workorderline#'
</cfquery>

<cfparam name="Form.DateEffective" default="">
<cfparam name="Form.CustomerId"    default="">
<cfparam name="Form.PersonNo"      default="">
			
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset EFF = dateValue>

<cfif not isDate(eff)>

	<script>
		alert("Invalid date. Operation denied")
	</script>	
	<cfabort> 

<cfelseif eff lte current.dateeffective>

	<script>
		alert("You may not define an effective date which lies before the current effective date. Operation denied")
	</script>	  
	<cfabort>

</cfif>

<cfquery name="Get" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Workorder 
		WHERE  CustomerId  = '#Form.CustomerId#'			
		AND    ServiceItem = '#Current.ServiceItem#'
	</cfquery>  

<cfif form.customerid neq current.customerid or
      form.personno neq current.personno>
	  		 
	  <!--- perform a cfc posting function --->  
	
	  <cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
		   method           = "ApplyTransfer" 
		   requestid        = "{00000000-0000-0000-0000-000000000000}"		   
		   workorderid      = "#current.workorderid#"	
		   workorderline    = "#current.workorderline#"	 
		   workorderidTo    = "#get.workorderid#" 
		   effectivedate    = "#Form.DateEffective#"
		   personno         = "#form.personno#">	
			  
<cfelse>

	<script>
		alert("You have not made any changes. Operation denied (transfer).")
	</script>	
	
	<cfabort>  	
	  
</cfif>

<cfoutput>
	<script>
		ColdFusion.navigate('ServiceLineForm.cfm?tabno=#url.tabno#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&mode=view','custom')
	</script>
</cfoutput>


