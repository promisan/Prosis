<cfparam name="accessmode" 		default="">
<cfparam name="URL.accessmode"  default="#accessmode#">
<cfoutput>

<tr>
	<td style="padding-left:16px" class="labelmedium"><cf_tl id="Service">:</td>
	
	<td colspan="1">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td class="labelmedium">
					
	<cfif URL.accessmode eq "Edit">	
	
			<input type="hidden" name="domain" id="domain" value="#url.domain#">
		
			<cfquery name="ServiceItem" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   #CLIENT.LanPrefix#ServiceItem
				WHERE  Code IN (SELECT ServiceItem 
				                FROM   ServiceItemMission
				                WHERE  Mission = '#url.mission#')
				<cfif url.domain neq "">		
				AND    ServiceDomain = '#url.domain#'		
				</cfif>			
				AND    Selfservice = 1	
				AND    Operational = 1
			</cfquery>

			<cfif url.requestid eq "00000000-0000-0000-0000-000000000000">		
								
			<select name="serviceitem" id="serviceitem" 
			    class="regularxl" 
			    onchange="document.getElementById('workorderlineid').value='';loadrequesttype('#URL.accessmode#','#url.scope#','#url.requestid#','#url.workorderid#',this.value);">
				
				<cfloop query="ServiceItem">
			       <option value="#Code#" <cfif RequestLine.serviceitem eq code>selected</cfif>>#Description#</option>
				</cfloop>	
				
			</select>
		
			<cfelse>
			
				<cfif url.requestid neq "00000000-0000-0000-0000-000000000000">
															
					<cfquery name="qRequest" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT RL.ServiceItem 
						FROM   Request	R INNER JOIN RequestLine RL ON 
							R.RequestId = RL.RequestId AND RL.RequestLine = 1 
						WHERE  R.RequestId = '#url.requestId#'					
					</cfquery>
				
					<input type="hidden" name="serviceitem" id="serviceitem" value="#qRequest.serviceitem#">
					
					<cfquery name="ServiceItem" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   #CLIENT.LanPrefix#ServiceItem
						WHERE  Code = '#qRequest.serviceitem#'
					</cfquery>
					
					#ServiceItem.Description#			
				
				<cfelse>
					
					<input type="hidden" name="serviceitem" id="serviceitem" value="#requestline.serviceitem#">
					
					<cfquery name="ServiceItem" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   #CLIENT.LanPrefix#ServiceItem
						WHERE  Code = '#RequestLine.serviceitem#'
					</cfquery>
					
					#ServiceItem.Description#
				
				</cfif>
			
			</cfif>
		
	<cfelse>
	
		  <input type="hidden" name="domain" id="domain" value="#Request.ServiceDomain#">
		  	
		  <input type="hidden" name="serviceitem" id="serviceitem" value="#requestline.serviceitem#">
					
		  <cfquery name="ServiceItem" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   #CLIENT.LanPrefix#ServiceItem
				WHERE  Code = '#RequestLine.serviceitem#'
			</cfquery>
		
		   #ServiceItem.Description#
				
			<!--- view mode --->
			
			<input type="hidden" name="requesttype" id="requesttype" value="#request.requesttype#">
						
			<cfquery name="get" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   #CLIENT.LanPrefix#Ref_Request		
					WHERE  Code = '#Request.requesttype#'
			</cfquery>
			
			/ #get.Description#
			
			<cfquery name="getAction" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   #CLIENT.LanPrefix#Ref_RequestWorkflow		
					WHERE  RequestType   = '#Request.requesttype#'
					AND    ServiceDomain = '#Request.ServiceDomain#'
					AND    RequestAction = '#Request.RequestAction#'					
			</cfquery>
			
			/ <b>#getAction.RequestActionName#</b>		
				
	</cfif>	
	
	</td>
		
	</tr>
	
	</table>
	
	</td>
	
</tr>	
	
<!--- -------------------------------------------- --->
<!--- ------------ TYPE OF REQUEST --------------- --->
<!--- -------------------------------------------- --->

<cfif URL.accessmode eq "Edit">	

	<tr>
	<td width="200" style="padding-left:16px" class="labelmedium"><cf_tl id="Class">:</td>
	
	<td id="boxrequesttype" class="labelmedium">	
		<cfif request.requesttype neq "">
				
			<cfquery name="current" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   #CLIENT.LanPrefix#Ref_RequestWorkflow 
					WHERE  RequestType   = '#Request.RequestType#'
					AND    ServiceDomain = '#Request.ServiceDomain#'					
					AND    RequestAction = '#Request.RequestAction#'
			</cfquery>
			
			<!--- limit the request types to which it can be changed to the same mode --->
								
			<cfquery name="RequestType" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   #CLIENT.LanPrefix#Ref_Request		
					WHERE  Code IN (SELECT RequestType 
					                FROM   Ref_RequestWorkflow
									WHERE  ServiceDomain = '#Request.ServiceDomain#'	
									AND    isAmendment   = '#current.isAmendment#')
					AND    Operational = 1
			</cfquery>			
												
			<select name="requesttype" id="requesttype" class="regularxl" 			   
			   onchange="ColdFusion.navigate('../Create/DocumentRequestAction.cfm?requestid=#url.requestid#&requesttype='+this.value+'&domain=#url.domain#&serviceitem=#RequestLine.serviceitem#&serviceitem='+document.getElementById('serviceitem').value,'requestaction')">
				<cfloop query="RequestType">
			        <option value="#Code#" <cfif Request.requesttype eq code>selected</cfif>>#Description#</option>				
				</cfloop>	
			</select>
			
		
		</cfif>		
	
	</td>
	
	</tr>	
		
	<tr id="rowaction">
	
	<td style="padding-left:16px" class="labelmedium"><cf_tl id="Condition">:</td>
	
	<td id="requestaction" height="20">	
		
	   <cfif request.requesttype neq "">
	   
	    <!--- preload --->

	    <cfdiv bind="url:../Create/DocumentRequestAction.cfm?requestid=#url.requestid#&requesttype=#request.requesttype#&domain=#url.domain#&serviceitem=#RequestLine.serviceitem#"
		id="requestactioncontent">
		   
	   </cfif>	
		
	</td>
	
	</tr>
	
</cfif>


<!--- ------------------------------------------------- --->
<!--- ------------- SERVICED ITEM --------------------- --->
<!--- ------------------------------------------------- 

<cfif Request.ActionStatus gte "2">	
		
	<tr id="line">

	    <td class="labelmedium" height="#ht#"><font color="808080"><cf_tl id="Serviced Item">:</td>
		<td class="labelmedium" id="contentline">
		
		<cfquery name="get" 
			   datasource="AppsWorkOrder" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				 SELECT W.*	
			     FROM   WorkOrderLine W, RequestWorkorder R
				 WHERE  R.Requestid     = '#url.requestid#'			
				 AND    W.WorkorderId   = R.WorkOrderId	     
				 AND    W.WorkOrderLine = R.WorkOrderLine			 		
		       </cfquery>
			   
			   <a href="javascript:editworkorderline('#get.workorderlineid#')">
			   <font color="6688aa"><b>#get.Reference#</font></a>		
		
		</td>
	</tr>

<cfelse>
	
	<tr id="line">
	
	    <td class="labelmedium" height="#ht#"><cf_space spaces="50"><font color="808080"><cf_tl id="Associate to">#domain.description# <font color="FF0000">*</font>:</td>
		
		<td id="contentline" class="labelmedium">	
		
			<cfif accessmode eq "Edit">		
			
					<cfdiv bind="url:DocumentWorkOrder.cfm?scope=#url.scope#&accessmode=#accessmode#&requestid=#url.requestid#&mission=#url.mission#&serviceitem={serviceitem}&workorderid=#url.workorderid#&workorderline=#url.workorderline#&orgunit={orgunit}">			
										
			<cfelse>
					
				 <cfquery name="get" 
				   datasource="AppsWorkOrder" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT W.*	
				       FROM   WorkOrderLine W, RequestWorkorder R
					   WHERE  R.Requestid     = '#url.requestid#'			
					   AND    W.WorkorderId   = R.WorkOrderId	     
					   AND    W.WorkOrderLine = R.WorkOrderLine			 		
			     </cfquery>
				   
				 <cfquery name="Format" 
					datasource="AppsWorkOrder"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_ServiceItemDomain
						WHERE  Code = '#URL.Domain#'			
				 </cfquery>
				   
				 <cfif Format.displayformat eq "">
					<cfset val = get.reference>
				 <cfelse>
					<cf_stringtoformat value="#get.reference#" format="#Format.DisplayFormat#">						
				 </cfif>
				   
				 <a href="javascript:editworkorderline('#get.workorderlineid#')"><font color="0080FF" size="2"><b>#val#</font></a>
			
			</cfif>
			
		</td>
	</tr>

</cfif>

--->


</cfoutput>