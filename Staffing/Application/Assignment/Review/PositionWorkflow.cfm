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
<cfparam name="url.init" default="0">

<table width="100%">

   <cfquery name="getPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT *
		 FROM  Position		 
		 WHERE PositionNo = '#URL.ajaxid#'	 
	</cfquery>
		
	<cf_wfactive entityCode="PositionReview" ObjectKeyValue1="#url.ajaxid#">
	
	<cfif wfstatus neq "closed">
		<cfset cl = "regular">
	<cfelse>
		<cfset cl = "hide">
	</cfif>	
	
	<cfoutput>
	
	<tr><td class="#cl# linedotted"></td></tr>
	<tr><td id="myrevertbox" class="#cl#" align="left" style="padding:5px;">
		<input style="border-radius:5px;height:25px;width:200;padding-left:4px" 
		  type="button" name="Revert" value="Revert assessment" class="button10g" onclick="revert('#url.ajaxid#')">
	</td></tr>
	
	</cfoutput>	
	
	<tr><td>		
	
	<cfset link = "Staffing/Application/Assignment/Review/AssignmentView.cfm?id1=#url.ajaxid#">			
	
	<cf_ActionListing 
	    EntityCode       = "PositionReview"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		tablewidth       = "100%"
		Mission          = "#getPosition.mission#"	
		OrgUnit          = "#getPosition.OrgUnitOperational#"
		ObjectReference  = "Incumbency review"
		ObjectReference2 = "#getPosition.PostGrade#" 	
	    ObjectKey1       = "#url.ajaxid#"	
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Show             = "Yes"
		HideCurrent      = "No">
		
	</td></tr>
	
</table> 	

<cfif url.init eq "0">

<cfparam name="url.box" default="">

<cfoutput>
	<script>	
		<cfif url.box neq "">			
		    opener.document.getElementById("refresh_#url.box#").click()	
		</cfif>		
	</script>
</cfoutput>

</cfif>

<!--- <cfset ajaxonload("docheck")> --->




	
