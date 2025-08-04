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

<cftry>

<cfquery name="Average" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    SUM(I.TransactionQuantityBase) as Total						   
		 FROM      ItemTransaction I
		 WHERE     I.Warehouse        = '#url.warehouse#'
		 AND       I.Location         = '#url.location#'		
		 AND       I.ItemNo           = '#url.itemno#'
		 AND       TransactionUoM     = '#url.UoM#'	
		 AND       I.TransactionType  = '2'		 				
		 AND       TransactionDate > getDate() - #url.period#	
</cfquery>
	
<cfset avg = -1*average.total/url.period>
				
<cfoutput><b>#numberformat(avg,"__,__._")#  
	
	<input type="hidden" 
	       class="regular" 
		   name="distributionaverage" 
		   id="distributionaverage" 
		   size="10"
		   readonly
		   value="#numberformat(avg,'__,__')#" 
		   style="text-align:right">	
		   
 	

<script>

  d = document.getElementById("distributiondays").value     
  ColdFusion.navigate('ItemUoMMinimum.cfm?days='+d+'&quantity=#avg#','minimum')

</script>

</cfoutput>	  

<cfcatch>

n/a

</cfcatch>	   	

</cftry>

