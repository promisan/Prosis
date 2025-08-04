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

<!--- launch template menu --->
<cfparam name="URL.ID1"	default="">

<cf_NavigationLeftmenu
	Alias        = "AppsSelection"
	Section      = "#URL.Section#"
	SectionTable = "Ref_ApplicantSection"
	TableName    = "ApplicantSubmission"
	Object       = "Applicant"
	Objectid     = "No"
	Group        = "#url.triggergroup#"
	PersonNo     = "#client.PersonNo#"
	Owner        = "#url.owner#"
	Mission      = "#url.mission#"
	ID           = "#URL.id#"
	ID1          = "#URL.id1#"
	IconWidth    = "48"
	IconHeight   = "48">
 


 
