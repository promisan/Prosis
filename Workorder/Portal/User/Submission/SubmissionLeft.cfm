
<!--- predefined serviceitem --->
<cfparam name="client.serviceitem" default="">
<cfset url.serviceitem = client.serviceitem>

<!--- selected as part of the menu --->
			 			 									
	<cfquery name="getList" 
	datasource="AppsWorkOrder">							
	  SELECT     W.Reference as OrderNo,
	             W.Mission,
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
	             WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
				 ServiceItemMission M ON M.ServiceItem = S.Code AND M.Mission = W.Mission
<!---			 LEFT OUTER JOIN Ref_ServiceItemDomainClass DC ON DC.ServiceDomain = WL.ServiceDomain AND DC.Code = WL.ServiceDomainClass--->
	     WHERE   WL.PersonNo = '#client.personno#' AND
	  			 WL.Operational = '1' AND
				 S.Operational = 1 AND
				 S.Selfservice = 1 AND
				 ((WL.DateExpiration is NULL) or (DateExpiration > getDate()) or (M.SettingShowExpiredLines = 1 AND DateExpiration > getDate()-M.SettingDaysExpiration) )
<!---			 AND ((DC.ChargeTagging IS NULL ) OR (DC.ChargeTagging ='1'))	--->	<!--- 2013-01-22 Disable Custodian devices for approval --->
	  ORDER BY   C.Description, S.Description, WL.Reference				  
	</cfquery>		
	
<!--- if not define take the first service item from the list to be shown --->	
	
<cfif url.serviceitem eq "">
	<cfset url.serviceitem = getList.Code>
</cfif>

<table bgcolor="white" cellspacing="0" border="0" bordercolor="silver" width="100%">
  								
	<tr><td style="padding-left:7px;padding-top:3px;padding-right:7px">				
					
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="navigation_table" navigationhover="#c4e1ff" navigationselected="#cccccc">
								
			<cfoutput query="getList" group="DescriptionClass">
			
			<tr><td height="5"></td></tr>				
			
			<tr>
				<td colspan="2" class="labellarge" style="padding:3px"><b>#DescriptionClass#</b></font></td>
			</tr>			
			
				<cfquery name="Subtotal" dbtype="query">
			  	  SELECT   DISTINCT Code	 
				  FROM     getList
				  WHERE    DescriptionClass = '#DescriptionClass#' 
			    </cfquery>	
			
				<cfset cnt = 0>
							
				<cfoutput group="Description">
							
					<cfset cnt = cnt + 1>		
					
					<cfif url.serviceitem eq code>
					    <cfset cl = "highlight1">
					<cfelse>
					    <cfset cl = "regular"> 
					</cfif>		
<!---									
					<tr class       = "navigation_row #cl#"
						onclick     = "ColdFusion.navigate('#SESSION.root#/workorder/portal/user/Submission/SubmissionPending.cfm?mission=#mission#&serviceitem=#code#','center')" 
						id          = "servicetree" 
						name        = "servicetree" 
						style       = "cursor:pointer">
--->						
					<tr class       = "navigation_row #cl#"
						onclick     = "ColdFusion.navigate('#SESSION.root#/workorder/portal/user/Submission/SubmissionTab.cfm?serviceitem=#code#','center')" 
						id          = "servicetree" 
						name        = "servicetree" 
						style       = "cursor:pointer">


						<td width="10%"></td>
						<td width="90%" align="left" class="labelmedium navigation_action" 
						    style="padding-left:0px;padding-top:1px; padding-bottom:1px; padding-right:5px">
							 #Description#
						</td>
					</tr>
																				
				</cfoutput>	
			
			<tr><td height="4"></td></tr>					
			
			</cfoutput>
											 
	    </table>

		</td>	
	</tr>
	

</table>

	