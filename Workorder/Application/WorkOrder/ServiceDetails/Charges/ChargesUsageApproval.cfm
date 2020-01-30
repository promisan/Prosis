
<cfparam name="url.mode"    default="Portal">
<cfparam name="url.mission" default="">
<cfparam name="url.print"   default="0">



<cfquery name="WorkorderLine"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 		
   SELECT  C.CustomerName, 
           W.ServiceItem, 
		   WL.Reference, 
		   WL.WorkOrderLine,
		   WL.WorkOrderId,
		   W.Mission
   FROM    WorkOrder AS W INNER JOIN
           WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
           Customer AS C ON W.CustomerId = C.CustomerId		
		   LEFT OUTER JOIN Ref_ServiceItemDomainClass DC ON DC.ServiceDomain = WL.ServiceDomain AND DC.Code = WL.ServiceDomainClass		  
	
   WHERE   W.WorkOrderId IN (SELECT WorkorderId 
		                     FROM   WorkOrder 
						     WHERE  WorkorderId = WL.Workorderid 
							 AND    Mission     = W.Mission
							 AND    ServiceItem = '#url.serviceitem#')
							 
   AND     WL.Personno  = '#client.personno#' 
   AND     WL.Operational = 1
   <!--- saveguard --->
   AND     (DateExpiration is NULL or DateExpiration > getdate()-50) 	  		
   AND ((DC.ChargeTagging IS NULL ) OR (DC.ChargeTagging ='1')) 	<!--- 2013-01-22 Disable Custodian devices for approval --->						  
</cfquery>	

<cfif url.mission eq "">
	<cfset url.mission = WorkOrderline.Mission>
</cfif>

<cfquery name="getAction"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
    SELECT * 
	FROM   ServiceItem 
	WHERE  Code = '#url.serviceitem#'
</cfquery>	

<cfif getAction.UsageActionClose eq "">

	<table width="100%"><tr><td align="center" height="80">
	<font face="Verdana" size="3" color="#eeeeee">Closing facility is not configured for this service</td></tr>
	</table>
		
<cfelse>

	<!--- --------------------------------------------------------------------- --->
	<!--- --------------------------------------------------------------------- --->
	<!--- create initial entry in WorkOrderlIneAction if not closing is entered --->
	<!--- --------------------------------------------------------------------- --->

	<cfloop query="workorderline">
		
		<!--- check --->
		
		<cfquery name="check"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#"> 		
		   SELECT  *
		   FROM    WorkOrderLineAction	  	
		   WHERE   WorkOrderId   = '#workorderid#'
		   AND     WorkOrderLine = '#workorderline#'
		   AND     ActionClass   = '#getAction.UsageActionClose#'	
		   AND	   ActionStatus <> '9'   
		</cfquery>
		
		<cfif check.recordcount eq "0">
			<!--- JDiaz 2012-03-23 Code below disabled. ActionStatus is no longer vaid.  Instead insert record with serialNo=0 
				if no closing record found for this workorderid and line --->
								
			<cfquery name="insert"
			   datasource="AppsWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">
			   INSERT INTO WorkOrderLineAction
			   (WorkOrderId,WorkOrderLine,ActionClass,SerialNo,DateTimePlanning,OfficerUserId,OfficerLastName,OfficerFirstName)
			   VALUES
			   ('#workorderid#',
			    '#workorderline#',
				'#getAction.UsageActionClose#',
				0,
				'01/01/2000',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')		
		    </cfquery>
		
		</cfif>   
	 
	</cfloop>

	<!--- ----------------------------------------------------------------------- --->
	<!--- ------------------------END SAFEGUARD---------------------------------- --->
	<!--- ----------------------------------------------------------------------- --->

	<cfquery name="Person"
	   datasource="AppsEmployee"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#"> 						  
		  SELECT   *
		  FROM    Person
		  WHERE   Personno  = '#client.personno#' 	  
	</cfquery>	
	
	<cfquery name="TopicList" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  R.*
	     FROM    Ref_Topic R INNER JOIN Ref_TopicServiceItem S ON R.Code = S.Code
		 WHERE 	 TopicClass = 'Usage'
		 AND	 R.Operational = 1
		 AND	 S.ServiceItem = '#url.serviceitem#'	
	</cfquery>
	
	<cfquery name="ServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ServiceItem
		WHERE	Code = '#url.ServiceItem#'
	</cfquery>
	
	<cfquery name="ServiceItemDomain" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ServiceItemDomain
		WHERE	Code = (SELECT ServiceDomain 
		                FROM   ServiceItem 
						WHERE  Code = '#url.ServiceItem#')
	</cfquery>
			
	<cfset topicCount = TopicList.RecordCount>
	<cfset LineCount = WorkorderLine.RecordCount>
		
	<cfif url.print eq "1">
		
		<cfoutput>
		    <title>Service Statement</title>
			<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 		
			<link rel="stylesheet" type="text/css"  href="#SESSION.root#/print.css" media="print">
		
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
		
	</cfif>	
	
	<table width="98%" cellpadding="0" cellspacing="0" class="clsNoPrint">
		<tr>
			<td align="right" style="padding-right:5px;">
				<cfoutput>
				<span id="printTitle" style="display:none;"><cf_tl id="Pending Charges">: #Person.FirstName# #Person.LastName#</span>
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
		</tr>
	</table>
	
	<table width="100%" cellpadding="0" cellspacing="0" >
	<tr>
	<td style="padding:3px 3px 5px 6px" id="target" name="target">
	
	<table width="98%" cellspacing="0" border="0" cellpadding="0" >
				
	<cfoutput>

		
<!---		
			<td colspan="#TopicCount+7#">
				<table cellpadding="0" cellspacing="0" border="0">
		
					<tr>		
	
								
						<td  style="padding-left:4px">
							<input name="rdApprovalView" id="rdPending"  title="Pending" type="radio"  style="height:20;width:20px" checked value="Pending">
						<td style="padding-left:8px" height="22" class="labellarge"><b>Authorise your PENDING Charges</td>
						</td>
						
						<td  style="padding-left:10px">
							<input name="rdApprovalView" id="rdApproved" title="Approved" style="height:16;width:16px;cursor:pointer" type="radio"  
							  onclick="ColdFusion.navigate('#SESSION.root#/workorder/portal/user/Submission/SubmissionLog.cfm?mission=#workorderline.mission#&serviceitem=#workorderline.serviceitem#&scope=portal','center')" 
							  value="Approved">
						</td>
						
						<td style="padding-left:8px;cursor:pointer" 
							onclick="ColdFusion.navigate('#SESSION.root#/workorder/portal/user/Submission/SubmissionLog.cfm?mission=#workorderline.mission#&serviceitem=#workorderline.serviceitem#&scope=portal','center')" 
							height="22" class="labellarge"><font color="0080C0">Authorised Charges</td>	
							
					</tr>	
					
					<tr><td height="5"></td></tr>
					<tr><td class="line" colspan="4"></td></tr>		
					
				</table>
			</td>
--->			
			
				
			<td colspan="#TopicCount+8#">
			
				<table align="center"  width="100%" style="border:1px solid silver" cellpadding="0" cellspacing="0">
					<tr>
						<td width="15%" style="padding-left:5px" class="labellarge">Service:</td>
						<td width="45%" class="labellarge" style="padding-left:5px;border:1px solid silver"><b>#serviceitem.description#</b></td>
						<td width="40%" class="labellarge" style="padding-left:15px;padding-right:15px;padding-top:10;padding-bottom:10px" bgcolor="c4e1ff" valign="top" id="summary" rowspan="3" valign="top">
							<cfinclude template="ChargesUsageDetailApproval.cfm">
						</td>
					</tr>
					
					<tr>
						<td class="labellarge" style="padding-left:5px">#ServiceItemDomain.Description#:</td>
						<td style="padding-left:5px;border:1px solid silver">
						
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
							
							<tr>
					   		<td class="labellarge" width="40%">
								<cfloop query="workorderline">
								<cf_stringtoformat value="#workorderline.reference#" format="#ServiceItemDomain.DisplayFormat#">#val#<cfif currentrow neq recordcount>&nbps;
								<cfif currentrow eq "4"><br></cfif>
								 </cfif>
								</cfloop>
							</td>
							
							</table>
							
						</td>
					</tr>
					
					<cfif Person.lastname neq ""> 
					<tr>
						<td class="labellarge"style="padding-left:5px" height="18" >Name:</td>
					    <td class="labellarge" style="padding-left:5px;border:1px solid silver"><b>#Person.FirstName# #Person.LastName#</b></td>
					</tr>								
					</cfif>				
				</table>
			</td>
		</tr>
			
	</cfoutput>
<!---	
	<cf_menucontainer item="1" class="regular" iframe="">
	<cf_menucontainer item="1" class="hide" iframe="">
--->		
	<cfquery name="UsageList"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	 						  
		  SELECT     D.WorkOrderId,
		  			 D.WorkOrderLine,
		             D.TransactionId,
					 D.TransactionDate, 	
					 Year(D.TransactionDate) as YearTransaction,
					 Month(D.TransactionDate) as MonthTransaction,
					 left(convert(varchar,D.TransactionDate,112),6)	as BillingCycle,
		             D.ServiceItem, 
					 L.UnitDescription,
				     D.ServiceItemUnit, 		
					 D.Reference,			  
				     D.Currency, 
					 D.Quantity,
					 D.Rate,	
					 D.DetailMemo,
					 ISNULL(C.Charged,'1') AS Charged,
					 CASE C.Charged
					 	WHEN '2' THEN 'Personal Charges'
						ELSE 'Business Charges'
					END AS ChargedDescription,				 		
					 U.Description as UnitClass,
					ISNULL(LabelQuantity ,'Qty') as LabelQuantity,
					ISNULL(LabelCurrency,'Currency') as LabelCurrency,
					ISNULL(LabelRate,'Rate') as LabelRate,
					L.PresentationMode,				
					
					<cfloop query="TopicList">			
					  <cfset fld = replace(description," ","","ALL")>
					  <cfset fld = replace(fld,".","","ALL")>
					  <cfset fld = replace(fld,",","","ALL")>
						(SELECT TopicValue 
						 FROM   WorkOrderLineDetailTopic 
						 WHERE  TransactionId = D.TransactionId AND Topic = '#code#') 
						as #fld#,						
					</cfloop>
								 			 
				     D.Amount,
					 DU.ReferenceAlias,
					 WL.Reference as LineReference
					 
		    FROM    WorkOrderLine WL 
					INNER JOIN WorkOrderLineDetail AS D ON  D.WorkOrderId = WL.WorkOrderId AND D.WorkOrderLine = WL.WorkOrderLine 
				    INNER JOIN	ServiceitemUnit L ON  L.ServiceItem = D.ServiceItem AND L.Unit = D.ServiceItemUnit 							
					INNER JOIN  Ref_UnitClass U   ON L.UnitClass = U.Code											 

			        LEFT OUTER JOIN WorkOrderLineDetailCharge AS C 
							ON  D.WorkOrderId     = C.WorkOrderId 
							AND D.WorkOrderLine   = C.WorkOrderLine 
							AND D.ServiceItem     = C.ServiceItem 
							AND D.ServiceItemUnit = C.ServiceItemUnit 
							AND D.Reference       = C.Reference 
							AND D.TransactionDate = C.TransactionDate 							
					LEFT OUTER JOIN WorkOrderLineDetailUser DU ON D.WorkOrderId = DU.WorkOrderId AND D.WorkOrderLine = DU.WorkOrderLine AND D.Reference = DU.Reference
					INNER JOIN WorkOrder W ON W.WorkOrderId = WL.WorkOrderId
<!--- 					INNER JOIN ServiceItemLoad IL ON IL.Mission = W.Mission AND IL.ServiceItem = D.ServiceItem AND IL.ServiceUsageSerialNo = D.ServiceUsageSerialNo
 --->					LEFT OUTER JOIN Ref_ServiceItemDomainClass DC ON DC.ServiceDomain = WL.ServiceDomain AND DC.Code = WL.ServiceDomainClass					  
						 
		   WHERE     WL.WorkOrderId IN (SELECT  WorkorderId 
			                             FROM   WorkOrder 
										 WHERE  WorkorderId = WL.Workorderid 
										 AND    ServiceItem = '#url.serviceitem#')		
										 	   
		   AND	     WL.PersonNo = '#client.personno#'	
   		   AND		 WL.Operational = 1
<!--- 		   AND		 IL.ActionStatus = '1' --->
		   
		   <!--- the source record has a 1 (business)  or a 2 (personal) --->	  
		   AND       D.Charged      <> '0'  	  	
		   AND       D.ActionStatus != '9'     
		  	 
		   <!--- 29/6 Added to filter based on the portal processing date for the service --->
		   AND		D.TransactionDate >= (
		   				SELECT 	ISNULL(DatePortalProcessing,convert(datetime,'01/01/1900',101)) 
						FROM 	ServiceItemMission
						WHERE   Mission     = W.Mission
						AND  	ServiceItem = '#url.serviceitem#')					
		 			
		   <!--- 2014-03-12 Added to filter transactions from closed periods (prior to DatePostingCalculate) --->
		   AND		D.TransactionDate >= (
		   				SELECT 	ISNULL(DatePostingCalculate,convert(datetime,'01/01/1900',101)) 
						FROM 	ServiceItemMission
						WHERE   Mission     = W.Mission
						AND  	ServiceItem = '#url.serviceitem#')							
		   
		   <!--- 24/10 transactions associated to a load after the last closing for this line --->
		   AND      D.ServiceUsageSerialNo > (
		                                      SELECT ISNULL(MAX(SerialNo),0)
		                                      FROM   WorkOrderLineAction
											  WHERE  WorkorderId   = WL.WorkOrderId
											  AND    WorkOrderLine = WL.WorkOrderLine
											  AND    ActionClass   = '#ServiceItem.UsageActionClose#'										 
											  AND	 ActionStatus <> '9'
											  )  
											  
		   <!--- user has tagged as personal, now we check for anything business and personal : please remove    
		   AND       C.Charged      = '2'  	
		   --->					
		   
		   <!--- action was not closed yet : old mode 
		   AND       C.ActionStatus = '0'	
		   --->   		
		    AND   ((DC.ChargeTagging IS NULL ) OR (DC.ChargeTagging ='1')) 	<!--- 2013-01-22 Disable Custodian devices for approval --->						  
					
			AND D.ServiceUsageSerialNo NOT IN (
				SELECT L1.ServiceUsageSerialNo
				FROM ServiceItemLoad L1
				WHERE L1.Mission = W.Mission
				AND L1.ServiceItem = D.ServiceItem
				AND L1.ActionStatus = '0'
			)
										   
		   ORDER BY  C.charged DESC,WL.Reference, L.ListingOrder, Year(D.TransactionDate),
					 Month(D.TransactionDate), left(convert(varchar,D.TransactionDate,112),6), U.ListingOrder, D.ServiceItemUnit, D.TransactionDate 	
		     	  
	</cfquery>	

	<!---- check threshold ---->
	<cfset ThresholdExceeded = "0">
		
	<cfquery name="BusinessChagesbyLine" dbtype="query" >
		SELECT 	DISTINCT WorkOrderId,
				WorkOrderline,
				YearTransaction,
				MonthTransaction,
				Charged
		FROM UsageList
		WHERE Charged = '1'
		ORDER BY WorkOrderId,
				WorkOrderLine, 
				YearTransaction, 
				MonthTransaction
	</cfquery>
	
	<cfloop query="BusinessChagesbyLine">

		<cfset dtrans = DateFormat(createdate(YearTransaction,MonthTransaction,"1"),"YYYY-MM-DD")>
		
		<cfinvoke component = "Service.Process.WorkOrder.ValidateWorkorder"  
			method			= "CheckThreshold"
			mode			= "overall"
			WorkOrderId	 	= "#WorkOrderId#"
			WorkOrderline	= "#WorkOrderLine#"
			TransactionDate	= "#dtrans#"
			Amount			= "0"
			Charged			= "1"
			returnVariable	= "ThresholdValidated">
			
		<cfif ThresholdValidated eq "0" >
			<cfset ThresholdExceeded = "1">
			<cfbreak>
		</cfif>					
		
	</cfloop>		
			
	<!---- end threshold check---->	
	
	<cfoutput>
	
	<cfif url.print eq "0">
					
		<tr><td style="border-left:1px solid silver;border-right:1px solid silver;border-bottom:1px solid silver;height:40px" colspan="#TopicCount+8#" align="center" bgcolor="eeeeee" class="labellarge clsNoPrint">
				
		<cfif UsageList.recordcount gt 0>	
		
 			<table width="100%" cellspacing="0" cellpadding="0">
			
			<cfparam name="client.workorderportalmessage" default="">
			<tr >
			<td align="center"  height="12px">								
			</td>
			</tr>			
			
			<tr class="#client.workorderportalmessage#">
			<td align="center" id="approvalmessage" class="labelmedium">					
			<!---
			<b>Please be aware that here we only show the calls previously marked as "Personal".</b><br> 
			--->
			This screen is intended for you to review and authorise your Business and Private usage.<br> If you need to modify the marking of a call, please do it on this screen.
												
			<br>
			<!---
			<a href="javascript:ColdFusion.navigate('#SESSION.root#/Workorder/Portal/User/InstructionHide.cfm','approvalmessage')">
			<font color="6688aa">[Do not show this message]</font>
			</a>
			--->
			</td>
			</tr>

			<tr >
			<td align="center"  height="12px">								
			</td>
			</tr>			
			
			</table>	
			
		<cfelse>
			
			<font size="4" color="black">This service does not have usage pending approval.			
		</cfif>
		
		</td>
		</tr>
		
	</cfif>
	
	</cfoutput>
	
	<tr><td>
	
	<table class="clsNoPrint">
	
 	<cf_layout type="accordion">  
	
		<cfoutput query="UsageList" group="Charged">
	
	 			<tr valign="top"><td colspan="#TopicCount+8#">
					 
	 			<cfif charged eq "1">
					<cfset vcollapsed = "true">
				<cfelse>
					<cfset vcollapsed = "false">
				</cfif>			
	 
 				<cf_layoutArea 
					id 		= "layoutArea_#charged#" 
					label 	= "#ChargedDescription#"  
					togglerColor = "c4e1ff"
					togglerBorder = "1px solid silver" 
					togglerBorderColor = "silver"
					labelFontColor = "525456"
					labelFontSize = "18"
					labelHeight = "20"
					labelIconHeight = "20"
					initCollapsed = "#vcollapsed#"
					togglerOpenIcon="plusBlue.png"
					togglerCloseIcon="minusBlue.png">	 
					
					<table width="98%" cellspacing="0"  border="0" cellpadding="0" class="navigation_table" navigationhover="##c4e1ff" navigationselected="##cccccc" class="clsPrintContent">
		
					<cfoutput group="LineReference">	
					
							<cf_stringtoformat value="#Linereference#" format="#ServiceItemDomain.DisplayFormat#">
							
							<tr><td></td><td class="labelmedium" colspan="#TopicCount+8#" height="20"><b>#ServiceItemDomain.Description# #val#</b></td></tr>
							<tr><td colspan="#TopicCount+8#" height="10" ></td></tr>					

						<cfoutput group="BillingCycle">
								
							<cfset vBillingCycle = createDate(YearTransaction,MonthTransaction,1)>
								
							<tr><td></td><td class="labelit" colspan="#TopicCount+8#" height="20"><font color="0080C0">#DateFormat(vBillingCycle,"mmmm yyyy")#</font></td></tr>
		
		
							<cfoutput group="ServiceItemUnit">					
							
						
								<tr>
								 <td></td>
								 <td class="labelit line" colspan="#TopicCount+8#" height="20"><b>#UnitDescription#</b></td>
								</tr>
								
								<tr bgcolor="fafafa" class="labelit line">
								   <td width="10" height="18" style="color: 002350"></td>			  
								   <td style="color: 002350" width="75"><font color="3d3d3d"><b><cf_tl id="Date"></b></font></td>
								   <td style="color: 002350" width="50"><font color="3d3d3d"><b><cf_tl id="Time"></b></font></td>		   		  
								   
								   <cfif PresentationMode eq "Detail">
								   		 <td style="color: 002350"><font color="3d3d3d"><b><cf_tl id="To/From"></b></font></td>
									   <cfloop query="TopicList">
										  <td style="color: 002350"><font color="3d3d3d"><b>#TopicList.description#</b></font></td>
									   </cfloop>   		
								   <cfelse>
								   		  <td colspan="#TopicCount+1#"></td>
								   </cfif>	
								   <td align="right" style="color: 002350"><font color="3d3d3d"><b>#LabelQuantity#</b></font></td>
								   <td align="right" style="color: 002350"><font color="3d3d3d"><b>#LabelRate#</b></font></td>
								   <td align="right" style="color: 002350"><font color="3d3d3d"><b>Amount (#LabelCurrency#)</b></font></td>			   
							   	   <td width="5%" align="center">
							     		<table cellspacing="0" cellpadding="0" width="100%">
											<tr><td align="center"><cf_UIToolTip tooltip="Business">&nbsp;<font color="3d3d3d"><b>B</b></font></cf_UIToolTip></td><td align="center"><cf_UIToolTip tooltip="Personal"><font color="3d3d3d"><b>P</b></font>&nbsp;</cf_UIToolTip></td></tr>
									 	</table>
							       </td>		
								   			   
								</tr>
								
								<cfset total = 0>
																	
									<cfoutput>	
									
										<!--- only the personal entries --->
									
										<cfif charged eq "2" or charged eq "1">
									
											<tr class="navigation_row labelit line">
											
											<td id="b#transactionid#"></td>
											<td>#dateformat(TransactionDate,CLIENT.DateFormatShow)#</b></td>
											<td>#TimeFormat(TransactionDate, "HH:mm")#</b></td>			
												
										   <cfif PresentationMode eq "Detail">
										   		<cfif UsageList.ReferenceAlias neq "">
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
													<td>#val#</td>				
																
												</cfloop>  
											<cfelse>
												  <td style="padding-left:5px">#DetailMemo#</td>
										   		  <td colspan="#TopicCount#"></td>
										   </cfif>	 
											
											<td align="right">#numberformat(quantity,",")#</td>
											<td align="right">#numberformat(rate,"__,__.__")#</td>
											<td align="right">#numberformat(amount,"__,__.__")#</td>		
																				   
											<cfif url.print eq "1">
											
											<!--- also disable at a certain point once the user confirms --->
											
											    <td align="center" height="15" style="padding-left:7px;padding-right:5px">
													<table cellspacing="0" cellpadding="0"  cellpadding="0" align="center" width="100%">
													<tr>
														<td bgcolor="ffffaf" align="center" width="50%" style="border: 1px solid silver">
														<cfif Charged neq "2" ><img src="#SESSION.root#/images/check_mark.gif" alt="" border="0"></cfif></td>
														</td>
													    <td align="center" height="15" bgcolor="eaeaea" align="center" width="50%" style="border: 1px solid silver">
														<cfif Charged eq "2" ><img src="#SESSION.root#/images/check_mark.gif" alt="" border="0"></cfif></td>
														</td>
														<td class="hide" id="b#transactionid#" style="border: 1px solid silver"></td>
													</tr>
													</table>
												</td>
															
											<cfelse>
														
												<td align="center" style="padding-left:7px;padding-right:5px">
													<table cellspacing="0" cellpadding="0" align="left" width="60px" height="20px"><tr>
													<td bgcolor="ffffdf" align="center" width="30px" valign="middle"  style="border-right: 1px solid silver">
													<input name="source_#currentrow#" id="chk_#transactionid#_1" style="height:16px;width:16px;padding:0px"  title="Business" type="radio" <cfif Charged neq "2" >checked</cfif> <cfif Amount eq "0" >disabled</cfif> onclick="dochange('#TransactionId#','#Transactionid#','1','#serviceitem#')">
													</td>
												    <td align="center" height="15" bgcolor="eaeaea" align="center" width="30px" valign="middle"  style="border-right: 1px solid silver">
													<input name="source_#currentrow#" id="chk_#transactionid#_2" style="height:16px;width:16px;padding:0px"  title="Personal" type="radio" <cfif Charged eq "2">checked</cfif> <cfif Amount eq "0" >disabled</cfif> onclick="dochange('#TransactionId#','#Transactionid#','2','#serviceitem#')">
													</td>
													<td class="hide" id="b#transactionid#"  style="border: 1px solid silver"></td>
													</tr>
													</table>
												</td>		
														
											</cfif>
													  
											</tr>
																															
											<cfset total = total+amount>
										
										</cfif>
									
									
								</cfoutput>
								
								<tr><td colspan="#TopicCount+8#"></td></tr>
								<tr><td colspan="#TopicCount+6#">
								    <td colspan="1" align="right" style="border-top:solid gray 1px" class="labelmedium">#LabelCurrency#  #numberformat(total,"__,__.__")#</td>
								</tr>
							
							</cfoutput>

						</cfoutput>
							
					</cfoutput>
				</td></tr>
				</table>
			
		 		</cf_LayoutArea> 

		</cfoutput>

	    </cf_layout> 
		
		</table>
		
		</td>
		</tr>
		
		
		<tr>
			
 			<td style="padding-top:4px" align="center" id="btnAuthorize" class="clsNoPrint">
		
				<cfif UsageList.recordcount gt 0>	
					<cfif ThresholdExceeded eq "0">
			
						<cfoutput>
					
						<cfset url.width = 700>			
						<input class="button10g"
					  	style="font-size:15;width:280;height:32;background-color:##eeeeee;" 
					  	type="button" 
					  	value="Authorise charges" 
					  	onclick="ColdFusion.Window.create('Auth', 'Authorise charges', '',{height:320,width:#url.width#,resizable:false,modal:true,center:true}); ColdFusion.Window.show('Auth');ColdFusion.navigate('#SESSION.root#/Workorder/Application/Workorder/Servicedetails/Charges/Authorize.cfm?mission=#url.mission#&serviceitem=#url.serviceitem#','Auth')">												
					  
						</cfoutput>  
				  
					</cfif>	  
				</cfif>	  

			</td>
			
		</tr>		 
		</table>
			

	</td>
	</tr>
	
	</table>
</cfif>

<cfset ajaxOnLoad("doHighlight")>


