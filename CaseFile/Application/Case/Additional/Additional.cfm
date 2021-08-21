<cfoutput>
<cfparam name="url.objectId" default="">

<cfif url.ObjectId neq "">

<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td height="10"></td></tr>
	<tr><td><b>   <cf_tl id="Additional information"></b></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td>
	
	<cf_ObjectHeaderFields 
	     entityId   = "#url.objectId#"
		 filter     = ""  <!--- not operational yet, but can be used to limit the fileds here --->
		 mode       = "'header','step'"
		 entityCode = "ClmNoticas"
		 caller     = "#SESSION.root#/CaseFile/Application/Claim/Additional/Additional.cfm?ObjectId=#Url.ObjectId#">
		 
	</td>	 
	</tr>
</table>

</cfif>

</cfoutput>

