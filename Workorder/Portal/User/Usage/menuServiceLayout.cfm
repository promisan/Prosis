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

<cfparam name="url.mission" default="">
<cfparam name="url.id" default="">

<cf_screentop height="100%" html="No" Jquery="yes">

<cf_LayoutScript>
<cf_PresentationScript>


  
<cfajaximport tags="cfwindow,cfdiv,cfform,cfinput-datefield">
        
<cfinclude template="menuServiceLayoutScript.cfm">

<!--- feature to load record if they do not exisit for the user. --->
<!---
<cfquery name="Insert"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   INSERT INTO WorkOrderLineDetailCharge
	   ( TransactionId, 
	     WorkOrderId, 
		 WorkOrderLine, 
		 ServiceItem, 
		 ServiceItemUnit, 
		 Reference, 
		 Charged,
		 TransactionDate, 
		 OfficerUserId, 
		 OfficerLastName, 
         OfficerFirstName)		 
	   SELECT
	    TransactionId, 
		WorkOrderId, 
		WorkOrderLine, 
		ServiceItem, 
		ServiceItemUnit, 
		Reference, 		
		'2',
		TransactionDate, 
		'#SESSION.acc#', 
		'#SESSION.last#', 
        '#SESSION.first#'
	   FROM      WorkOrderLineDetail
	   WHERE     TransactionId IN
                 (SELECT   D.TransactionId
                  FROM     WorkOrderLineDetail AS D INNER JOIN WorkOrderLine WL
		          ON       D.WorkOrderId = WL.WorkOrderId AND 
                           D.WorkOrderLine = WL.WorkOrderLine 
		            	   LEFT OUTER JOIN WorkOrderLineDetailCharge AS C 
						     ON D.WorkOrderId = C.WorkOrderId 
							 AND D.WorkOrderLine = C.WorkOrderLine 
							 AND D.ServiceItem = C.ServiceItem 
							 AND D.ServiceItemUnit = C.ServiceItemUnit 
							 AND D.Reference = C.Reference 
							 AND D.TransactionDate = C.TransactionDate
                  WHERE    D.Charged = '2' 
		          AND      WL.PersonNo = '#client.personno#'
                  GROUP BY D.TransactionId, C.ServiceItem
                  HAVING   C.ServiceItem IS NULL
	  )
							
</cfquery>
--->
<cfset attrib = {type="Border",name="myservices",fitToWindow="Yes"}>	

<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'
	</cfquery>
	
<cfparam name="path" default="#SESSION.root#/Custom/Logon/#Parameter.ApplicationServer#/watermark.png">

<!--- used for an overlayer in case of busy screen --->
	
<style>

	td.watermark {
		background-image: url('<cfoutput>#path#</cfoutput>');
		background-position: top center;
		background-repeat: no-repeat;
		width: 100%;
		height: 100%;
		background-color: transparent;
		padding-top: 5;
	}
</style>	
		
<cf_layout attributeCollection="#attrib#">		
	
	<cf_layoutarea  
		position="left" 
		name="left" 
		overflow="auto" 		 
		minsize="250px" 
		maxsize="250px" 
		size="250"
		collapsible="true" 
		splitter="true" 
		togglerOpenIcon = "leftarrowgray.png"
		togglerCloseIcon = "rightarrowgray.png">
		
		<cfset url.user = client.personno>
		<cf_divscroll>
			<table width="100%"  height="100%" border="0">
				<tr>
					<td valign="top"><cfinclude template="ServiceLayoutLeft.cfm"></td>
				</tr>
				<tr>
					<td ><br></td>
				</tr>				
			</table>
		</cf_divscroll>
				
	</cf_layoutarea>
						
	<cf_layoutarea 
          position="center"
          name="bodybox"
          splitter="true"
		  size="auto">		
																		
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
									
					<tr>				
					<td align="right" style="padding-top:6px" bgcolor="ffffff" id="calendar" name="calendar"></td>
					</tr>
														
					<tr>				
						<td style="border:0px solid silver" class="watermark" height="100%" valign="top">
						
						<cf_divscroll overflowx="auto" id="body">
						
						<cfset helpfile = "/custom/portal/#url.id#/HelpWizard.cfm">
			            <cfset helppath = "#SESSION.rootpath##helpfile#">
		            	<cfif FileExists('#helppath#')>               
			                     <cfinclude template="../../../..#helpfile#">                
            			</cfif>
						
						</cf_divscroll>
												
						</td>
					</tr>
				</table>
			
				
	</cf_layoutarea>	 
	
	<cf_layoutarea  
		position    = "right" 
		name        = "inspectbox" 				
		size        = "360"
		min-size    = "360"				
		collapsible="true" 
		splitter="true" 
		togglerOpenIcon = "leftarrowgray.png"
		togglerCloseIcon = "rightarrowgray.png">	
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
		<tr>
			<td id="rightbox">
						
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
					<tr>
					<td style="width:100%;padding-top:12px;padding-left:11px">
										
					<table width="100%" style="border:0px solid silver">
					<tr>							
						<td id="boxyear"  name="boxyear"  width="25%" align="left"></td>		
						<td id="boxmonth" name="boxmonth" width="75%" align="left" style="padding-left:1px;padding-right:22px"></td>															
					</tr>
					</table>
					
					</td></tr>
					
				    <tr><td colspan="1" valign="top" id="boxdates" name="boxdates" style="padding-left:11px;padding-top:4px"></td></tr>						
					
					<tr>
						<td colspan="1" height="100%" align="center" valign="top" style="padding-left:10px;padding-top:7px;padding-right:14px">
						<cf_divscroll height="100%" id="inspect"></cf_divscroll>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		</table>
	</cf_layoutarea>	
				
</cf_layout>
