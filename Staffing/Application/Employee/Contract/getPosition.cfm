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
					$('##PositionNo').val('');
					$('##Position').val('');
				} catch(e) {}
		</script>
		
<cfelse>
		
		<cfquery name="Position" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
			    FROM    Position
				WHERE   PositionNo = '#URL.PositionNo#' 
		</cfquery>	 
		
		<cfif Position.SourcePostNumber eq "">
		
			<script>
			    try {
					$('##PositionNo').val('#Position.PositionNo#');
				 	$('##Position').val('#trim(Position.PositionParentId)# - #trim(Position.PostType)# (#trim(Position.PostGrade)#)'); 
					$('##ContractFunctionNo').val('#Position.functionno#');
					$('##ContractFunctionDescription').val('#Position.FunctionDescription#');
						
				} catch(e) {}
							
			</script>
		
		<cfelse>
		
			<script>
			
			    try {
					$('##PositionNo').val('#Position.PositionNo#');
				 	$('##Position').val('#trim(Position.SourcePostNumber)# - #trim(Position.PostType)# (#trim(Position.PostGrade)#)'); 
					$('##ContractFunctionNo').val('#Position.functionno#');
					$('##ContractFunctionDescription').val('#Position.FunctionDescription#');
						
				} catch(e) {}
							
			</script>		
		
		</cfif>
	
</cfif>	

<script>
	ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Contract/getAssignment.cfm?positionno=#url.positionno#&dateeffective='+document.getElementById('DateEffective').value+'&dateexpiration='+document.getElementById('DateExpiration').value,'assignmentbox')
</script>

</cfoutput>