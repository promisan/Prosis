
<cfquery name="workorder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   *
    FROM     Workorder W, WorkOrderLine WL
	WHERE    W.WorkorderId = WL.WorkOrderId
    AND      WorkOrderLineId = '#url.workorderlineid#'		
</cfquery>

<cfquery name="Get" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   T.WorkOrderId, T.WorkOrderLine, T.Topic, T.TopicValue
    FROM     WorkOrderLine AS WL INNER JOIN
             WorkOrderLineTopic AS T ON WL.WorkOrderId = T.WorkOrderId AND WL.WorkOrderLine = T.WorkOrderLine
    WHERE    T.Topic = 'f010'
    AND      WorkOrderLineId = '#url.workorderlineid#'	
	AND      T.Operational = 1
</cfquery>

<cfif get.topicvalue eq "1">
  <cfset new = "0">
  <cfset display = "<font color='FF0000'><b>No</b></font>">
<cfelse>
  <cfset new = "1">
  <cfset display = "<font color='green'><b>Yes</b></font>">
</cfif>

<cfoutput>#display#</cfoutput>

<cfset id                = workorder.workorderid>
<cfset url.workorderline = workorder.workorderline>
	
<cfset url.topicselect   = "f010">
<cfset form.topic_f010 = new>

<cfinclude template="../../WorkOrder/Create/CustomFieldsSubmit.cfm">	

<!--- we also refresh the number on the left panel --->

<cfoutput>
	<script>		
	_cf_loadingtexthtml='';	
	ptoken.navigate('Planner/setScheduled.cfm?mission=#workorder.mission#&date=#url.dts#','scheduled')
	</script>
</cfoutput>