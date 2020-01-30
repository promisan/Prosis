
<cfparam name="URL.address" default="">

<cfloop index="mail" list="#url.address#" delimiters=",">

   <cfif not isValid("email","#mail#")> 
      <font color="FF0000"><cfoutput>Invalid:#mail#</cfoutput></font>
   </cfif>

</cfloop>

<cf_compression>