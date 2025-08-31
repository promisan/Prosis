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
<cfparam name="Form.Operational"    default="0">
<cfparam name="Form.Description"    default="">
<cfparam name="Form.ListingOrder"   default="">
<cfparam name="Form.Color"          default="white">



<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="appsSystem" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE UserAnnotation
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#',
				 ListingOrder        = '#Form.ListingOrder#',
				 Color               = '#Form.Color#' 
		  WHERE  AnnotationId = '#URL.ID2#'
		   AND   Account = '#SESSION.acc#' 
	</cfquery>
		
	<cfset url.id2 = "">
				
<cfelse>
			
	<cfquery name="Insert" 
	     datasource="appsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO UserAnnotation
	         (Account,
			 ListingOrder,
			 Description,						
			 Color,
			 Operational)
	      VALUES ('#SESSION.acc#',
		      '#Form.ListingOrder#',
			  '#Form.Description#',					
			  '#Form.Color#', 
	      	  '#Form.Operational#')
	</cfquery>
								
		
	<cfset url.id2 = "new">
			   	
</cfif>

<cfoutput>

 <cfinclude template="UserAnnotation.cfm">
  
</cfoutput>

