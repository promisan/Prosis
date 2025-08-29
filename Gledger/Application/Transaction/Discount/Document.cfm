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
<cfquery name="get"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   TransactionHeader
		WHERE  Journal = '#url.journal#'
		AND    JournalSerialNo = '#url.journalserialno#'		
</cfquery>

<cfquery name="check"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT GLAccount
		FROM   JournalAccount
		WHERE  Journal = '#url.journal#'
	    AND    Mode = 'Correction'
</cfquery>


<cf_tl id= "Apply financial discount #get.TransactionCategory#" var="label">

<cf_screentop height="100%" layout="webapp" scroll="Yes" label="#label#" jquery="Yes">

<cfif check.recordcount eq "0">	

	<cfoutput>
	<table width="92%" align="center" class="formpadding formspacing">
		
		<tr class="labelmedium"><td align="center" style="padding-top:70px;font-size:18px">Please define a [correction] contra account for journal: #url.journal#</td></tr>
		
	</table>	
	</cfoutput>

<cfelse>
	
	<!--- form to collect discount information --->
	
	<cfoutput>
	<script language="JavaScript">
		function apply() {			   
			ptoken.navigate('DocumentSubmit.cfm?journal=#journal#&journalserialno=#url.journalserialno#','process','','','POST','discountform')	
		}
	</script>
	</cfoutput>
	
	<cfform name="discountform" method="POST">
	
		<table width="92%" align="center" class="formpadding formspacing">
		
		<tr class="hide"><td id="process"></td></tr>
		
		<tr><td></td></tr>
			
		<cfquery name="get"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   TransactionHeader
			WHERE  Journal = '#url.journal#'
			AND    JournalSerialNo = '#url.journalserialno#'		
		</cfquery>
		
		<tr class="line">
		    <td colspan="2" style="height:50px;font-size:30px" class="labellarge"><cf_tl id="Receivable"></td>	
		</tr>
		<tr><td></td></tr>
		
		<cfoutput>
		
		<tr class="labelmedium2">
		    <td style="width:20%;padding-left:10px"><cf_tl id="Transaction No">:</td>
			<td>#url.journal# - #url.journalserialNo#</td>	
		</tr>
		
		<tr class="labelmedium2">
		    <td style="padding-left:10px"><cf_tl id="Relation">:</td>
			<td>#get.ReferenceName#</td>	
		</tr>
		
		<tr class="labelmedium2">
		    <td style="padding-left:10px"><cf_tl id="Date">:</td>
			<td>#dateformat(get.DocumentDate,client.dateformatshow)#</td>	
		</tr>
		
		<cfif get.documentAmount neq get.amount>
		
			<tr class="labelmedium2">
			    <td style="padding-left:10px"><cf_tl id="Document">:</td>
				<td>#get.DocumentCurrency# #numberformat(get.DocumentAmount,'.,__')#</td>	
			</tr>
		
		</cfif>
		
		<tr class="labelmedium2">
		    <td style="padding-left:10px"><cf_tl id="Amount">:</td>
			<td>#get.Currency# #numberformat(get.Amount,'.,__')#</td>	
		</tr>
		
		<tr class="labelmedium2">
		    <td style="padding-left:10px"><cf_tl id="Outstanding">:</td>
			<td style="font-size:20px;color:red"><b>#get.Currency# #numberformat(get.AmountOutstanding,'.,__')#</td>	
		</tr>
		
		</cfoutput>
		
		<tr><td></td></tr>
		<tr><td></td></tr>
		
		<tr class="line">
		    <td colspan="2" style="height:50px;font-size:30px" class="labellarge"><cf_tl id="Discount"></td>	
		</tr>
		<tr><td></td></tr>
				
		<cfquery name="Journal"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Journal J
			WHERE  Operational = 1
			AND    TransactionCategory = '#URL.Category#'	
			AND    Mission  = '#get.Mission#'
			AND    Currency = '#get.Currency#' 
			<cfif getAdministrator(get.mission) eq "1">	
					<!--- no filtering --->
			<cfelse>	
			AND    Journal IN (SELECT ClassParameter 
					           FROM   Organization.dbo.OrganizationAuthorization 
					           WHERE  UserAccount = '#SESSION.acc#' 
							   AND    AccessLevel IN ('1','2')
					           AND    Role = 'Accountant')  
			</cfif>		
		</cfquery>
			
		<cfoutput>
		<cfif journal.recordcount eq "0">
			<cf_message message="Problem, no #URL.Category# journal has been configured for your access.">
			<cfabort>
		</cfif>
		</cfoutput>
		
		<tr class="labelmedium">
		    <td style="padding-left:10px"><cf_tl id="Journal">:</td>
			<td>
			
			     <select name="journal" id="journal" class="regularxxl enterastab">		     		      
			            <cfoutput query="Journal">
			        	<option value="#Journal#" <cfif journal eq url.journal>selected</cfif>>
			           		#Journal# #Description#
						</option>
			         	</cfoutput>			
			     </select>
			
			</td>	
		</tr>	
		
		<tr>
		
		<TD style="padding-left:10px" class="labelmedium"><cf_tl id="Account">:</TD>			 	 	  			  
		
		<td colspan="1" id="account">
			
			<cf_securediv bind="url:#session.root#/Gledger/Application/Transaction/Discount/getAccount.cfm?journal=#url.journal#&journalserialno=#url.journalserialno#&selected={journal}" 
			  id="accountbox">
			  					   					   
		    </td>
			
		</tr>
		
		<tr class="labelmedium">
		    <td style="padding-left:10px"><cf_tl id="Reference">:</td>
			<td>
			
			   <cfoutput>
			    <input type="text" name="Reference" class="regularxxl enterastab" value="#get.Reference#" style="width:160" maxlength="20">	
			   </cfoutput>	
			   
			</td>	
		</tr>
			
		<cfquery name="Period" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Period 
			WHERE  ActionStatus = '0' 
			AND    AccountPeriod >= '#get.AccountPeriod#'
		</cfquery>
		
		<tr>
		
			<TD style="padding-left:10px" class="labelmedium"><cf_tl id="Fiscal Period">:</TD>			 	 	  			  
		    <td colspan="1">
						  					  		  
			    <select name="accountperiod" id="accountperiod" class="regularxxl enterastab">
					 
		            <cfoutput query="Period">
		        	   <option value="#AccountPeriod#" <cfif AccountPeriod is get.AccountPeriod>selected</cfif>>
		           	   #AccountPeriod#
					   </option>
		         	</cfoutput>
		
	           </select>
						   					   
		    </td>
			
		</tr>
		
		
		<tr class="labelmedium">
		    <td style="padding-left:10px"><cf_tl id="Discount date">:</td>
			<td>
			
				<cf_calendarScript>
			
			    <cf_intelliCalendarDate9
						      FieldName="TransactionDate" 			 
							  class="regularxxl enterastab"			  
						      Default="#Dateformat(now(), CLIENT.DateFormatShow)#">
			
			</td>	
		</tr>
		
		
		<tr class="labelmedium">
		    <td style="padding-left:10px"><cf_tl id="Amount">:</td>
			<td>
			
			<table><tr><td>
			
				<cfif get.AmountOutstanding eq get.Amount>
					<cfset amt = "0">
				<cfelse>
					<cfset amt = get.AmountOutstanding>
				</cfif>
			
			  <input type="text"
			       name="discountamount"
				   id="discountamount"
			       value="<cfoutput>#amt#</cfoutput>"
			       size="10"
			       class="regularxxl enterastab"
				   style="width:120;padding-top:1px;text-align: right;padding-right:4px;height:30px;font-size:20px">
				   
				  </td>
				  <td style="padding-left:4px"><cfoutput>#get.Currency#</cfoutput></td>
				  </tr></table> 
			
			</td>	
		</tr>
		
		<tr class="labelmedium">
		    <td style="padding-left:10px"><cf_tl id="Invoice">:</td>
			<td>
			
			  <cfoutput>
			    <input type="text" name="ActionReference1" class="regularxxl enterastab" style="width:40"  maxlength="5">	
			    <input type="text" name="ActionReference2" class="regularxxl enterastab" style="width:100" maxlength="20">	
			   </cfoutput>	
			
			</td>	
		</tr>	
		
		<tr class="labelmedium">
		    <td style="padding-left:10px"><cf_tl id="Memo">:</td>
			<td>
			
			  <cfoutput>
			    <input type="text" name="Description" class="regularxxl enterastab" style="width:90%" maxlength="200">	
			   </cfoutput>	
			
			</td>	
		</tr>	
		
		<tr><td style="height:10px"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr>
			<td colspan="2" height="30" align="center">
						
			   <cfoutput>
			  
	   		   <cf_tl id="Apply discount" var="1">
			   
		       <input type="button" id="submit" style="width:260px;font-size:13px" value="#lt_text#" 
			       class="button10g" 
				   onClick="Prosis.busy('yes');apply()">			   
			  				   
			   </cfoutput> 
			</td>
		</tr>
		
		</table>
		
	</cfform>	
	
</cfif>	
	