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
<cfquery name="tpUser" datasource="AppsSystem">
    SELECT *
    FROM   UserNames
    WHERE  AccountNo = '#url.accountno#'
</cfquery>

<cf_tl id="The user has not been registered yet.  Please create a new account using this email address:" var="msgNotRegistered">
<cf_tl id="The associated account has been disabled.  Please contact your system administrator." var="msgDisabled">

<cfif tpUser.recordCount eq 0>

    <!--- Create account on first login --->

    <cfoutput>
        <script>
            googleLogout(function(){
				alert('#msgNotRegistered# #url.accountno#');
			});
        </script>
    </cfoutput>

<cfelse>

    <cfif tpUser.disabled eq 1>

        <cfoutput>
            <script>
                googleLogout(function(){
                    alert('#msgDisabled#');
                });
            </script>
        </cfoutput>

    <cfelse>

        <!--- Authenticate in Prosis and redirect to landing page --->
        <cfset form.account = tpUser.account>
        <cfset form.password = tpUser.password>
        <cfif Len(tpUser.password) gt 25>
            <cf_decrypt text = "#tpUser.password#">
            <cfset form.password = Decrypted>
        </cfif>
        
        <cfinclude template="../../Authent.cfm">

        <cfif session.authent eq 1>
            <cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
            <cfset mid = oSecurity.gethash()/> 
            <cfoutput>
                <script>
                    window.location = '#session.root#/Portal/MainMenuView.cfm?id=main&mid=#mid#';
                </script>
            </cfoutput>
        </cfif>

    </cfif>

</cfif>