
<cfparam name="URL.page"       default="1">
<cfparam name="URL.warehouse"  default="">
<cfparam name="URL.period"     default="">

<cfif URL.ID1 eq "Week" or URL.ID1 neq "Year" or URL.ID1 neq "Locate">

<cfelse>

	<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
	
	<cfoutput>
		
		<script language="JavaScript">
		
		function more(box,id,act,mode) {
				
			icM  = document.getElementById(box+"Min")
		    icE  = document.getElementById(box+"Exp")
			se   = document.getElementById(box);
					 		 
			if (act=="show") {	 
		     	 icM.className = "regular";
			     icE.className = "hide";
		    	 se.className  = "regular";
				 ptoken.navigate('../ReceiptEntry/ReceiptDetail.cfm?box=i'+id+'&rctid='+id+'&mode='+mode+'&id1=#URL.ID1#','i'+id)
			 } else {
			   	 icM.className = "hide";
			     icE.className = "regular";
		     	 se.className  = "hide"
			 }
				 		
		  }
		  
		function reloadForm(page) { 
		      ptoken.location('ReceiptViewListing.cfm?mission=#URL.Mission#&warehouse=#url.warehouse#&period=#url.period#&id=#url.id#&id1=#url.id1#&page='+page)	
		}  
		
		</script>
	
	</cfoutput>
	
	<cf_dialogProcurement>
	<cf_dialogMaterial>

</cfif>

<cfset currrow = 0>

<cfset condition = "">
<cfset text = "Found receipts">

<cfswitch expression="#URL.ID1#">
	
	<cfcase value="Pending">
	    <cfif url.period eq "">
		    <cfset condition = "R.ActionStatus = '0' AND R.Mission = '#URL.Mission#'">
		<cfelse>
			<cfset condition = "R.ActionStatus = '0' AND R.Period = '#URL.Period#' AND R.Mission = '#URL.Mission#'">
		</cfif>	
		<cf_tl id="Pending for Clearance" var="text">
	</cfcase>
	
	<cfcase value="Equipment">
		<cfset condition = "R.Period = '#URL.Period#' AND R.Mission = '#URL.Mission#'">
		<cf_tl id="Pending Asset registration" var="text">
	</cfcase>
		
	<cfcase value="today">
		<cfset condition = "R.ReceiptDate = '#dateFormat(now(), CLIENT.dateSQL)#' AND R.Period = '#URL.Period#' AND R.Mission = '#URL.Mission#'">
		<cf_tl id="Today's receipts" var="text">
	</cfcase>
	
	<cfcase value="week">
		<cfset condition = "R.ReceiptDate > '#dateFormat(now()-7, CLIENT.dateSQL)#' AND R.Period = '#URL.Period#' AND R.Mission = '#URL.Mission#'">
		<cf_tl id="This week's receipts" var="text">
	</cfcase>
	
	<cfcase value="year">
		<cfset condition = "R.Period = '#URL.Period#' AND R.Mission = '#URL.Mission#'">
		<cf_tl id="This month's receipts" var="text">
	</cfcase>
	
</cfswitch>

<!--- 5/2/2015 added access if the user is RI for the class and the unit of the PO or receipt office --->

<cfoutput>
<cfsavecontent variable="access">

		(		
		
		 EXISTS (SELECT Mission
		         FROM   Organization.dbo.OrganizationAuthorization
				 WHERE  Role           = 'ProcRI'
			     AND    UserAccount    = '#session.acc#'
			     AND    ClassParameter = P.OrderClass
				 AND    Mission        = P.Mission
				 AND    OrgUnit is NULL)
					   
		 OR			   
					   
		 EXISTS (SELECT 'X' 
                 FROM   Organization.dbo.OrganizationAuthorization
                 WHERE  Mission        = P.Mission
			     AND    Role           = 'ProcRI'
			     AND    UserAccount    = '#session.acc#'
			     AND    ClassParameter = P.OrderClass
			     AND    OrgUnit        = P.OrgUnit)  
			  
		 OR
		 	  
		 EXISTS (SELECT 'X' 
                 FROM   Organization.dbo.OrganizationAuthorization
                 WHERE  Mission        = P.Mission
			     AND    Role           = 'ProcRI'
			     AND    UserAccount    = '#session.acc#'
			     AND    ClassParameter = P.OrderClass
			     AND    OrgUnit IN (SELECT O.OrgUnit
								    FROM   Materials.dbo.Warehouse W INNER JOIN
					                       Organization.dbo.Organization O ON W.MissionOrgUnitId = O.MissionOrgUnitId
								    WHERE  Warehouse = W.Warehouse
								   )  	
				)				 
		)		
		 
			
</cfsavecontent>
</cfoutput>

<cfif URL.ID1 eq "Week" or URL.ID1 eq "Year" or URL.ID1 eq "Locate">

	<cfoutput>
	
	<!--- --,ReceiptDate --->
	<cfsavecontent variable="myquery">
	
	SELECT * --,ReceiptDate 
	FROM (
	
		 SELECT       R.ReceiptNo, 
		              P.PurchaseNo, R.Period, 
					  R.PackingslipNo, 
					  R.EntityClass,
					  R.ReceiptReference1, R.ReceiptReference2, R.ReceiptReference3, R.ReceiptReference4, 
					  R.ReceiptDate, 
					  R.ActionStatus,
					  COUNT(PR.ReceiptId)                 AS Receipts, 
					  PR.Currency,
					  ROUND(SUM(PR.ReceiptAmount), 2)     AS Amount, 
                      ROUND(SUM(PR.ReceiptAmountBase), 2) AS AmountBase, 
					  MIN(PR.ActionStatus)                AS Status, 
					  R.OfficerUserId, R.OfficerLastName, R.OfficerFirstName, 
					  R.Created
					  
         FROM         PurchaseLineReceipt      AS PR 
		              INNER JOIN  Receipt      AS R  ON PR.ReceiptNo = R.ReceiptNo 
					  INNER JOIN  PurchaseLine AS PL ON PR.RequisitionNo = PL.RequisitionNo
					  INNER JOIN  Purchase     AS P  ON P.PurchaseNo = PL.PurchaseNo
         WHERE        1=1
		 <cfif condition neq "">
		 AND          #preserveSingleQuotes(condition)#  
		 </cfif>
		 AND          PR.ActionStatus != '9' 
		 AND          P.ActionStatus  != '9'
		 
		 <cfif url.id1 eq "Locate">
		 AND          R.ReceiptNo IN (SELECT ReceiptNo 
		                              FROM userQuery.dbo.#SESSION.acc#Receipt)
		 </cfif>
		 
		 <cfif getAdministrator("#url.mission#") eq "0">				
		 AND          #preserveSingleQuotes(access)#		
		 </cfif>
					
		 <!--- limit for stock task view ---> 		
		 <cfif url.warehouse neq "">
		 AND          PR.Warehouse = '#url.warehouse#'
		 </cfif>				
		 
		 GROUP BY     R.ReceiptNo, 
		              PR.Currency, 
					  P.PurchaseNo, 
					  R.ActionStatus,
					  R.Period, 
					  R.PackingslipNo, 
					  R.EntityClass, 
					  R.ReceiptReference1, 
					  R.ReceiptReference2, 
					  R.ReceiptReference3, 
					  R.ReceiptReference4, 
					  R.ReceiptDate, R.OfficerUserId, R.OfficerLastName, R.OfficerFirstName, R.Created 	
			
		) as B
				
		WHERE 1=1
		--condition			
			
	</cfsavecontent>
	
	</cfoutput>

<cfelseif URL.ID1 eq "Pending" or URL.ID1 eq "Today">

	<cfquery name="SearchResult" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  R.ReceiptNo,
		        R.Mission,
				R.Period,
				R.OfficerUserId,
				R.OfficerLastName,
				R.OfficerFirstName,
				R.ActionStatus,
				R.PackingSlipNo,
				R.ReceiptReference1, 
				R.ReceiptReference2, 
				R.ReceiptReference3, 
				R.ReceiptReference4, 
				R.ReceiptDate,
				
		        (SELECT count(*) 
				 FROM   PurchaseLineReceipt 
				 WHERE  ReceiptNo = R.ReceiptNo  
				 AND    ActionStatus != '9') as Lines,
				
				(SELECT SUM(ReceiptAmountBase)  
				 FROM   PurchaseLineReceipt 
				 WHERE  ReceiptNo = R.ReceiptNo  
				 AND    ActionStatus != '9') as AmountBase, 
				 
				(SELECT MIN(ActionStatus) 
			     FROM PurchaseLineReceipt 
			     WHERE ReceiptNo = R.ReceiptNo 
			     AND ActionStatus != '9') as ReceiptStatus,  
					 
		        PR.ReceiptId, 
				PL.RequisitionNo as RequisitionNo, 
				P.PurchaseNo, 
				P.OrgUnitVendor, 
				P.PersonNo,
				R.Created
		FROM    Receipt R 
		        INNER JOIN  PurchaseLineReceipt PR ON R.ReceiptNo = PR.ReceiptNo
				INNER JOIN  PurchaseLine PL ON Pr.RequisitionNo = PL.RequisitionNo
				INNER JOIN  Purchase P ON P.PurchaseNo = PL.PurchaseNo
				
		WHERE   #preserveSingleQuotes(condition)#  
		
		<cfif getAdministrator("#url.mission#") eq "0">				
		AND     #preserveSingleQuotes(access)#		
		</cfif>
				
		<!--- limit for stock task view ---> 		
		<cfif url.warehouse neq "">
		AND     PR.Warehouse = '#url.warehouse#'
		</cfif>		
				
		ORDER BY R.ReceiptNo	
				
	</cfquery>
	
<cfelseif URL.ID1 eq "Equipment">

	<!--- check if the receipt has an occurenca --->

	<cfquery name="SearchResult" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    R.*, 
			  
			  (SELECT count(*) 
			   FROM PurchaseLineReceipt 
			   WHERE ReceiptNo = R.ReceiptNo  
			   AND ActionStatus != '9') as Lines,
			  
			  (SELECT SUM(ReceiptAmountBase)  
				 FROM   PurchaseLineReceipt 
				 WHERE  ReceiptNo = R.ReceiptNo  
				 AND    ActionStatus != '9') as AmountBase, 
				 
			  (SELECT MIN(ActionStatus) 
			   FROM PurchaseLineReceipt 
			   WHERE ReceiptNo = R.ReceiptNo 
			   AND ActionStatus != '9') as ReceiptStatus, 
			 		 			  
	          L.ReceiptId, L.RequisitionNo, P.PurchaseNo, P.OrgUnitVendor, P.PersonNo
			  
    FROM      Materials.dbo.Ref_Category C
	          INNER JOIN  Materials.dbo.Item I ON C.Category = I.Category 
			  INNER JOIN  Receipt R 
			  INNER JOIN  PurchaseLineReceipt L ON R.ReceiptNo = L.ReceiptNo ON I.ItemNo = L.WarehouseItemNo
			  INNER JOIN  PurchaseLine PL ON L.RequisitionNo = PL.RequisitionNo
			  INNER JOIN  Purchase P ON P.PurchaseNo = PL.PurchaseNo
     WHERE    L.ActionStatus IN ('1','2')
	 AND      I.ItemClass = 'Asset'
	 AND      L.ReceiptId NOT IN  (SELECT  ReceiptId
                                   FROM    Materials.dbo.AssetItem
		    					   WHERE   ReceiptId = L.ReceiptId) 
	 AND      #preserveSingleQuotes(condition)# 		
	 
	 <cfif getAdministrator("#url.mission#") eq "0">
		
		AND     #preserveSingleQuotes(access)#
		
		</cfif>	  
	 
	ORDER BY R.ReceiptNo					
	</cfquery>
	

</cfif>

<cfif URL.ID1 eq "Equipment" or URL.ID1 eq "Today" or URL.ID1 eq "Pending">
			
	<cfquery name="Counted" 
	    dbtype="query">
			SELECT  DISTINCT ReceiptNo
			FROM    searchResult
	</cfquery>
	
	<cfset counted = Counted.recordcount>
	
	<cfquery name="Custom" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_CustomFields
	</cfquery>

	<table width="97%" height="100%" align="center">
			
	<tr><td colspan="4" align="left" class="labelmedium2" style="height:35px;font-size:25px;height:45px;padding-left:0px"><cfoutput>#Text#</cfoutput></td>
	
		<td colspan="5" align="right" style="padding-right:5px">	
		    
		    <cf_PageCountN count="#counted#">
			
			 <cfif pages gte "2">
			 
	         <select name="page" id="page" size="1" class="regularxl" 
	          onChange="javascript:reloadForm(this.value)">
			  <cfloop index="Item" from="1" to="#pages#" step="1">
	             <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
	          </cfloop>	 
	         </select>
			 
			 </cfif>
			 		 		 
	    </td>
		
	</tr>
	
	<tr><td colspan="13" style="border-bottom:1px solid gray;height:26px;padding-bottom:4px">						 
		 <cfinclude template="Navigation.cfm">	 				 
	</td></tr>
	
	<tr><td width="100%" height="100%" colspan="13">
	
		<cf_divscroll>
	
		<table width="100%" class="navigation_table">	
				
		<TR class="labelmedium line fixrow fixlengthlist">
			    <td></td>
				<td><cf_tl id="Receipt"></td>	
				<td><cf_tl id="Status"></td>			
				<td><cf_tl id="Purchase"></td>
				<td><cf_tl id="Vendor"></td>
				<td><cf_tl id="Packingslip"></td>
				<td><cf_tl id="Date"></td>
				<cfif Custom.ReceiptReference1 neq "">
				<td><cfoutput>#Custom.ReceiptReference1#</cfoutput></td>
				</cfif>
				<cfif Custom.ReceiptReference2 neq "">
				<td><cfoutput>#Custom.ReceiptReference2#</cfoutput></td>		
				</cfif>
				<td><cf_tl id="Officer"></td>
				<td><cf_tl id="Lines"></td>			
				<td align="right"><cf_tl id="Value"></td>			
				<td></td>
		</TR>
			
		<cfif searchresult.recordcount eq "0">
		
		<tr>
			<td colspan="12" style="padding-top:20px" class="labelmedium" align="center"><cf_tl id="No records to show in this view"></td>
		</tr>
		
		</cfif>
		
		<cfoutput query="SearchResult" group="ReceiptNo">
		
			<cfif orgunitVendor neq "0" and orgunitvendor neq "">
		
				<cfquery name="getDetail" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    Organization.dbo.Organization O
					WHERE   O.OrgUnit = '#orgunitvendor#'					
				</cfquery>
					
				<cfset beneficiary = getDetail.OrgUnitName>		
					
			<cfelse>
			
				<cfquery name="getDetail" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    Employee.dbo.Person O
					WHERE   O.PersoNo = '#PersonNo#'		
				</cfquery>	
				
				<cfset beneficiary = "#getDetail.FirstName# #getDetail.LastName#">
			
			</cfif>	
		
			<cfset currrow = currrow + 1>
									
				<cfif currrow gte first and currrow lte last>
					
					<tr class="navigation_row line labelmedium2 fixlengthlist" bgcolor="<cfif actionstatus eq '9'>FF8000<cfelseif url.id1 neq 'Locate'>EFFBFB</cfif>" >
					    <TD width="20" 
						     style="height:29px;padding-left:2px;padding-right:5px;padding-top:2px;padding-bottom:2px">
						
						    <cfif URL.ID1 eq "Equipment" or URL.ID1 eq "Today" or URL.ID1 eq "Week">
							
							     <cf_img icon="select" onClick="receiptdialog('#ReceiptNo#','receipt')">
							  
							<cfelseif URL.ID1 eq "Pending">
							
							 	<cf_tl id="Clear" var="vClear">
								
							    <button style="border:1px solid silver;font-size:13px;height:22px;padding-top:2px;padding-bottom:2px" 
								   class="button10g" type="button" class="button10g navigation_action"
								   name="Clear" id="Clear" onClick="receiptdialog('#ReceiptNo#','receipt')">#vClear#</button> 												 
							
							<cfelse>
																				
								<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
									id="d#currrow#Exp" border="0" class="regular" 
									align="absmiddle" style="cursor: pointer;" 
									onClick="more('d#currrow#','#receiptNo#','show','ri')">
									
								<img src="#SESSION.root#/Images/arrowdown.gif" 
									id="d#currrow#Min" alt="" border="0" 
									align="absmiddle" class="hide" style="cursor: pointer;" 
									onClick="more('d#currrow#','#receiptNo#','hide','ri')">
								
							</cfif>	
							
						</td>
						
					    <TD>
						   <cfif URL.ID1 eq "Pending">
						   #ReceiptNo#
						   <cfelse>				   
						   <a class="navigation_action" href="javascript:receiptdialog('#ReceiptNo#','receipt')">#ReceiptNo#</a>
						   </cfif>					 					   
						</td>		
						<td><cfif receiptstatus eq "2"><cf_tl id="Matched"><cfelseif receiptstatus eq "1"><cf_tl id="Posted"></cfif></td>					  
						<TD>#PurchaseNo#</TD>
						<TD style="background-color:##e1e1e180" title="#beneficiary#">#beneficiary#</TD>
						<TD>#PackingSlipNo#</TD>
						<TD>#DateFormat(ReceiptDate, CLIENT.DateFormatShow)#</td>
						<cfif Custom.ReceiptReference1 neq "">
						<TD>#ReceiptReference1#</TD>
						</cfif>
						<cfif Custom.ReceiptReference2 neq "">
						<TD>#ReceiptReference2#</TD>									
						</cfif>
					    <TD>#OfficerLastName# : #DateFormat(Created, "dd/mm/yy")#</TD>				
						<TD align="right">#Lines#</TD>	
						<td align="right">#numberformat(amountBase,",.__")#</td>		
					</TR>								
					
					<cfif URL.ID1 eq "Equipment" or URL.ID1 eq "Today" or URL.ID1 eq "Pending">
					
						<tr id="d#currrow#" bgcolor="<cfif url.id1 neq 'Locate'>ffffff</cfif>">					
																							
							<input type="button" id="add#RequisitionNo#Exp"
							 border="0" 
							 class="hide" 
							 value="refresh"
							 style="border:1px solid silver"
							 onClick="_cf_loadingtexthtml='';ptoken.navigate('../ReceiptEntry/ReceiptDetail.cfm?box=i#ReceiptNo#&rctid=#receiptNo#&mode=ri&id1=#URL.ID1#','i#ReceiptNo#')">
																			
						<td colspan="11" style="padding-right:10px;padding-bottom:3px;padding-top:3px;padding-left:4px" id="i#ReceiptNo#">																											
												
								<cfset url.mode   = "receipt">
								<cfset url.box    = "i#ReceiptNo#">
								<cfset url.rctid  = "#ReceiptId#">
								<cfset url.reqno  = "#RequisitionNo#">							
								<cfset url.select = "#url.id1#">
								<cfinclude template="../ReceiptEntry/ReceiptDetail.cfm">								
								
						</td>
				        </tr>		
											 			  
					<cfelse>
					
						<tr class="hide" id="d#currrow#" class="navigation_row_child" bgcolor="<cfif url.id1 neq 'Locate'>EFFBFB</cfif>">													
						<td bgcolor="white" style="padding-right:10px" colspan="11" id="i#ReceiptNo#"></td>
				        </tr>		
					
					</cfif>  				
					
			  </cfif>			  
		  
		  </cfoutput>  
		 
			 	  
		  </table>	
			
		  </cf_divscroll>
		  			  
		  <tr><td style="border-top:1px solid gray;height:26px;padding-bottom:4px" colspan="9">
			  	 <cfinclude template="Navigation.cfm">
				 </td>
		  </tr>			 	
				
	</table>
	
<cfelse>
	
	<cfparam name="client.header" default="">
	
	<cfset fields=ArrayNew(1)>
	
	<cfset itm = 0>
			
	<cfset itm = itm+1>			
	
	<cf_tl id="Receipt No" var="1">
							
	<cfset fields[itm] = {label           = "#lt_text#",                   
						field             = "ReceiptNo",								
						search            = "text"}>	
	
	<cfif URL.ID1 eq "Locate">
						
		<cfset itm = itm+1>			
		<cf_tl id="Period" var="1">
		<cfset fields[itm] = {label      = "#lt_text#", 
		                    width      = "0", 						
							field      = "Period"}>							
	
	</cfif>
						
	<cfset itm = itm+1>						
	<cf_tl id="Date" var="1">
	<cfset fields[itm] = {label      = "#lt_text#",    
						width        = "0", 
						field        = "ReceiptDate",		
						column       = "month",
						labelfilter  = "Receipt Date",						
						formatted    = "dateformat(ReceiptDate,CLIENT.DateFormatShow)",
						search       = "date"}>						
							
	<cfset itm = itm+1>		
	<cf_tl id="Packingslip" var="1">
	<cfset fields[itm] = {label           = "#lt_text#", 
	                    width             = "0", 
						field             = "PackingslipNo",						
						search            = "text"}>
						
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label       = "S", 	
    	                LabelFilter   = "Status",				
						field         = "ActionStatus",					
						filtermode    = "3",    
						search        = "text",
						align         = "center",
						formatted     = "Rating",
						ratinglist    = "0=Yellow,1=Green,9=Red"}>							
						
	<cfset itm = itm+1>									
	<cf_tl id="PurchaseNo" var="1">
	<cfset fields[itm] = {label      = "#lt_text#", 
						width      = "30", 
						field      = "PurchaseNo",							
						filtermode = "3",    
						search     = "text"}>									
										
	<cfset itm = itm+1>			
	<cf_tl id="Modality" var="1">
	<cfset fields[itm] = {label      = "#lt_text#", 
	                    width      = "0", 
						field      = "EntityClass",
						filtermode = "2",
						search     = "text"}>				
							
	<cfset itm = itm+1>							
	<cf_tl id="Officer" var="1">
	<cfset fields[itm] = {label      = "#lt_text#",    
						width      = "0", 
						field      = "OfficerLastName",
						filtermode = "2",   						
						search     = "text"}>					
	
	<cfset itm = itm+1>							
	<cf_tl id="Recorded" var="1">
	<cfset fields[itm] = {label      = "#lt_text#",    
						width        = "0", 
						field        = "Created",
						formatted    = "dateformat(ReceiptDate,CLIENT.DateFormatShow)",
						search       = "date"}>								
						
	<cfset itm = itm+1>						
	<cf_tl id="Cur" var="1">
	<cfset fields[itm] = {label      = "#lt_text#.",    
						width      = "0", 
						field      = "Currency",
						labelfilter  = "Currency",	
						filtermode = "2",						
						search     = "text"}>											
						
	<cfset itm = itm+1>					
	
	<cf_tl id="Amount" var="1">
	<cfset fields[itm] = {label      = "#lt_text#",
						width      = "0", 
						field      = "Amount",
						align      = "right",
						aggregate  = "sum",
						search     = "number",
						formatted  = "numberformat(Amount,',.__')"}>	
						
	<cfset itm = itm+1>					
	
	<cf_tl id="Base" var="1">
	<cfset fields[itm] = {label      = "#lt_text# #application.BaseCurrency#",
						width      = "0", 
						field      = "AmountBase",
						align      = "right",
						aggregate  = "sum",						
						formatted  = "numberformat(AmountBase,',.__')"}>		
								
	<cfif url.id1 eq "Locate">
		<cfset fil = "hide">
	<cfelse>
	    <cfset fil = "Yes">
	</cfif>
												
	<cf_listing
    	header        = "lsReceipt_#url.mission#_#url.id1#"
    	box           = "lsReceipt_#url.mission#_#url.id1#"
		link          = "#SESSION.root#/Procurement/Application/Receipt/ReceiptView/ReceiptViewListing.cfm?systemfunctionid=#url.systemfunctionid#&id=#url.id#&id1=#url.id1#&mission=#url.mission#&period=#url.period#"		
    	html          = "No"
		show	      = "100"
		height        = "100"
		datasource    = "AppsPurchase"
		listquery     = "#myquery#"
		listkey       = "ReceiptId"		
		listorder     = "ReceiptNo"
		listorderalias = ""
		listorderdir  = "ASC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"
		annotation    = "ProcReceipt"
		filterShow    = "#fil#"
		excelShow     = "Yes"
		drillmode     = "tab"	
		drillstring   = "mode=dialog"
		drilltemplate = "Procurement/Application/Receipt/ReceiptEntry/ReceiptEdit.cfm?id="
		drillkey      = "ReceiptNo">

<!--- listing --->

</cfif>	

<cfset ajaxonLoad("doHighlight")>
<cfset ajaxonload("doCalendar")>

<script>
	Prosis.busy('no')
</script>
