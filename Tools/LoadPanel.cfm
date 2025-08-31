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
<cfparam name="attributes.id"        default="left">
<cfparam name="attributes.var"       default="prg">
<cfparam name="attributes.template"  default="">
<cfparam name="attributes.condition" default="">

<cfoutput>

<script language="JavaScript1.2">

     #attributes.var# = setInterval('loadpanelcontent()', 1200) 		
	
   	 function loadpanelcontent() {		
	 	   
	    <cfif attributes.condition neq "">	   		
	 		window.#attributes.id#.open = "#attributes.template#?#attributes.condition#"			 		
		<cfelse>
			window.#attributes.id#.location = "#attributes.template#"		
		</cfif>
		
		clearInterval ( #attributes.var# )				
   	 }			 

</script>
				 
</cfoutput>				 