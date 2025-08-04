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

<cfparam name="Form.Operational"    default="0">
<cfparam name="Form.ListCode"       default="">
<cfparam name="Form.ListValue"      default="">
<cfparam name="Form.ListOrder"      default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_ScaleDetail
		  SET    CumDepreciation   = '#Form.CumDepreciation/100#'
		  WHERE  AgeYear = '#URL.ID2#'
		   AND   Code = '#URL.Code#' 
	</cfquery>
	
	<cfset url.id2 = "">
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
				
<cfelse>
			
		<cfquery name="Exist" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT    *
			FROM     Ref_ScaleDetail
			WHERE    AgeYear = '#Form.AgeYear#'
		      AND    Code = '#URL.Code#' 
		</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
		<cfquery name="Insert" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		    	 INSERT INTO Ref_ScaleDetail
		         (Code,AgeYear,CumDepreciation)
		     	 VALUES ('#URL.Code#','#Form.AgeYear#','#Form.CumDepreciation/100#')
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Insert" 
						 content="#Form#">
			
	<cfelse>
			
		<script>
			<cfoutput>
				alert("Sorry, but #Form.ListValue# already exists")
			</cfoutput>
		</script>
				
	</cfif>	
	
	<cfif Form.CumDepreciation lt "100">
	
		<cfset url.id2 = "new">
	
	</cfif>	
		   	
</cfif>

<cfoutput>
  <script>
	#ajaxlink('List.cfm?idmenu=#url.idmenu#&code=#url.code#&id2=#url.id2#')#
  </script>	
</cfoutput>

