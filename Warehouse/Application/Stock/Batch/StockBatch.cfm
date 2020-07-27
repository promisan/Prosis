<!--- landing page for batches to be processed (cleared by this warehouse) but --->

<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cfparam name="URL.id"                default="0000">
<cfparam name="URL.mission"           default="">

<cfparam name="URL.page"              default="1">
<cfparam name="URL.status"            default="0">
<cfparam name="URL.Fnd"               default="">

<cfinvoke component = "Service.Access"  
     method             = "function"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 warehouse          = "#url.warehouse#"
	 SystemFunctionId   = "#url.SystemFunctionId#" 
	 returnvariable     = "access">	 	


	
<cfif access eq "DENIED">	 

	<table width="100%" height="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
		   <tr><td align="center" height="40" class="labelid">
		    <font color="FF0000">
				<cf_tl id="Detected a Problem with your access"  class="Message">
			</font>
			</td></tr>
	</table>	
	<cfabort>	
		
</cfif>		


<!---

<cfif URL.Group eq "">
    <cfset URL.Group = "Location">
</cfif>

<cfif URL.Page eq "1">
    <!--- prepare dataset : ItemReceipt_#SESSION.acc# --->
	<cfinclude template="StockBatchPrepare.cfm">
</cfif>

<cfquery name="SearchResult"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      StockBatch_#SESSION.acc#
	ORDER BY  #URL.Group# DESC, Detail DESC, Created DESC
</cfquery>

<cfset rows = ceiling((url.height-230)/21)>
<cfset first   = ((URL.Page-1)*rows)+1>
<cfset pages   = Ceiling(SearchResult.recordCount/rows)>
<cfif pages lt '1'>
      <cfset pages = '1'>
</cfif>

--->
	
<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">
	
<table width="100%" height="100%" align="center">

<tr><td valign="top" height="100%">
	
	<table width="98%"
	       height="100%"	       
		   align="center">
				
	  <cfinvoke component   = "Service.Access"  
		   method          = "RoleAccess" 
		   Role            = "'WhsPick'"
		   Parameter       = "#url.systemfunctionid#"
		   Mission         = "#url.mission#"  	  
		   AccessLevel     = "2"
		   returnvariable  = "FullAccess">	
	 	  
	  <tr><td colspan="4" height="30" style="padding-top:4px;padding-left:7px">
	  
	  	<table><tr><td onclick="maximize('batchsummary')">
		
		<cfset down = "regular">
		<cfset up   = "hide">	
		
		<cfoutput>
				
		<img src="#SESSION.root#/images/up6.png" 
		    id="batchsummaryMin"		  
			style="border: 0px solid Silver;cursor: pointer;"
			class="#up#">
		<img src="#SESSION.root#/images/down6.png" 		    
			id="batchsummaryExp"
			style="border: 0px solid Silver;cursor: pointer;"
			class="#down#">
			
		</cfoutput>	
			
		</td><td onclick="maximize('batchsummary')" style="cursor:pointer;padding-left:4px" class="labelmedium"><cf_tl id="Inquiry Pending Transaction"></td></tr></table>
	  
	  </td></tr>
	  
	  <tr><td class="line"></td></tr>  	  
	  
	  <tr class="line" style="height:10px">
	  	<td name="batchsummary" id="batchsummary" class="<cfoutput>#up#</cfoutput>">
	  		<cfinclude template="StockBatchSummary.cfm">
	  	</td>
	  </tr>
	  	 	  	   
	  <tr style="height:10px">
	
		  <td>
						
				<cfoutput>	
				
				<table width="99%">
				<tr>
				<td width="190px">
								
					<table>					
					<input type="hidden" name="batchmode" id="batchmode" value="calendar">					
					<tr>
					<td><input type="radio" class="radiol" name="mde" id="mde" value="calendar" checked onclick="document.getElementById('batchmode').value='calendar';Prosis.busy('yes');stockbatch('','#url.systemfunctionid#','calendar',document.getElementById('warehouseselected').value)"></td>
					<td class="labelmedium" style="font-size:20px;padding-left:3px"><cf_tl id="Calendar"></td>
					<td style="padding-left:5px">
					<input type="radio" class="radiol" name="mde" id="mde" value="listing" onclick="document.getElementById('batchmode').value='listing';Prosis.busy('yes');stockbatch('','#url.systemfunctionid#','listing',document.getElementById('warehouseselected').value)">					
					</td>
					<td class="labelmedium" style="font-size:20px;padding-left:3px"><cf_tl id="Listing"></td>															
					</tr>					
					</table>
				
				</td>
				<TD height="20" align="right" class="labelmedium">	
				
					<table>
					
					<cfset link = "Prosis.busy('yes');stockbatch('x','#url.systemfunctionid#',document.getElementById('batchmode').value,document.getElementById('warehouseselected').value)">
					
					<tr class="labelmedium">
					<input type="hidden" class="radiol" name="status" id="status" value="#URL.Status#">
					<td style="padding-left:2px;font-weight:400">
					<input type="radio" id="content_refresh" class="radiol" name="stat" id="stat" value="0" <cfif URL.status eq "0">checked</cfif> onclick="document.getElementById('status').value=0;#link#">
					</td>
					<td class="labelmedium" style="font-size:20px;padding-left:3px">
					<font color="C4C400"><cf_tl id="Pending">
					</td>
					<td style="padding-left:8px;font-weight:400">
					<input type="radio" class="radiol" name="stat" id="stat" value="1" <cfif URL.status eq "1">checked</cfif> onclick="document.getElementById('status').value=1;#link#">
					</td>
					<td class="labelmedium" style="font-size:20px;padding-left:3px">
					<font color="008000"><cf_tl id="Confirmed">
					</td>
					<td style="padding-left:8px;font-weight:400">
					<input type="radio" class="radiol" name="stat" id="stat" value="9" <cfif URL.status eq "9">checked</cfif> onclick="document.getElementById('status').value=9;#link#">
					</td>
					<td class="labelmedium" style="font-size:20px;padding-left:3px">
					<font color="red"><cf_tl id="Overruled">
					</td>
					
					<td style="padding-left:10px">
					<!---
					<select name="group" id="group" size="1" style="height:20px;font:12px;" onChange="stockbatch('x','#url.systemfunctionid#')">
					     <option value="TransactionDate" <cfif URL.Group eq "TransactionDate">selected</cfif>><cf_tl id="Group by Transaction Date">			    
					</SELECT> 
					--->
					</td>
										
					</tr>
					</table>
				
				</TD>
				</tr>
				</table>	
				
				</cfoutput>
								
		  </td>			
	  </tr>
	  	    	 						
	  <TR>
	  
		<td height="100%" colspan="2" valign="top" id="batchmain">												
			<cfinclude template="StockBatchCalendar.cfm">					
		</td>
		
	  </tr>
	  
	</table>		
	
</td></tr>

</table>