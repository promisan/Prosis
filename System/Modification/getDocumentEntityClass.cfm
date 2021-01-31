<!--- select relevant workflows --->

<cfparam name="url.scope" default="">
<cfparam name="url.owner" default="">
<cfparam name="url.application" default="">

	<cfquery name="Class" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT R.*
		FROM     Ref_EntityClassPublish P, Ref_EntityClass R
		WHERE    R.EntityCode = '#url.entitycode#'
		AND      P.EntityCode = R.EntityCode
		AND      P.EntityClass = R.EntityClass
		AND      R.Operational = 1
		
		AND     
	         (
			 
	         R.EntityClass IN (SELECT EntityClass 
	                           FROM   Ref_EntityClassOwner 
							   WHERE  EntityCode = '#url.entitycode#'
							   AND    EntityClass = R.EntityClass
							   AND    EntityClassOwner = 
							   		<cfif url.owner neq "">
										'#url.owner#'
									<cfelse>
							   		( SELECT Owner FROM System.dbo.Ref_Application WHERE Code = '#url.application#') 
									</cfif>
							   )
							   
			 OR
			
			  R.EntityClass NOT IN (SELECT EntityClass 
	                           FROM   Ref_EntityClassOwner 
							   WHERE  EntityCode = '#url.entitycode#'
							   AND    EntityClass = R.EntityClass)
							   
			 )			
			
	</cfquery>

	
	
	<cfif Class.recordcount gte "1">
			
			<cfif Class.recordcount eq 1 >
				<tr>
	    			<td colspan="6">	
						<cfoutput>
							<input type="hidden" name="#url.scope#EntityClass" id="#url.scope#EntityClass" value="#Class.EntityClass#">
						</cfoutput>
					</td>
				</tr>
			<cfelse>
			
				<cfoutput>
					<tr>
						
	    				<td colspan="5">	
						    <select name="#url.scope#EntityClass" id="#url.scope#EntityClass" class="regularxxl enterastab">
						    <cfloop query="Class">
								<option value="#EntityClass#">#EntityClassName#</option>
							</cfloop>
						    </select>
					
						</td>
					</tr>
				</cfoutput>
			
			</cfif>
		
		
		
	<cfelse>	
		
		<tr>
			
	 				<td colspan="5">	
			   <table><tr><td class="labelmedium2">		
					<font color="FF0000">Workflow not configured</font>		
				</td></tr></table>
		
			</td>
		</tr>

	</cfif>	
	
	