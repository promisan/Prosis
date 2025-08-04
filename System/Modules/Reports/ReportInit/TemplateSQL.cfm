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

<!--- ----------- Prosis Template SQL.cfm     ------------------- --->
<!---

---------------------------------------------------------------------
How to declare a query
---------------------------------------------------------------------

---------------------------------------------------------------------
How to show progress 
---------------------------------------------------------------------

<cf_Wait text      = "Retrieving Report Data step 1 of 9"
	flush     = "yes" controlid = "#URL.controlid#">

---------------------------------------------------------------------	
How to trigger a condition
---------------------------------------------------------------------

<cfif CheckResult.recordcount gte "10000">

   <cfif URL.Mode eq "Form" or URL.Mode eq "Link" >
	  	<cf_message message = "You selected too many records." 
		return = "no">
   </cfif>
   <cfset status = "0">
   <cfexit method="EXITTEMPLATE">
      
</cfif>   	

--->
<!--- ----------------------------------------------------------- --->

<!--- ----------- SECTION : query definition  ------------------- --->
<!--- use this section to run one or more queries that result in  --->
<!--- one or more table that will be passed to the report         ---> 
<!--- ----------------------------------------------------------- --->







<!--- ----------- SECTION : condition definition  --------------- --->
<!--- use this section to define one or more condition ---------- --->
<!--- if the condition is not met assign a value status = 0  ---- --->
<!--- ----------------------------------------------------------- --->

<cfinclude template="Event.cfm">

<cfif condition eq "9">
	<cf_message message = "Attention: ......" return = "no">
	<cfset status = "0">
	<cfexit method="EXITTEMPLATE">
</cfif>


<!--- -----------------   END OF TEMPLATE    -------------------- --->