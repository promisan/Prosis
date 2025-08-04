<!--
    Copyright © 2025 Promisan

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


<script>
	Prosis.busy('yes')	
</script>

<cfquery name="line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   WorkorderLine 
	WHERE  WorkorderLineid = '#url.workorderlineid#'
</cfquery>	

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   Workorder
	WHERE  WorkorderId = '#Line.workorderId#'
</cfquery>	

<cfquery name="ServiceItem"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   ServiceItem 
	   WHERE  Code = '#workorder.serviceitem#'
</cfquery>   

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    SELECT   *
    FROM     WorkOrderLineDetailUser
	WHERE    UserAccount   = '#SESSION.acc#'
	AND      Workorderid   = '#line.workorderid#'
	AND      WorkOrderLine = '#line.WorkOrderLine#'
	AND      Reference     = '#url.reference#'
</cfquery>

<cfif get.recordcount eq "0">
	
	<cfquery name="insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
	    INSERT INTO WorkOrderLineDetailUser
	 		(UserAccount, 
			 WorkOrderId, 
			 WorkOrderLine, 
			 Reference, 
			 ReferenceAlias, 
			 Charged, 
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
		VALUES
			('#SESSION.acc#',
			 '#line.workorderid#',
			 '#line.WorkOrderLine#',
			 '#url.reference#',
			 '#rereplace(form.ReferenceAlias , '^(\w)(.*)', '\u\1\2')#',
			 '#form.charged#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
	</cfquery>

<cfelse>
	
	<cfquery name="set" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
	    UPDATE   WorkOrderLineDetailUser
		SET      ReferenceAlias = '#rereplace(form.ReferenceAlias , '^(\w)(.*)', '\u\1\2')#',
		         Charged        = '#form.charged#'	
		WHERE    UserAccount    = '#SESSION.acc#'
		AND      Workorderid    = '#line.workorderid#'
		AND      WorkOrderLine  = '#line.WorkOrderLine#'
		AND      Reference      = '#url.reference#'
	</cfquery>

</cfif>

<!--- set all calls for this number that are pending approval to personal --->
 
<cfif form.charged eq "1" or form.charged eq "2">

	<cfquery name="getActiveUsage" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
        SELECT  TransactionId
        FROM    WorkOrderLineDetail WL
		
        WHERE   WorkOrderId   = '#line.workorderid#' 
		AND     WorkOrderLine = '#line.WorkOrderLine#' 
		AND     Reference     = '#url.reference#' 
		
		<!--- only usage that is not cleared yet --->
		AND     ServiceUsageSerialNo > (
                                      SELECT MAX(SerialNo)
                                      FROM   WorkOrderLineAction
									  WHERE  WorkorderId   = WL.WorkOrderId
									  AND    WorkOrderLine = WL.WorkOrderLine
									  AND    ActionClass   = '#Serviceitem.UsageActionClose#'
									  AND	 ActionStatus <> '9'
									  ) 		
		
	</cfquery>	
		
	<cfset url.action  = "updatebatch">
	<cfset url.scope   = "data">
	<cfset url.charged = form.charged>
	<cfset url.workorderid = line.workorderid>			
	<cfset url.workorderline = line.WorkOrderLine>
	
	<cfset transactionids = ValueList(getActiveUsage.transactionid)>
	<cfinclude template="../../../Application/WorkOrder/ServiceDetails/Charges/ChargesUsageDetailApply.cfm">

</cfif>

<cfoutput>

	<cfif form.referencealias eq "">
	   #url.reference#
	<cfelse>
	   #form.ReferenceAlias#
	</cfif>

	<!--- refresh the screen with the existing settings --->
	
	<script>
	  refreshlines('')
	</script>
	
</cfoutput>

<script>
	Prosis.busy('no')	
</script>