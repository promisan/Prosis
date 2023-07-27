<cfparam name="url.mission" default="">
<cfparam name="url.planner" default="1">
<cfparam name="url.scope" default="filter">
<cfparam name="url.planid" default="">


<cfoutput>
	
	<cfif url.planner  eq "1">
		<cfset tReportPath = "/Custom/Kuntz/WorkOrder/WorkPlanPrint/WorkPlan.cfr">
	<cfelse>
		<cfset tReportPath = "/Custom/Kuntz/WorkOrder/DeliveryPrint/DeliveryList.cfr">	
	</cfif>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.dts#">
	<cfset DTS = dateValue>

	<cfset url.date = url.dts>
	
	<cfinclude template="../getTreeData.cfm">
	
	
	<cfset SESSION.DateDelivery = DTS>
	<cfset SESSION.mission = url.mission>	
	<cfset SESSION.planid = url.planid>

	<cfif url.scope eq "filter">
		<script>
			 ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#units#&ID0=#tReportPath#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
		</script>
	<cfelse>
		<script>
			 ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=&ID0=#tReportPath#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
		</script>
	</cfif>

</cfoutput>
