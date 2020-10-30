  
<cfparam name="Attributes.Language"    default="">
<cfparam name="Attributes.Context"     default="">
<cfparam name="Attributes.Id"          default="">
<cfparam name="Attributes.Disclaimer"  default="Yes">

<cfif trim(Attributes.Language) eq "" AND isDefined("client.languageid")>
	<cfset Attributes.Language = client.languageid>
</cfif>

<cfoutput>

	<cfquery name="user" 
		datasource="appsSystem">
			SELECT   *
		    FROM     UserNames
			WHERE    Account = '#session.acc#' 
	</cfquery>
	
	<cfset missionlogo = "">
	
	<cfif user.PersonNo neq "">
	
		<cfquery name="Function" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT      P.FunctionDescription, O.OrgUnitName, O.Mission, M.MissionName
			FROM        PersonAssignment AS PA INNER JOIN
		                Position AS P ON PA.PositionNo = P.PositionNo INNER JOIN
		                Organization.dbo.Organization AS O ON PA.OrgUnit = O.OrgUnit inner join
						Organization.dbo.Ref_Mission M ON O.Mission = M.Mission
			WHERE       PA.PersonNo = '#user.PersonNo#' 
			AND         PA.Incumbency > 0 
			AND         PA.AssignmentStatus IN ('0','1')
			ORDER BY    PA.DateEffective DESC
		</cfquery>	
		
		<cfif Function.Mission neq "">
		
			<cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Mission
				WHERE  Mission = '#Function.Mission#'
			</cfquery>
			
			<cfset missionlogo = Mission.MissionPathLogo>						
		
		</cfif>
		
	</cfif>		
	
	<table width="100%">
		
		<cfif user.Pref_Signature eq "1" and attributes.disclaimer eq "Yes">
		
			<tr><td style="padding-left:5px">#user.Pref_SignatureBlock#</td></tr>			
			<tr><td style="height:20px"></td></tr>	
			
			<cfif missionlogo neq "">		
			   <tr><td style="height:20px"><img src="cid:logomission"></td></tr>			 		
				<cfmailparam file="#SESSION.root#/#missionlogo#" contentid="logomission" disposition="inline"/>																				
			</cfif>
			
		</cfif>
			
		<tr>
		<td style="border-top:1px solid silver; border-bottom:1px solid silver;">
		
			 <cfif attributes.language eq "ENG">
			 <font color="808080" style="font-size:10px">
				 This message, including any attachments, contains confidential information intended for a specific individual and purpose, and is protected by law. If you are not the intended recipient, please contact the sender immediately by reply e-mail and destroy all copies. You are hereby notified that any disclosure, copying, or distribution of this message, or the taking of any action based on it, is strictly prohibited.
			 </font>
			 <cfelseif attributes.language eq "NED">
			   <font color="808080" style="font-size:10px">
				 De informatie die via dit bericht wordt verspreid is strikt vertrouwelijk en mag niet meegedeeld worden aan derde partijen zonder voorafgaandelijk toestemming van de afzender
			 </font>
			 <cfelseif attributes.language eq "ESP">
			   <font color="808080" style="font-size:10px">
				 Éste mensaje, incluyendo cualquier adjunto, contiene información confidencial intencionada a un individuo y propósito específico, y está protegido por ley.  Si usted no es el destinatario, por favor contacte al remitente inmediatamente respondiendo éste correo electrónico y destruyendo todas las copias.  Está por lo tanto notificado que cualquier revelación, copia, o distribución de este mensaje, o tomar acción con base en el mismo, está estrictamente prohibido.
			 </font>
			 <cfelse> 
			  <font color="808080" style="font-size:10px">
				 This message, including any attachments, contains confidential information intended for a specific individual and purpose, and is protected by law. If you are not the intended recipient, please contact the sender immediately by reply e-mail and destroy all copies. You are hereby notified that any disclosure, copying, or distribution of this message, or the taking of any action based on it, is strictly prohibited.
			 </font>
			 </cfif>
		 
		 </td>
		</tr>
		
		<tr><td><font style="font-size:10px" color="808080"><cf_tl id="Authentication">: #attributes.context# #attributes.id#</font></td></tr>		
		<tr><td height="1" style="border-bottom:1px solid silver"></td></tr>
		
	</table>

</cfoutput>

		