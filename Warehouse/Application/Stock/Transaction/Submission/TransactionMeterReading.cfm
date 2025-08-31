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
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="fafafa">

<tr><td class="labellarge" style="height:35;padding-top:8px;padding-left:15px"><b><i>Meter readings and transaction submission</td></tr>
<tr><td colspan="1" class="linedotted"></td></tr>

<tr><td height="95%" valign="top">

<cfquery name="reading" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ItemWarehouseLocation 
	WHERE  Warehouse = '#url.warehouse#'	
	AND    Location  = '#url.location#'	
	AND    ItemNo    = '#url.itemno#'
	AND    UoM       = '#url.UoM#' 				
</cfquery>

<cf_getWarehouseTime warehouse="#url.warehouse#">
<cfset hr = "#timeformat(localtime,'HH')#">			
<cfset mn = "#timeformat(localtime,'MM')#">

<cfoutput>

	<table width="87%" cellspacing="0" cellpadding="0" align="center">
	
		<tr><td height="10"></td></tr>
		
		<tr><td colspan="3" class="labelit" style="color:blue; font-style:italic;">* #url.message#</td></tr>
		
		<tr><td height="6"></td></tr>
				
		<tr>
			<td colspan="3">
				<cfinclude template="TransactionActor.cfm">
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr>	
			<td class="labelit" width="20%"><cf_tl id="Opening Meter">:<font color="FF0000">*</font></td>	
			<td>	   
				<input type  = "Text"
			       name      = "cTransactionOpening"
				   id        = "cTransactionOpening"
				   onchange  = "ColdFusion.navigate('../Transaction/LogReading/TransactionLogReadingSet.cfm?warehouse=#url.warehouse#&location=#url.location#&ItemNo=#url.itemno#&UoM=#url.uom#&field=opening&value='+this.value+'&refreshMain=1','openingset')"
			       message   = "Please enter a numeric value"
				   value     = "#reading.ReadingOpening#"	 
				   class     = "regularxl"		    					   	       
		           style     = "width:100;text-align:right">
			</td>
			<td>
				<table cellspacing="0" width="100%" class="formpadding">
					<tr><td class="labelit" style="padding-left:4px">On:</td>
						<td align="center">	
							<cf_setCalendarDate
								name     = "openReadingDate"        
								timeZone = "#tzcorrection#"     
								font     = "14"
								class    = "regularxl"	
								mode     = "datetime">
						</td>
						<td align="center" class="labelit">UTC#timezone#</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td class="labelit"><cf_tl id="Closing Meter">:<font color="FF0000">*</font></td>
			<td>
				<input type = "Text"
			       name     = "cTransactionClosing"
				   id       = "cTransactionClosing"
				   onchange = "ColdFusion.navigate('../Transaction/LogReading/TransactionLogReadingSet.cfm?warehouse=#url.warehouse#&location=#url.location#&ItemNo=#url.itemno#&UoM=#url.uom#&field=closing&value='+this.value+'&refreshMain=1','closingset')"	       
			       message  = "Please enter a numeric value"
				   class    = "regularxl"				  
				   value    = "#reading.ReadingClosing#"		     			      
		           style    = "width:100;text-align:right">
			 </td>
			 <td>
				<table cellspacing="0" width="100%" class="formpadding">
					<tr><td class="labelit" style="padding-left:4px">On:</td>
						<td align="center">	
							<cf_setCalendarDate
								name     = "closeReadingDate"        
								timeZone = "#tzcorrection#"     
								font     = "14"
								class="regularxl"	
								mode     = "datetime"> 
						</td>
						<td align="center" class="labelit">UTC#timezone#</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<cf_assignid>
		
		<cfset batchid = rowguid>
		
		<tr><td height="5"></td></tr>
		
		<tr>
		  <td class="labelit"><cf_tl id="Attachments">:</td>
		  <td colspan="2">
		  
		  <cf_filelibraryN 
			DocumentPath="WhsBatch" 
			SubDirectory="#BatchId#" 
			Filter="" 
			Insert="yes" 
			Remove="yes" 
			width="100%"
			LoadScript="false" 
			rowHeader="no" 
			ShowSize="yes"> 
		  
		  </td>		
		</tr>
			
		
		<tr><td height="5"></td></tr>
		<tr><td class="linedotted" colspan="3"></td></tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td colspan="3" align="center" height="30">
									
				<cf_tl id="Submit Transactions" var="1">
								
				<input type="button"					
					value       = "#lt_text#" 				
					onclick		= "processStockIssue('#url.mode#','#url.warehouse#','#url.tratpe#','#url.location#','#url.itemno#','#url.uom#','#batchid#','#url.systemfunctionid#');"
					name        = "save2"					
					id          = "save2"
					style       = "height:25;width:220px">
					
			</td>
		</tr>
	</table>
</cfoutput>

</td></tr>

</table>     

<cfset AjaxOnLoad("clearStockIssueEndFocus")>