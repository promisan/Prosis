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
<cfparam name="attributes.id"					default="">
<cfparam name="attributes.title"				default="">
<cfparam name="attributes.showCollapse"			default="1">
<cfparam name="attributes.showClose"			default="0">
<cfparam name="attributes.addContainer"			default="1">
<cfparam name="attributes.footer"				default="">
<cfparam name="attributes.footerClass"			default="">
<cfparam name="attributes.animation"			default="zoomIn">
<cfparam name="attributes.animationDelay"		default="0.1s">

<cfparam name="attributes.panelStyle"			default="">
<cfparam name="attributes.panelClass"			default="">
<cfparam name="attributes.panelHeadingClass"	default="hbuilt">
<cfparam name="attributes.panelHeadingStyle"	default="">
<cfparam name="attributes.bodyClass"			default="">
<cfparam name="attributes.bodyStyle"			default="">

<cfif thisTag.ExecutionMode is "start">
	<cfoutput>
		<cfif trim(lcase(attributes.addContainer)) eq "1" or trim(lcase(attributes.addContainer)) eq "yes">
		<div class="animate-panel" id="#attributes.id#">
			<div class="animated-panel #attributes.animation#" style="animation-delay:#attributes.animationDelay#;">
		</cfif>
				<div class="hpanel #attributes.panelClass#" style="#attributes.panelStyle#">
					<cfif trim(attributes.title) neq "">
						<div class="panel-heading showhide #attributes.panelHeadingClass#" style="cursor:pointer; #attributes.panelHeadingStyle#">
							<div class="panel-tools">
							<cfif trim(lcase(attributes.showCollapse)) eq "1" or trim(lcase(attributes.showCollapse)) eq "yes">
								<a class=""><i class="fa fa-chevron-up"></i></a>
							</cfif>
							<cfif trim(lcase(attributes.showClose)) eq "1" or trim(lcase(attributes.showClose)) eq "yes">
								<a class="closebox"><i class="fa fa-times"></i></a>
							</cfif>
							</div>
							#attributes.title#
						</div>
					</cfif>
					<div class="panel-body #attributes.bodyClass#" style="#attributes.bodyStyle#">
	</cfoutput>
<cfelse>
	<cfoutput>
					</div>
					<cfif trim(attributes.footer) neq "">
						<div class="panel-footer #attributes.footerClass#">
							#trim(attributes.footer)#
						</div>
					</cfif>
				</div>
		<cfif trim(lcase(attributes.addContainer)) eq "1" or trim(lcase(attributes.addContainer)) eq "yes">
			</div>
		</div>
		</cfif>
	</cfoutput>
</cfif>	
