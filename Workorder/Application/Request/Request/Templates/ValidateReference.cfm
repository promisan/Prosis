
<cf_compression>


<cfparam name="url.requestid" default="">
<cfparam name="url.mission"   default="">
<cfparam name="url.domain"    default="">
<cfparam name="url.reference" default="">

<cfquery name="Request" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     RequestWorkOrder
		<cfif requestid eq "">
		WHERE 1=0
		<cfelse>
		WHERE    RequestId = '#url.requestid#'		    
		</cfif>
</cfquery>	


<cfquery name="Domain" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ServiceItemDomain
		WHERE    Code = '#url.domain#'		    
</cfquery>	

<cfif Request.recordcount gte "1">
		
		<cfquery name="Check" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     WorkOrderLine
				WHERE    ServiceDomain = '#url.domain#'
				AND      Reference     = '#url.reference#'		
				AND      WorkOrderId   != '#request.workorderid#'
				AND      WorkorderLine != '#request.workorderline#'
				    
		</cfquery>	

<cfelse>

		<cfquery name="Check" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     WorkOrderService
				WHERE    ServiceDomain = '#url.domain#'
				AND      Reference     = '#url.reference#'						    
		</cfquery>	

</cfif>

<cfset val = replaceNoCase(domain.displayformat,"-","","ALL")> 

<cfoutput>
<cfif url.reference neq "">
	<cfif check.recordcount gte "1">
	
		&nbsp;<b></b><font color="FF0000">This #domain.description# already exists!</font>
		
		<script>
			ColdFusion.navigate('DocumentAction.cfm?mission=#url.mission#&requestid='+document.getElementById('requestid').value+'&domain=#url.domain#','actionbox')
		</script>	  
				
	<cfelseif len(url.reference) lt len(val) and len(val) gte "1">
	
		&nbsp;<b></b><font color="FF0000">Invalid #domain.description#</font>
		
		<script>
			ColdFusion.navigate('DocumentAction.cfm?accessmode=hide','actionbox')
		</script>
		
	<cfelse>
	
		&nbsp;<img src="#SESSION.root#/images/check.gif"
		      alt=""
		      border="0">
			  
		<script>
			ColdFusion.navigate('DocumentAction.cfm?mission=#url.mission#&requestid='+document.getElementById('requestid').value+'&domain=#url.domain#','actionbox')
		</script>	  
	
	</cfif>
</cfif>
</cfoutput>