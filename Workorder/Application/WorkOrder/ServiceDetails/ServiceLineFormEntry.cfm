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
<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.tabno"         default="0">
<cfparam name="url.workorderline" default="0">

<cfquery name="Line" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine WL INNER JOIN WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference 
	 WHERE   WL.WorkOrderId     = '#url.workorderid#'	
	 AND     WL.WorkOrderLine   = '#url.workorderline#'
</cfquery>

<!--- new line, no open requests --->
<cfquery name="checkopen" 
     datasource="AppsWorkOrder" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT  'X'
		WHERE	1 = 0
</cfquery>

<cf_divscroll>

<table width="100%" height="100%">

<tr><td height="5"></td></tr>

<tr><td id="contentbox" style="height:100%" valign="top">  <!--- contenbox is target for submit to load the servicelineformedit --->
	
	<cfform name="customform" method="POST" style="height:100%">	
	
		<table width="95%" border="0" class="formpadding" cellspacing="0" align="center">
			
		<tr><td colspan="2">
		
			<cfinclude template="ServiceLineFormData.cfm">
		
		</td></tr>
			
		<cfoutput>
		
			<tr><td colspan="2" class="line"></td></tr>
					
			<tr><td align="center" colspan="2" height="30">
					
				<input type    = "button" 
				       name    = "Save" 
			           id      = "Save"
					   Value   = "Save"
					   class   = "button10g" 
					   style   = "width:180;height:28"
					   onclick = "ptoken.navigate('ServiceLineForm.cfm?openmode=dialog&tabno=#url.tabno#&systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&mode=save','submitbox','','','POST','customform')")>
					
				</td>
			</tr>
			
			<tr><td id="submitbox"></td></tr>
					
		</cfoutput>
		
		</td></tr>
		
		</table>
		
	</cfform>
		
</td>
</tr>
</table>	

</cf_divscroll>

