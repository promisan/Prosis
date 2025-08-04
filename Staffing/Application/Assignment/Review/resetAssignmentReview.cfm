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

<!--- remove workflow object, close screen and refresh the line --->

<cfquery name="get"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * FROM OrganizationObject
	WHERE  ObjectKeyValue1 = '#url.positionno#'
	AND    Operational = 1
	AND    EntityCode = 'PositionReview'	
</cfquery>

<cfquery name="reset"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM OrganizationObject
	WHERE  ObjectKeyValue1 = '#url.positionno#'
	AND    Operational = 1
	AND    EntityCode = 'PositionReview'	
</cfquery>

<cfoutput>
	<script>
	    parent.document.getElementById("refresh_#url.box#").click()	
		parent.ColdFusion.Window.destroy('mystaff',true)	
	</script>

</cfoutput>

