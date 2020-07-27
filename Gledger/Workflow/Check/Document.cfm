<!--- 
1. database populate heck table from the transactionlines, group by Vendor/Personor otherwise lines 
2. Show checks in a visual format which includes the signature
--->

<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionHeader
	WHERE   TransactionId = '#Object.objectKeyValue4#'
</cfquery>

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionIssuedCheck
	WHERE   TransactionCheckId = '#url.id#'
</cfquery>

<cfif check.recordcount eq "0">
	
	<cfset dte = now()>
	<cfset pay = get.ReferenceName>
	<cfset amt = get.AmountOutstanding>
	<cfset cur = get.Currency>
	<cfset cno = "">
	<cfset mem = "">

	<cfif amt eq "">
		<cfset amt = get.Amount>
		<cfif amt eq "">
			<cfset amt = 0>
		</cfif>
	</cfif>
	
<cfelse>

	<cfset dte = "#check.CheckDate#">
	<cfset pay = "#check.CheckPayee#">
	<cfset amt = "#check.CheckAmount#">
	<cfset cur = "#get.Currency#">
	<cfset cno = "#check.checkNo#">
	<cfset mem = "#check.checkMemo#">

</cfif>

<cfquery name="Curr" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM   Currency
	WHERE  Currency = '#cur#'
</cfquery>

<cfquery name="Jrn" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM  Journal 
	WHERE Journal = '#get.journal#' 
</cfquery>

<cfquery name="Bank" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_BankAccount 
	WHERE  Currency = '#get.Currency#'
	<cfif Jrn.BankId neq "">
	AND   BankId = '#jrn.BankId#' 
	</cfif>
	AND  BankId IN
            (SELECT     BankId
             FROM       Ref_Account
             WHERE      GLAccount IN (SELECT GLAccount FROM Ref_AccountMission WHERE Mission = '#jrn.mission#'))
</cfquery>

<cf_NumberToText lang="ESP" amount="#amt#" showcurrency="0">
<cfset doPrintScript = "">
<cfset vShowPrint = false>

<cfif FileExists("#session.rootpath#\Custom\#Jrn.Mission#\QZ\Checks\PrintCheckScript.cfm") eq "YES">
	<cfinclude template="../../../Custom/#Jrn.Mission#/QZ/Checks/PrintCheckScript.cfm">
	<cfset vShowPrint = true>
</cfif>

<cfoutput>
	<script>
		function saveCheck() {
			ptoken.navigate('#session.root#/gledger/workflow/check/documentSubmit.cfm?id=#url.id#&transactionid=#get.TransactionId#','checksave','','','POST','checkform');
		}
	</script>
</cfoutput>

<cfoutput>

<cfform method="POST" id="checkform">

<table cellspacing="6" cellpadding="6" align="center" class="formpadding">

	   <tr><td height="10"></td></tr>
	   	   
	   <tr><td width="650" bgcolor="FFFFCF" style="border: 4px double gray;">
	  
	   <table width="97%" align="center" cellpadding="0" class="formpadding">
	   
	    <tr><td style="height:15px"></td></tr>
	   
		<tr><td>
			<table width="100%">
			   
			   <tr class="labelmedium">
			      <td width="70%">
				  
				    <select name="ActionBankId" class="regularxl enterastab">
						  
						   <cfif Jrn.BankId eq "">
							   <option value=""><cf_tl id="Undefined"></option>  
						   </cfif>
						  
					       <cfloop query="bank">
						     <option value="#BankId#" <cfif get.actionBankId is BankId>selected</cfif>>#BankName# [#AccountNo#]</option>
						   </cfloop>
						   
					   	  </select>
				  
				  </td>
				  <td width="30%">
				  <table width="100%">
				  <tr class="labelmedium">
				    <td style="min-width:80px"><cf_tl id="Date">:</td>
					<td style="min-width:150px">
					
					<cf_intelliCalendarDate9
						FieldName="CheckDate" 
						Default="#dateformat(dte,client.dateformatshow)#"
						class="regularxl"
						AllowBlank="False">	
					
					</td>
					
					<td style="min-width:30px"><cf_tl id="No">:</td>
					<td>
					
					<input type="text" class="regularxl" name="CheckNo" value="#cNo#" style="text-align:center;width:70" maxlength="8">
					
					</td>					
				  </tr>
				  </table>
				  </td>
			   </tr>
			      
			</table>
		</td></tr>
		
		<tr><td height="10"></td></tr>
		
		<tr><td>
			<table width="100%">
			   
			   <tr class="labelmedium">
			      <td width="80%">
				  <table width="100%">
				     <tr class="labelmedium">
					  <td width="70"><cf_tl id="Payee"></td>
					  <td style="padding-left:6px"><input type="text" value="#pay#" class="regularxl" name="CheckPayee" style="width:95%" maxlength="80"></td>
			         </tr>
				  </table>
				  </td>
				  <td width="30%">
				   <table width="100%">
				     <tr class="labelmedium">
					  <td width="45"><cf_tl id="Amount"></td>
					  <td style="padding-left:6px"><input type="text" value="#numberformat(amt,',.__')#" style="text-align:right" class="regularxl" name="CheckAmount" style="width:95%" maxlength="80"></td>
			         </tr>
				  </table>
				  </td>
			   </tr>
			      
			</table>
		</td></tr>
		
		<tr><td>
			<table width="100%">
			   
			   <tr  class="labelmedium">
			      <td width="90%" >
				  <input type="text" value="#textamount#" class="regularxl" name="CheckAmountText" style="width:99%" maxlength="80">				  
				  </td>
				  <td width="10%">#curr.description#</td>
			   </tr>
			      
			</table>
		</td></tr>
		
		<tr><td height="20"></td></tr>
		
		<tr><td>
			<table width="100%">
			   
			   <tr>
			      <td width="50%">
				  <table width="100%">
				     <tr class="labelmedium">
					  <td width="90"><cf_tl id="Memo"></td>
					  <td><input type="text" value="#mem#" class="regularxl" name="CheckMemo" style="width:99%" maxlength="50"></td>
			         </tr>
					 <tr colspan="2">
						<td>
							<table>
								<tr class="labelmedium">
									<td><input type="checkbox" class="regularxl" name="CheckNoNegotiable" id="CheckNoNegotiable"></td>
									<td style="padding-left:10px;"><label for="CheckNoNegotiable"><cf_tl id="No negotiable"></label></td>
								</tr>
							</table>
						</td>
			   		 </tr>
				  </table>
				 
				  </td>
				  <td width="50%" align="center">[<cf_tl id="Signature Image">]:</td>
			   </tr>
			      
			</table>
		</td></tr>
		
		<tr><td height="20"></td></tr>
		
	</table>
   </td></tr>
   
   <tr><td align="right">
   
   <table>
   <tr class="labelmedium">
		<cfif vShowPrint>
	   		<td><a href="javascript:saveCheck(); #doPrintScript#"><cf_tl id="Print check"></a></td>
	   		<td style="padding-left:4px;padding-right:4px">|</td>
		</cfif>
	   	<td><a href="javascript:saveCheck();"><cf_tl id="Save check"></a></td>
	   	<td id="checksave"></td>
   </tr>
   </table>	
   </td></tr>

</table>

</cfform>

</cfoutput>

