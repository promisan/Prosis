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

<HTML><HEAD>
    <TITLE>Operational reports</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">
   
<cfset CLIENT.width = 1100>
<cfset CLIENT.height = 940>
   
<cfinclude template="PublicInit.cfm">

<cfset heading   = "Operational reports">
<cfset module    = "'#URL.Module#'">
<cfset selection = "'#URL.Selection#'">
<cfset class     = "'Main'">

<cfinclude template="../MenuReport/SubmenuReport.cfm">

</BODY></HTML>