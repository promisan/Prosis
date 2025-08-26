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

<cf_assignid>

<cfparam name="attributes.displayLogo"    default="1">
<cfparam name="attributes.datasource"     default="appsOrganization">
<cfparam name="attributes.disclaimer"     default="Yes">
<cfparam name="attributes.context"        default="">
<cfparam name="attributes.id"             default="#rowguid#">

<div class="footer" style="clear: both; padding-top: 24px; text-align: center; width: 100%;">

    <cfif attributes.disclaimer neq "No">
	
	     <cf_MailDisclaimer disclaimer="#attributes.disclaimer#" datasource="#attributes.datasource#" context="#attributes.context#" id="#attributes.id#">		 
		
	</cfif>
	
    <cfif attributes.displayLogo eq 1>
	
	    <table style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
	    <tr>
	        <td class="content-block" style="font-family: Helvetica, sans-serif; vertical-align: top; padding: 0 15px 24px; font-size: 12px; color: ##999999; text-align: justify;" valign="top" align="center">
	        
			    <!--- Promisan information 
	            <br>
	            <img src="cid:logo-gray" width="126" height="35"><br>
	            <span style="color: ##999999; font-size: 12px; text-align: center;">Powered by <a href="https://www.promisan.com" style="color: ##F7531B; font-size: 12px; font-weight: bold; text-align: center; text-decoration: none;">Promisan</a></span><br>
	            <span style="color: ##777777; font-size: 11px; text-align: center;">
	                <strong>Netherlands</strong> | Vd. Valk Boumanlaan 17, 3446 GE Woerden, The Netherlands | <a href="tel:+31653956277" style="color: ##F7531B; font-size: 11px; font-weight: bold; text-align: center; text-decoration: none;">+31 6 539 56277</a><br>
	                <strong>United States</strong> | 1103 Hickory Way, Weston, Florida 33327 | <a href="tel:+19548269070" style="color: ##F7531B; font-size: 11px; font-weight: bold; text-align: center; text-decoration: none;">+1 954 826 9070</a><br>
	                <strong>Guatemala</strong> | 6th avenue 6-63, zone 10 Sixtino 1 Office 901, Guatemala City, 01010 | <a href="tel:+50222698000" style="color: ##F7531B; font-size: 11px; font-weight: bold; text-align: center; text-decoration: none;">+502 2269-8000</a><br>
	                <a href="mailto:dev@email" style="color: ##F7531B; font-size: 11px; font-weight: bold; text-align: center; text-decoration: none;">dev@email</a><br>
	            </span>
	            --->
	            
	            <img src="cid:logo-gray" width="80" height="25">         
	           
	        </td>
	    </tr>
	    </table>
		
		<cfmailparam file="#SESSION.rootpath#\Images\prosis-logo-gray.png" contentid="logo-gray" disposition="inline"/>
	    <!---	
		<cfmailparam file="#SESSION.root#/Images/prosis-logo-gray.png" contentid="logo-gray" disposition="inline"/>
		--->
		
	 </cfif>
</div>
