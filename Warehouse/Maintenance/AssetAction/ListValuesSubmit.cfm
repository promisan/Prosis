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
<cfparam name="Form.ListCode"       default="">
<cfparam name="Form.ListValue"      default="">
<cfparam name="Form.ListOrder"      default="">
<cfparam name="Form.ListDefault"    default="0">

<cf_tl id = "already exists" var = "vAlready">
<cf_tl id = "Sorry, but" var = "vSorry">


<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  UPDATE Ref_AssetActionList
			  SET    Operational         = '#Form.Operational#',
	 		         ListValue           = '#Form.ListValue#',
					 ListOrder           = '#Form.ListOrder#',
					 ListDefault         = '#Form.ListDefault#'
			  WHERE  ListCode = '#URL.ID2#'
			  AND   Code = '#URL.Code#' 
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
	
	<cfif Form.ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  UPDATE Ref_AssetActionList
				  SET    ListDefault = 0
				  WHERE  ListCode <> '#URL.ID2#'
				  AND   Code = '#URL.Code#' 
		</cfquery>
	
	</cfif>
		
	<cfset url.id2 = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    	SELECT *
			FROM   Ref_AssetActionList
		  	WHERE  ListCode = '#Form.ListCode#'
		   	AND    Code = '#URL.Code#' 
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     	INSERT INTO Ref_AssetActionList
			         (Code,
					 ListCode,
					 ListValue,
					 ListOrder,
					 Operational)
			      	VALUES ('#URL.Code#',
				      '#Form.ListCode#',
					  '#Form.ListValue#',
					  '#Form.ListOrder#',
			      	  '#Form.Operational#')
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Insert" 
						 content="#Form#">
			
	<cfelse>
			
		<script>
		<cfoutput>
			alert("#vSorry# #Form.ListValue# #vAlready#")
		</cfoutput>
		</script>
				
	</cfif>		
	
	<cfif Form.ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_AssetActionList
			  SET    ListDefault = 0
			  WHERE  ListCode <> '#Form.ListCode#'
			   AND   Code = '#URL.Code#' 
		</cfquery>
	
	</cfif>
	
	<cfset url.id2 = "new">
		   	
</cfif>

<cfoutput>
  <script>
	#ajaxlink('ListValuesListing.cfm?idmenu=#url.idmenu#&code=#url.code#&id2=#url.id2#')#
  </script>	
</cfoutput>

