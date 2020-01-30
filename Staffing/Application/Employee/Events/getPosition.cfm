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