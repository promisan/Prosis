
<!--- filter by owner of the position --->

<cfparam name="url.orgunit" default="">
<cfparam name="url.period"  default="">


<cfif url.orgunit neq "">

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
		
</cfif>

<cfif url.period eq "">

	<cfquery name="PeriodList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 M.PlanningPeriod, P.DateEffective
		FROM    Ref_MissionPeriod AS M INNER JOIN
	            Program.dbo.Ref_Period AS P ON M.PlanningPeriod = P.Period
		WHERE   M.Mission = '#url.mission#' 
		AND     P.DateEffective < GETDATE() 		
		ORDER BY P.DateEffective DESC	
	</cfquery>	
	
	<cfset url.period = PeriodList.PlanningPeriod>

</cfif>

<cfquery name="getObligation" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
	 
	    SELECT     C.Description, 
		           I.EntryClass, 
				   COUNT(*) AS Lines, 
				   ROUND(SUM(P.OrderAmountBase / 1000), 1) AS Amount, 
				   C.ListingOrder
		FROM       RequisitionLine AS R INNER JOIN
                   PurchaseLine AS P ON R.RequisitionNo = P.RequisitionNo INNER JOIN
                   ItemMaster AS I ON R.ItemMaster = I.Code INNER JOIN
                   Ref_EntryClass AS C ON I.EntryClass = C.Code
		WHERE      R.Mission = '#url.mission#' 
		<cfif url.orgunit neq "">
		AND       OrgUnit IN (SELECT OrgUnit 
		                      FROM   Organization.dbo.Organization
							  WHERE  Mission   = '#url.mission#'
							  AND    MandateNo = '#get.MandateNo#'
							  AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
							)  
		</cfif>
		AND        R.Period = '#url.period#' 
		AND        R.ActionStatus = '3' 
		AND        P.ActionStatus <> '9'
		AND        P.PurchaseNo NOT IN
                          (SELECT    PurchaseNo
                            FROM     Purchase
                            WHERE    PurchaseNo = P.PurchaseNo
							AND      ActionStatus = '9')
		GROUP BY I.EntryClass, C.Description, C.ListingOrder
		ORDER BY C.ListingOrder	 
</cfquery>	


<table width="100%" class="navigation_table">

<tr>

	<td style="width:6px">&nbsp;&nbsp;</td>
		
	<td width="29%" style="padding:10px">
	
	  <table cellspacing="0" cellpadding="0">
	  	  
	<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ModuleControl
		WHERE    SystemModule = 'Procurement' 
		AND      FunctionClass = 'Application' AND (FunctionName = 'Requisition Management')
	</cfquery>	
	
	 <tr>
	  <cfoutput>
		  <td class="labelit" style="cursor:pointer;padding-left:4px" onclick="loadmodule('#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionView.cfm','#url.mission#','','#get.SystemFunctionid#')">
		  <a><cf_tl id="Open Application"></a></td>
	  </cfoutput>
	  </tr>
	   
	  <tr><td valign="bottom">
	
	  <cfquery name="Summary" dbtype="query">
		  SELECT     SUM(Amount) as Total, 
		             Description, 
					 ListingOrder
		  FROM       getObligation
		  GROUP BY   ListingOrder, Description 
	  </cfquery>	
	
	  <cfset vColorlist = "##D24D57,##52B3D9,##E08283,##E87E04,##81CFE0,##2ABB9B,##5C97BF,##9B59B6,##E08283,##663399,##4DAF7C,##87D37C">
	  <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">

	  <cfchart 
		  style = "#chartStyleFile#" 
	 	  format      = "png"
	      chartheight     = "210"
	      chartwidth      = "520"
		  fontsize        = "13" 	
	      showxgridlines  = "yes"
	      seriesplacement = "default"
	      show3d          = "no">	
								
			   <cfchartseries
	             type="bar"
	             query="Summary"
	             itemcolumn="Description"
	             valuecolumn="Total"
	             serieslabel="Summary"
				 seriescolor = "EB974E"
			     colorlist="#vColorlist#"></cfchartseries>			
				 
		</cfchart>
		
		</td></tr></table>
	
	</td>
	
	<td style="width:7px">&nbsp;</td>
		
		<td width="69%" valign="top">
		
		<table width="100%" align="center">
		
		<tr>
	  <cfoutput>
		  <td  colspan="3" style="cursor:pointer;cursor:pointer" onclick="loadmodule('#SESSION.root#/Portal/Topics/Obligation/Dataset.cfm','#url.mission#','period=#url.period#','#get.SystemFunctionid#','tab')">
		  <table cellspacing="0" cellpadding="0">
		  <tr style="height:50px"><td>
		  	<img src="#session.root#/images/olap_cube.png?id=2" height="40" alt="" border="0">
			</td>
			<td class="labelmedium" style="font-size:17px;padding-left:6px"><a><cf_tl id="Slice and dice"></a></td></tr>
		  </table>
		  </td>
	  </cfoutput>
	  </tr>	  
					
		<tr class="labelmedium" style="background-color:f1f1f1">	
		<td><cf_tl id="Class"></td>	
		<td align="right"><cf_tl id="Lines"></td>
		<td align="right"><cf_tl id="Value"></td>
		</tr>
				
		<cfoutput query="getObligation">				
			<tr class="navigation_row labelmedium">
			  <td style="padding-left:15px">#Description#</td>
			  <td align="right">#Lines#</td>
			  <td align="right" style="padding-right:5px">#numberformat(amount,",._")#</td>
			</tr>
		</cfoutput>	
		
		<cfquery name="Total" dbtype="query">
		  SELECT     SUM(Amount) as Amount, 
		             sum(Lines) as Lines 
		  FROM       getObligation
	    </cfquery>	
		
		<cfoutput>
		<tr class="navigation_row labelmedium" style="background-color:f4f4f4">
			  <td style="padding-left:4px">Total</td>
			  <td align="right">#Total.Lines#</td>
			  <td align="right" style="padding-right:5px">#numberformat(Total.amount,",._")#</td>
		</tr>
		</cfoutput>
			
		</table>
		
		</td>		

</tr>

<tr><td height="5"></td></tr>

<cfset ajaxOnLoad("doHighlight")>

</table>
