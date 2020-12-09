
<cf_tl id="Within scope" var="1">
<cfset vInBudget=#lt_text#>

<cf_tl id="Outside scope" var="1">
<cfset vOutBudget=#lt_text#>

<cf_tl id="Total Overall" var="1">
<cfset vOverAll=#lt_text#>

<cf_tl id="Available" var="1">
<cfset vAvailable=#lt_text#>
	
<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_AllotmentEdition
		  WHERE  EditionId    = '#URL.EditionId#'		
</cfquery> 

<cfquery name="Snapshot" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_Snapshot
		  WHERE  EditionId    = '#URL.EditionId#'		
		  AND    Period       = '#url.period#'
		  ORDER BY SnapshotDate DESC
</cfquery> 

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Edition.Mission#'
</cfquery>

<cfif Snapshot.recordcount eq "0">

	<tr><td style="background-color:ffffcf" colspan="3" align="center" class="labelmedium"><cf_tl id="No snapshots available"> </td></tr>
	
</cfif>

<cfloop query="Snapshot">
	
	<cfoutput>
	
	<tr><td style="border:0px solid silver;padding:1px"  class="labelit">
	
		<table width="100%">
		
		<tr class="labelit line" style="border-top:1px solid silver">
			<td bgcolor="A6D2FF" style="min-width:80px;padding-left:5px;border-right:1px solid silver"><cf_tl id="Snapshot">:</td>
			<td colspan="2" align="center" style="padding-left:4px">#dateformat(snapshotdate,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
		</tr>
		
		</cfoutput>
		
		<tr><td valign="top">
			
		<cfif Parameter.BudgetCeiling eq "Resource">	
				
				<cfquery name="Resource" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				      SELECT  R.Resource, S.Name,
					  	      	(SELECT sum(Amount) 
								  	FROM ProgramAllotmentCeiling  
								    WHERE  ProgramCode IN (#preservesinglequotes(programselect)#)
									AND    Period       = '#URL.Period#'
								    AND    EditionId    = '#URL.EditionId#' 
									AND Resource = R.Resource) as Ceiling,						
							  SUM(RequestAmountBase) as Amount
					  FROM    ProgramAllotmentRequestSnapshot A 
					          INNER JOIN Ref_Object O                   ON A.ObjectCode = O.Code 
							  INNER JOIN Ref_ParameterMissionResource R ON R.Mission = '#edition.Mission#' AND O.Resource = R.Resource
							  INNER JOIN Ref_Resource S ON R.Resource = S.Code
					  WHERE   A.ProgramCode IN (#preservesinglequotes(programselect)#)
					  AND     A.Period          = '#URL.Period#'
					  AND     A.EditionId       = '#URL.EditionId#'	
					  AND     A.SnapShotBatchId = '#snapshotbatchid#'		
					  AND     A.ActionStatus   = '1' 									   						  						  		  		
					  AND    R.Ceiling = 1		  				
					 GROUP BY  R.Resource, S.Name, S.ListingOrder
					 ORDER BY S.ListingOrder		
					 		 							  
				</cfquery> 
						
				<cfoutput query="Resource">
				
				    <cfif amount gt ceiling>
					<tr class="labelit line" bgcolor="FFD6C1" style="height:15px">	
					<cfelse>
					<tr class="labelit line" bgcolor="ffffef" style="height:15px">
					</cfif>		    
					<td style="padding-left:10px">#Name#</td>
					<td align="right" style="min-width:60;padding-right:3px">#numberformat(Ceiling,"__,__")#</td>
					<td align="right" style="min-width:60;padding-right:3px">#numberformat(Amount,"__,__")#
				    </tr>		
								   
				</cfoutput>			
						
				<cfquery name="Total" dbtype="query">
					  SELECT  sum(Ceiling) as Ceiling,
					          sum(Amount) as Amount  
					  FROM	  Resource
			    </cfquery> 
				
				<cfoutput>
							
				<cfif Total.amount gt Total.ceiling>
					<tr class="labelit line" bgcolor="FFD6C1">	
				<cfelse>
					<tr class="labelit line" bgcolor="ffffef">
				</cfif>		    
					<td style="padding-left:10px">#vInBudget#</td>
					<td align="right" style="padding-right:3px">#numberformat(Total.Ceiling,"__,__")#</td>
					<td align="right" style="padding-right:3px">#numberformat(Total.Amount,"__,__")#
				</tr>		
				
				</cfoutput>
							
				<!--- ceiling disabled we call this extra budget --->
			
				<cfquery name="Resource" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				      SELECT  R.Resource, S.Name, sum(RequestAmountBase) as Amount
					  FROM    ProgramAllotmentRequestSnapShot A INNER JOIN
		                      Ref_Object O ON A.ObjectCode = O.Code INNER JOIN
		                      Ref_ParameterMissionResource R ON O.Resource = R.Resource INNER JOIN
							  Ref_Resource S ON R.Resource = S.Code
							  AND   A.ProgramCode IN (#preservesinglequotes(programselect)#)
							  AND   A.Period       = '#URL.Period#'
							  AND   A.EditionId    = '#URL.EditionId#'							  
							  AND   A.SnapShotBatchId = '#snapshotbatchid#'	
							  AND    A.ActionStatus = '1' 
					   WHERE  R.Mission = '#edition.Mission#'				
					   AND    R.Ceiling = 0		 
					   				
					 GROUP BY R.Resource, S.Name, S.ListingOrder
					 ORDER BY S.ListingOrder					 							  
				</cfquery> 
				
				<cfoutput query="Resource">
				    <tr class="labelit line">	
					<td style="padding-left:10px">#Name#</td>
					<td align="right" style=";padding-right:3px"></td>
					<td align="right" style="padding-right:3px">#numberformat(Amount,"__,__")#</td>
				    </tr>					   
				</cfoutput>	
						
				<cfquery name="Total" dbtype="query">
					  SELECT  sum(Amount) as Amount  
					  FROM	  Resource
			    </cfquery> 
				
				<cfif total.recordcount gte "1">
						
				<cfoutput>
						    
					<tr style="background-color:ffffcf" class="labelit">			    
					<td style="padding-left:10px">#vOutBudget#</td>
					<td align="right"></td>
					<td align="right" style="padding-right:3px">#numberformat(Total.Amount,"__,__")#</td>
				    </tr>		
											   
				</cfoutput>	
				
				</cfif>
			
		<cfelse>
		
		    <!--- -------------------------------- --->
			<!--- program roll-up for all ceilings --->
			<!--- -------------------------------- --->	
			
			<cfquery name="InBudget" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Ref_ParameterMissionResource
				 WHERE    Mission = '#edition.Mission#'				
				 AND      Ceiling = 1		  
			</cfquery>	  
				
			<cfset res =  QuotedValueList(InBudget.Resource)> 
										
			<cfquery name="Ceiling" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				  SELECT sum(Amount) as Amount
				  FROM   ProgramAllotmentCeiling
				  WHERE  ProgramCode IN (#preservesinglequotes(programselect)#)
				  AND    Period       = '#URL.Period#'
				  AND    EditionId    = '#URL.EditionId#'
				  AND    Resource IN (#preservesinglequotes(res)#)			 
			</cfquery> 
			
			<!--- check requested for ceiling sources --->
			
			<cfquery name="Requested" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				  SELECT sum(RequestAmountBase) as Amount
				  FROM   ProgramAllotmentRequestSnapshot
				  WHERE  ProgramCode IN (#preservesinglequotes(programselect)#)
				  AND    Period       = '#URL.Period#'
				  AND    EditionId    = '#URL.EditionId#'	
				  AND    SnapShotBatchId = '#snapshotbatchid#'	
				  AND    ActionStatus = '1' 				  
				  AND    ObjectCode IN (SELECT  Code  
				                        FROM    Ref_Object
									    WHERE   Resource IN (#preservesinglequotes(res)#)	
									   )  
			</cfquery> 
				
			<cfif Ceiling.amount lt Requested.amount and Ceiling.amount gt "0">
			  <cfset hd = "FFD5D5">
			  <cfset cl = "FFD6C1">
			<cfelse>
			  <cfset hd = "ffffff">
			  <cfset cl = "E3FBE8">
			</cfif>  	
			
			<cfoutput>
				   
				<!--- check requested for ceiling sources --->
				
				<cfquery name="Resource" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   O.Resource, 
					         S.Name, 
							 SUM(A.RequestAmountBase) AS Amount
					FROM     ProgramAllotmentRequestSnapshot A INNER JOIN
		                     Ref_Object O ON A.ObjectCode = O.Code INNER JOIN
		                     Ref_Resource S ON S.Code = O.Resource
					WHERE    A.ProgramCode IN (#preservesinglequotes(programselect)#)
					AND	     A.Period      = '#URL.Period#'
					AND      A.EditionId   = '#URL.EditionId#'		
					AND      A.SnapShotBatchId = '#snapshotbatchid#'	
					AND      A.ActionStatus = '1' 					  
					AND      S.Code IN (#preservesinglequotes(res)#)			 			
					GROUP BY O.Resource, S.Name,S.ListingOrder
					ORDER BY S.ListingOrder					 							  
			   </cfquery> 
			   				   
			   <cfloop query="Resource">
				    <tr class="labelit line" bgcolor="#cl#">	
					<td style="padding-left: 8px">#Name#</td>
					<td colspan="2" align="right" style="padding-right:10px">#numberformat(Amount,",__")#
				    </tr>					   
			   </cfloop>	
			   
			   <cfquery name="Total" dbtype="query">
					  SELECT  sum(Amount) as Amount  
					  FROM	  Resource
			    </cfquery> 
					
			   <!--- total regular budget --->		
			 
			   <tr class="labelit" bgcolor="#cl#">	
				  <td style="padding-left:10px">#vInBudget#</td>
				  <td colspan="2" align="right" style="padding-right:6px"><b>#numberformat(total.amount,",__")#</b>
			   </tr>	   
			  		
			   <!--- check requested for Extra budget --->
			   		
			   <cfquery name="Resource" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT    O.Resource, 
					          S.Name, 
							  SUM(A.RequestAmountBase) AS Amount
					FROM      ProgramAllotmentRequestSnapshot A INNER JOIN
		                      Ref_Object O ON A.ObjectCode = O.Code INNER JOIN
		                      Ref_Resource S ON S.Code = O.Resource
					WHERE     A.ProgramCode IN (#preservesinglequotes(programselect)#)
					AND	      A.Period      = '#URL.Period#'
					AND       A.EditionId   = '#URL.EditionId#'		
					AND       A.SnapShotBatchId = '#snapshotbatchid#'	
					AND       A.ActionStatus = '1' 			  
					AND       S.Code NOT IN (#preservesinglequotes(res)#)			 			
					GROUP BY  O.Resource, S.Name,S.ListingOrder
					ORDER BY  S.ListingOrder					 							  
				</cfquery> 				
						   
				<cfloop query="Resource">
				    <tr class="labelit" bgcolor="ffffef">	
					<td style="padding-left:10px"><cf_space spaces="36">#Resource#</td>
					<td colspan="2" align="right" style="padding-right:4px"><cf_space spaces="25">#numberformat(Amount,"__,__")#
				    </tr>					   
				</cfloop>	
				
				<cfquery name="Total" dbtype="query">
					SELECT  SUM(amount) as Amount
					FROM    Resource
				</cfquery> 
						
			    <tr class="labelit" bgcolor="ffffcf">	
				<td style="padding-left:10px">#vOutBudget#</td>
				<td colspan="2" align="right" style="padding-right:4px"><b>#numberformat(Total.amount,"__,__")#
			    </tr>	
						
				<cfquery name="Overall" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  SELECT sum(RequestAmountBase) as Amount
					  FROM   ProgramAllotmentRequestSnapshot
					  WHERE  ProgramCode IN (#preservesinglequotes(programselect)#)
					  AND    Period       = '#URL.Period#'
					  AND    EditionId    = '#URL.EditionId#'	
					  AND    ActionStatus = '1' 
					  AND    SnapShotBatchId = '#snapshotbatchid#'	
				</cfquery> 		 		   	 	
				
			    <tr class="labelit line" bgcolor="#hd#">	
				<td style="padding-left:10px">#vOverall#</td>
				<td colspan="2" align="right" style="padding-right:6px"><b>#numberformat(Overall.amount,"__,__")#
			    </tr>	
										
				<cfif ceiling.amount neq "" and Requested.amount neq "">
				<tr class="labelit" bgcolor="#hd#"><td  style="padding-left:10px">#vAvailable#</td>
				<td colspan="2" align="right" style="padding-right:6px"><b>#numberformat(Ceiling.amount-Requested.amount,"__,__")#
				</td>
				</tr>			
				</cfif>
			
			</cfoutput>	
			
		</cfif>	
		
		</table>
	
	</td></tr>
	
</cfloop>

		