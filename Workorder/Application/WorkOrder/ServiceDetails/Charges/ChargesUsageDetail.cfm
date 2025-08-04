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
<!--- Charges this month --->

<cfparam name="url.scope"             default= "standard">
<cfparam name="url.Year"              default= "2010">
<cfparam name="url.Mode"              default= "">
<cfparam name="url.Month"             default= "3">
<cfparam name="url.Day"               default= "0">
<cfparam name="url.Reference"         default= "undefined">
<cfparam name="url.CallDirection"     default="">
<cfparam name="url.ServiceItemUnit"   default="">
<cfparam name="url.content"   		  default="">

<cfparam name="url.Reference" default="undefined">

<cfif url.content eq "NonBillable">
	<cfset dbselect = "NonBillable">
<cfelse>
	<cfset dbselect = "">		
</cfif>

<cfif url.scope eq "print">
	
	<cfoutput>
	    <title>Service Statement</title>
		<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
		<link rel="stylesheet" type="text/css"  href="#SESSION.root#/print.css" media="print">
	</cfoutput>
	<cfoutput>
				<cfquery name="Parameter" 
		   				datasource="AppsInit">
		    				SELECT * 
		    				FROM Parameter
		    				WHERE HostName = '#CGI.HTTP_HOST#'
		  			 </cfquery>
			
				<cfif url.print eq "1" and fileExists ("#SESSION.rootpath#custom/logon/#Parameter.ApplicationServer#/printHeader.cfm")>			
					<cfinclude template="../../../../../custom/logon/#Parameter.ApplicationServer#/printHeader.cfm">
				</cfif>
			</cfoutput>	
			
<cfelseif url.scope eq "standard">

    <cfajaximport>

    <cf_screentop height="100%" scroll="Yes" html= "Yes" label="Service Usage" option="Review and tag detailed usage" layout="webapp" banner="gray" JQuery="yes">
   
<cfelse>

   <!--- portal scopes --->

</cfif>  

<cfif url.day gte "1">
	<cfset str = CreateDate(year,month,day)>
	<cfset end = CreateDate(year,month,day)>	
<cfelse>
	<cfset str = CreateDate(year, month, "1")>
	<cfset end = CreateDate(year,month,daysinmonth(str))>	
</cfif>

<cfset end = DateAdd("h","23", end)>
<cfset end = DateAdd("n","59", end)>
<cfset end = DateAdd("s","59", end)>

<cfset Periodstr = Createdate(Year(str),Month(str),1)>
<cfset Periodend = Createdate(Year(end),Month(end),daysinmonth(end))>
<cfset Periodend = DateAdd("h","23", Periodend)>
<cfset Periodend = DateAdd("n","59", Periodend)>
<cfset Periodend = DateAdd("s","59", Periodend)>

<cfoutput>

<cfif url.scope neq "portal">

	<script language="JavaScript">
	
	     function dochange(pid,ptid,charged,woid,wolid,year,month,day,ref,mode,pstr,pend) {
				ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/ServiceDetails/Charges/ChargesUsageDetailApply.cfm?scope=data&action=update&id='+pid+'&charged='+charged+'&workorderid='+woid+'&workorderline='+wolid+'&year='+year+'&month='+month+'&reference='+ref+'&mode='+mode+'&pstr='+pstr+'&pend='+pend,'applystatus');	
		  }
				
		 function printme(id,line,ref,yr,mt,dy,cnt,dir) { 
		    win = window.open("#SESSION.root#/workorder/application/workorder/servicedetails/charges/ChargesUsageDetail.cfm?scope=print&print=1&workorderid="+id+"&workorderline="+line+"&reference="+ref+"&year="+yr+"&month="+mt+"&day="+dy+"&content="+cnt+"&calldirection="+dir,"_blank","left=20, top=20, width=800, height=800, status=yes, toolbar=no, scrollbars=yes, resizable=yes");	  
		  	setTimeout('win.print()', 2000);
		  }	
		
		function moreunits(bx) {
		
			se   = document.getElementsByName(bx)
			cnt = 0
		    
			if ($('##'+bx+'min').is(':visible')) {
				$('##'+bx+'min').css('display','none');
				$('##'+bx+'exp').css('display','block');
				while (se[cnt]) { se[cnt].className = "hide"; cnt++ }
				// $('.clsUnit'+bx).css('display','none');
			}else{
				$('##'+bx+'min').css('display','block');
				$('##'+bx+'exp').css('display','none');
				while (se[cnt]) { se[cnt].className = "regular"; cnt++ }
				// $('.clsUnit'+bx).css('display','table-row');
			}
									
		}  
	
	</script>

</cfif>

</cfoutput>


<cfquery name="WorkOrder"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 						  
	  SELECT  W.*,
	          C.CustomerName, 
			  R.Description,
			  R.UsageTopicGroup,
			  R.UsageTopicDetail,
			  R.UsageActionClose
	  FROM    Workorder W, Customer C, ServiceItem R
	  WHERE   W.Customerid = C.CustomerId
	  AND     W.ServiceItem = R.Code
	  AND     W.WorkOrderId = '#url.workorderid#'	  	  
</cfquery>	

<cfquery name="WorkOrderLine"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 						  
	  SELECT  *, _name as PersonName
	  FROM    WorkorderLine
	  WHERE   WorkOrderId   = '#url.workorderid#'
	  AND     WorkorderLine = '#url.workorderline#'	  	  
</cfquery>	

<cfquery name="hasPlannedUnits"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 						  
	  SELECT  DISTINCT U.Unit		
	  FROM    WorkOrderLineBillingDetail BD INNER JOIN
              WorkOrderLineBilling B ON BD.WorkOrderId = B.WorkOrderId AND BD.WorkOrderLine = B.WorkOrderLine AND 
              BD.BillingEffective = B.BillingEffective INNER JOIN
              WorkOrderLine L ON B.WorkOrderId = L.WorkOrderId AND B.WorkOrderLine = L.WorkOrderLine INNER JOIN		  
			  ServiceItemUnit U ON BD.ServiceItem = U.ServiceItem AND BD.ServiceItemUnit = U.Unit					  		   
	  WHERE   L.WorkOrderId   = '#url.workorderid#'	 
      AND     L.WorkOrderLine = '#url.workorderline#'
	  UNION	 
	  SELECT  DISTINCT U.Unit
	  FROM    ServiceItemUnit U, Ref_UnitClass R
	  WHERE   U.ServiceItem = '#workorder.serviceitem#' 
	  AND     R.Code        = U.UnitClass
	  AND     R.isPlanned   = 1  <!--- even if not in provisionin = 0, it is considered as planned --->			  	  
</cfquery>	


<!--- get a lits of all items to be shown under planned --->
<cfset plannedunits = quotedvaluelist(hasPlannedUnits.unit)>

<cfquery name="Person"
   datasource="AppsEmployee"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 						  
	  SELECT   *
	  FROM    Person
	  WHERE   Personno  = '#workorderline.personno#' 	  
</cfquery>	

<cfquery name="TopicList" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  R.*
     FROM    Ref_Topic R INNER JOIN Ref_TopicServiceItem S ON R.Code = S.Code
	 WHERE 	 TopicClass = 'Usage'
	 AND	 R.Operational = 1
	 AND	 S.ServiceItem = (
			 	SELECT  ServiceItem 
				FROM    WorkOrder 
				WHERE 	WorkorderId = '#url.workorderID#')
	ORDER BY R.ListingOrder
</cfquery>

<cfquery name="ServiceItemDomain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ServiceItemDomain
	WHERE	Code = (SELECT ServiceDomain FROM ServiceItem WHERE Code = '#WorkOrder.ServiceItem#')
</cfquery>

<cfquery name="ServiceItemMission" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	ISNULL(DatePortalProcessing,convert(datetime,'01/01/1900',101)) as DatePortalProcessing,
			ISNULL(DatePostingCalculate,convert(datetime,'01/01/1900',101)) as DatePostingCalculate
	FROM 	ServiceItemMission
	WHERE	ServiceItem = '#WorkOrder.ServiceItem#'
	AND Mission = (
		SELECT TOP 1 Mission 
		FROM WorkOrder 
		WHERE WorkOrderId = '#url.workorderID#')
</cfquery>

<cfset topicCount = 0>

<cfinclude template="ChargesUsageDetailData.cfm">
