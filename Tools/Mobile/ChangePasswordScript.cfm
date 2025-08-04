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
<cfparam name="Attributes.context" default="Desktop">

<cfoutput>

    <script>

    var pchecker = new systempassword();
    pchecker.setSyncMode();

    function chkButton() {

        var p1 = $('##Password1').val();
        var p2 = $('##Password2').val();

        var vreturn   = JSON.parse(pchecker.testPassword(p1,'#SESSION.acc#').replace("//",""));
        var vreturn_2 = JSON.parse(pchecker.testPassword(p2,'#SESSION.acc#').replace("//",""));

        $('##pwdstat').html(vreturn.STATUS);
        $('##pwdinfo').html(vreturn.ERRORMESSAGES);

        $('##pwdstat_2').html(vreturn_2.STATUS);
        $('##pwdinfo_2').html(vreturn_2.ERRORMESSAGES);

        var enable = 0;

        if (vreturn.ISPASSWORDVALID && vreturn_2.ISPASSWORDVALID) {

            var vreturn_3 = JSON.parse(pchecker.compare(p1,p2).replace("//",""));
            if (vreturn_3.ISPASSWORDVALID) {
                enable = 1;
            } else {
                $('##pwdstat_2').html(vreturn_3.STATUS);
                $('##pwdinfo_2').html(vreturn_3.ERRORMESSAGES);
                $('##pwdbox_2').show();
                enable = 0;
            }
            } else {
                enable = 0;
            }

            if (enable==1) {
                $('##Process').show();
                $('##pwdbox').hide();
                $('##pwdbox_2').hide();
            } else {
                $('##Process').hide();

                if (!vreturn.ISPASSWORDVALID) {
                    $('##pwdbox').show();
                }
                if (!vreturn_2.ISPASSWORDVALID)	{
                    $('##pwdbox_2').show();
                }
            }
    }

    function formvalidate() {

        document.passwordform.onsubmit()
        if( _CF_error_messages.length == 0 ) {
            <cfif Attributes.context eq "Desktop">
                 ptoken.navigate('#session.root#/System/UserPasswordSubmit.cfm?portalid=#URL.portalid#&mission=#URL.mission#','dprocess','','','POST','passwordform')
            <cfelse>
                ptoken.navigate('#session.root#/portal/mobile/UserPasswordSubmit.cfm','mainContainer','','','POST','passwordform')
            </cfif>

        }
    }

</script>

</cfoutput>
