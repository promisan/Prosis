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
<cfoutput>

<cfparam name="url.unitclass"   default="">
<cfparam name="url.costid"      default="">
<cfparam name="url.quantity"    default="1">

<cfif url.costid eq "">
	
	<script language="JavaScript">				 
	    toggle('#UnitClass#',false)				
	</script>	
		
<cfelse>
	
	<cfquery name="Get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ServiceItemUnitMission
		WHERE    CostId = '#url.costid#'		
	</cfquery>
	
	<cfquery name="Unit" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     #CLIENT.lanPrefix#ServiceItemUnit
		WHERE    ServiceItem = '#get.ServiceItem#'		
		AND      Unit        = '#get.ServiceItemUnit#'
	</cfquery>			
			
	<script language="JavaScript">	
	  	
		toggle('#UnitClass#',true)		
				
		document.getElementById('#UnitClass#_frequency').innerHTML             = "#get.Frequency#"		
		document.getElementById('#UnitClass#_unitquantity_0').value            = "#url.quantity#"					
		document.getElementById('#UnitClass#_currency').innerHTML              = "#get.currency#"		
		document.getElementById('#UnitClass#_stdprice').innerHTML              = "#numberformat(get.standardcost,',.__')#"		
		document.getElementById('#UnitClass#_standardcost_0').value            = "#numberformat(get.standardcost,',.__')#"			
		document.getElementById('#UnitClass#_specification_content').innerHTML = "#unit.UnitSpecification#"			
		document.getElementById('total_#UnitClass#_0').innerHTML               = "#numberformat('#url.quantity*get.standardcost#',',.__')#"
				
		<cfif get.EnableEditRate eq "1">				  
			document.getElementById('#UnitClass#_standardcost_0').readOnly = false					
		<cfelse>
		    document.getElementById('#UnitClass#_standardcost_0').readOnly = true						
		</cfif>
				
		<cfif get.EnableEditQuantity eq "1">	
			document.getElementById('#UnitClass#_quantity_box').className = "regular"		
		<cfelse>
		    document.getElementById('#UnitClass#_quantity_box').className = "hide"	
		</cfif>					
					
	</script>		
	
</cfif>	

</cfoutput>

