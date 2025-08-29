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
<table cellspacing="0" border="0" width="100%">
  				 			 									
	<cfquery name="getList" 
	datasource="AppsWorkOrder">							
	  SELECT     W.Reference as OrderNo,
	             WL.Reference, 
				 C.Description as DescriptionClass,
				 D.DisplayFormat,
				 S.Code,
	             S.Description, 				
				 WL.DateEffective, 
				 WL.DateExpiration, 								
				 WL.WorkOrderId, 
				 WL.WorkOrderLine,
				 WL.WorkorderLineId				 
	  FROM       ServiceItemClass C INNER JOIN
	             ServiceItem S ON C.Code = S.ServiceClass INNER JOIN
				 Ref_ServiceItemDomain D ON D.Code = S.ServiceDomain INNER JOIN
                 WorkOrder W ON S.Code = W.ServiceItem INNER JOIN
                 WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId
      WHERE      WL.PersonNo = '#client.personno#' AND
	  			 WL.Operational = 1 AND
				 S.Operational  = 1 AND
				 S.Selfservice  = 1 AND
				 (WL.DateExpiration is NULL or DateExpiration > getDate()-50)
	  ORDER BY   C.Description, S.Description, WL.Reference						  
	</cfquery>	
							
	<tr><td style="padding-left:9px;padding-top:8px;padding-right:2px">				
					
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="navigation_table" navigationhover="#c4e1ff" navigationselected="#cccccc">
		
		     <cfoutput>
			 
		      <tr onclick="ColdFusion.navigate('#SESSION.root#/workorder/portal/user/Summary/SummaryOpen.cfm?width=#url.width#&height=#url.height#','center')" 
				 id="servicetree" name="servicetree" class="navigation_row">
					
				<td width="10%"><img src="#session.root#/images/toggle_up.png" alt="" border="0"></td>					
				<td width="90%" style="height:30px" align="left" class="label"><font color="0080C0">Show ALL services</font></td>
				
			 </tr>			 
			 		 
			</cfoutput>		
			
			<cfoutput query="getList" group="DescriptionClass">
			
			<tr><td height="5"></td></tr>				
			
			<tr>
				<td colspan="2" class="label" style="padding:3px"><b>#DescriptionClass#</font></td>
			</tr>			
			
			  <cfquery name="Subtotal" dbtype="query">
			  	  SELECT   DISTINCT Code	 
				  FROM     getList
				  WHERE    DescriptionClass = '#DescriptionClass#' 
			    </cfquery>	
			
				<cfset cnt = 0>
							
				<cfoutput group="Description">
							
					<cfset cnt = cnt + 1>		
					
					<cfset cl = "regular"> 	
										
					<tr class       = "navigation_row #cl#"
						onclick     = "ColdFusion.navigate('#SESSION.root#/workorder/portal/user/Summary/SummaryOpen.cfm?width=#url.width#&height=#url.height#&serviceitem=#code#','center')" 
						id          = "servicetree" 
						name        = "servicetree" 
						style       = "cursor:pointer">
						
						<td width="4%"></td>
						<td width="96%" align="left" class="label navigation_action" 
						    style="padding-left:0px;padding-top:1px; padding-bottom:1px; padding-right:5px">
							 #Description#
						</td>
					</tr>
																				
			  </cfoutput>	
			
			
			</cfoutput>
														 
	    </table>

		</td>	
	</tr>
	
</table>

	