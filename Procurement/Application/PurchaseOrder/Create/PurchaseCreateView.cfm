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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfparam name="url.jobno"    default="">
<cfparam name="url.actionId" default="">
<cfparam name="url.header"   default="no">
<cfparam name="url.mid"      default="">

<cfoutput>
	
	<cf_tl id="Record Obligation" var="vRecord">
	<cf_tl id="Select lines to be included in the obligation for the selected contractor" var="vSelectMessage">
		   
	<table width="100%" height="100%">
		<tr>		
			<td valign="top">
									
				<iframe src="#SESSION.root#/Procurement/Application/PurchaseOrder/Create/PurchaseCreate.cfm?Header=no&ActionId=#URL.actionId#&Jobno=#url.jobno#&Mission=#URL.Mission#&mid=#url.mid#"
			        name="right"
			        id="right"
			        width="100%"
			        height="99%"
					scrolling="no"
			        frameborder="0"></iframe>
					
			</td>
		</tr>
	</table>
	
</cfoutput>

