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

<cfparam name="Attributes.Amount" Default="0">
<cfparam name="Attributes.Present" Default="1">
<cfparam name="Attributes.Format" Default="Number">

<cfif attributes.amount eq "">

  <cfset myval = 0>  
  
<cfelse>
 
    <cfset myval = Attributes.amount>
	
	<cfset myval = ceiling(myval)>
	<!--- expression --->
	<cfset myval = myval/attributes.present>
	
	<!--- format --->
	<cfswitch expression="#Attributes.format#">
	 <cfcase value="Number">
	   <cfset myval = "#numberformat(myval,",__")#.00">
	   <!---
	   <cfset val = "#numberformat(val,"__,__.__")#">
	   --->
	 </cfcase>
	 <cfcase value="Number1">	 
	   <cfset myval = "#numberformat(myval,",__._")#">
	 </cfcase>
	 <cfcase value="Number0">	
	   <cfset myval = "#numberformat(myval,",__")#">
	 </cfcase>
	</cfswitch>
	
</cfif>	

<cfset caller.val = myval>

 