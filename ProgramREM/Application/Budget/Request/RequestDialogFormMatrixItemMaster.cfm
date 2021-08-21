
<cfquery name="List" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ItemMasterList
		WHERE     ItemMaster = '#url.itemmaster#'
		AND       Operational = 1 
		ORDER BY  ListOrder
</cfquery>

<cfif list.recordcount eq "0">
	
	<tr class="labelmedium"><td colspan="<cfoutput>#dates.recordcount+4#</cfoutput>" align="center" height="30" ><font color="gray">No items defined. Please contact administrator</font></td></tr>
	
	
<cfelse>	
	
	<cfoutput query="list">
			
		<cfquery name="Dates" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    A.*, 0 as requestQuantity
				FROM      Ref_Audit A
				WHERE     A.Period = '#url.period#'	
				#preserveSingleQuotes(filterdates)#		  
				ORDER BY  DateYear, AuditDate 
		</cfquery>	
	
	    <cfif Request.recordcount eq "1">
	
			<cfquery name="Requirement" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      ProgramAllotmentRequest
				WHERE     ProgramCode         = '#Request.ProgramCode#'		  
				AND       Period              = '#Request.Period#'
				AND       EditionId           = '#Request.EditionId#'
				AND       RequirementIdParent = '#Request.RequirementIdParent#'		
				AND       TopicValueCode      = '#TopicValueCode#'		
				AND       RequestType         = 'Standard' <!--- do not show rippled transaction --->
			</cfquery>					
	
			<cfif Requirement.recordcount eq "1">	
				
					<cfquery name="Dates" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    A.*, P.RequestQuantity
						FROM      Ref_Audit A LEFT OUTER JOIN ProgramAllotmentRequestQuantity P ON A.AuditId = P.AuditId 
						     AND  P.RequirementId  = '#Requirement.requirementid#'
						WHERE     A.Period = '#url.period#'		
						          #preserveSingleQuotes(filterdates)#	  
						ORDER BY  DateYear, AuditDate 
					</cfquery>	
								
			</cfif>
				 
		 </cfif>	
	
		 <cfset row = currentrow>
		 
		 <tr class="navigation_row">
		 <td class="labelit" style="min-width:200px;border-top:1px solid silver;border-left:0px dotted silver;padding-left:10px">#topicvalue#</td>
		 	  
		  <cfset total = 0>
		  <cfset col   = 0>
		  <cfset rate = list.listamount>
		  
		  <cfloop query="dates">
		  
		   <cfset col = col+1>
		   <cfif col eq "1">
		   <td bgcolor="white" style="border-top:1px solid silver;border-left:1px solid silver">
		   <cfelse>
		    <td bgcolor="white" style="border-top:1px solid silver;border-left:1px solid silver">
		   </cfif>
		  
		   <cfif RequestQuantity neq "">	  		  
			   <cfset total = total+requestQuantity>
		   </cfif>
		  
		   <input type = "text"
		      onchange = "ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#row#&col=#col#&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal')" 
			  style    = "padding-top:2px;width:100%;text-align:center" 
			  name     = "c#row#_#col#"
			  id       = "c#row#_#col#"
			  value    = "<cfif requestQuantity neq "0">#RequestQuantity#</cfif>"
			  class    = "button3 enterastab">
			  
		   </td>
		   
		   <cfif currentrow eq "1">
		
			 <td align="center" bgcolor="f4f4f4" style="cursor:pointer;padding-right:1px;border-top:1px solid silver;border-left:1px solid silver"
		   		onclick="ptoken.navigate('RequestDialogFormMatrixCopy.cfm?row=#row#&col=1&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal')">
				 <img src="#SESSION.root#/images/copy.png" height="12" width="12" alt="" border="0">
			 </td>
			 
		   </cfif>
		   
		  </cfloop>
		  
		  <!--- --------- --->
		  <!--- row total --->
		  <!--- --------- --->
		  
		  <td bgcolor="ffffcf" align="right" style="padding-right:2px;border-top:1px solid silver;border-left:1px solid silver">
		     <input type= "input" 
			    class   = "button3" 
			 	readonly 
				style   = "padding-top:2px;text-align:right;padding-right:2px;;width:100%"
				name    = "requestQuantity_#row#" 
				id      = "requestQuantity_#row#" 
				value   = "#numberformat(total,'__,__')#"> 	 
		  
		  </td>
		  <td bgcolor="ffffff" align="center" style="padding-top:3px;padding-left:4px;border-top:1px solid silver;border-left:1px solid silver">
		  		  
		  <!--- only visible for budgetmanager --->
		  
		  <cfparam name="Requirement.requirementid" default="#URL.RequirementId#">
		  
		  <cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL">
		 			  		   
		   	   <cf_img icon="expand" toggle="yes" 
				   onclick="_cf_loadingtexthtml='';parent.getrate('#row#','#url.programcode#','#url.itemmaster#','#topicvaluecode#','','#Requirement.requirementid#','#url.objectCode#','#url.location#','#url.period#')">			 			 						
				   
		  </cfif>		   
			   
		  </td>
		  
		  <td style="padding-right:2px;border-top:1px solid silver;border-left:1px solid silver;border-right:2px solid silver">			 
		   			  			   
		    <cfif Request.recordcount eq "1" and Requirement.recordcount eq "1">	
		  
		     <input type   = "input" 
				  onchange = "ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#row#&col=0&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal')"		
				  class    = "regularh" 
				  style    = "border:0px;padding-top:2px;text-align:right;padding-right:2px;width:99%" 
				  id       = "requestPrice_#row#" 
				  name     = "requestPrice_#row#" 
				  value    = "#numberformat(requirement.requestprice,'__,__')#">  
				 
				  				  
		    <cfelse>
			
				<cfquery name="GetPeriod" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Ref_Period
					WHERE  Period = '#URL.Period#'
				</cfquery>
	
				<cfquery name="StandardCost" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT IC.* 
					FROM   ItemMasterStandardCost IC INNER JOIN 
					       ItemMasterList L ON IC.TopicValueCode = L.TopicValueCode AND IC.ItemMaster = L.ItemMaster
						   
					WHERE  IC.ItemMaster		= '#URL.ItemMaster#' 
					AND    IC.TopicValueCode	= '#TopicValueCode#' 
					AND    IC.Mission			= '#URL.Mission#' 
					AND    DateEffective 		=
					
					( SELECT   TOP 1 DateEffective
						FROM   ItemMasterStandardCost
						WHERE  ItemMaster		= '#URL.ItemMaster#' 
						AND    TopicValueCode	= '#TopicValueCode#' 
						AND    Mission			= '#URL.Mission#' 
						AND    CostElement     = IC.CostElement 
						AND    DateEffective   <= '#getPeriod.DateEffective#'
					  ORDER BY DateEffective DESC	
					)
					<cfif url.location neq "999">
					AND Location	= '#url.Location#'	
					<cfelse>
					AND Location = ''
					</cfif>
					
					ORDER BY L.ListOrder, IC.CostOrder
				</cfquery>
					
	
				<cfif StandardCost.recordcount eq 0>
				     <input type="input"  
					  onchange= "ptoken.navigate('RequestDialogFormMatrixScript.cfm?row=#row#&col=0&rows=#list.recordcount#&cols=#dates.recordcount#','ctotal')"
					  class="regularh" style="border:0px;padding-top:2px;text-align:right;width:100%" id="requestPrice_#row#" name="requestPrice_#row#" value="#numberformat(rate,'__,__')#">  	  
				<cfelse>
					<input type="input"  
					  readonly = "yes"
					  class="regularh" style="border:0px;padding-top:2px;text-align:right;width:100%" id="requestPrice_#row#" name="requestPrice_#row#" value="">  	  							  
				</cfif>			   	  
			  
		    </cfif>
			
		   
		   </td>			   
		  
		 </tr>
		 
		 <tr>
		 	<td colspan="#5+col#">		
						   
		 		<cf_securediv bind="url:RequestDialogGetRate.cfm?row=#row#&programcode=#url.programcode#&period=#url.period#&itemmaster=#url.itemmaster#&objectCode=#url.objectCode#&topicvaluecode=#topicvaluecode#&requirementid=#Requirement.requirementid#&location=#url.location#"
				 id="dPrice_#row#" 
				 style="display:none">
			
			</td>
		 </tr>
	
	</cfoutput>
	
</cfif>	