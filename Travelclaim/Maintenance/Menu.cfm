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
<cf_submenutop>

<cf_submenuLogo module="TravelClaim" selection="Maintenance">

<cfsilent>

<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes>Laster update installed</proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template is part of the application framework and defines the menu to be presented to the user accessing the maintenance section of the Module travel Claim
</td></tr>
</table>
</proInfo>

</cfsilent>

<cfset heading = "Travel Claim Maintenance">
<cfset module = "'TravelClaim'">
<cfset selection = "'Maintain'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/submenu.cfm">

<cfset heading = "Lookup reference">
<cfset module = "'TravelClaim'">
<cfset selection = "'Reference'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/submenu.cfm">

