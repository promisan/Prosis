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
<cfoutput>

<cfif url.reviewid eq "undefined">
	  
	  <script>
	  document.getElementById("line#url.templateid#").style.backgroundColor = "yellow"
	  </script>
	  	
	  <cfabort>
</cfif>

<cfquery name="Check" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   SiteVersionReview
	   WHERE  ReviewId = '#url.reviewid#'
</cfquery>	

<!--- determine of this template may be deployed --->

<cfif check.actionStatus eq "3">
  	  <script>	  
	  document.getElementById("line#url.templateid#").style.backgroundColor = "##C9F5D2"
	  </script>
<cfelseif check.actionStatus eq "2">	  
	  <script>	 
	  document.getElementById("line#url.templateid#").style.backgroundColor = "yellow"
	  </script>
<cfelseif check.actionStatus eq "1">	  
	  <script>	 
	  document.getElementById("line#url.templateid#").style.backgroundColor = "yellow"
	  </script>
<cfelseif check.actionStatus eq "0">	  
	  <script>	  
	  document.getElementById("line#url.templateid#").style.backgroundColor = "white"
	  </script>	 
</cfif>	

<cfif Check.actionStatus eq "3">

 <img onclick="deployclient('#url.templateId#','#url.TemplateCompareId#','#Check.destinationserver#','#check.reviewid#')" 
         src="#SESSION.root#/Images/refresh4.gif" 
		 alt="Deploy template on #check.destinationserver# with master copy." 
		 border="0" 
		 align="absmiddle" 
		 style="cursor: pointer;">&nbsp;	
		 							 
	<a href="javascript:deployclient('#url.templateId#','#url.TemplateCompareId#','#Check.destinationserver#','#check.reviewid#')" 
	     title="Deploy template on #check.destinationserver# with master copy.">Deploy</a>

</cfif>

</cfoutput>
							