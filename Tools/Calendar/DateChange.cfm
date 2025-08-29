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
<cfparam name="url.key1"             default="">
<cfparam name="url.key2"             default="">
<cfparam name="url.name"             default="transaction_date">
<cfparam name="url.value"            default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="url.increment"        default="0">
<cfparam name="url.function"         default="">
<cfparam name="url.future"           default="No">
<cfparam name="url.datevalidstart"   default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.value#">
<cfset dte = dateValue>

<cfset dte = dateAdd("d",url.increment,dte)>
<cfoutput>				
	<!--- set value --->
	<script>			
	  document.getElementById("#url.name#_date").value = "#dateformat(dte,client.dateformatshow)#";   
	</script>
		
	<CF_DateConvert Value="#url.datevalidstart#">
	<cfset start = dateValue>
	
	<!--- control the prior button --->	 
	<cfif start lt dte>			
		<script>		   
		   document.getElementById("#url.name#_date_dateprior_tr").className = "regular";
		</script>	
	<cfelse>		
		<script>
		   document.getElementById("#url.name#_date_dateprior_tr").className = "hide";
		</script>		
	</cfif>
	
	<!--- control the next button --->	
	<cfif dateDiff("d",now(),dte) eq "0" and url.future eq "No">	
		<!--- set value --->
		<script>
		   document.getElementById("#url.name#_date_datenext_tr").className = "hide";
		</script>		
	<cfelse>	
		<!--- set value --->
		<script>
		   document.getElementById("#url.name#_date_datenext_tr").className = "regular";
		</script>			
	</cfif>	
	
	<!--- run the function --->	
	<cfif url.function neq "">
		<script>	
		
		    try {
		      #url.function#('#dateformat(dte,client.dateformatshow)#',document.getElementById('#url.name#_hour').value,document.getElementById('#url.name#_minute').value,'#url.key1#','#url.key2#');
		    } catch(e) {
		      #url.function#('#dateformat(dte,client.dateformatshow)#','#url.key1#','#url.key2#');
		    }
		
		</script>
	</cfif>
		
</cfoutput>

