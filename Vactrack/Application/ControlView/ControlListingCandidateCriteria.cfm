<!--- pending : limit on select mission, status document --->


<cfparam name="URL.EntityCode" default = "">

<cfoutput>

<cfform name="fCriteria" id="fCriteria" method="POST" onsubmit= "return false">

<table width="95%" class="formpadding" align="center">

	<cfif URL.Status eq "0" or URL.Status eq "9">
	<tr class="fixlengthlist">
	
		<td style="width:100px;height:30" class="labelmedium"><cf_tl id="Track type">:</td>
		<td>
		
		 <cfquery name="DocTpe" 
						datasource="AppsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
					    SELECT   *
						FROM     Ref_DocumentType
						ORDER BY ListingOrder						
	                  </cfquery>		
					  
				<cf_UISelect name   = "DocumentType"
					     class          = "regularxl"
					     queryposition  = "below"
					     query          = "#doctpe#"
					     value          = "Code"											     											     
					     display        = "Description"											    
						 separator      = ","
					     multiple       = "yes"/>				
				
		</td>			
		
		<td>&nbsp;</td>
		
		<td style="width:100px;height:30" class="labelmedium"><cf_tl id="Entiry">:</td>
		<td>
		
		<!--- default manadate, likely this does not change between mandates --->
		
		<cfquery name="Mandate"
			datasource="AppsOrganization"
			maxrows=1
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT    *
			FROM     Ref_Mandate
			WHERE    Mission = '#url.mission#'
			ORDER BY MandateDefault DESC, MandateNo DESC
		</cfquery>	
		
		<cfquery name="Level01"
			datasource="AppsOrganization"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Organization O
				WHERE  (O.ParentOrgUnit is NULL OR O.ParentOrgUnit = '')
				AND    O.Mission = '#url.mission#'							
				AND    O.MandateNo = '#Mandate.MandateNo#'
				ORDER BY TreeOrder, OrgUnitName
		</cfquery>		
				
		<cf_UISelect name   = "ParentCode"
			     class          = "regularxl"
		         queryposition  = "below"
				 query          = "#level01#"
				 style          = "width:80%"
				 value          = "HierarchyCode"											     											     
				 display        = "OrgUnitNameShort"											    
				 separator      = ","
				 multiple       = "yes"/>	
		
		</td>
        
		
	</tr>		

	<cfelse>
	
		<input type="hidden" name = "EntityCode" value = "">
		<input type="hidden" name = "EntityClass" value = "">
		
	</cfif>
	
	<tr class="fixlengthlist">
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
			                            FROM   (#preservesingleQuotes(Session.SelectTracks)#) as T										
									  )		
		</cfquery>
		
		<cf_UISelect name   = "Fund"
		     class          = "regularxl"
		     queryposition  = "below"
		     query          = "#getFund#"
		     value          = "Fund"											     											     
		     display        = "Fund"											    
			 separator      = ","
		     multiple       = "yes"/>		  
							
				
		</td>
		<td width="2%"></td>
		
		<td class="labelmedium"><cf_tl id="Grade"></td>
		
		<td>

		<cfquery name = "GetGrade" 
		  datasource = "AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
				SELECT P.PostGrade FROM 
					   Employee.dbo.Ref_PostGrade P 
				WHERE  EXISTS (
							SELECT 'X'
							FROM (#preservesingleQuotes(Session.SelectTracks)#) as T
							WHERE T.PostGrade = P.PostGrade
							<cfif URL.EntityCode neq "" AND  (URL.Status eq "0" or URL.Status eq "9")>
								AND EntityCode = '#URL.EntityCode#'
							</cfif>
						 )	
				ORDER BY P.PostOrderBudget	
		</cfquery>		
		
		<cf_UISelect name   = "PostGrade"
		     class          = "regularxl"
		     queryposition  = "below"
		     query          = "#getGrade#"
		     value          = "PostGrade"											     											     
		     display        = "PostGrade"											    
			 separator      = ","
		     multiple       = "yes"/>		
				
		</td>					
		
		<!---
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
				WHERE  C.EntityClass IN (SELECT EntityClass FROM (#preservesingleQuotes(Session.SelectTracks)#) as D)	   					  
		</cfquery>		
	
		<select name = "EntityClass" class="regularxxl">
			<option value=""><cf_tl id="Any"></option>		
		<cfloop query = "GetClass">
			<option value="#GetClass.EntityClass#">#GetClass.EntityClassName#</option>		
		</cfloop>
		</select>
		</td>	
		--->
	
	</tr>
	
	<tr class="fixlengthlist">
	
	    <!---
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
		--->
		
		<input type="hidden" name="FunctionNo">
		
		<!---
		
		<td class="labelmedium"><cf_tl id="Grade"></td>
		
		<td>

		<cfquery name = "GetGrade" 
		  datasource = "AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
				SELECT P.PostGrade FROM 
					   Employee.dbo.Ref_PostGrade P 
				WHERE  EXISTS (
							SELECT 'X'
							FROM (#preservesingleQuotes(Session.SelectTracks)#) as T
							WHERE T.PostGrade = P.PostGrade
							<cfif URL.EntityCode neq "" AND  (URL.Status eq "0" or URL.Status eq "9")>
								AND EntityCode = '#URL.EntityCode#'
							</cfif>
						 )	
				ORDER BY P.PostOrderBudget	
		</cfquery>		
		
		<cf_UISelect name   = "PostGrade"
		     class          = "regularxl"
		     queryposition  = "below"
		     query          = "#getGrade#"
		     value          = "PostGrade"											     											     
		     display        = "PostGrade"											    
			 separator      = ","
		     multiple       = "yes"/>		
				
		</td>							
		
		--->
		
		<td></td>		
		<td class="labelmedium hide"><cf_tl id="Posted">:</td>
		
		<td class="hide">
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
			<td style="min-width:40px" class="labelmedium"><cf_tl id="To">:
			</td>
			<td style="min-width:140px">
			   
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
				
	<tr class="fixlengthlist hide">
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
		<td colspan="5" align="left">			
			<input type="button" name="Save" value="Filter" class="button10g" style="font-size:15px;width:260px" onclick="do_search()">
		</td>
	</tr>
			
</table>
	
</cfform>

</cfoutput>

<script>
	Prosis.busy('no')
</script>	

<cfset ajaxonload("doCalendar")>
