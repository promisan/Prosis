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