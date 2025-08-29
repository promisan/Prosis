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
<cf_screentop jquery="Yes" html="No">

<!--- 10/1/2011 : supports currently the workorder, casefile and asset topic maintenance screen --->
<!--- 11/1/2011 : also for budget requirement --->

<!--- passed from source --->

<cfparam name="attributes.systemmodule"       default="">	
<cfparam name="attributes.alias"              default="">	
<cfparam name="attributes.language"           default="No">	

<cfparam name="attributes.topictable1"        default="">	
<cfparam name="attributes.topictable1name"    default="">	
<cfparam name="attributes.topicfield1"        default="Code">	
<cfparam name="attributes.topicscope1"        default="">	
<cfparam name="attributes.topicscope1table"   default="">	
<cfparam name="attributes.topicscope1field"   default="">	

<cfparam name="attributes.topictable2"        default="">	
<cfparam name="attributes.topictable2name"    default="">	
<cfparam name="attributes.topicfield2"        default="Code">	
<cfparam name="attributes.topicscope2"        default="">	
<cfparam name="attributes.topicscope2table"   default="">	
<cfparam name="attributes.topicscope2field"   default="">	

<cfparam name="attributes.topictable3"        default="">	
<cfparam name="attributes.topictable3name"    default="">	
<cfparam name="attributes.topicfield3"        default="Code">	
<cfparam name="attributes.topicscope3"        default="">	
<cfparam name="attributes.topicscope3table"   default="">	
<cfparam name="attributes.topicscope3field"   default="">	

<cfparam name="attributes.topictable4"        default="">	
<cfparam name="attributes.topictable4name"    default="">	
<cfparam name="attributes.topicfield4"        default="Code">	
<cfparam name="attributes.topicscope4"        default="">	
<cfparam name="attributes.topicscope4table"   default="">	
<cfparam name="attributes.topicscope4field"   default="">	

<cfparam name="attributes.topictable5"        default="">	
<cfparam name="attributes.topictable5name"    default="">	
<cfparam name="attributes.topicfield5"        default="Code">	
<cfparam name="attributes.topicscope5"        default="">	
<cfparam name="attributes.topicscope5table"   default="">	
<cfparam name="attributes.topicscope5field"   default="">	

<cfparam name="attributes.topicscope"         default="">	
<cfparam name="attributes.topicscopetable"    default="">	
<cfparam name="attributes.topicscopefield"    default="">	
<cfparam name="attributes.topicfield"         default="Code">	

<!--- convert so the variable = ulr passed variable --->

<cfparam name="systemmodule"      default="#attributes.systemmodule#">	
<cfparam name="alias"             default="#attributes.alias#">	
<cfparam name="language"          default="#attributes.language#">	

<cfparam name="topictable1"       default="#attributes.topictable1#">	
<cfparam name="topictable1name"   default="#attributes.topictable1name#">	
<cfparam name="topicfield1"       default="#attributes.topicfield1#">	
<cfparam name="topicscope1"       default="#attributes.topicscope1#">	
<cfparam name="topicscope1table"  default="#attributes.topicscope1table#">	
<cfparam name="topicscope1field"  default="#attributes.topicscope1field#">	

<cfparam name="topictable2"       default="#attributes.topictable2#">	
<cfparam name="topictable2name"   default="#attributes.topictable2name#">	
<cfparam name="topicfield2"       default="#attributes.topicfield2#">	
<cfparam name="topicscope2"       default="#attributes.topicscope2#">	
<cfparam name="topicscope2table"  default="#attributes.topicscope2table#">	
<cfparam name="topicscope2field"  default="#attributes.topicscope2field#">	

<cfparam name="topictable3"       default="#attributes.topictable3#">	
<cfparam name="topictable3name"   default="#attributes.topictable3name#">	
<cfparam name="topicfield3"       default="#attributes.topicfield3#">	
<cfparam name="topicscope3"       default="#attributes.topicscope3#">	
<cfparam name="topicscope3table"  default="#attributes.topicscope3table#">	
<cfparam name="topicscope3field"  default="#attributes.topicscope3field#">	

<cfparam name="topictable4"       default="#attributes.topictable4#">	
<cfparam name="topictable4name"   default="#attributes.topictable4name#">	
<cfparam name="topicfield4"       default="#attributes.topicfield4#">	
<cfparam name="topicscope4"       default="#attributes.topicscope4#">	
<cfparam name="topicscope4table"  default="#attributes.topicscope4table#">	
<cfparam name="topicscope4field"  default="#attributes.topicscope4field#">	

<cfparam name="topictable5"       default="#attributes.topictable5#">	
<cfparam name="topictable5name"   default="#attributes.topictable5name#">	
<cfparam name="topicfield5"       default="#attributes.topicfield5#">	
<cfparam name="topicscope5"       default="#attributes.topicscope5#">	
<cfparam name="topicscope5table"  default="#attributes.topicscope5table#">	
<cfparam name="topicscope5field"  default="#attributes.topicscope5field#">	

<cfparam name="topicscope"        default="#attributes.topicscope#">	
<cfparam name="topicscopetable"   default="#attributes.topicscopetable#">	
<cfparam name="topicscopefield"   default="#attributes.topicscopefield#">	
<cfparam name="topicfield"        default="#attributes.topicfield#">	

<!--- topicscope and other will be removed from here--->
<cfset link = "systemmodule=#systemmodule#&alias=#alias#&language=#language#&topicscope=#topicscope#&topicscopetable=#topicscopetable#&topicscopefield=#topicscopefield#&topicfield=#topicfield#">

<cfloop index="lk" from="1" to="5">
	<cfset link = "#link#&topictable#lk#=#evaluate('topictable#lk#')#&topictable#lk#name=#evaluate('topictable#lk#name')#">
	<cfset link = "#link#&topicscope#lk#=#evaluate('topicscope#lk#')#&topicfield#lk#=#evaluate('topicfield#lk#')#&topicscope#lk#table=#evaluate('topicscope#lk#table')#&topicscope#lk#field=#evaluate('topicscope#lk#field')#">
</cfloop>

<cfinclude template="TopicScript.cfm">  

<table width="100%" height="100%">
<tr><td id="topiclist" style="height:100%;padding-right:10px">
    <cf_divscroll>
	<cfinclude template="TopicListingDetail.cfm">
	</cf_divscroll>
</td></tr></table>
