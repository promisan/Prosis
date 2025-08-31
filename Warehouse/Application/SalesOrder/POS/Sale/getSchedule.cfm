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
<cfparam name="url.customerid" default="">

<cfquery name="qThisSale" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    SELECT *
	    FROM  CustomerRequestLine
	    WHERE 
	    <cfif url.customerId neq "">
			CustomerIdInvoice = '#url.customerid#'
		<cfelse>
			1=0	
	    </cfif>
	    AND PriceSchedule IS NOT NULL
</cfquery>		

<cfquery name="default" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_PriceSchedule	
	 WHERE  FieldDefault = 1
	 AND Operational = '1'
</cfquery>
		
<cfif qThisSale.recordcount neq 0>		
	<cfset sch = qThisSale.PriceSchedule>
<cfelse>
	<cfset sch = default.Code>
</cfif>
	
<cfif url.customerid neq "">
	
	<cfquery name="getSchedule" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     CustomerSchedule
		WHERE    CustomerId = '#url.customerid#' 
		AND      DateEffective =
	                          (SELECT     MAX(DateEffective) 
	                            FROM      CustomerSchedule
	                            WHERE     CustomerId = '#url.customerid#'
								AND       Category IN
	                                            (SELECT  Category
	                                             FROM    WarehouseCategory
	                                             WHERE   Warehouse = '#url.warehouse#')
								)
																
	</cfquery>		
			
	<cfif getSchedule.recordcount gte "1">					
		<cfset sch = getSchedule.PriceSchedule>	
	</cfif>			

</cfif>

<cfquery name="schedulelist" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_PriceSchedule							   							   
</cfquery>

<cfoutput>

<select name="PriceSchedule" id="PriceSchedule" style="font-size:16px;height:100%;width:100%;border:0px;background-color:f1f1f1;" class="regularXXL"
	onchange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=schedule&priceschedule='+this.value+'&requestno='+document.getElementById('RequestNo').value+'&customeridinvoice='+document.getElementById('customerinvoiceidselect').value,'salelines','','','POST','saleform')">
	
	<!--- <option value="">&nbsp;&nbsp;&nbsp;--- <cf_tl id="default"> ---</option> --->
	<cfloop query="schedulelist">
		<option value="#Code#" <cfif code eq sch>selected</cfif>>#Description#</option>
	</cfloop>
	
</select>	

</cfoutput>	