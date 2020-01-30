
<cfquery name="Parameter" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM Parameter
</cfquery>
	
<cfset Criteria = ''>

<cfoutput>
	<input type="hidden" name="SystemFunctionId" id="SystemFunctionId" value="#url.systemfunctionid#">
	<input type="hidden" name="treeselect"       id="treeselect">
</cfoutput>

<table width="100%" height="99%" border="0" cellspacing="0" cellpadding="0">
 
  <tr><td valign="top">
  
    <cfform>
    <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	 <cfquery name="Class" 
  	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
      SELECT * 
	  FROM Ref_ProgramGroup
	    WHERE  (Period = '#URL.Period#' or Period is null)
		  AND    (Mission = '#URL.Mission#' or Mission is NULL)
		  ORDER BY ListingOrder
	  </cfquery>
		  
	  <tr><td style="padding-top:5px">
	  
	  <select class="regularxl" id="ProgramGroup" style="width:240px"  onChange="updateGroup()">
		  <option value="All" selected><cf_tl id="All groups"></option>
		  <cfoutput query="Class">
		     <option value="#Code#">#Description#</option>
		  </cfoutput>
	  </select>
	  
	  </td></tr>
	  
	  <tr><td height="3"></td></tr>
	  
	  <!--- we show only periods that have been defined as plan period either on the period itself or through the mission
	  period table to be enforced if disabled on the period itself --->

	 <cfquery name="Period" 
       datasource="AppsProgram" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT   R.*, 
	            M.MandateNo, 
			    M.DefaultPeriod
	   FROM     Ref_Period R, 
	            Organization.dbo.Ref_MissionPeriod M
	   WHERE    IncludeListing = 1
	   <!---    added 20/8/2010 --->
	   AND      (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
	   AND      M.Mission  = '#URL.Mission#' 
	   AND      R.Period   = M.Period	   
	   ORDER BY DateEffective  	   
     </cfquery>
	 
	 <cfquery name="Setting" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Ref_ParameterMission
		  WHERE  Mission = '#URL.Mission#' 
	 </cfquery>
	 
	 <cfif Setting.DefaultAllotmentPeriod neq "">
	 
	 	 <cfquery name="Def" 
	       datasource="AppsProgram" 
	       username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
		       SELECT *
			   FROM   Ref_Period R, Organization.dbo.Ref_MissionPeriod M
			   WHERE  IncludeListing = 1
		      <!--- added 20/8/2010 --->
			   AND    (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
			   AND    M.Mission = '#URL.Mission#' 
			   AND    M.Period  = '#Setting.DefaultAllotmentPeriod#'
			   AND    R.Period = M.Period		   
	     </cfquery>
		 
		 <cfif def.recordcount eq "1">
		 
		 	 <cfset man = Def.MandateNo>
			 <cfset per = Def.Period>
		 
		 <cfelse>
		 
			 <cfquery name="Def" 
		       datasource="AppsProgram" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">
		       SELECT   TOP 1 *
			   FROM     Ref_Period R, Organization.dbo.Ref_MissionPeriod M
			   WHERE    IncludeListing = 1
		      <!--- added 20/8/2010 --->
			   AND      (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
			   AND       M.Mission = '#URL.Mission#' 
			   AND       R.Period = M.Period
			   ORDER BY  M.DefaultPeriod DESC
		     </cfquery>
			 	 
			 <cfset man = Def.MandateNo>
			 <cfset per = Def.Period>
		 
		 </cfif>
		 	 
	 <cfelse>
	 	 
		 <cfquery name="Def" 
	       datasource="AppsProgram" 
	       username="#SESSION.login#" 
	       password="#SESSION.dbpw#">
	       SELECT   TOP 1 *
		   FROM     Ref_Period R, Organization.dbo.Ref_MissionPeriod M
		   WHERE    IncludeListing = 1
	       <!--- added 20/8/2010 --->
	       AND      (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
		   AND      M.Mission = '#URL.Mission#' 
		   AND      R.Period  = M.Period
		   ORDER BY M.DefaultPeriod DESC
	     </cfquery>
		 	 
		 <cfset man = Def.MandateNo>
		 <cfset per = Def.Period>
	 	 
	 </cfif>
	 
	 <cfif url.period eq "">
 	 	  <cfset URL.Period = "#per#">
	 </cfif>		
	 		 		  	  
    <tr><td class="line"></td></tr>
	
	<tr><td>
		<table width="99%" cellspacing="0" cellpadding="0" align="center">
				
	    <cfset PNo = 0>
		<cfset row = 0>
	   
	    <cfoutput>
	   	   	<input type="hidden" id="PeriodSelect" value="#url.period#">			
	    </cfoutput>		
	  
	      <cfoutput query = "Period"> 
		  <cfset row = row+1>
		  <cfset PNo = PNo+1>
	          <cfif row eq "1"><tr></cfif>
	          <td id="Period#PNo#">
			    <table cellspacing="0" cellpadding="0">
				<tr><td>
				<input type="radio" style="height:14px;width:14px" id="Period" name="Period" value="#Period#" 
					onClick="Period#PNo#.style.fontWeight='bold';updatePeriod(this.value,'#MandateNo#','#URL.systemfunctionid#')"
					<cfif url.period eq period>Checked</cfif>>
				</td>
				<td class="labelmedium" style="padding-left:4px"><cfif url.period eq period><b></cfif>#Description#
	         		<cfif url.period eq period>
						<cfset per     = "#Period#">
						<input type="hidden" name="MandateNo" id="MandateNo" value="#MandateNo#">
						<cfset man     = "#MandateNo#">						
					</cfif>
				</td>
				</tr>	
				</table>	
			  </td>
		      <cfif row eq "2"></tr><cfset row="0"></cfif>
	    </cfoutput>   
				
		</table>
				
	</td></tr>  		 
  			
	<cfparam name="client.Edition" default="">	
	<cfparam name="URL.Edition" default="#CLIENT.Edition#">
		
	<cfquery name="Period" 
		datasource="AppsProgram"  
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    	SELECT *
			FROM   Ref_Period
			WHERE  Period = '#URL.Period#' 
	</cfquery>	 
  
	<cfquery name="Edition" 
		  datasource="AppsProgram"  
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	
		    SELECT  E.*, 
			        R.Description as VersionName
			FROM    Ref_AllotmentEdition E INNER JOIN 
			        Ref_AllotmentVersion R ON  R.Code = E.Version
				    LEFT OUTER JOIN Ref_Period P ON P.Period = E.Period
			WHERE   E.Mission     = '#URL.Mission#'		
			
			AND     (
			
			         <!--- select the periods to show for allotment entry, which may or may not be the actual execution  --->
					 
			         E.Period IN (
		                    
							SELECT Period 
		                    FROM   Ref_Period 
							
							<!--- expiration date of period lies after the start date of the planning period --->
						    WHERE  DateExpiration  >= '#Period.DateEffective#'
							
							<cfif Period.isPlanningPeriodExpiry neq "">
							<!--- expiration date of period lies before the scope of the planning period --->
							AND    DateExpiration <= '#Period.isPlanningPeriodExpiry#'						
							</cfif>
																		
							<!--- period is NOT a planning period itself 
							Hanno 10/10/2012 : this needs review, better to drop the isPlanning period and
							let is be defined on the dbo.missionperiod level if a period is a plan period.
							The below prevents for example in OICT to show B14-15 to be recorded under
							plan period B12-13, which is not the intention hence it was removed.
							
							
							AND    Period NOT IN (SELECT PP.Period 
							                      FROM   Organization.dbo.Ref_MissionPeriod PP, 
												         Ref_Period RE
												  WHERE  PP.Mission   = '#url.mission#'
												  AND    PP.Period    = Re.Period
												  AND    PP.Period   != '#URL.Period#'
												  AND    Re.IsPlanningPeriod = 1)		
												  
												   --->							
												  
																		  								
							) 
							
													
					OR 
					
					   E.Period is NULL
				    )
				   
			AND     EditionClass  = 'Budget'			
				
			ORDER BY R.ListingOrder, Version, P.DateEffective,E.EditionId,R.Description
	</cfquery>	
		
	<cfparam name="URL.Version" default="#Edition.Version#">	
	
	<cfquery name="Check" 
	datasource="AppsProgram">
       SELECT *
	   FROM   Ref_AllotmentEdition
	   WHERE  EditionId = '#URL.Edition#' 
	   AND    Mission = '#url.mission#'
	</cfquery>	 

	<cfif Check.recordCount eq "0">
	
	   <cfset CLIENT.Edition = "#Edition.EditionId#">
	   <cfset URL.version    = "#Edition.Version#">   
	
	<cfelse>  
		
	   <cfset CLIENT.Edition = "#URL.Edition#"> 
	   <cfset URL.Version    = "#Check.Version#">
	   
	</cfif> 
		
	<tr><td>
			    
	  <table align="center" width="98%" cellspacing="0" cellpadding="0" class="formpadding">
	  	 
		   <tr><td class="line" colspan="3"></td></tr> 	 
			  			  
			  <cfset ver = "">
			  
			  <cfoutput>
				  <input type="hidden" id="edition" value="#url.edition#">
			  </cfoutput>
			  
			  <tr><td height="4"></td></tr>
			  
			  <cfset st = "0">
		  
			  <cfoutput query="Edition">
			  
			  	<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
					Method         = "budget"
					Mission        = "#URL.Mission#"
					Period         = "#URL.Period#"	
					EditionId      = "'#editionID#'"  
					Scope          = "some"
					Role           = "'BudgetManager','BudgetOfficer'"
					ReturnVariable = "ListingAccess">	
										
				<cfif ListingAccess neq "NONE">	  
				
					<cfset st = "1">		
			  
				  	<cfquery name="ExecutionEdition" 
					datasource="AppsProgram">
					    SELECT *
						FROM   Organization.dbo.Ref_MissionPeriod
						WHERE  EditionId = '#editionid#'
						AND    PlanningPeriod = '#URL.Period#'						
					</cfquery>	 
					 
					 <td></td>
					  <cfif ver neq version>
					  <tr><td colspan="2" class="labelit" style="padding-left:5px"><font color="gray">#VersionName#</font></td></tr>				 
					  </cfif>
					  <tr>
				      	   <td width="15" style="padding-left:30px">
						     <cfif executionedition.recordcount eq "0">
							     <img width="9" src="#SESSION.root#/Images/select4.gif" align="absmiddle" alt="" border="0">
							 <cfelse>
							     <img width="9" src="#SESSION.root#/Images/favorite.gif" height="10" width="10" style="cursor:pointer" align="absmiddle" alt="Is the Procurement Budget Edition for #ExecutionEdition.period#" border="0">
							 </cfif>
						   </td>										
							<td class="<cfif url.Edition eq EditionId>labelmediumbold<cfelse>labelit</cfif>" height="19" width="80%" id="viewmode#currentrow#" 
							    style="cursor: pointer;"
								onclick="document.getElementById('edition').value='#EditionId#';view('#currentrow#','#editionid#');">														
								#Description# 							
							</td>
					  </tr>
					  <cfset ver = version>		
				   
				   </cfif> 		 				 
				
			  </cfoutput>
			  
			 			  
		     
		   <tr><td colspan="3" class="line"></td></tr>

	  </table>
	  
	</td></tr>
		
	<cfif st eq "0">
	
		<tr><td align="center" class="labelit"><font color="FF0000"><cf_tl id="No access granted"></td></tr>
	
	<cfelse>
	    		  
	  	  <tr>
	       <td style="padding-top:4px"> 
		   
		    <cftree name="status"
			   font="calibri"
			   fontsize="12"		
			   bold="No"   
			   format="html"    
			   required="No">  		
	
			  <cf_tl id="Allotment" var="1">
			  
			    <cftreeitem value="List"
			        display="<span class='labelmedium'>#lt_text#</span>"			
					parent="status"					
			        expand="Yes">	
							
				 
								 		
				  <cf_tl id="Review and Release" var="1">
				
					  <cftreeitem value="program"
				        display="<span style='color:0080C0' class='labelmedium'><u>#lt_text#</span>"
						href="AllotmentViewOpen.cfm?mode=REQ&ID1=0&ID2=#url.mission#&ID3=#man#&id4="
						target="right"
						parent="List"					
				        expand="Yes">							
						
				 <cf_tl id="Pending Release" var="1">
				
					  <cftreeitem value="pending"
				        display="<span style='color:0080C0' class='labelmedium'><u>#lt_text#</span>"
						href="AllotmentViewOpen.cfm?mode=STA&ID1=0&ID2=#url.mission#&ID3=#man#&id4="
						target="right"
						parent="List"					
				        expand="Yes">		
						
				 <cf_tl id="View Release Transactions" var="1">
				
					  <cftreeitem value="actions"
				        display="<span style='color:0080C0' class='labelmedium'><u>#lt_text#</span>"
						href="../Action/AllotmentActionOpen.cfm?systemfunctionid=#url.systemfunctionid#&mode=ACT&ID1=0&ID2=#url.mission#&ID3=#man#&id4="
						target="right"
						parent="List"					
				        expand="Yes">					
						
						<cftreeitem value="dummy"
			        display=""			
					parent="status"					
			        expand="Yes">			
			  
			 </cftree>
			
			 <cfinvoke component="Service.AccessGlobal"  
			      method="global" 
				  role="AdminProgram" 
				  returnvariable="GlobalAccess">
			
			 <cfinvoke component="Service.Access"
			     Method="Organization"
				 Mission="#URL.Mission#"
				 Role="BudgetOfficer','BudgetManager"
				 ReturnVariable="ManagerAccess">	
							
				<cfset CLIENT.ShowReports = "NO">
					
				<CFIF GlobalAccess neq "NONE" OR ManagerAccess eq "ALL">
								
					<cftree name="idtree" font="calibri"  fontsize="12" bold="No" format="html" required="No">
					     <cftreeitem 
						  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','#man#','AllotmentViewOpen.cfm','PRG','Responsible Unit','#url.mission#','#man#','','Full')">  		 
				    </cftree>						
					
			    <cfelse>
				
					<cftree name="idtree" font="calibri"  fontsize="12" bold="No" format="html" required="No">
					     <cftreeitem 
						  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','#man#','AllotmentViewOpen.cfm','PRG','Operational Structure','#url.mission#','#man#','','Role')">  		 
				    </cftree>	
								
				</cfif>
							
				
				<cfif getAdministrator("*") eq "1">
				
					<cftree name="audit"
						   font="calibri"
						   fontsize="12"		
						   bold="No"   
						   format="html"    
						   required="No">  
						   
						    <cftreeitem value="dummy"
			        		display=""			
							parent=""					
					        expand="Yes">	
					   
					   	 <cf_tl id="Audit" var="1">
						 
					    <cftreeitem value="AuditList"
				        display="<span class='labelmedium'><b>#lt_text#</span>"			
						parent="audit"					
				        expand="Yes">	
									
				        <cf_tl id="Invalid Organization" var="1">
					
						<cftreeitem value="invalidorg"
				        display="#lt_text#"
						href="AllotmentViewOpen.cfm?mode=AOR&ID1=0&ID2=#url.mission#&ID3=#man#&id4="
						target="right"
						parent="AuditList"					
				        expand="Yes">				
			
						<!---					
						<cf_tl id="Cleared" var="1">
						<cftreeitem value="cleared"
				        display="#lt_text#"
						parent="List"	
						target="right"
						href="AllotmentViewOpen.cfm?mode=APR&ID1=1&ID2=#url.mission#&ID3=#man#&id4="				
				        expand="Yes">					
						--->
					
					 </cftree>
				
				</cfif>		
			
		</td>
	    </tr>
     
	    <tr><td class="line"></td></tr>	 
		
		</cfif>
   
    </table>
	</cfform>
	</td>
  </tr>
   
</table>



