
<cfparam name="url.period" default="#year(now())#">
<cfparam name="url.mode"   default="Charges">
	
<!--- identify the PRIMARY edition for this period and check if the edition
is also used for other periods of the SAME mission, then we take
these periods as the basis for the presentation  --->

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Mission
	WHERE     Mission = '#URL.Mission#'	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#URL.Mission#'	
</cfquery>

<cfif url.mode eq "Charges">

	<cfquery name="Charges" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT   sk.ServiceItem, 
		          sk.Currency,
		          MONTH(sk.SelectionDate) AS SelMonth,
				  ROUND(SUM(sk.Amount), 0) AS Charge, 
				  S.Description,
				  C.Description as ServiceClass
		 FROM     skWorkOrderCharges AS sk INNER JOIN
		          ServiceItem AS S ON sk.ServiceItem = S.Code INNER JOIN
				  ServiceItemClass AS C ON C.Code = S.ServiceClass
		 WHERE    WorkOrderId IN (SELECT WorkOrderId 
		                          FROM   WorkOrder 
								  WHERE Mission = '#url.mission#'
								  AND   WorkOrderId = sk.WorkOrderId)
		 AND      YEAR(sk.SelectionDate) = '#url.period#' 
		 AND      sk.GLAccount IS NOT NULL <!--- is billed --->
		 GROUP BY sk.Currency, C.Description, sk.ServiceItem, MONTH(sk.SelectionDate), S.Description
		 ORDER BY sk.Currency,C.Description, sk.ServiceItem, SelMonth
	</cfquery> 

<cfelse>

	<!--- accounts receivables --->

	<cfquery name="Charges" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT     C.Description AS ServiceClass, MONTH(H.DocumentDate) AS SelMonth, S.Description, W.ServiceItem, ROUND(SUM(L.AmountDebit - L.AmountCredit), 2) AS Charge
		FROM         TransactionHeader AS H INNER JOIN
                      TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
                      WorkOrder.dbo.WorkOrder AS W ON H.ReferenceId = W.WorkOrderId INNER JOIN
                      WorkOrder.dbo.ServiceItem AS S ON W.ServiceItem = S.Code INNER JOIN
                      WorkOrder.dbo.ServiceItemClass AS C ON C.Code = S.ServiceClass
		WHERE     YEAR(H.DocumentDate) = '#url.period#' 
		AND       H.Mission = '#url.mission#' 
		AND       L.TransactionSerialNo <> '0'
		GROUP BY  C.Description, S.Description, W.ServiceItem, MONTH(H.DocumentDate)
		ORDER BY  ServiceClass, W.Serviceitem, S.Description, SelMonth 
	
	</cfquery> 


</cfif>

<table width="96%" align="center">
	<tr>
		<td valign="top" width="100%">
			<table width="100%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">

			<tr class="linedotted"><td class="cellcontent">Service</td>
				<cfloop index="mt" from="1" to="12">
				<td style="width:5%" class="linedotted labelsmall" align="right">
				<cfoutput>#left(MonthAsString(mt),3)#</cfoutput>
				</td>
				</cfloop>
				<td style="width:10%" align="right" class="cellcontent">Total</td>
			</tr>
			
			<cfquery name="get" dbtype="query">
				SELECT   DISTINCT ServiceItem,ServiceClass,Description
				FROM     Charges 
				ORDER BY ServiceClass,ServiceItem
			</cfquery> 
			
			<cfoutput query="get" group="ServiceClass">
			
				<tr class="linedotted"><td class="labelmedium" colspan="14" style="height:16;padding-left:5px"><b>#ServiceClass#</td></tr>
			
				<cfoutput>
				
					<tr class="navigation_row linedotted"><td class="labelit" style="height:16;padding-left:10px">#Description#</td>
				
					<cfloop index="mt" from="1" to="12">	
						
						<cfquery name="getamount" dbtype="query">
							SELECT   Charge
							FROM     Charges 
							WHERE    ServiceItem = '#get.serviceitem#'
							AND      SelMonth = #mt#			
						</cfquery> 	
				
						<td class="labelit" align="right" style="padding-left:2px;padding-right:1px;width:35">
						<cfif getAmount.charge neq "">
						#numberformat(getAmount.charge/1000,",._")#
						</cfif>
						</td>
				
					</cfloop>
						
					<cfquery name="getamount" dbtype="query">
						SELECT   SUM(Charge) as Total
						FROM     Charges 
						WHERE    ServiceItem = '#get.serviceitem#'						
					</cfquery> 	
					
					<td align="right" style="border-left:1px dotted silver" class="labelit" bgcolor="e1e1e1">
						<cfif getAmount.total neq "">#numberformat(getAmount.total/1000,",._")#</cfif>
					</td>
					
					</tr>
				
				</cfoutput>
				
				</cfoutput>
			
				<tr><td colspan="13" class="line"></td></tr>
				
				<tr>
				   
				   <td style="padding-left:10px" bgcolor="e1e1e1" class="cellcontent"><b>Total</td>
				   
				   <cfoutput>
				   
				   <cfloop index="mt" from="1" to="12">	
						
						<cfquery name="getamount" dbtype="query">
							SELECT   SUM(Charge) as Total
							FROM     Charges 
							WHERE    SelMonth = #mt#			
						</cfquery> 	
				
						<td class="linedotted label" bgcolor="e1e1e1" align="right" style="padding-left:2px;padding-right:2px;width:35">
						<cfif getAmount.total eq "">
						<cfelse>
						#numberformat(getAmount.Total/1000,",._")#
						</cfif>
						</td>
				
				   </cfloop>
					
				   <cfquery name="getamount" dbtype="query">
						SELECT   SUM(Charge) as Total
						FROM     Charges 									
				   </cfquery> 	
					
					<td align="right" bgcolor="ffffaf" class="linedotted labelmedium" style="border:1px solid silver">
						<cfif getAmount.total neq "">
						#numberformat(getAmount.total/1000,",._")#
						</cfif>
					</td>	
				
				  </cfoutput>	
				   
				</tr>
			</table>	
		</td>
		<td style="border:0px solid silver; display:none;" valign="top" align="center" class="clsGraphContainerWorkOrder clsNoPrint">
			<table width="100%" align="center">
				<tr><td style="height:100;padding-left:10px" colspan="15" align="left">
	 
					  <cfquery name="Summary" dbtype="query">
						  SELECT     SUM(Charge) as Total, 
						            ServiceClass
						  FROM       Charges
						  GROUP BY   ServiceClass
					  </cfquery>	
					  		
					  <cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
					  
						<cfchart style = "#chartStyleFile#" format="png"
						       chartheight="450" 
							   chartwidth="450" 
						       showygridlines="yes"		   
						       seriesplacement="default"	  
						       show3d="no"
							   fontsize="12"
							   font="Verdana"
							   showlegend="yes"	  
							   tipstyle="mouseOver"
						       tipbgcolor="E9E9D1"
							   pieslicestyle="solid"
							   showxgridlines="yes"
						       sortxaxis="no">	
												
							   <cfchartseries
					             type="pie"
					             query="Summary"				 
					             itemcolumn="ServiceClass"
					             valuecolumn="Total"
					             serieslabel="Year"
					             paintstyle="raise"
							     colorlist="red,yellow,##66CC66,##999999,##FFFF99,##9966FF,##FF7777,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA"		
					             markerstyle="circle">
								 
							   </cfchartseries>			
								 
						</cfchart>
						
				</td></tr>
			</table>
		</td>
		<cfoutput>
		<cf_tl id="Toggle Graph" var="1">
		<td align="center" class="clsNoPrint" style="width:50px; background-color:##EDEDED; cursor:pointer;" title="#lt_text#" onclick="$('.clsGraphContainerWorkOrder').toggle(); if($('.clsGraphContainerWorkOrder').is(':visible')){ $('.twistieGraphWO').attr('src','#session.root#/Images/HTML5/Gray/right.png'); }else{ $('.twistieGraphWO').attr('src','#session.root#/Images/HTML5/Gray/left.png'); };">
			<img class="twistieGraphWO" src="#session.root#/Images/HTML5/Gray/left.png" height="25px">
		</td>
		</cfoutput>
	</tr>
</table>



<cfset ajaxonload("doHighlight")>

