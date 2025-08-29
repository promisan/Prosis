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
<cfparam name="url.mid" default="">
<cfparam name="client.sd" default="\\ny-nas-p-share-001.ptc.un.org\novadocs\Document\">

<cfif url.mid neq "">

        <cfinvoke component  = "Service.Process.System.UserController"
                method            = "RecordSessionTemplate"
                SessionNo         = "#client.SessionNo#"
                ActionTemplate    = "#CGI.SCRIPT_NAME#"
                Hash              = "#URL.mid#"
                ActionQueryString = "#CGI.QUERY_STRING#">

<!--- validate access --->

        <cfinvoke component   = "Service.Process.System.UserController"
                method            = "ValidateFunctionAccess"
                SessionNo         = "#client.SessionNo#"
                ActionTemplate    = "#CGI.SCRIPT_NAME#"
                ActionQueryString = "#CGI.QUERY_STRING#">

</cfif>

<cfparam name="Attributes.SourceDirectory" default="#session.sd#">
<cfparam name="Attributes.SourceFileName"  default="#session.sf#">

<cfset Path = Attributes.SourceDirectory & Attributes.SourceFileName />

<cfswitch expression="#LCase(ListLast(Attributes.SourceFileName, "."))#">

    <cfcase value="xml">
        <cfset vContentType = "application/xml" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="avi">
        <cfset vContentType = "video/x-msvideo" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="gif">
        <cfset vContentType = "image/gif" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="jpg,jpeg">
        <cfset vContentType = "image/jpg" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="mp3">
        <cfset vContentType = "audio/mpeg" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="mov">
        <cfset vContentType = "video/quicktime" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="mpe,mpg,mpeg">
        <cfset vContentType = "video/mpeg" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="pdf">
        <cfset vContentType = "application/pdf" />
        <cfset vDestination = "inline">
    </cfcase>

    <cfcase value="png">
        <cfset vContentType = "image/png" />
        <cfset vDestination = "inline">
    </cfcase>

    <cfcase value="ppt">
        <cfset vContentType = "application/vnd.ms-powerpoint" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="wav">
        <cfset vContentType = "audio/x-wav" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="xls">
        <cfset vContentType = "application/vnd.ms-excel" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="xlsx">
        <cfset vContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="doc,docx">
        <cfset vContentType = "application/msword" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfcase value="zip">
        <cfset vContentType = "application/zip" />
        <cfset vDestination = "attachment">
    </cfcase>

    <cfdefaultcase>
        <cfset vContentType = "application/unknown" />
        <cfset vDestination = "attachment">
    </cfdefaultcase>

</cfswitch>

<!--- change so all files will be rendered as an attachment --->

<cftry>

    <cfheader name="Content-disposition"  value="#vDestination#; filename=#Replace(Replace(Attributes.SourceFileName, " ",  "_", "all"),",","","ALL")#" />
    <cfheader name="Content-length" value="#getFileInfo(Path).size#" />

    <cfcontent type="#vContentType#" file="#Path#"/>

    <cfcatch>

        <cfset m = Message()>

    </cfcatch>
</cftry>

<cffunction name="Message">

    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr><td align="center" height="40" class="labelmedium">
    <cf_tl id="This document link has expired. Go to the original document and click on it again"  class="Message">
    </td>
    </tr>
    </table>
    <cfabort>

</cffunction>