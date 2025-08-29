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
<cfparam name="url.opacity" 		default="0">
<cfparam name="attributes.opacity" 	default="#url.opacity#">

<cf_screenTop html="no" jquery="yes">

<cfquery name="Init"
        datasource="AppsInit">
    SELECT *
    FROM   Parameter
    WHERE  HostName = '#cgi.http_host#'
</cfquery>


<cfif Init.TreeAnimationPath neq "">
    <cf_securediv id="divAnimation" bind="url:#session.root#/#Init.TreeAnimationPath#/AnimationWrapper.cfm?opacity=#attributes.opacity#">
<cfelse>
    <cfoutput>
        <div style="width: 100%; height: 100%;">
                <div style="width: 100%; height: 100%; background: url(#SESSION.root#/Images/Modules.jpg); background-size: cover; background-position: right center;">
            <p style="position: absolute; color: ##333333; bottom: 3px; right: 18px; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,'Raleway',sans-serif!important;">Last Update: July 2018</p>
    </div>
    </div>
    </cfoutput>
</cfif>