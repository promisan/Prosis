
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes>The changes are done so that If URL mode is empty set to empty as a param statement JG since this screen always expects a mode  </proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	This template is used to load the ajax enabled attachment method of the framework for additional expenses. 
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<table width="94%" height="15%" cellspacing="0" cellpadding="0">
<tr><td>

<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<cfparam name="URL.Mode" default="Inquiry">
<cfparam name="URL.editclaim" default="1">

<cfif getheader.audit_status gte "2" or editclaim eq "0">

	<cf_filelibraryN
	    	DocumentURL="TravelClaim"
			DocumentPath="TravelClaim"
			SubDirectory="Attachment/#GetHeader.ClaimIdauditid#" 
			Filter=""
			Box="att"
			rowheader="No"
			Insert="no"
			Remove="no"
			reload="true">	

<cfelse>

	<cf_filelibraryN
	    	DocumentURL="TravelClaim"
			DocumentPath="TravelClaim"
			SubDirectory="Attachment/#GetHeader.ClaimIdauditid#" 
			Filter=""
			Box="att"
			Insert="yes"
			Remove="yes"
			reload="true">	
		
</cfif>		
</td></tr>
</table>