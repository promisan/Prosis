<!--
    Copyright © 2025 Promisan

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

    <cfoutput>

        <script src="https://apis.google.com/js/platform.js?onload=initGAuth" async defer></script>
        <meta name="google-signin-client_id" content="#vGoogleSigninKey#">

        <script>
            function initGAuth() {
                gapi.load('auth2', function() {
                    gapi.auth2.init({
                        client_id: '#vGoogleSigninKey#'
                    });
                });
            }

            function googleLogout(callback) {
                try {
                    var auth2 = gapi.auth2.getAuthInstance();
                    auth2.signOut().then(function() {
                        callback();
                    }).error(function() {
                        console.log('Google signin error.  Please check your configurations.');
                        callback();
                    });
                    auth2.disconnect();
                } catch(e) {
                    console.log('Google signin error.  Please check your configurations.');
                    callback();
                }
            }
        </script>

    </cfoutput>

</cfif>