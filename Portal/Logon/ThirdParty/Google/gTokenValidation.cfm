<cfinclude template="gSigninExists.cfm">

<cfif vGoogleSigninKey neq "">

    <cf_tl id="Email address not verified, please verify it in Gmail and try again." var="msgEmailNotVerified">

    <cfoutput>
        <script>
            function doGoogleTokenValidation() {
                $.get("https://oauth2.googleapis.com/tokeninfo?id_token=#url.gTokenId#", function(data) {
                    doProsisValidation(data);
                });
            }

            function doProsisValidation(user) {
                if (user.email_verified) {
                    ptoken.navigate('#session.root#/Portal/Logon/ThirdParty/ProsisAuth.cfm?accountno='+user.email, 'tpAuthVal');
                } else {
                    googleLogout(function(){
                        alert('#msgEmailNotVerified#');
                    });
                }
            }

            doGoogleTokenValidation();
        </script>
    </cfoutput>

</cfif>
