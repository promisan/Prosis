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
<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 	  
	   anyUnit           = "No"
	   role              = "'WhsPick'"
	   parameter         = "#url.systemfunctionid#"
	   accesslevel       = "'1','2'"
	   returnvariable    = "globalmission">		


	   
<cfif globalmission neq "GRANTED">
	
	<!--- check access on the level of the mission --->
			
	<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccessList" 
	   role              = "'WhsPick'"
	   mission           = "#url.mission#" 	  		  
	   parameter         = "#url.systemfunctionid#"
	   accesslevel       = "'0','1','2'"
	   returnvariable    = "accesslist">	
		   
</cfif>		


<cfif globalmission neq "GRANTED">
	
	<cfif accesslist.orgunit eq "">
	
		<table width="100%" height="100%" 
		       border="0" 
			   cellspacing="0" 			  
			   cellpadding="0" 
			   align="center">
			   <tr><td align="center" height="40" class="labelid">
			    <font color="FF0000">
					<cf_tl id="Detected a problem with your access to this function"  class="Message">
				</font>
				</td></tr>
		</table>	
		<cfabort>	
	
	</cfif>

</cfif>
      
<cfquery name="DateSummary"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
	 SELECT    TOP 10000000 DATEADD([DAY], DATEDIFF([DAY], 0, TransactionDate), 0) AS TransactionDate,          
			   count(*) as Pending 	 
     FROM      WarehouseBatch B, Warehouse W 	
	 WHERE     B.Mission = '#url.mission#'
	 
	 <cfif globalmission neq "GRANTED">
			   
		   AND     W.MissionOrgUnitId IN
			
			           (					   
		                  SELECT DISTINCT MissionOrgUnitId 
		                  FROM   Organization.dbo.Organization
						  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
					   )	
	 
	 
	 </cfif>								  
	 AND       B.Warehouse = W.Warehouse	 
	 AND       B.ActionStatus  = '0'		 
	 AND       B.BatchNo IN (SELECT TransactionBatchNo 
	                         FROM   ItemTransaction 
							 WHERE  TransactionBatchNo = B.BatchNo)	 
	 GROUP BY  DATEADD([DAY], DATEDIFF([DAY], 0, TransactionDate), 0) 
	 ORDER BY  DATEADD([DAY], DATEDIFF([DAY], 0, TransactionDate), 0)
	 
	 
</cfquery>   


<cfif datesummary.recordcount eq "0">

	<table align="center"><tr><td align="center" class="labelit"><font color="008000"><cf_tl id="There are no transactions pending confirmation"></td></tr></table>

<cfelse>	      
		      
	<cfquery name="WarehouseSummary"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		 
		 SELECT    W.MissionOrgUnitId, 
		           B.Warehouse, 
				   W.WarehouseName, 
				   W.City,
				   B.BatchDescription,
				   count(*) as Pending 	 
	     FROM      WarehouseBatch B, Warehouse W 	
		 WHERE     B.Mission = '#url.mission#'
		 <cfif globalmission neq "GRANTED">
		
			   
			   AND     W.MissionOrgUnitId IN
				
				           (					   
			                  SELECT DISTINCT MissionOrgUnitId 
			                  FROM   Organization.dbo.Organization
							  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
						   )	
		 
		 
		 </cfif>								  
		 AND       B.Warehouse = W.Warehouse	 
		 AND       B.ActionStatus  = '0'		 
		 AND       B.BatchNo IN (SELECT TransactionBatchNo 
		                         FROM   ItemTransaction 
								 WHERE  TransactionBatchNo = B.BatchNo)	 
		 GROUP BY  W.City, B.Warehouse, W.WarehouseName, B.BatchDescription, W.MissionOrgUnitId	 
		 ORDER BY  W.City, B.Warehouse, W.WarehouseName
	</cfquery>
	
	

	
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td colspan="4" align="center">
	
	
	

	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">

	

		<cfchart style = "#chartStyleFile#" format="png"
	     chartheight="120"
	     chartwidth="#url.width-350#"
	     showxgridlines="yes"
	     showygridlines="yes"
	     seriesplacement="default"
	     backgroundcolor="ffffff"
	     databackgroundcolor="FfFfFf"
	     labelformat="number"
	     labelmask="##"                    
	     show3d="no"
	     tipstyle="mouseOver">
		 
		<cfset prior = "">
		 
			<cfchartseries
		             type="bar"
		             datalabelstyle="value"
		             paintstyle="raise"
		             markerstyle="circle"
		             colorlist="silver,yellow,FF8000,red">  
			 
				<cfloop index="itm" list="2,7,14,999">
				
				 <cfset dte = dateAdd("d", -itm,  now())>
				

				 <cfquery name="get" dbtype="query">
						SELECT sum(Pending) as Total
						FROM   DateSummary 
						WHERE  TransactionDate >= #dte# <cfif prior neq "">and TransactionDate < #prior#</cfif>
				 </cfquery>	
				
				 
				 <cfset prior = dte> 
				
				 
				 <cfif get.Total eq "">
				  <cfset val = 0>
				 <cfelse>
				  <cfset val = get.Total>
				 </cfif>
				
				 <cfif itm eq 999>
					<cfset label = "> #p# days">
				 <cfelse>
				    <cfset label = "< #itm# days">
				 </cfif>
				 <cfchartdata item="#label#" value="#val#">
				 
				  <cfset p = itm>
			
				</cfloop>
			
			</cfchartseries>
	
		</cfchart>
	
	</td></tr>
	
	<tr><td class="linedotted" colspan="4"></td></tr>


		
	<cfoutput query="WarehouseSummary" group="city">

	<tr><td style="padding:4px" class="labelmedium">#city#</td></tr>
	
	<cfset row = 0>	

	<cfoutput group="warehouse">
			 		
	    <cfset row = row + 1>
		<cfif row eq "1">
		<tr><td height="2"></td></tr>
		<tr></cfif>
		<td height="14" width="30%" class="labelmedium"
		 valign="top" style="height:15px;padding-top:0px;padding-left:14px">		
		<a href="javascript:document.getElementsByName('mde')[0].checked=true;document.getElementsByName('stat')[0].checked=true;ColdFusion.navigate('#client.root#/Warehouse/Application/Stock/Batch/StockBatchCalendar.cfm?mission=#url.mission#&warehouse=#warehouse#&systemfunctionid=#url.systemfunctionid#&status=0','batchmain')">
		<cfif url.warehouse eq warehouse>	
			<font color="gray">#warehousename#</font>
		<cfelse>		
			<font color="0080FF"><u>#warehousename#</font>
		</cfif>
		</a>
		</td>
		
		<td align="right" width="20%" valign="top" class="labelmedium" style="height:15px;padding-right:10px">
			
			<table width="100%" cellspacing="0" cellpadding="0" align="right">
				<cfoutput>
				<tr class="labelit" style="height:15px;padding-right:10px">
				<td style="padding-left:5px">#BatchDescription#</td> 
				<td align="right">#numberformat(pending,'__')#</td>
				</tr>
				</cfoutput>
			</table>
				
		</td>	
				
		<cfif row eq "2"></tr>
		
		<tr><td colspan="4" class="linedotted"></td></tr>
		
		<cfset row = 0></cfif>
		
	</cfoutput>
	
	</cfoutput>
	
	</table>

</cfif>