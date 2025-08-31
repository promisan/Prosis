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
<cfset pointerinsert = "0">

<!--- save this info --->

<cfquery name="Color" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     UserAnnotation
	 WHERE    Account = '#SESSION.acc#'	
	 AND      Operational = 1
	 ORDER BY ListingOrder
</cfquery>

<cftransaction>		

<cfquery name="Clean" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE FROM  UserAnnotationRecord 
	 WHERE Account      = '#SESSION.acc#'
	 AND   EntityCode   = '#url.entity#'
	 <cfif key1 neq "">
	 AND   ObjectKeyValue1 = '#key1#'	
	 </cfif>
	 <cfif key2 neq "">
	 AND   ObjectKeyValue2 = '#key2#'	
	 </cfif>
	 <cfif key3 neq "">
	 AND   ObjectKeyValue3 = '#key3#'	
	 </cfif>
	 <cfif key4 neq "">
	 AND   ObjectKeyValue4 = '#key4#'	
	 </cfif>		 		
</cfquery>

<cfloop index="itm" list="Personal,Shared">

	<cfloop query = "Color">
	
	    <cfparam name="form.an#currentrow#_#itm#" default="0">
		<cfparam name="form.memo#currentrow#_#itm#" default="">
	
		<cfset sel = evaluate("Form.an#currentrow#_#itm#")>
		<cfset mem = evaluate("form.memo#currentrow#_#itm#")>
		
		<cfif sel eq "1">
		
			<cfset pointerinsert = "1">
			
			<cfquery name="Insert" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO UserAnnotationRecord
						 (Account, 
						  AnnotationId, 
						  EntityCode, 
						  <cfif url.key1 neq ""> ObjectKeyValue1, </cfif>
						  <cfif url.key2 neq ""> ObjectKeyValue2, </cfif>
						  <cfif url.key3 neq ""> ObjectKeyValue3, </cfif>
						  <cfif url.key4 neq ""> ObjectKeyValue4, </cfif>
						  Annotation,
						  Scope,
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName)
						 VALUES
						 ('#SESSION.acc#',
						  '#annotationid#',
						  '#url.entity#',
						  <cfif url.key1 neq ""> '#url.key1#', </cfif>
						  <cfif url.key2 neq ""> '#url.key2#', </cfif>
						  <cfif url.key3 neq ""> '#url.key3#', </cfif>
						  <cfif url.key4 neq ""> '#url.key4#', </cfif>
						  '#mem#',
						  '#itm#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')					 
			</cfquery>
			
		</cfif>	
				
	</cfloop>

</cfloop>

</cftransaction>

<cfoutput>
<script>
   
    parent.document.getElementById('annotation#url.box#').click()	
	parent.ProsisUI.closeWindow('annotationwindow')
	
</script>
</cfoutput>
	
	
		