
<cfparam name="URL.Category" default="">
<cfparam name="editmode"     default="full">

<cf_dialogOrganization>
<cf_dialogPosition>
<cf_dialogProcurement>
<cf_dialogMaterial>
<cf_dialogLedger>
<cf_calendarScript>
<cf_menuscript>
<cf_fileLibraryScript>
<cf_calculatorScript>

<cfquery name="Journal"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Journal J
	WHERE  Operational = 1
	<cfif URL.category neq "">
	AND   TransactionCategory = '#URL.Category#'	
	</cfif>
	AND   Mission = '#URL.Mission#'
	<cfif getAdministrator(url.mission) eq "1">	
			<!--- no filtering --->
	<cfelse>	
			AND Journal IN (SELECT ClassParameter 
			                FROM   Organization.dbo.OrganizationAuthorization 
					        WHERE  UserAccount = '#SESSION.acc#' 
							  AND  AccessLevel IN ('1','2')
			                  AND  Role = 'Accountant') 
	</cfif>		
</cfquery>

<cfoutput>
<cfif journal.recordcount eq "0">
	<cf_message message="Problem, no #URL.Category# journal has been configured.">
	<cfabort>
</cfif>
</cfoutput>

<cfif url.journal eq "" or not findNoCase(url.journal,valueList(Journal.Journal)) or url.journal eq "undefined">

	<cfset url.journal = journal.journal>
		
	<cfquery name = "HeaderSelect"
	   datasource = "AppsQuery" 
	   username   = "#SESSION.login#" 
	   password   = "#SESSION.dbpw#">
	    UPDATE #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction#
		SET Journal = '#journal.journal#', TransactionCategory = '#journal.TransactionCategory#'		
	</cfquery>
	
</cfif>

<cfquery name="SpeedType"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Speedtype
	WHERE  Speedtype IN (SELECT Speedtype
	                     FROM   Journal 
						 WHERE  Journal = '#url.journal#')
</cfquery>	

<cfif Speedtype.recordcount eq "0">
	<cfset institutiontree   = "">		
<cfelse>
	<cfset institutiontree   = "#speedtype.institutiontree#">				
</cfif>

<cfquery name="HeaderSelect"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction# 
</cfquery>

<cfparam name="URL.EntryAmount" default="#HeaderSelect.DocumentAmount#">

<cfif HeaderSelect.recordCount is 0>
     <cfabort>
</cfif>

<cfoutput query="HeaderSelect">
    <cfset glacc  = ContraGLAccount>
	<cfset tracat = TransactionCategory>
</cfoutput>

<!--- not relevant anymore 
<cfif traCat is "Payment" and #CLIENT.JournalStatus# eq "edit">
      <cfset traCat = "DirectPayment"> 
	  <!--- act like a direct payment --->
</cfif>
--->

<cfif glacc neq "">

    <cfquery name="Gledger"
     datasource="AppsLedger" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
        SELECT Description
    	FROM   Ref_Account WHERE GLAccount = '#glacc#'
    </cfquery>
    
    <cfset glaccdes = Gledger.Description>
    
</cfif>

<cfquery name="Period" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Period 
	<cfif getAdministrator(url.mission) eq "0">
	WHERE  ActionStatus = '0' 
	</cfif>
</cfquery>

<cfquery name="Jrn" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM  Journal 
	WHERE Journal = '#url.journal#' 
</cfquery>

<cfquery name="Bank" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_BankAccount 
	WHERE  Currency = '#HeaderSelect.Currency#'
	<cfif Jrn.BankId neq "">
	AND   BankId = '#jrn.BankId#' 
	</cfif>
</cfquery>

<cfif Bank.recordcount eq "0">

	<cfquery name="Bank" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_BankAccount 
		WHERE  Currency = '#HeaderSelect.Currency#'
	</cfquery>
	
</cfif>

<cfoutput>

<cf_ajaxRequest>
 
<span class="hide" id="process"></span>

<script language="JavaScript">

function setscopeno() {
	ptoken.navigate('setTransactionScope.cfm?scopeno=#session.mytransaction#','process')
}

function reloadForm(journal,period,category) {    
    Prosis.busy('yes');
    ptoken.open("TransactionPrepare.cfm?ts="+new Date().getTime()+"&Mission=#URL.Mission#&OrgUnitOwner=#URL.OrgUnitOwner#&Journal=" + journal +"&AccountPeriod=" + period +"&Category=" + category,"transactionbox");
}

function bankbase(op,cl,exc) {

transactionheader.documentamount.value = cl-op;
transactionheader.debitcredit.value = "Debit"

if (transactionheader.documentamount.value < 0) { 
    transactionheader.documentamount.value = transactionheader.documentamount.value * -1
    transactionheader.debitcredit.value = "Credit"
}

var s = " " + Math.round((transactionheader.documentamount.value / exc) * 100) / 100
var i = s.indexOf('.')
if (i < 0) 
return transactionheader.baseamount.value = s + ".00"

var t = s.substring(0, i + 1) + s.substring(i + 1, i + 3)
if (i + 2 == s.length) t += "0"
return transactionheader.baseamount.value = t
}

function maximize(id) {

   se = document.getElementById('t_'+id)
   icM = document.getElementById('t_'+id+'_Min')
   icE = document.getElementById('t_'+id+'_Exp')
   
   if (se.className == "hide") {
	     se.className = "regular"
		 icM.className = "regular"
		 icE.className = "hide"
	  } else {
	    se.className  = "hide" 
		icM.className = "hide"
	    icE.className = "regular"
	  }	  
	  
}	

function applycontra(acc) {
   ptoken.navigate('setContra.cfm?account='+acc,'processmanual')   
}  

function applyaccount(acc) {
   ptoken.navigate('setAccount.cfm?account='+acc,'processmanual')
}  

function applyprogram(prg,scope) {
   ptoken.navigate('setProgram.cfm?programcode='+prg+'&scope='+scope,'processmanual')
}  

function applydonor(clid,scope) {  
   ptoken.navigate('setDonor.cfm?ContributionLineId='+clid+'&scope='+scope,'donorbox')
}  

function applyitem(itmuomid) {   
   ptoken.navigate('setItem.cfm?ItemUoMId='+itmuomid,'processmanual')
}  
  
function purge() {

   if (confirm("Do you want to remove this Transaction ?"))  {
		window.location="TransactionPurge.cfm?";
		return true;
	}	
	return false
  }

	var ptday   = new Array();
	var ptdisc  = new Array();
	var ptdisd  = new Array();

	<cfquery name="Terms" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_Terms 
	</cfquery>

	<cfloop query="Terms">
	   ptday[#Code#]   = "#PaymentDays#";
	   ptdisc[#Code#]  = "#Discount#";
	   ptdisd[#Code#]  = "#DiscountDays#";
	</cfloop>

function terms(selected) {
     transactionheader.actiondiscount.value      = ptdisc[selected];
	 transactionheader.actiondiscountdays.value  = ptdisd[selected];
	 transactionheader.actiondays.value          = ptday[selected]; 
}

function doSubmit(element) {	
    Prosis.busy('yes')
	element.disabled = true;	
	document.getElementById('transactionheader').onsubmit() 	
	ptoken.navigate('TransactionSubmit.cfm?journal=#URL.Journal#&closewindow=1','resultbox','','','POST','transactionheader');		
}

function doSubmitContinue(element) {
	Prosis.busy('yes')
	element.disabled = true;
	document.getElementById('transactionheader').onsubmit()
	ptoken.navigate('TransactionSubmit.cfm?journal=#URL.Journal#&closewindow=1','resultbox','','','POST','transactionheader');
}

function toggleGroup(selector){
	if ($(selector).first().is(':visible')) {
		$(selector).hide();
	}else{
		$(selector).show();
	}
}

function togglebox(val) {
	document.getElementById('empbox').className='hide'
	document.getElementById('perbox').className='hide'	
	document.getElementById('venbox').className='hide'
	document.getElementById('cusbox').className='hide'
	document.getElementById(val+'box').className='regular'
}

</script>	  

</cfoutput>
	
	<table class="formpadding" width="100%" style="height:100%">
		
	    <tr><td id="transactionbox" valign="top" style="height:100%">	
		
		<cfform name="transactionheader" id="transactionheader" onsubmit="return false" style="height:98%">
	
		<table class="formpadding" width="100%" height="100%" style="min-width:1150px" align="center">
		
		<tr class="hide"><td id="process"></td></tr>
		
		  <!--- box for saving the transaction --->	
		  
		  <tr class="xhide">
			    <td colspan="2" style="height:1px" width="100%" valign="top" id="resultbox"></td>
		  </tr>
		  
		  <tr>
		  
		    <td colspan="2" height="30" valign="top" bgcolor="ffffff"> 	
							
			  <table width="98%" align="center" >		
			  			   
			   <tr><td style="padding-left:17px;padding-right:17px">		   
			   
			   <table width="100%" align="center" class="formpadding">		
			   
			    <cfoutput>	
			   
			   <tr class="line">
			   
			    <TD colspan="1" class="labelmedium2"><cf_tl id="Fiscal Period">:</TD>			 	 	  			  
				        
				  <td colspan="7" style="height:45px">
				  
				   <table style="width:100%"><tr><td>
				  					   
					    <cfif HeaderSelect.JournalSerialNo eq "" or HeaderSelect.JournalSerialNo neq "">
														  
					    <select name="accountperiod" 
						   id="accountperiod" 
						   class="regularxxl enterastab" 
						   style="background-color:f4f4f4;border:0px;height:40px;font-size:28px"
						   onchange="ptoken.navigate('TransactionDetailEntry.cfm?mission=#url.mission#&journal=#url.journal#&accountperiod='+this.value,'contentbox1')">
							 
				            <cfloop query="Period">
				        	   <option value="#AccountPeriod#" <cfif AccountPeriod is HeaderSelect.AccountPeriod>selected</cfif>>
				           	   #AccountPeriod# <cfif actionstatus eq "1">[<cf_tl id="locked">]</cfif>
							   </option>
				         	</cfloop>
				
			           </select>
				   
					   <cfelse>					   
					     
				    	    <input type="text" 
						       name="accountperiod" 
							   id=-"accountperiod"
							   value="#HeaderSelect.AccountPeriod#" 							   
							   readonly 
							   style="font-size:25px;height:35px;"
							   class="regularxxl enterastab">
			    		  					   
					   </cfif>
					   
				   
				  </td>   
				  				  
		          <td align="right" class="labelmedium2" style="color:brown;font-size:20px;padding-top:9px">
				  		  
				  <cfif (HeaderSelect.JournalSerialNo eq "" and HeaderSelect.ParentJournal eq "" and url.source eq "") or URL.category neq "">
				  		  
				  <select name="journal" id="journal" class="regularxxl enterastab" onChange="reloadForm(this.value,document.getElementById('accountperiod').value,'<cfoutput>#url.category#</cfoutput>')">		     		      
		            <cfloop query="Journal">
		        	<option value="#Journal#" <cfif Journal is URL.Journal>selected</cfif>>
		           		#Journal# #Description#
					</option>
		         	</cfloop>			
			       </select>
				   
				   <cfquery name="Jrn"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
						FROM   Journal
						WHERE  Journal = '#URL.Journal#'
					</cfquery>
				  
				  <cfelse>
										  
					<cfquery name="Jrn"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
						FROM   Journal
						WHERE  Journal = '#URL.Journal#'
					</cfquery>
				  
				    <cfloop>
					   #URL.Journal# #Jrn.Description#
			    	    <input type="hidden" id="journal" name="journal" value="#URL.Journal#" size="10" maxlength="10" readonly class="regular">
		    		</cfloop>
					
				  </cfif>
				  
				  </td></tr></table>	  	
			  
				  </td>						   		
				 				  
			   </tr>
			 			   
			   <TR style="height:30px">  		     					 				   
					   
					   <cfparam name="url.glaccount" default="">
					   
					   <cfquery name="ContraAccount"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   A.*, R.Description
							FROM     JournalAccount A INNER JOIN Ref_Account R ON A.GLAccount = R.GLAccount
							WHERE    Journal  = '#HeaderSelect.Journal#' 	
							AND      Mode     = 'Contra'
							ORDER BY ListOrder, ListDefault DESC 
						</cfquery>
																		
					   <input class="hide" type="hidden" id="processaccount" value="process" onClick="setline()">	
					 					 						
					  
					   <cfif ContraAccount.recordcount eq "0" and HeaderSelect.contraGLAccount eq "">
					   					   					   
					        <TD class="labelmedium2"><cf_tl id="Contra-Account">:</TD>			   
		    			    <td colspan="4">	
															   
					   		<table cellspacing="0" cellpadding="0"><tr>
								  
								  <td style="padding-right:2px">
								  					  
								  <input type="text" name="glaccount"     id="glaccount"      class="regularxxl" value="" size="12" readonly style="text-align: center;">
				         		  <input type="text" name="gldescription" id="gldescription"  class="regularxxl" value="" size="40" readonly style="text-align: center;">
								  
								  </td>
								  
								  <td>
					         
							     <img src="#SESSION.root#/Images/search.png" alt="Select" name="img56" 
									  onMouseOver="document.img56.src='#SESSION.root#/Images/contract.gif'" 
									  onMouseOut="document.img56.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;border-radius:5px" alt="" width="25" height="25" border="0" align="absmiddle" 
									  onClick="selectaccountgl('#URL.mission#','','','#url.journal#','applycontra');">
								  
								  </td>
								  
								  </tr>
								  
							  </table>		
							  
							  </td>	
							  
						 <cfelseif url.GLaccount neq "">	<!--- distribution --->
						 
						    <cfquery name="Distribution"
							  datasource="AppsLedger" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							    SELECT   *
								FROM     Ref_Account R 
								WHERE    GLAccount = '#url.GLaccount#' 									
							</cfquery>
							
							<TD class="labelmedium2"><cf_tl id="Contra-Account">:</TD>	
					   														       	   
		    			    <td colspan="4">	
							
										   
						        <table style="border:1px solid silver;;background-color:f1f1f1">
								    <tr>
																	   
									  <td class="labelmedium2" style="min-width:250px;color:green;font-size:15px;height:27px;padding-left:4px;padding-right:9px">#glaccdes#
							          	 <input type="hidden" name="glaccount"       id="glaccount"     value="#Distribution.GLAccount#"    size="12" style="text-align: center;" readonly class="disabled">
						         		 <input type="hidden" name="gldescription"   id="gldescription" value="#Distribution.Description#"  size="40" style="text-align: center;" readonly class="disabled">
										 <input type="hidden" name="debitcredit"     id="debitcredit"   value="#url.AccountType#"           size="8" style="text-align: center;" readonly class="disabled">
									  </td>		
									  
									   <td class="labelmedium2" style="border:0px solid silver;padding-right:4px">#Distribution.GLAccount#</td>								 		 
									  					 
									  <td align="center" class="labelmedium2" style="background-color:f1f1f1;border:0px solid silver;padding-left:6px;padding-right:4px">#url.AccountType#</td> 
									  
								    </tr>
								</table>	
							
							</td>	    
							  
								
					   <cfelseif ContraAccount.recordcount eq "1" and HeaderSelect.ContraGLAccount neq "">		
					   		
							<TD class="labelmedium2"><cf_tl id="Contra-Account">:</TD>													       	   
		    			    <td colspan="4">	 		   		
										   
						        <table border="0" style="border:1px solid silver;background-color:f1f1f1">
								    <tr>
																	   
									  <td class="labelmedium2" style="min-width:250px;height:27px;padding-left:4px;color:6688aa;font-size:15px;padding-right:9px">#glaccdes#
							          	 <input type="hidden" name="glaccount"       id="glaccount"     value="#HeaderSelect.ContraGLAccount#" size="12" style="text-align: center;" readonly class="disabled">
						         		 <input type="hidden" name="gldescription"   id="gldescription" value="#glaccdes#" size="40" style="text-align: center;" readonly class="disabled">
										 <input type="hidden" name="debitcredit"     id="debitcredit"   value="#HeaderSelect.ContraGLAccountType#" size="8" style="text-align: center;" readonly class="disabled">
									  </td>		
									  
									  <td class="labelmedium2" align="center" style="padding-left:8px;border-left:1px solid silver;font-size:15px;padding-right:8px">#HeaderSelect.ContraGLAccount#</td>									 										  					 
									  <td class="labelmedium2" align="center" style="border-left:1px solid silver;font-size:15px;padding-left:8px;padding-right:8px">#HeaderSelect.ContraGLAccountType#</td> 
									  
								    </tr>
								</table>	
							
							  </td>
							
					   <cfelseif ContraAccount.recordcount gt "1">		
					      						   
					        <TD class="labelmedium2"><cf_tl id="Contra-Account">:</TD>			   
		    			    <td colspan="4">	 
			   	    	  	
						    <table border="0" style="border:1px solid silver">
							    <tr>
								
								  <td align="center" class="labelmedium2" style="min-width:250px;height:27px;padding-left:4px; padding-right:4px">
								  
								  <select name="glaccount" style="border:0px" class="regularxxl" id="glaccount" onchange="javascript:setline()">
									  <cfloop query="ContraAccount" >
									  <option value="#glaccount#" <cfif HeaderSelect.ContraGLAccount eq glaccount>selected</cfif>>#glaccount# #description#</option>
									  </cfloop>
								  </select>
								  
								  <input type="hidden" name="debitcredit"     id="debitcredit"   value="#HeaderSelect.ContraGLAccountType#" size="8" style="text-align: center;" readonly class="disabled">
								
								  </td>						  	 
								  					 
								  <td align="center" class="labelmedium2" style="background-color:f4f4f4;padding-left:8px;border-left:1px solid silver;padding-right:8px">#HeaderSelect.ContraGLAccountType#</td> 
								  
							    </tr>
							</table>	
							
							</td> 	
							  
					  <cfelse>
					  
					  	 <input type="hidden" name="glaccount"     id="glaccount"      class="regularxl" value="" size="12"  readonly style="text-align: center;">
				         		 		  		   
								
					   </cfif>	
					    
					   </cfoutput>  
				 			 				   				   		   
				   <cfif HeaderSelect.ContraGLAccount is "">			   
				   	  
					   <TD class="labelmedium2"><cf_tl id="Type">:</TD>
			           <td colspan="2">	 
					   
					     <select name="debitcredit" style="" class="regularxxl enterastab">
			               <option value="Debit" selected><cf_tl id="Debit"></option>
			               <option value="Credit"><cf_tl id="Credit"></option>
			             </select>
						 <input type="hidden" name="transactiondocumentdate" id="transactiondocumentdate" value="">	
					   </td>	 
				  
				   <cfelse>
				  
				  	 <TD colspan="2"></TD>
				   
				   </cfif>	   
				   		  	   
		        </TR>
								
				<cfquery name="Param"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
						FROM   Ref_ParameterMission
						WHERE  Mission = '#jrn.Mission#' 
				  </cfquery>
				  			  
				  <cfif Param.AdministrationLevel eq "Parent">
				  
				     <!--- ---------------------------------------------------------------------------------------------------- --->
				  	 <!--- show only the last parent org structure, technically we can adjust this based on the period selected --->
					 <!--- ---------------------------------------------------------------------------------------------------- --->
					  
					 <cfquery name="Last" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT   *
					      FROM     Ref_Mandate
						  WHERE    Mission = '#jrn.Mission#'
						  ORDER BY DateExpiration DESC					 
					 </cfquery>
				  
				    <!--- show only the last parent org structure --->
					 <cfquery name="Owner" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT   DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode 
					      FROM     #Client.LanPrefix#Organization
					   	  WHERE    (ParentOrgUnit is NULL OR ParentOrgUnit = ''  OR Autonomous = 1)
						  AND      Mission     = '#Jrn.Mission#'
						  AND      MandateNo   = '#Last.MandateNo#'
						  ORDER BY TreeOrder, OrgUnitName
					 </cfquery>				 
				
					  <td class="labelmedium2"><cf_tl id="Owner">:</td>			 
					  
					  <td>
					  <select name="OrgUnitOwner" id="OrgUnitOwner" class="enterastab regularxxl">
					    <cfoutput query="Owner">
		     		     	  <option value="#OrgUnit#" <cfif url.orgunitowner eq orgunit>selected</cfif>>#OrgUnitName#</option>
		         	    </cfoutput>  
		              </select>	
					  </td>
					  
					  <cfelse>
					  
					  		  
				  <input type="hidden" name="OrgUnitOwner" id="OrgUnitOwner"  value="0">		        
					 
				</cfif>	 
				
				<TR> 
		          <TD valign="center" height="22" class="labelmedium2"><cf_tl id="Transaction No"></TD>
		          <td colspan="4">
				  
				   <cfif Jrn.JournalBatchNo eq "0" or Jrn.JournalBatchNo eq "">
				   
				      <cfoutput>
						  <input type="text" class="regularxxl enterastab" name="TransactionNo" value="#HeaderSelect.JournalTransactionNo#" size="20" maxlength="20">
					  </cfoutput>
				   
				   <cfelse>
				  
						  <table cellspacing="0" cellpadding="0">
						  <tr><td>
						  
						  <cfif Jrn.JournalBatchNo neq "0">
						  
							  <cfquery name="Batch"
								datasource="AppsLedger" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							    	SELECT *
									FROM JournalBatch
									WHERE Journal = '#URL.Journal#'
								</cfquery>
														
								<cfif HeaderSelect.JournalBatchNo eq "">
								    <cfset bt =  Jrn.JournalBatchNo>
								<cfelse>
								    <cfset bt =  HeaderSelect.JournalBatchNo>
								</cfif>		
								
								    <select name="journalbatchno" class="regularxxl enterastab">
								 
							            <cfoutput query="Batch">
							        	   <option value="#JournalBatchNo#" <cfif bt eq JournalBatchNo>selected</cfif>>
							           	   #JournalBatchNo# #Description#
										   </option>
							         	</cfoutput>
									
									</select>
							
									  
						  </cfif>		  
						  </td>
						  <td>
						  
						  <cfoutput>
						  	<input type="text" class="regularxxl enterastab" name="TransactionNo" value="#HeaderSelect.JournalTransactionNo#" size="20" maxlength="20">
						  </cfoutput>
						  
						  </td>
						  </tr>
						  
						  </table>
						  
					</cfif>	  
				 
				  </td>
				  
				  <script>
				   function apply_transactiondate(argOb) {		
				      _cf_loadingtexthtml='';			   
				      ptoken.navigate('TransactionDetailLines.cfm?accountperiod='+document.getElementById('accountperiod').value+'&pap='+argOb.dd+'/'+argOb.mm+'/'+argOb.yyyy,'lines')				    
				   }
				  </script>
				  
				  <TD valign="center" class="labelmedium2"><cf_tl id="Posting Date">:</TD>
		          <td align="left" colspan="1">				  
				      
				   <cf_intelliCalendarDate9
				      FieldName="transactiondate" 			 
					  class="regularxxl enterastab"			  
				      Default="#Dateformat(HeaderSelect.TransactionDate, CLIENT.DateFormatShow)#"
					  scriptdate="apply_transactiondate">
			
				  </td>
				  
			    </tr>				
				
				<tr>
												 
				
				  <!-------
				  <cfif tracat is "Payables" 
				        or tracat is "DirectPayment" 
						or tracat is "banking" 
						or tracat is "payment" 
						or tracat is "advances" 
						or tracat is "memorial" 
						or tracat is "Receivables" 
						or tracat is "Receipt">
						to support any other user-defined 
						------>
				  <cfif tracat eq "Inventory" or tracat eq "payroll">
				  
				  <cfelse>
				  
				  <TD class="labelmedium2" style="padding-right:6px">				  		   
				  				  				  
				      <cfswitch expression="#institutiontree#">
					  
						  <cfcase value="">
						  
						    <select name="Party" id="party" class="regularxxl" 
						        style="border:0px solid silver;background-color:f4f4f4;padding-left:0px;width:99%" 
								onchange="togglebox(this.value)">
							  	<option value="ven" <cfif HeaderSelect.ReferencePersonNo eq "">selected</cfif>><cf_tl id="Organization"></option>
							  	<option value="emp" <cfif HeaderSelect.ReferencePersonNo neq "">selected</cfif>><cf_tl id="Staff"></option>
								<option value="cus" <cfif HeaderSelect.ReferenceId neq "">selected</cfif>><cf_tl id="Customer"></option>
						    </select>
						  
						  </cfcase>
						  
						  <cfcase value="staff">
						  
							  <cf_tl id="Staff">:
							  <input type="hidden" name="Party" id="party" value="emp">
						  
						  </cfcase>
						  
						  <cfcase value="customer">
						  
						  	 <cf_tl id="Customer">:
							  <input type="hidden" name="Party" id="party" value="cus">
						  
						  </cfcase>
						  
						  <cfdefaultcase>
						  
						  	 <cf_tl id="Organization">:
							 <input type="hidden" name="Party" id="party" value="ven">						  
						  
						  </cfdefaultcase>
					 						  
					  </cfswitch>	
										  
				  </TD>
				  
		          <td colspan="4" height="22">
				   
				   <cfoutput> 
				   				   
				   <table cellspacing="0" cellpadding="0"><tr>
				   
				   	   <cfswitch expression="#institutiontree#">
					  
						  <cfcase value="">
				   
							   <cfif HeaderSelect.ReferenceId neq "">
							   
								   <cfif HeaderSelect.ReferencePersonNo eq "">
							   			
										<cfset ven = "hide">
							   			<cfset emp = "hide">
										<cfset per = "hide">
							   			<cfset cus = "show">	
																	
									<cfelse>
									
										<cfquery name="Person" 
										datasource="AppsSelection" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											  SELECT *
											  FROM   Applicant
											  WHERE  PersonNo = '#HeaderSelect.ReferencePersonNo#'	
										</cfquery>
									
									   <cfset ven = "hide">
									   <cfif Person.recordcount eq "0">
										   <cfset emp = "regular">							   
										   <cfset per = "hide">
									   <cfelse>
										   <cfset emp = "regular">							   
										   <cfset per = "hide">
									   </cfif>
									   <cfset cus = "hide">							   
								    </cfif>		
														
		  			   		   <cfelseif HeaderSelect.ReferencePersonNo eq "">
							   
									   <cfset ven = "regular">
									   <cfset emp = "hide">
									   <cfset per = "hide">
									   <cfset cus = "hide">		
									   					   
							   <cfelse>
							   
								       <cfset emp = "regular">
									   <cfset ven = "hide">
									   <cfset per = "hide">
									   <cfset cus = "hide">						 
									   
							   </cfif>
							   
						  </cfcase>
						  
						  <cfcase value="staff">
						  
							  <cfset emp = "regular">
							   <cfset ven = "hide">
							   <cfset per = "hide">
							   <cfset cus = "hide">		
						  
						  </cfcase>
						  
						  <cfcase value="customer">
						  
						  	   <cfset emp = "hide">
							   <cfset ven = "hide">
							   <cfset per = "hide">
							   <cfset cus = "regular">								  
						  	
						  </cfcase>
						  
						  <cfdefaultcase>
						  
						  	   <cfset emp = "hide">
							   <cfset ven = "regular">
							   <cfset per = "hide">
							   <cfset cus = "hide">		
						  	  						  
						  </cfdefaultcase>
						  
						</cfswitch>  
						  	   

					   	<td class="#ven#" id="venbox">
												
							 <table><tr>
								
								<td >   													  
							 	  <input type="text" name="referenceorgunitname1" id="referenceorgunitname1" value="#HeaderSelect.ReferenceName#" class="regularxxl enterastab" size="45" maxlength="60" readonly>					   
							   </td>
							   
							   <td style="padding-left:3px">
						
						       <img src="#SESSION.root#/Images/search.png" alt="Select" name="img1" 
								  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
								  style="cursor: pointer;" alt="" width="23" height="25" border="0" align="absmiddle" 
								  onClick="selectorgN('#institutiontree#','Administrative','referenceorgunit','applyorgunit','1')">
								    
								</td>
							   </tr>
							   
							  </table>
							   
							  <input type="hidden" name="mission1" id="mission1">
							  <input type="hidden" name="referenceorgunit1" id="referenceorgunit1" value="#HeaderSelect.ReferenceOrgUnit#">
							 
							   
						 </td> 								 
						 							
							<cfquery name="Person" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								  SELECT *
								  FROM   Applicant
								  WHERE  PersonNo = '#HeaderSelect.ReferencePersonNo#'	
							</cfquery>
													   	
					   		<td class="#per#" id="perbox">												
							
							   <table cellspacing="0" cellpadding="0"><tr>
								  
								  <td>
							
									<input type="text"    name="referencename3" id="referencename3" class="regularxxl enterastab" value="#Person.FirstName# #Person.LastName#" size="40" maxlength="60" readonly style="text-align: left;">
									<input type="hidden"  name="indexno3"   id="indexno3"    value="" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
									<input type="hidden"  name="personno3"  id="personno3"   value="#Person.PersonNo#">
								    <input type="hidden"  name="lastname3"  id="lastname3"   value="#Person.LastName#">
								    <input type="hidden"  name="firstname3" id="firstname3"  value="#Person.FirstName#">
									
								  </td>
								  
								  <td style="padding-left:3px">
											
							  		<img  src="#SESSION.root#/Images/search.png" 
									      alt="Select Customer" 
										  name="img9" 
									  	  onMouseOver="document.img9.src='#SESSION.root#/Images/button.jpg'" 
										  onMouseOut="document.img9.src='#SESSION.root#/Images/search.png'"
										  style="cursor: pointer;" 									  
										  width="23" 
										  height="25" 									   
										  align="absmiddle" 
										  onClick="selectapplicant('webdialog','personno3','indexno3','lastname3','firstname3','referencename3','','')">			
								  
								  </td>
								  
								  </tr>
								  </table>								 
								   
							</td>
							   
						   <cfif person.recordcount gte "1">	   
						   
						        <cfset emp = "hide">
						   
						   </cfif>
																   		   
						   <cfquery name="Person" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								  SELECT *
								  FROM   Person
								  WHERE  PersonNo = '#HeaderSelect.ReferencePersonNo#'	
							</cfquery>
							
						  <td class="#emp#" id="empbox">
						
						   <table><tr>
							  
							  <td>
						
								<input type="text"    name="referencename2" id="referencename2" class="regularxxl enterastab" value="#Person.FirstName# #Person.LastName#" size="40" maxlength="60" readonly style="text-align: left;">
								<input type="hidden"  name="indexno"   id="indexno"    value="" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
								<input type="hidden"  name="personno"  id="personno"   value="#Person.PersonNo#">
							    <input type="hidden"  name="lastname"  id="lastname"   value="#Person.LastName#">
							    <input type="hidden"  name="firstname" id="firstname"  value="#Person.FirstName#">
								
							  </td>
							  
							  <td style="padding-left:3px">
										
						  		<img src="#SESSION.root#/Images/search.png" alt="Select Employee" name="img9" 
								  onMouseOver="document.img9.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img9.src='#SESSION.root#/Images/search.png'"
								  style="cursor: pointer;" alt="" width="23" height="25" border="0" align="absmiddle" 
								  onClick="selectperson('webdialog','personno','indexno','lastname','firstname','referencename2','','')">			
							  
							  </td>
							  
							  </tr>
							  </table>	
							
						  </td>
							 

						   <td class="#cus#" id="cusbox">

						   <cfquery name="qCustomer"
								   datasource="AppsMaterials"
								   username="#SESSION.login#"
								   password="#SESSION.dbpw#">
								   SELECT *
								   FROM   Customer
								   WHERE
								   <cfif HeaderSelect.ReferenceId neq "">
									   CustomerId = '#HeaderSelect.ReferenceId#'
								   <cfelse>
										1 = 0
								   </cfif>
						   </cfquery>

						   <table cellspacing="0" cellpadding="0"><tr>

						   <td>

						   <input type="text"    name="customername" id="customername" class="regularxxl enterastab" value="#qCustomer.CustomerName#" size="40" maxlength="60" readonly style="text-align: left;">
						   <input type="hidden"  name="customerid"  id="customerid"   value="#qCustomer.CustomerId#">


					   </td>

					   <td style="padding-left:3px">

							   <img src="#SESSION.root#/Images/search.png" alt="Select Employee" name="img9"
							   onMouseOver="document.img9.src='#SESSION.root#/Images/button.jpg'"
							   onMouseOut="document.img9.src='#SESSION.root#/Images/search.png'"
							   style="cursor: pointer;" alt="" width="23" height="25" border="0" align="absmiddle"
							   onClick="selectcustomer('webdialog','customerid','customername','#HeaderSelect.ReferenceId#')">

					   </td>

					   </tr>
					   </table>

					   </td>

				   </tr>
				   </table>
				   		   
				   </cfoutput>		   
						   	
				  </td>
				  
				  <cfif tracat is "Payables" or Tracat is "DirectPayment" or Tracat is "Receivables">				  
				       <TD class="labelmedium2"><cf_tl id="Invoice No">:</TD>				   
				  <cfelse>				   
				       <TD class="labelmedium2"><cf_tl id="Reference No">:</TD>				   
				  </cfif>
		          
				  <td colspan="3">	
					   <cfinput type="Text"
					      class="regularxl" name="referenceno" 
						  value="#HeaderSelect.ReferenceNo#" 
						  message="Please enter a reference no" 
						  style="width:118PX" 
						  required="No" 
						  size="10" 
						  maxlength="30"> 
				   </td>
				   
				   <!---
						
		 		  <cfelse>
				  	   		  
				  <TD class="labelmedium2"><cf_tl id="Customer">/<cf_tl id="Agency">:</TD>
		          <td colspan="4" height="22">
				  
					  <cfoutput> 
					   
					  <table cellspacing="0" cellpadding="0">
						<tr>
						   <td>
						   <input type="text"   id="orgunitname1" name="referenceorgunitname1" class="regularxxl enterastab" value="#HeaderSelect.ReferenceName#" size="40" maxlength="60" readonly>
						   <input type="hidden" id="mission1"     name="mission1"              class="disabled" size="20" maxlength="20" readonly>
					   	   <input type="hidden" id="orgunit1"     name="referenceorgunit1" value="#HeaderSelect.ReferenceOrgUnit#">					  
						   </td>
						   
						   <td style="padding-left:2px">
					  
					       <img src="#SESSION.root#/Images/search.png" alt="Select" name="img1" 
							  onMouseOver="document.img1.src='#SESSION.root#/Images/contract.gif'" 
							  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
							  style="cursor: pointer;border-radius:5px" width="26" height="25" border="0" align="absmiddle" 
							  onClick="selectorgN('#institutiontree#','Administrative','orgunit','applyorgunit','1')">
					
							</td>
							
						</tr>
					   </table>
					   
					   </cfoutput>		  
				  		   	
				  </td>
				  
				 
				  
				   <TD class="labelmedium2"><cf_tl id="Voucher No">:</TD>
		           <td colspan="3">	
				   <cfinput type="Text" class="regularxxl enterastab" name="referenceno" value="#HeaderSelect.ReferenceNo#" message="Please enter an invoice no" required="No" size="10" maxlength="30"> 
				   </td>
				   
				    --->
				 
				  </cfif>	
				  
				</tr>		
				
				
				
				<tr>  
				
				  <cfoutput>
				  
		          <TD class="labelmedium2"><cf_tl id="Description">:</TD>
		          <td colspan="4" height="22">
				    <input type="text" name="Description" class="regularxxl enterastab" value="#HeaderSelect.Description#" style="width:90%" maxlength="200">
		   		  </td>
				  </cfoutput>
				  
				  <cfif tracat is "Payables" or Tracat is "DirectPayment" or Tracat is "Receivables">
					
					  <cfif tracat neq "Receivables">
					   <cfset text = "Invoice Date">
					  <cfelse>  
					   <cfset text = "Document Date">
					  </cfif>
					 
				       <TD height="22" class="labelmedium2"><cf_tl id="#text#">:</TD>
		               <td colspan="1">	 
					   					   
					    <cf_space spaces="40">			  
		     	   	 
						   <cf_intelliCalendarDate9
			    		      FieldName="documentdate" 				 
							  class="regularxxl enterastab"
			    		      Default="#Dateformat(HeaderSelect.DocumentDate, CLIENT.DateFormatShow)#">		
						  
		  		       </td>	
					   </tr>
			         
				 </cfif>  
		
				 <cfif (tracat is "Payment" or Tracat is "DirectPayment" or Tracat is "Receivables") and bank.recordcount gte "1">
				 
					  <cfif tracat neq "Receivables">
					    <cfset text = "Pay through">
					  <cfelse>  
					    <cfset text = "Receive through">
					  </cfif>
					 				 
					  <tr>
					  				 
				          <td class="labelmedium2"><cfoutput><cf_tl id="#Text#">:</cfoutput></TD>
					      <td>
					 	
				    	  <select name="ActionBankId" class="regularxxl enterastab">
						  
						   <cfif Jrn.BankId eq "">
							   <option value=""><cf_tl id="Undefined"></option>  
						   </cfif>
						  
					       <cfoutput query="bank">
						     <option value="#BankId#" <cfif HeaderSelect.actionBankId is BankId>selected</cfif>>#BankName# [#AccountNo#]</option>
						   </cfoutput>
					   	  </select>
						  
						  </td>
						  <td></td>
						  <td></td>
						  <td></td>					 				  		 
						  <td class="labelmedium2"><cf_tl id="Process date">:</td>		  
						  <td style="width:200px">
							  
							    <cf_intelliCalendarDate9
							      FieldName="journalbatchdate" 			 
								  class="regularxxl enterastab"			  
							      Default="#Dateformat(HeaderSelect.JournalBatchDate, CLIENT.DateFormatShow)#">
							  
						  </td>		 	  			  
				       			  
					  </tr>
				  
				 <cfelseif tracat is "Payables">
				 
				 <tr>
				 		<td class="labelmedium2"><cf_tl id="Source">:</TD>
						<td>
						    <cfoutput>
						    <input type="text" name="TransactionSourceNo" class="regularxxl enterastab" value="#HeaderSelect.TransactionSourceno#" style="width:120px" maxlength="20">		  
							</cfoutput>
						</td>
						<td></td>
						<td></td>
						<td></td>		
						
						<td class="labelmedium2"><cf_tl id="Process date">:</td>		  
						<td style="wodth:200">
							  
							    <cf_intelliCalendarDate9
							      FieldName="journalbatchdate" 			 
								  class="regularxxl enterastab"			  
							      Default="#Dateformat(HeaderSelect.JournalBatchDate, CLIENT.DateFormatShow)#">
							  
						</td>	
						
						 <input type="hidden" name="ActionBankId">	 	  		
				 
				 <cfelse>
				 
				   <cfoutput>
				 				   				 
				 	<tr>
															
						<td colspan="5"></td>													
					    <td class="labelmedium2"><cf_tl id="Batch date">:</td>		  
					    <td style="width:200">
																	  
					    <cf_intelliCalendarDate9
					      FieldName="journalbatchdate" 			 
						  class="regularxxl enterastab"			  
					      Default="#Dateformat(HeaderSelect.JournalBatchDate, CLIENT.DateFormatShow)#">
					  
					    </td>		 	  			  
				  
		            </tr>					
										
					<!---					
						<input type="hidden" name="journalbatchdate" value="#Dateformat(HeaderSelect.JournalBatchDate, CLIENT.DateFormatShow)#">					
					--->
					
					</cfoutput>
				 
					 <input type="hidden" name="ActionBankId">
				  
				 </cfif> 
				 						
				
				<cfif tracat is "Payables" or tracat is "receivables">
				
				<tr>
								   
				   <TD class="labelmedium2"><cf_tl id="Payment Due">:</TD>
		           <td colspan="4">	 
				   		     	  
					   <cf_intelliCalendarDate9
					   	  FieldName="actionbefore" 		
						  class="regularxxl enterastab"	 
					      Default="#Dateformat(HeaderSelect.ActionBefore, CLIENT.DateFormatShow)#">		
			 		   		   
				   </td>	
				  		   
				    <td class="labelmedium2"><cf_tl id="Terms">:</td>
		            <td colspan="3" height="22">	 
		     	   
				    <select name="actionterms" onChange="javascript:terms(this.value)" class="regularxxl enterastab" style="width:118">
					  <option value=""></option>  			
					  <cfoutput query="Terms">
		        	   <option value="#Code#" <cfif HeaderSelect.actionterms is Code>selected</cfif>>
						   #Description#
						  </option>
		         	  </cfoutput>  
		            
			        </select>	
					
					<cfoutput>
						<input type="hidden"   name="actiondays">	
						<input type="hidden"   name="actiondiscount"     value="#HeaderSelect.actiondiscount#">	
						<input type="hidden"   name="actiondiscountdays" value="#HeaderSelect.actiondiscountdays#">	
					</cfoutput>
				     		   
				    </td>					   						
					</TR>
						
				</tr>
								
				<cfelse>
				
					<input type="hidden" name="actionterms" value="">
					<input type="hidden" name="actiondays" value"">	
					<input type="hidden" name="actiondiscount" value="">	
		            <input type="hidden" name="actiondiscountdays" value="">				
					
				</cfif>		
				
				<!--- ------------- --->
				<!--- custom fields --->
				<!--- ------------- --->
						
				<cf_customField 
				     mode="edit" 
					 colspan="6"
					 stylelabel=""
					 stylefield=""
				     TopicClass="header"
				     journal="#HeaderSelect.Journal#" 
					 journalserialno="#HeaderSelect.JournalSerialNo#">		
					 
				<!--- ----------------------------------------------------------------- --->
				<!--- action fields : if fields are populated then we show them as edit --->
				<!--- ----------------------------------------------------------------- --->
				
				<!---		
				<cf_actionField 
				     mode="edit" 
					 stylelabel=""
					 stylefield=""
				     TopicClass="header"
				     journal="#HeaderSelect.Journal#" 
					 journalserialno="#HeaderSelect.JournalSerialNo#">						 			 		
					 
					 --->
				
				
			<!--- ---------------------------------- --->
			<!--- -------- add and edit mode-------- --->
			<!--- ---------------------------------- --->
			
			<tr><td style="height:5px"></td></tr>
			
			<tr><td colspan="9" align="center" valign="top" style="border-top:1px solid silver;max-height:200px">
				  				   
				   <!--- ------------------------------------------ --->
				   <!--- show the prepared transactions for posting --->
				   <!--- ------------------------------------------ --->						   					   	  
				   <cf_securediv bind="url:TransactionDetailLines.cfm?editmode=#editmode#" id="lines" style="height:100%">				  			   					  
				   
				</td>
			</tr>			
										
			</table>
							
			</td></tr>	
				
		</table>
				
		</td>
		</tr>	
			
			<cfif editmode eq "full">
			
			<tr>
			
					<td style="padding-left:35px;padding-right:15px;min-width:140px" valign="top">
					   
						<table align="center" height="100%" style="background-color:fafafa">	
						   <tr class="fixrow">
							   <td style="padding:4px" valign="top">
							       
								   <table>			
								   <cfinclude template="TransactionDetailMenu.cfm">
								   </table>								   
							   </td>
						   </tr>	 					
						</table>
						
					</td>
				
				    <td valign="top" style="width:100%;border:0px solid silver;height:100%;padding-left:4px;padding-right:4px">		
					    
						<table style="height:100%;width:100%;" border="0" align="center">						
							<cf_menucontainer item="1" class="regular">																							
									<cfinclude template="TransactionDetailEntry.cfm">																	
							</cf_menucontainer>												
							<cf_menucontainer item="2" class="hide" container="div">						
						</table>
														
					</td>
				
				</tr>
				
			</cfif>	
										
		 </table>
		 
		 </cfform>	
		
	</td></tr>
 
</table>

<script>
	<cfif tracat is "Payment" or  tracat is "DirectPayment">
		try {document.getElementById('menu2').click();} catch(e) {}
	</cfif>
</script>


