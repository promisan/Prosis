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
	
<cfquery name="param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Ref_ParameterMission
	   WHERE     Mission = '#mission#'  
</cfquery>

<cfinvoke component = "Service.Access"  
		   method           = "WarehouseAccessList" 
		   mission          = "#url.mission#" 					   					 
		   Role             = "'WhsShip'"
		   accesslevel      = "" 					  
		   returnvariable   = "Access">

<cfinvoke component = "Service.Process.Materials.Taskorder"  
		   method           = "TaskorderList" 
		   tasktype         = "Internal"		   
		   mission          = "#url.mission#"
		   search           = "#url.search#"	  
		   mode             = "Pending"
		   stockorderid     = ""
		   selected         = ""
		   returnvariable   = "listing">	
		   
<table width="95%" align="center">	   

<cfif listing.recordcount eq "0">

<tr><td class="labelit" style="padding-left:9px"><font color="FF0000">No pending taskorders found</td></tr>

</cfif>

<tr><td colspan="12" class="linedotted"></td></tr>

		   
<cfoutput query="listing">
	
	<tr>
		<td class="labelsmall" style="padding-left:3px;padding-right:3px">Task:</td>
		<td class="labelit" style="padding-left:14px;padding-right:3px">
		
		 <cfif find(SourceWarehouse,Access)>
			
				<cfif url.warehouse eq sourceWarehouse>
					<a href="javascript:ColdFusion.navigate('#SESSION.root#/tools/calendar/CalendarView/CalendarViewMonth.cfm?date=#dateformat(DeliveryDate,CLIENT.DateFormatShow)#','currentmonth')"><font color="0080FF">#TaskOrderReference#</font></a>
				<cfelse>
					<a href="javascript:ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&warehouse=#sourceWarehouse#&selecteddate=#dateformat(DeliveryDate,CLIENT.DateFormatShow)#','mainbox')">
					<font color="0080FF">#TaskOrderReference#</font></a>							
				</cfif>
			
		<cfelse>
			#TaskOrderReference#
		</cfif>
		
		
		</td>
		<td class="labelsmall" style="padding-left:3px;padding-right:3px">Request:</td>
		<td height="21" class="labelit" style="cursor:pointer;padding-left:14px;padding-right:3px" onclick="window.open('#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#Reference#&ID0=#Param.RequisitionTemplateMultiple#','_blank', 'left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no')">
		<cf_img icon="print">
		</td>
		<td height="21" class="labelit" style="cursor:pointer;padding-left:14px;padding-right:3px" onclick="stockrequest('#requestheaderid#')">
		<a href="##"><font color="gray"><u>#Reference#</font></a></td>			
		<td class="labelsmall" style="padding-left:3px;padding-right:3px">From:</td>
		<td class="labelit" style="padding-left:3px;padding-right:3px">#SourceWarehouseName#</td>
		<td class="labelsmall" style="padding-left:3px;padding-right:3px">To:</td>
		<td class="labelit" style="padding-left:3px;padding-right:3px">#ShipToWarehouseName#: </td>
		<td class="labelit" style="padding-left:3px;padding-right:3px">
		
		    <cfif find(SourceWarehouse,Access)>
			
				<cfif url.warehouse eq sourceWarehouse>
					<a href="javascript:ColdFusion.navigate('#SESSION.root#/tools/calendar/CalendarView/CalendarViewMonth.cfm?date=#dateformat(DeliveryDate,CLIENT.DateFormatShow)#','currentmonth')"><font color="0080FF">#dateformat(DeliveryDate,CLIENT.DateFormatShow)#</font></a>
				<cfelse>
					<a href="javascript:ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&warehouse=#sourceWarehouse#&selecteddate=#dateformat(DeliveryDate,CLIENT.DateFormatShow)#','mainbox')">
					<font color="0080FF">#dateformat(DeliveryDate,CLIENT.DateFormatShow)#</font></a>							
				</cfif>
			
			<cfelse>
				#dateformat(DeliveryDate,CLIENT.DateFormatShow)#
			</cfif>
		</td>
		<td class="labelit" style="padding-left:3px;padding-right:3px">#ItemDescription#</td>
		<td class="labelit" align="right" style="padding-left:3px;padding-right:3px">#TaskQuantity#</td>
		<td class="labelit" style="padding-left:3px;padding-right:3px">#UoMDescription#</td>
	</tr>

</cfoutput>		

</table>	   