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
<cfset versioncss = RandRange(1, 100, "SHA1PRNG")>
		
<cfparam name="url.date" default="#dateformat(now(),client.dateformatshow)#">

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<cf_screentop 
		title="#url.mission# Scheduler" 
		height="100%" 
		jQuery="Yes"	
		background="gray"
		scroll="No" 
		html="No">
		
<cfinclude template="DeliveryScript.cfm">	
<cfinclude template="Planner\DSS\DSSScript.cfm">	

<cfset vDateSQL = DateFormat(dts,"DDMMYYY")/>

<cfoutput>
<cftry>
	<cfquery name="dNodes"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DROP TABLE stNodes_#URL.mission#_#vDateSQL# 			
	</cfquery>

<cfcatch>	
</cfcatch>
</cftry>	

<cftry>
	<cfquery name="dDetails" datasource="AppsTransaction"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DROP TABLE stWorkPlanDetails_#URL.mission#_#vDateSQL#
	</cfquery>
<cfcatch>
</cfcatch>
</cftry>	
</cfoutput>

<div id="loading" style="top: 132px; left: 20px; width: 100%; height: 100%; position: fixed;  display: none;"></div>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cfform name="mapform" id="mapform" width="100%" height="100%">	

	<table width="100%" height="100%"><tr><td width="100%" height="100%">
	
	<cf_layout attributeCollection="#attrib#">
			
			<cf_layoutarea 
			   	position  = "header"						
			   	name      = "plntop">	
				
				<table cellspacing="0" height="50" width="100%" align="center" cellpadding="0">
								
					<tr><td height="50" valign="top">
				
						<cf_tl id="Delivery planner" var="1">				
						<cf_ViewTopMenu label="#url.mission# #lt_text#" background="gray">
				
					</td>
					</tr>
			
				</table>
							 			  
			</cf_layoutarea>		
			  
			<cf_layoutarea 
			    position    = "left" 
				name        = "treebox" 
				maxsize     = "32%" 		
				size        = "480" 
				minsize     = "480"
				collapsible = "true" 
				splitter    = "true"	
				onhide      = "resizemap();"	
				onshow      = "resizemap();"		
				overflow    = "auto">			
							
				<table width="100%" height="100%">
				
				    <cfoutput>
					
					<tr><td valign="top" height="20" style="padding-left:16px;padding-right:16px">
					
						<table width="99%" cellspacing="0" cellpadding="0">
						
						<tr class="line">
						
						   <td style="height:35px;padding-left:0px">
						   
						   		 <cf_intelliCalendarDate9
									FieldName="DateEffective_date" 								
									class="regularxl"
									Default="#url.date#"
									scriptdate="applydate"	
									manual="false"							
									AllowBlank="false">	
										
								</td>
							<td id="process"></td>
																		
							<td height="24" class="labelit" style="padding-left:7px"><cf_tl id="Order"></td>
																													
							<td class="hide" id="lock" style="cursor:pointer" onclick="setlock()">								
							 	  <img src="<cfoutput>#session.root#</cfoutput>/images/locked.png" alt="Lock workorder in portal" border="0" height="10" width="10">															 								  								
							</td>														
							
							<td height="2" id="order" colspan="1" align="right" class="labellarge" style="padding-right:3px;border-top:0px solid gray"></td>	
							<td style="padding-left:3px">
							
							<a href="javascript:ptoken.navigate('Planner/PlannerReportPrint.cfm?dts='+$('##DateEffective_date').val()+'&mission=#URL.Mission#&planner=0','process','','','POST','mapform')">
		 							<img src="#SESSION.root#/images/print.png" height="22" alt="Requested Deliveries" border="0" align="absmiddle" title="Requested Deliveries"></a>
		 						
							</td>		
							
							<td><cf_img icon="add" tooltip="Add Order" onclick="orderadd()"></td>							
							
							<td colspan="4" align="right" style="padding-left:5px;padding-right:4px" class="labelit"><cf_tl id="Planned"></td>							
							<td id="scheduled" align="left" style="padding-left:2px;border-top:0px solid gray" class="labellarge"></td>								
							<td>
							
							<a href="javascript:ptoken.navigate('Planner/PlannerReportPrint.cfm?dts='+$('##DateEffective_date').val()+'&mission=#URL.Mission#&planner=1','process','','','POST','mapform')">
		 						<img src="#SESSION.root#/images/print.png" height="22" align="absmiddle" alt="Scheduled deliveries" title="Scheduled Deliveries" border="0"></a>
								</td>
							<td id="addmarker" class="hide"></td>
							
						</tr>		
						
						</table>
					
					</td></tr>							
					
					<tr><td valign="top" height="20"  style="padding-top:8px;padding-left:16px;padding-right:16px;padding-bottom:0px">
					
						<input type="hidden" id="menu" value="map">
		
							<!--- top menu --->
						
							<table width="100%" border="0" align="center" cellpadding="0">		  		
											
								<cfset ht = "48">
								<cfset wd = "48">
								
								<tr>		
								
									<cfset itm = 1>			
											
									<cf_menutab item       = "#itm#" 
									            iconsrc    = "Logos/WorkOrder/Planner/MAP.png" 
												iconwidth  = "#wd#" 
												iconheight = "#ht#" 
												class      = "highlight1"
												name       = "Deliveries"
												source     = "javascript:reloadmap()">			
												
									<cfset itm = itm+1>			
																																		
									<cf_menutab item       = "#itm#" 
									            iconsrc    = "Logos/WorkOrder/Planner/WorkPlan.png" 
												iconwidth  = "#wd#" 
												iconheight = "#ht#" 
												name       = "Workplan"
												source     = "javascript:planning()">
												
									<cfquery name="Protocol"
									datasource="AppsWorkOrder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT DISTINCT Protocol
										FROM   Ref_Action R, Ref_ActionNotification P
										WHERE  R.Code = P.Code
										AND    R.Mission = '#url.mission#'										
									</cfquery>	
									
									<cfloop query="Protocol">	
									
										<cfset itm = itm+1>
													
										<cf_menutab item       = "#itm#" 
										            iconsrc    = "Logos/WorkOrder/Planner/#protocol#.png" 
													iconwidth  = "#wd#" 
													iconheight = "#ht#" 
													name       = "#UCASE(protocol)#"
													source     = "javascript:notification('#protocol#')">
																	
									</cfloop>								
													


									</tr>
							</table>
								
					</td></tr>
										
					</cfoutput>					
							    
					<tr><td height="100%" style="padding-left:16px;padding-right:16px;padding-bottom:20px;padding-top:8px">								
	
						<cf_divscroll id="mycontentbox">										
							<cfinclude template="DeliveryViewContent.cfm">						
						</cf_divscroll>	
					
					</td></tr>
									
				</table>
			</cf_layoutarea>
			
			<cf_layoutarea position="center" name="main">
			
				<table width="100%" height="100%">
					<tr>
						<td style="height:100%;padding-left:0px;padding-top:0px;padding-bottom:0px;padding-right:0px" 
						align="center" id="mapcontent"></td>						
					</tr>
				</table>
				
			</cf_layoutarea>
			
			<cf_layoutarea position="right" name="rightbox" maxsize = "32%" 		
				size            = "480" 
				minsize         = "480"
				initcollapsed   = "Yes"
				collapsible     = "false">
				
					<table width="100%" height="100%">	
					    <tr class="line" ><td class="labelmedium" style="padding:10px;">Quick Planner</td></tr>		     
						<tr>		
							<td valign="top" width="30%" style="height:100%;padding-left:8px;padding-top:7px;padding-bottom:9px;padding-right:10px" align="center" id="mapmetadata"></td>
						</tr>	
					</table>
								
			</cf_layoutarea>			
								
	</cf_layout>
	
	<!--- initially load the map --->
	<script>
	 	reloadmap();
	</script>
	   
	</td></tr>
	
	</table>
 	
</cfform>		
   
