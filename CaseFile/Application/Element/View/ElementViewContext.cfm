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

<cfparam name="url.elementid" default="446645B8-1018-0668-43F7-BFC90C1343F7">

<!--- visual presentation of an element --->

<cf_ActiveSheetScript>

<cfset circleElement= ArrayNew(1)>
	
<cfset elementsList = "'#url.elementid#'">

<cfset position=1>

<cfquery name="Element" datasource="AppsCaseFile">
	SELECT * FROM Element
	WHERE ElementId = '#url.elementid#'
</cfquery>
			
<cfset circleelement[position] = 
          {elementid        = "#Element.ElementId#", 
           elementclass   = "#Element.ElementClass#",
           level = "0" }>  <!--- root element ---->

<cfset position = position + 1 >

<!--- levels of relationship --->
<cfset level = "2" >

<cfloop index="i" from="1" to="#level#">
	
	<cfif listLen(elementsList) gt 0>
	
		<cfquery name = "Related" datasource="AppsCaseFile">
			
			SELECT * FROM ElementRelation
			WHERE ElementId IN (#PreserveSingleQuotes(elementsList)#)
		
		</cfquery>
		
		<cfset elementsList = ''>
		
		<cfloop query="Related">
		
			<cfset elementsList = listAppend(elementsList,"'#ElementIdChild#'")>
			
			<cfquery name="Element" datasource="AppsCaseFile">
				SELECT * FROM Element
				WHERE ElementId = '#ElementIdChild#'
			</cfquery>
			
			<cfset circleelement[position] = 
	              {elementid        = "#Element.ElementId#", 
	               elementclass   = "#Element.ElementClass#",
	               level = "#i#" }>
	
				
			<cfset position = position +1>
			
		</cfloop>
	
	</cfif>
	
</cfloop>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td height="100%">
	
		<cfif ArrayLen(circleelement) gt 1>
		
			<cf_ActiveSheet module="CaseFile" content="#circleelement#" resolution="30">
			
		<cfelse>
			
			<cf_tl id="No context was found for this element." var="1" class="message">

			<cf_message width="100%" last="1" 
			 height="80" 
			 message="#lt_text#" 
			 return="No">
			
		</cfif>
	</td></tr>
	
</table>


