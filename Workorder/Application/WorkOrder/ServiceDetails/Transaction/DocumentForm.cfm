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

<cfif url.scope eq "entry">		
<cf_screentop height="100" close="parent.ColdFusion.Window.destroy('mydialog',true)" label="Record Transaction" option="Manual entry of costs" layout="webapp" banner="yellow" scroll="no">
<cfelse>
<cf_screentop height="100" close="parent.ColdFusion.Window.destroy('adddetail',true)" label="Record Transaction" option="Manual entry of costs" layout="webapp" banner="yellow" scroll="no">
</cfif>

<cfparam name="url.drillid"       default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.transactionid" default="#url.drillid#">

<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">
<cfparam name="url.scope"         default="edit">

<cfoutput>
<script>
  function calc() {
    qt = document.getElementById("quantity").value
	pr = document.getElementById("price").value		
    ColdFusion.navigate('Amount.cfm?quantity='+qt+'&price='+pr,'amount')
  }
  
  function validate() {
 	 	document.transactionform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {                     
			 ColdFusion.navigate('documentsubmit.cfm?mode=#url.scope#&action=update&workorderid=#url.workorderid#&workorderline=#url.workorderline#&transactionid=#url.transactionid#','process','','','POST','transactionform')
		}   
  
  }   
  
</script>
</cfoutput>

<cfquery name="get" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkorderLineDetail
		WHERE  TransactionId  = '#URL.transactionid#'						  
</cfquery>		

<cfif get.recordcount eq "1">

	<cfset url.workorderid   = get.workorderid>
	<cfset url.workorderline = get.workorderline>

</cfif>

<cfquery name="WorkOrder" 
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT *
	FROM   WorkOrder
	WHERE  WorkOrderId   = '#URL.workorderid#'						  
</cfquery>	

<cfquery name="ServiceItem" 
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT *
	FROM   ServiceItem
	WHERE  Code   = '#Workorder.ServiceItem#'						  
</cfquery>			
	
<cfquery name="Customer" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer
		WHERE  CustomerId   = '#workorder.customerid#'						  
</cfquery>			
	
<cfquery name="Line" 
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT *
	FROM   WorkOrderLine
	WHERE  WorkOrderId   = '#URL.workorderid#'		  
	AND    WorkOrderLine = '#url.workorderline#'					  
</cfquery>	

<cfquery name="Person" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  Personno  = '#Line.PersonNo#'		  					  
</cfquery>	

<cf_calendarscript>

<cfoutput>

<cfform name="transactionform" onsubmit="return false">
			
	<table width="95%" border="0" class="formpadding formspacing" cellpadding="0" align="center">

	<tr><td height="10"></td></tr>
				
	<tr class="labelmedium"><td height="15"><cf_tl id="Customer">:</td><td>#Customer.CustomerName#</td></tr>
	<tr class="labelmedium"><td height="15"><cf_tl id="Service">:</td><td>#ServiceItem.Description#</td></tr>
	<tr class="labelmedium"><td height="15"><cf_tl id="Service Tag">:</td><td>#Line.Reference#</td></tr>
	<tr class="labelmedium"><td height="15"><cf_tl id="User">:</td><td>#Person.Firstname# #Person.LastName#</td></tr>
	
			
	<tr><td height="4"></td></tr>
	<tr class="labelmedium">
	    <td><cf_tl id="Unit">:</td>
		<td height="23">		
														
		<cfquery name="Unit" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		     SELECT  *	
		     FROM    ServiceItemUnit
			 WHERE   ServiceItem  = '#workorder.serviceitem#'	
			 AND     Unit IN (SELECT  ServiceItemUnit 
						      FROM    ServiceItemUnitMission
							  WHERE   ServiceItem  = '#workorder.serviceitem#'	
							  AND     Mission      = '#workorder.mission#'
							  AND     DateEffective <= getDate()
						      AND     EnableUsageEntry = 1)
		</cfquery>
		
		<select name="serviceitemunit" id="serviceitemunit" class="regularxl">
		    <cfloop query="Unit">
			<option value="#unit#" <cfif get.serviceitemunit eq unit>selected</cfif>>#UnitDescription#</option>
			</cfloop>
		</select>
				
		</td>
	</tr>
	
	<tr  class="labelmedium">
	    <td>Date:</td>
		<td>	
		
		<cfif get.transactiondate eq "">		
			
			<cf_intelliCalendarDate9
				FieldName="TransactionDate" 
				Manual="True"		
				class="regularxl"								
				Default="#dateformat(now(),CLIENT.DateFormatShow)#"
				AllowBlank="False">	
		
		<cfelse>
		
			<cf_intelliCalendarDate9
				FieldName="TransactionDate" 
				Manual="True"		
				class="regularxl"								
				Default="#dateformat(get.TransactionDate,CLIENT.DateFormatShow)#"
				AllowBlank="False">	
			
		</cfif>	
		
		</td>
	</tr>
	
	<tr  class="labelmedium">
		<td>Reference:</td>
		<td>		
			<input type="text" 
			  name="Reference" 
              id="Reference"
			  value="#get.Reference#" 
			  size="30"  class="regularxl"
			  maxlength="30">		
		</td>
	</tr>
	
	<tr class="labelmedium">
		<td>TransactionNo:</td>
		<td>		
			<input type="text" 
			  name="DetailReference" 
              id="DetailReference"
			  value="#get.DetailReference#" 
			  size="30"  class="regularxl"
			  maxlength="30">		
		</td>
	</tr>
	
	<tr class="labelmedium">
		<td>Quantity:</td>
		<td>
		<cfif get.quantity eq "">
		 <cfset qt = "1">
		<cfelse>
		 <cfset qt = get.quantity> 
		</cfif>
		
		<cfinput type="Text" 
		 name="quantity" 
		 value="#qt#" 
		 message="Please enter a quantity" 
		 class="regularxl"
		 validate="integer" 
		 onchange="calc()"
		 required="No" 
		 visible="No" 
		 size="2" 
		 maxlength="3">		
		
		</td>
	</tr>
	
	<tr  class="labelmedium">
		<td>Price:</td>
		
		<td>
		
		<table cellspacing="0" cellpadding="0">
		<tr><td>
		
		<cfquery name="CurrencyList" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		     SELECT  *	
		     FROM    Currency
		</cfquery>
		
		<cfif get.currency eq "">
		
			<select name="Currency" id="Currency" class="regularxl">
			    <cfloop query="CurrencyList">
				<option value="#currency#" <cfif APPLICATION.BaseCurrency eq currency>selected</cfif>>#currency#</option>
				</cfloop>
			</select>
		
		<cfelse>
		
			<select name="Currency" id="Currency" class="regularxl">
			    <cfloop query="CurrencyList">
				<option value="#currency#" <cfif get.currency eq currency>selected</cfif>>#currency#</option>
				</cfloop>
			</select>
		
		</cfif>
		
		</td>
		<td>
		
		<cfif get.quantity eq "">
		 <cfset pr = "0">
		<cfelse>
		 <cfset pr = get.rate> 
		</cfif>
		
		<cfinput type="Text" 
		 name="price" 
		 value="#pr#" 
		 message="Please enter an price" 
		 validate="float" 
		 required="No" 
		 visible="No" 
		 size="6" 
		 onchange="calc()"
		 style="text-align:right"
		 class="regularxl"
		 maxlength="10">	
		
		</td>
		</tr></table>
				
		</td>
	</tr>
		
	<tr class="labelmedium">
		<td>Amount:</td>
		
		<td id="amount" height="23">
		
			<cfif get.amount neq "1">
				#numberformat(get.amount,"__,__.__")#
			<cfelse>
				#numberformat(0,"__,__.__")#
			</cfif>	
		
		</td>
		
	</tr>
	
	<tr><td height="1" colspan="2" style="border-bottom: 1px solid dadada;"></td></tr>	
	
	<tr><td colspan="2" align="center" id="process"></td></tr>
	<tr>
	<td colspan="2" align="center" height="30">
	
	<!--- define access --->

	<cfinvoke component = "Service.Access"  
		   method           = "WorkorderProcessor" 
		   mission          = "#workorder.mission#" 
		   serviceitem      = "#workorder.serviceitem#"
		   returnvariable   = "access">		     					   
			   
	   <cfif access eq "ALL" and get.recordcount eq "1">	   	   				   
  
		   <input type="button" 
				   name="Delete" 
                   id="Delete"
				   value="Delete" 
				   class="button10g" 					   
				   onclick="if (confirm('Do you want to remove this line ?')) { ColdFusion.navigate('documentsubmit.cfm?scope=edit&action=purge&transactionid=#url.transactionid#','process','','','POST','transactionform') }" 					  
				   style="height:25;width:100px">	
			   
		</cfif>	   		   
	
	    <input type="button" 
			   name="Save" 
			   value="Save" 
			   class="button10g" 					   
			   onclick="validate()" 					  
			   style="height:25;width:100px">		
	
	</td></tr>

</cfform>

</cfoutput>

</table>

