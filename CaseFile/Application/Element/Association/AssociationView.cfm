
<!--- container which shows both parents and children for this element --->

<cfparam name="url.elementid" default="">
<cfparam name="url.forclaimid" default="">

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td height="3"></td></tr>

<tr class="line">
	<td class="line">
		
		<table width="99%" align="center" cellspacing="0" cellpadding="0">				
		<tr><td>
		<cfset key = url.elementid>
		<cfinclude template="../Create/ElementView.cfm">
		</td>
		</tr>		
		</table>
			
	</td>
</tr>	

<tr><td height="3"></td></tr>

<!--- routine to show all relationsships also in the reverse --->
	
<tr>
	<td id="children">	
	
	<cfif url.forclaimid eq "">	
		
		<cfquery name="CaseElement" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT   *
		     FROM     ClaimElement			
			 WHERE    CaseElementId = '#url.caseelementid#'	
		</cfquery>
		
		<cfset url.forclaimid = caseelement.claimid>
	
	</cfif>	
	
	<cfinclude template="AssociationListing.cfm">		
	
	</td>
</tr>	
	
</table>
