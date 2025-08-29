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
<cfparam name="URL.Option" default="Hide">

<cfset add          = "1">
<cfset Header       = "Currency Exchange Rates to <cfoutput>#APPLICATION.BaseCurrency#</cfoutput>">

<cf_PresentationScript>

<cfparam name="URL.Option" default="show">

<cf_screentop html="No" jquery="Yes">

<table height="100%" width="94%" align="center" cellspacing="0" cellpadding="0" align="center">

<tr><td style="height:10">

<cfinclude template = "../HeaderMaintain.cfm"> 

</td></tr>

<cfquery name="Exchange"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   CE.Currency, Max(CE.EffectiveDate) as EffectiveDate
	FROM     CurrencyExchange CE, Currency C
	WHERE    CE.Currency = C.Currency
	AND      ExchangeRateModified < getdate()-1
	GROUP BY CE.Currency
</cfquery>

<cfloop query="Exchange">

	<cfquery name="Last"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  CurrencyExchange CE
		WHERE Currency          = '#Currency#'
		AND   EffectiveDate     = '#dateFormat(EffectiveDate,Client.DateSQL)#'
	</cfquery>
	
	<cfquery name="Update"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Currency 
		SET    ExchangeRate         = '#Last.ExchangeRate#',
		       ExchangeRateModified = getdate()
		WHERE  Currency           = '#Currency#'
	</cfquery>

</cfloop>

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *, 
	         (SELECT MAX(EffectiveDate) FROM CurrencyExchange WHERE Currency = C.Currency) as Effective
	FROM     Currency C
	ORDER BY EnableProcurement DESC
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=770, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1,id2) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 +"&ID2=" + id2, "Edit", "left=80, top=80, width=770, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function exclog(id,id1) {
 	
	se   = document.getElementById("log"+id);				 		 
	if (se.className == "hide") {	   	
		 se.className  = "regular";
		 url = "RecordListingDetail.cfm?time=#now()#&id=" + id + "&id1=" + id1
		 ptoken.navigate(url,'detail'+id)
 	 } else {	   	
    	 se.className  = "hide"
	 }
		 		
  }
  
</script>	

</cfoutput>


<tr><td style="height:40">

<cfinvoke component = "Service.Presentation.tableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font:15px;height:25;width:120"
			   rowclass         = "filter_row"
			   rowfields        = "filter_content">

</td></tr>
	
<tr>
<td colspan="1" style="height:100%">

<cf_divscroll>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium2 line fixrow">
      
    <td width="5%" align="left"></td> 
    <td width="60" align="left">Acr</td>
	<td width="15%" align="left">Description</td>	
	<td width="80" align="left">Updated</td>	
	<td align="15%" style="padding-left:3px">Officer</td>
	<td width="5%" align="left"></td>
    <td align="10%">Entered</td>
	<td width="80" align="left">Effective</td>
	<td width="100" style="padding-right:5px" align="right">Exchange Rate</td>	
  
</tr>

<cfoutput query="SearchResult" group="EnableProcurement">

<tr class="filter_row"><td colspan="8" style="height:40;font-size:20px;font-weight:200" class="labellarge"><cfif EnableProcurement eq "1">Procurement enabled<cfelse>Other</cfif></td></tr>
	
	<cfoutput>
	    
	    <tr class="labelmedium2 navigation_row line filter_row">
					
			<td style="padding-left:5px;padding-top:1px;">
			   <cf_img icon="select" onclick="recordedit('#URLEncodedFormat(Currency)#')" navigation="yes">		   
			</td>			
			
			<td class="filter_content">#Currency#</td>
			<td class="filter_content">#Description#</td>
			
			<td><cfif URL.Option eq "hide">#Dateformat(ExchangeRateModified, "#CLIENT.DateFormatShow#")#</cfif></td>
			<td style="padding-left:10px">#OfficerFirstName# #OfficerLastName#</td>
			
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			<td align="center" style="height:18;padding-top:2px;">	
			   <cf_img icon="expand" toggle="yes" onclick="exclog('#currency#')">	
			</td>
			<td><cfif URL.Option eq "hide">#Dateformat(Effective, "#CLIENT.DateFormatShow#")#</cfif></td>	
			<td align="right" style="padding-right:6px"><cfif URL.Option eq "hide">#NumberFormat(ExchangeRate,',.____')#</cfif></td>
			
	    </tr>
		
		<tr id="log#currency#" class="hide">
		    <td colspan="4"></td>
			<td></td>
			<td></td>
			<td></td>
			<td colspan="2" id="detail#currency#"></td>
			
		</tr>
				
	</cfoutput>		

</CFOUTPUT>

</table>

</cf_divscroll>

</td>

</table>

<cfset ajaxonload("doHighlight")>