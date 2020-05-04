
<cfparam name="URL.header"            default="1">   
<cfparam name="URL.idmenu"            default="">   
<cfparam name="URL.submissionedition" default="Generic">   
<cfparam name="URL.Next"              default="Default">
<cfparam name="URL.ID"                default="">

<cfif url.id eq "">
	<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes" menuAccess="Yes" systemfunctionid="#url.idmenu#">
<cfelse>
    <cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes" menuAccess="No" systemfunctionid="#url.idmenu#">
</cfif>	

<cf_systemscript>

<cfoutput>

<script language="JavaScript">   
  function purgecandidate(id) {     
    if (confirm("Do you want to revoke this candidate ?")) {	
	 ptoken.location("ApplicantEntry.cfm?remove="+id+"&submissionedition=#url.submissionedition#")
	}	
	return false	  
   
  } 
   function newcandidate(id) {       
    ptoken.location("ApplicantEntry.cfm?submissionedition=#url.submissionedition#")
  } 
  
</script>

</cfoutput>

<cfajaximport tags="cfdiv">

<cfoutput>
<table width="96%" border="0" align="center">
	
	<cfif url.header eq "1">
		
		<tr>
			<td width="5%"></td>
		
			<td height="80" valign="middle" align="left" width="98%" style="top; padding-left:10px">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">
					<tr>
						<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(#SESSION.root#/images/logos/BGV2.png); background-repeat:no-repeat">
						</td>
					</tr>			
					<tr>
				<td style="z-index:5; position:absolute; top:23px; left:40px; ">
					<img src="#SESSION.root#/images/logos/no-picture-male.png" alt="" width="52" height="52" border="0">
				</td>
			</tr>
					<tr>
						<td style="z-index:3; position:absolute; top:25px; left:100px; color:##45617d; font-family:calibri; font-size:25px; font-weight:bold;">
							<cf_tl id="Register a Candidate">
						</td>
					</tr>
					<tr>
						<td style="position:absolute; top:5px; left:100px; color:##e9f4ff; font-family:calibri; font-size:45px; font-weight:bold; z-index:2">
							<cf_tl id="Register Candidate">
						</td>
					</tr>
					
					<tr>
						<td style="position:absolute; top:50px; left:110px; color:##45617d; font-family:calibri; font-size:12px; font-weight:bold; z-index:4">
							Register Candidate and Submission edition
						</td>
					</tr>
					
				</table>
			</td>
		</tr>
	
	</cfif>
		
	<!--- entry screen for the buckets --->
	
	<tr>
	<td width="95%" align="center">
	
	    <cfset url.scope     = "entry">
		<cfset url.id1       = url.submissionedition>
		<cfset url.source    = url.source>
		<cfinclude template  ="../Functions/ApplicantFunctionEntry.cfm">
		
	</td>
	</tr>

</table>

</cfoutput>

