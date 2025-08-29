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
<cf_mobileSearch 
	id="#url.id#"
	mission="#url.mission#"
	modalDetailStyle="min-width:50%; margin-top:5%;"
	filterURL="#session.root#/warehouse/portal/requester/search/searchFilters.cfm"
	listingURL="#session.root#/warehouse/portal/requester/search/searchListing.cfm"
	contentHeaderURL="#session.root#/warehouse/portal/requester/search/elementHeader.cfm"
	contentBodyURL="#session.root#/warehouse/portal/requester/search/elementBody.cfm"
	externalElementURL="#session.root#/Warehouse/Maintenance/Item/RecordEdit.cfm?fmission=&id="
	customScripts="#session.root#/warehouse/portal/requester/search/resources/custom.js"
	customCSS="#session.root#/warehouse/portal/requester/search/resources/custom.css"
	customPrintCSS="#session.root#/warehouse/portal/requester/search/resources/customPrint.css"
	customPrintListCSS="#session.root#/warehouse/portal/requester/search/resources/customPrintList.css">