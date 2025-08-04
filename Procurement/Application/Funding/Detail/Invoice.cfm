<!--
    Copyright © 2025 Promisan

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
<cfquery name="Invoice" datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT I.*, P.FullName
		FROM   Invoice_#Session.ACC#_#SESSION.FileNo# I LEFT OUTER JOIN 
			   Employee.dbo.Person P ON I.PersonNo=P.PersonNo
		ORDER BY Reference	   
</cfquery>

<cfif Invoice.recordcount gt "0">		

	<table width="99%" border="0" style="border:0px solid silver" class="navigation_table">  
	 
	   <cfquery name="Total" dbtype="query">
		SELECT    sum(InvoiceAmount) as Amount
		FROM      Invoice				
	   </cfquery>
	
	 	<cfoutput>
	  	<tr class="invoice line">	
		
		    <td></td>				      	       
		    <td colspan="5" height="15" style="padding-right:5;padding-left:1px;font-size:23px;font-weight:200" class="labelmedium">
		  	   <cf_tl id="Invoiced">/<cf_tl id="Disbursed">
			</td> 
			
			<td>
			<table><tr>
					  
		  		 <cfinvoke component="Service.Analysis.CrossTab"  
						  method         = "ShowInquiry"
						  buttonName     = "Excel"
						  buttonText     = "Export to MS - Excel"
						  buttonClass    = "td"
						  buttonIcon     = "#SESSION.root#/Images/sqltable.gif"
						  scriptfunction = "facttabledetailxls"
						  reportPath     = "Procurement\Application\Funding\Detail\"
						  SQLtemplate    = "InvoiceExport.cfm"  <!--- generates the data --->
						  queryString    = ""
						  dataSource     = "appsQuery" 
						  module         = "Program"
						  reportName     = "Budget: Disbursement"
						  table1Name     = "Export file"
						  data           = "1"					  
						  ajax           = "1"
						  olap           = "0" 
						  excel          = "1"> 				  
						  
		 	  </tr></table>
			  
			 </td> 		   				    
		    <td align="right" style="font-weight:200px;font-size:21px;padding-right:16px" class="labelmedium">#NumberFormat(Total.Amount,",__.__")#</td>					   
	  	</tr>
				
		</cfoutput> 
		   
		<cfset row = "0">
		   
		<cfoutput query="Invoice" group="Reference">		
		
			  <cfset row = row+1>
		
			  <tr class="navigation_row invoice line">
			  
				  <td valign="top" style="min-width:60;padding-top:7px;padding-left:5px">#row#.</td>
				  
			      <td colspan="7" class="labelit" style="width:100%;padding-left:4px">
				 
					  <table width="100%">
					  				  
					  <tr class="line" style="height:28px">
					  	<td colspan="9" class="labelit">
						  <cfif Reference eq "">#Journal# #JournalSerialNo#<cfelse>#Reference#</cfif></td>	
						</td>
						<td align="right" style="padding-right:16px">
						
						<cfif referenceNo neq "">
						
						  <cfquery name="Total" dbtype="query">
							SELECT    sum(InvoiceAmount) as Amount
							FROM      Invoice				
							WHERE     Reference = '#Reference#'
					   </cfquery>
					   
					   <b>#NumberFormat(Total.Amount,",__.__")#</b>
						
						</cfif>
						
						</td> 
					  </tr>
					  
					  <cfoutput>
					  
							 <tr class="filterrow navigation_row_child labelmedium linedotted">
							 
							 	<td height="12" width="20" align="center" style="padding-left:3px;padding-top:0px">	
											
									<cfif ReferenceId neq "">					
										<cf_img icon="open" navigation="Yes" onClick="invoiceedit('#ReferenceId#')">															  
									<cfelse>					
										<cf_img icon="open" navigation="Yes" onClick="ShowTransaction('#Journal#','#journalSerialNo#','','tab')">												  
									</cfif>	
									 
							   </td>			  				  				 			 			   
							  			   
							   <td style="padding-left:4px" width="10%">			   
							   <cfif ReferenceId neq "">
							   	<a href="javascript:invoiceedit('#ReferenceId#')">#ReferenceName#</a>
							   <cfelse>
							    <a href="javascript:ShowTransaction('#Journal#','#journalSerialNo#','','tab')">#JournalTransactionNo#</a>
							   </cfif>
							    <div class="filtercontent hide">#ReferenceName# #ReferenceNo# #JournalTransactionNo# #Description#</div>	
							   </td>	
							   		   
							   <cfif PersonNo neq "">
							        <td style="padding-left:4px" width="20%">	
								   	<a title="View profile" HREF ="javascript:EditPerson('#PersonNo#')"><font color="0080C0">#FullName#</a>
									</td>
								<cfelse>
									<td></td>	
							   </cfif>
							  		    
							   
							   <td width="90" style="padding-left:4px">#DateFormat(TransactionDate, CLIENT.DateFormatShow)#</td>			  	      			   
							   <td width="50%" colspan="3" style="padding-left:4px">
							   <cfif ReferenceId neq "">			   
							   	 <a href="javascript:invoiceedit('#ReferenceId#')"><font color="0080C0">#Description#</a>
							   <cfelse>
							     <a href="javascript:ShowTransaction('#Journal#','#journalSerialNo#','','tab')"><font color="black">#ReferenceName#<cfif ReferenceName neq "">:</cfif> <font color="0080C0">#Description#</a>
							   </cfif>			   
							   </td>		
							   <td style="min-width:40">#Currency#</td>	   
							   <td width="100" style="min-width:150px" align="right">#NumberFormat(InvoiceCurrency,",.__")#</td>
							   <td width="10%" align="right" style="padding-right:16px">#NumberFormat(InvoiceAmount,",.__")#</td>	 			
							 </tr>
							 			 
						 </cfoutput>			  
					  
					 </table>	
				 </td>	     
				 
			  </tr>
			 		  		 
		</cfoutput>
				
	</table>		 
	
</cfif>  
	
<script>
	Prosis.busy('no')
</script>	

 <cfset ajaxonload("doHighlight")>