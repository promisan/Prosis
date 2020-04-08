
<!--- we show the most applicable source --->

<cfparam name="Attributes.PersonNo" default="">
<cfparam name="Attributes.Selected" default="">
<cfparam name="Attributes.ShowAll"  default="No">
<cfparam name="Attributes.Label"    default="Profile source">

<cfquery name="getSource" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   Source
		FROM     ApplicantSubmission S
		WHERE    PersonNo = '#Attributes.PersonNo#'	
		<cfif Attributes.showAll eq "No">					
		AND     ( ApplicantNo IN (SELECT ApplicantNo 
		                          FROM   ApplicantBackground 
								  WHERE  ApplicantNo = S.ApplicantNo)
				OR 						 
				
				ApplicantNo IN  (SELECT ApplicantNo 
		                         FROM   ApplicantLanguage 
								 WHERE  ApplicantNo = S.ApplicantNo)
								 
				)				 
		</cfif>									 
		ORDER BY Created DESC
	</cfquery>
				
	<cfquery name="getUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     UserNames
		WHERE    Account = '#session.acc#'				
	</cfquery>
								
	<cfif getUser.accountOwner neq "">
		
		<cfquery name="getOwner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_ParameterOwner
			WHERE    Owner = '#getUser.accountOwner#'					
		</cfquery>
										
		<cfset src = getOwner.DefaultPHPSource>
		
		<cfif not find(src,valueList(getSource.source))>
		    <cfset src = getSource.Source>
		</cfif>
	
	<cfelse>
		
		<!--- check the one for which we have background --->
		
		<cfquery name="getBackground" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 Source
			FROM     ApplicantSubmission S
			WHERE    PersonNo = '#URL.ID#'							
			AND      ApplicantNo IN (SELECT ApplicantNo 
			                         FROM   ApplicantBackground 
									 WHERE  ApplicantNo = S.ApplicantNo)								 
									 
			ORDER BY Created DESC
		</cfquery>
				
		<cfif getBackground.recordcount eq "0">
		
			<cfquery name="getBackground" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 Source
				FROM     ApplicantSubmission S
				WHERE    PersonNo = '#URL.ID#'																 
				ORDER BY Created DESC
			</cfquery>
							
		</cfif>
		
		<cfset src = getBackground.source>
			
	</cfif>
			
	<!--- wildcard if we can not define a default --->
	
	<cfif src eq "">
				
		<cfif getSource.recordcount gte "1">	
			<cfset src = getSource.source>				
		<cfelse>	
			<cfset src = client.submission>						
		</cfif>			
		
	</cfif>	
	
	<!--- set the forced overrulling default --->
			
	<cfif attributes.selected neq "">
		<cfset src = attributes.selected>
	</cfif>
		
	<cfoutput>	
	
	<cfif getSource.recordcount gt "1">
			
		<cfif attributes.label neq "">
		<table>
			<tr>			
			<td valign="top" class="labelmedium" style="padding-top:12px;height:50px;padding-left:10px;padding-right:6px">#attributes.label#:</td>			
			<td style="padding-left:4px">
			<select name="source" id="source" class="regularxl" style="font-size:20px;height:35px">
			<cfloop query="getSource">
				<option value="#Source#" <cfif source eq src>selected</cfif>>#Source#</option>
			</cfloop>
			</select>
			</td>
			</tr>
		</table>
		
		<cfelse>
		
		<select name="source" id="source" class="regularx">
			<cfloop query="getSource">
				<option value="#Source#" <cfif source eq src>selected</cfif>>#Source#</option>
			</cfloop>
		</select>
		
		</cfif>
				
	<cfelseif getsource.recordcount eq "1">
	
		<input type="hidden" id="source" name="source" value="#src#">	
	
	<cfelse>
	
		<input type="hidden" id="source" name="source" value="#src#">	
	
	</cfif>
		
	</cfoutput>		
	
	
<cfset url.source = src>


