<cf_compression>

<cfparam name="URL.address" default="">

<cfloop index="mail" list="#url.address#" delimiters=",">

   <cfif not isValid("email","#mail#")> 
      <font color="FF0000">Invalid address : <cfoutput>#mail#</cfoutput></font>
   </cfif>

</cfloop>