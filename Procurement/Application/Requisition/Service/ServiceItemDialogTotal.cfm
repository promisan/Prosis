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

<!--- total --->


<cftry>

	<cfset tot = "#url.sqty*url.qty*url.rate#">
	
	<cfoutput>
		  
	  		<input type="Text"
			   name="svctotal"
			   style="text-align: right;" 
		       value="#numberformat(tot,'__,__.__')#"	
			   readonly		       
			   style="width:80"
			   maxlength="10"
			   class="regularxl">

	</cfoutput>	

	<cfcatch>n/a</cfcatch>

</cftry>