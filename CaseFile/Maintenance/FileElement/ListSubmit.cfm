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
<cfparam name="Form.Code"                default="">
<cfparam name="Form.element"             default="">

 <cfquery name="Update" 
	  datasource="AppsCaseFile" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  UPDATE Ref_TopicElementClass
	  SET    ListingOrder         = '#FORM.ListingOrder#',
	  		 PresentationMode	  = '#FORM.PresentationMode#',
			 ElementSection		  = '#Form.ElementSection#'
	  WHERE  Code                = '#URL.Code#'		 	   
	  AND    ElementClass          = '#URL.element#' 
</cfquery>
	
<cfset url.code = "">
				
		
			   	
<cfoutput>
  <script>
   <!---  ColdFusion.navigate('RecordListingDelete.cfm?Code=#URL.ClaimType#','del_#url.claimtype#')	 --->
    ColdFusion.navigate('List.cfm?element=#URL.element#&code=#url.code#','#url.element#_list')	
  </script>	
</cfoutput>


