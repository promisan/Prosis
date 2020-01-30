
<cfoutput>

<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'
	</cfquery>
	
<cfparam name="path" default="#SESSION.root#/Custom/Logon/#Parameter.ApplicationServer#/watermark.png">

<style>
	td.watermark {
		background-image:url('#path#');
		background-position:top center;
		background-repeat:no-repeat;
		width:100%;
		height:100%;
		background-color:transparent;
		padding-top:14px;
	}
</style>

</cfoutput>
		
<cfif url.serviceitem neq "">

	<table cellpadding="0" cellspacing="0" border="0" width="100%" height="80%">
			<tr>				
				<td class="watermark clsPrintContent" valign="top" style="padding-left:20px;padding-right:20px">								
				<cfset url.scope = "clearance">
				<cfinclude template="../../../Application/WorkOrder/ServiceDetails/Charges/ChargesUsageApproval.cfm">			
				</td>
			</tr>
		</table>		

<cfelse>
			  
	  <cfquery name="Parameter" 
		datasource="AppsInit">
			SELECT * 
			FROM   Parameter
			WHERE  HostName = '#CGI.HTTP_HOST#'
	  </cfquery>

	  <cfoutput>
				
		<table cellpadding="0" cellspacing="0" border="0" width="100%" height="80%">
			<tr>				
				<td class="watermark"></td>
			</tr>
		</table>		
		
	  </cfoutput>

</cfif>

