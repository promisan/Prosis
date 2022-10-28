
<cfparam name="url.referenceid" default="">
<cfparam name="URL.IDSorting" default="ReferenceNo">
<cfparam name="getTotal.records"         default="0">
<cfparam name="searchresult.recordcount" default="#getTotal.records#">

<table width="100%" height="100%">

<tr>

	<td valign="top">
	
	<table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">
	    
		  <tr style="height:20px" class="noprint line">
		  
		   <td style="padding-left:8px;min-width:400px" class="labellarge clsNoPrint">
	
		    <cfif url.journal neq "">
			
			  	<table style="width:100%">											
					<tr><td><cfinclude template="JournalTopMenu.cfm"></td></tr>						
				</table>
			
			<cfelse>
			
				<cf_tl id="Status of Submitted Invoices">
			
			</cfif>
				
		  </td> 
		  
		  <td align="right" style="padding-right:6px">
		  
		   <cfquery name="Batch"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     JournalBatch
				WHERE    Journal = '#URL.Journal#' 	
				AND      JournalBatchNo IN (SELECT JournalBatchNo 
				                            FROM   TransactionHeader 
											WHERE  Journal = '#URL.Journal#'
											AND    AccountPeriod = '#URL.Period#')
			</cfquery>	
			
			<table>
			<tr>			
			<td style="border-right:1px solid right">
					
			<cfif Batch.recordcount gte "1">
			
				<select name="journalbatchno" id="journalbatchno" style="background-color:f1f1f1;font-size:18px;height:35px;border:0px;" 
				class="regularxl" onchange="reloadForm(page.value,document.getElementById('idstatus').value)">
				<option value=""><cf_tl id="All Batch periods"></option>
				<cfoutput query="Batch">
					<option value="#journalbatchno#" <cfif url.journalbatchno eq journalbatchno>selected</cfif>>#journalbatchno#</option>
				</cfoutput>
				</select>
			
			<cfelse>
			
				<input type="hidden" name="journalbatchno" id="journalbatchno"  value="">
			
			</cfif>
			
			</td>
			  
			   <cfquery name="Month"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   DISTINCT MONTH(T.TransactionDate) AS Month
					FROM     TransactionHeader T
					WHERE    T.Journal       = '#URL.Journal#' 
					AND      T.AccountPeriod = '#URL.Period#'
					ORDER BY MONTH(T.TransactionDate)
				</cfquery>
			
			<td style="border-right:1px solid right">
			
			<cf_securediv id="mybox" bind="url:#session.root#/gledger/application/transaction/setMonth.cfm?journal=#url.journal#&period={period}">
						
			</td>
			
			<td style="border-right:1px solid right">
			
			<select name="period" id="period"
			    size="1" style="background-color:f1f1f1;font-size:16px;height:35px;;border:0px"
				class="regularxl"
				onChange="reloadForm(page.value,document.getElementById('idstatus').value)">
				<option value=""><cf_tl id="All"></option>
			    <cfoutput query="Period">
				<option value="#AccountPeriod#" <cfif AccountPeriod is URL.Period>selected</cfif>>#AccountPeriod#</option>
				</cfoutput>
		    </select>
			
			</td>
			
			<td style="padding-right:10px">
			
				<cf_button2 
					type		= "Print"
					text        = "" 
					id          = "Print"		
					mode        = "icon"	
					width       = "20px"												
					height		= "28px"
					imageheight = "25px"
					printTitle	= "##printTitle"
					printContent= ".clsPrintContent">
			
			</td>
			
			</tr>
			</table>
		 </td>
			
		 </tr> 
		 		  
		 <tr class="line" style="height:20px">
		 
		    <td style="padding-left:4px;padding-right:20px">
			
			<table>
			<tr>				
			
			<td style="padding-left:3px;padding-right:20px;">
			
					<table>
					<tr>			
					<td width="4" style="height:28px;padding-left:4px"></td>
					<td  style="border-left:1px solid silver;border-right:1px solid silver;background-color:f3f3f3">
					
						<input type = "text" 
						   name     = "filtersearch" 
						   id       = "filtersearch"
						   style    = "width:150;border:0px;background-color:transparent"
						   class    = "regularxl" 
						   onKeyUp  = "search(event)"
						   value    = "<cfoutput>#url.find#</cfoutput>">
						   
					   </td>
					  
					   <td style="border-left:1px solid silver;border-right:1px solid silver">
					   				   
						<cfoutput>
						  
						    <img src="#client.root#/Images/search.png" id="locate"
							     style="cursor:pointer;height:25;width:25;" 
							     alt="" 
								 border="0" 
								 align="absmiddle" 
								 onclick="reloadForm(page.value,document.getElementById('idstatus').value)">
							
						</cfoutput>
					  </td>  							 
					  
				   </tr>
				   </table>
						   
			</td>					
									
			<cfif url.journal eq "">
			
				<td>	
							
				
					<table>
					<tr class="labelmedium">
					<td  style="cursor: pointer;" onclick="reloadForm(document.getElementById('page').value,'Outstanding')">  					
					<input type="radio" style="height:18px;width:18px" class="radiol" name="Status" value="Outstanding" <cfif URL.IDStatus eq "Outstanding">checked</cfif>>
					</td>
					<td style="padding-left:3px;padding-right:10px">
					<cf_tl id="Outstanding">
					</td>
					<td style="padding-left:4px;cursor: pointer;" onclick="reloadForm(document.getElementById('page').value,'Voided')">
					<input type="radio" style="height:18px;width:18px" class="radiol" name="Status" value="Voided" <cfif URL.IDStatus eq "Voided">Checked</cfif>>
					</td>
					<td style="padding-left:3px;padding-right:10px">
					<font color="FF0000"><cf_tl id="Voided"></font>	
					</td>
					<!---
					<td style="padding-left:4px;cursor: pointer;" onclick="reloadForm(document.getElementById('page').value,'All')">
					<input type="radio" style="height:18px;width:18px" class="radiol" name="Status" value="All" <cfif URL.IDStatus neq "Outstanding" and URL.IDStatus neq "Voided">Checked</cfif>>
					</td>
					<td style="padding-left:3px;padding-right:10px">
					<cf_tl id="All">	
					</td>
					--->
					
					</tr>
					</table>
				
				</td>	
			
			<cfelse>
				
				<cfif Journal.TransactionCategory is "Payables" or
				      Journal.TransactionCategory is "Memorial" or 
				      Journal.TransactionCategory is "DirectPayment" or 
					  Journal.TransactionCategory is "Advances" or 
					  Journal.TransactionCategory is "Receivables" or 
					  Journal.TransactionCategory is "Receipt" or 
					  Journal.TransactionCategory is "Payment" or 
					  Journal.TransactionCategory is "Banking">
					  
					<td>	
									
					<table class="formpadding">
					
						<tr class="labelmedium2">					
						
						<td style="padding-left:7px;cursor: pointer;" onclick="reloadForm(document.getElementById('page').value,'Pending')">  				
						<input type="radio" style="height:18px;width:18px" class="radiol" name="Status" value="Pending" <cfif URL.IDStatus eq "Pending">checked</cfif>>
						</td>
						<td class="fixlength" style="padding-left:5px">
						<cf_tl id="Pending for Clearance">
						</td>
						
						<cfif Journal.TransactionCategory neq "Memorial" and  Journal.TransactionCategory neq "Receipt" and  Journal.TransactionCategory neq "Payment">
						
						<td style="padding-left:7px;cursor: pointer;" onclick="reloadForm(document.getElementById('page').value,'Outstanding')">  				
						<input type="radio" style="height:18px;width:18px" class="radiol" name="Status" value="Outstanding" <cfif URL.IDStatus eq "Outstanding">checked</cfif>>
						</td>
						<td style="padding-left:5px;padding-right:10px">
						<cf_tl id="Offset">
						</td>
						
						</cfif>
						
						<td style="padding-left:7px;cursor: pointer;" onclick="reloadForm(document.getElementById('page').value,'Voided')">
						<input type="radio" style="height:18px;width:18px" class="radiol" class="radiol" name="Status" value="Voided" <cfif URL.IDStatus eq "Voided">Checked</cfif>>
						</td>
						<td style="padding-left:5px;padding-right:10px"><font color="FF0000"><cf_tl id="Voided"></font></td>
						
						<td style="padding-left:4px;cursor: pointer;" onclick="reloadForm(document.getElementById('page').value,'All')">
						<input type="radio" style="height:18px;width:18px" class="radiol" name="Status" value="All" <cfif URL.IDStatus eq "All" or URL.IDStatus eq "">Checked</cfif>>
						</td>
						<td class="fixlength" style="padding-left:5px;padding-right:10px">
						<cf_tl id="All Valid">
						</td>
						
						</tr>
					
					</table>
					
					</td>	
				
				</cfif>	
				
			</cfif>	
				
			</tr>
			</table>  
		  
		  </td>
		  
		  <td align="right" style="padding-right:10px">
		  
			  <select name="group" id="group" 
			         class="regularxl" style="border:0px;border-left:1px solid silver"
					 onChange="reloadForm(document.getElementById('page').value,document.getElementById('idstatus').value)">
					 
				     <cfif url.journal eq "">
			    	 <option value="Journal" <cfif URL.IDSorting eq "Journal">selected</cfif>><cf_tl id="Journal">
					 </cfif>
					 <OPTION value="ReferenceNo" <cfif URL.IDSorting eq "ReferenceNo">selected</cfif>><cf_tl id="Source Document">		    
				     <OPTION value="ReferenceName" <cfif URL.IDSorting eq "ReferenceName">selected</cfif>><cf_tl id="Reference">
				     <OPTION value="TransactionDate" <cfif URL.IDSorting eq "TransactionDate">selected</cfif>><cf_tl id="TransactionDate">
					 <OPTION value="DocumentDate" <cfif URL.IDSorting eq "DocumentDate">selected</cfif>><cf_tl id="DocumentDate">
					 
			  </select> 	
			  
			  
			  <!--- can be removed  
			 
			  <cfif pages eq "1">
			   
		    	     <input type="hidden" id="page" name="page" value="1">
					 
			  <cfelse>
			   
					<select name="page"  id="page" size="1" class="regularxl" onChange="reloadForm(document.getElementById('group').value,this.value,document.getElementById('period').value,'<cfoutput>#URL.IDStatus#</cfoutput>',document.getElementById('filtersearch').value)">
					    <cfloop index="Item" from="1" to="#pages#" step="1">
							<cf_tl id="Page" var="1">
							<cfset vPage=#lt_text#>
							
							<cf_tl id="of" var="1">
							<cfset vOf=#lt_text#>
							
					        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>#vPage# #Item# #vOf# #pages#</option></cfoutput>
					    </cfloop>	 
					</SELECT>
				
				</cfif>  
								
				--->	
		
		  </td>
		  
		</tr> 	
		
		<tr>
	
		<td colspan="2" valign="top" style="height:10px">
					
			  <table width="100%" align="center" class="navigation_table">			  
					
				<cfoutput>
										  
				<tr class="line labelmedium">  
				  
				   <td colspan="10" height="24" style="width:100%;font-size:14px;padding-left:20px"><cf_tl id="Journal totals">:</td> 				   
				   <cfif outst eq "1">			   	   				
					   	<td align="right" class="clsSearchField" style="min-width:117px;padding-right:3px">#NumberFormat(getTotal.Amount,',.__')#</td>	
					    <td align="right" class="clsSearchField" style="min-width:117px;padding-right:3px">#NumberFormat(getTotal.AmountOutstanding,',.__')#</td>			
				   <cfelse>	 		   			     	   
				   	    <td class="clsSearchField" style="min-width:107px;padding-right:3px" align="right">#NumberFormat(getTotal.Amount,',.__')#</td>	
			 	   		<cfif journal.glaccount gte "1" and Journal.TransactionCategory neq "Memorial">
			   			<td class="clsSearchField" style="min-width:107px;padding-right:3px" align="right">#NumberFormat(getTotal.AmountTriggerDebit,',.__')#</td>	
						<td class="clsSearchField" style="min-width:107px;padding-right:3px" align="right">#NumberFormat(getTotal.AmountTriggerCredit,',.__')#</td>	
						</cfif>		   								
				   </cfif>
				   <td style="min-width:40px"></td>			   
				</tr>
						  
				</cfoutput>	
					 
				</table>
			
			</td>		 
	
		</TR>
		
		<!--- content --->	
					
		<tr class="line">
		
			<td colspan="2" class="clsPrintContent" id="journalcontent" valign="top" style="padding-left:10px;height:100%">	
						
				<cfinclude template="JournalListingDetail.cfm">											
			
			</td>		
		
		</tr>				
	
	
	</TABLE>
	
	</td>
	</tr>

</table>
