
<cfparam name="Attributes.Language"  default="">
<cfparam name="Attributes.Context"   default="">
<cfparam name="Attributes.Id"        default="">
<cfparam name="Attributes.Declaimer" default="">

<cfif trim(Attributes.Language) eq "" AND isDefined("client.languageid")>
	<cfset Attributes.Language = client.languageid>
</cfif>

<cfoutput>

	<table width="100%">
			
		<tr>
		<td align="center" style="border-top:1px solid silver; border-bottom:1px solid silver;">
		
		 <cfif attributes.language eq "ENG">
		 <font size="1" color="808080">
			 This message, including any attachments, contains confidential information intended for a specific individual and purpose, and is protected by law. If you are not the intended recipient, please contact the sender immediately by reply e-mail and destroy all copies. You are hereby notified that any disclosure, copying, or distribution of this message, or the taking of any action based on it, is strictly prohibited.
		 </font>
		 <cfelseif attributes.language eq "NED">
		  <font size="1" color="808080">
			 De informatie die via dit bericht wordt verspreid is strikt vertrouwelijk en mag niet meegedeeld worden aan derde partijen zonder voorafgaandelijk toestemming van de afzender
		 </font>
		 <cfelseif attributes.language eq "ESP">
		  <font size="1" color="808080">
			 Éste mensaje, incluyendo cualquier adjunto, contiene información confidencial intencionada a un individuo y propósito específico, y está protegido por ley.  Si usted no es el destinatario, por favor contacte al remitente inmediatamente respondiendo éste correo electrónico y destruyendo todas las copias.  Está por lo tanto notificado que cualquier revelación, copia, o distribución de este mensaje, o tomar acción con base en el mismo, está estrictamente prohibido.
		 </font>
		 <cfelse> 
		  <font size="1" color="808080">
			 This message, including any attachments, contains confidential information intended for a specific individual and purpose, and is protected by law. If you are not the intended recipient, please contact the sender immediately by reply e-mail and destroy all copies. You are hereby notified that any disclosure, copying, or distribution of this message, or the taking of any action based on it, is strictly prohibited.
		 </font>
		 </cfif>
		 
		 </td>
		</tr>
		
		<tr><td align="center">
		   <font size="1" color="808080"><cf_tl id="Authentication">: #attributes.context# #attributes.id#</font>				   
		    </td>
		</tr>
		
		<tr><td height="1" style="border-bottom:1px solid silver"></td></tr>
		
	</table>

</cfoutput>

		