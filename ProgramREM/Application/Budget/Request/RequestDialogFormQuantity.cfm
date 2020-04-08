  	   
<cfquery name="ItemMaster" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ItemMaster	
		WHERE     Code = '#url.itemmaster#'		
</cfquery>	

<!--- Now determine the period of dates to be shown for new entries and for existing entries aff already recorded
detail --->

<cfif url.requirementid neq "">

	<cfif edition.period eq "">
		<cfset perdates = url.period>
	<cfelse>
		<cfset perdates = Edition.Period>
	</cfif>	

<cfelse>
		   
	<cfquery name="getEdition" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_AllotmentEdition
			WHERE     EditionId      = '#Requirement.Editionid#'				
	</cfquery>	

	<cfif getEdition.period eq "">
		<cfset perdates = url.period>
	<cfelse>
		<cfset perdates = Requirement.Period>
	</cfif>	

</cfif>
 
<cfquery name="LastDate" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    MAX(R.AuditDate) AS Date
	FROM      Ref_Audit R 
	WHERE     Period = '#Edition.period#'		
</cfquery>		

<!--- get the dates to be shown for input --->   	   
<cfquery name="Dates" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    A.*, P.*
		FROM      Ref_Audit A LEFT OUTER JOIN ProgramAllotmentRequestQuantity P ON A.AuditId = P.AuditId 
		     AND  P.RequirementId  = '#url.requirementid#' 	
		WHERE     A.Period = '#perdates#'
		<cfif ItemMaster.BudgetAuditClass neq "">
		AND      (
			         A.AuditId NOT IN (SELECT AuditId FROM Ref_AuditClass) OR
					 A.Auditid IN (SELECT   AuditId 
					               FROM     Ref_AuditClass 
								   WHERE    AuditClass = '#ItemMaster.BudgetAuditClass#')
				 )		
		</cfif>
		
		<!--- we filter for the periods --->
		
		<cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL" or Closure.RequirementStart eq "">
		
			<!--- no filtering --->
		
		<cfelseif entry.requirementid eq "">
		
			<!--- new requirement we only show dates after the last closure date --->		
			AND    (
			       AuditDate >= '#dateformat(Closure.RequirementStart,CLIENT.DateSQL)#' 
			       OR 
			       AuditDate = '#dateformat(LastDate.Date,CLIENT.DateSQL)#'
				   ) 
		<cfelse>	
		
			<cfquery name="CurrentStart" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT    MIN(R.AuditDate) AS Date
				FROM      ProgramAllotmentRequestQuantity P INNER JOIN
	                      Ref_Audit R ON P.AuditId = R.AuditId
				WHERE     P.RequirementId = '#entry.requirementid#'
			</cfquery>		
		
			<cfif CurrentStart.date lt closure.requirementStart>
			
				<!--- edit requirement we only show dates after the current start date --->		
				AND    AuditDate >= '#dateformat(CurrentStart.Date,CLIENT.DateSQL)#'
			
			<cfelse>
			
				AND    (
			       AuditDate >= '#dateformat(Closure.RequirementStart,CLIENT.DateSQL)#' 
			       OR 
			       AuditDate = '#dateformat(LastDate.Date,CLIENT.DateSQL)#'
				   ) 
			
			</cfif>
						
		</cfif>			
		
		ORDER BY  DateYear, AuditDate 
		
</cfquery>	

<cfoutput>

	<cfloop query="Dates">
		
		<cfif DateYear neq Prior>	
				
			<cfif currentrow neq "1"></table></cfif>
			
			<td valign="top">
											
			<table width="100%">
			
			<cfif Object.RequirementMode eq "1">
			    <cfset cols = "5">
			<cfelse>
			    <cfset cols = "3">
			</cfif>
			
			<tr class="line"><td height="20" colspan="#cols#" style="padding-left:4px" class="labellarge">#DateYear#</td></tr>		
						
			<tr height="18" class="labelit">
			  <td style="padding-left:5px;border:1px solid silver;"></td>
			  <td align="center" id="labelqty" style="border:1px solid silver;min-width:90px">
			  <cf_tl id="Quantity">
			  </td>
			  <cfif Object.RequirementMode eq "1">
				  <td align="center" style="border:1px solid silver;"><cf_tl id="Days"></td>
				  <td align="center" style="min-width:60px;border:1px solid silver;"><cf_tl id="Sum"></td>						 
			  </cfif>
			  <td width="50%" align="center" style="padding-right:4px;border:1px solid silver;"><cf_tl id="Memo"></td>
			</tr> 				
						
		</cfif>
								
		<tr class="labelmedium" style="height:17px">
			
		<cfquery name="Label" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_AuditClass 
			WHERE  AuditId = '#AuditId#'
			AND    AuditClass = '#ItemMaster.BudgetAuditClass#'
		</cfquery>
			
		<td style="background-color:ffffcf;padding-left:6px;border:1px solid silver;">
		    <cfif Label.AuditLabel neq "">
				#Label.AuditLabel#
			<cfelseif Description neq "">
				#Description#
			<cfelse>
				<cf_tl id="#MonthAsString(DateMonth)#">:
			</cfif>		
			<cf_space spaces="40">	
		</td>					
			
		<cfif Object.RequirementMode eq "0">
				   
			   <cfif URL.Mode neq "edit" and url.mode neq "add">
			   
				   	<td height="15" align="right">
					
					   <cfif Dates.requestQuantity eq "">
						   --
					   <cfelse>				   
					   	   #Dates.requestQuantity#
					   </cfif>
					   
					</td>  						
					<td width="50">#Dates.Remarks#</td> 
				   
		<cfelse>
				   
			   	<td style="border:1px solid silver">
											
					<cf_tl id="Please enter a quantity" var="1">				
							
					<cfif Dates.requestQuantity eq "0">				
						
					   <input type="Text"
					       name="requestquantity_#currentrow#"
					       value=""
					       class="regularh enterastab"
						   style="text-align:right;width:99%;border:0px"
						   size="8"							   
						   message="#lt_text#">
						   
					<cfelse>
					
					   <input type="Text"
					       name="requestquantity_#currentrow#"
					       value="#Dates.requestQuantity#"
					       class="regularh enterastab"
						   style="text-align:right;;width:99%;border:0px"
						   size="8"							   
						   message="#lt_text#">
						   
					</cfif>	   
					   
			    </td>
				   
			    <td width="80%" style="padding-left:5px;padding-right:5px;border:1px solid silver">
									   
				      <cfinput type="Text"
				       name="remarks_#currentrow#"
				       value="#Dates.remarks#"						      
					   size="50"
					   style="width:100%;border:0px"
					   tabindex="999"
					   maxlength="50"							  					 
				       required="No"      				      
				       class="regularh enterastab">
					   
			    </td>
					   
		</cfif>	 
			   
		</tr>
					   
	   <cfelse>
	   						   
	   	   <cfif URL.Mode neq "edit" and url.mode neq "add">
				   
		      <td align="right" class="labelit" style=";border:1px solid silver">#Dates.ResourceQuantity#</td>
			  <td align="right" class="labelit" style=";border:1px solid silver">#Dates.ResourceDays#</td> 
			  <td align="right" class="labelit" style=";border:1px solid silver">#Dates.requestQuantity#</td>						
			  <td align="right" class="labelit" style="min-width:120px;border:1px solid silver">#Dates.Remarks#</td>
					
		   <cfelse>
		   
		   	   <cf_tl id="Please enter a quantity" var="1">				  
			   
			   <td style=";border:1px solid silver">
			 	
				   <input type = "Text"
				       name        = "resourcequantity_#currentrow#"
				       value       = "#Dates.resourceQuantity#"
				       validate    = "float"
					   size        = "8"
					   style       = "text-align:right;width:99%;border:0px"
					   message     = "#lt_text#"
				       required    = "No"      
					   class       = "regularh enterastab">						   
				   
			   </td>
			  					 
			   <td style="padding-left:1px;border:1px solid silver">			
			   			  
				   <input type   = "Text"
			   		   name      = "resourcedays_#currentrow#"
					   value     = "#Dates.resourcedays#"
				       validate  = "float"
					   size      = "5"
					   style     = "text-align:right;border:0px"
					   message   = "#lt_text#"
				       required  = "No"      				      
				       class     = "regularh enterastab">
					   
			   </td>
	
			   <td style="padding-left:1px;min-width:100px;padding-right:1px;border:1px solid silver">			    
											
					<cfdiv id="quantity_#currentrow#" 
				       bindonload="false"
				       bind="url:RequestQuantityMode1.cfm?mode=sum&line=#currentrow#&resource={resourcequantity_#currentrow#}&day={resourcedays_#currentrow#}">
					   						 				  															  							   
					   <input type = "text" 
					    class      = "regularh enterastab" 
						style      = "text-align:right;width:99%;background-color:f1f1f1;border:0px" 
						size       = "8"						
						readonly 
						id         = "requestquantity_#currentrow#" 
						name       = "requestquantity_#currentrow#" 
						value      = "#Dates.requestQuantity#" 
						tabindex   = "99999">		
						
					</cfdiv>	   
																					   
			   </td>
								   
			   <td width="70%" style="padding-left:3px;padding-right:4px;border:1px solid silver">
			   
			      <cfinput type = "Text"
				       name         = "remarks_#currentrow#"
				       value        = "#Dates.remarks#"	
					   tabindex     = "999"					      
					   style        = "width:100%;border:0px"
					   maxlength    = "50"			 					 
				       required     = "No"      				      
				       class        = "regularh enterastab">
			   
			   </td>
			   
			   </tr>
			 	
		   </cfif>	 
					   
		</cfif>	   
					   
		<cfset prior = dateyear>
		  			
	  </cfloop>
   
  </table>
  
  </td>
  
  </tr>
    
	<input type="hidden" name="AuditIds" value="#quotedvalueList(Dates.Auditid)#">
  
</cfoutput>  

