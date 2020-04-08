
<cfset vGoogleClientId = "849273980393-jc7797rdi2asd0nbeieplvmuef29kv7h.apps.googleusercontent.com">

<cfoutput>

    <script src="https://apis.google.com/js/platform.js?onload=initGAuth" async defer></script>
    <meta name="google-signin-client_id" content="#vGoogleClientId#">

    <script>
        function initGAuth() {
            gapi.load('auth2', function() {
                gapi.auth2.init({
                    client_id: '#vGoogleClientId#'
                });
            });
        }

        function googleLogout(callback) {
            var auth2 = gapi.auth2.getAuthInstance();
            auth2.signOut().then(function () {
                callback();
            });
            auth2.disconnect();
        }
    </script>

</cfoutput>