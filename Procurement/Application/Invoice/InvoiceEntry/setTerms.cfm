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

<cfquery name="Terms" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Ref_Terms 
	WHERE Code = '#url.id#'
</cfquery>

<cfif terms.recordcount eq "1">
	
	<cfoutput query="Terms">
		<input type="hidden"   name="actiondays"         id="actiondays"          value="#terms.PaymentDays#">	
		<input type="hidden"   name="actiondiscount"     id="actiondiscount"      value="#terms.Discount#">	
		<input type="hidden"   name="actiondiscountdays" id="actiondiscountdays"  value="#terms.DiscountDays#">	
	</cfoutput>
		
	<cftry>
	
		<CF_DateConvert Value="#url.date#">
	
		<cfset due = dateAdd("d",  terms.PaymentDays, datevalue)>
		<cfset dis = dateAdd("d",  terms.DiscountDays, datevalue)>
		
		<cfoutput>
	
			<script>
			    document.getElementById('discount').className = "regular"
			 	document.getElementById('actiondiscountdate').value = "#dateformat(dis,client.dateformatshow)#"				
				document.getElementById('actionbefore').value   = "#dateformat(due,client.dateformatshow)#"
			</script>
		
		</cfoutput>
		
		<cfcatch></cfcatch>
		
	</cftry>
	
	<cfif terms.discount eq "0">
	
		<script>
			document.getElementById('discount').className = "hide"
	    </script>
	
	</cfif>
	
<cfelse>

	<script>
		document.getElementById('discount').className = "hide"
    </script>	
	
</cfif>

