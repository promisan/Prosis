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

<!--- predefined serviceitem --->
<cfparam name="client.serviceitem" default="">
<cfparam name="url.width" default="#client.width#">
<cfset url.serviceitem = client.serviceitem>

<!--- selected as part of the menu --->
			 			 									
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
	                WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
				 ServiceItemMission M ON M.ServiceItem = S.Code AND M.Mission = W.Mission
<!---				LEFT OUTER JOIN Ref_ServiceItemDomainClass DC ON DC.ServiceDomain = WL.ServiceDomain AND DC.Code = WL.ServiceDomainClass--->
	     WHERE      WL.PersonNo = '#client.personno#' AND
	  			 WL.Operational = '1' AND
				 S.Operational = 1 AND
				 S.Selfservice = 1 AND
				 ((WL.DateExpiration is NULL) or (DateExpiration > getDate()) or (M.SettingShowExpiredLines = 1 AND DateExpiration > getDate()-M.SettingDaysExpiration) )
<!---				 AND ((DC.ChargeTagging IS NULL ) OR (DC.ChargeTagging ='1'))	--->	<!--- 2013-01-22 Disable Custodian devices for approval --->
	  ORDER BY   C.Description, S.Description, WL.Reference							  
</cfquery>	
	
<cfif url.serviceitem eq "">
	<cfset url.serviceitem = getList.Code>
</cfif>	
	
<cfajaximport tags="cfwindow">

<cfoutput>

<head>			
<title></title>

<style>
	td.itemregular {
		cursor:pointer;
		background-image:url('#SESSION.root#/Images/toggle_up.png');
		background-position:center left;
		background-repeat:no-repeat;
	}
	
	td.itemselected {
		cursor:pointer;
		color:navy;
		background-image:url('#SESSION.root#/Images/toggle_down.png');
		background-position:center left; 
		background-repeat:no-repeat;
	}
	
</style>

	<script language="JavaScript">		  
		  	
	  function dochange(pid,ptid,charged,service) {
	        _cf_loadingtexthtml="";		
			ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/charges/ChargesUsageDetailApply.cfm?mission=#url.mission#&scope=clearance&action=update&id='+pid+'&charged='+charged+'&serviceitem='+service,'applystatus');	
			_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy10.gif'/>";	
	  }

	  function printme(service) {
	    printWin = window.open("#SESSION.root#/workorder/application/workorder/servicedetails/charges/ChargesUsageApproval.cfm?mission=#url.mission#&scope=approval&print=1&serviceitem="+service,"_blank","left=20, top=20, width=800, height=800, status=yes, toolbar=yes, scrollbars=yes, resizable=yes");
	  	setTimeout('printWin.print()', 2000);
	  }
	  
	
	  function detshow(det) {
			var el = document.getElementById(det);		
			
			if (el.style.display == "none" )		
				el.style.display = "";		
			 else 
				el.style.display = "none";		
		}	 
	</script>

</head>
	
</cfoutput>

<cf_screentop height="100%" html="No" scroll="Yes" jQuery="Yes" busy="busy10.gif">

<cf_LayoutScript>
<cf_MenuScript>

<cfparam name="url.mode"  default="menu">

<cfif url.mode eq "dialog">

	<!--- show in a dialog --->
	
	<table cellspacing="1" cellpadding="1">
	<tr><td>
	
	 <cfquery name="Workorder" datasource="AppsWorkOrder">							
	   SELECT     *
	   FROM       Workorder
       WHERE      WorkorderId = '#url.workorderid#'  
	 </cfquery>	
	
	 <cfset url.serviceitem = workorder.serviceitem>
	 <cfinclude template="../../../Application/WorkOrder/ServiceDetails/Charges/ChargesUsageApproval.cfm">
			
	</td></tr></table>	

<cfelse>

	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

	<cf_layout attributeCollection="#attrib#">		
	
	     <cf_layoutarea 
	          position="left"
	          name="left"  
			  minsize="220"
	          maxsize="220"  
			  size="220"  
			  source="SubmissionLeft.cfm"
			  collapsible = "true" 
			  splitter="true"         
			  overflow = "auto"
			  togglerOpenIcon = "leftarrowgray.png"
			  togglerCloseIcon = "rightarrowgray.png"/>
	
		<cf_layoutarea 
	          position="center"
	          name="centerbox" 
			  size="100%"  			  		       
			  overflow="auto">
			  					
				<cfdiv style="text-align:center;padding-left:4px;padding-top:6px;width:99%;" bind="url:SubmissionTab.cfm?serviceitem=#url.serviceitem#" id="center">				
				
		</cf_layoutarea>	
					  		  		
	</cf_layout>
	
</cfif>	

