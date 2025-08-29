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
<cfquery name="Delete" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ClaimEventTrip 
	WHERE ClaimEventId = '#URL.ClaimEventId#'
	AND ClaimTripStop = '#URL.Stop#'
</cfquery>

<cflocation url="ClaimEventEntry.cfm?section=#url.section#&leg=0&Status=Edit&claimId=#URL.claimId#&ID1=#URL.ID1#&Topic=#URL.Topic#" addtoken="No">
