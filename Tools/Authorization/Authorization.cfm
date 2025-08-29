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
<cfparam name="Attributes.mission"            default="">
<cfparam name="Attributes.systemfunctionid"   default="">
<cfparam name="Attributes.functionname"       default="">
<cfparam name="Attributes.object"             default="">
<cfparam name="Attributes.objectclass"        default="input">

<cfif attributes.systemfunctionid eq "">

       <cfquery name="get" 
			datasource="AppsSystem" 
		    username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	          SELECT    * 
			  FROM      Ref_ModuleControl
	          WHERE     FunctionName = '#attributes.functionName#'		  
		</cfquery>  
		
		<cfset systemfunctionid = get.SystemFunctionid>
		
<cfelse>

        <cfset systemfunctionid = Attributes.systemfunctionid>			

</cfif>

<cfoutput>

<input type="button" 
	   name="Authorization" 
	   value="A" 
	   title="Overwrite"
	   class="button10g" 
	   style="width:27px;height:28px;border:0px" 
       onclick="openauthorization('#attributes.mission#','#systemfunctionid#','#attributes.object#','#attributes.objectclass#')">
	   
</cfoutput>	   

<!--- dialog which has module and mission as reference --->
