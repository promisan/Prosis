<!--- pending : limit on select mission, status document --->

 
<cfinclude template="ControlGetTrack.cfm">

<cfparam name="URL.EntityCode" default = "">

<cfoutput>

 

<cfform name="fCriteria" id="fCriteria" method="POST" onsubmit = "return false">

<table width="95%" class="formpadding" align="center">

	<cfif URL.Status eq "0" or URL.Status eq "9">
	<tr>
	
		<td style="height:30" class="labelmedium"><cf_tl id="Track type">:</td>
		<td>
		
		 <cfquery name="DocTpe" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
					    SELECT   *
						FROM     Ref_DocumentType
						ORDER BY ListingOrder						
	                  </cfquery>		
							
				<select name="DocumentType" required="Yes" class="regularxl">
				    <option value=""><cf_tl id="All"></option>
				    <cfloop query="DocTpe">
						<option value="#Code#">#Description#</option>
					</cfloop>
			    </select>	
				
		</td>			
		
		<td>&nbsp;</td>
		
		<td style="height:30" class="labelmedium"><cf_tl id="Workflow">:</td>
		<td>
		
			<cfquery name = "GetEntity" 
			    datasource = "AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	DISTINCT E.EntityCode, E.EntityDescription
				FROM    Ref_Entity E 
						INNER JOIN Ref_EntityClass C ON E.EntityCode = C.EntityCode
						INNER JOIN Ref_EntityClassOwner RCO ON RCO.EntityCode = E.EntityCode 
												
				AND 	RCO.EntityClass = C.EntityClass 
				WHERE 	E.EntityCode IN ('VacDocument','VacCandidate')		
					  
				AND 	( RCO.EntityClassOwner IS NULL 
				      		OR
				      	  RCO.EntityClassOwner IN (
								SELECT MissionOwner
								FROM   Ref_Mission
								WHERE  Mission = '#URL.Mission#' 
    					)
				)
			</cfquery>
			
		

			<select name = "EntityCode" class="regularxl" 
			    onchange = "do_restrict(this.options[this.selectedIndex].value)">
				<cfif GetEntity.recordcount neq 1>
					<option value=""><cf_tl id="Any"></option>
				<cfelse>
					<cfset URL.EntityCode = GetEntity.EntityCode > 			
				</cfif>	
				<cfloop query = "GetEntity">
					<option value= "#GetEntity.EntityCode#" <cfif url.EntityCode eq GetEntity.EntityCode>selected</cfif>>#GetEntity.EntityDescription#</option>		
				</cfloop>
			</select>

		</td>
        
		
	</tr>		

	<cfelse>
	
		<input type="hidden" name = "EntityCode" value = "">
		<input type="hidden" name = "EntityClass" value = "">
		
	</cfif>
	
	<tr>
	<td style="height:30" class="labelmedium"><cf_tl id="Fund">:</td>
		<td>
		
		<cfquery name = "GetFund" 
		      datasource = "AppsVacancy" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  
			  SELECT DISTINCT PP.Fund
			  FROM   DocumentPost AS DP INNER JOIN
                     Employee.dbo.Position AS P ON DP.PositionNo = P.PositionNo INNER JOIN
                     Employee.dbo.PositionParent AS PP ON P.PositionParentId = PP.PositionParentId
			  WHERE DP.DocumentNo IN (  SELECT DocumentNo
			                            FROM   (#preservesingleQuotes(SelectTracks)#) as T										
									  )		
		</cfquery>
		
	
		
		<select name = "Fund" class="regularxxl">
			<option value = ""><cf_tl id="Any"></option>		
			<cfloop query = "GetFund">
				<option value = "#Fund#">#Fund#</option>
			</cfloop>	
		</select>
		
		</td>
		<td width="2%"></td>
		
		<td class="labelmedium"><cf_tl id="Class"></td>
		<td>
				
		<cfquery name="GetClass" 
		   datasource = "AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">		
				SELECT C.EntityClass,
					   C.EntityClassName
				FROM   Ref_Entity E
				       INNER JOIN Ref_EntityClass C ON E.EntityCode = C.EntityCode	
				WHERE  C.EntityClass IN (SELECT EntityClass FROM (#preservesingleQuotes(SelectTracks)#) as D)	   					  
		</cfquery>
		
	
		<select name = "EntityClass" class="regularxxl">
			<option value=""><cf_tl id="Any"></option>		
		<cfloop query = "GetClass">
			<option value="#GetClass.EntityClass#">#GetClass.EntityClassName#</option>		
		</cfloop>
		</select>
		</td>
		
			
	
	</tr>
	
	<tr>
		<td style="height:30" class="labelmedium"><cf_tl id="Functional title">:</td>
		<td>
		
		<cfquery name = "GetFunction" 
		      datasource = "AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			SELECT DISTINCT FunctionNo, FunctionalTitle as FunctionDescription 
			FROM   (#preservesingleQuotes(SelectTracks)#) as T
			<cfif URL.EntityCode neq "" AND  (URL.Status eq "0" or URL.Status eq "9")>
			WHERE	EntityCode = '#URL.EntityCode#'
			</cfif>
		</cfquery>

		<select name = "FunctionNo" class="regularxxl">
			<option value  = ""><cf_tl id="Any"></option>		
			<cfloop query = "GetFunction">
				<option value = "#GetFunction.FunctionNo#">#GetFunction.FunctionDescription#</option>
			</cfloop>	
		</select>
		
		</td>
		<td width="2%"></td>
		<td width="10%" class="labelmedium"><cf_tl id="Grade"></td>
		
		<td>

		<cfquery name = "GetGrade" 
		  datasource = "AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
				SELECT P.PostGrade FROM 
					   Employee.dbo.Ref_PostGrade P 
				WHERE  EXISTS (
							SELECT 'X'
							FROM (#preservesingleQuotes(SelectTracks)#) as T
							WHERE T.PostGrade = P.PostGrade
							<cfif URL.EntityCode neq "" AND  (URL.Status eq "0" or URL.Status eq "9")>
								AND EntityCode = '#URL.EntityCode#'
							</cfif>
						 )	
				ORDER BY P.PostOrderBudget	
		</cfquery>		

		<select name= "PostGrade" class="regularxxl">
			<option value  = ""></option>		
			<cfloop query = "GetGrade">
				<option value = "#GetGrade.PostGrade#">#GetGrade.PostGrade#</option>
			</cfloop>	
		</select>
		
		</td>							
		<td>
		</td>
		
	</tr>	
				
	<tr>
		<td style="height:30" class="labelmedium"><cf_tl id="Position No">:</td>
		<td>
		<input type="text" name="PositionNo" size="10" maxlength="10" class="regularxxl">
		</td>
		<td>&nbsp;</td>
		<td class="labelmedium">
		<cf_tl id="Reference">:
		</td>
		<td>
		<input type="text" name="ReferenceNo" size="10" maxlength="10" class="regularxxl">
		</td>					
	</tr>

	<tr>
		<td style="height:30" class="labelmedium"><cf_tl id="Effective">:</td>
		<td colspan="3">
		<table cellspacing="0" cellpadding="0">
		<tr>
		<td style="min-width:140px">
		
			<cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Manual="True"	
				class="regularxxl"				
				Default=""
				AllowBlank="True">	

		</td>		
		<td style="min-width:70px" class="labelmedium"><cf_tl id="Expiry">:
		</td>
		<td style="min-width:150px">
		    <cf_space spaces="40">
			<cf_intelliCalendarDate9
				FieldName="DateExpiration" 
				Manual="True"	
				class="regularxxl"				
				Default=""
				AllowBlank="True">	
		</td>	
		</table>
		</td>
						
	</tr>
	
	<tr><td height="4"></td></tr>
	<tr><td colspan="5" class="linedotted"></td></tr>	
	<tr><td height="4"></td></tr>
	
	<tr>
		<td colspan="5" align="center">			
			<input type="button" name="Save" value="Filter" class="button10g" style="font-size:13px;width:200px" onclick="do_search()">
		</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	<tr><td colspan="5" class="linedotted"></td></tr>	
	<tr><td height="4"></td></tr>
	
</table>
	
</cfform>

</cfoutput>

<script>
	Prosis.busy('no')
</script>	

<cfset ajaxonload("doCalendar")>
