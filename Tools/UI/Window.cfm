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
<!---- after the script ProsisUI.windowCreate I am not sure if this tag should be
indeed needed 
8/5/2013
by dev
---->


<cfparam name="attributes.name" 	default = "window"> 
<cfparam name="attributes.width" 	default = "300"> 
<cfparam name="attributes.height" 	default = "300"> 
<cfparam name="attributes.actions" 	default = "'Refresh','Pin','Minimize','Maximize','Close'">
<cfparam name="attributes.initShow" default = "false">
<cfparam name="attributes.title"	default = "">
<cfparam name="attributes.source"	default = "">


<cfoutput>
<cfif thisTag.ExecutionMode is 'start'>
    <div id="#attributes.name#" <cfif attributes.initShow eq "false">style="display:none"</cfif>> 

<cfelse>

	</div>

     <script>
         $(document).ready(function() {
               var window = $("###attributes.name#").kendoWindow({
                   width: "#attributes.width#",
                   height: "#attributes.height#",
                   title: "#attributes.title#",
                   actions: [#attributes.actions#],
                   visible: #attributes.initShow#
				   <cfif attributes.source neq "">
				   	  ,content: "#attributes.source#"
				   </cfif>
				   
               });
			   
			   <cfif attributes.initShow eq "true">
			   		window.data("kendoWindow").open();
			   </cfif>

         });
     </script>	

	
	
	
</cfif>

</cfoutput>
