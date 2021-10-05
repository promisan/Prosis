
<!--- show the review cycles based on the selected mission and period --->

<cfparam name="url.mission" default="">
<cfparam name="url.period"  default="">

<!--- show review cycles to select --->

<cfquery name="Review" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   Ref_ReviewCycle
	  WHERE  Mission = '#url.mission#'
	  AND    Period  = '#url.period#'
	  AND    DateEffective < getDate()
	  AND    Operational = 1
	  ORDER BY DateEffective, DateExpiration		  
</cfquery>

<cfoutput>
	
	<cfif Review.recordcount eq "0">
	
		<input type="hidden" name="CycleId" id="CycleId" value="">
			
	<cfelse>
	
	 <table cellspacing="0" cellpadding="0">
	 <tr>
	 <td valign="top"><img src="#client.root#/images/join.gif" alt="" border="0"></td>
	 <td style="padding:3px" class="labelmedium">
	
	 <select style="width:190px;" class="regularxl" name="CycleId" id="CycleId" onChange="refreshListing()">
			 <option value="" selected><cf_tl id="Any Review Cycle"></option>
			 <cfloop query="Review">
				 <option value="#CycleId#">#Description#</option>		 
	    	 </cfloop>
	 </select>
	 
	 </td>
	 </tr>
	 </table>
	 
	 </cfif>
	 	
 </cfoutput>
