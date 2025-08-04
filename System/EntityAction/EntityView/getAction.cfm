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

<!--- check action --->

<cftry>

<cfparam name="url.scope" default="backoffice">
<cfparam name="url.object" default="">

<cfinvoke component = "Service.PendingAction.Check"
    Method           = "PendingAction"  
   	scope            = "#url.scope#"
   	returnvariable   = "getaction">
	
<cfoutput>

	<cfif url.scope eq "portal">	
		
		<cfif getAction.workflow gte "1">
		    <script>			  
			   document.getElementById('#url.object#').className = "regular"
			</script>
		<cfelse>
		     <script>			   
			   document.getElementById('#url.object#').className = "hide"
			</script> 
		</cfif>		
		
	<cfelse>			
	
		<!--- <span style="line-height: 400px; border-radius: 50%; font-size: 16px; padding:6px; color: ffffff; font-weight:bold; text-align: center; background: 000000"> --->
		#getAction.workflow#
		<!--- </span> --->
		
	</cfif>	
	
</cfoutput>		

<cfcatch></cfcatch>

</cftry>

