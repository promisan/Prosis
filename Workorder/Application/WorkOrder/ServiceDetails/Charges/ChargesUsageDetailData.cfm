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
<cfparam name="url.id"              default="muc">
<cfparam name="url.workorderlineid" default="">

<cfquery name="GetClass"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">	

	SELECT *
	FROM   Ref_ServiceItemDomainClass
	WHERE  ServiceDomain = '#workorderline.ServiceDomain#'
	AND    Code          = '#workorderline.ServiceDomainClass#'
	   
</cfquery>	  

<cfif GetClass.recordcount eq "0">
	<cfset venableMarking = "1">
<cfelse>
	<cfset venableMarking = GetClass.ChargeTagging>	
</cfif>

<!--- the query string for return/refresh feature --->

<cfoutput>

	<input type="hidden" 
	    id="templatequerystring" 
		name="templatequerystring"  
		value="content=#url.content#&workorderlineid=#url.workorderlineid#&year=#url.year#&month=#url.month#&reference=#url.reference#&calldirection=#url.calldirection#">
		
</cfoutput>

<!--- ------------------------------------------- --->
<!--- feature to set all transactions as personal --->
<!--- ------------------------------------------- --->


<cfoutput>

    <!--- retrieve the usage for this line --->	
			
	<cfquery name="UsageList"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">	 						  
		  SELECT     BD.WorkOrderId,
		  			 BD.WorkOrderLine,
		             BD.TransactionId,
					 BD.TransactionDate, 	
		             BD.ServiceItem, 
					 L.UnitDescription,
				     BD.ServiceItemUnit, 		
					 BD.Reference,			  
				     BD.Currency, 
					 BD.Quantity,
					 BD.Rate,	
					 BD.ServiceUsageSerialNo,				 		
					 BD.DetailMemo,
					 C.Description as UnitClass,
					 ISNULL(LabelQuantity ,'Qty') as LabelQuantity,
					 ISNULL(LabelCurrency,'Currency') as LabelCurrency,
					 ISNULL(LabelRate,'Rate') as LabelRate,
					 L.PresentationMode,
					
					<cfloop query="TopicList">			
					  <cfset fld = replace(description," ","","ALL")>
					  <cfset fld = replace(fld,".","","ALL")>
					  <cfset fld = replace(fld,",","","ALL")>
					  <cfset topicCount = topicCount + 1>
						(SELECT TopicValue FROM WorkOrderLineDetailTopic#dbselect# WHERE TransactionId = BD.TransactionId AND Topic = '#code#') 
						as #fld#,						
					</cfloop>
								 			 
				     BD.Amount,
					 
					 ISNULL((SELECT EnablePortalProcessing 
					         FROM   ServiceItemMissionPosting MP 
							 WHERE  MP.Mission     = W.Mission 
							 AND    MP.ServiceItem = BD.ServiceItem 
					 		 AND    Year(SelectionDateExpiration)  = Year(BD.TransactionDate) 
							 AND    Month(SelectionDateExpiration) = Month(BD.TransactionDate)),0) as EnablePortalProcessing,
					
					 DU.ReferenceAlias
		
		   FROM      ServiceItemUnit L INNER JOIN
	                 WorkOrderLineDetail#dbselect# BD ON L.ServiceItem = BD.ServiceItem AND L.Unit = BD.ServiceItemUnit INNER JOIN
					 Ref_UnitClass C ON L.UnitClass = C.Code INNER JOIN 
					 WorkOrder W ON BD.WorkOrderId = W.WorkOrderId LEFT OUTER JOIN 
					 WorkOrderLineDetailUser DU ON BD.WorkOrderId = DU.WorkOrderId AND BD.WorkOrderLine = DU.WorkOrderLine AND BD.Reference = DU.Reference
		   WHERE     BD.WorkOrderId      = '#url.workorderid#'			   	   	   
	       AND       BD.WorkOrderLine    = '#url.workorderline#'	
		   AND       BD.TransactionDate  >= #str#	 
		   AND       BD.TransactionDate  < #end#	
		   
		   <cfif dbselect eq "">	
		   
		   <!--- 28/3 exclude actionstatus = 9 --->		   
		   AND      BD.ActionStatus != '9'
		   
		   </cfif>

		   <!--- --------------------------------------------------- --->
		   <!--- special code to be reviewed as it is more for calls --->	
		   <!--- --------------------------------------------------- --->
				   		   
		   <cfif url.reference neq "" and url.reference neq "undefined">		
		   					
				AND     BD.Reference      = '#url.reference#'		
							
			<cfelseif url.reference eq "" and url.calldirection eq "">
										
			    <!--- add to filter in the portal, to be checked --->
								
				AND (BD.Reference = '' or BD.Reference is NULL or BD.Reference = '#workorderline.reference#')	
				
			<cfelseif url.calldirection neq "">
															
			  	AND EXISTS (
							SELECT *
							FROM   WorkorderLineDetailTopic#dbselect# T
							WHERE  BD.TransactionId = T.TransactionId							
							AND    Topic      = '#workorder.UsageTopicGroup#'
							AND    TopicValue = '#url.Calldirection#')	
				
									
		   </cfif> 	
		   
		   <!--- ----------------------------------------------------------------------------- --->
		   <!--- special provision to assign something to the correct unit based on the amount --->
		   <!--- ----------------------------------------------------------------------------- --->
		 
		   <cfif url.mode eq "" or url.mode eq "all">		   		   
		  		
		   <cfelseif url.mode eq "planned">	  
		    
		   		AND		(
				        L.Unit IN (#preservesinglequotes(plannedunits)#)
				        AND (BD.Amount > L.ThresholdProvision OR BD.Reference = '')							
						)
												
			
				
		   <cfelseif url.mode eq "unplanned">	
		   		   		   		  
		        AND		(
				        L.Unit NOT IN (#preservesinglequotes(plannedunits)#)	
				        OR
						BD.Amount <= L.ThresholdProvision		
						)
					
		   </cfif>				   
		   		  		  		   
		   <cfif url.ServiceItemUnit neq "">
		   		AND		BD.ServiceItemUnit = '#url.ServiceItemUnit#'
		   </cfif>
		  		   	   	    	  
		   ORDER BY  C.ListingOrder, 
		             L.ListingOrder, 
					 BD.ServiceItemUnit, 
					 BD.TransactionDate 	
		     	  
	</cfquery>	
			
	<!--- retrieve the tagging as already recorded in an internal view to be used --->
		
	<cfquery name="ChargesBase"
	     datasource="AppsWorkOrder"
	     username="#SESSION.login#"
	     password="#SESSION.dbpw#">
	  	 	SELECT Reference,
			       ServiceitemUnit,
				   TransactionDate,
				   Charged
			FROM   WorkOrderLineDetailCharge 
			<cfif url.workorderid neq "">
			WHERE  WorkOrderId     = '#url.WorkOrderId#'
			AND    WorkOrderLine   = '#url.WorkOrderLine#'					
			AND    TransactionDate >= #str#	 
		    AND    TransactionDate < #end#	
			<cfelse>
			WHERE 1 = 0
			</cfif>		
	</cfquery>
	
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
		
	<!--- retrieve the last closing for this line --->
	
	<cfquery name="PriorClosing"
	     datasource="AppsWorkOrder"
	     username="#SESSION.login#"
	     password="#SESSION.dbpw#">
	  	 	SELECT TOP 1 * 
			FROM   WorkOrderLineAction 			
			WHERE  WorkOrderId     = '#url.WorkOrderId#'
			AND    WorkOrderLine   = '#url.WorkOrderLine#'	
			AND    ActionClass     = '#workorder.UsageActionClose#'	
			AND	   ActionStatus <> '9'
			ORDER BY Created DESC			
	</cfquery>	
	
<!--- capture the transactions shown in this list --->

<form method="post"
      name="transactionform"
      id="transactionform" class="clsPrintContent">
	  
	
<!--- ------------------------------------------- --->
<!--- ------------------------------------------- --->
<!--- ------------------------------------------- --->

<table width="98%" cellspacing="0" border="0" cellpadding="0" align="center" class="navigation_table" navigationhover="##c4e1ff" navigationselected="##cccccc">	

    <cfif url.scope neq "summary"> 
	
	<cfset sel     = CreateDate(url.year,url.month,1)>
	<cfset selend  = CreateDate(Year(sel),Month(sel),DaysInMonth(sel))>
	
	<tr>
	 	<td colspan="#TopicCount+6#" class="labellarge">#workorder.description#</td>
		
		<cfif url.scope neq "print">
	 	<td align="right" colspan="1" class="clsNoPrint">
			<!--- <cf_print mode="hyperlink"> --->	
			<cfoutput>
			<span id="printTitle" style="display:none;"><cf_tl id="Pending Charges">: #workorder.description# - #Person.FirstName# #Person.LastName#</span>
			</cfoutput>
			<cf_tl id="Print" var="1">
			<cf_button2 
				mode		= "icon"
				type		= "Print"
				title       = "#lt_text#" 
				id          = "Print"					
				height		= "30px"
				width		= "35px"
				printTitle	= "##printTitle"
				printContent = ".clsPrintContent"
				printCallback = "$('._clsLayoutArea').css('display','table-row');">		
		</td>
		</cfif>
	</tr>	
	
	</cfif>
		
		<cfif url.scope neq "summary">
		
			<tr><td colspan="#TopicCount+7#" class="line"></td></tr>		
			<tr><td colspan="#TopicCount+7#" height="80" style="padding-top:0px">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
						
				<tr>
					<td colspan="2" align="center">

					</td>
					
					<td width="60%" rowspan="5" valign="middle" align="center" id="applystatus">						
						<cfinclude template="ChargesUsageDetailDataApplied.cfm">			
					</td>
				</tr>
				
				
				<tr>					
				    <td colspan="2" class="labellarge">#workorder.customerName#</td>
				</tr>

				<cfif url.scope neq "Process" or url.scope eq "print">
					<cfif Person.lastname neq ""> 
					<tr>						
					    <td colspan="2" class="labellarge">#Person.FirstName# #Person.LastName#</b></td>
					</tr>	
					<cfelseif WorkorderLine.PersonName neq "">
					<tr>						
					    <td colspan="2" class="labellarge">#WorkorderLine.PersonName#</b></td>
					</tr>	
					</cfif>
					
				</cfif>							
				
				
					
				<tr>					
					<td colspan="2" class="labelmedium" style="padding-left:3px">
					 #dateformat(sel,CLIENT.DateFormatShow)# - #dateformat(selend,CLIENT.DateFormatShow)#   	   
					</td>					
				</tr>
				
				<tr>
					<td height="1" style="padding-left:5px" class="labelit">#ServiceItemDomain.Description#: </td>
					<td style="font-size:35px" class="labelmedium"><b>
					 <cf_stringtoformat value="#workorderline.reference#" format="#ServiceItemDomain.DisplayFormat#">	
					#val#</b>	   
					</td>
					
				</tr>

				
				</table>
				
			</td>
			</tr>
			
		</cfif>
			
</cfoutput>

<cfset pointer = "0">

<cfoutput query="UsageList" group="UnitClass">
	
	<cfoutput group="ServiceItemUnit">
	
	   <cfset prior = "">
	    
		<tr class="line">		  
		  
		  <cfif url.scope eq "standard">
		  
			  <td colspan="#TopicCount+6#" height="20" onClick="moreunits('u#serviceitemunit#')" style="padding:3px;cursor:pointer;">
			 
				  <table cellspacing="0" cellpadding="0">
				  	<tr>
						<td>
							<img src="#SESSION.root#/Images/arrowright.gif" alt="More details" 
								id="u#serviceitemunit#exp"  border="0" class="show" 
								align="absmiddle">
						</td>
						<td>
							 <img src="#SESSION.root#/Images/arrowdown.gif" 
								id="u#serviceitemunit#min"  alt="More details" border="0" 
								align="absmiddle" class="hide">
						</td>			
											
					  <td class="labelmedium" style="padding-left:20px"><font color="0080C0">#UnitDescription# </td>		
				   </tr>	
		  	    </table>
			   
			   </td>	
				
			   <cfset cl = "hide">
				
		  <cfelse>
		  
		  	   <cfset cl = "regular">		  
		       <td colspan="#TopicCount+5#" class="labelmedium" height="40" style="padding:3px">#UnitDescription#</td>
		 		  		  
		  </cfif>			  
			
			<cfquery name="getUsageLabel"
			   datasource="AppsWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#"> 						  
				  SELECT    ISNULL(LabelCurrency,'$')   as LabelCurrency,
				            ISNULL(LabelQuantity,'Qty') as LabelQuantity,	
					        ISNULL(LabelRate,'Rate')    as LabelRate			
				  FROM      ServiceItemUnit L INNER JOIN
							Ref_UnitClass C ON L.UnitClass = C.Code	 	  	  
				  WHERE     ServiceItem     = '#workorder.ServiceItem#'		
				  AND       Unit            = '#serviceitemunit#'	  
			</cfquery>	
						
			<cfquery name="Total" dbtype="query">
					SELECT  SUM(amount) as Total 
					FROM    UsageList 
					WHERE   ServiceItemUnit = '#ServiceItemUnit#'					
			</cfquery>		
					
		    <td colspan="2" align="right" style="padding-right:4px" class="labelmedium">
				#getUsageLabel.LabelCurrency#&nbsp;#numberformat(total.total,",__.__")#
			</td>
			
		</tr>					
      
		<tr name="u#serviceitemunit#" id="u#serviceitemunit#" class="#cl# clsUnitu#serviceitemunit# labelmedium">
		
			<td width="4%" style="padding-left:15px"></td>	
			
			<cfif PresentationMode eq "Detail">
						  
			   <td width="7%" style="padding-left:3px"><font color="3d3d3d"><cf_tl id="Time"></b></font></td>		   
			   <td width="13%" height="20"><font color="3d3d3d"><cf_tl id="To / From"></b></strong></td>
			   
				<cfloop query="TopicList">
				   	<td width="10%" style="padding-left:2px" class="labelit"><font color="3d3d3d">#TopicList.description#</b></font></td>
				</cfloop>  			
				<td width="6%" align="center" class="labelit" style="padding-left:2px"><font color="3d3d3d">#getUsageLabel.LabelQuantity#</b></font></td>
			
			<cfelse>
			
				<td width="30%" colspan="#TopicCount+3#"></td>
			
			</cfif>
			 			
			<td width="10%" align="right" style="padding-left:2px;padding-right:2px"><font color="3d3d3d">#getUsageLabel.LabelRate#</td>
			<td width="10%" align="right" style="padding-left:2px;padding-right:2px"><font color="3d3d3d"><cf_tl id="Amount">&nbsp;#getUsageLabel.LabelCurrency#</td>		
			
			<td width="3%" align="center">
			     	<table cellspacing="0" cellpadding="0" width="60" align="right">
						<tr class="labelmedium"><td align="center" ><cf_UIToolTip tooltip="Business">&nbsp;<font color="3d3d3d"><b>B</b></font></cf_UIToolTip></td>
						    <td align="center" style="padding-right:3px"><cf_UIToolTip tooltip="Personal"><font color="3d3d3d">P</font>&nbsp;</cf_UIToolTip></td>
						 </tr>
					</table>
			</td>		
			     
		</tr>				
				
		<tr name="u#serviceitemunit#" id="u#serviceitemunit#" class="#cl# clsUnitu#serviceitemunit#">
		     <td colspan="#TopicCount+7#" height="1"></td>
		</tr>
		
		<cfoutput>						
						
			<cfif url.day eq "0" or url.day eq "">

				<cfif prior neq dateformat(TransactionDate,CLIENT.DateFormatShow)>
				
				<!--- <tr name="u#serviceitemunit#" class="#cl# clsUnitu#serviceitemunit#" > --->
				<tr name="u#serviceitemunit#" class="clsUnitu#serviceitemunit# line" >
				<td colspan="#TopicCount+7#" style="padding-left:25px" class="labelmedium line">
				#dateformat(TransactionDate,CLIENT.DateFormatShow)# </b>#dateformat(TransactionDate,"DDDD")#
				<cfset prior = dateformat(TransactionDate,CLIENT.DateFormatShow)>					
				</td>
				</tr>	
											
				</cfif>			
			
			</cfif>
			
			<tr name="u#serviceitemunit#" id="u#serviceitemunit#" class="#cl# clsUnitu#serviceitemunit# navigation_row labelit line" style="height:14px">
			
			<!--- get the tagging for this item --->
			
			<cfquery name="Charges" dbtype="query">
					SELECT * 
					FROM   ChargesBase 
					WHERE  ServiceItemUnit = '#ServiceItemUnit#'
					AND    Reference       = '#Reference#'
					AND    TransactionDate = '#TransactionDate#'
			</cfquery>		
						
			<td width="4%" style="padding-left:30px"></td>
			
			<cfif PresentationMode eq "Detail">
			
				<td style="padding-left:9px;padding-right:3px">#TimeFormat(TransactionDate, "HH:mm")#</b></td>
				<cfif ReferenceAlias neq "" and url.scope eq "portal">
					<td title="#Reference#">#ReferenceAlias# 
				<cfelse>
					<td>#Reference#
				</cfif>
				</td>
					
				<cfloop query="TopicList">
					
					<cfset vTopic = replace(description," ","","ALL")>
					<cfset vTopic = replace(vTopic,".","","ALL")>
					<cfset vTopic = replace(vTopic,",","","ALL")>				
					<cfset val    = evaluate("UsageList.#vTopic#")>									
					<td width="10%" style="padding-left:2px">#val#</td>				
								
				</cfloop>   
				
				<td align="center">#numberformat(quantity)#</td>
				
			<cfelse>
			
				<td style="padding-left:5px">#DetailMemo#</td>
				<td colspan="#TopicCount+2#"></td>					
				
			</cfif>
			
			<td align="right">#numberformat(rate,",.__")#</td>
			<td align="right" style="padding-right:5px">#numberformat(amount,",.__")#</td>		
											
			<cfif getAdministrator(workorder.mission) eq "1" or client.personno eq workorderline.personno>			
				 <cfset access = "edit">
			<cfelse>
			     <cfset access = "view">
			</cfif>	 		
				
			<!--- disable tagging if this is
			     a print or a load from the backoffice or a determined view
				 a service for which tagging is disabled
				 a detail record which date lies before the portal start date
				 a detail usage record referring to a load for which the user already performed a closing 
				 a device with a Service Domain Class that indicates no tagging allowed -- 2013-01-22 JDiaz (provision for Custodians)
			--->
							 
			<cfif url.scope neq "portal" or 				
				 access eq "view" or 
				 EnablePortalProcessing eq "0" or 
				 TransactionDate lt ServiceItemMission.DatePortalProcessing or
				 PriorClosing.SerialNo gte ServiceUsageSerialNo or
				 venableMarking eq "0" or
				 TransactionDate lt ServiceItemMission.DatePostingCalculate>
													
			   <!--- also disable at a certain point once the user confirms --->
						
			    <td align="right" style="padding-left:7px;padding-right:11px">
				
					<table cellpadding="0" align="right" width="40">
					<tr>					
					<td align="center" width="20" style="border: 1px solid silver"><cf_space spaces="5">
						<cfif Charges.Charged neq "2" ><img src="#SESSION.root#/images/check_mark.gif" alt="Business" height="12" border="0" style="display:block"></cfif>
					</td>					
				    <td align="center" align="center" width="20" style="border: 1px solid silver">
						<cf_space spaces="5">
						<cfif Charges.Charged eq "2" ><img src="#SESSION.root#/images/check_mark.gif" alt="Personal" height="12" border="0" style="display:block"></cfif>
					</td>					
					<td class="hide" id="b#transactionid#" style="border: 1px solid silver"></td>					
					</tr>
					</table>
				
				</td>					
			
			<cfelse>
			
    			<cfif Amount neq "0">
				    <cfset pointer = "1">
				</CFIF>
										
				<td align="right" style="padding-left:7px;">					
				
					<table cellspacing="0"  cellpadding="0" align="right" height="20" width="60px">
					<tr>
					<td bgcolor="ffffdf" align="center" width="35px" valign="middle" style="border: 0px solid silver">
					<input name="source_#currentrow#" id="chk_#transactionid#_1" style="height:16px;width:16px;padding:0px"  title="Business" type="radio" <cfif Charges.Charged neq "2" >checked</cfif> <cfif Amount eq "0" >disabled</cfif> onclick="dochange('#TransactionId#','#Transactionid#','1','#url.workorderid#','#url.workorderline#','#url.year#','#url.month#','0','#url.reference#','#url.calldirection#','#url.mode#')">
					</td>
				    <td align="center" height="15" bgcolor="eaeaea" align="center" width="35px" valign="middle" style="border: 0px solid silver">
					<input name="source_#currentrow#" id="chk_#transactionid#_2" style="height:16px;width:16px;padding:0px"  title="Personal" type="radio" <cfif Charges.Charged eq "2">checked</cfif> <cfif Amount eq "0" >disabled</cfif> onclick="dochange('#TransactionId#','#Transactionid#','2','#url.workorderid#','#url.workorderline#','#url.year#','#url.month#','0','#url.reference#','#url.calldirection#','#url.mode#')">
					</td>
					<td class="hide" id="b#transactionid#" style="border: 1px solid silver"></td>
					</tr>
					</table>
				</td>
				
			</cfif>				
												  
			</tr>		
							
		</cfoutput>				
				
	</cfoutput>
</cfoutput>

<cfoutput>

<cfif url.scope eq "portal" and pointer eq "1">


	<tr>
		<td colspan="#TopicCount+7#" align="center" style="border-top:1px dotted silver; padding-top:6px;border-bottom:1px dotted silver; padding-bottom:6px" class="clsNoPrint">	
			<table cellspacing="0" cellpadding="0" align="center">
				<tr>
					
					<td>
					
					<input type="button" name="xxx" value="Set all as BUSINESS" style="font-size:13px;height:29px;width:200" class="button10s" onclick="dochangebatch('1','#url.workorderid#','#url.workorderline#','#url.year#','#url.month#','0','#url.reference#','#url.calldirection#','#url.mode#')">
											
					</td>
					<td width="10px"></td>
					
					<td>
					
					<input type="button" name="xxx" value="Set all as PERSONAL" style="font-size:13px;height:29px;width:200" class="button10s" onclick="dochangebatch('2','#url.workorderid#','#url.workorderline#','#url.year#','#url.month#','0','#url.reference#','#url.calldirection#','#url.mode#')">
											
					</td>
					<td width="10px"></td>
					
					<td>
					
					<!--- <cfset func1 = "parent.menuselect('menu2')">
					<cfset func2 = "parent.goToBalance('#SESSION.root#/Workorder/Portal/User/ServiceOpen.cfm?template=submission/menuSubmission.cfm&mission=#url.mission#&webapp=#url.id#')"> --->
					<cfset func1 = "parent.parent._goToNextTab(true);">
					<cfset func2 = "">
					
					<cfset client.serviceitem = "#usagelist.serviceitem#">
					
					<input type="button" name="xxx" value="APPROVE transactions" style="font-size:13px;height:29px;width:200" class="button10s" onclick="#func1#; #func2#;">
												
					</td>	 	
				</tr>
			</table>		
		</td>
	</tr>
</cfif>

</cfoutput>

<tr><td>
	<input type="hidden" name="transactionlistcontent" id="transactionlistcontent" value="<cfoutput>#ValueList(UsageList.TransactionId)#</cfoutput>">
</td></tr>

</table>

</form>

<cfset ajaxonload("doHighlight")>



