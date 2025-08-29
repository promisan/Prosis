<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
