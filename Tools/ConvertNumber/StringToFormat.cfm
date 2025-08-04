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

<cfparam name="Attributes.Value"   Default="">
<cfparam name="Attributes.Format"  Default="">
<cfparam name="Attributes.Prefix"  Default="">

<cfset format = attributes.format>
<cfset myval  = attributes.Value>

<cfif format eq "">

  <cfset myval = "#attributes.Value#">  
  
<cfelse>
			
	<cfloop index="pos" from="1" to="#len(format)#">
			
	<cfset char = mid(format,  pos,  1)>
	
	<cfif char eq "X">
	
	 <!--- do nothing --->
	
	<cfelse>
	
		<cfif len(myval) gte pos>
	
		<cfset myval = insert(char, myval, pos-1)> 
		
		</cfif>
	
	</cfif>
	
	</cfloop>
 	
</cfif>	

<cfset caller.val = "#attributes.prefix##myval#">

 