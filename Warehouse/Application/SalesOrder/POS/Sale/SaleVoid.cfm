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

<cfparam name="url.requestNo" default="">

<cfquery name="getWarehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Warehouse
		WHERE  Warehouse = '#URL.Warehouse#'		
</cfquery>

<cfquery name="getBatch"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT BatchId
		FROM   CustomerRequestLine
		WHERE  RequestNo = '#url.requestNo#'
		AND    BatchId is not NULL
</cfquery>

<!--- ---------------------------------------------------------------------------------------- --->
<!--- this is hardcoded voiders, need to be part of the structure of ALL for this POS function --->
<!--- ---------------------------------------------------------------------------------------- --->

<cfquery name="getValidVoider"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM	UserNamesGroup
		WHERE	AccountGroup = 'SaleVoiders'
		AND		Account = '#session.acc#'
</cfquery>

<CFParam name="Attributes.height" default="660">
<CFParam name="Attributes.width"  default="780">	
<CFParam name="Attributes.Modal"  default="true">	
			
<cfset link   = "#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#&">			
<cfset jvlink = "ProsisUI.createWindow('dialogcustomerbox','Customer','',{x:100,y:100,height:document.body.clientHeight-80,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Customer/Customer.cfm?datasource=appsMaterials&close=Yes&class=Customer&box=customerbox&link=#link#&dbtable=&des1=customerid&filter1=&filter1value=&filter2=&filter2value=','dialogcustomerbox')">		
	
<cfif getBatch.recordCount eq 1>

	<cfif getBatch.BatchId neq "">
	
	    <table class="formspacing">
		<tr>
		<td valign="top">
			
			<cfset go = "0">

			<cfif SESSION.isAdministrator eq "Yes" OR getValidVoider.recordCount eq 1>
				<cfset go = "1">				
			</cfif>
	
			<cfif go eq "1">
	
				<cf_tl id="Void this sale" var="1">
				<cfoutput>
					<img src="#SESSION.root#/images/logos/menu/delete.png" 
						 title="#lt_text#" 
						 align="absmiddle" 
						 height="40" 
						 style="cursor:pointer;" 
						 onclick="voidSale('#url.customerid#','#URL.Warehouse#','#getBatch.BatchId#',document.getElementById('terminal').value,'#url.requestno#')">
				</cfoutput>		
			
			</cfif>
		
		</td>
		
		<td style="padding-left:25px">
		
			<cf_tl id="Print Invoice" var="1">
			<cfoutput>
				<img 
					src="#SESSION.root#/images/print.png" 
					title="#lt_text#" 
					align="absmiddle" 
					height="40" 
					style="cursor:pointer;" 
					onclick="printSale('#url.customerid#','#url.Warehouse#','#getBatch.BatchId#',document.getElementById('terminal').value);">
			</cfoutput>		
		
		</td>
		
		</tr>
		</table>
		
	<cfelse>			
		
		<!--- button to select other active waiting customer in memory --->
		
		<cfquery name="getCustomer"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    Mission,CustomerId, CustomerName, Reference
			FROM      Customer
			WHERE     CustomerId IN (SELECT  CustomerId
		                             FROM    vwCustomerRequest
									 WHERE   Warehouse = '#url.warehouse#'
									 AND     ActionStatus != '9'
									 AND     BatchNo is NULL)
			AND       CustomerId != '#url.customerid#'						
		</cfquery>
			
		<cfoutput>	

			<table class="formspacing">
				                
            <tr>
				<td>		
									
                <button type="button" class="btn btn-lg btn-light" onclick="#jvlink#" style="height: 38px;width: 180px;padding: 0 0 0 9px!important;text-align: left; margin-bottom:0px!important;">                                                       
				<img src="#SESSION.root#/Images/Search-R-Blue.png" width="26"><span style="top:-4px;left: 10px;"><cf_tl id="Find Customer"></button>
				
				</td>
			</tr>
			
			<cfif getCustomer.recordcount gte "1">
			<tr>
				<td>
				
				    <cfset jvlink = "ProsisUI.createWindow('dialogquotebox','In Line','',{x:100,y:100,height:document.body.clientHeight-80,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/InLine/InLineView.cfm?warehouse=#url.warehouse#','dialogquotebox')">		

								
				 <!--- old embedded search for other sales
                 <button type="button" class="btn btn-lg btn-light" style="height: 38px;width: 180px;padding: 0 0 0 9px!important;text-align: left; margin-bottom:0px!important;"
					  onclick="searchcombo('#getCustomer.mission#','#url.warehouse#','','switch','inmemory','up','','##customeridselect_val')">
					  <img src="#SESSION.root#/Images/SwitchUser-Blue.png" width="26"><span style="top:-4px;left: -2px;"><cf_tl id="Switch Sale"></button>
				  --->	  
				  <button type="button" class="btn btn-lg btn-light" style="height: 38px;width: 180px;padding: 0 0 0 9px!important;text-align: left; margin-bottom:0px!important;"
					  onclick="s#jvlink#">
					  <img src="#SESSION.root#/Images/SwitchUser-Blue.png" width="26"><span style="top:-4px;left: 18px;"><cf_tl id="Switch Sale"></button>
					  
				
				</td>
			</tr>                
			</cfif>
                                    
			</table>	
						
        </cfoutput>
				
	</cfif>					
		
<cfelse>
	
	<!--- button to select other customer in memory --->
	
	<cfquery name="getCustomer"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    Mission,CustomerId, CustomerName, Reference
			FROM      Customer
			WHERE     CustomerId IN (SELECT  CustomerId
		                             FROM    vwCustomerRequest
									 WHERE   Warehouse = '#url.warehouse#'
									 AND     ActionStatus != '9')
			AND       CustomerId != '#url.customerid#'						
	</cfquery>
			
	<cfoutput>
		
		<table class="formspacing">
		            
            <tr>
				<td>	
								
	                <button type="button" class="btn btn-lg btn-light" onclick="#jvlink#" style="height: 38px;width: 180px;padding: 0 0 0 9px!important;text-align: left; margin-bottom:0px!important;">                                                       
					<img src="#SESSION.root#/Images/Search-R-Blue.png" width="26"><span style="top:-4px;left: 10px;"><cf_tl id="Find Customer"></span>
					</button>
				
				</td>
			</tr>
			
			<cfif getCustomer.recordcount gte "1">
			   			
				<tr>
					<td>
					
					  <!---
										
		                <button type="button" class="btn btn-lg btn-light" style="height: 38px;width: 180px;padding: 0 0 0 9px!important;text-align: left; margin-bottom:0px!important;"
						  onclick="searchcombo('#getCustomer.mission#','#url.warehouse#','','switch','inmemory','up','','##customeridselect_val')">
						  <img src="#SESSION.root#/Images/SwitchUser-Blue.png" width="26">
						  <span style="top:-4px;left: -2px;"><cf_tl id="Switch Sale"></span>
						</button>
					
					  --->
					  
					  <!---
					  <cfset jvlink = "ProsisUI.createWindow('wfuserchat', 'Messenger', '', { height:document.body.clientHeight-89,width:510,resizable:false,center:false,modal:false, position:{top:40, left:document.body.clientWidth-525}, animation:{ open: { effects: "slideIn:up" }, close: { effects: "slideIn:up", reverse: true} }});">
					  --->
				  
					  <cfset jvlink = "ProsisUI.createWindow('dialogquotebox','In Line','',{height:document.body.clientHeight-80,width:#Attributes.width#,modal:#attributes.modal#,center:false,position:{top:40, left:document.body.clientWidth-#Attributes.width+30#}, animation:{ open: { effects: 'slideIn:up' }, close: { effects: 'slideIn:up', reverse: true} }});ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/InLine/InLineView.cfm?warehouse=#url.warehouse#','dialogquotebox')">		
		
					  <button type="button" class="btn btn-lg btn-light" style="height: 38px;width: 180px;padding: 0 0 0 9px!important;text-align: left; margin-bottom:0px!important;"
					  onclick="#jvlink#">
					     <img src="#SESSION.root#/Images/SwitchUser-Blue.png" width="26">
					     <span style="top:-4px;left: 18px;"><cf_tl id="Switch Sale"></span>
					  </button>
					
					</td>
				</tr>
			</cfif>
                     
		</table>		
		
	</cfoutput>				
	
</cfif>