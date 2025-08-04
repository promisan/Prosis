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

<cfparam name="Attributes.Name" default="">
<cfparam name="Attributes.Value" default="">

<cfoutput>

<select name="#Attributes.Name#" id="#Attributes.Name#">

	<option value="IndexNo" <cfif "IndexNo" eq "#Attributes.Value#">selected</cfif>>IndexNo</option>
	<option value="Grade" <cfif "Grade" eq "#Attributes.Value#">selected</cfif>>Grade</option>
	<option value="BirthDate" <cfif "BirthDate" eq "#Attributes.Value#">selected</cfif>>Date of Birth [DDMMYYYY]</option>
	<option value="Travel Request" <cfif "Travel Request" eq "#Attributes.Value#">selected</cfif>>Recent travel request No</option>
	
</select>	

</cfoutput>