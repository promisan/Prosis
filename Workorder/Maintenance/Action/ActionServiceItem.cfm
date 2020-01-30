
<cfquery name="ServiceItem" 
	datasource="#alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	O.*, 
		       	(
					SELECT ServiceItem 
				    FROM   Ref_ActionServiceItem 
					WHERE  Code = '#url.code#' 
					AND    ServiceItem = O.Code
				) as Selected,
				(
					SELECT entityClass 
				    FROM   Ref_ActionServiceItem 
					WHERE  Code = '#url.code#' 
					AND    ServiceItem = O.Code
				) as EntityClass
	    FROM  ServiceItem O
		WHERE Code IN 
					(
						SELECT 	ServiceItem 
		               	FROM 	ServiceItemMission 
					   	WHERE 	Mission = '#url.mission#' 
					   	AND    	Operational = 1
					)
		AND   Operational = 1			   
		ORDER BY O.ListingOrder
</cfquery>

<cfquery name="qEntityClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT	*
		FROM	Ref_EntityClass
		WHERE	EntityCode = 'Workorder'
		AND		Operational = 1
</cfquery>

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT	*
		FROM	Ref_Action
		WHERE	Code = '#url.code#'		
</cfquery>

<cfset col = 1>


<form method="POST" name="form<cfoutput>#Code#</cfoutput>">

<table width="100%" class="formspacing">

	<cfoutput query="ServiceItem">
	
		<cfif col eq "1"><tr class="line"></cfif>
			<cfset col = col+1>
			<td>&nbsp;</td>
			
			<td valign="top" style="padding-top:6px;padding-left:4px">
			<input style="height:14px;width:14px" type="checkbox" name="TopicClass_#Code#" id="TopicClass_#Code#" <cfif selected neq "">checked</cfif> onclick="selectitem('#url.code#','#code#', this);saveitem('#url.code#')" value="#Code#">
			</td>
			
			<td style="border-radius:10px" valign="top" width="45%" id="td_#url.code#_#Code#" <cfif selected neq ''>style="background-color:'E1EDFF'"</cfif>>
				<table width="100%" cellspacing="0" border="0">
				
				<tr>
								
					<td valign="top" colspan="3" class="labelmedium" style="padding-left:8px;padding-top:3px">#Code# - #Description#</td>					
					<td valign="top" width="1%" id="notification_#url.code#_#code#" rowspan="2" style="padding-top:4px;padding-right:8px; padding-left:5px; <cfif selected eq ''>display:none;</cfif>">
					
					<cfif get.ActionFulfillment eq "Message">
					
						<img src="#SESSION.root#/Images/alert4.gif" 
						style="cursor: pointer;" title="Add Notifications" width="13" height="14" border="0" align="absmiddle" 
						onClick="javascript: addNotification('#url.code#','#code#');">	
						
					</cfif>	
						
					</td>		
				</tr>
				
				<cfif get.ActionFulfillment neq "Message">
				
					<tr id="detail_#url.code#_#code#" style="<cfif selected eq "">display:none</cfif>">
											
							
							<td colspan="3" style="padding-bottom:5px;padding-left:8px" class="labelmedium">	
							<font size="1">Flow:</font>			
							<select name="entityClass_#Code#" id="entityClass_#Code#" class="regularxl" onchange="saveitem('#url.code#')">
								<option value="">None</option>
								<cfloop query="qEntityClass">
								<option value="#qEntityClass.entityClass#" <cfif qEntityClass.entityClass eq ServiceItem.entityClass>selected</cfif>>#qEntityClass.entityClass# - #qEntityClass.entityClassName#</option>
								</cfloop>
							</select>
							</td>
													
					</tr>	
				
				</cfif>		
												
				<cfset url.serviceItem = code>
				<cfinclude template="ActionCustom.cfm">
								
				</table>
				
			</td>
			<cfif col eq "3">
				<cfset col = 1>
			</tr>
			
		</cfif>
	</cfoutput>

</table>

</corm>
