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
<cfparam name="url.mission"    default="">
<cfparam name="url.positionNo" default="">

<cfoutput>

<cfif url.positionNo eq "">

	    <script>
				try {
					$('##positionNo').val('');
					$('##positionselect').val('');
				} catch(e) {}
		</script>
		
<cfelse>
		
		<cfquery name="qPosition" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
			    FROM    Position
				WHERE   PositionNo = '#URL.PositionNo#' 
		</cfquery>	 
						
		<script>
		    try {
			$('##positionNo').val('#qPosition.PositionNo#');
		 	$('##positionselect').val('#trim(qPosition.SourcePostNumber)# - #trim(qPosition.FunctionDescription)# (#trim(qPosition.PostGrade)#)'); } catch(e) {}
		</script>
	
</cfif>	

<script>

	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Events/getAssignment.cfm?positionno=#url.positionno#','assignmentbox')

</script>

</cfoutput>