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
<cfparam name="url.requestno"  default="0">

<!--- --------------------------------------------------------- --->
<!--- Ajax template template to update the totals in the screen --->
<!--- --------------------------------------------------------- --->

<cfquery name="getTotal"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT SUM((SchedulePrice - SalesPrice) * TransactionQuantity) AS Discount,
		       SUM(SalesAmount) AS Sales, 
		       SUM(SalesTax) AS Tax, 
			   SUM(SalesTotal) AS Total     

		FROM   CustomerRequestLine
		WHERE  RequestNo = '#url.requestNo#'
						
</cfquery>

<cfquery name="getLines"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequestLine
		WHERE  RequestNo = '#url.requestNo#'
</cfquery>

<!--- set the totals --->

<cfoutput>

<script language="JavaScript">

	<cfif getLines.recordcount eq "0">
		document.getElementById('tenderbutton').className = "hide"
	<cfelse>
	    document.getElementById('tenderbutton').className = "regular" 
	</cfif>
	
	<cfif getTotal.discount gte 0>
	    document.getElementById('discountbox').className =  'regular'
		document.getElementById('totaldiscount').innerHTML = '#numberformat(getTotal.Discount,',.__')#'	
	<cfelse>
	    document.getElementById('discountbox').className =  'hide'
	    document.getElementById('totaldiscount').innerHTML = ''	
	</cfif>	
	document.getElementById('totalamount').innerHTML   = '#numberformat(getTotal.Sales,',.__')#'
	document.getElementById('totaltax').innerHTML      = '#numberformat(getTotal.Tax,',.__')#'
	document.getElementById('total').innerHTML         = '#numberformat(getTotal.Total,',.__')#'

</script>

</cfoutput>