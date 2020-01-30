
<!--- open the form of the service selected here --->

<table width="100%" height="100%">
	
	<tr><td>
		
		<cfquery name="get" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT  *
		     FROM    Request
			 WHERE   Requestid = '#url.ajaxid#'	 
		</cfquery>
		
		<cfquery name="check" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		     SELECT  R.*, WL.WorkOrderLineId AS WorkOrderLineId
			 FROM    RequestWorkOrder R INNER JOIN
		             WorkOrderLine WL ON R.WorkOrderId = WL.WorkOrderId AND R.WorkOrderLine = WL.WorkOrderLine
			 WHERE   Requestid = '#url.ajaxid#'			
		</cfquery>
		
		<cfif check.recordcount gte "1">
		    
			<!--- show as part of the workflow --->
			<table width="100%" align="center">
				<tr><td width="100%" style="padding-left:30px;font-size:23px;padding-top:30px" class="labellarge">
				    
					<a href="javascript:lineopen('#check.workorderlineid#')">
					<font color="6688aa"><cf_tl id="Request has been fullfilled"></font>
					</a>
					
					</td>
				</tr>
			</table>	
		
		<cfelse>
			
			<cfoutput>
			
			<iframe src="#session.root#/workorder/application/WorkOrder/Create/WorkOrderAdd.cfm?context=workflow&customerid=#get.customerid#&mission=#get.mission#&requestid=#url.ajaxid#&systemfunctionid="
			 width="100%" height="100%" frameborder="0"></iframe>
			
			 </cfoutput>
			 
		</cfif>	 
	
	</td></tr>

</table>
