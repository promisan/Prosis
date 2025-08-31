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
<!--- editing a workorder called from the listing --->
<!--- ------------------------------------------- --->

<cfquery name="Get" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  W.*, S.Description
	    FROM    WorkOrder W,
		        WorkOrderLine WL,
				ServiceItem S
		WHERE   W.WorkOrderid      = WL.WorkOrderid		   
		AND     WL.WorkOrderLineId = '#url.drillid#'	
		AND     S.Code = W.ServiceItem
</cfquery>


<cf_screentop height="100%" 
   jQuery="Yes" 
   scroll="Yes" 
   layout="webapp" 
   banner="gray" 
   bannerforce="Yes"  
   band="No" 
   title="#get.Description#" 
   label="Service: <b>#get.Description#" 
   option="Maintain order information">
   
		
<cfinclude template="../ServiceDetails/Billing/DetailBillingFormScript.cfm">

<cfif client.googlemap eq "1">

	<cfajaximport tags="cfmap,cfform,cfdiv" params="#{googlemapkey='#client.googlemapid#'}#">
	
<cfelse>

	<cfajaximport tags="cfform,cfdiv">
	
</cfif>	
	
<cf_menuScript>
<cf_mapscript>
<cf_comboscript>
<cf_calendarscript>
	
<cfparam name="url.mission"    default="#get.mission#">
<cfif url.mission eq "">
   <cfset url.mission ="#get.mission#">
</cfif>

<cfparam name="url.customerid" default="#get.customerid#">

<cfparam name="url.box"     default="">
<cfparam name="url.context" default="Backoffice">

<table width="100%" height="100%">

<cfoutput>
<tr bgcolor="f4f4f4" class="line">

<td colspan="2" style="height:34px">

	<table width="95%" align="center">
	<tr class="labelmedium2">
	<td><cf_tl id="Workorder Number">:</td>
	<td><b>#Get.Reference#</td>
	<td><cf_tl id="Recorded by">:</td>
	<td><b>#Get.OfficerFirstName# #get.OfficerLastName#</td>
	<td><cf_tl id="On">:</td>
	<td><b>#Dateformat(Get.created,CLIENT.DateFormatShow)#</td>
	<td align="right" style="padding-bottom:3px">
		<span id="printTitle" style="display:none;">#Get.Reference# - #Get.OfficerFirstName# #get.OfficerLastName# - #Dateformat(Get.created,CLIENT.DateFormatShow)#</span>
		<cf_tl id="Print" var="1">
		<cf_button2 
			mode		= "icon"
			type		= "Print"
			title       = "#lt_text#" 
			id          = "Print"					
			height		= "19px"
			width		= "19px"
			printTitle	= "##printTitle"
			printContent = ".clsPrintContentImage">
	</td>
	</tr>
	</td></tr>
	</table>
</td>

</tr>	

</cfoutput>

<tr><td valign="top" colspan="2">

	<cf_divscroll>   

   <table width="98%" align="center">
   		
		<cfoutput>
		
		<tr><td colspan="2">
			
			<table width="100%" class="formpadding">
			
			<tr>
			   <td colspan="2" id="workordercontent" class="clsPrintContentImage">
			   
			       <cf_securediv bind="url:#SESSION.root#/workorder/application/workorder/create/workorderform.cfm?context=#url.context#&scope=edit&mode=edit&mission=#url.mission#&workorderlineid=#url.drillid#&box=#url.box#" id="editcontent">
			   </td>
			</tr>			
			
			<tr><td colspan="2" class="line"></td></tr>
						
			<tr><td colspan="2" align="center" style="padding-top:4px">
						
				   <input type="button" 
					   name="Close" 
	                   id="Close"
					   value="Close" 
					   class="button10g" 
					   onclick="window.close()" 
					   style="height:26;width:140px">	
					   
			   <!--- define access --->

			   <cfinvoke component = "Service.Access"  
				   method           = "WorkorderProcessor" 
				   mission          = "#get.mission#" 
				   serviceitem      = "#get.serviceitem#"
				   returnvariable   = "access">		     					   
					   
			   <cfif access eq "ALL" or Get.ActionStatus eq "0">	   	   				   
	   
				   <input type="button" 
						   name="Delete"
                           id="Delete" 
						   value="Delete" 
						   class="button10g" 					   
						   onclick="if (confirm('Do you want to remove this line ?')) { ColdFusion.navigate(document.getElementById('formsave').value+'&customerid=#url.customerid#&box=#url.box#&action=purge','workordercontent','','','POST','orderform') }" 					  
						   style="height:26;width:140px">	
					   
				</cfif>	 
				
				<cfif access eq "EDIT" or access eq "ALL" or Get.ActionStatus eq "0">	    		   
			
				    <input type="button" 
						   name="Save" 
	                       id="Save"
						   value="Save" 
						   class="button10g" 					   
						   onclick="ColdFusion.navigate(document.getElementById('formsave').value+'&customerid=#url.customerid#&box=#url.box#','workordercontent','','','POST','orderform')" 					  
						   style="height:26;width:140px">	
					   
				</cfif>	   
			
			</td></tr>
			
			</table>
		
		</td></tr>
		
		</cfoutput>
	
   </table>
   
   </cf_divscroll>
   
</td></tr>

</table>



<cf_screenbottom layout="webapp">