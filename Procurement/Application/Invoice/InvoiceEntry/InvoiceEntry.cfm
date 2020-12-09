
<!--- assign a unique identifier --->
<cf_AssignId>
<cfset guid = rowguid>

<cfparam name="URL.Mode"        default="Match">
<cfparam name="URL.PurchaseNo"  default="">
<cfparam name="URL.Warehouse"   default="">
<cfparam name="HTML"            default="No">

<cfset url.routing = "new">

<cfif url.mode eq "Warehouse">

    <cfset HTML ="No">
	<cfset cls = "Warehouse">
	<cf_screentop height="100%" html="#html#" jquery="Yes" layout="webapp" banner="gray" scroll="Yes" user="no" label="Register Payable" menuAccess="context">
			
<cfelse>

    <cfset cls = "Standard">
	<cf_screentop height="100%" html="#html#" jQuery="Yes" layout="webapp" banner="gray" scroll="Yes" label="Register Invoice">
	
</cfif>	

<cfquery name="PO" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Purchase P, Ref_OrderType T
	WHERE    P.OrderType = T.Code 
	AND      P.PurchaseNo = '#URL.PurchaseNo#'
</cfquery>

<cfset url.period = PO.Period>

<!--- make sure the body code comes before the screentop!!! --->

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<!--- ------------------------------------------------------- --->
<!--- warehouse mode means it is billned based on presettings --->
<!--- ------------------------------------------------------- --->

<cfif url.mode eq "Warehouse">

	<cfoutput>
	
		<!--- define the invoice condition to get the correct lines --->
	
		<cfsavecontent variable="invoicecondition">
		
		     		  
			  AND       B.Mission   = '#url.mission#'
		      AND       B.Warehouse = '#url.warehouse#'
		  
		      <!--- --------------------------- --->
			  <!--- -- status is confirmed----- --->
			   <!--- --------------------------- --->
			  AND       B.ActionStatus = '1'		
			  
			  <!--- --------------------------- --->
			  <!--- -- was set to billing ready ---> 
			  <!--- --------------------------- ---> 	  
			  AND       B.BillingStatus = '1'
			  
			  AND       T.BillingMode = 'External'
			  	  	  
			  <!--- for billing we only take the outgoing negative transactions for now --->
			  AND       (( B.TransactionType = '8' and TransactionQuantity < 0) OR B.TransactionType = '2')
		    
			  AND       (
			            InvoiceId IS NULL 
			            OR 
						InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = TS.InvoiceId)
					    )	
		
		</cfsavecontent>
	
	</cfoutput>
	
	<cfquery name="getTotal" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
	      SELECT  SUM(SalesTotal) as Total
		  FROM    ItemTransactionShipping TS, 
		          ItemTransaction T, 
				  WarehouseBatch B
		  WHERE   T.TransactionId = TS.TransactionId 
		  AND     T.TransactionBatchNo = B.BatchNo
		  
		  #preservesinglequotes(invoicecondition)#
											
	</cfquery>		
	
	
	<cfif getTotal.Total eq "0">
	
		<table align="center" height="80%">
			<tr><td align="center" class="verdana" height="70%"><font size="3" color="0080C0"><cf_tl id="No pending records found to be billed"></font></td></tr>
		</table>
		
		<cfabort>
	
	</cfif>
	
	<cfset total = getTotal.Total>
			
	<cfquery name="setCurrency" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	  
	      UPDATE  ItemTransactionShipping 		 
		  SET     SalesCurrency = '#url.currency#'
		  FROM    ItemTransactionShipping TS, 
		          ItemTransaction T, 
				  WarehouseBatch B
		  WHERE 1=1 #preservesinglequotes(invoicecondition)#		  
	</cfquery>	
			
	<cfset curr = url.currency>		
		
<cfelse>

	<cfset total = "0">
	
	<cfquery name="Line" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     PurchaseLine P 
		WHERE    P.PurchaseNo = '#URL.PurchaseNo#'
	</cfquery>

	<cfset curr  = Line.Currency>	
	
</cfif>	


<cfoutput>

<cfif Parameter.TaxExemption neq "0">  
   <body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="if (document.getElementById('exemption')) {ColdFusion.navigate('InvoiceExemption.cfm?tag=No&documentamount=#total#','exemption')}">
</cfif>

</cfoutput>

<cfajaximport tags="cfwindow,cfdiv">
<cfinclude template="InvoiceEntryMatchRequisitionScript.cfm">

<cf_calendarscript>
<cf_dialogOrganization>
<cf_DialogProcurement>
<cf_DialogStaffing>
<cf_dialogLedger>

<!--- provision to clean database for -blank- incoming invoices --->

<cfquery name="Clean" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM InvoiceIncoming
WHERE    InvoiceIncomingId IN
                (SELECT   InvoiceIncomingId
                 FROM     InvoiceIncoming IC LEFT OUTER JOIN
                          Invoice I ON IC.Mission = I.Mission 
					  AND     IC.OrgUnitOwner  = I.OrgUnitOwner 
					  AND     IC.OrgUnitVendor = I.OrgUnitVendor 
					  AND     IC.InvoiceNo     = I.InvoiceNo
                WHERE     I.InvoiceId IS NULL
		          AND     IC.Mission = '#URL.Mission#'    
				)
</cfquery>		

<cfquery name="OrderType" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_OrderType R
	WHERE  Code IN (SELECT Code 
	                FROM   Ref_OrderTypeMission 
				    WHERE  Mission = '#url.mission#'
				    AND    Code = R.Code)	
</cfquery>

<cfif OrderType.recordcount eq "0">

	<!--- show all --->
	
	<cfquery name="OrderType" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_OrderType R	
	</cfquery>

</cfif>

<cfquery name="PO" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Purchase P, Ref_OrderType T
	WHERE    P.OrderType = T.Code 
	AND      P.PurchaseNo = '#URL.PurchaseNo#'
</cfquery>

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     PurchaseLine P 
	WHERE    P.PurchaseNo = '#URL.PurchaseNo#'
</cfquery>

<cfif Line.recordcount eq "0">

	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr>
			<td height="50" align="center"><font face="Calibri" size="2"><i><cf_tl id="No Purchase Order selected. Action can not be completed">.</i></font></td>
		</tr>
	</table>
	
	<cfabort>

</cfif>

<cfoutput>

<script language="JavaScript">
	
	function tagging(amt) {
	 
		 <cfif Parameter.enableInvTag eq "1">
		     cu = document.getElementById("currency")
			 finlabel('INV','#rowguid#','Invoice','#URL.Mission#',cu.value,amt,'no','Purchase.dbo.RequisitionLineFunding','multiple','100%')
		 </cfif>
	}
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hl(itm,fld,ser){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
		 
				 		 	 		 	
		 if (fld != false){			
			 itm.className = "highLight2";
			 try { document.getElementById(ser+'_amount').className = "regular" } catch(e) {}		 		 
		 }else{			
		     itm.className = "regular";		
			 try { document.getElementById(ser+'_amount').className = "hide" } catch(e) {}
		 }
	  }
	  
	  function checkJournal(po){
	  	var thisCurr 	= document.getElementById("currency").value;
	  	var thisPO 		= po;
	  	var thisOwner   = document.getElementById("orgunitowner").value;	
		_cf_loadingtexthtml='';	
		ptoken.navigate('#session.root#/procurement/application/invoice/InvoiceEntry/setJournal.cfm?purchaseNo='+thisPO+'&currency='+thisCurr+'&Owner='+thisOwner,'postingJournalselect')		
	  }
	
	function check() {
	
		var count = 0;
		var s = 0;
		
		cur  = document.getElementById("currency")
		se   = document.getElementsByName("selectedpurchase")
		sec  = document.getElementsByName("selcurrency")
	
		while (se[count]) {
		   if (se[count].checked == true) { 
		   s = 1 
		   <cfif Parameter.EnforceCurrency eq "1">
		    if (sec[count].value != cur.value) {
			 <cf_tl id="The currency of the invoice must match the Purchase order currency" var="1">
		     alert("#lt_text#.")
		     return false
			 }
		   </cfif>		   
		 }
		 count++	 
	    }
	
		if (s == 0) { 
			
		  <cf_tl id="You must select one or more purchase orders that have an outstanding balance" var="1">
		  alert("#lt_text#.")
		  return false
			
		}   	
	}
		
	function terms(date) {
	
	     if (typeof date.dd!= "undefined") {
		    dte = date.dd+'/'+date.mm+'/'+date.yyyy;
		 } else {
		    dte = document.getElementById('documentdate').value	  
		 }			 
	     sel = document.getElementById('actionterms').value	  
	     _cf_loadingtexthtml='';
	     ptoken.navigate('#session.root#/procurement/application/invoice/InvoiceEntry/setTerms.cfm?date='+dte+'&id='+sel,'termsbox')	
		 
	}
	
	
	function showassociatedtotal() {
	     _cf_loadingtexthtml='';
		ptoken.navigate('#session.root#/procurement/application/invoice/InvoiceEntry/setTotal.cfm','invoicetotalselect','','','POST','forminvoice')	
	
	}
	
</script>	  

</cfoutput>

<cfform action="InvoiceEntrySubmit.cfm?invoiceclass=#cls#&warehouse=#url.warehouse#&html=#html#&Mode=new&Guid=#GUID#&Period=#URL.Period#&PurchaseNo=#URL.PurchaseNo#" 
		method="POST" target="result" name="forminvoice">
				        
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">
 		
<tr class="hide"><td><iframe name="result" id="result" width="100%" height="100"></iframe></td></tr>
			
    <!--- check if posting is possible --->

    <input type="hidden" id="_requests" name="_requests" value="">
	
	<cf_verifyOperational 
         module="Accounting" 
		 Warning="No">		
		 
	<cfset submit = "1">
		 
	<cfif operational eq "1">
	
	  <cfquery name="Journal" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT    *
			FROM      Journal
			WHERE     Mission       = '#URL.Mission#' 
			AND       SystemJournal = 'Procurement'				
		</cfquery>
		
		<cfquery name="Difference" 
	    	datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT    *
			    FROM      Ref_AccountMission
				WHERE     Mission       = '#URL.Mission#'
				AND       SystemAccount = 'ExchangeDifference' 
	    </cfquery>
		
		<cfif Journal.recordcount eq "0" or Difference.recordcount eq "0">
		
		    <cfoutput>
			<tr><td class="labelmedium"><cf_tl id="Financials Module Integration Notification(s)"></td></tr>
			<cfif Journal.recordcount eq "0">
			<tr><td class="labelmedium">
				<font color="FF0000">- <cf_tl id="An Incoming Invoice or Direct Payment journal for"> #URL.Mission# <cf_tl id="to be recorded and associated to the [Procurement] system journal attribute."></font>			
			</td></tr>
			</cfif>
			<cfif Difference.recordcount eq "0">
			<tr><td class="labelmedium">
				<font color="FF0000">- <cf_tl id="A GL Account enabled for"> #URL.Mission# <cf_tl id="and to be associated as a Exchange Rate system account">.</font>			
			</td></tr>
			</cfif>
			</cfoutput>
			<cfset submit = "0">			
								  
		</cfif> 			
				
	</cfif>	 
      
    <tr>
        
	<td> 
					
	  <table width="100%" align="center" class="formpadding">
	  
	    <tr class="line"><td colspan="2" style="font-size:27px;font-weight:200;height:45px;padding-left:18px" class="labelmedium"><cf_tl id="Invoice Registration"></td></tr>
				  			  			
		<tr>
		
		<td width="16%" class="labelmedium" style="padding-left:23px"><cf_tl id="Managed by">:</td>
		
		<td>  
   
    		<!--- HERE select the owner --->
			  
			<cfquery name="Mandate" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT  *
			      FROM     Ref_MissionPeriod
			   	  WHERE    Mission = '#url.Mission#'
				  AND      Period  = '#url.Period#'				
			</cfquery>
			
			<cfif url.mode eq "Warehouse">
			
				 <!--- show only the last parent org structure --->
				 <cfquery name="Owner" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT   DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
				      FROM     #Client.LanPrefix#Organization
				   	  WHERE    Mission     = '#Mandate.Mission#'
					  AND      MandateNo   = '#Mandate.MandateNo#'
					  AND      MissionOrgUnitId IN (SELECT MissionOrgUnitId 
					                                FROM   Materials.dbo.Warehouse 
													WHERE  Warehouse = '#url.warehouse#')
					  ORDER BY TreeOrder, OrgUnitName
				 </cfquery>
				 
				 <cfif owner.recordcount eq "0">
				 
					   <!--- show only the last parent org structure --->
					 <cfquery name="Owner" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT   DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
					      FROM     #Client.LanPrefix#Organization
					   	  WHERE    (ParentOrgUnit is NULL OR ParentOrgUnit = '' OR Autonomous = 1)
						  AND      Mission     = '#Mandate.Mission#'
						  AND      MandateNo   = '#Mandate.MandateNo#'
						  ORDER BY TreeOrder, OrgUnitName
					 </cfquery>				 
				 
				 </cfif>			    
			
			<cfelse>
	 
				  <!--- show only the last parent org structure --->
				 <cfquery name="Owner" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT   DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
				      FROM     #Client.LanPrefix#Organization
				   	  WHERE    (ParentOrgUnit is NULL OR ParentOrgUnit = ''  OR Autonomous = 1)
					  AND      Mission     = '#Mandate.Mission#'
					  AND      MandateNo   = '#Mandate.MandateNo#'
					  ORDER BY TreeOrder, OrgUnitName
				 </cfquery>
			 
			 </cfif>
			
			  <select name="orgunitowner" id="orgunitowner" class="enterastab regularxl">
			    <cfoutput query="Owner">
     		     	  <option value="#OrgUnit#" <cfif PO.OrgUnit eq OrgUnit>selected</cfif>>#OrgUnitName#</option>
         	    </cfoutput>  
              </select>	
			  
			  <cfoutput>		   			   
			     <input type="hidden" name="Mission" id="Mission" value="#URL.Mission#"> 
			  </cfoutput>	
			  
		  </td>
		  		   
			<cfoutput>
			  <input type="hidden" name="issuedmission"  id="issuedmission"   value = "#PO.Mission#"> 
			  <input type="hidden" name="issuedcurrency" id="issuedcurrency"  value = "#Line.Currency#"> 
			</cfoutput>  
		
		</tr>
		
		<tr>	  
		   <td width="200" class="labelmedium" style="padding-left:23px"><cf_tl id="Cost Center">:</TD>
           <td colspan="1" width="70%">	 
		   		    
				 <cfquery name="Center" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT   TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
				      FROM     #Client.LanPrefix#Organization
				   	  WHERE    Mission     = '#Mandate.Mission#'
					  AND      MandateNo   = '#Mandate.MandateNo#'
					  ORDER BY HierarchyCode
				 </cfquery>
				 
			    <select name="OrgUnitCenter" id="OrgUnitCenter" class="enterastab regularxl">
			    <cfoutput query="Center">
     		     	  <option value="#OrgUnit#" <cfif PO.OrgUnit eq OrgUnit>selected</cfif>>#orgunit# - #OrgUnitName#</option>
         	    </cfoutput>  
              </select>	
				     	   				
  		   
		   </td>	
		</tr>	
		
		<!--- ------------------------------------------------------------------- --->
		<!--- the period is in principle the same as the period of purchase order --->
		<!--- ------------------------------------------------------------------- --->
				
		<tr>	  
		   <td width="200" class="labelmedium" style="padding-left:23px"><cf_tl id="Period">:</TD>
           <td colspan="1" width="70%">	 		
		   
		   	<cfquery name="Period" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_Period
					WHERE  Period = '#PO.Period#'					
				</cfquery>		     	   
						   
				<cfquery name="tPeriod" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT DISTINCT Period
				    FROM   Purchase
					WHERE  Mission = '#URL.Mission#'
					AND    Period IN (SELECT Period FROM Program.dbo.Ref_Period WHERE DateEffective >= '#Period.DateEffective#')					
				</cfquery>
	    	 
			    <select name="Period" id="Period" size="1" class="regularxl enterastab">
				    <option value="" selected><cf_tl id="All"></option>
				    <cfoutput query="tPeriod">
						<option value="#Period#" <cfif PO.Period eq Period>selected</cfif> >#Period#</option>
					</cfoutput>
				</select>
  		   
		   </td>	
		</tr>	
			
		
		<tr>	  
		   <td width="200" class="labelmedium" style="padding-left:23px"><cf_tl id="Date Received">:</TD>
           <td colspan="1" width="70%">	 
     	   
	    	   <cf_intelliCalendarDate9
			      Class="regularxl enterastab"
    		      FieldName="documentdatereceived" 
				  Manual="True"				
				  DateValidEnd="#Dateformat(now()+1, 'YYYYMMDD')#"
    		      Default="#Dateformat(now(), CLIENT.DateFormatShow)#">		
  		   
		   </td>	
		</tr>	
			
			<cfquery name="OrgUnit" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM Organization
					WHERE OrgUnit = '#URL.OrgUnit#'
			</cfquery>				
				
			<cfif orgunit.recordcount eq "1">
			
				<!--- vendor invoice --->
				
				<tr><td colspan="1" class="labelmedium" style="height:28px;padding-left:23px" class="labellarge">
							   
				<cfoutput>
					
				     <cf_tl id="Vendor">
					 
					 </td>
					 
					 <td>
									
					  <a href="javascript:viewOrgUnit('#OrgUnit.OrgUnit#')">#OrgUnit.OrgUnitName#</a>
					   <input type="hidden" name="orgunit"  id="orgunit"  value="#OrgUnit.OrgUnit#"> 
					   <input type="hidden" name="personno" id="personno" value=""> 					
					
					</td>
				</cfoutput>
				<cfset md = "org">
			
			<cfelse>
			
				<cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM  Person
					WHERE PersonNo = '#URL.PersonNo#' 
				</cfquery>	
								
				<cfoutput>
				
				<tr><td height="20" colspan="1" class="labelmedium" style="padding-left:23px">				
					
				     <cf_tl id="Claim"> :</font>
					 
					  </td>
					 
					 <td>
							
										
					  <a href="javascript:EditPerson('#Person.PersonNo#')"><font color="0080C0">#Person.FirstName# #Person.LastName#</a>
					   <input type="hidden" name="orgunit"  id="orgunit"  value="0"> 
					   <input type="hidden" name="personno" id="personno" value="#Person.PersonNo#"> 
					   
					  </td> 
										
				</cfoutput>		
				
				<cfset md = "per">	
			
			</cfif>
			
			</td>
			
		 </tr>	
				
		 <tr>
			    <TD class="labelmedium" style="padding-left:23px">
					<cfif md eq "org">
						<cf_tl id="Invoice">
					<cfelse>
						<cf_tl id="Document">
					</cfif> 
					<cf_tl id="Category">:
				</TD>
				
			    <TD>    		
					<select name="OrderType" id="OrderType" class="regularxl enterastab">
					    <cfoutput query="OrderType">
							<option value="#Code#" <cfif PO.OrderType eq "#code#">selected</cfif>>#Description#</option>
						</cfoutput>
					</select>					
				</TD>
				
		 </tr>		
		 		 		 		  	  	    			
		 <TR>		  
		   <TD class="labelmedium" style="padding-left:23px"><cfif md eq "org"><cf_tl id="Invoice/Reference"><cfelse><cf_tl id="Document"></cfif> No: <font color="FF0000">*</font></TD>
           <td colspan="1">	
		   
		       <table>
			   
				   <tr>
				   <td>			   
				   <cfinput type="Text" style="width:100px;padding-left:5px" class="regularxl enterastab" name="invoiceseries" value="" required="No" size="10" maxlength="10"> 
				   </td>
				   
				   <td style="padding-left:3px">				   
				   <cf_tl id="Record an invoice no" var="inv">		   
				   <cfinput type="Text" class="regularxl enterastab" name="invoiceno" value="" message="#inv#" required="Yes" size="25" maxlength="30"> 
				   </td>
				   </tr>
			   
			   </table>
			   
		   </td>						  
		 </tr>
		 
		 <cfif orgunit.recordcount eq "0">
		 
			  <tr>		  
			   <td class="labelmedium" style="padding-left:23px"><cf_tl id="Issued by">:</TD>
	           <td colspan="1">			   	   
				  <cfinput type="Text" class="regularxl enterastab" name="InvoiceIssued" value="" required="No" size="40" maxlength="60"> 			
			   </td>						  
			  </tr>
			 
			  <tr>		  
			   <td class="labelmedium" style="padding-left:23px"><cf_tl id="Issue Reference">:</TD>
	           <td colspan="1">			   	   
				  <cfinput type="Text" class="regularxl enterastab" name="InvoiceReference" value="" required="No" size="20" maxlength="20"> 			
			   </td>						  
			  </tr>
		 
		 <cfelse>
		 
			<tr>		  
			   <td class="labelmedium" style="padding-left:23px"><cf_tl id="Reference">:</TD>
	           <td colspan="1">			   	   
				  <cfinput type="Text" class="regularxl enterastab" name="InvoiceReference" value="" required="No" size="40" maxlength="40"> 			
			   </td>						  
			  </tr>
			  
			 <input type="hidden" name="InvoiceIssued"    value="">
		 
		 </cfif>
		 		 			
	     <tr >	  
		   <TD class="labelmedium" style="padding-left:23px">
		   		<cfif md eq "org">
					<cf_tl id="Date on Invoice">
				<cfelse>
					<cf_tl id="Document date">
				</cfif>: <font color="FF0000">*</font></TD>
           <td colspan="1">	 
     	   
	    	   <cf_intelliCalendarDate9
			      Class="regularxl enterastab"
				  Manual="False"
    		      FieldName="documentdate" 
				  scriptdate="terms"
				  DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"
    		      Default="#Dateformat(now(), CLIENT.DateFormatShow)#">		
  		   
		   </td>	
		 </TR>	
		 		 
		 <tr>
				   
			   <TD class="labelmedium" style="width:24%;padding-left:23px"><cf_tl id="Terms">: <font color="FF0000">*</font></TD>
			   
			      <cfquery name="vendor" 
					 datasource="AppsOrganization" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">	  
					   SELECT   TOP 1 * 
					   FROM     Organization
					   WHERE    OrgUnit = '#URL.OrgUnit#'									  
				    </cfquery>		
					
					<cfif vendor.terms neq "">
													
						<cfset term = vendor.terms>
					
					<cfelse>
					
					  <cfquery name="prior" 
						 datasource="AppsPurchase" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">	  
						    SELECT   TOP 1 * 
						    FROM     Invoice
						    WHERE    Mission = '#url.mission#'
						    AND      OrgUnitVendor = '#URL.OrgUnit#'	
						    ORDER BY Created DESC
					    </cfquery>	
													
						<cfset term = prior.ActionTerms>	
													
					</cfif>							     
					
					<cfquery name="Terms" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  * 
							FROM    Ref_Terms 
							WHERE   Operational = 1
					</cfquery>
   		   
				     <td>
					 
					 <table><tr><td>
						  <select name="actionterms" id="actionterms" onChange="terms(this.value)" class="regularxl enterastab">
							
				   		      <option value=""><cf_tl id="None"></option>  
							  <cfoutput query="Terms">
				     		   	  <option value="#Code#" <cfif code eq term>selected</cfif>>#Description#</option>
				         	  </cfoutput>  
				            
					      </select>		
						  </td>
						  <td><cfdiv id="termsbox" bind="url:setTerms.cfm?id=#term#&date=#dateformat(now(),client.dateformatshow)#"></td>	
						  </tr></table>								  
					  </td>		
						  									  
					  												
			   
		</tr>
		
		<tr class="line">		
					  
		  	  <td class="labelmedium" style="padding-left:23px;padding-right:10px"><cf_tl id="Due date">:</td>
			  
			  <td>
   	  
			   <cf_intelliCalendarDate9
			      Class="Regularxl enterastab"
			   	  FieldName="actionbefore" 
				  Manual="False"
				  DateValidStart="#Dateformat(now()-380, 'YYYYMMDD')#"
		    	  Default="#Dateformat(now()+Parameter.InvoiceDueDays, CLIENT.DateFormatShow)#">		
			  
			  </td>				
						  
		</tr>				  
		
		<tr id="discount" class="line">	   
	    
		      <td class="labelmedium" style="padding-left:23px;padding-right:10px"><cf_tl id="Discount date">:</td>		   

			   <td>
			    							  
		  		 <cf_intelliCalendarDate9
				      Class="Regularxl enterastab"
				   	  FieldName="actiondiscountdate" 
					  Manual="True"
					  DateValidStart="#Dateformat(now()-380, 'YYYYMMDD')#"
			    	  Default="">															  
									 		   		   
			   </td>	
			   
		  </tr>
				 
		  <cfquery name="CurrencySelect" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM Currency
				<cfif Parameter.InvoiceRequisition eq "1">
				<!--- always enforce currency on case of invoice mapping per line, even if PO is receipt based --->
				WHERE Currency = '#Line.Currency#' OR Currency = '#curr#'
				<cfelse>
				WHERE EnableProcurement = 1 OR Currency = '#curr#'
				</cfif>
		  </cfquery>	
		 			  
		  <TR class="line"> 
		 
              <TD style="padding-left:23px" class="labelmedium">
			  
			  	<cf_tl id="Amount on"> 
				<cfif md eq "org">
					<cf_tl id="Invoice">
				<cfelse>
					<cf_tl id="Document">
				</cfif>: <font color="FF0000">*</font>
				
			  </TD>
			  				
              <td colspan="1">	
			  
			  	<table cellspacing="0" cellpadding="0" class="formpadding">
				 
				  <tr>	
				  
				   <cfif Parameter.TaxExemption eq "0">
					   
					   	 <cfif Parameter.InvoiceRequisition eq "0"> 
						      <cfset tag = "tagging(this.value)">
						 <cfelse>
						      <cfset tag = "">
						 </cfif>
						   
				   <cfelse>	   
				   
				   	     <cfif Parameter.InvoiceRequisition eq "0">  <!--- or PO.InvoiceWorkflow eq "0" --->
						      <cfset tag = "yes">
						 <cfelse>
						      <cfset tag = "no">
						 </cfif>
						   
				   </cfif>  
				  
				   <cfif url.mode eq "Warehouse">
				   
					   <td>
				   
						<table cellspacing="0" cellpadding="0" class="formpadding">
						
							<!--- added by hanno 15/8/2012 to split the amount by transaction / category --->
							
							<cfquery name="getTotalDetails" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">	  
						
							    <!--- get the summary by equipment category to support the distribution by line --->
							
							    SELECT     'Issuance' as Type, R.Description as Category, SUM(TS.SalesTotal) AS Amount
								FROM       ItemTransactionShipping TS 
								           INNER JOIN ItemTransaction T ON TS .TransactionId = T .TransactionId 
										   INNER JOIN WarehouseBatch B ON T .TransactionBatchNo = B.BatchNo 
										   INNER JOIN AssetItem AI ON T.AssetId = AI.AssetId 
										   INNER JOIN Item I ON AI.ItemNo = I.ItemNo
										   INNER JOIN Ref_Category R ON I.Category = R.Category
								WHERE      B.TransactionType = '2'
								
								#preservesinglequotes(invoicecondition)#
								GROUP BY R.Description
										
								UNION
						
								SELECT     'Transfer' as Type, R.Description as Category, SUM(TS.SalesAmount) AS Amount
								FROM       ItemTransactionShipping TS 
								           INNER JOIN ItemTransaction T ON TS .TransactionId = T .TransactionId 
										   INNER JOIN WarehouseBatch B ON T .TransactionBatchNo = B.BatchNo 
										   INNER JOIN Ref_Category R ON B.Category = R.Category
								WHERE      T.TransactionType = '8'
								
								#preservesinglequotes(invoicecondition)#
								
								GROUP BY R.Description
								
								ORDER BY Type,R.Description
															
						    </cfquery>	
							
							<cfset sum = 0>
							
							<cfoutput>
							
								<cfloop query="getTotalDetails">
								
									<cfset sum = sum+amount>
		
									<tr><td class="labelmedium" style="padding-left:3px"><font color="808080">#Type#</td><td style="padding-left:4px"><font color="808080">#Category#</td><td align="right" style="padding-left:4px">#numberformat(amount,",__.__")#</td></tr>
								
								</cfloop>
								
								<cfif abs(total-sum) gt 0.5>
								
									<tr><td class="labelmedium" colspan="2" style="padding-left:3px"><font color="808080">Other transactions</td><td align="right" style="padding-left:4px">#numberformat(total-sum,",__.__")#</td></tr>
								
								</cfif>
								
								<tr><td colspan="3" class="line"></td></tr>
								
								<tr>
									<td class="label"></td>
									<td></td>
									<td height="18" class="labelmedium">	
																		
									    #curr# <b>#numberformat(total,",.__")#								
										<input type="hidden" name="currency" value="#curr#">
										<input type="hidden" name="documentamount" value="#total#">
									
									</td>
								</tr>
							
							</cfoutput>
							
							</table>
							
							</td>
																			
					<cfelse>	
					
						<td>		  
							  
				  	   <select name="currency" id="currency" onChange="tagging (); checkJournal('<cfoutput>#PO.PurchaseNo#</cfoutput>');" class="regularxl enterastab">
					    <cfoutput query="CurrencySelect">
		     		   	  <option value="#Currency#" <cfif Currency eq curr>selected</cfif>>#Currency#</option>
		         	    </cfoutput>  
		               </select>	
					  					  		   
				   
					   <cfif Parameter.TaxExemption eq "0">					   
					   	  						  
						   <cfinput type="Text"
						       name="documentamount"
						       message="Enter a valid amount"
						       validate="float"
						       required="Yes"
						       visible="Yes"
						       enabled="Yes"
						       size="10"
							   value="#numberformat(total,",.__")#"
							   class="regularxl enterastab"
						       maxlength="15"
						       style="text-align: right;"
							   onchange="#tag#;_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoicePayable.cfm?documentamount='+this.value+'&tax=0&tag=no','payable')">						    
					   
					   <cfelse>					   				   
						   					   
						   <cfinput type = "Text"
						       name      = "documentamount"
						       message   = "Enter a valid amount"
						       validate  = "float"
						       required  = "Yes"
						       visible   = "Yes"
							   value     = "#numberformat(total,",.__")#"							  
						       enabled   = "Yes"
						       size      = "10"
							   class     = "regularxl enterastab"
							   style     = "text-align: right;"
						       maxlength = "15"
							   onchange  = "ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoiceExemption.cfm?tag=#tag#&documentamount='+this.value+'&tax='+tax.value,'exemption')">
							   
						</cfif>   
						
						</td>
						
						<td width="2"></td>
					
    					<td id="documentamounttotal" class="labelmedium"></td>
						
						<td width="2"></td>
																		   
						<td class="labelmedium" style="padding-left:7px">
						   
						   <cfoutput>	 
						  	 <a href="javascript:ProsisUI.createWindow('linedetail', 'Detailed Information', '',{x:600,y:0,height:450,width:620,closable:true,resizable:true,modal:true,center:true});ptoken.navigate('InvoiceEntryLine.cfm?tax='+document.getElementById('tax').value+'&mission=#url.mission#&id=#guid#','linedetail')"><cf_tl id="Record in detail"></a>
						   </cfoutput>	 
						   
						</td>
						
					</cfif>	
					
					</tr>
				  
				  </table>
				</td>
				
			  </tr>	  	
			  
			  <cfif Parameter.TaxExemption eq "1">
			  
				  <tr>		
						<TD class="labelmedium" style="padding-left:23px;padding-right:5px"><cf_tl id="Tax Exemption">:</TD>
				        <TD>
						
							<table cellspacing="0" cellpadding="0">
							
								<tr>
									<td>
									   		
									<cfinput type="Text" 
										name="tax" 
										maxlength="2" 
										value="#Line.OrderTax*100#"
										message="Enter a valid percentage" 
										validate="float" 
										required="Yes" 
										class="regularxl enterastab"										
										style="text-align: center;width:25" 
										onChange="ptoken.navigate('InvoiceExemption.cfm?tag=#tag#&documentamount='+documentamount.value+'&tax='+this.value,'exemption')">
										
									</td>
									<td class="labelmedium" width="19" align="center">%</td>													 
						           
								    <td colspan="1" id="exemption" style="padding-top:4px;padding-left:1px">	
								  
								  			<input type="Text"
										       name="ExemptionAmount"
											   id="ExemptionAmount"
										       message="Enter a valid amount"
										       validate="float"
										       required="Yes"
											   readonly											   
											   value="0.00"				      
										       size="15"
											   class="regularxl enterastab"
										       maxlength="15"										      
											   style="border:0px;font-size:14px;height:19;text-align: left;padding-right:2px" >
											   
									</td>		
																											
								</tr>
							
						  </table>
						
					</TD>
					
				 </TR>
				 
				 <input type="hidden" name="taxexemption" id="taxexemption" value="1">	
				 
			 <cfelse>
			 
			 	<tr>
			    <TD style="height:30px;cursor: pointer;padding-left:23px" class="labelmedium"><font color="006688"><cf_UIToolTip tooltip="Check option if this invoices has tax exemption applied"><cf_tl id="Tax Exemption">:</cf_UIToolTip></TD>
			
				<td>
					<input type="checkbox" class="radiol enterastab" name="taxexemption" id="taxexemption" value="1">
				</td>
				</tr>
									
				<input type="hidden" name="tax" id="tax" value="0">	 
			 
			 </cfif>
			 
							
			 <TR class="line"> 
				 	 
        	  <TD style="cursor: pointer;padding-left:23px" class="labelmedium"><font color="006688"> 
			    <cf_UIToolTip tooltip="Adjusted Invoice Amount after the Tax exemption correction"><cf_tl id="Amount Charge">:</cf_UIToolTip></TD>
				
				<td>
				<table>
				
				<tr>
												
				 <td colspan="1" style="padding-top:1px;padding-bottom:1px">	
				  
     		      	  <cfdiv bind="url:setJournal.cfm?mission=#url.mission#&purchaseno=#PO.PurchaseNo#&owner={orgunitowner}&currency={currency}" 
					    id="postingJournalselect">	  
					  
					  
	    		   </td>	
				   
				   <td colspan="1" id="payable" style="padding-left:3px" class="labelmedium">	
			  			  			  
				     <cfoutput>
				  			  
				  		<input type=  "Text"
					       name    =  "amountpayable"		
						   id      =  "amountpayable"		      
					       validate=  "float"
					       readonly
						   value   =  "#numberformat(total,',.__')#"	
		    		       visible =  "Yes"
						   class   =  "regularxl enterastab"
					       enabled =  "Yes"				       
					       maxlength= "15"
					       style    = "width:160px;background-color:f4f4f4;border:1px solid silver;font-size:17px;height:26;text-align:right;padding-right:2px">					   					
					   
					   </cfoutput>
						   
			       </td>
				
				</tr>
				
				</table>
				
				</td>
						
		   </tr>	  	  									
			
		   <tr>	  
		   
		       <TD width="140" class="labelmedium" style="padding-top:4px;padding-left:23px" valign="top"><cf_tl id="Memo">:</TD>
               <td colspan="1" style="padding-top:3px;padding-bottom:3px">	 
     	      	   <textarea class="regular" rows="2" totlength="400"  style="width:99%;font-size:13px;padding:3px" onkeyup="return ismaxlength(this)" name="Description"></textarea>
    		   </td>	
			   
		   </TR>	
			  		   
		   <TR class="line">
			     <td valign="top" class="labelmedium" style="padding-top:4px;padding-left:23px"><cf_tl id="Attach"> <cfif md eq "org"><cf_tl id="Invoice"><cfelse><cf_tl id="Document"></cfif>:</td>
				 <td colspan="1">
				     <cfset access = "edit">
					 <cfset url.id     = "#GUID#">
					 <cfinclude template="InvoiceEntryAttachment.cfm">					
				 </td>
			</TR>			
						
			<input type="hidden" name="InvoiceWorkflow" id="InvoiceWorkflow" value="#PO.InvoiceWorkflow#">
			 
			<cfif PO.InvoiceWorkflow eq "0">
			
				<tr style="height:30px">
					<td style="padding-left:23px" height="18" class="labelmedium"><font color="808080"><cf_tl id="Payable Routing">:</td>
					<td class="labelmedium"><cf_tl id="Routing Option not applicable for this type">.</td>
				</tr>
				<input type="hidden" name="EntityClass" id="EntityClass" value="">
							
			<cfelse>
			
				<cfinclude template="InvoiceRouting.cfm">										    			
							
			</cfif>		  			
					
					
			<tr class="line"><td colspan="2" style="height:50px;font-size:27px;font-weight:200;padding-left:18px" class="labelmedium line"><cf_tl id="Invoice Payable Funding"></b></td></tr>
						
			<!--- ---------------------------------------- --->	
			<!--- for matching invoice against requisition --->
			<!--- ---------------------------------------- --->			
			
			<cfif Parameter.InvoiceRequisition eq "0" or PO.InvoiceWorkflow eq "0">
				
				    <tr>
					<td colspan="4" style="padding-left:10px;padding-right:10px">										
						<cfinclude template="InvoiceEntryMatchHeader.cfm">							
					</td>
					</tr>		
					
			<cfelse>	
									
					<tr>
						<td width="181" class="labelmedium" style="padding-left:23px"><cf_tl id="Amount Payable">:</td>
						
						<td height="20" colspan="1" class="labellarge" id="totalsum" width="85%">
						
							<cfoutput>
							<b>#numberformat(0,",.__")#</b>
							</cfoutput>			
						
						</td>
						
					</tr>
				
					<tr>
						<td colspan="2" style="padding-left:23px;padding-right:10px">
							<cfinclude template="InvoiceEntryMatchRequisition.cfm">				
						</td>
					</tr>
					
			</cfif>		
			
			<!--- -------------------- --->				 	
			<!--- mapping to a tagging --->
			<!--- -------------------- --->
								
			<cfif parameter.EnableInvTag eq "1">
			
			<tr><td height="5"></td></tr>
			
			    <!--- embed the labeling script --->
				
				<cfquery name="DELETE" 
				datasource="AppsLedger">
						DELETE FROM FinancialObject
						WHERE EntityCode = 'INV'
						AND   OfficerUserId = '#SESSION.acc#'
						AND   ObjectKeyValue4 NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice)									
				</cfquery>	
						
				<cf_ObjectListingScript entitycode="INV"> 
				<tr><td colspan="2">
				
					<table width="100%" class="formpadding" cellspacing="0" cellpadding="0" align="center">
					
					<tr><td height="25" style="font-size:27px;font-weight:200;height:30px;padding-left:18px" class="labelmedium"><cf_tl id="Cost Tagging"></b></td></tr>
					
					<TR><TD id="label" style="padding-left:20px">
							
						  <cf_ObjectListing 
							    TableWidth       = "96%"
								Label            = "No"
							    EntityCode       = "INV"
								ObjectReference  = "Invoice"
								ObjectKey        = "#GUID#"
								Mission          = "#URL.Mission#"
								Amount           = "0" 
								Entry            = "Multiple"
								Object           = "Purchase.dbo.RequisitionLineFunding"  
								Currency         = "#APPLICATION.BaseCurrency#">
							
						</TD>
					</TR>
					</TABLE>
				
				</td>
				</tr>  
					
				</cfif>	 
				
				<cfif submit eq "0">
				
				<tr><td colspan="2" class="linedotted"></td></tr>
	
				<tr><td height="3" class="labelmedium" colspan="2" height="30" align="center">
					<font color="red">
						<cf_tl id="You must resolve the listed Financials Integration"> 
						<cf_tl id="problem before you may submit any invoices">.
					</font>	
				</td></tr>				
				
				<cfelse>
				
								 	 	 
				 <tr>
				  <td align="center" colspan="2">
		  
				  <table><tr>
					   <td align="center">
					   						  
						  <cfif Parameter.InvoiceRequisition eq "0">  <!--- or PO.InvoiceWorkflow eq "0" --->						
						  	 	<input type="submit" class="button10g" style="width:130px;height:28px;font-size:12px" name="Save" id="Save" value="Save" onClick="return check()">
								
						  <cfelse>
						        <input type="submit" class="button10g" style="width:130px;height:28px;font-size:12px" name="Save" id="Save" value="Save">													
								<input type="hidden" name="Requisition" id="Requisition" value="Requisition">												  
						  </cfif>
					  </td>
					 </tr>
				 </table>
		       </td>
			  </tr> 	
			  
			  </cfif>
			  			 		 
	 </table>
	 	 
	  </cfform>  
	 	 
 </td></tr>
	 
</table>
	
<cf_screenbottom layout="innerbox">