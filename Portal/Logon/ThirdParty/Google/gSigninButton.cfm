<cfinclude template="gSigninExists.cfm">

<cfif vGoogleSigninKey neq "">

    <style>
        .g-signin2 { padding-top:10px; }
        .abcRioButtonIcon { width:auto; }
    </style>

    <div class="g-signin2" data-onsuccess="onGoogleSignIn" data-longtitle="true"></div>

</cfif>