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
<cfparam name="url.output" 				default="1">
<cfparam name="url.contributions" 		default="1">
<cfparam name="url.deductions" 		default="1">
<cfparam name="url.currency" 			default="USD">
<cfparam name="url.sign" 				default="">


<!--- pass true to generate the document --->

<cfreport template     = "Report.cfr" 
		  format       = "PDF" 
		  overwrite    = "yes" 
		  encryption   = "none">
			<cfreportparam name="personno" 			value="#url.personno#"> 
			<cfreportparam name="year" 				value="#url.year#"> 
			<cfreportparam name="mission" 			value="#url.mission#"> 
			<cfreportparam name="contributions" 	value="#url.contributions#"> 
			<cfreportparam name="deductions" 	    value="#url.deductions#"> 
			<cfreportparam name="miscellaneous" 	value="#url.miscellaneous#"> 
			<cfreportparam name="currency" 			value="#url.currency#"> 
			<cfreportparam name="sign" 				value="#url.sign#">
</cfreport>	

