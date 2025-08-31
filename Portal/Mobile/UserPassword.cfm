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
<cf_param name="URL.ID" 	  default="change" type="string">

<!--- Parameters for portal enabled password change---->
<cf_param name="URL.portalid" default="" type="string">
<cf_param name="URL.mission"  default="" type="string">


<cfquery name="Parameter"
        datasource="AppsSystem"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
    SELECT  TOP 1 LogonMode
    FROM    Parameter
</cfquery>

<cfif parameter.LogonMode neq "LDAP">

    <cfquery name="Get"
            datasource="AppsSystem"
            username="#SESSION.login#"
            password="#SESSION.dbpw#">
        SELECT   *
        FROM     userNames
        WHERE    account = '#SESSION.acc#'
    </cfquery>

    <cfquery name="Parameter"
            datasource="AppsSystem"
            username="#SESSION.login#"
            password="#SESSION.dbpw#">
        SELECT   *
        FROM     Parameter
    </cfquery>

    <cf_preventCache>


    <CFFORM name="passwordform" onsubmit="return false" method="post">
        <cf_mobileCell class="col-xs-12 col-lg-6">

            <cf_MobilePanel
                    footer = ""
                    bodyClass = "h-200"
                    bodyStyle = "font-size:85%; min-height:500px;"
                    height = "250px"
                    panelClass = "stats hgreen container_categoryGraph_#url.id#">

                <cf_mobilerow>

                    <cf_mobileCell class="col-md-12">
                        <cfoutput>

                            <table width="90%" align="center" cellspacing="0" cellpadding="0">

                            <cfif parameter.LogonMode eq "Mixed">
                                <tr>
                                <td height="20" colspan="3" align="center" bgcolor="ffffff" class="labellarge" style="border: 1px black solid; padding: 5;">

                                    <strong>Attention:&nbsp;</strong>Password change will not impact your network password (LDAP).
                                    <br>It will only have an effect on <cfoutput>#SESSION.welcome#</cfoutput> Password and your ability to logon with this password.</strong>

                            </td>
                            </tr>
                                <tr>
                                    <td colspan="3" bgcolor="white" height="40">
                                    </td>
                                </tr>
                            </cfif>
                            </table>

                            <cfoutput>

<!--- Entry form --->

                                <table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

                                    <tr><td height="5"></td></tr>
                                <TR>
                                <td height="30" class="labelmedium">
                                        <h2 style="font-weight: 200;font-size: 24px;color: ##52565B;">Password Maintenance</h2>
                                    <img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
                                <cf_tl id="Account">: &nbsp;&nbsp;&nbsp;<b><cfoutput>#SESSION.acc# (#SESSION.first# #SESSION.last#)</cfoutput>
                                </td>
                                </tr>

                                    <tr><td height="5"></td></tr>

                                <TR>
                                <td class="labelmedium">
                                        <img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
                                <cf_tl id="TypeOld" class="Message">:
                            </td>
                            </tr>
                                <tr><td height="3"></td></tr>
                            <tr>
                            <td style="padding-left:40px">
                                <cfinput type="Password" name="PasswordOld" size="20" maxlength="20" autocomplete="off">
                                </td>
                                </tr>

                                    <tr><td height="5"></td></tr>

<!--- Field: Password --->
                                <tr>
                                <td class="labelmedium">
                                        <img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
                            <b><cf_tl id="New"></b> <cf_tl id="password"> <cfif Parameter.PasswordMode eq "Basic">(<cfoutput>#Parameter.PasswordTip#</cfoutput>)</cfif>:
                            </td>
                            </tr>

                                <tr><td height="3"></td></tr>
                            <tr>
                            <td style="padding-left:40px">
                            <table>
                            <tr>
                            <td>

                                <cfif Parameter.PasswordMode eq "Basic">


                                    <cfinput type="Password"
                                            name="Password1"
                                            id="Password1"
                                            validateat="onSubmit"
                                            message="#Parameter.PasswordTip#"
                                            validate="regular_expression"
                                            pattern="#Parameter.PasswordBasicPattern#"
                                            required="No"
                                            size="20"
                                            maxlength="20"
                                            autocomplete="off">

                                <cfelse>
                                        <input type="Password"
                                               name="Password1"
                                               id="Password1"
                                               required="No"
                                               size="20"
                                               maxlength="20"
                                               autocomplete="off"
                                               onblur="chkButton();">

                                </cfif>

                                </td>
                                    <td id="pwdstat" style="cursor:pointer" onclick="document.getElementById('pwdbox').className='regular'" style="padding-left:5px"></td>
                                </tr>
                                </table>
                                </td>
                                </tr>

                                    <tr><td height="3"></td></tr>

                                    <tr id="pwdbox" class="hide">
                                        <td colspan="2" class="labelmedium" id="pwdinfo" style="padding-left:35px;height:3px;color:red"></td>
                                    </tr>

<!--- Field: Password --->
                                <tr>
                                <td class="labelmedium">
                                        <img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
                                <Cf_tl id="Confirm"> <b><cf_tl id="new"></b> <cf_tl id="password">:
                            </td>
                            </tr>
                                <tr><td height="3"></td></tr>
                            <tr>
                            <td style="padding-left:40px">
                            <table>
                            <tr>
                            <td>

                                <cfif Parameter.PasswordMode eq "Basic">

                                    <cfinput  type="Password"
                                            id="Password2"
                                            name="Password2"
                                            size="20"
                                            maxlength="20"
                                            autocomplete="off">

                                <cfelse>

                                        <input type="Password"
                                               id="Password2"
                                               name="Password2"
                                               size="20"
                                               maxlength="20"
                                               autocomplete="off"
                                               onblur="chkButton();">

                                </cfif>


                                </td>
                                    <td id="pwdstat_2" style="cursor:pointer; padding-left:5px" onclick="document.getElementById('pwdbox_2').className='regular'"></td>

                                </tr>
                                </table>
                                </td>
                                </tr>

                                    <tr><td height="3"></td></tr>

                                    <tr id="pwdbox_2" class="hide">
                                        <td colspan="2" class="labelmedium" id="pwdinfo_2" style="padding-left:35px;height:3px;color:red">x</td>
                                    </tr>


<!--- Field: Password --->

                                <tr>
                                <td style="padding-left:40px">
                                <cfinput type="hidden" name="eMailAddress" value="#get.eMailAddress#" validate="email" required="Yes" size="20" maxlength="40" message="Please enter a valid eMail address. The current address is incorrect." class="regularxl enterastab">
                                </td>
                                </tr>

                                    <tr><td height="5"></td></tr>

<!--- Field: Password --->
                                <tr>
                                <td class="labelmedium">
                                        <img src="#SESSION.root#/Images/pointer.gif" border="0">&nbsp;
                                <cf_tl id="TypeHint" class="Message">: </td>
                            </tr>
                                <tr><td height="3"></td></tr>
                                <tr>
                                    <td style="padding-left:40px">
                                        <input class="regularxl enterastab" type="Text" name="Hint" id="Hint" size="20" maxlength="50">
                                    </td>
                                </tr>

                                <tr><td height="20"></td></tr>
                                <tr><td height="1" colspan="2" class="line"></td></tr>
                                <tr><td height="15"></td></tr>

                                <cfif Parameter.PasswordMode eq "Basic">

                                        <tr>
                                        <td colspan="2" align="left" style="padding-left:40px">
                                        <cf_tl id="Submit" var="1">
                                        <cfset tSave=#lt_text#>
                                        <input class="button10g" type="button" onclick="formvalidate()" style="height:30;width:140px;display:none" name="Process" id="Process" value="#tSave#">
                                    </td>
                                    </tr>

                                <cfelse>

                                        <tr>
                                        <td colspan="2" align="left" style="padding-left:40px">
                                        <cf_tl id="Submit" var="1">
                                        <cfset tSave=#lt_text#>
                                        <input class="button10g" type="button" onclick="formvalidate()" style="height:30;width:140px;display:none" name="Process" id="Process" value="#tSave#">
                                    </td>
                                    </tr>

                                </cfif>

                                </table>

                            </cfoutput>



                        </cfoutput>
                    </cf_mobileCell>

                </cf_mobilerow>

            </cf_MobilePanel>

        </cf_mobileCell>


    </cfform>

<cfelse>

    <cfoutput>
        <cf_message message = "<b><font color='800000'>Problem, LDAP authentication mode does not allow change in passwords. Please change your password from LDAP authentication console</font></b>"  return = "UserPassword.cfm">
    </cfoutput>

</cfif>


