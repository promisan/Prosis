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

<!--- service landing page --->

<cf_screentop height="100%" html="No">

<cfparam name="url.mission" default="OICT">

<cfquery name="Service" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    M.Mission, 
	          M.ServiceItem, 
			  S.ServiceDomain,
			  S.Description AS ServiceDescription, 
			  R.Description AS ServiceClass, 
			  R.ListingOrder,
			  M.ServiceIcon,
			  M.ServiceInformation
	FROM      ServiceItem AS S INNER JOIN
              Ref_ServiceItemDomain AS R ON S.ServiceDomain = R.Code INNER JOIN
              ServiceItemMission AS M ON S.Code = M.ServiceItem
    WHERE     (S.Selfservice = '1') 
	AND       (M.Mission = '#url.mission#')
    AND       (S.Operational = '1') <!--- added by jBatres 12/03/2012 --->
    ORDER BY  S.ListingOrder
</cfquery>	

<cfquery name="List" 
	datasource="AppsWorkOrder"
     username="#SESSION.login#"
     password="#SESSION.dbpw#">							
	  SELECT    W.Reference as OrderNo,
	             WL.Reference, 
				 C.Description as DescriptionClass,
				 D.DisplayFormat,
	             S.Description, 				
				 S.Code,
				 S.ServiceDomain,
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
      WHERE      WL.PersonNo = '#client.personno#' AND
	  			 WL.Operational = '1' AND
				 S.Operational = 1 AND
				 S.Selfservice = 1 AND
				 ((WL.DateExpiration is NULL) or (DateExpiration > getDate()) or (M.SettingShowExpiredLines = 1 AND DateExpiration > getDate()-M.SettingDaysExpiration)) AND
				 W.Mission = '#url.mission#'
	  ORDER BY   C.Description, S.Description, WL.Reference						  
	</cfquery>	
	

<cf_divscroll>
<table width="97%" cellspacing="0" cellpadding="0" border="0" align="center">
	
	<cfoutput query="service" group="ServiceClass">
	<tr><td colspan="2" height="10px"></td></tr>
	<tr><td colspan="2"><font size="3">#ServiceDescription#</font></td></tr>
	
		<cfset xcnt="0">
				
		<cfoutput>
		
			<cfset xcnt = xcnt+1>
		
			<cfif xcnt eq "1">
				<tr><td height="10px" colspan="2"></td></tr>
			    <tr>
			</cfif>	

			<td width="50%" height="140px" <cfif xcnt eq "2">style="padding-left:10px"</cfif>>
			
				<cf_tableround mode="solidborder" 
				      color="silver" 
					  totalheight="100%" 
					  valign="middle" 
					  padding="2px" 
					  onmouseover="this.bgColor='2d8feb'" 
					  onmouseout="this.bgColor='silver'" 
					  background="yes">

				<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0" >
					<tr>
						<td>
							<table cellpadding="0" cellspacing="0" width="100%" height="100%" onmouseover="this.bgColor='c8dfec'" onmouseout="this.bgColor='ffffff'">
								<tr>
									<td rowspan="2" valign="top" align="center" style="padding-top:3px;border:0px dotted silver" width="120px">
									
										<cfif FileExists ('#SESSION.rootpath##serviceicon#')>
											<img src="#SESSION.root#/#serviceicon#" border="0" width="110px" align="absmiddle" style="max-height: 120px;">
										<cfelse>
											<img src="#SESSION.root#/Images/noimage.gif" border="0" width="110px" align="absmiddle" style="border:1px dotted silver">
										</cfif>								
										
									</td>
									<td style="padding-top:3px;padding-left:7px" valign="top">
										<table cellpadding="0" cellspacing="0" width="100%">
											<tr bgcolor="##FFFFCC" height="30px">
												<td style="padding-left:10px">
													<b>#ServiceDescription#</b>
												</td>
												<td align="right" style="padding-right:5px">
												<cf_space spaces="47">
												
												<cfquery name="RequestType" 
												datasource="AppsWorkOrder" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT *
													FROM   Ref_Request		
													WHERE  Code IN (SELECT RequestType 
													                FROM   Ref_RequestWorkflow 
																	WHERE  ServiceDomain = '#servicedomain#'																	
																	AND    isAmendment = 0																	
																	)
													AND    Operational = 1
													
												</cfquery>
												
												<cfif RequestType.recordcount gte "1">

													<cf_button 
														id="Request_#currentrow#" 
														mode="blueshadow"
														label="New Request" 
														icon="Images/Enter.gif"
														iconheight="15px"
														fontweight="bold"
														fontsize="10"
														height="29"
														fontface="calibri"
														color="black"
														onclick="addRequest('#url.mission#','#servicedomain#','','','')">
														
												</cfif>
														
												</td>
											</tr>
											<tr>
												<td class="line" colspan="2" height="1px">
												</td>
											</tr>
											<tr>
												<td colspan="2" style="padding-top:5px; padding-right:7px; text-align:justify">
													<b>Description:</b>
													<cfif ServiceInformation neq "">
														#ServiceInformation#
													<cfelse>
														There is no description for this item. Contact your Services Focal Point.
													</cfif>
												</td>
											</tr>
										</table>
										
									</td>
									
									
								</tr>
								
								<cfquery dbtype="query" name="chente">
										SELECT *
										FROM   List
										WHERE  Code = '#Service.ServiceItem#'
									</cfquery>
									
									<!--- Show if Service is subscribed  --->
									<cfif chente.reference neq "">
								
								    <tr>
																
									<td align="right" style="padding-left:10px;padding:2px">
															
											<table cellpadding="0" cellspacing="0" width="100%" border="0">
												
												<tr>
													<td style="padding-left:10px;padding-bottom:3px">
														<b>Existing Services:</b>
													</td>
												</tr>
														<cfset cnt = "0">												
														<cfloop query="chente">
														<cfset cnt = cnt+1>
															<tr													
                                                                <cfif currentrow MOD 2>
                                                                bgcolor="##f3f3f3"
                                                                </cfif>
																style="cursor:pointer">
                                                                
                                                                <td style="padding-left:10px;padding-bottom:3px">
                                                                	<table cellpadding="0" cellspacing="0" width="100%">
                                                                    	<tr onmouseover="this.style.backgroundColor='91cbeb'" 
                                                                        onmouseout="this.style.backgroundColor='transparent'">
                                                                            <td height="16">																	
                                                                                <cf_stringtoformat value="#reference#" prefix="-" format="#DisplayFormat#">
                                                                                <cfif DateExpiration neq "" and DateExpiration lt now() >
                                                                                    <font color="silver" title="Expired Service">#val#</font>
                                                                                <cfelse>	
                                                                                    #val#
                                                                                </cfif>
                                                                            </td>
                                                                            <td width="80px">
																			   <a href="javascript:addRequest('#url.mission#','#servicedomain#','','#workorderid#','#workorderline#')">
																				  [Amend&nbsp;service]
																			   </a>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                      
															<cfif cnt eq "2">
															<cfset cnt = "0">
															</tr>
															</cfif>
															 
														</cfloop>

											</table>							
										
										
									</td>
									
									</tr>
									
									</cfif>
																
							</table>
							
						</td>
					</tr>
				</table>			
				
				</cf_tableround>
			</td>		   		
					
			<cfif xcnt eq "2">
			</tr>
		 	<cfset xcnt = "0">
			</cfif>
	
		</cfoutput>
		
	</cfoutput>

</table>
</cf_divscroll>