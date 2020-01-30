
<cfoutput>

<tr>
	<td class="labelmedium"><font color="808080"><cf_tl id="Service">:</td>
	
	<td height="#ht#" colspan="3">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td class="labelmedium">
	
	<cfif accessmode eq "Edit">	
		
			<cfquery name="ServiceItem" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   ServiceItem
				WHERE  Code IN (SELECT Code 
				                FROM   ServiceItemMission
				                WHERE  Mission = '#url.mission#')
				<cfif url.domain neq "">		
				AND    ServiceDomain = '#url.domain#'		
				</cfif>				
				AND    Operational = 1
			</cfquery>
			
			<cfif url.requestid eq "" and url.workorderid eq "">
					
			<select name="serviceitem" id="serviceitem" 
			    class="regularxl" 
			    onchange="document.getElementById('workorderlineid').value='';loadrequesttype('#accessmode#');">
				
				<cfloop query="ServiceItem">
			       <option value="#Code#" <cfif RequestLine.serviceitem eq code>selected</cfif>>#Description#</option>
				</cfloop>	
				
			</select>
		
		<cfelse>
		
			<cfif url.workorderid neq "">
														
				<cfquery name="WorkOrder" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * 
					FROM   WorkOrder	
					WHERE  WorkOrderid = '#url.workorderid#'					
				</cfquery>
			
				<input type="hidden" name="serviceitem" id="serviceitem" value="#workorder.serviceitem#">
				
				<cfquery name="ServiceItem" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   ServiceItem
					WHERE  Code = '#workorder.serviceitem#'
				</cfquery>
				
				#ServiceItem.Description#			
			
			<cfelse>
				
				<input type="hidden" name="serviceitem" id="serviceitem" value="#requestline.serviceitem#">
				
				<cfquery name="ServiceItem" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   ServiceItem
					WHERE  Code = '#RequestLine.serviceitem#'
				</cfquery>
				
				#ServiceItem.Description#
			
			</cfif>
		
		</cfif>
		
	<cfelse>
	
		  <input type="hidden" name="serviceitem" id="serviceitem" value="#requestline.serviceitem#">
					
		  <cfquery name="ServiceItem" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   ServiceItem
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
					FROM   Ref_Request		
					WHERE  Code = '#Request.requesttype#'
			</cfquery>
			
			/ #get.Description#
			
			<cfquery name="getAction" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_RequestWorkflow		
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

<cfif accessmode eq "Edit">	

	<tr>
	<td width="200" class="labelmedium"><font color="808080"><cf_tl id="Class">:</td>
	
	<td id="boxrequesttype" height="#ht#" class="labelmedium">	
														
		<cfif request.requesttype neq "">
				
			<cfquery name="current" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_RequestWorkflow 
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
					FROM   Ref_Request		
					WHERE  Code IN (SELECT RequestType 
					                FROM   Ref_RequestWorkflow
									WHERE  ServiceDomain = '#Request.ServiceDomain#'	
									AND    isAmendment   = '#current.isAmendment#')
					AND    Operational = 1
			</cfquery>			
												
			<select name="requesttype" id="requesttype" class="regularxl" 			   
			   onchange="loadcustomform('#url.requestid#',this.value,'#RequestLine.serviceitem#','#accessmode#',document.getElementById('workorderlineid').value,document.getElementById('requestaction').value);ColdFusion.navigate('DocumentRequestAction.cfm?requestid=#url.requestid#&requesttype='+this.value+'&domain=#url.domain#&serviceitem=#RequestLine.serviceitem#','requestaction')">
				<cfloop query="RequestType">
			        <option value="#Code#" <cfif Request.requesttype eq code>selected</cfif>>#Description#</option>				
				</cfloop>	
			</select>
		
		</cfif>		
	
	</td>
	
	</tr>
	
		
	<tr id="rowaction">
	
	<td class="labelmedium"><font color="808080"><cf_tl id="Action">:</td>
	
	<td id="requestaction" height="20">	
		
	   <cfif request.requesttype neq "">
	   
	    <!--- preload --->

	    <cfdiv bind="url:DocumentRequestAction.cfm?requestid=#url.requestid#&requesttype=#request.requesttype#&domain=#url.domain#&serviceitem=#RequestLine.serviceitem#"
		id="requestactioncontent">
		   
	   </cfif>	
		
	</td>
	
	</tr>
	
</cfif>


<!--- ------------------------------------------------- --->
<!--- ------------- SERVICED ITEM --------------------- --->
<!--- ------------------------------------------------- --->

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
	
	    <td class="labelmedium" height="#ht#"><cf_space spaces="50"><font color="808080"><cf_tl id="Apply to">#domain.description# <font color="FF0000">*</font>:</td>
		
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

</cfoutput>