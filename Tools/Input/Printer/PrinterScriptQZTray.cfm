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
<cfparam name="attributes.printer" default=""> 
<cfparam name="attributes.jquery" default="Yes">
 
<cfif attributes.jquery eq "Yes">
	<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/jQuery/jquery.js"></script>
</cfif>	

<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print/js/dependencies/rsvp-3.1.0.min.js?23"></script>
<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print/js/dependencies/sha-256.min.js?23"></script>
<script type="text/javascript" src="<cfoutput>#SESSION.root#</cfoutput>/Scripts/qz-print/js/qz-tray.js?23"></script>


<script type="text/javascript">

	var root = '<cfoutput>#SESSION.root#</cfoutput>';
	
    function displayError(err) {
        console.error(err);
    }

</script>

