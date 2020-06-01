<cfquery name="qSigninExists" datasource="AppsSystem">
    SELECT *
    FROM   Parameter.dbo.Parameter
    WHERE  HostName = '#cgi.HTTP_HOST#'
</cfquery>

<cfset vGoogleSigninKey = "">

<cfif qSigninExists.recordCount eq 1>
    <cfset vGoogleSigninKey = trim(qSigninExists.GoogleSigninKey)>
</cfif>