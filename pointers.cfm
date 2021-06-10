<cfobject type="java" class="java.lang.System" name="system" action="CREATE">

<cfset property = system.getProperty("user.home")>

<cfoutput>

    User home location: #property#

</cfoutput>