
 <cfparam name="URL.glaccount"     default="">
 <cfparam name="URL.date"          default="#dateformat(now(),client.dateformatshow)#">
 <cfparam name="URL.mode"          default="0">
 <cfparam name="URL.entryAmount"   default="0">
 <cfparam name="URL.entryCurrency" default="USD">
 <cfparam name="URL.entryexcjrn"   default="">
 <cfparam name="URL.entryexcbase"  default="">
 
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>
 	
 <cfquery name="ExcDoc"
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT   TOP 1 * 
	FROM     CurrencyExchange
	WHERE    Currency = '#URL.entryCurrency#'
	AND      EffectiveDate <= #dte#
	ORDER BY EffectiveDate DESC
 </cfquery>		
    
 <cfquery name="Acc"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_Account
	WHERE    GLAccount = '#URL.glaccount#' 
 </cfquery>	
 
 <cfquery name="Journ"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   Currency
	FROM     Journal
	WHERE    Journal = '#URL.Journal#' 
 </cfquery>	
  
 <cfquery name="ExcJrn"
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT   TOP 1 * 
	FROM     CurrencyExchange
    WHERE    Currency = '#Journ.Currency#'
	AND      EffectiveDate <= #dte#
	ORDER BY EffectiveDate DESC
 </cfquery>	  
     		
 <table width="270" class="formpadding">
  
 <cfset show = "regular">
	
 <cfif not LSIsNumeric(URL.entryamount) and url.entryamount neq "">
  <tr><td colspan="4"  class="labelmedium2"><font color="FF0000"><cf_tl id="Incorrect Amount Entered"> : <cfoutput>#URL.entryamount#</cfoutput></td></tr>
  <input type="hidden" name="status" value="0">
  <cfset show = "hide">  
 <cfelse>
  <input type="hidden" name="status" value="1"> 
 </cfif>
	
 <cfif ExcDoc.recordcount eq "0" or ExcJrn.recordcount eq "0">
  
    <cfoutput>
	<!---  <tr class="labelmedium"><td colspan="4"><font color="FF0000"><cf_tl id="Problem">, <cf_tl id="amounts can not be calculated"></font></td></tr> --->
	 <cfset show = "hide">
	</cfoutput>  
	
 </cfif>
 
 <cfset traamt = replace(url.entryamount,',','',"ALL")>
 
 <cfif traamt eq "">
   <cfset traamt = 0>
 </cfif>
  
 <cfif show eq "regular" and url.entryexcjrn neq "0">
 			 
	 <cfif url.mode eq "0">
	 	 
		 <cfset jrnexc = ExcDoc.ExchangeRate/ExcJrn.ExchangeRate>
	     <cfset jrnamt = traamt/jrnexc>
	     <cfset bseexc = ExcDoc.ExchangeRate>
	     <cfset bseamt = traamt/bseexc>
		 
	 <cfelse>
	 	 
	 	<cfif URL.entryexcjrn eq "">
			<cfset URL.entryexcjrn = 1>
		</cfif>
		
	    <cfset jrnexc = URL.entryexcjrn>
	    <cfset jrnamt = traamt/jrnexc>
	    <cfset bseexc = URL.entryexcbase>
	    <cfset bseamt = traamt/bseexc>
		 
	 </cfif>	 
	 
<cfelse>
    
	<tr class="labelmedium2"><td colspan="4" style="padding-left:4px"><font size="1" color="FF0000"><cf_tl id="Problem">, <cf_tl id="amounts can not be calculated"></font></td></tr>
		<cfset jrnexc = 1>
	    <cfset jrnamt = 0>
	    <cfset bseexc = 1>
	    <cfset bseamt = 0>
		
</cfif>
	 				 
 <cfoutput>
 
 <cfif (Journ.Currency eq URL.entryCurrency and APPLICATION.BaseCurrency eq Journ.Currency) or acc.MonetaryAccount eq "1" or acc.MonetaryAccount eq "">
 cccccccc
     <cfset show = "disabled">
 </cfif> 
	  
 <tr class="labelmedium2">
 <td>&nbsp;</td>
 <TD style="padding-left:5px;padding-right:5px"><cf_tl id="Exchange"> #Journ.Currency#:</TD>  
 <td align="right">		  
      <input type="text"
      name="entryexcjrn"
	  id="entryexcjrn"	  
      value="#NumberFormat(jrnexc,'._____')#"
      size="12"
	  #show#
      class="regularxxl"
      style="text-align: right;background-color:ffffcf"
      onChange="javascript:amountcalc('1')">
 </td>
 </tr>
 
 <tr class="labelmedium2">
 <td></td> 
 <td style="padding-left:5px;padding-right:5px"><cf_tl id="Total"> #Journ.Currency#:</td>
 <td align="right">
 
 	<input type="text"
	   name="entryamtjrn"
	   id="entryamtjrn"
	   value="#NumberFormat(jrnamt,',.__')#"
	   size="12"			  
	   readonly    
	   class="regularxxl" 
	   style="text-align: right;background-color:E6E6E6"
	   notab="">
	   
 </td> 
 
 </tr>
 
<cfif APPLICATION.BaseCurrency eq Journ.Currency>
   <cfset cl = "hide">
<cfelse>
   <cfset cl = "regular">  
</cfif>   

<cfif acc.MonetaryAccount eq "1" or acc.MonetaryAccount eq "">
    <cfset ena =  "disabled">
<cfelse>	
    <cfset ena = "">	
 </cfif>

<tr class="#cl#">
	 <td>&nbsp;</td>	
	 <TD style="padding-left:5px;padding-right:5px" class="labelmedium2">#APPLICATION.BaseCurrency# <cf_tl id="Exch. rate">:</TD>  
	 <td align="right">		  
	     <input type="text"
	       name="entryexcbase"
		   id="entryexcbase"
	       value="#NumberFormat(bseexc,'._____')#"
	       size="12"
		   #ena#
	       class="regularxxl"
	       style="text-align: right;background-color:ffffcf"
	       onChange="javascript:amountcalc('1')">
	 </td>
</tr>
	 
<tr class="#cl#">	
	 <td></td>
	 <td style="padding-left:5px;padding-right:5px" class="labelmedium2"><cf_tl id="Base Amount">:</td>
	 <td align="right"><input type="text"
	       name="entryamtbase"
		   id="entryamtbase"
	       value="#NumberFormat(bseamt,',.__')#"
	       size="12"
	       readonly	 
		   class="regularxxl"     
	       style="text-align: right;background-color:E6F6F6"
	       notab="">
	 </td> 	
</tr>
 
</table>
	 
</cfoutput>

<cfset AjaxOnLoad("enable_button")>
