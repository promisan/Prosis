
<cfparam name="url.cycleclass" default="Inception">

<cfquery name="Group" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT ProgramGroup 
      FROM   ProgramGroup 
	  WHERE  ProgramCode = '#URL.ProgramCode#'
</cfquery>	  

<cfquery name="Review" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
      SELECT *, (SELECT TOP 1 ActionStatus 
	             FROM   ProgramPeriodReview 
				 WHERE  ProgramCode = '#URL.ProgramCode#'
				 AND    Period      = '#URL.Period#'
				 AND    ReviewCycleId = R.CycleId
				 ORDER BY Created DESC) as ActionStatus
	  FROM   Ref_ReviewCycle R
	  WHERE  Mission     = '#url.mission#'
	  AND    Period      = '#url.period#'
	  AND    Operational = 1
	  AND    DateEffective < getDate()
	  AND    CycleClass = '#url.cycleclass#'
	  
	  <cfif group.recordcount gte "1">	  
	 	 
	  AND    CycleId IN (SELECT CycleId 
	                     FROM   Ref_ReviewCycleGroup 
						 WHERE  ProgramGroup IN (SELECT ProgramGroup 
						                         FROM   ProgramGroup 
												 WHERE  ProgramCode = '#URL.ProgramCode#'))
	  </cfif>											 
	  ORDER BY DateEffective 	  
	  
	</cfquery>
	

<table width="95%" class="navigation_table">
 <cfoutput query="review">
 <cfif enablemultiple eq "1">
 	<cfset cl = "e9e9e9">
 <cfelse>
 	<cfset cl = "transparent">		
 </cfif>
 <tr bgcolor="#cl#" class="navigation_row linedotted" onclick="reviewcycle('#url.programcode#','#url.period#','#cycleid#')">  
	 <td style="padding-left:3px"><img src="#client.root#/images/workflow1.png" height="26" width="32" alt="" border="0"></td>
	 <td style="padding-left:2px;font-size:14px" class="labelit">
	 <cfif CycleName neq "">#CycleName#<cfelse>#Description#</cfif></td>
	 <cfif ActionStatus eq "3">
	 <td style="padding-left:6px"><img src="#client.root#/images/check_icon.gif" alt="" border="0"></td>
	 <cfelseif ActionStatus lte "3">
	 <td style="padding-left:6px"><img src="#client.root#/images/pending.gif" alt="" border="0"></td>
	 </cfif>
 </tr>
 </cfoutput> 
</table>

<cfset ajaxonload("doHighlight")>

<cfparam name="url._cf_containerId" default="">

<!--- added by hanno to load the review screen upon changing of the period in the interface 
and do not do this upon initial opening without ajax --->

<cfif url._cf_containerid neq "">
	
	<cfoutput>
	<cfif review.recordcount gte "1">
		<script>
			reviewcycle('#url.programcode#','#url.period#','#review.cycleid#')
		</script>	  	
	</cfif>
	</cfoutput>

</cfif>