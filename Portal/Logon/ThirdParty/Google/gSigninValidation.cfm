<cfinclude template="gSigninExists.cfm">

<cfif vGoogleSigninKey neq "">

    <cfinclude template="gScripts.cfm">

    <cfoutput>
        <script>
            function onGoogleSignIn(googleUser) {
                var gTokenId = googleUser.getAuthResponse().id_token;
                //Send to Prosis for validation
                ptoken.navigate('#session.root#/Portal/Logon/ThirdParty/Google/gTokenValidation.cfm?gTokenId='+gTokenId, 'tpAuthVal');
            }
        </script>
    </cfoutput>

</cfif>