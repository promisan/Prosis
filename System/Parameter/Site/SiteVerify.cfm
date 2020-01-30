
<cfoutput>
   <cfif DirectoryExists("#url.id#")>
	    <img style="cursor:pointer" src="#SESSION.root#/Images/check_mark2.gif" alt="Valid Location" border="0">
   <cfelse>
	    <img style="cursor:pointer" src="#SESSION.root#/Images/warning.gif" alt="Directory does not exists or is not accessible" border="0">
   </cfif>
</cfoutput>   	  