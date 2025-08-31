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
<cfparam name="URL.Mission"    default="">
<cfparam name="URL.Period"     default="">
<cfparam name="URL.OrderClass" default="">
	
<CF_DropTable dbName="AppsQuery"  tblName="lsPurchase_#SESSION.acc#">

<cfquery name="Parameter" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_ParameterMission 
   WHERE  Mission = '#url.mission#'
</cfquery>

<cfoutput>

<cfsavecontent variable="sqlselect">

      P.Mission, 
      P.PurchaseNo, 
	  <cfif Parameter.PurchaseCustomField eq "">		  
	  P.PurchaseNo as PurchaseReference,		  
	  <cfelse>
	  		  
	     CASE 
		
		 <!--- generic changes : check if the workflow is aready no pending steps but active --->
					 
		 WHEN P.Userdefined#Parameter.PurchaseCustomField# = '' THEN P.PurchaseNo				
		 WHEN P.Userdefined#Parameter.PurchaseCustomField# is NULL THEN P.PurchaseNo															   							   			   
		 ELSE P.Userdefined#Parameter.PurchaseCustomField#
		 
		END as PurchaseReference,		
	  
	  </cfif>
	  
	  P.OrderDate, 
	  P.Period,
	  P.OrderClass, 
	  Class.Description AS ClassDescription, 
	  P.OrderType, 
	  Type.Description AS TypeDescription, 
	  Type.InvoiceWorkflow,
	  Type.ReceiptEntry,
	  P.OrgUnit, 
	  P.OrgUnitVendor, 
	  P.PersonNo,
	  S.ProgramCode,
	  S.ProgramName,
	  P.OfficerLastName,
	  CASE P.OrgUnitVendor WHEN 0 THEN 'stf:'+E.FirstName+' '+E.LastName 
		   WHEN NULL THEN 'stf:'+E.FirstName+' '+E.LastName 
		   ELSE Vendor.OrgUnitName 
      END as IssuedBy,
	  COUNT(PL.RequisitionNo) AS Lines,
	  P.Currency,			  
	  ISNULL(SUM(PL.OrderAmount),0)    AS Amount,		
	  ISNULL(SUM(PL.OrderAmountBase),0) AS AmountBase			
 
</cfsavecontent>	
</cfoutput>			  

<!--- body --->

<cfsavecontent variable="sqlbody">
          Purchase P INNER JOIN
          Ref_OrderClass Class ON P.OrderClass = Class.Code INNER JOIN
          Ref_OrderType Type ON P.OrderType = Type.Code INNER JOIN
          Organization.dbo.Organization Unit ON P.OrgUnit = Unit.OrgUnit 
		  LEFT OUTER JOIN Organization.dbo.Organization Vendor ON P.OrgUnitVendor = Vendor.OrgUnit
		  LEFT OUTER JOIN Employee.dbo.Person E ON P.PersonNo = E.PersonNo
		  LEFT OUTER JOIN Program.dbo.Program S ON P.ProgramCode = S.ProgramCode
		  	  
		  <cfif url.id eq "LOC">
		  LEFT OUTER JOIN PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo AND PL.ActionStatus != '9'	  
		  <cfelse>
		  INNER JOIN PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo	      
		  </cfif>
</cfsavecontent>

<cfoutput>

<cfswitch expression="#URL.ID#">

	<cfcase value="PEN">
	
		<cfif url.orderclass neq ''>
			<cfset cls = "AND OrderClass = '#url.orderclass#'">		
		<cfelse>
			<cfset cls = "">
		</cfif>
			
	    <cfif URL.ID1 eq "9">
			<cfset condition = "WHERE PL.ActionStatus = '9' AND P.ActionStatus <= '#URL.ID1#' AND P.Period = '#URL.Period#' AND P.Mission = '#URL.Mission#' #cls#">
		<cfelse>
			<cfset condition = "WHERE PL.ActionStatus != '9' AND P.ActionStatus <= '#URL.ID1#' AND P.Period = '#URL.Period#' AND P.Mission = '#URL.Mission#' #cls#">
		</cfif>
					  	
		<cfset text = "">
		 
	</cfcase>
	
	<cfcase value="STA">
	
		<cfif url.orderclass neq ''>
			<cfset cls = "AND OrderClass = '#url.orderclass#'">		
		<cfelse>
			<cfset cls = "">
		</cfif>
		
		<cfif url.id1 eq "PendingReceipt">
		
		    <cfset condition = "WHERE P.ActionStatus IN ('3','4') AND PL.DeliveryStatus < '3' AND ObligationStatus = '1' AND ReceiptEntry = '0' AND P.Period = '#URL.Period#' AND P.Mission = '#URL.Mission#' #cls#">
		     		
		<cfelseif url.id1 eq "PendingInvoice">
		
		    <cfset condition = "WHERE P.ActionStatus = '3' AND P.Period = '#URL.Period#' AND P.Mission = '#URL.Mission#' #cls# AND P.PurchaseNo IN (SELECT PurchaseNo FROM skPurchase WHERE InvoiceAmount > 0)">		    
		
		<cfelse>
			
		    <cfif URL.ID1 eq "9">
				<cfset condition = "WHERE PL.ActionStatus = '9' AND P.ActionStatus = '#URL.ID1#' AND P.Period = '#URL.Period#' AND P.Mission = '#URL.Mission#' #cls#">
			<cfelse>
				<cfset condition = "WHERE PL.ActionStatus != '9' AND P.ActionStatus = '#URL.ID1#' AND P.Period = '#URL.Period#' AND P.Mission = '#URL.Mission#' #cls#">
			</cfif>
		
		</cfif>
					  	
		<cfset text = "">
		 
	</cfcase>
	
	<cfcase value="TOD">
		<cfset condition = "WHERE PL.ActionStatus != '9'  AND P.OrderDate >= '#dateFormat(now()-5, CLIENT.dateSQL)#' AND P.Period = '#URL.Period#' AND P.Mission = '#URL.Mission#'">
		<cfset text = "Today's Purchase orders">
	</cfcase>
	
	<cfcase value="VED">
		<cfset condition = "WHERE PL.ActionStatus != '9'  AND CAST(P.OrgUnitVendor AS varchar) = '#URL.ID1#'">
		<cfset text = "Vendor">
	</cfcase>
	
	<cfcase value="LOC">
	
	      <cfparam name="Form.PurchaseNo"    default="">
		  <cfparam name="Form.Period"        default="">
		  <cfparam name="Form.ActionStatus"  default="">
		  <cfparam name="Form.OrderType"     default="">
		  <cfparam name="Form.OrderClass"    default="">
		  <cfparam name="Form.OrgUnitVendor" default="">
		  <cfparam name="Form.OrgUnit"       default="">
		  <cfparam name="Form.PersonNo"      default="">
		  <cfparam name="Form.OrderItem"     default="">
		  <cfparam name="Form.DateStart"     default="">
		  					
		  <cfset condition = "WHERE P.Mission = '#URL.Mission#'">
		  
		  <cfif Form.PurchaseNo neq "">
		      <cfset condition  = "#condition# AND (P.PurchaseNo LIKE '%#Form.PurchaseNo#%' OR P.UserDefined1 LIKE  '%#Form.PurchaseNo#%' OR P.UserDefined2 LIKE  '%#Form.PurchaseNo#%' OR P.UserDefined3 LIKE  '%#Form.PurchaseNo#%' or P.UserDefined4 LIKE  '%#Form.PurchaseNo#%') ">
		  </cfif>	
		  
		  <cfif Form.Period neq "">
		      <cfset condition   = "#condition# AND P.Period = '#Form.Period#'">
		  </cfif>
		  
		   <cfif Form.ActionStatus neq "">
		      <cfset condition   = "#condition# AND P.ActionStatus = '#Form.ActionStatus#'">
		   <cfelse>
			   <cfset condition   = "#condition# AND P.ActionStatus != '9'">	  		  
		  </cfif>
		  
		  <cfif Form.OrderType neq "">
		      <cfset condition   = "#condition# AND P.OrderType = '#Form.OrderType#'">
		  </cfif>
		  
		  <cfif Form.OrderClass neq "">
		      <cfset condition   = "#condition# AND P.OrderClass = '#Form.OrderClass#'">
		   </cfif>
		  
		  <cfif Form.OrgUnitVendor neq "">
		      <cfset condition   = "#condition# AND CAST(P.OrgUnitVendor AS varchar) = '#Form.OrgUnitVendor#'">
		  </cfif>
		    
		  <cfif Form.OrgUnit neq "">
		      <cfset condition   = "#condition# AND CAST(P.OrgUnitVendor AS varchar) = '#Form.OrgUnit#'">
		  </cfif>
		  		    
		  <cfif Form.RequisitionNo neq "">		   		   
	          <cfset condition  = "#condition# AND (P.PurchaseNo IN (SELECT P.PurchaseNo FROM RequisitionLine L INNER JOIN PurchaseLine P ON L.RequisitionNo = P.RequisitionNo WHERE (L.RequisitionNo LIKE '%#Form.RequisitionNo#%') OR (L.Reference LIKE '%#Form.RequisitionNo#%')))">														   
		  </cfif>	
		  
		   <cfif Form.PersonNo neq "">
		      <cfset condition   = "#condition# AND P.PersonNo = '#Form.PersonNo#'">
		  </cfif>
			
		  <cfif Form.OrderItem neq "">
		      <cfset condition  = "#condition# AND PL.OrderItem LIKE  '%#Form.OrderItem#%'">
		  </cfif>	
		  
		  <cfif Form.DateStart neq "">
			  <cfset dateValue = "">
			  <CF_DateConvert Value="#Form.DateStart#">
			  <cfset dte = #dateValue#>
			  <cfset condition = "#condition# AND P.OrderDate >= #dte#">
		  </cfif>		
	
	   <cfset text = "Inquiry">
	</cfcase>
	
</cfswitch>


<cfsavecontent variable="OrderClass">
		 
 	<cfif getAdministrator(url.mission) neq "1">
		
			 AND    P.OrderClass IN (SELECT ClassParameter 
		                         FROM   Organization.dbo.OrganizationAuthorization
								 WHERE  UserAccount    = '#SESSION.acc#'
								 AND    Mission        = '#URL.Mission#'   
								 AND    ClassParameter = P.OrderClass
								 AND    Role           = 'ProcApprover')
    </cfif>	
			
</cfsavecontent>

<cfset condition = condition & " " & OrderClass>
	
</cfoutput>

<cfquery name="Parameter" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_ParameterMission 
   WHERE  Mission = '#url.mission#'
</cfquery>

<cfoutput>	
 
<cfsavecontent variable="myquery"> 
	SELECT *,OrderDate
	FROM  (
	SELECT   #preserveSingleQuotes(sqlselect)#					 			
	FROM     #preserveSingleQuotes(sqlbody)#
			 #preserveSingleQuotes(Condition)#				
	GROUP BY P.Mission,	
			 <cfif Parameter.PurchaseCustomField neq "">        			
			 P.Userdefined#Parameter.PurchaseCustomField#,
			 </cfif>
		     P.PurchaseNo, 
			 P.OrderClass, 
			 P.OrderDate, 
			 Class.Description, 
			 P.OrderType, 
			 Type.Description, 
			 Type.InvoiceWorkflow,
			 Type.ReceiptEntry,
			 P.OrgUnit, 
			 P.OrgUnitVendor, 
			 S.ProgramCode,
			 S.ProgramName,
			 Unit.OrgUnitName, 
             Vendor.OrgUnitName,
			 P.PersonNo,
			 E.Firstname,
			 P.Period,
			 E.LastName,
			 P.OfficerlastName,
			 P.Currency		
	
	) as P
	WHERE 1=1
	--condition
</cfsavecontent>	
	
</cfoutput>



<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfif url.id neq "VED">

<cfset itm = itm+1>

<cf_tl id="Issued By" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
                    width      = "0", 
					field      = "IssuedBy",
					filtermode = "2",
					search     = "text"}>
					
</cfif>		
					
<cfset itm = itm+1>			
<cf_tl id="Purchase No" var="1">
						
<cfset fields[itm] = {label           = "#lt_text#",                   
					field             = "PurchaseReference",		
					functionscript    = "ProcPOEdit",
					functionfield     = "PurchaseNo",			
					functioncondition = "tab",		
					search            = "text"}>		
					
<cfset itm = itm+1>		
<cf_tl id="Program" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "ProgramName",
					filtermode        = "2",
					search            = "text"}>
					
									
<cfset itm = itm+1>			
<cf_tl id="Order Class" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
                    width        = "0", 
					field        = "OrderClass",
					filtermode   = "2",
					search       = "text"}>
					
<cfset itm = itm+1>								
<cf_tl id="Order Type" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
					width        = "0", 
					field        = "OrderType",							
					filtermode   = "3",    
					search       = "text"}>							
					
<cfset itm = itm+1>		
<cf_tl id="Period" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
                    width        = "0", 
					alias        = "P",
					field        = "Period"}>									
						
<cfset itm = itm+1>							
<cf_tl id="Date" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    
					width        = "0", 
					field        = "OrderDate",		
					column       = "month",
					labelfilter  = "Order Date",						
					formatted    = "dateformat(OrderDate,CLIENT.DateFormatShow)",
					search       = "date"}>
					
<cfset itm = itm+1>							
<cf_tl id="Officer" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    
					width        = "0", 
					field        = "OfficerLastName",
					filtermode   = "2",   
					alias        = "P",
					search       = "text"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label      = "L",    
					width        = "0", 
					field        = "Lines",
					alias        = "P"}>						
					
<cfset itm = itm+1>		
<cf_tl id="Cur" var="1">
<cfset fields[itm] = {label      = "#lt_text#.",    
					width        = "0", 
					field        = "Currency",
					filtermode   = "2",
					alias        = "P",
					search       = "text"}>											
					
<cfset itm = itm+1>			
<cf_tl id="Amount" var="1">
<cfset fields[itm] = {label      = "#lt_text#",
					width        = "0", 
					field        = "Amount",
					align        = "right",
					aggregate    = "sum",
					search       = "number",
					formatted    = "numberformat(Amount,',.__')"}>	
					
<cfset itm = itm+1>					

<cf_tl id="Base" var="1">
<cfset fields[itm] = {label      = "#lt_text#",
					width        = "0", 
					field        = "AmountBase",
					align        = "right",
					aggregate    = "sum",
					search       = "number",
					formatted    = "numberformat(AmountBase,',.__')"}>											
					
<cfif url.id eq "LOC">
    <cfset s = "No">
	<cfset f = "formlocate">
<cfelseif url.id eq "VED">
	 <cfset s = "Hide"> 
	<cfset f = "">
<cfelse>
    <cfset s = "Hide"> 
	<cfset f = "">
</cfif>		
										
<cf_listing
   	header         = "lsPurchase"
   	box            = "lsPurchase"
	link           = "#SESSION.root#/Procurement/Application/Purchaseorder/PurchaseView/PurchaseViewListing.cfm?#cgi.query_string#"
	linkform       = "#f#"
   	html           = "No"	
	datasource     = "AppsPurchase"
	listquery      = "#myquery#"
	listkey        = "PurchaseNo"
	listgroup      = "IssuedBy"	
	listorder      = "PurchaseNo"
	listorderalias = "P"
	listorderdir   = "ASC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	annotation     = "ProcPO"
	filterShow     = "#s#"
	excelShow      = "Yes"
	drillmode      = "embed"	
	drillstring    = "mode=list"
	drilltemplate  = "Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchHeader.cfm"
	drillkey       = "PurchaseNo">

<script>
	parent.Prosis.busy('no')
</script>

