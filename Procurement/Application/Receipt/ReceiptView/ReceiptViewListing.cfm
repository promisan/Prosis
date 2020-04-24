
<cfparam name="URL.page"       default="1">
<cfparam name="URL.warehouse"  default="">
<cfparam name="URL.period"     default="">

<cfajaximport tags="cfwindow">

<cfif url.id1 neq "Locate">

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
				 ColdFusion.navigate('../ReceiptEntry/ReceiptDetail.cfm?box=i'+id+'&rctid='+id+'&mode='+mode+'&id1=#URL.ID1#','i'+id)
			 } else {
			   	 icM.className = "hide";
			     icE.className = "regular";
		     	 se.className  = "hide"
			 }
				 		
		  }
		  
		function reloadForm(page) { 
		      window.location = "ReceiptViewListing.cfm?mission=#URL.Mission#&warehouse=#url.warehouse#&period=#url.period#&id=#url.id#&id1=#url.id1#&page="+page	
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
		    <cfset condition = "L.ActionStatus = '0' AND R.Mission = '#URL.Mission#'">
		<cfelse>
			<cfset condition = "L.ActionStatus = '0' AND R.Period = '#URL.Period#' AND R.Mission = '#URL.Mission#'">
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
	
	<cfcase value="month">
		<cfset condition = "R.ReceiptDate > '#dateFormat(now()-30, CLIENT.dateSQL)#' AND R.Period = '#URL.Period#' AND R.Mission = '#URL.Mission#'">
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
								    WHERE  Warehouse = L.Warehouse
								   )  	
				)				 
		)		
		 
			
</cfsavecontent>
</cfoutput>

<cfif URL.ID1 eq "Pending" or URL.ID1 eq "Today" or URL.ID1 eq "Week" or URL.ID1 eq "Month">

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
					 
		        L.ReceiptId, 
				PL.RequisitionNo as RequisitionNo, 
				P.PurchaseNo, 
				P.OrgUnitVendor, 
				P.PersonNo,
				R.Created
		FROM    Receipt R 
		        INNER JOIN  PurchaseLineReceipt L ON R.ReceiptNo = L.ReceiptNo
				INNER JOIN  PurchaseLine PL ON L.RequisitionNo = PL.RequisitionNo
				INNER JOIN  Purchase P ON P.PurchaseNo = PL.PurchaseNo
				
		WHERE   #preserveSingleQuotes(condition)#  
		
		<cfif getAdministrator("#url.mission#") eq "0">				
		AND     #preserveSingleQuotes(access)#		
		</cfif>
				
		<!--- limit for stock task view ---> 		
		<cfif url.warehouse neq "">
		AND     L.Warehouse = '#url.warehouse#'
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
		
<cfelse>

	<cftry>

		<cfquery name="SearchResult" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT   L.*, P.PurchaseNo, P.OrgUnitVendor, P.PersonNo
			FROM     userQuery.dbo.#SESSION.acc#Receipt L  
			         INNER JOIN  Purchase.dbo.PurchaseLine PL ON L.RequisitionNo = PL.RequisitionNo
					 INNER JOIN  Purchase.dbo.Purchase P ON P.PurchaseNo = PL.PurchaseNo
			
			WHERE 1=1 	
				 
			<cfif getAdministrator("#url.mission#") eq "0">		
			AND     #preserveSingleQuotes(access)#		
			</cfif>		 
					 
			ORDER BY ReceiptNo		
		</cfquery>
	
	<cfcatch>
	
		<table align="center"><tr><td style="padding-top:10px;color:red" class="labelmedium">A problem occurred with your request</td></tr></table>
	
	     <cfabort>
		 
	</cfcatch>
	   
	</cftry>

</cfif>

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

<table width="97%" height="100%" align="center" border="0">
		
<tr><td colspan="4" style="height:35;font-size:25px;height:45px;padding-left:0px" class="labelmedium"><cfoutput>#Text#</cfoutput></td>

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
			
	<TR class="labelmedium line fixrow">
		    <td style="min-width:20"></td>
			<td style="min-width:100"><cf_tl id="Receipt"></td>	
			<td style="min-width:70"><cf_tl id="Status"></td>			
			<td style="min-width:100"><cf_tl id="Purchase"></td>
			<td width="100%"><cf_tl id="Vendor"></td>
			<td style="min-width:150px"><cf_tl id="Packingslip"></td>
			<td style="min-width:100px"><cf_tl id="Date"></td>
			<cfif Custom.ReceiptReference1 neq "">
			<td style="min-width:80px"><cfoutput>#Custom.ReceiptReference1#</cfoutput></td>
			</cfif>
			<cfif Custom.ReceiptReference2 neq "">
			<td style="min-width:80px"><cfoutput>#Custom.ReceiptReference2#</cfoutput></td>		
			</cfif>
			<td style="min-width:250"><cf_tl id="Officer"></td>
			<td style="min-width:50"><cf_tl id="Lines"></td>			
			<td align="right" style="min-width:80"><cf_tl id="Value"></td>			
			<td style="min-width:20"></td>
		</TR>
	
	<!---
	
	<TR style="height:1px">
	    <td style="min-width:20"></td>
		<td style="min-width:100"></td>				
		<td style="min-width:70"></td>		
		<td style="min-width:100"></td>
		<td width="100%"></td>
		<td style="min-width:150px"></td>
		<td style="min-width:100px"></td>
		<cfif Custom.ReceiptReference1 neq "">
		<td style="min-width:80px"></td>
		</cfif>
		<cfif Custom.ReceiptReference2 neq "">
		<td style="min-width:80px"></td>		
		</cfif>
		<td style="min-width:250"></td>
		<td style="min-width:50"></td>		
		<td style="min-width:80"></td>	
		<td style="min-width:20"></td>
	</TR>
	
	--->
	
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
				
				<tr class="navigation_row line labelmedium" bgcolor="<cfif actionstatus eq '9'>FF8000<cfelseif url.id1 neq 'Locate'>EFFBFB</cfif>" >
				    <TD width="20" 
					     style="height:19;padding-left:2px;padding-right:5px;padding-top:2px">
					
					    <cfif URL.ID1 eq "Equipment" or URL.ID1 eq "Today" or URL.ID1 eq "Week">
						
						     <cf_img icon="select" onClick="receiptdialog('#ReceiptNo#','receipt')">
						  
						<cfelseif URL.ID1 eq "Pending">
						
						 	<cf_tl id="Clear" var="vClear">
							
						    <button style="font-size:12px;border:1px solid silver;height:21;padding-top:2px;padding-bottom:2px" 
							   class="button10g" type="button" class="button10s navigation_action"
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
					
				    <TD style="padding-left:2px">
					   <cfif URL.ID1 eq "Pending">
					   #ReceiptNo#
					   <cfelse>				   
					   <a class="navigation_action" href="javascript:receiptdialog('#ReceiptNo#','receipt')">#ReceiptNo#</a>
					   </cfif>					 					   
					</td>		
					<td><cfif receiptstatus eq "2"><cf_tl id="Matched"><cfelseif receiptstatus eq "1"><cf_tl id="Posted"></cfif></td>					  
					<TD>#PurchaseNo#</TD>
					<TD>#beneficiary#</TD>
					<TD style="padding-right:2px;">#PackingSlipNo#</TD>
					<TD style="padding-right:2px;">#DateFormat(ReceiptDate, CLIENT.DateFormatShow)#</td>
					<cfif Custom.ReceiptReference1 neq "">
					<TD style="padding-right:2px;">#ReceiptReference1#</TD>
					</cfif>
					<cfif Custom.ReceiptReference2 neq "">
					<TD style="padding-right:2px;">#ReceiptReference2#</TD>									
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
						 onClick="_cf_loadingtexthtml='';ColdFusion.navigate('../ReceiptEntry/ReceiptDetail.cfm?box=i#ReceiptNo#&rctid=#receiptNo#&mode=ri&id1=#URL.ID1#','i#ReceiptNo#')">
					
					<td></td>									
					<td colspan="10" style="padding-right:10px;padding-bottom:3px;padding-top:3px;padding-left:4px" id="i#ReceiptNo#">																											
											
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
					<td bgcolor="white"></td>
					<td bgcolor="white" style="padding-right:10px" colspan="10" id="i#ReceiptNo#"></td>
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

<cfset ajaxonLoad("doHighlight")>
<script>
	Prosis.busy('no')
</script>
